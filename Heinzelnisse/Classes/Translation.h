//
//  Translation.h
//  Heinzelnisse
//
//  Created by Roman Bertolami on 02.01.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Translation :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * wordNONorm;
@property (nonatomic, retain) NSString * wordDE;
@property (nonatomic, retain) NSString * otherNO;
@property (nonatomic, retain) NSString * relatedNO;
@property (nonatomic, retain) NSString * articleNO;
@property (nonatomic, retain) NSString * otherDE;
@property (nonatomic, retain) NSString * articleDE;
@property (nonatomic, retain) NSString * wordNO;
@property (nonatomic, retain) NSString * relatedDE;
@property (nonatomic, retain) NSString * wordDENorm;

@end



