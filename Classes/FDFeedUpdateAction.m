//
//  FDFeedUpdateAction.m
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDFeedUpdateAction.h"
#import "FDFeedStore+Implementation.h"
#import "FDFeedInfo+Implementation.h"

@implementation FDFeedUpdateAction

@synthesize feedInfo;
@synthesize data;
@synthesize cancel;
@synthesize delegate;

#pragma mark -
#pragma mark Initialization

- (id) init
{
    if( self = [super init] )
    {
        feedInfo = nil;
        data = nil;
        cancel = NO;
        delegate = nil;
    }
    return self;
}

- (void) dealloc
{
    [feedInfo release];
    feedInfo = nil;
    [data release];
    data = nil;
    [(NSObject*)delegate release];
    delegate = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Connection Handling

- (void) beginRequest
{
    data = [[NSMutableData alloc] init];
    
    // NOTE: NSURLRequestReloadRevalidatingCacheData is probably a better choice but should be looked at in the case of the server not returning modification time or obeying IfModifiedSince
    NSURLRequest* request = [NSURLRequest requestWithURL:[feedInfo url]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:60.0];
    [[NSURLConnection alloc] initWithRequest:request
                                    delegate:self];
}

- (NSCachedURLResponse*) connection:(NSURLConnection*)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Disable caching
    return nil;
}

- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    [[FDFeedStore sharedFeedStore] completeUpdateFailureForFeed:feedInfo fromAction:self];
    
    [connection release];
}

- (void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    [data setLength:0];
}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)dataChunk
{
    [data appendData:dataChunk];
}

- (void) connectionDidFinishLoading:(NSURLConnection*)connection
{
    [[FDFeedStore sharedFeedStore] completeUpdateForFeed:feedInfo withData:data fromAction:self];
    
    [connection release];
}

@end
