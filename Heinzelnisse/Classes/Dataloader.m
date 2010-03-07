//
//  Dataloader.m
//  Heinzelnisse
//
//  Created by Roman Bertolami on 06.03.10.
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
		[self deleteAllRecords];
		NSLog(@"loading contents of %@", txtFile);
		NSError *error;
		NSString *contents = [NSString stringWithContentsOfFile:txtFile encoding: NSUTF8StringEncoding error: &error];
		NSArray *arrayOfLines = [contents componentsSeparatedByString:@"\n"];
		NSLog(@"done size: %d lines", [arrayOfLines count]);
		for (int i=0 ;i< [arrayOfLines count]; i++) {
			NSString *line= [arrayOfLines objectAtIndex:i];
			NSArray *columns = [line componentsSeparatedByString:@"\t"];
			if([columns count] > 7) {
				Translation *t = [NSEntityDescription insertNewObjectForEntityForName:@"Translation" inManagedObjectContext:managedObjectContext];
				t.wordDE = [columns objectAtIndex:4];
				t.articleDE = [columns objectAtIndex:5];
				t.otherDE = [columns objectAtIndex:7];
				t.wordNO = [columns objectAtIndex:0];
				t.articleNO = [columns objectAtIndex:1];
				t.otherNO = [columns objectAtIndex:3];
			}
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
	NSLog(@"saving context");
	NSError *saveError;
	if(![managedObjectContext save:&saveError]) {
		NSLog(@"error occurred %@", [saveError description]);
	}
	NSLog(@"done");
}
- (void) dealloc {
	[managedObjectContext release];
	[super dealloc];
}
@end
