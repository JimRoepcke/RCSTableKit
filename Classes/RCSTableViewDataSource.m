//
//  RCSTableDataSource.m
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSTableViewDataSource.h"
#import "RCSTableViewController.h"
#import "RCSTableDefinition.h"
#import "RCSTable.h"
#import "RCSTableSectionDefinition.h"
#import "RCSTableSection.h"
#import "RCSTableRowDefinition.h"
#import "RCSTableRow.h"
#import "RCSTableViewCell.h"
#import "RCSTableUIViewControllerAdditions.h"

@interface RCSTableViewDataSource ()
@property (nonatomic, readwrite, assign) RCSTableViewController *viewController;
@property (nonatomic, readwrite, retain) NSObject *rootObject;
@property (nonatomic, readwrite, retain) NSDictionary *dictionary;
@property (nonatomic, readwrite, retain) NSString *key;
@property (nonatomic, readwrite, retain) RCSTableDefinition *tableDefinition;
@property (nonatomic, readwrite, retain) RCSTable *table;
@end

@implementation RCSTableViewDataSource

@synthesize viewController=_viewController;
@synthesize rootObject=_rootObject;
@synthesize dictionary=_dictionary;
@synthesize key=_key;
@synthesize tableDefinition=_tableDefinition;
@synthesize table=_table;

- (id) initForViewController: (RCSTableViewController *)viewController_
			  withRootObject: (NSObject *)rootObject_
		  usingConfiguration: (NSDictionary *)configuration_
					   named: (NSString *)name_ {
	self = [super init];
	if (self != nil) {
		self.viewController = viewController_;
		self.rootObject = rootObject_;
		self.dictionary = configuration_;
		self.key = name_;
		self.table = nil;
		// FIXME: the RCSTableDefinition should come from a cache
		self.tableDefinition = [[[RCSTableDefinition alloc] initWithDictionary: configuration_ forKey: name_] autorelease];
	}
	return self;
}

- (void) dealloc
{
	self.viewController = nil;
	self.rootObject = nil;
	self.key = nil;
	self.table = nil;
	self.tableDefinition = nil;
	self.dictionary = nil;
	[super dealloc];
}

- (NSInteger) numberOfSections { return [self.table numberOfSections]; }
- (NSInteger) numberOfRowsInSection: (NSInteger)sec { return [self.table numberOfRowsInSection: sec]; }

- (RCSTableRow *) rowAtIndexPath: (NSIndexPath *)indexPath {
	return [self.table rowAtIndexPath: indexPath];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
	return [self numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[self.table sectionAtIndex: (NSUInteger)section] title];
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
	return [self numberOfRowsInSection: section];
}

- (BOOL) tableView: (UITableView *)tableView canEditRowAtIndexPath: (NSIndexPath *)indexPath
{
	return [self.table isEditableAtIndexPath: indexPath];
}

- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
	NSString *identifier = [self.table cellReuseIdentifierAtIndexPath: indexPath];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
	if (cell == nil) {
		cell = [self.table cellForRowAtIndexPath: indexPath];
	}
	
	if ([cell isKindOfClass: [RCSTableViewCell class]]) {
		RCSTableRow *row = [self.table rowAtIndexPath: indexPath];
		((RCSTableViewCell *)cell).row = row;
	}
	
    return cell;
}

- (void) tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath
{
	RCSTableRow *row = [self.table rowAtIndexPath: indexPath];
	[row commitEditingStyle: editingStyle];
}

#pragma mark -
#pragma mark Building the Data Source from the configuration file

// TODO: support animated mode
- (void) reloadData: (BOOL)animated
{
	self.table = nil;
	RCSTable *newTable = [[RCSTable alloc] initUsingDefintion: self.tableDefinition
											   withRootObject: self.rootObject
											forViewController: self.viewController];
	self.table = newTable;
	[newTable release];
}

- (void) reloadData
{
	[self reloadData: NO];
}

- (void) setEditing: (BOOL)editing animated: (BOOL)animated
{
	[self reloadData: YES];
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
