//
//  RCSTableRowDefinition.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTableRowDefinition ()
@property (nonatomic, readwrite, retain) NSDictionary *dictionary;
@property (nonatomic, readwrite, retain) NSString *key;
@property (nonatomic, readwrite, retain) NSString *list;
@end

@implementation RCSTableRowDefinition

@synthesize dictionary=_dictionary;
@synthesize key=_key;
@synthesize list=_list;

@synthesize cellClassName=_cellClassName;
@synthesize cellClass=_cellClass;

@synthesize cellStyle=_cellStyle;
@synthesize becomeFirstResponder=_becomeFirstResponder;
@synthesize rowHeight=_rowHeight;	
@synthesize backgroundColor=_backgroundColor;

@synthesize staticText=_staticText;
@synthesize text=_text;
@synthesize textSelector=_textSelector;

@synthesize staticDetailText=_staticDetailText;
@synthesize detailText=_detailText;
@synthesize detailTextSelector=_detailTextSelector;

@synthesize editingStyle=_editingStyle;
@synthesize editingStyleAction=_editingStyleAction;
@synthesize editingStylePushConfiguration=_editingStylePushConfiguration;

@synthesize action=_action;
@synthesize pushConfiguration=_pushConfiguration;
@synthesize viewAction=_viewAction;
@synthesize viewPushConfiguration=_viewPushConfiguration;
@synthesize editAction=_editAction;
@synthesize editPushConfiguration=_editPushConfiguration;

@synthesize staticAccessoryType=_staticAccessoryType;
@synthesize accessoryType=_accessoryType;
@synthesize accessoryTypeSelector=_accessoryTypeSelector;

@synthesize accessoryAction=_accessoryAction;
@synthesize accessoryPushConfiguration=_accessoryPushConfiguration;
@synthesize viewAccessoryAction=_viewAccessoryAction;
@synthesize viewAccessoryPushConfiguration=_viewAccessoryPushConfiguration;

@synthesize staticEditingAccessoryType=_staticEditingAccessoryType;
@synthesize editingAccessoryType=_editingAccessoryType;
@synthesize editingAccessoryTypeSelector=_editingAccessoryTypeSelector;

@synthesize editAccessoryAction=_editAccessoryAction;
@synthesize editAccessoryPushConfiguration=_editAccessoryPushConfiguration;	

- (id) initWithDictionary: (NSDictionary *)dictionary_
				   forKey: (NSString *)key_
{
	self = [super init];
	if (self != nil) {
		self.dictionary = dictionary_;
		self.key = key_;
		self.list = [dictionary_ objectForKey: @"list"];
		_cellClass = nil;

		NSString *editingStyleString, *cellStyleString, *staticAccessoryTypeString;
		UITableViewCellEditingStyle editingStyle;
		UITableViewCellStyle cellStyle;
		UITableViewCellAccessoryType staticAccessoryType, staticEditingAccessoryType;
		
		// cellStyle
		cellStyle = UITableViewCellStyleDefault;
		cellStyleString = [self stringForKey: @"cellStyle" withDefault: @"default" inDictionary: _dictionary];
		if ([@"value1" isEqualToString: cellStyleString]) {
			cellStyle = UITableViewCellStyleValue1;
		} else if ([@"value2" isEqualToString: cellStyleString]) {
			cellStyle = UITableViewCellStyleValue2;
		} else if ([@"subtitle" isEqualToString: cellStyleString]) {
			cellStyle = UITableViewCellStyleSubtitle;
		}
		
		// editingStyle
		editingStyle = UITableViewCellEditingStyleNone;
		editingStyleString = [self stringForKey: @"editingStyle" withDefault: @"none" inDictionary: _dictionary];
		if ([@"insert" isEqualToString: editingStyleString]) {
			editingStyle = UITableViewCellEditingStyleInsert;
		} else if ([@"delete" isEqualToString: editingStyleString]) {
			editingStyle = UITableViewCellEditingStyleDelete;
		}
		
		// staticAccessoryType
		staticAccessoryType = UITableViewCellAccessoryNone;
		staticAccessoryTypeString = [self stringForKey: @"staticAccessoryType" withDefault: @"none" inDictionary: _dictionary];
		if ([@"disclosureIndicator" isEqualToString: staticAccessoryTypeString]) {
			staticAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else if ([@"detailDisclosureIndicator" isEqualToString: staticAccessoryTypeString]) {
			staticAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		} else if ([@"checkmark" isEqualToString: staticAccessoryTypeString]) {
			staticAccessoryType = UITableViewCellAccessoryCheckmark;
		}

		// staticEditingAccessoryType
		staticEditingAccessoryType = UITableViewCellAccessoryNone;
		staticAccessoryTypeString = [self stringForKey: @"staticEditingAccessoryType" withDefault: @"none" inDictionary: _dictionary];
		if ([@"disclosureIndicator" isEqualToString: staticAccessoryTypeString]) {
			staticEditingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else if ([@"detailDisclosureIndicator" isEqualToString: staticAccessoryTypeString]) {
			staticEditingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		} else if ([@"checkmark" isEqualToString: staticAccessoryTypeString]) {
			staticEditingAccessoryType = UITableViewCellAccessoryCheckmark;
		}

		self.cellStyle = cellStyle;
		self.editingStyle = editingStyle;
		
		// TODO: rearrange these lines to match the order of the properties above
		self.staticAccessoryType = staticAccessoryType;
		self.accessoryType = [self stringForKey: @"accessoryType" withDefault: nil inDictionary: dictionary_];
		self.accessoryTypeSelector = NSSelectorFromString([self stringForKey: @"accessoryTypeSelector" withDefault: nil inDictionary: dictionary_]);
		self.staticEditingAccessoryType = staticEditingAccessoryType;
		self.editingAccessoryType = [self stringForKey: @"editingAccessoryType" withDefault: nil inDictionary: dictionary_];
		self.editingAccessoryTypeSelector = NSSelectorFromString([self stringForKey: @"editingAccessoryTypeSelector" withDefault: nil inDictionary: dictionary_]);
		self.cellClassName = [self stringForKey: @"cell" withDefault: @"RCSTableViewCell" inDictionary: dictionary_];
		self.staticText = [self stringForKey: @"staticText" withDefault: nil inDictionary: dictionary_];
		self.staticDetailText = [self stringForKey: @"staticDetailText" withDefault: nil inDictionary: dictionary_];
		self.editPushConfiguration = [self stringForKey: @"editPushConfiguration" withDefault: nil inDictionary: dictionary_];
		self.viewPushConfiguration = [self stringForKey: @"viewPushConfiguration" withDefault: nil inDictionary: dictionary_];
		self.pushConfiguration = [self stringForKey: @"pushConfiguration" withDefault: nil inDictionary: dictionary_];
		self.accessoryPushConfiguration = [self stringForKey: @"accessoryPushConfiguration" withDefault: nil inDictionary: dictionary_];
		self.editAccessoryPushConfiguration = [self stringForKey: @"editAccessoryPushConfiguration" withDefault: nil inDictionary: dictionary_];
		self.viewAccessoryPushConfiguration = [self stringForKey: @"viewAccessoryPushConfiguration" withDefault: nil inDictionary: dictionary_];
		self.text = [self stringForKey: @"text" withDefault: nil inDictionary: dictionary_];
		self.textSelector = NSSelectorFromString([self stringForKey: @"textSelector" withDefault: nil inDictionary: dictionary_]);
		self.detailText = [self stringForKey: @"detailText" withDefault: nil inDictionary: dictionary_];
		self.detailTextSelector = NSSelectorFromString([self stringForKey: @"detailTextSelector" withDefault: nil inDictionary: dictionary_]);
		self.backgroundColor = [self stringForKey: @"backgroundColor" withDefault: nil inDictionary: dictionary_];
		self.becomeFirstResponder = [self boolForKey: @"becomeFirstResponder" withDefault: NO inDictionary: dictionary_];
		self.editingStyleAction = NSSelectorFromString([self stringForKey: @"editingStyleAction" withDefault: nil inDictionary: dictionary_]);
		self.editingStylePushConfiguration = [self stringForKey: @"editingStylePushConfiguration" withDefault: nil inDictionary: dictionary_];
		self.editAction = NSSelectorFromString([self stringForKey: @"editAction" withDefault: nil inDictionary: dictionary_]);
		self.viewAction = NSSelectorFromString([self stringForKey: @"viewAction" withDefault: nil inDictionary: dictionary_]);
		self.action = NSSelectorFromString([self stringForKey: @"action" withDefault: nil inDictionary: dictionary_]);
		self.editAccessoryAction = NSSelectorFromString([self stringForKey: @"editAccessoryAction" withDefault: nil inDictionary: dictionary_]);
		self.viewAccessoryAction = NSSelectorFromString([self stringForKey: @"viewAccessoryAction" withDefault: nil inDictionary: dictionary_]);
		self.accessoryAction = NSSelectorFromString([self stringForKey: @"accessoryAction" withDefault: nil inDictionary: dictionary_]);
		self.rowHeight = (CGFloat)[self floatForKey: @"rowHeight" withDefault: -1.0 inDictionary: dictionary_];
	}
	return self;
}

- (void) dealloc
{
	self.dictionary = nil;
	self.key = nil;
	self.list = nil;
	
	self.accessoryType = nil;
	self.editingAccessoryType = nil;
	self.cellClassName = nil;
	self.cellClass = nil;
	self.backgroundColor = nil;
	self.staticText = nil;
	self.text = nil;
	self.staticDetailText = nil;
	self.detailText = nil;
	self.editingStylePushConfiguration = nil;
	self.pushConfiguration = nil;
	self.viewPushConfiguration = nil;
	self.editPushConfiguration = nil;
	self.accessoryPushConfiguration = nil;
	self.viewAccessoryPushConfiguration = nil;
	self.editAccessoryPushConfiguration = nil;
	[super dealloc];
}

- (NSArray *) objectsForRowsInSection: (RCSTableSection *)section
{
	NSNull *nullValue = [NSNull null];
	if (self.list == nil) {
		NSString *objectKeyPath = [self stringForKey: @"object"
										 withDefault: nil
										inDictionary: self.dictionary];
		if (objectKeyPath == nil) {
			return [NSArray arrayWithObject: nullValue];
		}
		return [NSArray arrayWithObject: [section.object valueForKeyPath: objectKeyPath]];
	}
	return [section.object valueForKeyPath: self.list];
}

#pragma mark -
#pragma mark Public API

// called by RCSTableSectionDefinition's rowsForSection:
// returns an array of RCSTableRow objects
- (NSMutableArray *) rowsForSection: (RCSTableSection *)section
					   startAtIndex: (NSUInteger)startIndex
{
	NSNull *nullValue = [NSNull null];
	NSMutableArray *result = [[NSMutableArray alloc] init];
	
	NSArray *objects = [self objectsForRowsInSection: section];
	NSPredicate *rowPredicate = [NSPredicate predicateWithFormat: [self stringForKey: @"predicate"
																		 withDefault: @"TRUEPREDICATE"
																		inDictionary: self.dictionary]];
	NSObject *rowObject;
	RCSTableRow *row;
	NSUInteger i = startIndex;
	for (NSObject *obj in objects) {
		rowObject = obj == nullValue ? section.object : obj;
		if ([rowPredicate evaluateWithObject: rowObject]) {
			row = [[RCSTableRow alloc] initUsingDefintion: self
										   withRootObject: rowObject
											   forSection: section
											  atIndexPath: [NSIndexPath indexPathForRow: i++
																			  inSection: section.index]];
			[result addObject: row];
			[row release];
		}
	}
	
	return [result autorelease];
}

- (Class) cellClass
{
	if (_cellClass == nil) {
		if (_cellClassName == nil) {
			_cellClass = [UITableViewCell class];
		} else {
			_cellClass = NSClassFromString(_cellClassName);
		}
	}
	return _cellClass;
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
