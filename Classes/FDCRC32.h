//
//  FDCRC32.h
//  Feeds
//
//  Created by Ben Vanik on 10/8/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Utility class for computing CRC32 checksums.
 */
@interface FDCRC32 : NSObject {
}

/**
 * Compute the checksum of the given data.
 * @param data The data to compute; the entire data is used.
 * @return The CRC32 of the given data.
 */
+ (uint) checksumOfData:(NSData*)data;

/**
 * Compute the checksum of the given string.
 * @param string The string to compute; the entire string is used.
 * @return The CRC32 of the given string.
 */
+ (uint) checksumOfString:(NSString*)string;

@end
