//
//  GeoNames.h
//  GeoNamesTest
//
//  Created by Alex Roberts on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GeoNamesRequest;

@interface GeoNames : NSObject {
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

@interface NSObject (GeoNames)
- (void)geoName:(GeoNames *)geoName didReceiveResponse:(NSDictionary *)responseDict;
- (void)geoName:(GeoNames *)geoName failedWithError:(NSError *)error;
@end
