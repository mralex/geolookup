//
//  GeoNames.m
//  GeoNamesTest
//
//  Created by Alex Roberts on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GeoNames.h"
#import "GeoNamesRequest.h"

NSString *GeoNamesServer = @"http://ws.geonames.org";

@interface GeoNames (Private)
- (void)fetch:(NSString *)apiCommand;
@end

@implementation GeoNames

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
	NSString *url = [NSString stringWithFormat:@"%@/%@?lat=%f&lng=%f", GeoNamesServer, apiCommand, self.latitude, self.longitude];
	NSLog(@"Fetch %@", url);
	GeoNamesRequest *gnRequest = [[GeoNamesRequest alloc] initWithTimeout:30.0 delegate:self];
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

- (void)request:(GeoNamesRequest *)request didGetData:(NSData *)data
{
//	NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	if (dataString != nil) {
//		NSLog(@"GeoNames: Data: %@", dataString);
//	}
	
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

- (void)request:(GeoNamesRequest *)request failedWithError:(NSError *)error
{
	NSLog(@"GeoNames: Error with url connection");
	if ([delegate respondsToSelector:@selector(geoName:failedWithError:)]) {
		[delegate geoName:self failedWithError:error];
	}
	
	//[request release];
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
	
	if ([delegate respondsToSelector:@selector(geoName:didReceiveResponse:)]) {
		[delegate geoName:self didReceiveResponse:responseDict];
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
