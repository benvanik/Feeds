//
//  FDImage+Implementation.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDImage.h"

@interface FDImage (Implementation)

/**
 * Initializes an instance with the given URL, target link, and title.
 * @param url The source URL for the image.
 * @param link A target link for the image.
 * @param title A human-readable title.
 */
- (id) initWithURL:(NSURL*)url toLink:(NSURL*)link withTitle:(NSString*)title;

- (void) setTitle:(NSString*)value;
- (void) setURL:(NSURL*)value;
- (void) setLink:(NSURL*)link;

/**
 * Creates and returns an image with the contents of the given property list.
 * @param plist A serialized image in property list representation.
 */
+ (FDImage*) imageWithContentsOfPropertyList:(NSDictionary*)plist;

/**
 * Serialize the object to a property list.
 * @return The object in property list format.
 */
- (NSDictionary*) propertyList;

@end
