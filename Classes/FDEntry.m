//
//  FDEntry.m
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDEntry.h"
#import "FDEntry+Implementation.h"
#import "FDCategory+Implementation.h";
#import "FDEmailAddress+Implementation.h"
#import "FDTitledURL+Implementation.h"
#import "FDEnclosure+Implementation.h"

@implementation FDEntry

@synthesize permanentID;
@synthesize title;
@synthesize description;
@synthesize link;
@synthesize publicationDate;
@synthesize categories;
@synthesize author;
@synthesize source;
@synthesize enclosure;

#pragma mark -
#pragma mark Initialization

- (id) init
{
    if( self = [super init] )
    {
        permanentID = nil;
        title = nil;
        description = nil;
        link = nil;
        publicationDate = nil;
        categories = nil;
        author = nil;
        source = nil;
        enclosure = nil;
    }
    return self;
}

- (void) dealloc
{
    [permanentID release];
    permanentID = nil;
    [title release];
    title = nil;
    [description release];
    description = nil;
    [link release];
    link = nil;
    [publicationDate release];
    publicationDate = nil;
    [categories release];
    categories = nil;
    [author release];
    author = nil;
    [source release];
    source = nil;
    [enclosure release];
    enclosure = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@ (%@)", ( title != nil ) ? title : description, ( link != nil ) ? [link absoluteString] : @"no link"];
}

FD_SETTER( PermanentID,         permanentID,        NSString*           );
FD_SETTER( Title,               title,              NSString*           );
FD_SETTER( Description,         description,        NSString*           );
FD_SETTER( Link,                link,               NSURL*              );
FD_SETTER( PublicationDate,     publicationDate,    NSDate*             );
FD_SETTER( Categories,          categories,         NSArray*            );
FD_SETTER( Author,              author,             FDEmailAddress*     );
FD_SETTER( Source,              source,             FDTitledURL*        );
FD_SETTER( Enclosure,           enclosure,          FDEnclosure*        );

#pragma mark -
#pragma mark Serialization

+ (FDEntry*) entryWithContentsOfPropertyList:(NSDictionary*)plist
{
    if( plist == nil )
        return nil;
    FDEntry* entry = [[FDEntry alloc] init];
    [entry setPermanentID:[plist objectForKey:@"permanentID"]];
    [entry setTitle:[plist objectForKey:@"title"]];
    [entry setDescription:[plist objectForKey:@"description"]];
    if( [plist objectForKey:@"link"] != nil )
        [entry setLink:[NSURL URLWithString:[plist objectForKey:@"link"]]];
    [entry setPublicationDate:[plist objectForKey:@"publicationDate"]];
    [entry setAuthor:[FDEmailAddress emailAddresWithContentsOfPropertyList:[plist objectForKey:@"author"]]];
    [entry setSource:[FDTitledURL titledURLWithContentsOfPropertyList:[plist objectForKey:@"source"]]];
    [entry setEnclosure:[FDEnclosure enclosureWithContentsOfPropertyList:[plist objectForKey:@"enclosure"]]];
    NSArray* categoriesPlist = [plist objectForKey:@"categories"];
    if( categoriesPlist != nil )
    {
        NSMutableArray* categories = [NSMutableArray arrayWithCapacity:[categoriesPlist count]];
        for( NSDictionary* categoryPlist in categoriesPlist )
            [categories addObject:[FDCategory categoryWithContentsOfPropertyList:categoryPlist]];
        [entry setCategories:categories];
    }
    return [entry autorelease];
}

- (NSDictionary*) propertyList
{
    NSMutableArray* categoriesPlist = [NSMutableArray arrayWithCapacity:[categories count]];
    for( FDCategory* category in categories )
        [categoriesPlist addObject:[category propertyList]];
    NSMutableDictionary* plist = [NSMutableDictionary dictionary];
    if( permanentID != nil )
        [plist setObject:permanentID forKey:@"permanentID"];
    if( title != nil )
        [plist setObject:title forKey:@"title"];
    if( description != nil )
        [plist setObject:description forKey:@"description"];
    if( link != nil )
        [plist setObject:[link absoluteString] forKey:@"link"];
    if( publicationDate != nil )
        [plist setObject:publicationDate forKey:@"publicationDate"];
    if( [categories count] > 0 )
        [plist setObject:categoriesPlist forKey:@"categories"];
    if( author != nil )
        [plist setObject:[author propertyList] forKey:@"author"];
    if( source != nil )
        [plist setObject:[source propertyList] forKey:@"source"];
    if( enclosure != nil )
        [plist setObject:[enclosure propertyList] forKey:@"enclosure"];
    return plist;
}

@end
