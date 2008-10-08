//
//  FDFeed.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDImage;

/**
 * A feed that contains a list of items.
 */
@interface FDFeed : NSObject {
    NSString*       title;
    NSString*       description;
    NSURL*          link;
    NSDate*         publicationDate;
    FDImage*        image;
    NSArray*        categories;
    NSArray*        entries;
}

/**
 * The short human-readable name for this feed.
 */
@property (nonatomic, readonly) NSString* title;

/**
 * The optional detailed summary for this feed.
 */
@property (nonatomic, readonly) NSString* description;

/**
 * A link to the website associated with this feed.
 */
@property (nonatomic, readonly) NSURL* link;

/**
 * The date when the feed was last updated.
 */
@property (nonatomic, readonly) NSDate* publicationDate;

/**
 * A small logo or icon.
 */
@property (nonatomic, readonly) FDImage* image;

/**
 * A list of categories referenced by this feed.
 */
@property (nonatomic, readonly) NSArray* categories;

/**
 * A list of items in this feed.
 */
@property (nonatomic, readonly) NSArray* entries;

/**
 * Creates and returns a feed with the contents of the file at the given path.
 * @param path The absolute path of the file from which to read data.
 */
+ (FDFeed*) feedWithContentsOfFile:(NSString*)path;

/**
 * Creates and returns a feed with the contents of the file at the given URL.
 * @param url The URL from which to read data.
 */
+ (FDFeed*) feedWithContentsOfURL:(NSURL*)url;

/**
 * Creates and returns a feed with the contents of the given data.
 * @param data The data from which to read.
 */
+ (FDFeed*) feedWithData:(NSData*)data;

/**
 * Merges the unique contents of the given feed into this feed.
 * @param otherFeed A feed that may contain new items.
 * @return YES if new items were added.
 */
- (BOOL) addNewItemsFromFeed:(FDFeed*)otherFeed;

/**
 * Creates and returns a feed with the contents of the given property list.
 * @param plist A serialized feed in property list representation.
 */
+ (FDFeed*) feedWithContentsOfPropertyList:(NSDictionary*)plist;

/**
 * Convert the feed to a property list.
 * @return The feed in property list representation.
 */
- (NSDictionary*) propertyList;

@end
