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


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *writableDBPath;
	writableDBPath = [self dbPath];

	dataManager= [[DataManager alloc] initWithManagedObjectContext:self.managedObjectContext dbPath: writableDBPath];
	
	BOOL loadData=NO;
    if(! [fileManager fileExistsAtPath:writableDBPath]) {
		NSLog(@"DB File not found %@", writableDBPath);
		loadData = YES;
	} else {
		NSLog(@"DB File found %@", writableDBPath);
		int filesize=[[fileManager attributesOfItemAtPath: writableDBPath error: &error] fileSize];
		NSLog(@"File Size %d", filesize);
		if (filesize < 1000000) {
			loadData = YES;
		}
	}
	if (loadData) {
		[dataManager loadFromTxtFileToCoreDataContext];
	}
//	[dataManager createIndex];
	self.viewController.managedObjectContext = [self managedObjectContext];
 
	NSLog(@"Add the controller's current view %@ as a subview of the window %@", self.navigationController.view, window);
	[window addSubview: self.navigationController.view];
	NSLog(@"done");
	
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
															  
		NSLog(@"Error occurred %@", [error localizedDescription]);
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
	}
	return managedObjectContext;
}
/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

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

- (void)dealloc {
	[dataManager release];
	[persistentStoreCoordinator release];
	[managedObjectModel release];
	[managedObjectContext release];
    [viewController release];
	[navigationController release];
    [window release];
    [super dealloc];
}

@end

