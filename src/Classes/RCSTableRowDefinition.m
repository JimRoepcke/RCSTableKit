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

@synthesize staticText=_staticText;
@synthesize text=_text;
@synthesize textSelector=_textSelector;

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
		self.dictionary = dictionary_;
		self.key = key_;
		self.list = [dictionary_ objectForKey: @"list"];
		_cellClass = nil;

		NSString *s;
		// staticCellStyle
		if ((s = [_dictionary objectForKey: @"staticCellStyle"])) {
			if ([@"value1" isEqualToString: s]) {
				self.staticCellStyle = UITableViewCellStyleValue1;
			} else if ([@"value2" isEqualToString: s]) {
				self.staticCellStyle = UITableViewCellStyleValue2;
			} else if ([@"subtitle" isEqualToString: s]) {
				self.staticCellStyle = UITableViewCellStyleSubtitle;
			} else {
				self.staticCellStyle = UITableViewCellStyleDefault;
			}
		} else {
			self.staticCellStyle = UITableViewCellStyleDefault;
		}
		
		// editingStyle
		if ((s = [_dictionary objectForKey: @"editingStyle"])) {
			if ([@"insert" isEqualToString: s]) {
				self.editingStyle = UITableViewCellEditingStyleInsert;
			} else if ([@"delete" isEqualToString: s]) {
				self.editingStyle = UITableViewCellEditingStyleDelete;
			} else {
				self.editingStyle = UITableViewCellEditingStyleNone;
			}
		} else {
			self.editingStyle = UITableViewCellEditingStyleNone;
		}
		
		// staticAccessoryType
		if ((s = [_dictionary objectForKey: @"staticAccessoryType"])) {
			if ([@"disclosureIndicator" isEqualToString: s]) {
				self.staticAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
			} else if ([@"detailDisclosureIndicator" isEqualToString: s]) {
				self.staticAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			} else if ([@"checkmark" isEqualToString: s]) {
				self.staticAccessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				self.staticAccessoryType = UITableViewCellAccessoryNone;
			}
		} else {
			self.staticAccessoryType = UITableViewCellAccessoryNone;
		}

		// staticEditingAccessoryType
		if ((s = [_dictionary objectForKey: @"staticEditingAccessoryType"])) {
			if ([@"disclosureIndicator" isEqualToString: s]) {
				self.staticEditingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
			} else if ([@"detailDisclosureIndicator" isEqualToString: s]) {
				self.staticEditingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			} else if ([@"checkmark" isEqualToString: s]) {
				self.staticEditingAccessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				self.staticEditingAccessoryType = UITableViewCellAccessoryNone;
			}
		} else {
			self.staticEditingAccessoryType = UITableViewCellAccessoryNone;
		}
		
		self.cellStyle = [dictionary_ objectForKey: @"cellStyle"];
		self.cellStyleSelector = NSSelectorFromString([dictionary_ objectForKey: @"cellStyleSelector"]);
		self.accessoryType = [dictionary_ objectForKey: @"accessoryType"];
		self.accessoryTypeSelector = NSSelectorFromString([dictionary_ objectForKey: @"accessoryTypeSelector"]);
		self.editingAccessoryType = [dictionary_ objectForKey: @"editingAccessoryType"];
		self.editingAccessoryTypeSelector = NSSelectorFromString([dictionary_ objectForKey: @"editingAccessoryTypeSelector"]);
		self.cellNibName = [dictionary_ objectForKey: @"cellNibName"];
		self.cellClassName = [self stringForKey: @"cell" withDefault: @"RCSTableViewCell" inDictionary: dictionary_];
		self.editPushConfiguration = [dictionary_ objectForKey: @"editPushConfiguration"];
		self.viewPushConfiguration = [dictionary_ objectForKey: @"viewPushConfiguration"];
		self.pushConfiguration = [dictionary_ objectForKey: @"pushConfiguration"];
		self.accessoryPushConfiguration = [dictionary_ objectForKey: @"accessoryPushConfiguration"];
		self.editAccessoryPushConfiguration = [dictionary_ objectForKey: @"editAccessoryPushConfiguration"];
		self.viewAccessoryPushConfiguration = [dictionary_ objectForKey: @"viewAccessoryPushConfiguration"];
		self.staticText = [dictionary_ objectForKey: @"staticText"];
		self.text = [dictionary_ objectForKey: @"text"];
		self.textSelector = NSSelectorFromString([dictionary_ objectForKey: @"textSelector"]);
		self.staticDetailText = [dictionary_ objectForKey: @"staticDetailText"];
		self.detailText = [dictionary_ objectForKey: @"detailText"];
		self.detailTextSelector = NSSelectorFromString([dictionary_ objectForKey: @"detailTextSelector"]);
		self.staticImageName = [dictionary_ objectForKey: @"staticImageName"];		
		self.image = [dictionary_ objectForKey: @"image"];
		self.imageSelector = NSSelectorFromString([dictionary_ objectForKey: @"imageSelector"]);
		self.backgroundColor = [dictionary_ objectForKey: @"backgroundColor"];
		self.backgroundColorSelector = NSSelectorFromString([dictionary_ objectForKey: @"backgroundColorSelector"]);
		self.becomeFirstResponder = [self boolForKey: @"becomeFirstResponder" withDefault: NO inDictionary: dictionary_];
		self.editingStyleAction = NSSelectorFromString([dictionary_ objectForKey: @"editingStyleAction"]);
		self.editingStylePushConfiguration = [dictionary_ objectForKey: @"editingStylePushConfiguration"];
		self.editAction = NSSelectorFromString([dictionary_ objectForKey: @"editAction"]);
		self.viewAction = NSSelectorFromString([dictionary_ objectForKey: @"viewAction"]);
		self.action = NSSelectorFromString([dictionary_ objectForKey: @"action"]);
		self.editAccessoryAction = NSSelectorFromString([dictionary_ objectForKey: @"editAccessoryAction"]);
		self.viewAccessoryAction = NSSelectorFromString([dictionary_ objectForKey: @"viewAccessoryAction"]);
		self.accessoryAction = NSSelectorFromString([dictionary_ objectForKey: @"accessoryAction"]);
		self.rowHeight = (CGFloat)[self floatForKey: @"rowHeight" withDefault: -1.0 inDictionary: dictionary_];
	}
	return self;
}

- (void) dealloc
{
	[_dictionary release]; _dictionary = nil;
	[_key release]; _key = nil;
	[_list release]; _list = nil;
	
	[_accessoryType release]; _accessoryType = nil;
	[_editingAccessoryType release]; _editingAccessoryType = nil;
	[_cellNibName release]; _cellNibName = nil;
	[_cellClassName release]; _cellClassName = nil;
	[_backgroundColor release]; _backgroundColor = nil;
	[_staticText release]; _staticText = nil;
	[_text release]; _text = nil;
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
