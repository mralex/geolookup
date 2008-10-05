//
//  GeoNames.h
//  GeoNamesTest
//
//  Created by Alex Roberts on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

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
