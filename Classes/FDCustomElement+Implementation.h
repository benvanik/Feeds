//
//  FDCustomElement+Implementation.h
//  Feeds
//
//  Created by Ben Vanik on 11/14/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDCustomElement.h"

@interface FDCustomElement (Implementation)

/**
 * Initializes an instance with the given naming and attributes.
 * @param localName The local name (in the namespace) of the element.
 * @param namespace The namespace that contains the element type.
 * @param attributes A dictionary of key-value pairs.
 */
- (id) initWithLocalName:(NSString*)localName inNamespace:(NSString*)namespace withAttributes:(NSDictionary*)attributes;

- (void) setText:(NSString*)text;

/**
 * Creates and returns a custom element with the contents of the given property list.
 * @param plist A serialized custom element in property list representation.
 */
+ (FDCustomElement*) customElementWithContentsOfPropertyList:(NSDictionary*)plist;

/**
 * Serialize the object to a property list.
 * @return The object in property list format.
 */
- (NSDictionary*) propertyList;

@end
