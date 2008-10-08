//
//  FDCategory.m
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDCategory.h"
#import "FDCategory+Implementation.h"

@implementation FDCategory

@synthesize label;

#pragma mark -
#pragma mark Initialization

- (id) initWithLabel:(NSString*)_label
{
    if( self = [super init] )
    {
        if( ( _label == nil ) || ( [_label length] == 0 ) )
        {
#if defined( FD_EXCEPTIONS )
            [NSException raise:NSInvalidArgumentException format:@"Label must not be nil or empty"];
#endif
            [self release];
            return nil;
        }
        label = [_label copy];
    }
    return self;
}

- (void) dealloc
{
    [label release];
    label = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (NSString*) description
{
    return label;
}

#pragma mark -
#pragma mark Utilities

- (NSArray*) labelList
{
    return [label pathComponents];
}

@end
