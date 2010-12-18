//
//  TranslationTest.m
//  Heinzelnisse
//
//  Created by Roman Bertolami on 28.02.10.
//  Copyright 2010 Roman Bertolami. All rights reserved.Haus
//

#import "TranslationTest.h"
#import "Translation.h"
@implementation TranslationTest
	

- (void) testInitTranslation {
	Translation * t = [[Translation alloc]init];
	STAssertNotNil(t, @"translation is expected to be not nil");
}
	

@end
