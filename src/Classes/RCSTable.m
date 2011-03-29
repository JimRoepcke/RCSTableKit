//
//  RCSTable.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTable ()
@property (nonatomic, readwrite, retain) RCSTableDefinition *definition;
@property (nonatomic, readwrite, assign) NSObject *object;
@property (nonatomic, readwrite, retain) NSMutableArray *sections;
@property (nonatomic, readwrite, assign) RCSTableViewController *controller; // parent
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
		self.definition = definition_;
		self.object = object_;
		self.controller = controller_;
		self.sections = [self.definition sectionsForTable: self];
	}
	return self;
}

- (void) dealloc {
	[_definition release]; _definition = nil;
	[_sections release]; _sections = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Public API

- (NSString *) title
{
	return [_definition title: self];
}

- (NSUInteger) numberOfSections
{
	return [self.sections count];
}

- (NSUInteger) numberOfRowsInSection: (NSUInteger)section_
{
	return [(RCSTableSection *)[self.sections objectAtIndex: section_] numberOfRows];
}

- (RCSTableSection *) sectionAtIndex: (NSUInteger)section
{
	return (RCSTableSection *)[self.sections objectAtIndex: section];
}

- (RCSTableRow *) rowAtIndexPath: (NSIndexPath *)indexPath
{
	return [[self sectionAtIndex: indexPath.section] rowAtIndex: indexPath.row];
}

- (BOOL) isEditableAtIndexPath: (NSIndexPath *)indexPath
{
	RCSTableRow *row = [self rowAtIndexPath: indexPath];
	return [row isEditable];
}

- (NSString *) cellReuseIdentifierAtIndexPath: (NSIndexPath *)indexPath
{
	return [[self rowAtIndexPath: indexPath] cellReuseIdentifier];
}

- (UITableViewCell *) cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
	RCSTableRow *row = [self rowAtIndexPath: indexPath];
	return [row createCell];
	
}

- (NSString *) tableHeaderImagePath
{
	NSString *result = nil;
	if (_definition.tableHeaderImagePathSelector) {
		result = [self.controller performSelector: _definition.tableHeaderImagePathSelector withObject: self];
	} else if (_definition.tableHeaderImagePath != nil) {
		result = [_object valueForKeyPath: _definition.tableHeaderImagePath];
	}
	return result;
}

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
