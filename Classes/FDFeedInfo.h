//
//  FDFeedInfo.h
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents the metadata about a feed and its current state.
 */
@interface FDFeedInfo : NSObject {
    NSURL*      url;
    NSString*   title;
    NSDate*     lastUpdated;
    BOOL        hasNewEntries;
}

/**
 * The source URL of the feed. May be of scheme file://.
 */
@property (retain) NSURL* url;

/**
 * The title of the feed from when it was last fetched or nil if it has not yet been fetched.
 */
@property (retain) NSString* title;

/**
 * The date when the feed was last updated or nil if it has not yet been fetched.
 */
@property (retain) NSDate* lastUpdated;

/**
 * A flag denoting whether or not the feed has new entries since last being updated.
 */
@property BOOL hasNewEntries;

@end
