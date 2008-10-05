//
//  GeoNamesRequest.h
//  GeoNamesTest2
//
//  Created by Alex Roberts on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GeoLookupRequest : NSObject {
	NSURLConnection *urlConnection;
	NSTimeInterval timeout;
	
	NSMutableData *receivedData;
	
	id delegate;
}

@property (assign) id delegate;
@property NSTimeInterval timeout;

- (id)initWithTimeout:(NSTimeInterval)inTimeout delegate:(id)inDelegate;

- (void)get:(NSString *)url;

@end

@interface NSObject (GeoLookupRequest)
- (void)request:(GeoLookupRequest *)request didGetData:(NSData *)data;
- (void)request:(GeoLookupRequest *)request failedWithError:(NSError *)error;
@end
