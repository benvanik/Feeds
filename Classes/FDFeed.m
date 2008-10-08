//
//  FDFeed.m
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDFeed.h"
#import "FDFeed+Implementation.h"
#import "FDEntry+Implementation.h"
#import "FDCategory+Implementation.h"
#import "FDImage+Implementation.h"
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

#pragma mark -
#pragma mark Management

- (BOOL) addNewItemsFromFeed:(FDFeed*)otherFeed
{
    BOOL contentsChanged = NO;
    
    // Merge categories
    NSMutableDictionary* localCategories = [[NSMutableDictionary alloc] initWithCapacity:[categories count] + 5];
    for( FDCategory* category in categories )
        [localCategories setObject:category forKey:[category label]];
    for( FDCategory* category in [otherFeed categories] )
    {
        if( [localCategories objectForKey:[category label]] == nil )
        {
            // New category
            FDCategory* newCategory = [[FDCategory alloc] initWithLabel:[category label]];
            [localCategories setObject:newCategory forKey:[newCategory label]];
            [newCategory release];
            contentsChanged = YES;
        }
    }
    
    // Merge entries
    NSMutableDictionary* localEntries = [[NSMutableDictionary alloc] initWithCapacity:[entries count] + 5];
    for( FDEntry* entry in entries )
        [localEntries setObject:entry forKey:[entry permanentID]];
    for( FDEntry* entry in [otherFeed entries] )
    {
        if( [localEntries objectForKey:[entry permanentID]] == nil )
        {
            // New entry
            // Instead of copying everything, just serialize/deserialize
            FDEntry* newEntry = [FDEntry entryWithContentsOfPropertyList:[entry propertyList]];
            // Have to fix categories to our local instances
            NSMutableArray* entryCategories = [NSMutableArray arrayWithCapacity:[[entry categories] count]];
            for( FDCategory* category in [entry categories] )
            {
                FDCategory* localCategory = [localCategories objectForKey:[category label]];
                [entryCategories addObject:localCategory];
            }
            [newEntry setCategories:entryCategories];
            [localEntries setObject:newEntry forKey:[newEntry permanentID]];
            contentsChanged = YES;
        }
    }

    // TODO: sort categories/entries
    NSArray* updatedCategories = [localCategories allValues];
    NSArray* updatedEntries = [localEntries allValues];
    
    // Update members
    if( contentsChanged == YES )
    {
        [categories release];
        categories = [updatedCategories retain];
        [entries release];
        entries = [updatedEntries retain];
    }
    [localCategories release];
    [localEntries release];
    
    return contentsChanged;
}

#pragma mark -
#pragma mark Loading/Saving

+ (FDFeed*) feedWithContentsOfPropertyList:(NSDictionary*)plist
{
    if( plist == nil )
        return nil;
    FDFeed* feed = [[FDFeed alloc] init];
    [feed setTitle:[plist objectForKey:@"title"]];
    [feed setDescription:[plist objectForKey:@"description"]];
    if( [plist objectForKey:@"link"] != nil )
        [feed setLink:[NSURL URLWithString:[plist objectForKey:@"link"]]];
    [feed setPublicationDate:[plist objectForKey:@"publicationDate"]];
    [feed setImage:[FDImage imageWithContentsOfPropertyList:[plist objectForKey:@"image"]]];
    NSArray* categoriesPlist = [plist objectForKey:@"categories"];
    if( categoriesPlist != nil )
    {
        NSMutableArray* categories = [NSMutableArray arrayWithCapacity:[categoriesPlist count]];
        for( NSDictionary* categoryPlist in categoriesPlist )
            [categories addObject:[FDCategory categoryWithContentsOfPropertyList:categoryPlist]];
        [feed setCategories:categories];
    }
    NSArray* entriesPlist = [plist objectForKey:@"entries"];
    if( entriesPlist != nil )
    {
        NSMutableArray* entries = [NSMutableArray arrayWithCapacity:[entriesPlist count]];
        for( NSDictionary* entryPlist in entriesPlist )
            [entries addObject:[FDEntry entryWithContentsOfPropertyList:entryPlist]];
        [feed setEntries:entries];
    }
    return [feed autorelease];
}

- (NSDictionary*) propertyList
{
    NSMutableArray* categoriesPlist = [NSMutableArray arrayWithCapacity:[categories count]];
    for( FDCategory* category in categories )
        [categoriesPlist addObject:[category propertyList]];
    NSMutableArray* entriesPlist = [NSMutableArray arrayWithCapacity:[entries count]];
    for( FDEntry* entry in entries )
        [entriesPlist addObject:[entry propertyList]];
    
    NSMutableDictionary* plist = [NSMutableDictionary dictionary];
    if( title != nil )
        [plist setObject:title forKey:@"title"];
    if( description != nil )
        [plist setObject:description forKey:@"description"];
    if( link != nil )
        [plist setObject:[link absoluteString] forKey:@"link"];
    if( publicationDate != nil )
        [plist setObject:publicationDate forKey:@"publicationDate"];
    if( image != nil )
        [plist setObject:[image propertyList] forKey:@"image"];
    if( [categories count] > 0 )
        [plist setObject:categoriesPlist forKey:@"categories"];
    if( [entries count] > 0 )
        [plist setObject:entriesPlist forKey:@"entries"];
    return plist;
}
            
@end
