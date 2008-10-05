//
//  AppController.m
//
//  Created by Alex Roberts on 9/30/08.
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
