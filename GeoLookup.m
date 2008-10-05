//
//  GeoNames.m
//  GeoNamesTest
//
//  Created by Alex Roberts on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GeoLookup.h"
#import "GeoLookupRequest.h"

NSString *GeoLookupServer = @"http://ws.geonames.org";

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
	NSLog(@"Fetch %@", url);
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
	[self fetch:@"findNearbyWeather"];
}

- (void)dealloc
{
	[responseDict release];
	
	[super dealloc];
}

#pragma mark GeoNamesRequest delegate methods

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
	
	NSXMLParser *xml = [[NSXMLParser alloc] initWithData:data];
	xml.delegate = self;
	
	success = [xml parse];
	
	[request release];
}

- (void)request:(GeoLookupRequest *)request failedWithError:(NSError *)error
{
	NSLog(@"GeoNames: Error with url connection");
	if ([delegate respondsToSelector:@selector(geoLookup:failedWithError:)]) {
		[delegate geoLookup:self failedWithError:error];
	}
	
	[request release];
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
