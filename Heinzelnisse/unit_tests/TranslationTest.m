//
//  TranslationTest.m
//  Heinzelnisse
//
//  Created by Roman Bertolami on 28.02.10.
//  Copyright 2010 Roman Bertolami. All rights reserved.
//

#import "TranslationTest.h"

@implementation TranslationTest
	

- (void) testInitTranslation {
	Translation * t = [[Translation alloc]init];
	
	STAssertNotNil(t, @"translation is expected to be not nil");
}
	

@end
