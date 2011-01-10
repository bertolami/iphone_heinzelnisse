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
#import "StringNormalizer.h"
#import <stdlib.h>

@interface FirstViewController (Private)

- (NSString*) sortColumn;
- (BOOL) isDE_NO;
- (void) executeSearch;
- (NSString*) stringWithDETranslation: (Translation*) aTranslation;
- (NSString*) stringWithNOTranslation: (Translation*) aTranslation;
- (NSPredicate*) buildPredicate;
@end


@implementation FirstViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize searchBar;
@synthesize tableView;
@synthesize queryText;
@synthesize translationDetailViewController;
//@synthesize activityIndicatorView;


- (void) viewDidLoad {
	DebugLog(@"view did load");
	[super viewDidLoad];
//	activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//	activityIndicatorView.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
//	activityIndicatorView.center = self.view.center;
	// pre-parse predicate for quick substitution
    predicateTemplateDE = [[NSPredicate predicateWithFormat:@"wordDENorm >= $lowBound and wordDENorm < $highBound"] retain];
    predicateTemplateNO = [[NSPredicate predicateWithFormat:@"wordNONorm >= $lowBound and wordNONorm < $highBound"] retain];
	
}

- (void) viewDidAppear:(BOOL)animated {
	DebugLog(@"view did appear");
//	[self.view addSubview: activityIndicatorView];
	
	[super viewDidAppear:animated];
	[searchBar becomeFirstResponder];
	
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	DebugLog(@"controller will change content");
    [self.tableView beginUpdates];
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	DebugLog(@"controller did change content");
    [self.tableView endUpdates];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
	DebugLog(@"selectedScopeButtonIndexDidChange");
	[self executeSearch];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
	DebugLog(@"searchButtonClicked");
	[self executeSearch];
}

- (void) executeSearch {
	
	self.queryText = self.searchBar.text;
	if(! queryText) {
		return;
	}
	
	[searchBar resignFirstResponder];
//	[NSThread detachNewThreadSelector: @selector(spinBegin) toTarget:self withObject:nil];

	self.fetchedResultsController = nil;
		NSError *error = nil;
	if(![self.fetchedResultsController performFetch:&error]) {
		ErrorLog(@"Error occurred %@", error);
	}
//	[NSThread detachNewThreadSelector: @selector(spinEnd) toTarget:self withObject:nil];
	[self.tableView reloadData];
	[tableView setContentOffset:CGPointMake(0, 0) animated:NO];

}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Translation *translation = [self.fetchedResultsController objectAtIndexPath:indexPath];
	if([self isDE_NO]) {
		[self.translationDetailViewController setDE_NOTranslation:translation];
	} else {
		[self.translationDetailViewController setNO_DETranslation:translation];	
	}
	
	[self.navigationController pushViewController:self.translationDetailViewController animated:YES];

}
/*
- (void)spinBegin {
	[activityIndicatorView startAnimating];
}

- (void)spinEnd {
	[activityIndicatorView stopAnimating];
}
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSUInteger count = 0;
	if(fetchedResultsController) {
		count = [[self.fetchedResultsController sections] count];		
	}
	if (count == 0) {
		count = 1;
	}
	DebugLog(@"numberOfSectionsInTableView %d", count);
	return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    if(fetchedResultsController) {
		
		NSArray *sections = [self.fetchedResultsController sections];
		
		if ([sections count]) {
			id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
			count = [sectionInfo numberOfObjects];
		}
	}
	DebugLog(@"numberOfRowsInSection %d", count);
	return count;
	
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    Translation *translation = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = [self isDE_NO] ? [self stringWithDETranslation: translation] : [self stringWithNOTranslation:translation];
	cell.detailTextLabel.text = [self isDE_NO] ? [self stringWithNOTranslation: translation] : [self stringWithDETranslation:translation];		
	return cell;
}

- (NSString*) stringWithDETranslation: (Translation*) translation{
	if([translation.articleDE length] > 0) {
		return [NSString stringWithFormat:@"%@ (%@)", translation.wordDE, translation.articleDE];		
	} else {
		return translation.wordDE;
	}

}

- (NSString*) stringWithNOTranslation: (Translation*) translation{
	if([translation.articleNO length] > 0) {
		return [NSString stringWithFormat:@"%@ (%@)", translation.wordNO, translation.articleNO];
	} else {
		return translation.wordNO;
	}

}


- (NSPredicate*) buildPredicate   {
	NSPredicate * predicate;
	NSString *lowBound = [StringNormalizer normalizeString: queryText];
    NSString *highBound = [StringNormalizer upperBoundSearchString: lowBound];
    
    NSMutableDictionary *bindVariables = [[NSMutableDictionary alloc] init];
    [bindVariables setObject:lowBound forKey:@"lowBound"];
    [bindVariables setObject:highBound forKey:@"highBound"];
    
	if([self isDE_NO]) {
		predicate = [predicateTemplateDE predicateWithSubstitutionVariables:bindVariables];
	} else {
		predicate = [predicateTemplateNO predicateWithSubstitutionVariables:bindVariables];
	}

	[bindVariables release];
	return predicate;
}
-(NSFetchedResultsController*) fetchedResultsController {
	if(fetchedResultsController) {
		return fetchedResultsController;
	}
	DebugLog(@"Building Fetch Result Controller");
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Translation" 
											  inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	// [fetchRequest setFetchLimit:1000];
	
	NSPredicate *predicate = [self buildPredicate];

	
	[fetchRequest setPredicate:predicate];
	DebugLog(@"Fetch Request %@", fetchRequest);
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: [self sortColumn] ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
															 initWithFetchRequest:fetchRequest
															 managedObjectContext:managedObjectContext 
															 sectionNameKeyPath:nil 
															 cacheName:nil];
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
 

- (void)dealloc {
  //	 [activityIndicatorView dealloc];
	[super dealloc];
	
}

@end
