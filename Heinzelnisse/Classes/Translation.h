//
//  Translation.h
//  Heinzelnisse
//
//  Created by Roman Bertolami on 14.02.10.
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

#import <CoreData/CoreData.h>


@interface Translation :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * articleDE;
@property (nonatomic, retain) NSString * articleNO;
@property (nonatomic, retain) NSString * otherNO;
@property (nonatomic, retain) NSString * otherDE;
@property (nonatomic, retain) NSString * wordDE;
@property (nonatomic, retain) NSString * wordNO;
@property (nonatomic, retain) NSString * relatedDE;
@property (nonatomic, retain) NSString * relatedNO;
@end



