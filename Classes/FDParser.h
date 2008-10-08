//
//  FDParser.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDFeed;

@interface FDParser : NSObject {
}

+ (FDParser*) parserWithData:(NSData*)data;

- (FDFeed*) parseFeed;

@end
