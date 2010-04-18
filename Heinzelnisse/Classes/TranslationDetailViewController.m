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
- (void) applyDE_NOTranslation;
- (void) applyNO_DETranslation;
@end


@implementation TranslationDetailViewController


@synthesize originalWord;
@synthesize translatedWord;
@synthesize translatedArticle;
@synthesize translatedOther;
@synthesize translation;
@synthesize translationDirection;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if([self.translationDirection isEqual:@"DE_NO"]) {
		[self applyDE_NOTranslation];
	} else {
		[self applyNO_DETranslation];
	}	
}

- (IBAction) back {
	[self.navigationController popViewControllerAnimated:YES];
}


- (void) setDE_NOTranslation:(Translation*) aTranslation {		
	self.translation = aTranslation;
	self.translationDirection = @"DE_NO";
}

- (void) applyDE_NOTranslation {
	originalWord.text = translation.wordDE;
	translatedWord.text = translation.wordNO;
	translatedArticle.text = translation.articleNO;
	translatedOther.text = translation.otherNO;
	
}
- (void) setNO_DETranslation:(Translation*) aTranslation {
	self.translation = aTranslation;
	self.translationDirection = @"NO_DE";
}

- (void) applyNO_DETranslation {
	originalWord.text = translation.wordNO;
	translatedWord.text = translation.wordDE;
	translatedArticle.text = translation.articleDE;
	translatedOther.text = translation.otherDE;
}


 


- (void)dealloc {
	[translatedWord dealloc];
	[translatedArticle dealloc];
	[translatedOther dealloc];
	[originalWord dealloc];
	[translation dealloc];
	[translationDirection dealloc];
    [super dealloc];
}


@end
