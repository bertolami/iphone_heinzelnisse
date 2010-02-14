//
//  Translation.h
//  Heinzelnisse
//
//  Created by Roman Bertolami on 14.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Translation :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * articleDE;
@property (nonatomic, retain) NSString * articleNO;
@property (nonatomic, retain) NSString * otherNO;
@property (nonatomic, retain) NSString * otherDE;
@property (nonatomic, retain) NSString * wordDE;
@property (nonatomic, retain) NSString * wordNO;

@end



