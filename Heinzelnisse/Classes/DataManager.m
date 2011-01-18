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

#import "DataManager.h"
#import "Translation.h"
#import "StringNormalizer.h"

@interface DataManager (Private)

-(void) saveContext;

@end

@implementation DataManager

- (DataManager*) initWithManagedObjectContext: (NSManagedObjectContext*) ctx dbPath: (NSString*)path {
	self = [super init];
	if(self != nil) {
		DebugLog(@"Initializing Dataloader");
		[ctx retain];
		managedObjectContext = ctx;
		dbPath = path;
	}
	return self;
}


- (void) loadFromTxtFileToCoreDataContext {
	// double before = [[NSDate date] timeIntervalSince1970];
	DebugLog(@"loadFromTxtFileToCoreDataContext start");
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *txtFile = [[NSBundle mainBundle] pathForResource:@"heinzelliste" ofType:@"txt"];
	if(! [fileManager fileExistsAtPath:txtFile]) {
		DebugLog(@"Heinzelliste text file not found %@", txtFile);
	} else {
		DebugLog(@"loading contents of %@", txtFile);
		NSError *error;
		NSUInteger count = 0, LOOP_LIMIT = 8000; // batch size
		Translation *t = nil;
		
		NSString *contents = [[NSString alloc] initWithContentsOfFile:txtFile encoding: NSUTF8StringEncoding error: &error];
		NSArray *arrayOfLines = [contents componentsSeparatedByString:@"\n"];
		[contents release];
		DebugLog(@"done size: %d lines", [arrayOfLines count]);
		NSAutoreleasePool *innerPool = [[NSAutoreleasePool alloc] init];
		for (int i=0 ;i< [arrayOfLines count]; i++) {
			count++;
			if(count == LOOP_LIMIT) {
				[self saveContext];
				count = 0;
				[innerPool drain];
				innerPool = [[NSAutoreleasePool alloc] init];
			}
			NSString *line= [arrayOfLines objectAtIndex:i];
			NSArray *columns = [line componentsSeparatedByString:@"\t"];
			if([columns count] > 7) {
				t = [NSEntityDescription insertNewObjectForEntityForName:@"Translation" inManagedObjectContext:managedObjectContext];
				t.wordDE = [columns objectAtIndex:4];
				t.wordDENorm = [StringNormalizer normalizeString:[columns objectAtIndex:4]];
				t.articleDE = [columns objectAtIndex:5];
				t.relatedDE = [[[columns objectAtIndex:6] componentsSeparatedByString:@";"] componentsJoinedByString:@", "];
				t.otherDE = [columns objectAtIndex:7];
				t.wordNO = [columns objectAtIndex:0];
				t.wordNONorm = [StringNormalizer normalizeString:[columns objectAtIndex:0]];
				t.articleNO = [columns objectAtIndex:1];
				t.relatedNO = [[[columns objectAtIndex:2] componentsSeparatedByString:@";"] componentsJoinedByString:@", "];
				t.otherNO = [columns objectAtIndex:3];
			}
		}
		[self saveContext];
		[innerPool drain];
	}

	[pool release];
//	double after = [[NSDate date] timeIntervalSince1970];
	
	//ErrorLog(@"loadFromTxtFileToCoreDataContext done %0.4f", (after - before));
	
	
}


- (void) saveContext{
	NSError *saveError;
	if(![managedObjectContext save:&saveError]) {
		ErrorLog(@"error occurred %@", [saveError description]);
	}
	[managedObjectContext reset];
}

- (void) dealloc {
	[managedObjectContext release];
	[super dealloc];
}
@end
