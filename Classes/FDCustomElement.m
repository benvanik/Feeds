//
//  FDCustomElement.m
//  Feeds
//
//  Created by Ben Vanik on 11/14/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDCustomElement.h"
#import "FDCustomElement+Implementation.h"

@implementation FDCustomElement

@synthesize namespace;
@synthesize localName;
@synthesize attributes;
@synthesize text;

#pragma mark -
#pragma mark Initialization

- (id) init
{
    if( self = [super init] )
    {
        namespace = nil;
        localName = nil;
        attributes = nil;
        text = nil;
    }
    return self;
}

- (id) initWithLocalName:(NSString*)_localName inNamespace:(NSString*)_namespace withAttributes:(NSDictionary*)_attributes
{
    if( self = [super init] )
    {
        if( _localName == nil )
        {
#if defined( FD_EXCEPTIONS )
            [NSException raise:NSInvalidArgumentException format:@"Local name must not be nil or empty"];
#endif
            [self release];
            return nil;
        }
        if( _namespace == nil )
        {
#if defined( FD_EXCEPTIONS )
            [NSException raise:NSInvalidArgumentException format:@"Namespace must not be nil or empty"];
#endif
            [self release];
            return nil;
        }
        namespace = [_namespace copy];
        localName = [_localName copy];
        attributes = [_attributes copy];
        text = nil;
    }
    return self;
}

- (void) dealloc
{
    [namespace release];
    namespace = nil;
    [localName release];
    localName = nil;
    [attributes release];
    attributes = nil;
    [text release];
    text = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@:%@", namespace, localName];
}

FD_SETTER( Text,        text,       NSString*       );

#pragma mark -
#pragma mark Serialization

+ (FDCustomElement*) customElementWithContentsOfPropertyList:(NSDictionary*)plist
{
    if( plist == nil )
        return nil;
    FDCustomElement* element = [[FDCustomElement alloc] initWithLocalName:[plist objectForKey:@"localName"] inNamespace:[plist objectForKey:@"namespace"] withAttributes:[plist objectForKey:@"attributes"]];
    if( [plist objectForKey:@"text"] != nil )
        [element setText:[plist objectForKey:@"text"]];
    return [element autorelease];
}

- (NSDictionary*) propertyList
{
    return [NSDictionary dictionaryWithObjectsAndKeys:localName, @"localName", namespace, @"namespace", text, @"text", attributes, @"attributes", nil];
}

@end
