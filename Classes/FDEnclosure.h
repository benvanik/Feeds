//
//  FDEnclosure.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * An entry content enclosure.
 */
@interface FDEnclosure : NSObject {
    NSURL*      url;
    NSString*   mimeType;
    NSUInteger  length;
}

/**
 * The fully-qualified URL to the content.
 */
@property (nonatomic, readonly) NSURL* url;

/**
 * The MIME-type of the target content.
 */
@property (nonatomic, readonly) NSString* mimeType;

/**
 * The length of the target content, in bytes.
 */
@property (nonatomic, readonly) NSUInteger length;

@end
