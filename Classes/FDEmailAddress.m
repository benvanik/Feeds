//
//  FDEmailAddress.m
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDEmailAddress.h"
#import "FDEmailAddress+Implementation.h"

@implementation FDEmailAddress

@synthesize name;
@synthesize address;

#pragma mark -
#pragma mark Initialization

- (id) initWithAddress:(NSString*)_address
{
    return [self initWithAddress:_address andName:nil];
}

- (id) initWithAddress:(NSString*)_address andName:(NSString*)_name
{
    if( self = [super init] )
    {
        if( ( _address == nil ) || ( [_address length] == 0 ) )
        {
#if defined( FD_EXCEPTIONS )
            [NSException raise:NSInvalidArgumentException format:@"Address must not be nil or empty"];
#endif
            [self release];
            return nil;
        }
        address = [_address copy];
        
        if( ( _name != nil ) && ( [_name length] == 0 ) )
            name = nil;
        else
            name = [_name copy];
    }
    return self;
}

- (void) dealloc
{
    [address release];
    address = nil;
    [name release];
    name = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (NSString*) description
{
    if( name != nil )
        return [NSString stringWithFormat:@"%@ (%@)", address, name];
    else
        return address;
}

@end
