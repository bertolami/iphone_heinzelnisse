//
//  TranslationDetailViewController.h
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

#import <UIKit/UIKit.h>
#import "Translation.h"

@interface TranslationDetailViewController : UIViewController {
	IBOutlet UILabel *originalWord;
	IBOutlet UILabel *translatedWord;
	IBOutlet UILabel *translatedArticle;
	IBOutlet UILabel *translatedOther;
}

@property(nonatomic, retain) IBOutlet UILabel *originalWord;
@property(nonatomic, retain) IBOutlet UILabel *translatedWord;
@property(nonatomic, retain) IBOutlet UILabel *translatedArticle;
@property(nonatomic, retain) IBOutlet UILabel *translatedOther;

- (IBAction) back;
- (void) setDE_NOTranslation:(Translation*) aTranslation;
- (void) setNO_DETranslation:(Translation*) aTranslation;
@end
