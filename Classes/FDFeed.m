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
#import "FDCustomElement+Implementation.h"
#import "FDParser.h"

@implementation FDFeed

@synthesize title;
@synthesize description;
@synthesize link;
@synthesize publicationDate;
@synthesize image;
@synthesize customElements;
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
        customElements = nil;
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
    [customElements release];
    customElements = nil;
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
FD_SETTER( CustomElements,      customElements,     NSArray*            );
FD_SETTER( Categories,          categories,         NSArray*            );
FD_SETTER( Entries,             entries,            NSArray*            );

#pragma mark -
#pragma mark Creation Helpers

+ (FDFeed*) feedWithContentsOfFile:(NSString*)path
{
    return [FDFeed feedWithContentsOfFile:path withCustomNamespaces:nil];
}

+ (FDFeed*) feedWithContentsOfFile:(NSString*)path withCustomNamespaces:(NSArray*)namespaces
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
    
    FDFeed* feed = [FDFeed feedWithData:data withCustomNamespaces:namespaces];
    [data release];
    return feed;
}

+ (FDFeed*) feedWithContentsOfURL:(NSURL*)url
{
    return [FDFeed feedWithContentsOfURL:url withCustomNamespaces:nil];
}

+ (FDFeed*) feedWithContentsOfURL:(NSURL*)url withCustomNamespaces:(NSArray*)namespaces
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
    
    FDFeed* feed = [FDFeed feedWithData:data withCustomNamespaces:namespaces];
    [data release];
    return feed;
}

+ (FDFeed*) feedWithData:(NSData*)data
{
    return [FDFeed feedWithData:data withCustomNamespaces:nil];
}

+ (FDFeed*) feedWithData:(NSData*)data withCustomNamespaces:(NSArray*)namespaces
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
    
    FDParser* parser = [FDParser parserWithData:data andCustomNamespaces:namespaces];
    if( parser != nil )
        feed = [[parser parseFeed] retain];
    
    [pool release];
    return [feed autorelease];
}

#pragma mark -
#pragma mark Management

- (BOOL) addNewItemsFromFeed:(FDFeed*)otherFeed removeMissingEntries:(BOOL)removeMissingEntries
{
    BOOL contentsChanged = NO;
    
    // Merge categories
    NSMutableDictionary* localCategories = [[NSMutableDictionary alloc] initWithCapacity:[categories count] + 5];
    for( FDCategory* category in categories )
        [localCategories setObject:category forKey:[category label]];
    for( FDCategory* category in [otherFeed categories] )
    {
        FDCategory* presentCategory = [localCategories objectForKey:[category label]];
        if( presentCategory == nil )
        {
            // New category
            FDCategory* newCategory = [[FDCategory alloc] initWithLabel:[category label]];
            [localCategories setObject:newCategory forKey:[newCategory label]];
            [newCategory release];
            contentsChanged = YES;
        }
    }
    
    // NOTE: if an entry has no permanentID, we ignore it entirely and let it pass through to the new world or add it as if it were new
    NSMutableArray* untrackableEntries = [[NSMutableArray alloc] init];
    
    // Merge entries
    NSMutableDictionary* localEntries = [[NSMutableDictionary alloc] initWithCapacity:[entries count] + 5];
    for( FDEntry* entry in entries )
    {
        if( [entry permanentID] != nil )
            [localEntries setObject:entry forKey:[entry permanentID]];
        else
            [untrackableEntries addObject:entry];
    }
    NSMutableArray* presentLocalEntries = [[NSMutableArray alloc] initWithArray:entries];
    for( FDEntry* entry in [otherFeed entries] )
    {
        // Lookup existing
        FDEntry* presentEntry = ( [entry permanentID] == nil ) ? nil : [localEntries objectForKey:[entry permanentID]];
        
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
        
        // Replace our local entry with the remote one (if not new) - assuming that we want the latest version, if things have changed
        if( [newEntry permanentID] != nil )
            [localEntries setObject:newEntry forKey:[newEntry permanentID]];
        else
            [untrackableEntries addObject:newEntry];
        
        // If no permanentID, always consider new
        if( presentEntry == nil )
            contentsChanged = YES;
        else
            [presentLocalEntries removeObject:presentEntry];
    }
    // presentLocalEntries has a list of entries in us but not in the other feed
    if( ( removeMissingEntries == YES ) && ( [presentLocalEntries count] > 0 ) )
    {
        // Remove the entries
        for( FDEntry* entry in presentLocalEntries )
        {
            if( [entry permanentID] != nil )
                [localEntries removeObjectForKey:[entry permanentID]];
        }
        contentsChanged = YES;
    }
    [presentLocalEntries release];
    
    // TODO: remove empty categories

    // TODO: sort categories/entries
    NSArray* updatedCategories = [localCategories allValues];
    NSArray* updatedEntries = [[localEntries allValues] arrayByAddingObjectsFromArray:untrackableEntries];
    
    [untrackableEntries release];
    
    // Update members
    if( contentsChanged == YES )
    {
        // Odd cases when removing all items
        if( [updatedEntries count] == 0 )
            updatedCategories = [NSArray array];
        
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
    NSArray* customElementsPlist = [plist objectForKey:@"customElements"];
    if( customElementsPlist != nil )
    {
        NSMutableArray* customElements = [NSMutableArray arrayWithCapacity:[customElementsPlist count]];
        for( NSDictionary* customElementPlist in customElementsPlist )
            [customElements addObject:[FDCustomElement customElementWithContentsOfPropertyList:customElementPlist]];
        [feed setCustomElements:customElements];
    }
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
    NSMutableArray* customElementsPlist = [NSMutableArray arrayWithCapacity:[customElements count]];
    for( FDCustomElement* element in customElements )
        [customElementsPlist addObject:[element propertyList]];
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
    if( [customElements count] > 0 )
        [plist setObject:customElementsPlist forKey:@"customElements"];
    if( [categories count] > 0 )
        [plist setObject:categoriesPlist forKey:@"categories"];
    if( [entries count] > 0 )
        [plist setObject:entriesPlist forKey:@"entries"];
    return plist;
}
            
@end
