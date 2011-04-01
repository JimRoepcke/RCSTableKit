//
//  RCSTableRowDefinition.m
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSTableViewController.h"

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

@synthesize becomeFirstResponder=_becomeFirstResponder;
@synthesize rowHeight=_rowHeight;	

@synthesize editingStyle=_editingStyle;
@synthesize editingStyleAction=_editingStyleAction;
@synthesize editingStylePushConfiguration=_editingStylePushConfiguration;

@synthesize action=_action;
@synthesize pushConfiguration=_pushConfiguration;
@synthesize viewAction=_viewAction;
@synthesize viewPushConfiguration=_viewPushConfiguration;
@synthesize editAction=_editAction;
@synthesize editPushConfiguration=_editPushConfiguration;

@synthesize accessoryAction=_accessoryAction;
@synthesize accessoryPushConfiguration=_accessoryPushConfiguration;
@synthesize viewAccessoryAction=_viewAccessoryAction;
@synthesize viewAccessoryPushConfiguration=_viewAccessoryPushConfiguration;
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

		// editingStyle
		NSString *s;
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
		
		_cellNibName = [[dictionary_ objectForKey: @"cellNibName"] retain];
		_editPushConfiguration = [[dictionary_ objectForKey: @"editPushConfiguration"] retain];
		_viewPushConfiguration = [[dictionary_ objectForKey: @"viewPushConfiguration"] retain];
		_pushConfiguration = [[dictionary_ objectForKey: @"pushConfiguration"] retain];
		_accessoryPushConfiguration = [[dictionary_ objectForKey: @"accessoryPushConfiguration"] retain];
		_editAccessoryPushConfiguration = [[dictionary_ objectForKey: @"editAccessoryPushConfiguration"] retain];
		_viewAccessoryPushConfiguration = [[dictionary_ objectForKey: @"viewAccessoryPushConfiguration"] retain];
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
	[_didSelectBlock release]; _didSelectBlock = nil;
	[_accessoryButtonBlock release]; _accessoryButtonBlock = nil;
	[_textBlock release]; _textBlock = nil;
	[_detailTextBlock release]; _detailTextBlock = nil;
	[_imageBlock release]; _imageBlock = nil;
	[_accessoryTypeBlock release]; _accessoryTypeBlock = nil;
	[_editingAccessoryTypeBlock release]; _editingAccessoryTypeBlock = nil;
	[_cellStyleBlock release]; _cellStyleBlock = nil;
	[_cellClassBlock release]; _cellClassBlock = nil;
	[_backgroundColorBlock release]; _backgroundColorBlock = nil;

	[_dictionary release]; _dictionary = nil;
	[_key release]; _key = nil;
	[_list release]; _list = nil;
	
	[_cellNibName release]; _cellNibName = nil;
	[_editingStylePushConfiguration release]; _editingStylePushConfiguration = nil;
	[_pushConfiguration release]; _pushConfiguration = nil;
	[_viewPushConfiguration release]; _viewPushConfiguration = nil;
	[_editPushConfiguration release]; _editPushConfiguration = nil;
	[_accessoryPushConfiguration release]; _accessoryPushConfiguration = nil;
	[_viewAccessoryPushConfiguration release]; _viewAccessoryPushConfiguration = nil;
	[_editAccessoryPushConfiguration release]; _editAccessoryPushConfiguration = nil;
	[super dealloc];
}

- (void) pushConfiguration: (NSString *)name withRootObject: (NSObject *)object usingController: (RCSTableViewController *)controller
{
	// FIXME: avoid creating a new RCSTableDefinition here if possible
	// TODO: support pulling the bundle from the same bundle as the current definition came from
	RCSTableDefinition *def = [RCSTableDefinition tableDefinitionNamed: name inBundle: nil];
	UIViewController *vc = [def viewControllerWithRootObject: object == controller ? nil : object];
	[[controller navigationController] pushViewController: vc animated: YES];
}

- (NSArray *) objectsForRowsInSection: (RCSTableSection *)section
{
	if (_list == nil) {
		NSString *objectKeyPath = [_dictionary objectForKey: @"object"];
		return [NSArray arrayWithObject: objectKeyPath ?
				[[section object] valueForKeyPath: objectKeyPath] :
				[NSNull null]];
	}
	return [[section object] valueForKeyPath: _list];
}

#pragma mark -
#pragma mark Public API

// called by RCSTableSectionDefinition's rowsForSection:
// returns an array of RCSTableRow objects
- (NSMutableArray *) rowsForSection: (RCSTableSection *)section
{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	
	NSArray *objects = [self objectsForRowsInSection: section];
	NSString *predicate = [_dictionary objectForKey: @"predicate"];
	NSPredicate *rowPredicate = nil;
	BOOL (^rowTest)(NSObject *);
	if ([predicate length] > 0) {
		rowPredicate = [NSPredicate predicateWithFormat: predicate];
		rowTest = ^(NSObject *ro) { return [rowPredicate evaluateWithObject: ro]; };
	} else {
		rowTest = ^(NSObject *ro) { return YES; };
	}
	NSObject *rowObject;
	RCSTableRow *row;
	NSObject *sectionObject = [section object];
	NSNull *nullValue = [NSNull null];
	for (NSObject *obj in objects) {
		rowObject = obj == nullValue ? sectionObject : obj;
		if (rowTest(rowObject)) {
			row = [[RCSTableRow alloc] initUsingDefintion: self
										   withRootObject: rowObject
											   forSection: section];
			[result addObject: row];
			[row release];
		}
	}
	return [result autorelease];
}

- (Class) cellClass: (RCSTableRow *)aRow
{
	if (_cellClassBlock == nil) {
		NSString *s = [_dictionary objectForKey: @"staticCell"];
		if (s) _cellClassBlock = [^(RCSTableRow *r) {
			Class c = NSClassFromString(s);
			return c ? c : [RCSTableViewCell class];
		} copy];
		else {
			s = [_dictionary objectForKey: @"cell"];
			if (s) _cellClassBlock = [^(RCSTableRow *r) {
				NSString *cs = [[r object] valueForKeyPath: s];
				Class c = cs ? NSClassFromString(cs) : nil;
				return c ? c : [RCSTableViewCell class];
			} copy];
			else {
				SEL sel = NSSelectorFromString([_dictionary objectForKey: @"cellSelector"]);
				if (sel) _cellClassBlock = [^(RCSTableRow *r) {
					Class c = [[r controller] performSelector: sel withObject: r];
					return c ? c : [RCSTableViewCell class];
				} copy];
				else _cellClassBlock = [^(RCSTableRow *r) { return [RCSTableViewCell class]; } copy];
			}
		}
	}
	return _cellClassBlock(aRow);
}

- (void) rowCommitEditingStyle: (RCSTableRow *)aRow
{
	RCSTableViewController *controller = [aRow controller];
	if (_editingStyleAction) {
		[controller performSelector: _editingStyleAction withObject: aRow];
		// FIXME: this should happen via a callback, or something, right?
		// if (_editingStyle == UITableViewCellEditingStyleDelete) {
		//     something that makes a delete happen goes here
		// }
	} else if (_editingStylePushConfiguration) {
		[self pushConfiguration: _editingStylePushConfiguration withRootObject: [aRow object] usingController: [aRow controller]];
	}
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
				_willSelectBlock = [^(RCSTableRow *r, NSIndexPath *input) { return input; } copy];
			} else if (indexPathWhenEditing) {
				_willSelectBlock = [^(RCSTableRow *r, NSIndexPath *input) { return [[r controller] isEditing] ? input : nil; } copy];
			} else if (indexPathWhenViewing) {
				_willSelectBlock = [^(RCSTableRow *r, NSIndexPath *input) { return [[r controller] isEditing] ? nil : input; } copy];
			} else {
				_willSelectBlock = [^(RCSTableRow *r, NSIndexPath *input) { return nil; } copy];
			}
		}
	}
	return _willSelectBlock(aRow, anIndexPath);
}

- (void) rowDidSelect: (RCSTableRow *)aRow
{
	if (_didSelectBlock == nil) {
		__block __typeof__(self) blockSelf = self;
		if (_action) _didSelectBlock = [^(RCSTableRow *r) { [[r controller] performSelector: blockSelf->_action withObject: r]; } copy];
		else {
			if (_pushConfiguration) _didSelectBlock = [^(RCSTableRow *r) { [blockSelf pushConfiguration: blockSelf->_pushConfiguration withRootObject: [r object] usingController: [r controller]]; } copy];
			else {
				// editing
				void (^editing)(RCSTableRow *) = nil;
				if (_editAction) editing = ^(RCSTableRow *r) { [[r controller] performSelector: blockSelf->_editAction withObject: r]; };
				else if (_editPushConfiguration) editing = ^(RCSTableRow *r) { [blockSelf pushConfiguration: blockSelf->_editPushConfiguration withRootObject: [r object] usingController: [r controller]]; };
				// not editing (viewing)
				void (^viewing)(RCSTableRow *) = nil;
				if (_viewAction) viewing = ^(RCSTableRow *r) { [[r controller] performSelector: blockSelf->_viewAction withObject: r]; };
				else if (_viewPushConfiguration) viewing = ^(RCSTableRow *r) { [blockSelf pushConfiguration: blockSelf->_viewPushConfiguration withRootObject: [r object] usingController: [r controller]]; };
				_didSelectBlock = [^(RCSTableRow *r) {
					if ([[r controller] isEditing]) {
						if (editing) editing(r);
					} else {
						if (viewing) viewing(r);
					}
				} copy];
			}
		}
	}
	_didSelectBlock(aRow);
}

- (void) rowAccessoryButtonTapped: (RCSTableRow *)aRow
{
	if (_accessoryButtonBlock == nil) {
		__block __typeof__(self) blockSelf = self;
		if (_accessoryAction) _accessoryButtonBlock = [^(RCSTableRow *r) { [[r controller] performSelector: blockSelf->_accessoryAction withObject: r]; } copy];
		else {
			if (_accessoryPushConfiguration) _accessoryButtonBlock = [^(RCSTableRow *r) { [blockSelf pushConfiguration: blockSelf->_accessoryPushConfiguration withRootObject: [r object] usingController: [r controller]]; } copy];
			else {
				// editing
				void (^editing)(RCSTableRow *) = nil;
				if (_editAccessoryAction) editing = ^(RCSTableRow *r) { [[r controller] performSelector: blockSelf->_editAccessoryAction withObject: r]; };
				else if (_editAccessoryPushConfiguration) editing = ^(RCSTableRow *r) { [blockSelf pushConfiguration: blockSelf->_editAccessoryPushConfiguration withRootObject: [r object] usingController: [r controller]]; };
				// not editing (viewing)
				void (^viewing)(RCSTableRow *) = nil;
				if (_viewAccessoryAction) viewing = ^(RCSTableRow *r) { [[r controller] performSelector: blockSelf->_viewAccessoryAction withObject: r]; };
				else if (_viewAccessoryPushConfiguration) viewing = ^(RCSTableRow *r) { [blockSelf pushConfiguration: blockSelf->_viewAccessoryPushConfiguration withRootObject: [r object] usingController: [r controller]]; };
				_accessoryButtonBlock = [^(RCSTableRow *r) {
					if ([[r controller] isEditing]) {
						if (editing) editing(r);
					} else {
						if (viewing) viewing(r);
					}
				} copy];
			}
		}
	}
	_accessoryButtonBlock(aRow);
}

- (UIColor *) backgroundColor: (RCSTableRow *)aRow
{
	if (_backgroundColorBlock == nil) {
		NSString *s = [_dictionary objectForKey: @"backgroundColor"];
		if (s) _backgroundColorBlock = [^(RCSTableRow *r) { return [[r object] valueForKey: s]; } copy];
		else {
			SEL sel = NSSelectorFromString([_dictionary objectForKey: @"backgroundColorSelector"]);
			if (sel) _backgroundColorBlock = [^(RCSTableRow *r) { return [[r controller] performSelector: sel withObject: r]; } copy];
			else _backgroundColorBlock = [^(RCSTableRow *r) { return nil; } copy];
		}
	}
	return _backgroundColorBlock(aRow);
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
				if (sel) _textBlock = [^(RCSTableRow *r) { return [[r controller] performSelector: sel withObject: r]; } copy];
				else _textBlock = [^(RCSTableRow *r) { return nil; } copy];
			}
		}
	}
	return _textBlock(aRow);
}

- (NSString *) detailText: (RCSTableRow *)aRow
{
	if (_detailTextBlock == nil) {
		NSString *s = [_dictionary objectForKey: @"staticDetailText"];
		if (s) _detailTextBlock = [^(RCSTableRow *r) { return s; } copy];
		else {
			s = [_dictionary objectForKey: @"detailText"];
			if (s) _detailTextBlock = [^(RCSTableRow *r) { return [[r object] valueForKeyPath: s]; } copy];
			else {
				SEL sel = NSSelectorFromString([_dictionary objectForKey: @"detailTextSelector"]);
				if (sel) _detailTextBlock = [^(RCSTableRow *r) { return [[r controller] performSelector: sel withObject: r]; } copy];
				else _detailTextBlock = [^(RCSTableRow *r) { return nil; } copy];
			}
		}
	}
	return _detailTextBlock(aRow);
}

- (UIImage *) image: (RCSTableRow *)aRow
{
	if (_imageBlock == nil) {
		NSString *s = [_dictionary objectForKey: @"staticImageName"];
		if (s) {
			UIImage *i = [UIImage imageNamed: s];
			_imageBlock = [^(RCSTableRow *r) { return i; } copy];
		}
		else {
			s = [_dictionary objectForKey: @"image"];
			if (s) _imageBlock = [^(RCSTableRow *r) { return [[r object] valueForKeyPath: s]; } copy];
			else {
				SEL sel = NSSelectorFromString([_dictionary objectForKey: @"imageSelector"]);
				if (sel) _imageBlock = [^(RCSTableRow *r) { return [[r controller] performSelector: sel withObject: r]; } copy];
				else _imageBlock = [^(RCSTableRow *r) { return nil; } copy];
			}
		}
	}
	return _imageBlock(aRow);
}

- (UITableViewCellAccessoryType) editingAccessoryType: (RCSTableRow *)aRow
{
	if (_editingAccessoryTypeBlock == nil) {
		NSString *s = [_dictionary objectForKey: @"staticEditingAccessoryType"];
		if (s) {
			if ([@"disclosureIndicator" isEqualToString: s]) {
				_editingAccessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryDisclosureIndicator; } copy];
			} else if ([@"detailDisclosureIndicator" isEqualToString: s]) {
				_editingAccessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryDetailDisclosureButton; } copy];
			} else if ([@"checkmark" isEqualToString: s]) {
				_editingAccessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryCheckmark; } copy];
			} else {
				_editingAccessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryNone; } copy];
			}
		} else {
			s = [_dictionary objectForKey: @"editingAccessoryType"];
			if (s) _editingAccessoryTypeBlock = [^(RCSTableRow *r) {
				NSString *typeString = [[r object] valueForKeyPath: s];
				if ([@"disclosureIndicator" isEqualToString: typeString]) { return UITableViewCellAccessoryDisclosureIndicator; }
				else if ([@"detailDisclosureIndicator" isEqualToString: typeString]) { return UITableViewCellAccessoryDetailDisclosureButton; }
				else if ([@"checkmark" isEqualToString: typeString]) { return UITableViewCellAccessoryCheckmark; }
				else { return UITableViewCellAccessoryNone; }
			} copy];
			else {
				SEL sel = NSSelectorFromString([_dictionary objectForKey: @"editingAccessoryTypeSelector"]);
				if (sel) _editingAccessoryTypeBlock = [^(RCSTableRow *r) {
					NSNumber *type = [[r controller] performSelector: sel withObject: r];
					return (UITableViewCellAccessoryType)[type intValue];
				} copy];
				else _editingAccessoryTypeBlock = [^(RCSTableRow *r) { return nil; } copy];
			}
		}
	}
	return _editingAccessoryTypeBlock(aRow);
}

- (UITableViewCellAccessoryType) accessoryType: (RCSTableRow *)aRow
{
	if ([[aRow controller] isEditing]) return [self editingAccessoryType: aRow];
	if (_accessoryTypeBlock == nil) {
		NSString *s = [_dictionary objectForKey: @"staticAccessoryType"];
		if (s) {
			if ([@"disclosureIndicator" isEqualToString: s]) {
				_accessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryDisclosureIndicator; } copy];
			} else if ([@"detailDisclosureIndicator" isEqualToString: s]) {
				_accessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryDetailDisclosureButton; } copy];
			} else if ([@"checkmark" isEqualToString: s]) {
				_accessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryCheckmark; } copy];
			} else {
				_accessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryNone; } copy];
			}
		} else {
			s = [_dictionary objectForKey: @"accessoryType"];
			if (s) _accessoryTypeBlock = [^(RCSTableRow *r) {
				NSString *typeString = [[r object] valueForKeyPath: s];
				if ([@"disclosureIndicator" isEqualToString: typeString]) { return UITableViewCellAccessoryDisclosureIndicator; }
				else if ([@"detailDisclosureIndicator" isEqualToString: typeString]) { return UITableViewCellAccessoryDetailDisclosureButton; }
				else if ([@"checkmark" isEqualToString: typeString]) { return UITableViewCellAccessoryCheckmark; }
				else { return UITableViewCellAccessoryNone; }
			} copy];
			else {
				SEL sel = NSSelectorFromString([_dictionary objectForKey: @"accessoryTypeSelector"]);
				if (sel) _accessoryTypeBlock = [^(RCSTableRow *r) {
					NSNumber *type = [[r controller] performSelector: sel withObject: r];
					return (UITableViewCellAccessoryType)[type intValue];
				} copy];
				else _accessoryTypeBlock = [^(RCSTableRow *r) { return nil; } copy];
			}
		}
	}
	return _accessoryTypeBlock(aRow);
}


- (UITableViewCellStyle) cellStyle: (RCSTableRow *)aRow
{
	if (_cellStyleBlock == nil) {
		NSString *s = [_dictionary objectForKey: @"staticCellStyle"];
		if (s) {
			if ([@"value1" isEqualToString: s]) {
				_cellStyleBlock = [^(RCSTableRow *r) { return UITableViewCellStyleValue1; } copy];
			} else if ([@"value2" isEqualToString: s]) {
				_cellStyleBlock = [^(RCSTableRow *r) { return UITableViewCellStyleValue2; } copy];
			} else if ([@"subtitle" isEqualToString: s]) {
				_cellStyleBlock = [^(RCSTableRow *r) { return UITableViewCellStyleSubtitle; } copy];
			} else {
				_cellStyleBlock = [^(RCSTableRow *r) { return UITableViewCellStyleDefault; } copy];
			}
		} else {
			s = [_dictionary objectForKey: @"cellStyle"];
			if (s) _cellStyleBlock = [^(RCSTableRow *r) {
				NSString *styleString = [[r object] valueForKeyPath: s];
				if ([@"value1" isEqualToString: styleString]) { return UITableViewCellStyleValue1; }
				else if ([@"value2" isEqualToString: styleString]) { return UITableViewCellStyleValue2; }
				else if ([@"subtitle" isEqualToString: styleString]) { return UITableViewCellStyleSubtitle; }
				else { return UITableViewCellStyleDefault; }
			} copy];
			else {
				SEL sel = NSSelectorFromString([_dictionary objectForKey: @"cellStyleSelector"]);
				if (sel) _cellStyleBlock = [^(RCSTableRow *r) {
					NSNumber *type = [[r controller] performSelector: sel withObject: r];
					return (UITableViewCellStyle)[type intValue];
				} copy];
				else _cellStyleBlock = [^(RCSTableRow *r) { return nil; } copy];
			}
		}
	}
	return _cellStyleBlock(aRow);
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
