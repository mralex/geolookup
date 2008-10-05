//
//  GeoNamesRequest.m
//  GeoNamesTest2
//
//  Created by Alex Roberts on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GeoLookupRequest.h"

NSString *GeoLookupUserAgent = @"GeoNames/Obj-C 1.0";

@interface GeoLookupRequest (Private)
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end

@implementation GeoLookupRequest

@synthesize timeout;
@synthesize delegate;

- (id)initWithTimeout:(NSTimeInterval)inTimeout delegate:(id)inDelegate
{
	if (self = [super init]) {
		self.timeout = inTimeout;
		self.delegate = inDelegate;
	}
	
	return self;
}

- (void)get:(NSString *)url
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:self.timeout];

	[request setValue:GeoLookupUserAgent forHTTPHeaderField:@"User-Agent"];
	
	// create the connection with the request
	// and start loading the data
	urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

	if (urlConnection) {
		receivedData = [[NSMutableData data] retain];
	} else {
		NSLog(@"Error occured setting up URL Connection");
	}
	
}

- (void) dealloc
{
	[receivedData release];
	[urlConnection release];
	
	[super dealloc];
}

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"received response");
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Data received! Hooray! %d bytes", [receivedData length]);
	
	if ([delegate respondsToSelector:@selector(request:didGetData:)]) {
		[delegate request:self didGetData:receivedData];
	}
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

	if ([delegate respondsToSelector:@selector(request:failedWithError:)]) {
		[delegate request:self failedWithError:error];
	}
	
}


@end
