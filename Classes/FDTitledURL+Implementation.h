//
//  FDTitledURL+Implementation.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDTitledURL.h"

@interface FDTitledURL (Implementation)

/**
 * Initialize an instance with the given URL.
 * @param url A uniform resource locator.
 */
- (id) initWithURL:(NSURL*)url;

/**
 * Initialize an instance with the given URL and title.
 * @param URL A uniform resource locator.
 * @param title The title of the target URL.
 */
- (id) initWithURL:(NSURL*)url andTitle:(NSString*)title;

@end
