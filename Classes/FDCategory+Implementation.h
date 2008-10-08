//
//  FDCategory+Implementation.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDCategory.h"

@interface FDCategory (Implementation)

/**
 * Initializes an instance with the given label.
 * @param label A human-readable label for the category.
 */
- (id) initWithLabel:(NSString*)label;

/**
 * Creates and returns a category with the contents of the given property list.
 * @param plist A serialized category in property list representation.
 */
+ (FDCategory*) categoryWithContentsOfPropertyList:(NSDictionary*)plist;

/**
 * Serialize the object to a property list.
 * @return The object in property list format.
 */
- (NSDictionary*) propertyList;

@end
