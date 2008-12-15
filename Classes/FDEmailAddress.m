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
        if( ( _address != nil ) && ( [_address length] == 0 ) )
             address = nil;
        else
             address = [_address retain];
        
        if( ( _name != nil ) && ( [_name length] == 0 ) )
            name = nil;
        else
            name = [_name retain];
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

#pragma mark -
#pragma mark Serialization

+ (FDEmailAddress*) emailAddresWithContentsOfPropertyList:(NSDictionary*)plist
{
    if( plist == nil )
        return nil;
    FDEmailAddress* emailAddress = [[FDEmailAddress alloc] initWithAddress:[plist objectForKey:@"address"] andName:[plist objectForKey:@"name"]];
    return [emailAddress autorelease];
}

- (NSDictionary*) propertyList
{
    return [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", address, @"address", nil];
}

@end
