//
//  FDAtomParser.m
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDAtomParser.h"

@implementation FDAtomParser

#pragma mark -
#pragma mark Initialization

- (id) initWithData:(NSData*)data
{
    if( self = [super init] )
    {
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Parsing

- (FDFeed*) parseFeed
{
    return nil;
}

@end
