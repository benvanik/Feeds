//
//  FDEmailAddress+Implementation.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDEmailAddress.h"

@interface FDEmailAddress (Implementation)

/**
 * Initialize an instance with the given e-mail address.
 * @param address An RFC 2822 e-mail address.
 */
- (id) initWithAddress:(NSString*)address;

/**
 * Initialize an instance with the given e-mail address and name.
 * @param address An RFC 2822 e-mail address.
 * @param name A name for the owner of the e-mail address.
 */
- (id) initWithAddress:(NSString*)address andName:(NSString*)name;

/**
 * Creates and returns an e-mail address with the contents of the given property list.
 * @param plist A serialized e-mail address in property list representation.
 */
+ (FDEmailAddress*) emailAddresWithContentsOfPropertyList:(NSDictionary*)plist;

/**
 * Serialize the object to a property list.
 * @return The object in property list format.
 */
- (NSDictionary*) propertyList;

@end
