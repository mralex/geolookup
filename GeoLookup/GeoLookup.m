//
//  GeoLookup.m
//
//  Created by Alex Roberts on 9/29/08.
//	Copyright (c) 2008 Alex Roberts
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

#import "GeoLookup.h"
#import "GeoLookupRequest.h"

static NSString *GeoLookupServer = @"http://ws.geonames.org";

@interface GeoLookup (Private)
- (void)fetch:(NSString *)apiCommand;
@end

@implementation GeoLookup

@synthesize longitude;
@synthesize latitude;
@synthesize delegate;

- (id)initWithLatitude:(double)inLatitude longitude:(double)inLongitude
{
	if (self = [super init]) {
		self.longitude = inLongitude;
		self.latitude = inLatitude;
		
		NSLog(@"Long: %f, Lat: %f", self.longitude, self.latitude);
	}
	
	return self;
}

- (void)fetch:(NSString *)apiCommand
{
	NSString *url = [NSString stringWithFormat:@"%@/%@?lat=%f&lng=%f", GeoLookupServer, apiCommand, self.latitude, self.longitude];

	GeoLookupRequest *gnRequest = [[GeoLookupRequest alloc] initWithTimeout:30.0 delegate:self];
	[gnRequest get:url];
}

- (void)findNearby
{
	[self fetch:@"findNearby"];
}

- (void)findNearbyPlaceName
{
	[self fetch:@"findNearbyPlaceName"];	
}

- (void)findNearbyPostalCodes
{
	[self fetch:@"findNearbyPostalCodes"];
}

- (void)findNearbyStreets
{
	[self fetch:@"findNearbyStreets"];
}

- (void)findNearbyWeather
{
	[self fetch:@"findNearByWeather"];
}

- (void)dealloc
{
	[responseDict release];
	
	[super dealloc];
}

#pragma mark GeoLookupRequest delegate methods

- (void)request:(GeoLookupRequest *)request didGetData:(NSData *)data
{
	NSXMLDocument *xmlDoc;
	NSError *error = nil;
	BOOL success;
	
	// Parse the returned XML data
	xmlDoc = [[NSXMLDocument alloc] initWithData:data options:NSXMLDocumentTidyXML error:&error];
	if (xmlDoc == nil) {
		if (error) {
			NSLog(@"XML Loading failed with: (%d) %@", [error code], [error domain]);
		}
		return;
	}
	
	NSLog(@"Got data, parsing.");
	
	NSXMLParser *xml = [[NSXMLParser alloc] initWithData:data];
	xml.delegate = self;
	
	success = [xml parse];
	
	[request release];
	request = nil;
}

- (void)request:(GeoLookupRequest *)request failedWithError:(NSError *)error
{
	NSLog(@"GeoNames: Error with url connection");
	if ([delegate respondsToSelector:@selector(geoLookup:failedWithError:)]) {
		[delegate geoLookup:self failedWithError:error];
	}
	
	[request release];
	request = nil;
}


#pragma mark NSXMLParser delegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
	NSLog(@"Started parsing xml");
	
	responseDict = [[NSMutableDictionary alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"Parsing complete.");
	
	if ([delegate respondsToSelector:@selector(geoLookup:didReceiveResponse:)]) {
		[delegate geoLookup:self didReceiveResponse:responseDict];
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	currentElement = [elementName copy];
	currentCharacters = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	[responseDict setValue:currentCharacters forKey:currentElement];
	
	[currentCharacters release];
	currentCharacters = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[currentCharacters appendString:string];
}

@end
