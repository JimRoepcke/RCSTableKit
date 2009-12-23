//
//  RCSTableViewController.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTableViewController ()
@property (nonatomic, readwrite, copy)   NSString *configurationName;
@property (nonatomic, readwrite, retain) NSDictionary *configuration;
- (void) configureEditButton;
- (void) configureTitle;
- (void) reloadData;

- (BOOL) configurationBoolForKey: (id)key withDefault: (BOOL)value;
- (NSInteger) configurationIntegerForKey: (id)key withDefault: (NSInteger)value;
- (NSString *) configurationStringForKey: (id)key withDefault: (NSString *)value;
@end

@implementation RCSTableViewController

@synthesize configuration=_configuration;
@synthesize configurationName=_configurationName;
@synthesize tableView=_tableView;
@synthesize dataSource=_dataSource;
@synthesize tableViewDelegate=_tableViewDelegate;

- (id) initWithRootObject: (id)rootObject_
			configuration: (NSDictionary *)configuration_
					named: (NSString *) name_
{
	if (configuration_ == nil) {
		if (name_ == nil) return nil;
		configuration_ = [[self class] configurationNamed: name_];
	}
	NSString *nibName = [configuration_ objectForKey:@"nibName"];
	if (nibName == nil) nibName = @"RCSTableViewPlain";
	if (self = [super initWithNibName: nibName bundle: nil]) {
		self.configurationName = name_;
		self.configuration = configuration_;
		self.dataSource = [[[RCSTableViewDataSource alloc] initForViewController: self
																  withRootObject: (rootObject_ == nil ? self : rootObject_)
															  usingConfiguration: configuration_
																		   named: name_] autorelease];
		self.tableViewDelegate = [[[RCSTableViewDelegate alloc] initForViewController: self
																	   withDataSource: self.dataSource] autorelease];
		[self configureEditButton];
    }
    return self;
}

- (void) dealloc
{
	self.configuration = nil;
	self.configurationName = nil;
	self.dataSource = nil;
	self.tableViewDelegate = nil;
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
	self.tableView = nil;
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	[self.tableView setDataSource: self.dataSource];
	self.tableView.allowsSelectionDuringEditing = [self configurationBoolForKey: @"allowsSelectionDuringEditing" withDefault: self.tableView.allowsSelectionDuringEditing];
	self.tableView.allowsSelection = [self configurationBoolForKey: @"allowsSelection" withDefault: self.tableView.allowsSelection];
}

- (void) viewDidUnload
{
	[super viewDidUnload];
	self.tableView.dataSource = nil;
	self.tableView = nil;
}

- (void) viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];
	[self configureTitle];
	[self reloadData];
}

- (void) viewWillDisappear: (BOOL)animated
{
	[super viewWillDisappear: animated];
	[[NSNotificationCenter defaultCenter] postNotificationName: @"RCSTableViewControllerViewWillDisappear" object: self];
}

- (NSObject *) rootObject { return self.dataSource.rootObject; }

- (void) configureEditButton {
	if ([self configurationBoolForKey: @"isEditable" withDefault: NO]) {
		self.navigationItem.rightBarButtonItem = [self editButtonItem];
	}
}

- (void) configureTitle
{
	NSString *title = [self configurationStringForKey: @"staticTitle" withDefault: nil];
	if (title == nil) {
		title = [self configurationStringForKey: @"title" withDefault: nil];
		if (title != nil) {
			title = [self valueForKeyPath: title];
		}
	}
	if (title != nil) {
		self.title = title;
	}
}

- (void)willReloadData {}
- (void)didReloadData {}

- (void) reloadData
{
	[self willReloadData];
	[self.dataSource reloadData];
	[self.tableView reloadData];
	[self didReloadData];
}

#pragma mark -
#pragma mark UIViewController methods

- (void) setEditing: (BOOL)editing animated: (BOOL)animated
{
	BOOL oldEditing = self.editing;
	if (editing != oldEditing) {
		if (NO) { // set to NO to disable animations if it's still buggy
			[self.tableView beginUpdates];
			[super setEditing: editing animated: animated];
			[self.dataSource setEditing: editing animated: animated];
			[self.tableView endUpdates];
			if (!animated)
				[self reloadData];
		} else {
			[super setEditing: editing animated: animated];
			[self.dataSource reloadData];
			[self reloadData];
		}
	}
}

- (void) didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark Configuration Accessors

- (BOOL) configurationBoolForKey: (id)key withDefault: (BOOL)value {
	NSNumber *num = [self.configuration objectForKey:key];
	return num == nil ? value : [num boolValue];
}

- (NSInteger) configurationIntegerForKey: (id)key withDefault: (NSInteger)value {
	NSNumber *num = [self.configuration objectForKey:key];
	return num == nil ? value : [num integerValue];
}

- (NSString *) configurationStringForKey: (id)key withDefault: (NSString *)value {
	NSString *s = [self.configuration objectForKey:key];
	return s == nil ? value : s;
}

#pragma mark Relaunch Restoration Support

- (NSDictionary *) relaunchRestorationState
{
	NSMutableDictionary *state = [[NSMutableDictionary alloc] initWithCapacity: 2];
	[state setObject: NSStringFromClass([self class]) forKey: @"viewControllerClassName"];
	[state setObject: self.configurationName forKey: @"configurationName"];
	return [state autorelease];
}

#pragma mark -
#pragma mark Table View Delegate Methods

// delegate methods are forwarded to self.tableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableViewDelegate tableView: tableView willDisplayCell: cell forRowAtIndexPath: indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	[self.tableViewDelegate tableView: tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableViewDelegate tableView: tableView editingStyleForRowAtIndexPath: indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self.tableViewDelegate tableView: tableView heightForRowAtIndexPath: indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self.tableViewDelegate tableView: tableView willSelectRowAtIndexPath: indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableViewDelegate tableView: tableView didSelectRowAtIndexPath: indexPath];
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
