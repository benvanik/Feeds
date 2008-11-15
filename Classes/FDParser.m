//
//  FDParser.m
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDParser.h"
#import "FDContentDetector.h"

@implementation FDParser

#pragma mark -
#pragma mark Initialization

- (id) init
{
    if( self = [super init] )
    {
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Creation Helpers

+ (FDParser*) parserWithData:(NSData*)data andCustomNamespaces:(NSArray*)namespaces
{
    if( ( data == nil ) || ( [data length] == 0 ) )
    {
#if defined( FD_EXCEPTIONS )
        [NSException raise:NSInvalidArgumentException format:@"Data must not be nil or empty"];
#endif
        return nil;
    }
    
    Class detectedType = [FDContentDetector detectParserOfData:data];
    if( detectedType == NULL )
    {
#if defined( FD_EXCEPTIONS )
        [NSException raise:FDUnknownContentException format:@"Unable to determine the contents of the data"];
#endif
        return nil;
    }
    
    return [[[detectedType alloc] initWithData:data andCustomNamespaces:namespaces] autorelease];
}

#pragma mark -
#pragma mark Parsing

- (FDFeed*) parseFeed
{
    return nil;
}

@end
