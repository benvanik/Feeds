//
//  FDFeedUpdateAction.h
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDFeedInfo;
@protocol FDFeedStoreDelegate;

@interface FDFeedUpdateAction : NSObject {
    FDFeedInfo*     feedInfo;
    NSMutableData*  data;
    BOOL            cancel;
    id<FDFeedStoreDelegate> delegate;
}

@property (retain) FDFeedInfo* feedInfo;
@property (retain) NSMutableData* data;
@property BOOL cancel;
@property (retain) id<FDFeedStoreDelegate> delegate;

- (void) beginRequest;

@end
