//
//  FDContentDetector.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDContentDetector : NSObject {
    BOOL    didDetectType;
    Class   detectedType;
}

+ (Class) detectParserOfData:(NSData*)data;

@end
