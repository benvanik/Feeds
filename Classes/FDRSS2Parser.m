//
//  FDRSS2Parser.m
//  Feeds
//
//  Created by Ben Vanik on 10/7/08.
//  Copyright 2008 Ben Vanik ( http://www.noxa.org ). All rights reserved.
//

#import "FDRSS2Parser.h"
#import "FDFeed+Implementation.h"
#import "FDEntry+Implementation.h"
#import "FDCategory+Implementation.h"
#import "FDEnclosure+Implementation.h"
#import "FDEmailAddress+Implementation.h"
#import "FDTitledURL+Implementation.h"
#import "FDImage+Implementation.h"

@implementation FDRSS2Parser

#pragma mark -
#pragma mark Initialization

- (id) initWithData:(NSData*)data
{
    if( self = [super init] )
    {
        xml = [[NSXMLParser alloc] initWithData:data];
        [xml setDelegate:self];
        [xml setShouldProcessNamespaces:NO];
        [xml setShouldReportNamespacePrefixes:NO];
        [xml setShouldResolveExternalEntities:NO];

        // Sun, 29 Jan 2006 05:00:00 GMT
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"%a, %d %b %Y %H:%M:%S %Z"];
    }
    return self;
}

- (void) dealloc
{
    // NOTE: these should already be cleaned up, but if we errored they may not be
    [feed release];
    [image release];
    [entry release];
    [categories release];
    [entries release];
    [entryCategories release];
    [entryEnclosures release];
    [attributes release];
    [text release];
    
    [dateFormatter release];
    dateFormatter = nil;
    [xml release];
    xml = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Parsing

- (FDFeed*) parseFeed
{
    if( [xml parse] == NO )
    {
#if defined( FD_EXCEPTIONS )
        [NSException raise:FDInvalidDataException format:@"Unable to parse the RSS document"];
#endif
        return nil;
    }
    
    FDFeed* result = feed;
    feed = nil;
    return [result autorelease];
}

- (void) parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict
{
    if( [elementName isEqualToString:@"channel"] == YES )
    {
        state = FDRSS2InChannel;
        feed = [[FDFeed alloc] init];
        categories = [[NSMutableDictionary alloc] init];
        entries = [[NSMutableArray alloc] init];
    }
    
    attributes = [attributeDict retain];
    
    if( state == FDRSS2InChannel )
    {
        if( [elementName isEqualToString:@"image"] == YES )
        {
            state = FDRSS2InChannelImage;
            image = [[FDImage alloc] init];
        }
        else if( [elementName isEqualToString:@"item"] == YES )
        {
            state = FDRSS2InItem;
            entry = [[FDEntry alloc] init];
            entryCategories = [[NSMutableArray alloc] init];
            entryEnclosures = [[NSMutableArray alloc] init];
        }
        else if( [elementName isEqualToString:@"textInput"] == YES )
        {
            state = FDRSS2InTextInput;
        }
    }
    else if( state == FDRSS2InChannelImage )
    {
    }
    else if( state == FDRSS2InItem )
    {
    }
}

- (void) parser:(NSXMLParser*)parser foundCharacters:(NSString*)string
{
    if( text == nil )
        text = [[NSMutableString alloc] initWithCapacity:50];
    [text appendString:string];
}

- (void) parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
{
    NSString* fixedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if( state == FDRSS2InChannel )
    {
        if( [elementName isEqualToString:@"channel"] == YES )
        {
            NSMutableArray* allCategories = [[NSMutableArray alloc] initWithArray:[categories allValues]];
            // TODO: sort categories
            [feed setCategories:allCategories];
            // TODO: sort entries
            [feed setEntries:entries];
            [categories release];
            categories = nil;
            [entries release];
            entries = nil;
        }
        else if( [elementName isEqualToString:@"title"] == YES )
        {
            [feed setTitle:fixedText];
        }
        else if( [elementName isEqualToString:@"description"] == YES )
        {
            [feed setDescription:fixedText];
        }
        else if( [elementName isEqualToString:@"link"] == YES )
        {
            [feed setLink:[NSURL URLWithString:fixedText]];
        }
        else if( [elementName isEqualToString:@"pubDate"] == YES )
        {
            [feed setPublicationDate:[dateFormatter dateFromString:fixedText]];
        }
    }
    else if( state == FDRSS2InChannelImage )
    {
        if( [elementName isEqualToString:@"image"] == YES )
        {
            state = FDRSS2InChannel;
            [feed setImage:image];
            [image release];
            image = nil;
        }
        else if( [elementName isEqualToString:@"title"] == YES )
        {
            [image setTitle:fixedText];
        }
        else if( [elementName isEqualToString:@"url"] == YES )
        {
            [image setURL:[NSURL URLWithString:fixedText]];
        }
        else if( [elementName isEqualToString:@"link"] == YES )
        {
            [image setLink:[NSURL URLWithString:fixedText]];
        }
    }
    else if( state == FDRSS2InItem )
    {
        if( [elementName isEqualToString:@"item"] == YES )
        {
            state = FDRSS2InChannel;
            // TODO: sort entryCategories
            [entry setCategories:entryCategories];
            [entry setEnclosures:entryEnclosures];
            [entries addObject:entry];
            [entryCategories release];
            entryCategories = nil;
            [entryEnclosures release];
            entryEnclosures = nil;
            [entry release];
            entry = nil;
        }
        else if( [elementName isEqualToString:@"guid"] == YES )
        {
            id isPermaLinkValue = [attributes objectForKey:@"isPermaLink"];
            BOOL isPermaLink = ( isPermaLinkValue == nil ) || ( [isPermaLinkValue boolValue] == YES );
            if( isPermaLink == YES )
                [entry setLink:[NSURL URLWithString:fixedText]];
            [entry setPermanentID:fixedText];
        }
        else if( [elementName isEqualToString:@"title"] == YES )
        {
            [entry setTitle:fixedText];
        }
        else if( [elementName isEqualToString:@"description"] == YES )
        {
            [entry setDescription:fixedText];
        }
        else if( [elementName isEqualToString:@"link"] == YES )
        {
            [entry setLink:[NSURL URLWithString:fixedText]];
        }
        else if( [elementName isEqualToString:@"pubDate"] == YES )
        {
            [entry setPublicationDate:[dateFormatter dateFromString:fixedText]];
        }
        else if( [elementName isEqualToString:@"category"] == YES )
        {
            FDCategory* category = [categories objectForKey:fixedText];
            if( category == nil )
            {
                category = [[FDCategory alloc] initWithLabel:fixedText];
                [categories setObject:category forKey:fixedText];
                [category release];
            }
            [entryCategories addObject:category];
        }
        else if( [elementName isEqualToString:@"author"] == YES )
        {
            NSUInteger space = [fixedText rangeOfString:@" "].location;
            if( space == NSNotFound )
            {
                // email@email.com
                FDEmailAddress* author = [[FDEmailAddress alloc] initWithAddress:fixedText];
                [entry setAuthor:author];
                [author release];
            }
            else
            {
                // email@email.com (Name)
                NSString* email = [fixedText substringToIndex:space];
                NSString* name = [fixedText substringWithRange:NSMakeRange( space + 2, [fixedText length] - space - 3 )];
                FDEmailAddress* author = [[FDEmailAddress alloc] initWithAddress:email andName:name];
                [entry setAuthor:author];
                [author release];
            }
        }
        else if( [elementName isEqualToString:@"source"] == YES )
        {
            FDTitledURL* url = [[FDTitledURL alloc] initWithURL:[NSURL URLWithString:[attributes objectForKey:@"url"]]
                                                       andTitle:fixedText];
            [entry setSource:url];
            [url release];
        }
        else if( [elementName isEqualToString:@"enclosure"] == YES )
        {
            FDEnclosure* enclosure = [[FDEnclosure alloc] initWithURL:[NSURL URLWithString:[attributes objectForKey:@"url"]]
                                                         withMimeType:[attributes objectForKey:@"type"]
                                                            andLength:[[attributes objectForKey:@"length"] integerValue]];
            [entryEnclosures addObject:enclosure];
            [enclosure release];
        }
    }
    else if( state == FDRSS2InTextInput )
    {
        if( [elementName isEqualToString:@"textInput"] == YES )
        {
            state = FDRSS2InChannel;
        }
    }
    
    [text release];
    text = nil;
    [attributes release];
    attributes = nil;
}

- (void) parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError
{
    NSLog( @"FDRSS2Parser: Error %i, Description: %@, Line: %i, Column: %i", [parseError code], [[parser parserError] localizedDescription], [parser lineNumber], [parser columnNumber] );
}

@end
