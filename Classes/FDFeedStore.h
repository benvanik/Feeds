//
//  FDFeedStore.h
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDFeed;
@class FDFeedInfo;
@protocol FDFeedStoreDelegate;

/**
 * A simple feed storage and update manager.
 */
@interface FDFeedStore : NSObject {
    NSArray*                customNamespaces;
    BOOL                    removeMissingEntries;
    NSLock*                 dataLock;
    NSLock*                 queueLock;
    NSString*               cachePath;
    NSMutableDictionary*    feeds;
    volatile NSInteger      actionCount;
    NSMutableArray*         processingUpdates;
    NSMutableArray*         pendingUpdates;
    NSInteger               simultaneousUpdates;
    volatile NSInteger      currentWorkerCount;
}

/**
 * The list of custom namespaces recognized during feed parsing.
 */
@property (retain) NSArray* customNamespaces;

/**
 * If set updates will remove existing entries not in the newly fetched feed.
 */
@property BOOL removeMissingEntries;

/**
 * The path to where cached feeds should be stored.
 */
@property (retain) NSString* cachePath;

/**
 * The maximum number of simultaneous updates that can occur.
 */
@property NSInteger simultaneousUpdates;

/**
 * Indicates whether or not there are processing or pending updates.
 */
- (BOOL) isProcessing;

/**
 * Returns the singleton feed store instance.
 */
+ (FDFeedStore*) sharedFeedStore;

/**
 * Add a new feed to the store.
 * @param url The source URL of the feed.
 * @return Metadata describing the newly added feed.
 */
- (FDFeedInfo*) addFeed:(NSURL*)url;

/**
 * Add a new feed to the store with the given initial data.
 * @param url The source URL of the feed.
 * @param data The contents of the feed URL.
 * @return Metadata describing the newly added feed.
 */
- (FDFeedInfo*) addFeed:(NSURL*)url withData:(NSData*)data;

/**
 * Remove a feed from the store.
 * @param url The source URL of the feed to remove.
 */
- (void) removeFeed:(NSURL*)url;

/**
 * Remove all feeds from the store.
 */
- (void) removeAllFeeds;

/**
 * Get a list of metadata instances for all tracked feeds.
 * @return A list of FDFeedInfo instances.
 */
- (NSArray*) feedInfos;

/**
 * Get the feed metadata for the given source URL.
 * @param url The source URL of the feed.
 * @return The metadata corresponding to the given source URL.
 */
- (FDFeedInfo*) feedInfoForURL:(NSURL*)url;

/**
 * Sets the feeds last updated time to never so that it will be fetched again.
 * @param feedInfo The feed to invalidate.
 */
- (void) invalidateFeed:(FDFeedInfo*)feedInfo;

/**
 * Get the cached copy of the feed for the given source URL, if present.
 * @param url The source URL of the feed.
 * @return The cached copy of the feed from the last update or nil of the feed has yet to be fetched.
 */
- (FDFeed*) cachedFeedForURL:(NSURL*)url;

/**
 * Begin an update of the given feed.
 * @param url The source URL of the feed to fetch.
 * @param delegate The delegate that will receive completion events.
 */
- (void) updateFeed:(NSURL*)url withDelegate:(id<FDFeedStoreDelegate>)delegate;

/**
 * Cancel all pending update requests.
 */
- (void) cancelAllUpdates;

@end
