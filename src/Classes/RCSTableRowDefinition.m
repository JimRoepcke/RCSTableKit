//
//  RCSTableRowDefinition.m
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSTableRowDefinition.h"
#import "RCSTableViewController.h"
#import "RCSTableKitConstants.h"
#import "RCSTableSectionDefinition.h"
#import "RCSTableDefinition.h"
#import "RCSTableSection.h"
#import "RCSTableRow.h"
#import "RCSTableViewCell.h"

@interface RCSTableRowDefinition ()
@property (nonatomic, readwrite, strong) NSDictionary *dictionary;
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *list;

@property (nonatomic, readwrite, copy) NSIndexPath *(^willSelectBlock)(RCSTableRow *row, NSIndexPath *input);
@property (nonatomic, readwrite, copy) void (^didSelectBlock)(RCSTableRow *row);
@property (nonatomic, readwrite, copy) void (^accessoryButtonBlock)(RCSTableRow *row);
@property (nonatomic, readwrite, copy) NSString *(^textBlock)(RCSTableRow *row);
@property (nonatomic, readwrite, copy) NSString *(^detailTextBlock)(RCSTableRow *row);
@property (nonatomic, readwrite, copy) UIImage *(^imageBlock)(RCSTableRow *row);
@property (nonatomic, readwrite, copy) UITableViewCellAccessoryType (^accessoryTypeBlock)(RCSTableRow *row);
@property (nonatomic, readwrite, copy) UITableViewCellAccessoryType (^editingAccessoryTypeBlock)(RCSTableRow *row);
@property (nonatomic, readwrite, copy) UITableViewCellStyle (^cellStyleBlock)(RCSTableRow *row);
@property (nonatomic, readwrite, copy) Class (^cellClassBlock)(RCSTableRow *row);
@property (nonatomic, readwrite, copy) UIColor *(^backgroundColorBlock)(RCSTableRow *row);
@end

@implementation RCSTableRowDefinition

@synthesize parent=_parent;
@synthesize dictionary=_dictionary;
@synthesize name=_name;
@synthesize list=_list;

@synthesize cellReuseIdentifier=_cellReuseIdentifier;

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

@synthesize willSelectBlock=_willSelectBlock;
@synthesize didSelectBlock=_didSelectBlock;

@synthesize accessoryButtonBlock=_accessoryButtonBlock;
@synthesize textBlock=_textBlock;
@synthesize detailTextBlock=_detailTextBlock;
@synthesize imageBlock=_imageBlock;
@synthesize accessoryTypeBlock=_accessoryTypeBlock;
@synthesize editingAccessoryTypeBlock=_editingAccessoryTypeBlock;
@synthesize cellStyleBlock=_cellStyleBlock;
@synthesize cellClassBlock=_cellClassBlock;
@synthesize backgroundColorBlock=_backgroundColorBlock;

// FIXME: instead of explicitly setting each property here, make each accessor
// method lazily pull the value from dictionary_
- (id) initWithName: (NSString *)name_
         dictionary: (NSDictionary *)dictionary_
             parent: (RCSTableSectionDefinition *)parent_
{
	if (self = [super init]) {
		_name = [name_ copy];
		_dictionary = dictionary_;
        _parent = parent_;
		_list = [[dictionary_ objectForKey: kTKListKey] copy];
        
		// editingStyle
		NSString *s;
		if ((s = [_dictionary objectForKey: kTKEditingStyleKey])) {
			if ([kTKEditingStyleInsertKey isEqualToString: s]) {
				_editingStyle = UITableViewCellEditingStyleInsert;
			} else if ([kTKEditingStyleDeleteKey isEqualToString: s]) {
				_editingStyle = UITableViewCellEditingStyleDelete;
			} else {
				_editingStyle = UITableViewCellEditingStyleNone;
			}
		} else {
			_editingStyle = UITableViewCellEditingStyleNone;
		}
		
		_cellNibName = [[dictionary_ objectForKey: kTKCellNibKey] copy];
		_editPushConfiguration = [[dictionary_ objectForKey: kTKEditPushConfigurationKey] copy];
		_viewPushConfiguration = [[dictionary_ objectForKey: kTKViewPushConfigurationKey] copy];
		_pushConfiguration = [[dictionary_ objectForKey: kTKPushConfigurationKey] copy];
		_accessoryPushConfiguration = [[dictionary_ objectForKey: kTKAccessoryPushConfigurationKey] copy];
		_editAccessoryPushConfiguration = [[dictionary_ objectForKey: kTKEditAccessoryPushConfigurationKey] copy];
		_viewAccessoryPushConfiguration = [[dictionary_ objectForKey: kTKViewAccessoryPushConfigurationKey] copy];
		_becomeFirstResponder = [[self class] boolForKey: kTKBecomeFirstResponderKey withDefault: NO inDictionary: dictionary_];
		_editingStyleAction = NSSelectorFromString([dictionary_ objectForKey: kTKEditingStyleActionKey]);
		_editingStylePushConfiguration = [[dictionary_ objectForKey: kTKEditingStylePushConfigurationKey] copy];
		_editAction = NSSelectorFromString([dictionary_ objectForKey: kTKEditActionKey]);
		_viewAction = NSSelectorFromString([dictionary_ objectForKey: kTKViewActionKey]);
		_action = NSSelectorFromString([dictionary_ objectForKey: kTKActionKey]);
		_editAccessoryAction = NSSelectorFromString([dictionary_ objectForKey: kTKEditAccessoryActionKey]);
		_viewAccessoryAction = NSSelectorFromString([dictionary_ objectForKey: kTKViewAccessoryActionKey]);
		_accessoryAction = NSSelectorFromString([dictionary_ objectForKey: kTKAccessoryActionKey]);
		_rowHeight = [[self class] floatForKey: kTKRowHeightKey withDefault: -1.0 inDictionary: dictionary_];
	}
	return self;
}

- (void) dealloc
{
    // don't think these are needed but the ARC refactorer left them
    // so I'll leave them here for now
    _willSelectBlock = nil;
    _didSelectBlock = nil;
    _accessoryButtonBlock = nil;
    _textBlock = nil;
    _detailTextBlock = nil;
    _imageBlock = nil;
    _accessoryTypeBlock = nil;
    _editingAccessoryTypeBlock = nil;
    _cellStyleBlock = nil;
    _cellClassBlock = nil;
    _backgroundColorBlock = nil;
}

- (void) pushConfiguration: (NSString *)name withRootObject: (NSObject *)object usingController: (RCSTableViewController *)controller
{
	// FIXME: avoid creating a new RCSTableDefinition here if possible
	RCSTableDefinition *def = [RCSTableDefinition tableDefinitionNamed: name inBundle: [[[self parent] parent] bundle]];
	UIViewController *vc = [def viewControllerWithRootObject: object == controller ? nil : object];
	[[controller navigationController] pushViewController: vc animated: YES];
}

- (NSArray *) objectsForRowsInSection: (RCSTableSection *)section
{
	if ((_list == nil) || ([_list length] == 0)) {
		NSString *objectKeyPath = [_dictionary objectForKey: kTKObjectKey];
		return [NSArray arrayWithObject: [objectKeyPath length] ?
				[[section object] valueForKeyPath: objectKeyPath] :
				[NSNull null]];
	}
	return [[section object] valueForKeyPath: _list];
}

#pragma mark -
#pragma mark Public API

- (Class) tableRowClass
{
    return [RCSTableRow class];
}

// called by RCSTableSectionDefinition's rowsForSection:
// returns an array of RCSTableRow objects
- (NSMutableArray *) rowsForSection: (RCSTableSection *)section
{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	
	NSArray *objects = [self objectsForRowsInSection: section];
	NSString *predicate = [_dictionary objectForKey: kTKPredicateKey];
	NSPredicate *rowPredicate;
	if ([predicate length]) {
		rowPredicate = [NSPredicate predicateWithFormat: predicate];
	}
	NSObject *rowObject;
	RCSTableRow *row;
	NSObject *sectionObject = [section object];
	NSNull *nullValue = [NSNull null];
	for (NSObject *obj in objects) {
		rowObject = obj == nullValue ? sectionObject : obj;
		if ((rowPredicate == nil) || [rowPredicate evaluateWithObject: rowObject]) {
			row = [(RCSTableRow *)[[self tableRowClass] alloc] initUsingDefintion: self
                                                                   withRootObject: rowObject
                                                                       forSection: section];
			[result addObject: row];
		}
	}
	return result;
}

- (NSString *) cellReuseIdentifier
{
	if (_cellReuseIdentifier == nil) {
		_cellReuseIdentifier = [[NSString alloc] initWithFormat: @"%d",
								(int)_dictionary];
	}
	return _cellReuseIdentifier;
}

- (Class) cellClass: (RCSTableRow *)aRow
{
	if (_cellClassBlock == nil) {
		NSString *s = [_dictionary objectForKey: kTKStaticCellKey];
		if ([s length]) _cellClassBlock = [^(RCSTableRow *r) {
			Class c = NSClassFromString(s);
			return c ? c : [RCSTableViewCell class];
		} copy];
		else {
			s = [_dictionary objectForKey: kTKCellKey];
			if ([s length]) _cellClassBlock = [^(RCSTableRow *r) {
				NSString *cs = [[r object] valueForKeyPath: s];
				Class c = cs ? NSClassFromString(cs) : nil;
				return c ? c : [RCSTableViewCell class];
			} copy];
			else {
				SEL sel = NSSelectorFromString([_dictionary objectForKey: kTKCellSelectorKey]);
				if (sel) _cellClassBlock = [^(RCSTableRow *r) {
					Class c = [[self class] receiver: [r controller] leakyPerformSelector: sel withObject: r];
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
		[[self class] receiver: controller leakyPerformSelector: _editingStyleAction withObject: aRow];
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
		__weak RCSTableRowDefinition *blockSelf = self;
		if (_action) _didSelectBlock = [^(RCSTableRow *r) { [[blockSelf class] receiver: [r controller] leakyPerformSelector: blockSelf->_action withObject: r]; } copy];
		else {
			if (_pushConfiguration) _didSelectBlock = [^(RCSTableRow *r) { [blockSelf pushConfiguration: blockSelf->_pushConfiguration withRootObject: [r object] usingController: [r controller]]; } copy];
			else {
				// editing
				void (^editing)(RCSTableRow *);
				if (_editAction) editing = ^(RCSTableRow *r) { [[blockSelf class] receiver: [r controller] leakyPerformSelector: blockSelf->_editAction withObject: r]; };
				else if (_editPushConfiguration) editing = ^(RCSTableRow *r) { [blockSelf pushConfiguration: blockSelf->_editPushConfiguration withRootObject: [r object] usingController: [r controller]]; };
				// not editing (viewing)
				void (^viewing)(RCSTableRow *);
				if (_viewAction) viewing = ^(RCSTableRow *r) { [[blockSelf class] receiver: [r controller] leakyPerformSelector: blockSelf->_viewAction withObject: r]; };
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
		__weak RCSTableRowDefinition *blockSelf = self;
		if (_accessoryAction) _accessoryButtonBlock = [^(RCSTableRow *r) { [[blockSelf class] receiver: [r controller] leakyPerformSelector: blockSelf->_accessoryAction withObject: r]; } copy];
		else {
			if (_accessoryPushConfiguration) _accessoryButtonBlock = [^(RCSTableRow *r) { [blockSelf pushConfiguration: blockSelf->_accessoryPushConfiguration withRootObject: [r object] usingController: [r controller]]; } copy];
			else {
				// editing
				void (^editing)(RCSTableRow *);
				if (_editAccessoryAction) editing = ^(RCSTableRow *r) { [[blockSelf class] receiver: [r controller] leakyPerformSelector: blockSelf->_editAccessoryAction withObject: r]; };
				else if (_editAccessoryPushConfiguration) editing = ^(RCSTableRow *r) { [blockSelf pushConfiguration: blockSelf->_editAccessoryPushConfiguration withRootObject: [r object] usingController: [r controller]]; };
				// not editing (viewing)
				void (^viewing)(RCSTableRow *);
				if (_viewAccessoryAction) viewing = ^(RCSTableRow *r) { [[blockSelf class] receiver: [r controller] leakyPerformSelector: blockSelf->_viewAccessoryAction withObject: r]; };
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
		NSString *s = [_dictionary objectForKey: kTKBackgroundColorKey];
		if ([s length]) _backgroundColorBlock = [^(RCSTableRow *r) { return [[r object] valueForKeyPath: s]; } copy];
		else {
            __weak RCSTableDefinition *blockSelf = self;
			SEL sel = NSSelectorFromString([_dictionary objectForKey: kTKBackgroundColorSelectorKey]);
			if (sel) _backgroundColorBlock = [^(RCSTableRow *r) { return [[blockSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r]; } copy];
			else _backgroundColorBlock = [^(RCSTableRow *r) { return nil; } copy];
		}
	}
	return _backgroundColorBlock(aRow);
}

- (NSString *) text: (RCSTableRow *)aRow
{
	if (_textBlock == nil) {
		NSString *s = [_dictionary objectForKey: kTKStaticTextKey];
		if (s) _textBlock = [^(RCSTableRow *r) { return s; } copy];
		else {
			s = [_dictionary objectForKey: kTKTextKey];
			if ([s length]) _textBlock = [^(RCSTableRow *r) { return [[r object] valueForKeyPath: s]; } copy];
			else {
                __weak RCSTableDefinition *blockSelf = self;
				SEL sel = NSSelectorFromString([_dictionary objectForKey: kTKTextSelectorKey]);
                if (sel) _textBlock = [^(RCSTableRow *r) { return [[blockSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r]; } copy];
				else _textBlock = [^(RCSTableRow *r) { return nil; } copy];
			}
		}
	}
	return _textBlock(aRow);
}

- (NSString *) detailText: (RCSTableRow *)aRow
{
	if (_detailTextBlock == nil) {
		NSString *s = [_dictionary objectForKey: kTKStaticDetailTextKey];
		if (s) _detailTextBlock = [^(RCSTableRow *r) { return s; } copy];
		else {
			s = [_dictionary objectForKey: kTKDetailTextKey];
			if ([s length]) _detailTextBlock = [^(RCSTableRow *r) { return [[r object] valueForKeyPath: s]; } copy];
			else {
                __weak RCSTableDefinition *blockSelf = self;
				SEL sel = NSSelectorFromString([_dictionary objectForKey: kTKDetailTextSelectorKey]);
                if (sel) _detailTextBlock = [^(RCSTableRow *r) { return [[blockSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r]; } copy];
				else _detailTextBlock = [^(RCSTableRow *r) { return nil; } copy];
			}
		}
	}
	return _detailTextBlock(aRow);
}

- (UIImage *) image: (RCSTableRow *)aRow
{
	if (_imageBlock == nil) {
		NSString *s = [_dictionary objectForKey: kTKStaticImageKey];
		if ([s length]) {
			UIImage *i = [UIImage imageNamed: s];
			_imageBlock = [^(RCSTableRow *r) { return i; } copy];
		}
		else {
			s = [_dictionary objectForKey: kTKImageKey];
			if ([s length]) _imageBlock = [^(RCSTableRow *r) { return [[r object] valueForKeyPath: s]; } copy];
			else {
                __weak RCSTableDefinition *blockSelf = self;
				SEL sel = NSSelectorFromString([_dictionary objectForKey: kTKImageSelectorKey]);
                if (sel) _imageBlock = [^(RCSTableRow *r) { return [[blockSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r]; } copy];
				else _imageBlock = [^(RCSTableRow *r) { return nil; } copy];
			}
		}
	}
	return _imageBlock(aRow);
}

- (UITableViewCellAccessoryType) editingAccessoryType: (RCSTableRow *)aRow
{
	if (_editingAccessoryTypeBlock == nil) {
		NSString *s = [_dictionary objectForKey: kTKStaticEditingAccessoryTypeKey];
		if (s) {
			if ([kTKAccessoryTypeDisclosureIndicatorKey isEqualToString: s]) {
				_editingAccessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryDisclosureIndicator; } copy];
			} else if ([kTKAccessoryTypeDetailDisclosureButtonKey isEqualToString: s]) {
				_editingAccessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryDetailDisclosureButton; } copy];
			} else if ([kTKAccessoryTypeCheckmarkKey isEqualToString: s]) {
				_editingAccessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryCheckmark; } copy];
			} else {
				_editingAccessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryNone; } copy];
			}
		} else {
			s = [_dictionary objectForKey: kTKEditingAccessoryTypeKey];
			if ([s length]) _editingAccessoryTypeBlock = [^(RCSTableRow *r) {
				NSString *typeString = [[r object] valueForKeyPath: s];
				if ([kTKAccessoryTypeDisclosureIndicatorKey isEqualToString: typeString]) { return UITableViewCellAccessoryDisclosureIndicator; }
				else if ([kTKAccessoryTypeDetailDisclosureButtonKey isEqualToString: typeString]) { return UITableViewCellAccessoryDetailDisclosureButton; }
				else if ([kTKAccessoryTypeCheckmarkKey isEqualToString: typeString]) { return UITableViewCellAccessoryCheckmark; }
				else { return UITableViewCellAccessoryNone; }
			} copy];
			else {
                __weak RCSTableDefinition *blockSelf = self;
				SEL sel = NSSelectorFromString([_dictionary objectForKey: kTKEditingAccessoryTypeSelectorKey]);
				if (sel) _editingAccessoryTypeBlock = [^(RCSTableRow *r) {
                    NSNumber *type = [[blockSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r];
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
		NSString *s = [_dictionary objectForKey: kTKStaticAccessoryTypeKey];
		if (s) {
			if ([kTKAccessoryTypeDisclosureIndicatorKey isEqualToString: s]) {
				_accessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryDisclosureIndicator; } copy];
			} else if ([kTKAccessoryTypeDetailDisclosureButtonKey isEqualToString: s]) {
				_accessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryDetailDisclosureButton; } copy];
			} else if ([kTKAccessoryTypeCheckmarkKey isEqualToString: s]) {
				_accessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryCheckmark; } copy];
			} else {
				_accessoryTypeBlock = [^(RCSTableRow *r) { return UITableViewCellAccessoryNone; } copy];
			}
		} else {
			s = [_dictionary objectForKey: kTKAccessoryTypeKey];
			if ([s length]) _accessoryTypeBlock = [^(RCSTableRow *r) {
				NSString *typeString = [[r object] valueForKeyPath: s];
				if ([kTKAccessoryTypeDisclosureIndicatorKey isEqualToString: typeString]) { return UITableViewCellAccessoryDisclosureIndicator; }
				else if ([kTKAccessoryTypeDetailDisclosureButtonKey isEqualToString: typeString]) { return UITableViewCellAccessoryDetailDisclosureButton; }
				else if ([kTKAccessoryTypeCheckmarkKey isEqualToString: typeString]) { return UITableViewCellAccessoryCheckmark; }
				else { return UITableViewCellAccessoryNone; }
			} copy];
			else {
                __weak RCSTableDefinition *blockSelf = self;
				SEL sel = NSSelectorFromString([_dictionary objectForKey: kTKAccessoryTypeSelectorKey]);
				if (sel) _accessoryTypeBlock = [^(RCSTableRow *r) {
                    NSNumber *type = [[blockSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r];
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
		NSString *s = [_dictionary objectForKey: kTKStaticCellStyleKey];
		if (s) {
			if ([kTKCellStyleValue1Key isEqualToString: s]) {
				_cellStyleBlock = [^(RCSTableRow *r) { return UITableViewCellStyleValue1; } copy];
			} else if ([kTKCellStyleValue2Key isEqualToString: s]) {
				_cellStyleBlock = [^(RCSTableRow *r) { return UITableViewCellStyleValue2; } copy];
			} else if ([kTKCellStyleSubtitleKey isEqualToString: s]) {
				_cellStyleBlock = [^(RCSTableRow *r) { return UITableViewCellStyleSubtitle; } copy];
			} else {
				_cellStyleBlock = [^(RCSTableRow *r) { return UITableViewCellStyleDefault; } copy];
			}
		} else {
			s = [_dictionary objectForKey: kTKCellStyleKey];
			if ([s length]) _cellStyleBlock = [^(RCSTableRow *r) {
				NSString *styleString = [[r object] valueForKeyPath: s];
				if ([kTKCellStyleValue1Key isEqualToString: styleString]) { return UITableViewCellStyleValue1; }
				else if ([kTKCellStyleValue2Key isEqualToString: styleString]) { return UITableViewCellStyleValue2; }
				else if ([kTKCellStyleSubtitleKey isEqualToString: styleString]) { return UITableViewCellStyleSubtitle; }
				else { return UITableViewCellStyleDefault; }
			} copy];
			else {
                __weak RCSTableDefinition *blockSelf = self;
				SEL sel = NSSelectorFromString([_dictionary objectForKey: kTKCellStyleSelectorKey]);
				if (sel) _cellStyleBlock = [^(RCSTableRow *r) {
                    NSNumber *type = [[blockSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r];
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
 * Copyright 2009-2012 Jim Roepcke <jim@roepcke.com>. All rights reserved.
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
