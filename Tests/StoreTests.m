//
//  StoreTests.m
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "StoreTests.h"

@implementation StoreTests

- (void) setUp
{
    [[FDFeedStore sharedFeedStore] removeAllFeeds];
}

- (void) tearDown
{
    [[FDFeedStore sharedFeedStore] removeAllFeeds];
}

- (void) testSimpleUpdate
{
    NSURL* url = [NSURL URLWithString:@"http://www.rssboard.org/files/rss-2.0-sample.xml"];
    
    FDFeedStore* feedStore = [FDFeedStore sharedFeedStore];
    FDFeedInfo* feedInfo = [feedStore addFeed:url];
    STAssertNotNil( feedInfo, @"Unable to add feed" );
    
    FDFeedInfo* feedInfo1 = [feedStore addFeed:url];
    STAssertEquals( feedInfo, feedInfo1, @"Got a different feed info back on second add" );
    
    FDFeed* cachedFeed = [feedStore cachedFeedForURL:url];
    STAssertNil( cachedFeed, @"Had feed cached before we requested" );
    
    FDFeedInfo* feedInfo2 = [feedStore feedInfoForURL:url];
    STAssertNotNil( feedInfo2, @"Unable to get feed info" );
    STAssertEquals( feedInfo, feedInfo2, @"Feed infos differ" );
    
    done = NO;
    [feedStore updateFeed:url withDelegate:self];
    
    while( done == NO )
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    
    cachedFeed = [feedStore cachedFeedForURL:url];
    STAssertNotNil( cachedFeed, @"Could not get cached feed" );
}

- (void) updateFeed:(FDFeed*)feed withInfo:(FDFeedInfo*)feedInfo forURL:(NSURL*)url
{
    done = YES;
}

- (void) updateFeedFailedForURL:(NSURL*)url
{
    done = YES;
}

- (void) testMergeUpdate
{
    FDFeedStore* feedStore = [FDFeedStore sharedFeedStore];
}

@end
