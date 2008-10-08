//
//  FDEntry.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDEmailAddress;
@class FDTitledURL;
@class FDEnclosure;

/**
 * An individual entry inside of a feed.
 */
@interface FDEntry : NSObject {
    NSString*       permanentID;
    NSString*       title;
    NSString*       description;
    NSURL*          link;
    NSDate*         publicationDate;
    NSArray*        categories;
    FDEmailAddress* author;
    FDTitledURL*    source;
    FDEnclosure*    enclosure;
}

/**
 * The optional permanent ID of this entry that will not change between updates.
 */
@property (nonatomic, readonly) NSString* permanentID;

/**
 * The human-readable title of the entry. If not present, description should be used.
 */
@property (nonatomic, readonly) NSString* title;

/**
 * The optional detailed contents of the entry.
 */
@property (nonatomic, readonly) NSString* description;

/**
 * The associated website for the entry.
 */
@property (nonatomic, readonly) NSURL* link;

/**
 * The date this entry was published.
 */
@property (nonatomic, readonly) NSDate* publicationDate;

/**
 * The list of categories this entry is a member of.
 */
@property (nonatomic, readonly) NSArray* categories;

/**
 * The author who posted the entry.
 */
@property (nonatomic, readonly) FDEmailAddress* author;

/**
 * The source this entry is derived from.
 */
@property (nonatomic, readonly) FDTitledURL* source;

/**
 * The optional media enclosure.
 */
@property (nonatomic, readonly) FDEnclosure* enclosure;

@end
