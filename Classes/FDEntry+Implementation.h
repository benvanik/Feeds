//
//  FDEntry+Implementation.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDEntry.h"

@interface FDEntry (Implementation)

- (void) setPermanentID:(NSString*)value;
- (void) setTitle:(NSString*)value;
- (void) setDescription:(NSString*)value;
- (void) setLink:(NSURL*)value;
- (void) setPublicationDate:(NSDate*)value;
- (void) setCategories:(NSArray*)value;
- (void) setAuthor:(FDEmailAddress*)value;
- (void) setSource:(FDTitledURL*)value;
- (void) setEnclosures:(NSArray*)value;

/**
 * Creates and returns an entry with the contents of the given property list.
 * @param plist A serialized entry in property list representation.
 */
+ (FDEntry*) entryWithContentsOfPropertyList:(NSDictionary*)plist;

/**
 * Serialize the object to a property list.
 * @return The object in property list format.
 */
- (NSDictionary*) propertyList;

@end
