//
//  FDCustomElement.h
//  Feeds
//
//  Created by Ben Vanik on 11/14/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A custom element from the source feed.
 */
@interface FDCustomElement : NSObject {
    NSString*       namespace;
    NSString*       localName;
    NSDictionary*   attributes;
    NSString*       text;
}

/**
 * The namespace that contains the element type.
 */
@property (nonatomic, readonly) NSString* namespace;

/**
 * The local name (in the namespace) of the element.
 */
@property (nonatomic, readonly) NSString* localName;

/**
 * The key-value pairs of attributes for the element.
 */
@property (nonatomic, readonly) NSDictionary* attributes;

/**
 * The text contents of the element.
 */
@property (nonatomic, readonly) NSString* text;

@end
