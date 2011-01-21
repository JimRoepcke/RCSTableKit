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
	if (_definition.tableHeaderImagePathSelector != (SEL)0) {
		result = [self.controller performSelector: _definition.tableHeaderImagePathSelector withObject: self];
	} else if (_definition.tableHeaderImagePath != nil) {
		result = [_object valueForKeyPath: _definition.tableHeaderImagePath];
	}
	return result;
}

@end

/*
 * Copyright (c) 2009 Jim Roepcke <jim@roepcke.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
