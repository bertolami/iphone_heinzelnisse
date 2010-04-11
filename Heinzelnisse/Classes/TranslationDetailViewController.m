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


@implementation TranslationDetailViewController

@synthesize originalWord;
@synthesize translatedWord;
@synthesize translatedArticle;
@synthesize translatedOther;


- (IBAction) back {
	[self.navigationController popViewControllerAnimated:YES];
}


- (void) setDE_NOTranslation:(Translation*) aTranslation {
	NSLog(@"setting DE NO Translation");
	originalWord.text = aTranslation.wordDE;
	translatedWord.text = aTranslation.wordNO;
	translatedArticle.text = aTranslation.articleNO;
	translatedOther.text = aTranslation.otherNO;
	[self.view setNeedsLayout];
	
}

- (void) setNO_DETranslation:(Translation*) aTranslation {
	NSLog(@"setting NO DE Translation");
	originalWord.text = aTranslation.wordNO;
	translatedWord.text = aTranslation.wordDE;
	translatedArticle.text = aTranslation.articleDE;
	translatedOther.text = aTranslation.otherDE;
	[self.view setNeedsDisplay];

}


 


- (void)dealloc {
    [super dealloc];
}


@end
