//
//  FDRSS2Parser.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDParser.h"

@class FDFeed;
@class FDImage;
@class FDEntry;

enum {
    FDRSS2InChannel,
    FDRSS2InChannelImage,
    FDRSS2InTextInput,
    FDRSS2InItem,
};
typedef NSInteger FDRSS2State;

/**
 * An RSS 2.0.XX parser.
 * Format documentation: http://www.rssboard.org/rss-specification
 */
@interface FDRSS2Parser : FDParser {
    NSXMLParser*            xml;
    FDRSS2State             state;
    
    FDFeed*                 feed;
    FDImage*                image;
    FDEntry*                entry;
    NSMutableDictionary*    categories;
    NSMutableArray*         entries;
    NSMutableArray*         entryCategories;
    
    NSDateFormatter*        dateFormatter;
    NSDictionary*           attributes;
    NSMutableString*        text;
}

- (id) initWithData:(NSData*)data;

- (FDFeed*) parseFeed;

@end
