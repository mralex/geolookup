//
//  AppController.m
//  GeoNamesTest2
//
//  Created by Alex Roberts on 9/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "GeoNames.h"

@implementation AppController

- (id)init
{
	if (self = [super init]) {
		gn = [[GeoNames alloc] initWithLatitude:37.3317 longitude:-122.0307];
		[gn setDelegate:self];
	}
	
	return self;
}

- (void)awakeFromNib
{
	NSLog(@"Long: %f", gn.longitude);
}

- (IBAction)startLookup:(id)sender
{
	NSLog(@"startLookup");
	[progress startAnimation:nil];
	[gn findNearbyPlaceName];
	[gn findNearby];
}

- (void)geoName:(GeoNames *)geoName didReceiveResponse:(NSDictionary *)responseDict
{
	[responseLabel setStringValue:[responseDict valueForKey:@"name"]];
	[progress stopAnimation:nil];
}

- (void)geoName:(GeoNames *)geoName failedWithError:(NSError *)error {
	[responseLabel setStringValue:@"Error fetching URL"];
	[progress stopAnimation:nil];
}

- (void)dealloc
{
	[gn release];
	[super dealloc];
}

@end
