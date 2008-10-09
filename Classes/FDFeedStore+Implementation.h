//
//  FDFeedStore+Implementation.h
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDFeedStore.h"

@class FDFeedInfo;
@class FDFeedUpdateAction;

@interface FDFeedStore (Implementation)

- (void) pumpQueue;
- (void) completeUpdateForFeed:(FDFeedInfo*)feedInfo withData:(NSData*)data fromAction:(FDFeedUpdateAction*)action;
- (void) completeUpdateFailureForFeed:(FDFeedInfo*)feedInfo fromAction:(FDFeedUpdateAction*)action;

- (BOOL) loadFeedMetadata;
- (void) saveFeedMetadata;

- (NSString*) fileNameForURL:(NSURL*)url;
- (NSData*) loadDataForFeed:(NSURL*)url;
- (void) storeData:(NSData*)data forFeed:(NSURL*)url;
- (void) removeDataForFeed:(NSURL*)url;

@end
