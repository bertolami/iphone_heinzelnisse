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
-(void) deleteAllRecords;

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
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *txtFile = [[NSBundle mainBundle] pathForResource:@"heinzelliste" ofType:@"txt"];
	if(! [fileManager fileExistsAtPath:txtFile]) {
		DebugLog(@"Heinzelliste text file not found %@", txtFile);
		
	} else {
		[self deleteAllRecords];
		DebugLog(@"loading contents of %@", txtFile);
		NSError *error;
		NSString *contents = [[NSString alloc] initWithContentsOfFile:txtFile encoding: NSUTF8StringEncoding error: &error];
		NSArray *arrayOfLines = [contents componentsSeparatedByString:@"\n"];
		[contents release];
		DebugLog(@"done size: %d lines", [arrayOfLines count]);
		for (int i=0 ;i< [arrayOfLines count]; i++) {
			NSString *line= [arrayOfLines objectAtIndex:i];
			NSArray *columns = [line componentsSeparatedByString:@"\t"];
			if([columns count] > 7) {
				Translation *t = [NSEntityDescription insertNewObjectForEntityForName:@"Translation" inManagedObjectContext:managedObjectContext];
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
	}

	[pool release];
	
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
	DebugLog(@"saving context");
	NSError *saveError;
	if(![managedObjectContext save:&saveError]) {
		ErrorLog(@"error occurred %@", [saveError description]);
	}
	DebugLog(@"done");
}

// deprecated
- (void) createIndex {
	DebugLog(@"creating index for db %@", dbPath);
	NSString *createIndexWordDE = @"CREATE INDEX INDEX_ON_ZWORDDE ON ZTRANSLATION (ZWORDDE)";
	const char *sqlStatement = [createIndexWordDE UTF8String]; 
	sqlite3 *db;
	int dbrc = sqlite3_open([dbPath UTF8String], &db);
	if(dbrc) {
		WarningLog(@"couldn't open db at path: @%", dbPath);
		return;
	}
	int res = sqlite3_exec(db,sqlStatement, NULL, NULL, NULL);
	DebugLog(@"finished creating index: %d",res);
	sqlite3_close(db);
}
- (void) dealloc {
	[managedObjectContext release];
	[super dealloc];
}
@end
