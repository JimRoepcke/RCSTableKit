//
//  RCSTable.m
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSTable.h"
#import "RCSTableDefinition.h"
#import "RCSTableSection.h"
#import "RCSTableRow.h"

@interface RCSTable ()
@property (nonatomic, readwrite, strong) RCSTableDefinition *definition;
@property (nonatomic, readwrite, weak) NSObject *object;
@property (nonatomic, readwrite, strong) NSMutableArray *sections;
@property (nonatomic, readwrite, weak) RCSTableViewController *controller; // parent
@end

@implementation RCSTable

@synthesize definition=_definition;
@synthesize object=_object;
@synthesize sections=_sections;
@synthesize controller=_controller;

- (id) initUsingDefintion: (RCSTableDefinition *)definition_
		   withRootObject: (NSObject *)object_
		forViewController: (RCSTableViewController *)controller_
{
	if (self = [super init]) {
		_definition = definition_;
		_object = object_;
		_controller = controller_;
		_sections = [definition_ sectionsForTable: self];
	}
	return self;
}


#pragma mark -
#pragma mark Public API

- (NSString *) title { return [_definition title: self]; }
- (NSString *) tableHeaderImagePath { return [_definition tableHeaderImagePath: self]; }

- (NSInteger) numberOfSections
{
	return [_sections count];
}

- (NSInteger) numberOfRowsInSection: (NSInteger)section_
{
	return [(RCSTableSection *)[_sections objectAtIndex: section_] numberOfRows];
}

- (RCSTableSection *) sectionAtIndex: (NSInteger)section
{
	return (RCSTableSection *)[_sections objectAtIndex: section];
}

- (RCSTableRow *) rowAtIndexPath: (NSIndexPath *)indexPath
{
	return [(RCSTableSection *)[self sectionAtIndex: [indexPath section]] rowAtIndex: [indexPath row]];
}

- (BOOL) isEditableAtIndexPath: (NSIndexPath *)indexPath
{
	return [(RCSTableRow *)[self rowAtIndexPath: indexPath] isEditable];
}

- (NSString *) cellReuseIdentifierAtIndexPath: (NSIndexPath *)indexPath
{
	return [(RCSTableRow *)[self rowAtIndexPath: indexPath] cellReuseIdentifier];
}

- (UITableViewCell *) cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
	return [(RCSTableRow *)[self rowAtIndexPath: indexPath] createCell];
	
}

@end

/*
 * Copyright 2009-2013 Jim Roepcke <jim@roepcke.com>. All rights reserved.
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
