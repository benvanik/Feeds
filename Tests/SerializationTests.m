//
//  SerializationTests.m
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "SerializationTests.h"

@implementation SerializationTests

- (void) setUp
{
    sourceFeed = [[FDFeed feedWithContentsOfURL:[NSURL URLWithString:@"http://www.rssboard.org/files/rss-2.0-sample.xml"]] retain];
}

- (void) tearDown
{
    [sourceFeed release];
    sourceFeed = nil;
}

- (void) testFeedToPlist
{
    NSDictionary* plist = [sourceFeed propertyList];
}

- (void) testPlistToFeed
{
    NSDictionary* plist = [sourceFeed propertyList];
    FDFeed* deserialized = [FDFeed feedWithContentsOfPropertyList:plist];
}

@end
