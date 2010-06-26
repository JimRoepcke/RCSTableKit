//
//  RCSTableViewController.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTableViewController ()
@property (nonatomic, retain) NSString *tableHeaderImagePath;
+ (Class) dataSourceClass;
- (RCSTableViewDataSource *) dataSourceWithRootObject: (id)rootObject_
								   usingConfiguration: (NSDictionary *)configuration_
												named: (NSString *)name_;
- (void) configureEditButton;
- (void) configureTitle;
- (void) reloadData;
@end

@implementation RCSTableViewController

@synthesize tableView=_tableView;
@synthesize tableViewDelegate=_tableViewDelegate;
@synthesize dataSource=_dataSource;
@synthesize tableHeaderImagePath=_tableHeaderImagePath;

- (id) initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder: aDecoder]) {
		_tableViewDelegate = nil;
		_dataSource = nil;
		_tableHeaderImagePath = nil;
	}
	return self;
}

- (id) initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil]) {
		_tableViewDelegate = nil;
		_dataSource = nil;
		_tableHeaderImagePath = nil;
	}
	return self;
}

- (id) initWithRootObject: (id)rootObject_
			configuration: (NSDictionary *)configuration_
					named: (NSString *)name_
{
	// need the data source here so we can find out what nibName/nibBundleName are
	// because these must be passed to -[UIViewController initWithNibName:bundle:].
	RCSTableViewDataSource *ds = [self dataSourceWithRootObject: rootObject_ usingConfiguration: configuration_ named: name_];
	NSString *nibName_ = [ds configurationStringForKey: @"nibName" withDefault: nil];
	NSString *nibBundleName_ = [ds configurationStringForKey: @"nibBundleName" withDefault: nil];
	NSBundle *nibBundle_ = nil;
	if (nibBundleName_ != nil) {
		NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: nibBundleName_];
		nibBundle_ = [NSBundle bundleWithPath: path];
	}
	if (self = [self initWithNibName: nibName_ bundle: nibBundle_]) {
		[self setDataSource: ds];
    }
    return self;
}

- (void) dealloc
{
	[_tableHeaderImagePath release]; _tableHeaderImagePath = nil;
	[_dataSource release]; _dataSource = nil;
	[_tableViewDelegate release]; _tableViewDelegate = nil;
	[_tableView setDelegate: nil];
	[_tableView setDataSource: nil];
	[_tableView release]; _tableView = nil;
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	[self.tableView setDataSource: self.dataSource];
	self.tableView.allowsSelectionDuringEditing = [self.dataSource configurationBoolForKey: @"allowsSelectionDuringEditing" withDefault: self.tableView.allowsSelectionDuringEditing];
	self.tableView.allowsSelection = [self.dataSource configurationBoolForKey: @"allowsSelection" withDefault: self.tableView.allowsSelection];
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
	[self configureEditButton];	
	[self configureTitle];
	[self reloadData];
}

- (void) viewWillDisappear: (BOOL)animated
{
	[super viewWillDisappear: animated];
	[[NSNotificationCenter defaultCenter] postNotificationName: @"RCSTableViewControllerViewWillDisappear" object: self];
}

+ (Class) dataSourceClass { return [RCSTableViewDataSource class]; }

- (RCSTableViewDataSource *) dataSourceWithRootObject: (id)rootObject_
								   usingConfiguration: (NSDictionary *)configuration_
												named: (NSString *)name_
{
	return [[[[[self class] dataSourceClass] alloc] initForViewController: self
														   withRootObject: (rootObject_ == nil ? self : rootObject_)
													   usingConfiguration: configuration_
																	named: name_] autorelease];
}

- (void) setDataSource: (RCSTableViewDataSource *)ds
{
	if (ds != _dataSource) {
		[_dataSource release];
		_dataSource = [ds retain];
		self.tableViewDelegate = [[[RCSTableViewDelegate alloc] initForViewController: self withDataSource: ds] autorelease];
	}
}

- (NSObject *) rootObject { return self.dataSource.rootObject; }

- (void) configureEditButton
{
	if ([self.dataSource configurationBoolForKey: @"isEditable" withDefault: NO]) {
		self.navigationItem.rightBarButtonItem = [self editButtonItem];
	}
}

- (void) configureTitle
{
	NSString *title = [self.dataSource configurationStringForKey: @"staticTitle" withDefault: nil];
	if (title == nil) {
		title = [self.dataSource configurationStringForKey: @"title" withDefault: nil];
		if (title != nil) {
			title = [self valueForKeyPath: title];
		}
	}
	if (title != nil) {
		self.title = title;
	}
}

- (void) willReloadData {}
- (void) didReloadData {}

- (BOOL) string: (NSString *)s1 isEqualToString: (NSString *)s2
{
	if (s1 == nil) return s2 == nil;
	return [s1 isEqualToString: s2];
}

- (void) reloadData
{
	[self willReloadData];
	[self.dataSource reloadData];
	[self.tableView reloadData];
	NSString *path = [self.dataSource.table tableHeaderImagePath];
	if (! [self string: path isEqualToString: self.tableHeaderImagePath]) {
		self.tableHeaderImagePath = path;
		if (self.tableHeaderImagePath == nil) {
			self.tableView.tableHeaderView = nil;
		} else {
			UIImage *image = [UIImage imageWithContentsOfFile: self.tableHeaderImagePath];
			UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
			self.tableView.tableHeaderView = imageView;
			[imageView release];
		}
	}
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

#pragma mark Relaunch Restoration Support

- (NSDictionary *) relaunchRestorationState
{
	NSMutableDictionary *state = [[NSMutableDictionary alloc] initWithCapacity: 2];
	// FIXME: i don't think this actually works in general, what about the nibName and the nibBundleName etc?
	[state setObject: NSStringFromClass([self class]) forKey: @"viewControllerClassName"];
	[state setObject: self.dataSource.key forKey: @"configurationName"];
	return [state autorelease];
}

#pragma mark -
#pragma mark Table View Delegate Methods

// delegate methods are forwarded to self.tableViewDelegate

- (void) tableView: (UITableView *)tableView willDisplayCell: (UITableViewCell *)cell forRowAtIndexPath: (NSIndexPath *)indexPath {
	[self.tableViewDelegate tableView: tableView willDisplayCell: cell forRowAtIndexPath: indexPath];
}

- (void) tableView: (UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath {
	[self.tableViewDelegate tableView: tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
}

- (UITableViewCellEditingStyle) tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath {
    return [self.tableViewDelegate tableView: tableView editingStyleForRowAtIndexPath: indexPath];
}

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath {
	return [self.tableViewDelegate tableView: tableView heightForRowAtIndexPath: indexPath];
}

- (NSIndexPath *)tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath {
	return [self.tableViewDelegate tableView: tableView willSelectRowAtIndexPath: indexPath];
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
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
