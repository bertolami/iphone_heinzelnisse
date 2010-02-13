//
//  DBAccessTest.m
//  Heinzelnisse
//
//  Created by Roman Bertolami on 13.02.10.
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

#import "DBAccessTest.h"


@implementation DBAccessTest

- (void) testDBOpenSucceeds {
	NSString *filename = @"/Users/bertolam/Documents/iPhone Apps/iphone_heinzelnisse/Heinzelnisse/heinzelnisse.db";
//	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentFolderPath = [searchPaths objectAtIndex:0];
	sqlite3 *db;
	NSLog(@"Running db test %@",filename);
	int dbrc =sqlite3_open([filename UTF8String], &db);
	if(dbrc) {
		STFail(@"Unable to open db %d", dbrc);
	}
	sqlite3_close(db);
}
@end
