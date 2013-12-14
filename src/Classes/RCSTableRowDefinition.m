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
		_list = [dictionary_[kTKListKey] copy];
        
		// editingStyle
		NSString *s;
		if ((s = _dictionary[kTKEditingStyleKey])) {
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
		
		_cellNibName = [dictionary_[kTKCellNibKey] copy];
		_editPushConfiguration = [dictionary_[kTKEditPushConfigurationKey] copy];
		_viewPushConfiguration = [dictionary_[kTKViewPushConfigurationKey] copy];
		_pushConfiguration = [dictionary_[kTKPushConfigurationKey] copy];
		_accessoryPushConfiguration = [dictionary_[kTKAccessoryPushConfigurationKey] copy];
		_editAccessoryPushConfiguration = [dictionary_[kTKEditAccessoryPushConfigurationKey] copy];
		_viewAccessoryPushConfiguration = [dictionary_[kTKViewAccessoryPushConfigurationKey] copy];
		_becomeFirstResponder = [[self class] boolForKey: kTKBecomeFirstResponderKey withDefault: NO inDictionary: dictionary_];
		_editingStyleAction = NSSelectorFromString(dictionary_[kTKEditingStyleActionKey]);
		_editingStylePushConfiguration = [dictionary_[kTKEditingStylePushConfigurationKey] copy];
		_editAction = NSSelectorFromString(dictionary_[kTKEditActionKey]);
		_viewAction = NSSelectorFromString(dictionary_[kTKViewActionKey]);
		_action = NSSelectorFromString(dictionary_[kTKActionKey]);
		_editAccessoryAction = NSSelectorFromString(dictionary_[kTKEditAccessoryActionKey]);
		_viewAccessoryAction = NSSelectorFromString(dictionary_[kTKViewAccessoryActionKey]);
		_accessoryAction = NSSelectorFromString(dictionary_[kTKAccessoryActionKey]);
		_rowHeight = [[self class] floatForKey: kTKRowHeightKey withDefault: -1.0 inDictionary: dictionary_];
	}
	return self;
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
	if ((!self.list) || ([self.list length] == 0)) {
		NSString *objectKeyPath = self.dictionary[kTKObjectKey];
		return @[[objectKeyPath length] ?
				[[section object] valueForKeyPath: objectKeyPath] :
				[NSNull null]];
	}
	return [[section object] valueForKeyPath: self.list];
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
	NSString *predicate = self.dictionary[kTKPredicateKey];
	NSPredicate *rowPredicate;
	if ([predicate length]) {
		rowPredicate = [NSPredicate predicateWithFormat: predicate];
	}
	NSObject *rowObject = nil;
	RCSTableRow *row = nil;
	NSObject *sectionObject = [section object];
	NSNull *nullValue = [NSNull null];
	for (NSObject *obj in objects) {
		rowObject = obj == nullValue ? sectionObject : obj;
		if ((!rowPredicate) || [rowPredicate evaluateWithObject: rowObject]) {
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
	if (!_cellReuseIdentifier) {
		_cellReuseIdentifier = [[NSString alloc] initWithFormat: @"%d",
								(int)self.dictionary];
	}
	return _cellReuseIdentifier;
}

- (Class) cellClass: (RCSTableRow *)aRow
{
	if (!self.cellClassBlock) {
		NSString *s = self.dictionary[kTKStaticCellKey];
		if ([s length]) self.cellClassBlock = ^(RCSTableRow *r) {
			Class c = NSClassFromString(s);
			return c ? c : [RCSTableViewCell class];
		};
		else {
			s = self.dictionary[kTKCellKey];
			if ([s length]) self.cellClassBlock = ^(RCSTableRow *r) {
				NSString *cs = [[r object] valueForKeyPath: s];
				Class c = cs ? NSClassFromString(cs) : nil;
				return c ? c : [RCSTableViewCell class];
			};
			else {
				SEL sel = NSSelectorFromString(self.dictionary[kTKCellSelectorKey]);
                __weak RCSTableRowDefinition *weakSelf = self;
				if (sel) self.cellClassBlock = ^(RCSTableRow *r) {
					Class c = [[weakSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r];
					return c ? c : [RCSTableViewCell class];
				};
				else self.cellClassBlock = ^(RCSTableRow *r) { return [RCSTableViewCell class]; };
			}
		}
	}
	return self.cellClassBlock(aRow);
}

- (void) rowCommitEditingStyle: (RCSTableRow *)aRow
{
	RCSTableViewController *controller = [aRow controller];
	if (self.editingStyleAction) {
		[[self class] receiver: controller leakyPerformSelector: self.editingStyleAction withObject: aRow];
		// FIXME: this should happen via a callback, or something, right?
		// if (self.editingStyle == UITableViewCellEditingStyleDelete) {
		//     something that makes a delete happen goes here
		// }
	} else if (self.editingStylePushConfiguration) {
		[self pushConfiguration: self.editingStylePushConfiguration withRootObject: [aRow object] usingController: [aRow controller]];
	}
}

- (NSIndexPath *) row: (RCSTableRow *)aRow willSelect: (NSIndexPath *)anIndexPath
{
	// yeah yeah this is crazy, but it's fun and cool
	// this class is a flyweight so this computation will
	// be re-used for every row
	if (!self.willSelectBlock) {
		if (self.action || self.pushConfiguration) {
			self.willSelectBlock = ^(RCSTableRow *row, NSIndexPath *input) { return input; };
		} else {
			BOOL indexPathWhenEditing = self.editAction || self.editPushConfiguration;
			BOOL indexPathWhenViewing = self.viewAction || self.viewPushConfiguration;
			if (indexPathWhenEditing && indexPathWhenViewing) {
				self.willSelectBlock = ^(RCSTableRow *r, NSIndexPath *input) { return input; };
			} else if (indexPathWhenEditing) {
				self.willSelectBlock = ^(RCSTableRow *r, NSIndexPath *input) { return [[r controller] isEditing] ? input : nil; };
			} else if (indexPathWhenViewing) {
				self.willSelectBlock = ^(RCSTableRow *r, NSIndexPath *input) { return [[r controller] isEditing] ? nil : input; };
			} else {
				self.willSelectBlock = ^(RCSTableRow *r, NSIndexPath *input) { return (NSIndexPath *)nil; };
			}
		}
	}
	return self.willSelectBlock(aRow, anIndexPath);
}

- (void) rowDidSelect: (RCSTableRow *)aRow
{
	if (!self.didSelectBlock) {
		__weak RCSTableRowDefinition *weakSelf = self;
		if (self.action) self.didSelectBlock = ^(RCSTableRow *r) { [[weakSelf class] receiver: [r controller] leakyPerformSelector: weakSelf.action withObject: r]; };
		else {
			if (self.pushConfiguration) self.didSelectBlock = ^(RCSTableRow *r) { [weakSelf pushConfiguration: weakSelf.pushConfiguration withRootObject: [r object] usingController: [r controller]]; };
			else {
				// editing
				void (^editing)(RCSTableRow *);
				if (self.editAction) editing = ^(RCSTableRow *r) { [[weakSelf class] receiver: [r controller] leakyPerformSelector: weakSelf.editAction withObject: r]; };
				else if (self.editPushConfiguration) editing = ^(RCSTableRow *r) { [weakSelf pushConfiguration: weakSelf.editPushConfiguration withRootObject: [r object] usingController: [r controller]]; };
				// not editing (viewing)
				void (^viewing)(RCSTableRow *);
				if (self.viewAction) viewing = ^(RCSTableRow *r) { [[weakSelf class] receiver: [r controller] leakyPerformSelector: weakSelf.viewAction withObject: r]; };
				else if (self.viewPushConfiguration) viewing = ^(RCSTableRow *r) { [weakSelf pushConfiguration: weakSelf.viewPushConfiguration withRootObject: [r object] usingController: [r controller]]; };
				self.didSelectBlock = ^(RCSTableRow *r) {
					if ([[r controller] isEditing]) {
						if (editing) editing(r);
					} else {
						if (viewing) viewing(r);
					}
				};
			}
		}
	}
	self.didSelectBlock(aRow);
}

- (void) rowAccessoryButtonTapped: (RCSTableRow *)aRow
{
	if (!self.accessoryButtonBlock) {
		__weak RCSTableRowDefinition *weakSelf = self;
		if (self.accessoryAction) self.accessoryButtonBlock = ^(RCSTableRow *r) { [[weakSelf class] receiver: [r controller] leakyPerformSelector: weakSelf.accessoryAction withObject: r]; };
		else {
			if (self.accessoryPushConfiguration) self.accessoryButtonBlock = ^(RCSTableRow *r) { [weakSelf pushConfiguration: weakSelf.accessoryPushConfiguration withRootObject: [r object] usingController: [r controller]]; };
			else {
				// editing
				void (^editing)(RCSTableRow *);
				if (self.editAccessoryAction) editing = ^(RCSTableRow *r) { [[weakSelf class] receiver: [r controller] leakyPerformSelector: weakSelf.editAccessoryAction withObject: r]; };
				else if (self.editAccessoryPushConfiguration) editing = ^(RCSTableRow *r) { [weakSelf pushConfiguration: weakSelf.editAccessoryPushConfiguration withRootObject: [r object] usingController: [r controller]]; };
				// not editing (viewing)
				void (^viewing)(RCSTableRow *);
				if (self.viewAccessoryAction) viewing = ^(RCSTableRow *r) { [[weakSelf class] receiver: [r controller] leakyPerformSelector: weakSelf.viewAccessoryAction withObject: r]; };
				else if (self.viewAccessoryPushConfiguration) viewing = ^(RCSTableRow *r) { [weakSelf pushConfiguration: weakSelf.viewAccessoryPushConfiguration withRootObject: [r object] usingController: [r controller]]; };
				self.accessoryButtonBlock = ^(RCSTableRow *r) {
					if ([[r controller] isEditing]) {
						if (editing) editing(r);
					} else {
						if (viewing) viewing(r);
					}
				};
			}
		}
	}
	self.accessoryButtonBlock(aRow);
}

- (UIColor *) backgroundColor: (RCSTableRow *)aRow
{
	if (!self.backgroundColorBlock) {
		NSString *s = self.dictionary[kTKBackgroundColorKey];
		if ([s length]) self.backgroundColorBlock = ^(RCSTableRow *r) { return [[r object] valueForKeyPath: s]; };
		else {
            __weak RCSTableRowDefinition *weakSelf = self;
			SEL sel = NSSelectorFromString(self.dictionary[kTKBackgroundColorSelectorKey]);
			if (sel) self.backgroundColorBlock = ^(RCSTableRow *r) { return [[weakSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r]; };
			else self.backgroundColorBlock = ^(RCSTableRow *r) { return (UIColor *)nil; };
		}
	}
	return self.backgroundColorBlock(aRow);
}

- (NSString *) text: (RCSTableRow *)aRow
{
	if (!self.textBlock) {
		NSString *s = self.dictionary[kTKStaticTextKey];
		if (s) self.textBlock = ^(RCSTableRow *r) { return s; };
		else {
			s = self.dictionary[kTKTextKey];
			if ([s length]) self.textBlock = ^(RCSTableRow *r) { return [[r object] valueForKeyPath: s]; };
			else {
                __weak RCSTableRowDefinition *weakSelf = self;
				SEL sel = NSSelectorFromString(self.dictionary[kTKTextSelectorKey]);
                if (sel) self.textBlock = ^(RCSTableRow *r) { return [[weakSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r]; };
				else self.textBlock = ^(RCSTableRow *r) { return (NSString *)nil; };
			}
		}
	}
	return self.textBlock(aRow);
}

- (NSString *) detailText: (RCSTableRow *)aRow
{
	if (!self.detailTextBlock) {
		NSString *s = self.dictionary[kTKStaticDetailTextKey];
		if (s) self.detailTextBlock = ^(RCSTableRow *r) { return s; };
		else {
			s = self.dictionary[kTKDetailTextKey];
			if ([s length]) self.detailTextBlock = ^(RCSTableRow *r) { return [[r object] valueForKeyPath: s]; };
			else {
                __weak RCSTableRowDefinition *weakSelf = self;
				SEL sel = NSSelectorFromString(self.dictionary[kTKDetailTextSelectorKey]);
                if (sel) self.detailTextBlock = ^(RCSTableRow *r) { return [[weakSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r]; };
				else self.detailTextBlock = ^(RCSTableRow *r) { return (NSString *)nil; };
			}
		}
	}
	return self.detailTextBlock(aRow);
}

- (UIImage *) image: (RCSTableRow *)aRow
{
	if (!self.imageBlock) {
		NSString *s = self.dictionary[kTKStaticImageKey];
		if ([s length]) {
			UIImage *i = [UIImage imageNamed: s];
			self.imageBlock = ^(RCSTableRow *r) { return i; };
		}
		else {
			s = self.dictionary[kTKImageKey];
			if ([s length]) self.imageBlock = ^(RCSTableRow *r) { return [[r object] valueForKeyPath: s]; };
			else {
                __weak RCSTableRowDefinition *weakSelf = self;
				SEL sel = NSSelectorFromString(self.dictionary[kTKImageSelectorKey]);
                if (sel) self.imageBlock = ^(RCSTableRow *r) { return [[weakSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r]; };
				else self.imageBlock = ^(RCSTableRow *r) { return (UIImage *)nil; };
			}
		}
	}
	return self.imageBlock(aRow);
}

- (UITableViewCellAccessoryType) editingAccessoryType: (RCSTableRow *)aRow
{
	if (!self.editingAccessoryTypeBlock) {
		NSString *s = self.dictionary[kTKStaticEditingAccessoryTypeKey];
		if (s) {
			if ([kTKAccessoryTypeDisclosureIndicatorKey isEqualToString: s]) {
				self.editingAccessoryTypeBlock = ^(RCSTableRow *r) { return UITableViewCellAccessoryDisclosureIndicator; };
			} else if ([kTKAccessoryTypeDetailDisclosureButtonKey isEqualToString: s]) {
				self.editingAccessoryTypeBlock = ^(RCSTableRow *r) { return UITableViewCellAccessoryDetailDisclosureButton; };
			} else if ([kTKAccessoryTypeCheckmarkKey isEqualToString: s]) {
				self.editingAccessoryTypeBlock = ^(RCSTableRow *r) { return UITableViewCellAccessoryCheckmark; };
			} else {
				self.editingAccessoryTypeBlock = ^(RCSTableRow *r) { return UITableViewCellAccessoryNone; };
			}
		} else {
			s = self.dictionary[kTKEditingAccessoryTypeKey];
			if ([s length]) self.editingAccessoryTypeBlock = ^(RCSTableRow *r) {
				NSString *typeString = [[r object] valueForKeyPath: s];
				if ([kTKAccessoryTypeDisclosureIndicatorKey isEqualToString: typeString]) { return UITableViewCellAccessoryDisclosureIndicator; }
				else if ([kTKAccessoryTypeDetailDisclosureButtonKey isEqualToString: typeString]) { return UITableViewCellAccessoryDetailDisclosureButton; }
				else if ([kTKAccessoryTypeCheckmarkKey isEqualToString: typeString]) { return UITableViewCellAccessoryCheckmark; }
				else { return UITableViewCellAccessoryNone; }
			};
			else {
                __weak RCSTableRowDefinition *weakSelf = self;
				SEL sel = NSSelectorFromString(self.dictionary[kTKEditingAccessoryTypeSelectorKey]);
				if (sel) self.editingAccessoryTypeBlock = ^(RCSTableRow *r) {
                    NSNumber *type = [[weakSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r];
					return (UITableViewCellAccessoryType)[type intValue];
				};
				else self.editingAccessoryTypeBlock = ^(RCSTableRow *r) { return UITableViewCellAccessoryNone; };
			}
		}
	}
	return self.editingAccessoryTypeBlock(aRow);
}

- (UITableViewCellAccessoryType) accessoryType: (RCSTableRow *)aRow
{
	if ([[aRow controller] isEditing]) return [self editingAccessoryType: aRow];
	if (!self.accessoryTypeBlock) {
		NSString *s = self.dictionary[kTKStaticAccessoryTypeKey];
		if (s) {
			if ([kTKAccessoryTypeDisclosureIndicatorKey isEqualToString: s]) {
				self.accessoryTypeBlock = ^(RCSTableRow *r) { return UITableViewCellAccessoryDisclosureIndicator; };
			} else if ([kTKAccessoryTypeDetailDisclosureButtonKey isEqualToString: s]) {
				self.accessoryTypeBlock = ^(RCSTableRow *r) { return UITableViewCellAccessoryDetailDisclosureButton; };
			} else if ([kTKAccessoryTypeCheckmarkKey isEqualToString: s]) {
				self.accessoryTypeBlock = ^(RCSTableRow *r) { return UITableViewCellAccessoryCheckmark; };
			} else {
				self.accessoryTypeBlock = ^(RCSTableRow *r) { return UITableViewCellAccessoryNone; };
			}
		} else {
			s = self.dictionary[kTKAccessoryTypeKey];
			if ([s length]) self.accessoryTypeBlock = ^(RCSTableRow *r) {
				NSString *typeString = [[r object] valueForKeyPath: s];
				if ([kTKAccessoryTypeDisclosureIndicatorKey isEqualToString: typeString]) { return UITableViewCellAccessoryDisclosureIndicator; }
				else if ([kTKAccessoryTypeDetailDisclosureButtonKey isEqualToString: typeString]) { return UITableViewCellAccessoryDetailDisclosureButton; }
				else if ([kTKAccessoryTypeCheckmarkKey isEqualToString: typeString]) { return UITableViewCellAccessoryCheckmark; }
				else { return UITableViewCellAccessoryNone; }
			};
			else {
                __weak RCSTableRowDefinition *weakSelf = self;
				SEL sel = NSSelectorFromString(self.dictionary[kTKAccessoryTypeSelectorKey]);
				if (sel) self.accessoryTypeBlock = ^(RCSTableRow *r) {
                    NSNumber *type = [[weakSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r];
					return (UITableViewCellAccessoryType)[type intValue];
				};
				else self.accessoryTypeBlock = ^(RCSTableRow *r) { return UITableViewCellAccessoryNone; };
			}
		}
	}
	return self.accessoryTypeBlock(aRow);
}


- (UITableViewCellStyle) cellStyle: (RCSTableRow *)aRow
{
	if (!self.cellStyleBlock) {
		NSString *s = self.dictionary[kTKStaticCellStyleKey];
		if (s) {
			if ([kTKCellStyleValue1Key isEqualToString: s]) {
				self.cellStyleBlock = ^(RCSTableRow *r) { return UITableViewCellStyleValue1; };
			} else if ([kTKCellStyleValue2Key isEqualToString: s]) {
				self.cellStyleBlock = ^(RCSTableRow *r) { return UITableViewCellStyleValue2; };
			} else if ([kTKCellStyleSubtitleKey isEqualToString: s]) {
				self.cellStyleBlock = ^(RCSTableRow *r) { return UITableViewCellStyleSubtitle; };
			} else {
				self.cellStyleBlock = ^(RCSTableRow *r) { return UITableViewCellStyleDefault; };
			}
		} else {
			s = self.dictionary[kTKCellStyleKey];
			if ([s length]) self.cellStyleBlock = ^(RCSTableRow *r) {
				NSString *styleString = [[r object] valueForKeyPath: s];
				if ([kTKCellStyleValue1Key isEqualToString: styleString]) { return UITableViewCellStyleValue1; }
				else if ([kTKCellStyleValue2Key isEqualToString: styleString]) { return UITableViewCellStyleValue2; }
				else if ([kTKCellStyleSubtitleKey isEqualToString: styleString]) { return UITableViewCellStyleSubtitle; }
				else { return UITableViewCellStyleDefault; }
			};
			else {
                __weak RCSTableRowDefinition *weakSelf = self;
				SEL sel = NSSelectorFromString(self.dictionary[kTKCellStyleSelectorKey]);
				if (sel) self.cellStyleBlock = ^(RCSTableRow *r) {
                    NSNumber *type = [[weakSelf class] receiver: [r controller] leakyPerformSelector: sel withObject: r];
					return (UITableViewCellStyle)[type intValue];
				};
				else self.cellStyleBlock = ^(RCSTableRow *r) { return UITableViewCellStyleDefault; };
			}
		}
	}
	return self.cellStyleBlock(aRow);
}

@end

/*
 * Copyright 2009-2013 Jim Roepcke <jim@roepcke.com>. All rights reserved.
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
