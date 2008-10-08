//
//  FDContentDetector.m
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDContentDetector.h"
#import "FDAtomParser.h"
#import "FDRSS2Parser.h"

@implementation FDContentDetector

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
#pragma mark Accessors

- (BOOL) didDetectType
{
    return didDetectType;
}

- (Class) detectedType
{
    return detectedType;
}

#pragma mark -
#pragma mark Detection

+ (Class) detectParserOfData:(NSData*)data
{
    FDContentDetector* detector = [[FDContentDetector alloc] init];
    
    // Currently all formats use XML, so we can try to load it up as XML - in the future, this may not be the case
    NSXMLParser* xml = [[NSXMLParser alloc] initWithData:data];
    [xml setDelegate:detector];
    [xml setShouldProcessNamespaces:NO];
    [xml setShouldReportNamespacePrefixes:NO];
    [xml setShouldResolveExternalEntities:NO];
    if( ( [xml parse] == NO ) && ( [detector didDetectType] == NO ) )
    {
        // Failed
#if defined( FD_EXCEPTIONS )
        [NSException raise:FDUnknownContentException format:@"Unable to parse content XML"];
#endif
        [xml release];
        [detector release];
        return NULL;
    }
    
    Class detectedType = NULL;
    if( [detector didDetectType] == YES )
        detectedType = [detector detectedType];
    
    [xml release];
    [detector release];
    return detectedType;
}

- (void) parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict
{
    if( [elementName isEqualToString:@"rss"] == YES )
    {
        NSString* version = [attributeDict objectForKey:@"version"];
        if( [version isEqualToString:@"2.0"] == YES )
        {
            didDetectType = YES;
            detectedType = [FDRSS2Parser class];
        }
    }
    else if( [elementName isEqualToString:@"feed"] == YES )
    {
        didDetectType = YES;
        detectedType = [FDAtomParser class];
    }
    [parser abortParsing];
}

//- (void) parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError
//{
//    // Ignore our abort error
//    if( ( [parseError domain] == NSXMLParserErrorDomain ) && ( [parseError code] == 1 ) )
//        return;
//    NSLog( @"FDContentDetector: Error %i, Description: %@, Line: %i, Column: %i", [parseError code], [[parser parserError] localizedDescription], [parser lineNumber], [parser columnNumber] );
//}

@end
