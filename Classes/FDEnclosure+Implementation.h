//
//  FDEnclosure+Implementation.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDEnclosure.h"

@interface FDEnclosure (Implementation)

/**
 * Initialize an instance with the given URL and content properties.
 * @param url A fully-qualified URL to the enclosed content.
 * @param mimeType The mime-type of the target content.
 * @param length The length, in bytes, of the target content.
 */
- (id) initWithURL:(NSURL*)url withMimeType:(NSString*)mimeType andLength:(NSUInteger)length;

@end
