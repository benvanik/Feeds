//
//  FDEntry+Implementation.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDEntry.h"

@interface FDEntry (Implementation)

- (void) setPermanentID:(NSString*)value;
- (void) setTitle:(NSString*)value;
- (void) setDescription:(NSString*)value;
- (void) setLink:(NSURL*)value;
- (void) setPublicationDate:(NSDate*)value;
- (void) setCategories:(NSArray*)value;
- (void) setAuthor:(FDEmailAddress*)value;
- (void) setSource:(FDTitledURL*)value;
- (void) setEnclosure:(FDEnclosure*)value;

@end
