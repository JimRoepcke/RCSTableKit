//
//  RCSTable.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableSection, RCSTableRow, RCSTableDefinition, RCSTableViewController;

@interface RCSTable : NSObject
{
	RCSTableDefinition *_definition;
	NSObject *_object;
	RCSTableViewController *_controller; // parent
	NSMutableArray *_sections; // children (RCSTableSection)
}

@property (nonatomic, readonly, retain) RCSTableDefinition *definition;
@property (nonatomic, readonly, assign) NSObject *object;
@property (nonatomic, readonly, retain) NSMutableArray *sections;
@property (nonatomic, readonly, assign) RCSTableViewController *controller; // parent

- (id) initUsingDefintion: (RCSTableDefinition *)definition_
		   withRootObject: (NSObject *)object_
		forViewController: (RCSTableViewController *)controller_;

- (NSString *) title;
- (NSUInteger) numberOfSections;
- (RCSTableSection *) sectionAtIndex: (NSUInteger)section;
- (NSUInteger) numberOfRowsInSection: (NSUInteger)section_;
- (RCSTableRow *) rowAtIndexPath: (NSIndexPath *)indexPath;
- (BOOL) isEditableAtIndexPath: (NSIndexPath *)indexPath;
- (NSString *) cellReuseIdentifierAtIndexPath: (NSIndexPath *)indexPath;
- (UITableViewCell *) cellForRowAtIndexPath: (NSIndexPath *)indexPath;

- (NSString *) tableHeaderImagePath;

@end

/*
 * Copyright 2009-2011 Jim Roepcke <jim@roepcke.com>. All rights reserved.
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
