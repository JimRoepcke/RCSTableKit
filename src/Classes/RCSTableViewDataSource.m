//
//  RCSTableDataSource.m
//  Created by Jim Roepcke.
//  See license below.
//

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
	if (!(configuration_ = configuration_ ? configuration_ :
		  (name_ ? [[self class] configurationNamed: name_] : nil))) {
		return nil;
	}
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
	[_rootObject release]; _rootObject = nil;
	[_key release]; _key = nil;
	[_table release]; _table = nil;
	[_tableDefinition release]; _tableDefinition = nil;
	[_dictionary release]; _dictionary = nil;
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

#pragma mark -
#pragma mark Configuration Support

+ (NSDictionary *) configurationNamed: (NSString *)name inBundle: (NSBundle *)bundle
{
	NSDictionary *result = nil;
	if (name == nil) {
		result = [NSDictionary dictionaryWithObjectsAndKeys: [NSArray array], @"displaySectionKeys", [NSDictionary dictionary], @"sections", nil];
		bundle = nil;
	} else if (bundle == nil) {
		bundle = [NSBundle mainBundle];
	}
	if (bundle != nil) {
		result = [NSDictionary dictionaryWithContentsOfFile: [bundle pathForResource: name ofType: @"plist"]];
	}
	return result;
}

+ (NSDictionary *) configurationNamed: (NSString *)name
{
	return [[self class] configurationNamed: name inBundle: nil];
}

- (RCSTableViewController *) configuration: (NSString *)name withRootObject: (NSObject *)object
{
	NSDictionary *conf = [[self class] configurationNamed: name];
	NSString *controllerClassName = [conf objectForKey: @"controllerClassName"];
	if (controllerClassName == nil) controllerClassName = NSStringFromClass([[self viewController] class]);
	Class controllerClass = NSClassFromString(controllerClassName);
	RCSTableViewController *c = [[controllerClass alloc] initWithRootObject: object
															  configuration: nil
																	  named: name];
	return [c autorelease];
}

- (BOOL) configurationBoolForKey: (id)key_ withDefault: (BOOL)value {
	NSNumber *num = [self.dictionary objectForKey: key_];
	return num == nil ? value : [num boolValue];
}

- (NSInteger) configurationIntegerForKey: (id)key_ withDefault: (NSInteger)value {
	NSNumber *num = [self.dictionary objectForKey: key_];
	return num == nil ? value : [num integerValue];
}

- (NSString *) configurationStringForKey: (id)key_ withDefault: (NSString *)value {
	NSString *s = [self.dictionary objectForKey: key_];
	return s == nil ? value : s;
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
