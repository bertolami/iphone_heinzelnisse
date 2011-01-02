//
//  TranslationIntegrationTests.m
//  Heinzelnisse
//
//  Created by Roman Bertolami on 02.01.11.
//  Copyright 2011 Roman Bertolami. All rights reserved.
//

#import "TranslationIntegrationTests.h"
#import "HeinzelnisseAppDelegate.h"


@implementation TranslationIntegrationTests

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void) testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

- (void) testTranslateHaus {
	id heinzelnisseAppDelegate = [[UIApplication sharedApplication] delegate];
   	FirstViewController *firstViewController = [heinzelnisseAppDelegate viewController];

	firstViewController.searchBar.text = @"Haus";
	[firstViewController searchBarSearchButtonClicked: nil];
	
	
}


#else                           // all code under test must be linked into the Unit Test bundle

- (void) testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}



#endif


@end
