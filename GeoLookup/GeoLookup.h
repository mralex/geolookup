//
//  GeoLookup.h
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

#import <Foundation/Foundation.h>

@interface GeoLookup : NSObject {
	double longitude;
	double latitude;
		
	NSDate *lastLookup;
	
	id delegate;

	NSMutableDictionary *responseDict;
	NSString *currentElement;
	NSMutableString *currentCharacters;
}

@property (assign, readwrite) double longitude;
@property (assign, readwrite) double latitude;
@property (assign) id delegate;

- (id)initWithLatitude:(double)inLatitude longitude:(double)inLongitude;

- (void)findNearby;
- (void)findNearbyPlaceName;
- (void)findNearbyPostalCodes;
- (void)findNearbyStreets;
- (void)findNearbyWeather;


@end

@interface NSObject (GeoLookup)
- (void)geoLookup:(GeoLookup *)geoLookup didReceiveResponse:(NSDictionary *)responseDict;
- (void)geoLookup:(GeoLookup *)geoLookup failedWithError:(NSError *)error;
@end
