//
//  HeinzelnisseAppDelegate.h
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

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface HeinzelnisseAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	UIWindow *window;
    UITabBarController *tabBarController;
}

@property(nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
