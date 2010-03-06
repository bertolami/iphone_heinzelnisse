//
//  Dataloader.m
//  Heinzelnisse
//
//  Created by Roman Bertolami on 06.03.10.
//  Copyright 2010 Roman Bertolami. All rights reserved.
//

#import "Dataloader.h"
#import "Translation.h"

@interface Dataloader (Private)

-(void) saveContext;
-(void) deleteAllRecords;

@end

@implementation Dataloader

- (Dataloader*) initWithManagedObjectContext: (NSManagedObjectContext*) ctx {
	self = [super init];
	if(self != nil) {
		NSLog(@"Initializing Dataloader");
		[ctx retain];
		managedObjectContext = ctx;
	}
	return self;
}


- (void) load {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *txtFile = [[NSBundle mainBundle] pathForResource:@"heinzelliste" ofType:@"txt"];
	if(! [fileManager fileExistsAtPath:txtFile]) {
		NSLog(@"Heinzelliste text file not found %@", txtFile);
		
	} else {
	//	[self deleteAllRecords];
		NSLog(@"loading contents of %@", txtFile);
		NSError *error;
		NSString *contents = [NSString stringWithContentsOfFile:txtFile encoding: NSUTF8StringEncoding error: &error];
		NSArray *arrayOfLines = [contents componentsSeparatedByString:@"\n"];
		NSLog(@"done size: %d lines", [arrayOfLines count]);
		for (int i=0 ;i< 10; i++) {
			NSString *line= [arrayOfLines objectAtIndex:i];
			NSArray *columns = [line componentsSeparatedByString:@"\t"];
			Translation *t = [NSEntityDescription insertNewObjectForEntityForName:@"Translation" inManagedObjectContext:managedObjectContext];
			t.wordDE = [columns objectAtIndex:1];
			t.articleDE = [columns objectAtIndex:2];
			t.otherDE = [columns objectAtIndex:3];
			t.wordNO = [columns objectAtIndex:4];
			t.articleNO = [columns objectAtIndex:5];
			NSLog(@"%d", i);
		}
		[self saveContext];
	}

	
}

-(void) deleteAllRecords {
	NSFetchRequest * fetch = [[[NSFetchRequest alloc] init] autorelease];
	[fetch setEntity:[NSEntityDescription entityForName:@"Translation" inManagedObjectContext:managedObjectContext]];
	NSArray * result = [managedObjectContext executeFetchRequest:fetch error:nil];
	for (id basket in result){
		[managedObjectContext deleteObject:basket];
	}		
	[self saveContext];
}

- (void) saveContext{
	
	NSError *saveError;
	[managedObjectContext save:&saveError];
	if(saveError != nil){
		NSLog(@"error occurred %@", saveError);
	}
}
- (void) dealloc {
	[managedObjectContext release];
	[super dealloc];
}
@end
