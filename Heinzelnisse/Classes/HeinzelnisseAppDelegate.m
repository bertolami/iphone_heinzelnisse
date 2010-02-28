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

@implementation HeinzelnisseAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    NSArray *viewControllers = tabBarController.viewControllers;
	FirstViewController *firstView = (FirstViewController*) [viewControllers objectAtIndex:0];
	firstView.managedObjectContext = managedObjectContext;
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator {
	if(persistentStoreCoordinator != nil) {
		return persistentStoreCoordinator;
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] 
											   stringByAppendingFormat: @"heinzelnisse.db"]];

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
	[persistentStoreCoordinator release];
	[managedObjectModel release];
	[managedObjectContext release];
	
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

