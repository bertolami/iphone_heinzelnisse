//
//  FirstViewController.m
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

#import "FirstViewController.h"
#import <stdlib.h>
@interface FirstViewController (Private)

- (NSString*) sortColumn;
- (NSUInteger) numberOfRowsInSection: (NSInteger) section;
- (BOOL) isDE_NO;
- (void) executeSearch;
@end


@implementation FirstViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize searchBar;
@synthesize tableView;
@synthesize queryText;
@synthesize translationDetailViewController;

- (void) viewDidLoad {
	[super viewDidLoad];
	[searchBar becomeFirstResponder];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	NSLog(@"controller will change content");
    [self.tableView beginUpdates];
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	NSLog(@"controller did change content");
    [self.tableView endUpdates];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
	NSLog(@"selectedScopeButtonIndexDidChange");
	[self executeSearch];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
	NSLog(@"searchButtonClicked");
	[self executeSearch];
}

- (void) executeSearch {
	self.fetchedResultsController = nil;
	self.queryText = self.searchBar.text;
	NSError *error = nil;
	if(![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Error occurred %@", error);
	}
	NSLog(@"Result size ", [self numberOfRowsInSection:0]);
	[self.tableView reloadData];
	[tableView setContentOffset:CGPointMake(0, 0) animated:NO];
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Translation *translation = [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSLog(@"Selected %@ adding to controller %@", translation, self.translationDetailViewController);
	if([self isDE_NO]) {
		[self.translationDetailViewController setDE_NOTranslation:translation];
	} else {
		[self.translationDetailViewController setNO_DETranslation:translation];	
	}
	
	[self.navigationController pushViewController:self.translationDetailViewController animated:YES];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSUInteger count = [[self.fetchedResultsController sections] count];
    NSLog(@"numberOfSectionsInTableView %d", count);
    
	if (count == 0) {
        count = 1;
    }
    return count;
}

- (NSUInteger) numberOfRowsInSection: (NSInteger) section  {
	NSArray *sections = [self.fetchedResultsController sections];
    NSUInteger count = 0;
    if ([sections count]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        count = [sectionInfo numberOfObjects];
    }
	NSLog(@"numberOfRowsInSection %d", count);
    
	return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = [self numberOfRowsInSection: section];
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    Translation *translation = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = [self isDE_NO] ? translation.wordDE : translation.wordNO;
	cell.detailTextLabel.text = [self isDE_NO] ? translation.wordNO : translation.wordDE;		
	return cell;
}

-(NSFetchedResultsController*) fetchedResultsController {
	if(fetchedResultsController !=nil) {
		return fetchedResultsController;
	}
	NSLog(@"Building Fetch Result Controller");
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Translation" 
											  inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	NSString *pattern = [[queryText stringByAppendingString:@"*"] stringByAppendingString:@"*"];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like[cd] %@", [self sortColumn], pattern];
	
	[fetchRequest setPredicate:predicate];
	NSLog(@"Fetch Request %@", fetchRequest);
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: [self sortColumn] ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
															 initWithFetchRequest:fetchRequest
															 managedObjectContext:managedObjectContext 
															 sectionNameKeyPath:nil 
															 cacheName:@"Root"];
	aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	
	return fetchedResultsController;
}
	 
- (NSString*) sortColumn {
	return [self isDE_NO] ? @"wordDE" : @"wordNO";
	
}
- (BOOL) isDE_NO {
	return searchBar.selectedScopeButtonIndex == 0;
}
 - (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
