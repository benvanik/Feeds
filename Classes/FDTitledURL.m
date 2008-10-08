//
//  FDTitledURL.m
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDTitledURL.h"
#import "FDTitledURL+Implementation.h"

@implementation FDTitledURL

@synthesize title;

#pragma mark -
#pragma mark Initialization

- (id) initWithURL:(NSURL*)_url
{
    return [self initWithURL:_url andTitle:nil];
}

- (id) initWithURL:(NSURL*)_url andTitle:(NSString*)_title
{
    if( _url == nil )
    {
#if defined( FD_EXCEPTIONS )
        [NSException raise:NSInvalidArgumentException format:@"URL must not be nil or empty"];
#endif
        [self release];
        return nil;
    }    
    
    if( self = [super initWithString:[_url absoluteString]] )
    {
        if( ( _title != nil ) && ( [_title length] == 0 ) )
            title = nil;
        else
            title = [_title copy];
    }
    return self;
}

- (void) dealloc
{
    [title release];
    title = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (NSString*) description
{
    if( title != nil )
        return [NSString stringWithFormat:@"%@ (%@)", [self absoluteString], title];
    else
        return [self absoluteString];
}

@end
