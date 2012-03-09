//
//  RCSTable.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableSection, RCSTableRow, RCSTableDefinition, RCSTableViewController;

@interface RCSTable : NSObject

@property (nonatomic, readonly, strong) RCSTableDefinition *definition;
@property (nonatomic, readonly, unsafe_unretained) NSObject *object;
@property (nonatomic, readonly, strong) NSMutableArray *sections;
@property (nonatomic, readonly, unsafe_unretained) RCSTableViewController *controller; // parent

- (id) initUsingDefintion: (RCSTableDefinition *)definition_
		   withRootObject: (NSObject *)object_
		forViewController: (RCSTableViewController *)controller_;

- (NSString *) title;
- (NSString *) tableHeaderImagePath;

- (NSInteger) numberOfSections;
- (RCSTableSection *) sectionAtIndex: (NSInteger)section;
- (NSInteger) numberOfRowsInSection: (NSInteger)section_;
- (RCSTableRow *) rowAtIndexPath: (NSIndexPath *)indexPath;
- (BOOL) isEditableAtIndexPath: (NSIndexPath *)indexPath;
- (NSString *) cellReuseIdentifierAtIndexPath: (NSIndexPath *)indexPath;
- (UITableViewCell *) cellForRowAtIndexPath: (NSIndexPath *)indexPath;

@end

/*
 * Copyright 2009-2012 Jim Roepcke <jim@roepcke.com>. All rights reserved.
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
