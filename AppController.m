//
//  AppController.m
//  GeoNamesTest2
//
//  Created by Alex Roberts on 9/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "GeoLookup.h"

@implementation AppController

- (id)init
{
	if (self = [super init]) {
		gn = [[GeoLookup alloc] initWithLatitude:37.3317 longitude:-122.0307];
		[gn setDelegate:self];
	}
	
	return self;
}

- (void)awakeFromNib
{
	[responseBox setTitle:[NSString stringWithFormat:@"%f, %f", gn.latitude, gn.longitude]];
}

- (IBAction)startLookup:(id)sender
{
	NSLog(@"startLookup");
	[responseLabel setStringValue:@"Fetching data..."];
	[progress startAnimation:nil];
	[gn findNearbyPlaceName];
	[gn findNearby];
}

- (void)geoLookup:(GeoLookup *)geoLookup didReceiveResponse:(NSDictionary *)responseDict
{
	[responseLabel setStringValue:[responseDict valueForKey:@"name"]];
	[progress stopAnimation:nil];
}

- (void)geoLookup:(GeoLookup *)geoLookup failedWithError:(NSError *)error {
	[responseLabel setStringValue:@"Error fetching URL"];
	[progress stopAnimation:nil];
}

- (void)dealloc
{
	[gn release];
	[super dealloc];
}

@end
