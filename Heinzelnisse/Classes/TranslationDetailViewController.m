//
//  TranslationDetailViewController.m
//  Heinzelnisse
//
//  Created by Roman Bertolami on 09.04.10.
//  Copyright 2010 Roman Bertolami. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#import "TranslationDetailViewController.h"
#import "Translation.h"


@interface TranslationDetailViewController (Private)
- (void) applyTranslation;
- (NSString*) buildText:(NSString*) originalText defaultText: (NSString*) defaultText;
- (NSString*) buildText:(NSString*) originalText originalFormat: originalFormat defaultText: (NSString*) defaultText;
@end


@implementation TranslationDetailViewController

@synthesize translationDirection;
@synthesize translation;
@synthesize wordDE;
@synthesize articleDE;
@synthesize otherDE;
@synthesize relatedDE;
@synthesize wordNO;
@synthesize articleNO;
@synthesize otherNO;
@synthesize relatedNO;


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self applyTranslation];
	
}

- (IBAction) back {
	[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touches began %@", event);
}

- (void) setDE_NOTranslation:(Translation*) aTranslation {		
	self.translation = aTranslation;
	self.translationDirection = @"DE_NO";
}

- (void) applyTranslation {
	wordDE.text = translation.wordDE;
	articleDE.text = [self buildText:translation.articleDE originalFormat: @"(%@)" defaultText:@""];
	otherDE.text = [self buildText: translation.otherDE defaultText: @""];
	relatedDE.text = [self buildText: translation.relatedDE defaultText: @"-"];
	wordNO.text = translation.wordNO;
	articleNO.text = [self buildText:translation.articleNO originalFormat: @"(%@)" defaultText:@""];
	otherNO.text = [self buildText: translation.otherNO  defaultText: @""];
	relatedNO.text = [self buildText: translation.relatedNO defaultText: @"-"];
	
}

- (NSString*) buildText:(NSString*) originalText defaultText: (NSString*) defaultText {
	if([originalText length] > 0) {
		return originalText;
	} 
	return [self buildText:originalText originalFormat: @"%@" defaultText:defaultText];
} 

- (NSString*) buildText:(NSString*) originalText originalFormat: originalFormat defaultText: (NSString*) defaultText {
	if([originalText length] > 0) {
		return [NSString  stringWithFormat:originalFormat,originalText];
	} 
	return defaultText;
} 

- (void) setNO_DETranslation:(Translation*) aTranslation {
	self.translation = aTranslation;
	self.translationDirection = @"NO_DE";
}

 


- (void)dealloc {
	[wordDE dealloc];
	[articleDE dealloc];
	[otherDE dealloc];
	[relatedDE dealloc];
	[wordNO dealloc];
	[articleNO dealloc];
	[otherNO dealloc];
	[relatedNO dealloc];
	[translation dealloc];
	[translationDirection dealloc];
    [super dealloc];
}


@end
