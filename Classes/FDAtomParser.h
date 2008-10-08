//
//  FDAtomParser.h
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDParser.h"

/**
 * An RFC 4287 (Atom) parser.
 * Format documentation: http://tools.ietf.org/html/rfc4287
 */
@interface FDAtomParser : FDParser {
    NSXMLParser*    xml;
}

- (id) initWithData:(NSData*)data;

- (FDFeed*) parseFeed;

@end
