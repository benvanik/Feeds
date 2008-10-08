//
//  AtomTests.m
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "AtomTests.h"

@implementation AtomTests

- (void) setUp
{
    feedUrls = [[NSArray alloc] initWithObjects:
                [NSURL URLWithString:@"http://code.google.com/feeds/p/micro-frameworks/svnchanges/basic"],
                nil];
}

- (void) tearDown
{
    [feedUrls release];
}

- (void) testVariousAtomFeedParsing
{
    for( NSURL* feedUrl in feedUrls )
    {
        FDFeed* feed = [FDFeed feedWithContentsOfURL:feedUrl];
        STAssertNotNil( feed, @"Could not load feed from %@", [feedUrl absoluteString] );
    }
}

@end
