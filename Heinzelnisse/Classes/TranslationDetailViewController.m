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
	if([translation.articleDE length] >0) {
		articleDE.text = [NSString stringWithFormat:@"(%@)",translation.articleDE];
	} else {
		articleDE.text = @"";
	}

	otherDE.text = translation.otherDE;
	relatedDE.text = translation.relatedDE;
	wordNO.text = translation.wordNO;
	if([translation.articleNO length] >0) {
		articleNO.text = [NSString  stringWithFormat:@"(%@)",translation.articleNO];
	} else {
		articleNO.text = @"";
	}

	otherNO.text = translation.otherNO;
	relatedNO.text = translation.relatedNO;
	
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
