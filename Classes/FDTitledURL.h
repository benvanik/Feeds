//
//  FDTitledURL.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents a simple URL/title pair.
 */
@interface FDTitledURL : NSURL {
    NSString*   title;
}

/**
 * The title of the target URL.
 */
@property (nonatomic, readonly) NSString* title;

@end
