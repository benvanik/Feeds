//
//  FDEmailAddress.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents a simple e-mail address/name pair.
 */
@interface FDEmailAddress : NSObject {
    NSString*   name;
    NSString*   address;
}

/**
 * The name of the owner of the e-mail address.
 */
@property (nonatomic, readonly) NSString* name;

/**
 * The e-mail address in RFC 2822 format.
 */
@property (nonatomic, readonly) NSString* address;

@end
