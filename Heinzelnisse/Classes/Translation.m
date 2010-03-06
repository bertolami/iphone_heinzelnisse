// 
//  Translation.m
//  Heinzelnisse
//
//  Created by Roman Bertolami on 14.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Translation.h"


@implementation Translation 

@dynamic articleDE;
@dynamic articleNO;
@dynamic otherNO;
@dynamic otherDE;
@dynamic wordDE;
@dynamic wordNO;

- (NSString*) description {
	return [NSString stringWithFormat:@"WordDE: %@ WordNO: %@ ArticleDE: %@ ArticleNO %@ OtherDE %@ OtherNO %@", 
			self.wordDE, self.wordNO, self.articleDE, self.articleNO, self.otherDE, self.otherNO];
}
@end
