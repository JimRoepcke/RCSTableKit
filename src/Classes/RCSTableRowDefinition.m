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

@synthesize cellNibName=_cellNibName;
@synthesize cellClassName=_cellClassName;
@synthesize cellClass=_cellClass;

@synthesize staticCellStyle=_staticCellStyle;
@synthesize cellStyle=_cellStyle;
@synthesize cellStyleSelector=_cellStyleSelector;

@synthesize becomeFirstResponder=_becomeFirstResponder;
@synthesize rowHeight=_rowHeight;	

@synthesize backgroundColor=_backgroundColor;
@synthesize backgroundColorSelector=_backgroundColorSelector;

@synthesize staticDetailText=_staticDetailText;
@synthesize detailText=_detailText;
@synthesize detailTextSelector=_detailTextSelector;

@synthesize staticImageName=_staticImageName;
@synthesize image=_image;
@synthesize imageSelector=_imageSelector;

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

// FIXME: instead of explicitly setting each property here, make each accessor
// method lazily pull the value from dictionary_
- (id) initWithDictionary: (NSDictionary *)dictionary_
				   forKey: (NSString *)key_
{
	self = [super init];
	if (self != nil) {
		_dictionary = [dictionary_ retain];
		_key = [key_ retain];
		_list = [[dictionary_ objectForKey: @"list"] retain];
		_cellClass = nil;

		NSString *s;
		// staticCellStyle
		if ((s = [_dictionary objectForKey: @"staticCellStyle"])) {
			if ([@"value1" isEqualToString: s]) {
				_staticCellStyle = UITableViewCellStyleValue1;
			} else if ([@"value2" isEqualToString: s]) {
				_staticCellStyle = UITableViewCellStyleValue2;
			} else if ([@"subtitle" isEqualToString: s]) {
				_staticCellStyle = UITableViewCellStyleSubtitle;
			} else {
				_staticCellStyle = UITableViewCellStyleDefault;
			}
		} else {
			_staticCellStyle = UITableViewCellStyleDefault;
		}
		
		// editingStyle
		if ((s = [_dictionary objectForKey: @"editingStyle"])) {
			if ([@"insert" isEqualToString: s]) {
				_editingStyle = UITableViewCellEditingStyleInsert;
			} else if ([@"delete" isEqualToString: s]) {
				_editingStyle = UITableViewCellEditingStyleDelete;
			} else {
				_editingStyle = UITableViewCellEditingStyleNone;
			}
		} else {
			_editingStyle = UITableViewCellEditingStyleNone;
		}
		
		// staticAccessoryType
		if ((s = [_dictionary objectForKey: @"staticAccessoryType"])) {
			if ([@"disclosureIndicator" isEqualToString: s]) {
				_staticAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
			} else if ([@"detailDisclosureIndicator" isEqualToString: s]) {
				_staticAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			} else if ([@"checkmark" isEqualToString: s]) {
				_staticAccessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				_staticAccessoryType = UITableViewCellAccessoryNone;
			}
		} else {
			_staticAccessoryType = UITableViewCellAccessoryNone;
		}

		// staticEditingAccessoryType
		if ((s = [_dictionary objectForKey: @"staticEditingAccessoryType"])) {
			if ([@"disclosureIndicator" isEqualToString: s]) {
				_staticEditingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
			} else if ([@"detailDisclosureIndicator" isEqualToString: s]) {
				_staticEditingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			} else if ([@"checkmark" isEqualToString: s]) {
				_staticEditingAccessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				_staticEditingAccessoryType = UITableViewCellAccessoryNone;
			}
		} else {
			_staticEditingAccessoryType = UITableViewCellAccessoryNone;
		}
		
		_cellStyle = [[dictionary_ objectForKey: @"cellStyle"] retain];
		_cellStyleSelector = NSSelectorFromString([dictionary_ objectForKey: @"cellStyleSelector"]);
		_accessoryType = [[dictionary_ objectForKey: @"accessoryType"] retain];
		_accessoryTypeSelector = NSSelectorFromString([dictionary_ objectForKey: @"accessoryTypeSelector"]);
		_editingAccessoryType = [[dictionary_ objectForKey: @"editingAccessoryType"] retain];
		_editingAccessoryTypeSelector = NSSelectorFromString([dictionary_ objectForKey: @"editingAccessoryTypeSelector"]);
		_cellNibName = [[dictionary_ objectForKey: @"cellNibName"] retain];
		_cellClassName = [[self stringForKey: @"cell" withDefault: @"RCSTableViewCell" inDictionary: dictionary_] retain];
		_editPushConfiguration = [[dictionary_ objectForKey: @"editPushConfiguration"] retain];
		_viewPushConfiguration = [[dictionary_ objectForKey: @"viewPushConfiguration"] retain];
		_pushConfiguration = [[dictionary_ objectForKey: @"pushConfiguration"] retain];
		_accessoryPushConfiguration = [[dictionary_ objectForKey: @"accessoryPushConfiguration"] retain];
		_editAccessoryPushConfiguration = [[dictionary_ objectForKey: @"editAccessoryPushConfiguration"] retain];
		_viewAccessoryPushConfiguration = [[dictionary_ objectForKey: @"viewAccessoryPushConfiguration"] retain];
		_staticDetailText = [[dictionary_ objectForKey: @"staticDetailText"] retain];
		_detailText = [[dictionary_ objectForKey: @"detailText"] retain];
		_detailTextSelector = NSSelectorFromString([dictionary_ objectForKey: @"detailTextSelector"]);
		_staticImageName = [[dictionary_ objectForKey: @"staticImageName"] retain];
		_image = [[dictionary_ objectForKey: @"image"] retain];
		_imageSelector = NSSelectorFromString([dictionary_ objectForKey: @"imageSelector"]);
		_backgroundColor = [[dictionary_ objectForKey: @"backgroundColor"] retain];
		_backgroundColorSelector = NSSelectorFromString([dictionary_ objectForKey: @"backgroundColorSelector"]);
		_becomeFirstResponder = [self boolForKey: @"becomeFirstResponder" withDefault: NO inDictionary: dictionary_];
		_editingStyleAction = NSSelectorFromString([dictionary_ objectForKey: @"editingStyleAction"]);
		_editingStylePushConfiguration = [[dictionary_ objectForKey: @"editingStylePushConfiguration"] retain];
		_editAction = NSSelectorFromString([dictionary_ objectForKey: @"editAction"]);
		_viewAction = NSSelectorFromString([dictionary_ objectForKey: @"viewAction"]);
		_action = NSSelectorFromString([dictionary_ objectForKey: @"action"]);
		_editAccessoryAction = NSSelectorFromString([dictionary_ objectForKey: @"editAccessoryAction"]);
		_viewAccessoryAction = NSSelectorFromString([dictionary_ objectForKey: @"viewAccessoryAction"]);
		_accessoryAction = NSSelectorFromString([dictionary_ objectForKey: @"accessoryAction"]);
		_rowHeight = (CGFloat)[self floatForKey: @"rowHeight" withDefault: -1.0 inDictionary: dictionary_];
	}
	return self;
}

- (void) dealloc
{
	[_willSelectBlock release]; _willSelectBlock = nil;
	[_textBlock release]; _textBlock = nil;

	[_dictionary release]; _dictionary = nil;
	[_key release]; _key = nil;
	[_list release]; _list = nil;
	
	[_accessoryType release]; _accessoryType = nil;
	[_editingAccessoryType release]; _editingAccessoryType = nil;
	[_cellNibName release]; _cellNibName = nil;
	[_cellClassName release]; _cellClassName = nil;
	[_backgroundColor release]; _backgroundColor = nil;
	[_staticDetailText release]; _staticDetailText = nil;
	[_detailText release]; _detailText = nil;
	[_staticImageName release]; _staticImageName = nil;
	[_image release]; _image = nil;
	[_editingStylePushConfiguration release]; _editingStylePushConfiguration = nil;
	[_pushConfiguration release]; _pushConfiguration = nil;
	[_viewPushConfiguration release]; _viewPushConfiguration = nil;
	[_editPushConfiguration release]; _editPushConfiguration = nil;
	[_accessoryPushConfiguration release]; _accessoryPushConfiguration = nil;
	[_viewAccessoryPushConfiguration release]; _viewAccessoryPushConfiguration = nil;
	[_editAccessoryPushConfiguration release]; _editAccessoryPushConfiguration = nil;
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
	NSString *predicate = [_dictionary objectForKey: @"predicate"];
	NSPredicate *rowPredicate = nil;
	BOOL (^rowTest)(NSObject *);
	if (predicate) {
		rowPredicate = [NSPredicate predicateWithFormat: predicate];
		rowTest = ^(NSObject *ro) { return [rowPredicate evaluateWithObject: ro]; };
	} else {
		rowTest = ^(NSObject *ro) { return YES; };
	}
	NSObject *rowObject;
	RCSTableRow *row;
	NSUInteger i = startIndex;
	NSUInteger sectionIndex = section.index;
	NSObject *sectionObject = section.object;
	for (NSObject *obj in objects) {
		rowObject = obj == nullValue ? sectionObject : obj;
		if (rowTest(rowObject)) {
			row = [[RCSTableRow alloc] initUsingDefintion: self
										   withRootObject: rowObject
											   forSection: section
											  atIndexPath: [NSIndexPath indexPathForRow: i++
																			  inSection: sectionIndex]];
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

- (NSIndexPath *) row: (RCSTableRow *)aRow willSelect: (NSIndexPath *)anIndexPath
{
	// yeah yeah this is crazy, but it's fun and cool
	// this class is a flyweight so this computation will
	// be re-used for every row
	if (_willSelectBlock == nil) {
		if (_action || _pushConfiguration) {
			_willSelectBlock = [^(RCSTableRow *row, NSIndexPath *input) { return input; } copy];
		} else {
			BOOL indexPathWhenEditing = _editAction || _editPushConfiguration;
			BOOL indexPathWhenViewing = _viewAction || _viewPushConfiguration;
			if (indexPathWhenEditing && indexPathWhenViewing) {
				_willSelectBlock = [^(RCSTableRow *row, NSIndexPath *input) { return input; } copy];
			} else if (indexPathWhenEditing) {
				_willSelectBlock = [^(RCSTableRow *row, NSIndexPath *input) { return row.section.table.controller.editing ? input : nil; } copy];
			} else if (indexPathWhenViewing) {
				_willSelectBlock = [^(RCSTableRow *row, NSIndexPath *input) { return row.section.table.controller.editing ? nil : input; } copy];
			} else {
				_willSelectBlock = [^(RCSTableRow *row, NSIndexPath *input) { return nil; } copy];
			}
		}
	}
	return _willSelectBlock(aRow, anIndexPath);
}

- (NSString *) text: (RCSTableRow *)aRow
{
	if (_textBlock == nil) {
		NSString *s = [_dictionary objectForKey: @"staticText"];
		if (s) _textBlock = [^(RCSTableRow *r) { return s; } copy];
		else {
			s = [_dictionary objectForKey: @"text"];
			if (s) _textBlock = [^(RCSTableRow *r) { return [[r object] valueForKeyPath: s]; } copy];
			else {
				SEL sel = NSSelectorFromString([_dictionary objectForKey: @"textSelector"]);
				if (sel) _textBlock = [^(RCSTableRow *r) { return [r.section.table.controller performSelector: sel withObject: r]; } copy];
				else _textBlock = [^(RCSTableRow *r) { return nil; } copy];
			}
		}
	}
	return _textBlock(aRow);
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
