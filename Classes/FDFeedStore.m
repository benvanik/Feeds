//
//  FDFeedStore.m
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDFeedStore.h"
#import "FDFeedStore+Implementation.h"
#import "FDFeedInfo+Implementation.h"
#import "FDFeed+Implementation.h"
#import "FDFeedUpdateAction.h"
#import "FDFeedStoreDelegate.h"
#import "FDCRC32.h"
#import <libkern/OSAtomic.h>

#define kDefaultSimultaneousUpdates 2

volatile FDFeedStore*   __fd_singletonStore = nil;
volatile int            __fd_singletonLock = 0;

@implementation FDFeedStore

@synthesize customNamespaces;
@synthesize removeMissingEntries;
@synthesize cachePath;
@synthesize simultaneousUpdates;

#pragma mark -
#pragma mark Initialization

- (id) init
{
    if( self = [super init] )
    {
        dataLock = [[NSLock alloc] init];
        queueLock = [[NSLock alloc] init];

        NSFileManager* fileManager = [[NSFileManager alloc] init];
        NSString* userCachePath = [NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES ) objectAtIndex:0];
        if( [fileManager fileExistsAtPath:userCachePath] == NO )
            [fileManager createDirectoryAtPath:userCachePath attributes:nil];
        cachePath = [[userCachePath stringByAppendingPathComponent:@"Feeds"] retain];
        if( [fileManager fileExistsAtPath:cachePath] == NO )
            [fileManager createDirectoryAtPath:cachePath attributes:nil];
        [fileManager release];
        
        customNamespaces = nil;
        feeds = [[NSMutableDictionary alloc] init];
        actionCount = 0;
        processingUpdates = [[NSMutableArray alloc] init];
        pendingUpdates = [[NSMutableArray alloc] init];
        simultaneousUpdates = kDefaultSimultaneousUpdates;
        currentWorkerCount = 0;
        
        removeMissingEntries = YES;
        
        [self loadFeedMetadata];
    }
    return self;
}

- (void) dealloc
{
    [customNamespaces release];
    customNamespaces = nil;
    [pendingUpdates release];
    pendingUpdates = nil;
    [processingUpdates release];
    processingUpdates = nil;
    [feeds release];
    feeds = nil;
    [cachePath release];
    cachePath = nil;
    [queueLock release];
    queueLock = nil;
    [dataLock release];
    dataLock = nil;
    [super dealloc];
}

+ (FDFeedStore*) sharedFeedStore
{
    if( OSAtomicCompareAndSwapInt( 0, 1, &__fd_singletonLock ) == NO )
    {
        while( __fd_singletonStore == nil );
        return ( FDFeedStore* )__fd_singletonStore;
    }
    __fd_singletonStore = [[FDFeedStore alloc] init];
    return ( FDFeedStore* )__fd_singletonStore;
}

#pragma mark -
#pragma mark Accessors

- (BOOL) isProcessing
{
    return actionCount > 0;
}

- (void) setCachePath:(NSString*)value
{
    [cachePath release];
    cachePath = [value retain];
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    if( [fileManager fileExistsAtPath:cachePath] == NO )
        [fileManager createDirectoryAtPath:cachePath attributes:nil];
    [fileManager release];
    [feeds removeAllObjects];
    [self loadFeedMetadata];
}

#pragma mark -
#pragma mark Feed Accessors

- (FDFeedInfo*) addFeed:(NSURL*)url
{
    [dataLock lock];
    FDFeedInfo* feedInfo = [[feeds objectForKey:url] retain];
    if( feedInfo == nil )
    {
        // New
        feedInfo = [[FDFeedInfo alloc] init];
        [feedInfo setUrl:url];
        [feeds setObject:feedInfo forKey:url];
        [self saveFeedMetadata];
    }
    [dataLock unlock];
    return [feedInfo autorelease];
}

- (FDFeedInfo*) addFeed:(NSURL*)url withData:(NSData*)data
{
    FDFeed* feed = [FDFeed feedWithData:data withCustomNamespaces:customNamespaces];
    NSDictionary* plist = [feed propertyList];
    
    [dataLock lock];
    FDFeedInfo* feedInfo = [[feeds objectForKey:url] retain];
    if( feedInfo == nil )
    {
        // New
        feedInfo = [[FDFeedInfo alloc] init];
        [feedInfo setUrl:url];
        [feeds setObject:feedInfo forKey:url];
    }
    [feedInfo setTitle:[feed title]];
    [feedInfo setLastUpdated:[NSDate date]];
    [feedInfo setHasNewEntries:( [[feed entries] count] > 0 ) ? YES : NO];
    [self saveFeedMetadata];
    [dataLock unlock];
    
    NSData* feedData = [NSPropertyListSerialization dataFromPropertyList:plist
                                                                  format:NSPropertyListXMLFormat_v1_0
                                                        errorDescription:NULL];
    [self storeData:feedData forFeed:url];
    
    return [feedInfo autorelease];
}

- (void) removeFeed:(NSURL*)url
{
    [dataLock lock];
    [feeds removeObjectForKey:url];
    [self removeDataForFeed:url];
    [self saveFeedMetadata];
    [dataLock unlock];
}

- (void) removeAllFeeds
{
    [self cancelAllUpdates];
    [dataLock lock];
    for( NSURL* url in [feeds allKeys] )
        [self removeDataForFeed:url];
    [feeds removeAllObjects];
    [self saveFeedMetadata];
    [dataLock unlock];
}

- (NSArray*) feedInfos
{
    [dataLock lock];
    NSArray* infos = [feeds allValues];
    [dataLock unlock];
    return infos;
}

- (FDFeedInfo*) feedInfoForURL:(NSURL*)url
{
    [dataLock lock];
    FDFeedInfo* feedInfo = [[feeds objectForKey:url] retain];
    [dataLock unlock];
    return [feedInfo autorelease];
}

- (void) invalidateFeed:(FDFeedInfo*)feedInfo
{
    [dataLock lock];
    [feedInfo setLastUpdated:nil];
    [self saveFeedMetadata];
    [dataLock unlock];
}

- (FDFeed*) cachedFeedForURL:(NSURL*)url
{
    NSData* data = [self loadDataForFeed:url];
    if( data == nil )
        return nil;
    NSPropertyListFormat format;
    id plist = [NSPropertyListSerialization propertyListFromData:data
                                                mutabilityOption:NSPropertyListImmutable
                                                          format:&format
                                                errorDescription:NULL];
    return [FDFeed feedWithContentsOfPropertyList:plist];
}

#pragma mark -
#pragma mark Updating

- (void) updateFeed:(NSURL*)url withDelegate:(id<FDFeedStoreDelegate>)delegate
{
    [dataLock lock];
    FDFeedInfo* feedInfo = [[feeds objectForKey:url] retain];
    [dataLock unlock];
    if( feedInfo == nil )
        return;
    
    [queueLock lock];
    FDFeedUpdateAction* action = nil;
    for( FDFeedUpdateAction* pending in pendingUpdates )
    {
        if( [pending feedInfo] == feedInfo )
        {
            action = pending;
            break;
        }
    }
    if( action == nil )
    {
        for( FDFeedUpdateAction* processing in processingUpdates )
        {
            if( [processing feedInfo] == feedInfo )
            {
                action = processing;
                break;
            }
        }
    }
    if( action != nil )
    {
        // Already a pending/processing update request - ignore
        [queueLock unlock];
        [feedInfo release];
        return;
    }
    else
    {
        // New request
        action = [[FDFeedUpdateAction alloc] init];
        [action setFeedInfo:feedInfo];
        [action setDelegate:delegate];
        [pendingUpdates addObject:action];
        OSAtomicIncrement32( &actionCount );
        [action release];
    }
    [queueLock unlock];
    [feedInfo release];
    
    [self pumpQueue];
}

- (void) cancelAllUpdates
{
    [queueLock lock];
    [pendingUpdates removeAllObjects];
    for( FDFeedUpdateAction* action in processingUpdates )
        [action setCancel:YES];
    [queueLock unlock];
}

- (void) pumpQueue
{
    FDFeedUpdateAction* action = nil;
    [queueLock lock];
    // Be nice - only go if we are under the cap
    if( currentWorkerCount < simultaneousUpdates )
    {
        if( [pendingUpdates count] > 0 )
        {
            currentWorkerCount++;
            action = [[pendingUpdates objectAtIndex:0] retain];
            [processingUpdates addObject:action];
            [pendingUpdates removeObjectAtIndex:0];
        }
    }
    [queueLock unlock];
    
    if( action != nil )
    {
        [action beginRequest];
        [action release];
    }
}

- (void) completeUpdateForFeed:(FDFeedInfo*)feedInfo withData:(NSData*)data fromAction:(FDFeedUpdateAction*)action
{
    [action retain];
    BOOL cancelled = [action cancel];
    [queueLock lock];
    [processingUpdates removeObject:action];
    OSAtomicDecrement32( &actionCount );
    currentWorkerCount--;
    [queueLock unlock];
    
    [self pumpQueue];
    
    if( cancelled == YES )
    {
        [action release];
        return;
    }
    
    id<FDFeedStoreDelegate> delegate = [action delegate];
    
    FDFeed* feed = nil;
    @try
    {
        feed = [FDFeed feedWithData:data withCustomNamespaces:customNamespaces];
    }
    @catch( NSException* ex )
    {
        // TODO: better logging and reporting to end user
    }
    if( feed != nil )
    {
        // Load existing feed data for merge
        FDFeed* existingFeed = [self cachedFeedForURL:[feedInfo url]];
        if( existingFeed == nil )
        {
            // First fetch
            [dataLock lock];
            [feedInfo setTitle:[feed title]];
            [feedInfo setLastUpdated:[NSDate date]];
            [feedInfo setHasNewEntries:( [[feed entries] count] > 0 ) ? YES : NO];
            [self saveFeedMetadata];
            [dataLock unlock];
        }
        else
        {
            // Merge
            // TODO: make this thread safe - it's not right now! No one holds the dataLock except us, so if someone was using the feed outside they'd have issues!
            [dataLock lock];
            BOOL changed = [existingFeed addNewItemsFromFeed:feed removeMissingEntries:removeMissingEntries];
            [feedInfo setTitle:[feed title]];
            [feedInfo setLastUpdated:[NSDate date]];
            [feedInfo setHasNewEntries:changed];
            [self saveFeedMetadata];
            [dataLock unlock];
            
            feed = existingFeed;
        }
        
        NSData* feedData = [NSPropertyListSerialization dataFromPropertyList:[feed propertyList]
                                                                      format:NSPropertyListXMLFormat_v1_0
                                                            errorDescription:NULL];
        [self storeData:feedData forFeed:[feedInfo url]];
        
        if( [(NSObject*)delegate respondsToSelector:@selector( updateFeed:withInfo:forURL: )] == YES )
            [delegate updateFeed:feed withInfo:feedInfo forURL:[feedInfo url]];
    }
    else
    {
        if( [(NSObject*)delegate respondsToSelector:@selector( updateFeedFailedForURL: )] == YES )
            [delegate updateFeedFailedForURL:[feedInfo url]];
    }
    
    [action release];
}

- (void) completeUpdateFailureForFeed:(FDFeedInfo*)feedInfo fromAction:(FDFeedUpdateAction*)action
{
    [action retain];
    BOOL cancelled = [action cancel];
    [queueLock lock];
    [processingUpdates removeObject:action];
    OSAtomicDecrement32( &actionCount );
    currentWorkerCount--;
    [queueLock unlock];
    
    [self pumpQueue];
    
    if( cancelled == YES )
    {
        [action release];
        return;
    }
    
    id<FDFeedStoreDelegate> delegate = [action delegate];
    if( [(NSObject*)delegate respondsToSelector:@selector( updateFeedFailedForURL: )] == YES )
        [delegate updateFeedFailedForURL:[feedInfo url]];
        
    [action release];
}

#pragma mark -
#pragma mark Metadata Storage

- (BOOL) loadFeedMetadata
{
    NSString* path = [cachePath stringByAppendingPathComponent:@"feed-metadata"];
    NSArray* infosPlist = [NSArray arrayWithContentsOfFile:path];
    if( infosPlist == nil )
        return NO;
    for( NSDictionary* infoPlist in infosPlist )
    {
        FDFeedInfo* feedInfo = [FDFeedInfo feedInfoWithContentsOfPropertyList:infoPlist];
        [feeds setObject:feedInfo forKey:[feedInfo url]];
    }
    return YES;
}

- (void) saveFeedMetadata
{
    NSString* path = [cachePath stringByAppendingPathComponent:@"feed-metadata"];
    NSMutableArray* infosPlist = [NSMutableArray arrayWithCapacity:[feeds count]];
    for( FDFeedInfo* info in [feeds allValues] )
        [infosPlist addObject:[info propertyList]];
    [infosPlist writeToFile:path atomically:YES];
}

#pragma mark -
#pragma mark Data Storage

- (NSString*) fileNameForURL:(NSURL*)url
{
    uint checksum = [FDCRC32 checksumOfString:[url absoluteString]];
    return [NSString stringWithFormat:@"feed-%08x", checksum];
}

- (NSData*) loadDataForFeed:(NSURL*)url
{
    NSString* path = [cachePath stringByAppendingPathComponent:[self fileNameForURL:url]];
    return [NSData dataWithContentsOfFile:path options:NSUncachedRead error:NULL];
}

- (void) storeData:(NSData*)data forFeed:(NSURL*)url
{
    NSString* path = [cachePath stringByAppendingPathComponent:[self fileNameForURL:url]];
    [data writeToFile:path atomically:YES];
}

- (void) removeDataForFeed:(NSURL*)url
{
    NSString* path = [cachePath stringByAppendingPathComponent:[self fileNameForURL:url]];
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtPath:path error:NULL];
    [fileManager release];
}

@end
