//
//  FDCategory.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A feed-defined category.
 */
@interface FDCategory : NSObject {
    NSString*   label;
}

/**
 * The human-readable label for the category. May contain /'s for nested categories.
 */
@property (nonatomic, readonly) NSString* label;

/**
 * A list of labels in most-general to most-specific order.
 */
- (NSArray*) labelList;

@end
