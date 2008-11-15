//
//  MergeTests.m
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "MergeTests.h"

@implementation MergeTests

- (void) setUp
{
}

- (void) tearDown
{
}

- (void) testRandomMerge
{
    FDFeed* feed1 = [FDFeed feedWithContentsOfURL:[NSURL URLWithString:@"http://www.rssboard.org/files/rss-2.0-sample.xml"]];
    FDFeed* feed2 = [FDFeed feedWithContentsOfURL:[NSURL URLWithString:@"http://feeds.rssboard.org/rssboard"]];
    BOOL anyDiffer = [feed1 addNewItemsFromFeed:feed2 removeMissingEntries:YES];
    STAssertTrue( anyDiffer, @"Something should have differed" );
}

- (void) testIdentityMerge
{
    FDFeed* feed1 = [FDFeed feedWithContentsOfURL:[NSURL URLWithString:@"http://www.rssboard.org/files/rss-2.0-sample.xml"]];
    FDFeed* feed2 = [FDFeed feedWithContentsOfURL:[NSURL URLWithString:@"http://www.rssboard.org/files/rss-2.0-sample.xml"]];
    BOOL anyDiffer = [feed1 addNewItemsFromFeed:feed2 removeMissingEntries:YES];
    STAssertFalse( anyDiffer, @"Nothing should have changed" );
}

@end
