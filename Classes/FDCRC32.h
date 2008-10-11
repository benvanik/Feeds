//
//  FDCRC32.h
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDCRC32 : NSObject {
}

+ (uint) checksumOfData:(NSData*)data;
+ (uint) checksumOfString:(NSString*)string;

@end
