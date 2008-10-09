//
//  FDFeedInfo.m
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDFeedInfo.h"

@implementation FDFeedInfo

@synthesize url;
@synthesize title;
@synthesize lastUpdated;
@synthesize hasNewEntries;

#pragma mark -
#pragma mark Initialization

- (id) init
{
    if( self = [super init] )
    {
        url = nil;
        title = nil;
        lastUpdated = nil;
        hasNewEntries = NO;
    }
    return self;
}

- (void) dealloc
{
    [url release];
    url = nil;
    [title release];
    title = nil;
    [lastUpdated release];
    lastUpdated = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Serialization

+ (FDFeedInfo*) feedInfoWithContentsOfPropertyList:(NSDictionary*)plist
{
    FDFeedInfo* feedInfo = [[FDFeedInfo alloc] init];
    [feedInfo setUrl:[NSURL URLWithString:[plist objectForKey:@"url"]]];
    [feedInfo setTitle:[plist objectForKey:@"title"]];
    [feedInfo setLastUpdated:[plist objectForKey:@"lastUpdated"]];
    [feedInfo setHasNewEntries:[[plist objectForKey:@"hasNewEntries"] boolValue]];
    return [feedInfo autorelease];
}

- (NSDictionary*) propertyList
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [url absoluteString], @"url",
            title, @"title",
            lastUpdated, @"lastUpdated",
            [NSNumber numberWithBool:hasNewEntries], @"hasNewEntries", nil];
}

@end
