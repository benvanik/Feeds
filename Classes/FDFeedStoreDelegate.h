//
//  FDFeedStoreDelegate.h
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDFeed;
@class FDFeedInfo;

/**
 * Methods that a delegate for FDFeedStore must implement.
 */
@protocol FDFeedStoreDelegate

@optional

/**
 * Sent when a feed update request has completed successfully.
 * @param feed The feed that was fetched.
 * @param feedInfo The metadata describing the feed.
 * @param url The source URL from which the feed was fetched.
 */
- (void) updateFeed:(FDFeed*)feed withInfo:(FDFeedInfo*)feedInfo forURL:(NSURL*)url;

/**
 * Sent when a feed update request has failed.
 * @param url The source URL from which the feed was fetched.
 */
- (void) updateFeedFailedForURL:(NSURL*)url;

@end
