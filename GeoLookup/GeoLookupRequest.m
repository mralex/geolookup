//
//  GeoLookupRequest.m
//
//  Created by Alex Roberts on 10/1/08.
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

#import "GeoLookupRequest.h"

NSString *GeoLookupUserAgent = @"GeoLookup/Obj-C 1.0";

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
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
													   timeoutInterval:self.timeout];

	[request setValue:GeoLookupUserAgent forHTTPHeaderField:@"User-Agent"];
	
	// create the connection with the request
	// and start loading the data
	NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

	if (urlConnection) {
		NSLog(@"URL Connection to: %@", url);
		receivedData = [[NSMutableData data] retain];
	} else {
		NSLog(@"Error occured setting up URL Connection");
	}
	
}

- (void) dealloc
{
	[receivedData release];
	//[urlConnection release];
	
	[super dealloc];
}

#pragma mark NSURLConnection delegate methods


- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
	NSLog(@"Gotta redirect.");
	NSLog(@"Proposal: %@", [[request URL] absoluteString]);
	return request;
}

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
	
	[connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

	if ([delegate respondsToSelector:@selector(request:failedWithError:)]) {
		[delegate request:self failedWithError:error];
	}

	[connection release];
}


@end
