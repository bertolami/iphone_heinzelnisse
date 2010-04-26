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
	IBOutlet UILabel *wordDE;
	IBOutlet UILabel *articleDE;
	IBOutlet UILabel *otherDE;
	IBOutlet UILabel *relatedDE;
	IBOutlet UILabel *wordNO;
	IBOutlet UILabel *articleNO;
	IBOutlet UILabel *otherNO;
	IBOutlet UILabel *relatedNO;
	Translation *translation;
	NSString *translationDirection;
}

@property(nonatomic, retain) IBOutlet UILabel *wordDE;
@property(nonatomic, retain) IBOutlet UILabel *articleDE;
@property(nonatomic, retain) IBOutlet UILabel *otherDE;
@property(nonatomic, retain) IBOutlet UILabel *relatedDE;
@property(nonatomic, retain) IBOutlet UILabel *wordNO;
@property(nonatomic, retain) IBOutlet UILabel *articleNO;
@property(nonatomic, retain) IBOutlet UILabel *otherNO;
@property(nonatomic, retain) IBOutlet UILabel *relatedNO;
@property(nonatomic, retain) Translation *translation;
@property(nonatomic, retain) NSString *translationDirection;

- (IBAction) back;
- (void) setDE_NOTranslation:(Translation*) aTranslation;
- (void) setNO_DETranslation:(Translation*) aTranslation;
@end
