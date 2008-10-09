//
//  NSData+CRC32.h
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CRC32)

- (uint) checksum;
+ (uint) checksumOfString:(NSString*)string;

@end
