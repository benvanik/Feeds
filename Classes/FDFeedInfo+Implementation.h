//
//  FDFeedInfo+Implementation.h
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDFeedInfo.h"

@interface FDFeedInfo (Implementation)

+ (FDFeedInfo*) feedInfoWithContentsOfPropertyList:(NSDictionary*)plist;

- (NSDictionary*) propertyList;

@end
