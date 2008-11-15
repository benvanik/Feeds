//
//  FDFeed+Implementation.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDFeed.h"

@interface FDFeed (Implementation)

- (void) setTitle:(NSString*)value;
- (void) setDescription:(NSString*)value;
- (void) setLink:(NSURL*)value;
- (void) setPublicationDate:(NSDate*)value;
- (void) setImage:(FDImage*)value;
- (void) setCustomElements:(NSArray*)value;
- (void) setCategories:(NSArray*)value;
- (void) setEntries:(NSArray*)value;

@end
