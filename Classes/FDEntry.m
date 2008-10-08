//
//  FDEntry.m
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDEntry.h"
#import "FDEntry+Implementation.h"

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

@end
