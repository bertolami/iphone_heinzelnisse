//
//  HeinzelnisseAppDelegate.m
//  Heinzelnisse
//
//  Created by Roman Bertolami on 01.02.10.
//  Copyright Roman Bertolami 2010. All rights reserved.
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

#import "HeinzelnisseAppDelegate.h"
#import <Foundation/Foundation.h>
#import "FirstViewController.h"
#import "DataManager.h"

@interface HeinzelnisseAppDelegate (Private)
- (NSString*) dbPath;

@end

@implementation HeinzelnisseAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navigationController;
@synthesize loadViewController;

- (BOOL) shouldLoadData: (NSString *) writableDBPath  {
  BOOL loadData=NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(! [fileManager fileExistsAtPath:writableDBPath]) {
		DebugLog(@"DB File not found %@", writableDBPath);
		loadData = YES;
	} else {
		DebugLog(@"DB File found %@", writableDBPath);
		NSError *error;		
		int filesize=[[fileManager attributesOfItemAtPath: writableDBPath error: &error] fileSize];
		DebugLog(@"File Size %d", filesize);
		if (filesize < 1000000) {
			loadData = YES;
		}
	}
  return loadData;
}


- (void) getInitialData:(id)obj  {
	  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	DebugLog(@"Get Initial Data");
	NSString *writableDBPath;
	writableDBPath = [self dbPath];
	DebugLog(@"writable db path %@", writableDBPath);
	dataManager= [[DataManager alloc] initWithManagedObjectContext:self.managedObjectContext dbPath: writableDBPath];
	
	BOOL loadData = [self shouldLoadData: writableDBPath];
	
	if (loadData) {
		[dataManager loadFromTxtFileToCoreDataContext];
	}
	
	DebugLog(@"done");
	[pool release];
	[self performSelectorOnMainThread:@selector(initDone:) withObject:nil waitUntilDone:NO];
}

- (void) initDone:(id)obj {
	self.viewController.managedObjectContext = [self managedObjectContext];
	[loadViewController.view removeFromSuperview];
	
	[window addSubview: self.navigationController.view];
	
	DebugLog(@"Add the controller's current view %@ as a subview of the window %@", self.navigationController.view, window);
	
	
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	InfoLog(@"Starting Heinzelnisse");
	[window addSubview:loadViewController.view];
	
	[self.loadViewController becomeFirstResponder];
	[window bringSubviewToFront:loadViewController.view];
	
	[NSThread detachNewThreadSelector:@selector(getInitialData:) 
							 toTarget:self withObject:nil];
	
	
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator {
	if(persistentStoreCoordinator != nil) {
		return persistentStoreCoordinator;
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath: [self dbPath]];
	

	NSError *error = nil;
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] 
								  initWithManagedObjectModel:[self managedObjectModel]];
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
												  configuration:nil 
															URL:storeUrl 
														options:nil 
														  error:&error]) {
															  
		DebugLog(@"Error occurred %@", [error localizedDescription]);
	}
	return persistentStoreCoordinator;
}

-(NSManagedObjectModel*) managedObjectModel {
	if (managedObjectModel != nil) {
		return managedObjectModel;
	}
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil]
						  retain];
	return managedObjectModel;
}

- (NSManagedObjectContext*) managedObjectContext {
	if(managedObjectContext != nil) {
		return managedObjectContext;
	}
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if(coordinator != nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator:coordinator];
		[managedObjectContext setUndoManager:nil];
	}
	return managedObjectContext;
}

- (NSString *) dbPath {
    NSString *writableDBPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"heinzelnisse.db"];
	return writableDBPath;
}

- (NSString *)applicationDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask,
														 YES);
	NSString *basePath = nil;
	if([paths count] > 0) {
		basePath = [paths objectAtIndex:0];
	}
	return basePath;
}

- (void)didReceiveMemoryWarning
{ 
	WarningLog(@"Memory Warning");
	// default behavior is to release the view if it doesn't have a superview.
	
	// remember to clean up anything outside of this view's scope, such as
	// data cached in the class instance and other global data.
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	[dataManager release];
	[persistentStoreCoordinator release];
	[managedObjectModel release];
	[managedObjectContext release];
    [viewController release];
	[loadViewController release];
	[navigationController release];
    [window release];
    [super dealloc];
}

@end

