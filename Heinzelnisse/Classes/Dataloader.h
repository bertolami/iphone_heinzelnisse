//
//  Dataloader.h
//  Heinzelnisse
//
//  Created by Roman Bertolami on 06.03.10.
//  Copyright 2010 Roman Bertolami. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface Dataloader : NSObject {
	NSManagedObjectContext *managedObjectContext;
}
- (Dataloader*) initWithManagedObjectContext: (NSManagedObjectContext*) ctx;
- (void) load ;
@end
