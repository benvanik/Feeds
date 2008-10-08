//
//  RSS2Tests.m
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "RSS2Tests.h"

@implementation RSS2Tests

- (void) setUp
{
    feedUrls = [[NSArray alloc] initWithObjects:
                [NSURL URLWithString:@"http://www.rssboard.org/files/rss-2.0-sample.xml"],
                [NSURL URLWithString:@"http://feeds.rssboard.org/rssboard"],
                nil];
}

- (void) tearDown
{
    [feedUrls release];
}

- (void) testVariousRSS2FeedParsing
{
    for( NSURL* feedUrl in feedUrls )
    {
        FDFeed* feed = [FDFeed feedWithContentsOfURL:feedUrl];
        STAssertNotNil( feed, @"Could not load feed from %@", [feedUrl absoluteString] );
    }
}

@end
