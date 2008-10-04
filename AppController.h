//
//  AppController.h
//  GeoNamesTest2
//
//  Created by Alex Roberts on 9/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GeoNames;
@interface AppController : NSObject {
	IBOutlet NSTextField *responseLabel;
	IBOutlet NSProgressIndicator *progress;
	
	GeoNames *gn;
	//NSDictionary *responseDict;
	
	BOOL isLookingUp;
}

- (IBAction) startLookup:(id)sender;


@end
