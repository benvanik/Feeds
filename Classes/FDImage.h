//
//  FDImage.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * An image that represents a feed.
 */
@interface FDImage : NSObject {
    NSString*   title;
    NSURL*      url;
    NSURL*      link;
}

/**
 * The human-readable title for the image.
 */
@property (nonatomic, retain) NSString* title;

/**
 * The source URL for the image.
 */
@property (nonatomic, retain) NSURL* url;

/**
 * The target link for the image.
 */
@property (nonatomic, retain) NSURL* link;

@end
