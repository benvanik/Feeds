//
//  FDImage.m
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDImage.h"
#import "FDImage+Implementation.h"

@implementation FDImage

@synthesize title;
@synthesize url;
@synthesize link;

#pragma mark -
#pragma mark Initialization

- (id) init
{
    if( self = [super init] )
    {
        url = nil;
        link = nil;
        title = nil;
    }
    return self;
}

- (id) initWithURL:(NSURL*)_url toLink:(NSURL*)_link withTitle:(NSString*)_title
{
    if( self = [super init] )
    {
        if( _url == nil )
        {
#if defined( FD_EXCEPTIONS )
            [NSException raise:NSInvalidArgumentException format:@"URL must not be nil or empty"];
#endif
            [self release];
            return nil;
        }
        url = [_url copy];
        
        link = [_link copy];
        title = [_title copy];
    }
    return self;
}

- (void) dealloc
{
    [url release];
    url = nil;
    [link release];
    link = nil;
    [title release];
    title = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (NSString*) description
{
    if( title != nil )
        return [NSString stringWithFormat:@"%@ (%@)", [url absoluteString], title];
    else
        return [url absoluteString];
}

FD_SETTER( Title,       title,      NSString*       );
FD_SETTER( URL,         url,        NSURL*          );
FD_SETTER( Link,        link,       NSURL*          );

#pragma mark -
#pragma mark Serialization

+ (FDImage*) imageWithContentsOfPropertyList:(NSDictionary*)plist
{
    if( plist == nil )
        return nil;
    FDImage* image = [[FDImage alloc] init];
    [image setTitle:[plist objectForKey:@"title"]];
    if( [plist objectForKey:@"url"] != nil )
        [image setURL:[NSURL URLWithString:[plist objectForKey:@"url"]]];
    if( [plist objectForKey:@"link"] != nil )
        [image setLink:[NSURL URLWithString:[plist objectForKey:@"link"]]];
    return [image autorelease];
}

- (NSDictionary*) propertyList
{
    return [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", [url absoluteString], @"url", [link absoluteString], @"link", nil];
}

@end
