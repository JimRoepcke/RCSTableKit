//
//  RCSTableViewController.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTableViewController ()
@property (nonatomic, retain) NSString *tableHeaderImagePath;
- (void) configureEditButton;
- (void) configureTitle;
- (void) reloadData;
@property (nonatomic, readwrite, retain) RCSTable *table;
@end

@implementation RCSTableViewController

@synthesize tableView=_tableView;
@synthesize tableHeaderImagePath=_tableHeaderImagePath;
@synthesize rootObject=_rootObject;
@synthesize tableDefinition=_tableDefinition;
@synthesize table=_table;

- (void) dealloc
{
	[_tableHeaderImagePath release]; _tableHeaderImagePath = nil;
	[_tableView setDelegate: nil];
	[_tableView setDataSource: nil];
	[_tableView release]; _tableView = nil;

	[_rootObject release]; _rootObject = nil;
	[_table release]; _table = nil;
	[_tableDefinition release]; _tableDefinition = nil;
	
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	UITableView *tv = [self tableView];
	[tv setDataSource: self];
	
	tv.allowsSelectionDuringEditing = [[self tableDefinition] configurationBoolForKey: @"allowsSelectionDuringEditing" withDefault: tv.allowsSelectionDuringEditing];
	tv.allowsSelection = [[self tableDefinition] configurationBoolForKey: @"allowsSelection" withDefault: tv.allowsSelection];
}

- (void) viewDidUnload
{
	[super viewDidUnload];
	[[self tableView] setDataSource: nil];
	[self setTableView: nil];
}

- (void) viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];
	[self configureEditButton];	
	[self configureTitle];
	[self reloadData];
}

- (void) viewWillDisappear: (BOOL)animated
{
	[super viewWillDisappear: animated];
	[[NSNotificationCenter defaultCenter] postNotificationName: @"RCSTableViewControllerViewWillDisappear" object: self];
}

- (void) configureEditButton
{
	if ([[self tableDefinition] configurationBoolForKey: @"isEditable" withDefault: NO]) {
		[[self navigationItem] setRightBarButtonItem: [self editButtonItem]];
	}
}

- (void) configureTitle
{
	NSString *title = [[self table] title];
	if (title) {
		[self setTitle: title];
	}
}

- (void) willReloadData {}
- (void) didReloadData {}

- (BOOL) string: (NSString *)s1 isEqualToString: (NSString *)s2
{
	if (s1 == nil) return s2 == nil;
	return [s1 isEqualToString: s2];
}

- (NSInteger) numberOfSections { return [self.table numberOfSections]; }
- (NSInteger) numberOfRowsInSection: (NSInteger)sec { return [self.table numberOfRowsInSection: sec]; }

- (RCSTableRow *) rowAtIndexPath: (NSIndexPath *)indexPath {
	return [_table rowAtIndexPath: indexPath];
}

- (NSObject *) rootObject
{
	return _rootObject ? _rootObject : self;
}

- (void) reloadData
{
	[self willReloadData];
	self.table = nil;
	RCSTable *newTable = [[RCSTable alloc] initUsingDefintion: [self tableDefinition]
											   withRootObject: [self rootObject]
											forViewController: self];
	self.table = newTable;
	[newTable release];
	[[self tableView] reloadData];
	NSString *path = [[self table] tableHeaderImagePath];
	if (! [self string: path isEqualToString: [self tableHeaderImagePath]]) {
		[self setTableHeaderImagePath: path];
		if (path == nil) {
			[[self tableView] setTableHeaderView: nil];
		} else {
			UIImage *image = [UIImage imageWithContentsOfFile: [self tableHeaderImagePath]];
			UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
			[[self tableView]  setTableHeaderView: imageView];
			[imageView release];
		}
	}
	[self didReloadData];
}

#pragma mark -
#pragma mark UIViewController methods

- (void) setEditing: (BOOL)editing animated: (BOOL)animated
{
	BOOL oldEditing = [self isEditing];
	[super setEditing: editing animated: animated];
	if (editing != oldEditing) {
		[self reloadData];
	}
}

- (void) didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (void) tableView: (UITableView *)tableView willDisplayCell: (UITableViewCell *)cell forRowAtIndexPath: (NSIndexPath *)indexPath {
	[[self rowAtIndexPath: indexPath] willDisplayCell: cell];
}

- (void) tableView: (UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath {
    [[self rowAtIndexPath: indexPath] accessoryButtonTapped];
}

- (UITableViewCellEditingStyle) tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath {
    return [((RCSTableRow *)[self rowAtIndexPath: indexPath]) editingStyle];
}

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath {
	return [((RCSTableRow *)[self rowAtIndexPath: indexPath]) heightWithDefault: tableView.rowHeight];
}

- (NSIndexPath *)tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath {
	return [[self rowAtIndexPath: indexPath] willSelect: indexPath];
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
	[[self rowAtIndexPath: indexPath] didSelect];
}

#pragma mark -
#pragma mark Table View Data Source Methods


- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
	return [self numberOfSections];
}

- (NSString *) tableView: (UITableView *)tableView titleForHeaderInSection: (NSInteger)section {
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
