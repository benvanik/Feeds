//
//  FDFeed.m
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDFeed.h"
#import "FDFeed+Implementation.h"
#import "FDParser.h"

@implementation FDFeed

@synthesize title;
@synthesize description;
@synthesize link;
@synthesize publicationDate;
@synthesize image;
@synthesize categories;
@synthesize entries;

- (id) init
{
    if( self = [super init] )
    {
        title = nil;
        description = nil;
        link = nil;
        publicationDate = nil;
        image = nil;
        categories = nil;
        entries = nil;
    }
    return self;
}

- (void) dealloc
{
    [title release];
    title = nil;
    [description release];
    description = nil;
    [link release];
    link = nil;
    [publicationDate release];
    publicationDate = nil;
    [image release];
    image = nil;
    [categories release];
    categories = nil;
    [entries release];
    entries = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (NSString*) description
{
    return title;
}

FD_SETTER( Title,               title,              NSString*           );
FD_SETTER( Description,         description,        NSString*           );
FD_SETTER( Link,                link,               NSURL*              );
FD_SETTER( PublicationDate,     publicationDate,    NSDate*             );
FD_SETTER( Image,               image,              FDImage*            );
FD_SETTER( Categories,          categories,         NSArray*            );
FD_SETTER( Entries,             entries,            NSArray*            );

#pragma mark -
#pragma mark Creation Helpers

+ (FDFeed*) feedWithContentsOfFile:(NSString*)path
{
    if( ( path == nil ) || ( [path length] == 0 ) )
    {
#if defined( FD_EXCEPTIONS )
        [NSException raise:NSInvalidArgumentException format:@"Path must not be nil or empty"];
#endif
        return nil;
    }
    
    NSData* data = [[NSData alloc] initWithContentsOfFile:path];
    if( data == nil )
    {
#if defined( FD_EXCEPTIONS )
        [NSException raise:FDFileLoadException format:@"Could not retrieve contents of file"];
#endif
        return nil;
    }
    
    FDFeed* feed = [FDFeed feedWithData:data];
    [data release];
    return feed;
}

+ (FDFeed*) feedWithContentsOfURL:(NSURL*)url
{
    if( url == nil )
    {
#if defined( FD_EXCEPTIONS )
        [NSException raise:NSInvalidArgumentException format:@"URL must not be nil or empty"];
#endif
        return nil;
    }
    
    NSData* data = [[NSData alloc] initWithContentsOfURL:url];
    if( data == nil )
    {
#if defined( FD_EXCEPTIONS )
        [NSException raise:FDURLLoadException format:@"Could not retrieve contents of URL"];
#endif
        return nil;
    }
    
    FDFeed* feed = [FDFeed feedWithData:data];
    [data release];
    return feed;
}

+ (FDFeed*) feedWithData:(NSData*)data
{
    if( ( data == nil ) || ( [data length] == 0 ) )
    {
#if defined( FD_EXCEPTIONS )
        [NSException raise:NSInvalidArgumentException format:@"Data must not be nil or empty"];
#endif
        return nil;
    }
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    FDFeed* feed = nil;
    
    FDParser* parser = [FDParser parserWithData:data];
    if( parser != nil )
        feed = [[parser parseFeed] retain];
    
    [pool release];
    return [feed autorelease];
}

@end
