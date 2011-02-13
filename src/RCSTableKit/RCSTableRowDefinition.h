//
//  RCSTableRowDefinition.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableSection;
@class RCSTableRow;

@interface RCSTableRowDefinition : RCSBaseDefinition {
	NSDictionary *_dictionary;
	NSString *_key;
	NSString *_list;
	
	NSString *_cellNibName;
	NSString *_cellClassName;
	Class _cellClass;
	
	UITableViewCellStyle _staticCellStyle;
	NSString *_cellStyle;
	SEL _cellStyleSelector;
	
	BOOL _becomeFirstResponder;
	CGFloat _rowHeight;	

	NSString *_backgroundColor;
	SEL _backgroundColorSelector;
	
	NSString *_staticDetailText;
	NSString *_detailText;
	SEL _detailTextSelector;
	
	NSString *_staticImageName;
	NSString *_image;
	SEL _imageSelector;
	
	UITableViewCellEditingStyle _editingStyle;
	SEL _editingStyleAction;
	NSString *_editingStylePushConfiguration;

	SEL _action;
	NSString *_pushConfiguration;
	SEL _viewAction;
	NSString *_viewPushConfiguration;
	SEL _editAction;
	NSString *_editPushConfiguration;

	UITableViewCellAccessoryType _staticAccessoryType;
	NSString *_accessoryType;
	SEL _accessoryTypeSelector;
	
	SEL _accessoryAction;
	NSString *_accessoryPushConfiguration;
	SEL _viewAccessoryAction;
	NSString *_viewAccessoryPushConfiguration;

	UITableViewCellAccessoryType _staticEditingAccessoryType;
	NSString *_editingAccessoryType;
	SEL _editingAccessoryTypeSelector;
	
	SEL _editAccessoryAction;
	NSString *_editAccessoryPushConfiguration;	
	
	NSIndexPath *(^_willSelectBlock)(RCSTableRow *row, NSIndexPath *input);
	NSString *(^_textBlock)(RCSTableRow *row);
}

// the source dictionary that generated this definition
@property (nonatomic, readonly, retain) NSDictionary *dictionary;

// The name (key) of this definition, referenced by displayRowKeys
@property (nonatomic, readonly, retain) NSString *key;

// keyPath returning list of objects to be rootObject for rows with this definition
// if nil, there is only one row with this definition and its rootObject is the view controller.
@property (nonatomic, readonly, retain) NSString *list;


@property (nonatomic, retain) NSString *cellNibName;
@property (nonatomic, retain) NSString *cellClassName;
@property (nonatomic, assign) Class     cellClass;

@property (nonatomic, assign) UITableViewCellStyle staticCellStyle;
@property (nonatomic, retain) NSString *cellStyle;
@property (nonatomic, assign) SEL cellStyleSelector;

@property (nonatomic, assign) BOOL becomeFirstResponder;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, retain) NSString *backgroundColor;
@property (nonatomic, assign) SEL backgroundColorSelector;

@property (nonatomic, retain) NSString *staticDetailText;
@property (nonatomic, retain) NSString *detailText;
@property (nonatomic, assign) SEL detailTextSelector;

@property (nonatomic, retain) NSString *staticImageName;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, assign) SEL imageSelector;

@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;
@property (nonatomic, assign) SEL editingStyleAction;
@property (nonatomic, retain) NSString *editingStylePushConfiguration;

@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) NSString *pushConfiguration;
@property (nonatomic, assign) SEL viewAction;
@property (nonatomic, retain) NSString *viewPushConfiguration;
@property (nonatomic, assign) SEL editAction;
@property (nonatomic, retain) NSString *editPushConfiguration;

@property (nonatomic, assign) UITableViewCellAccessoryType staticAccessoryType;
@property (nonatomic, retain) NSString *accessoryType;
@property (nonatomic, assign) SEL accessoryTypeSelector;

@property (nonatomic, assign) SEL accessoryAction;
@property (nonatomic, retain) NSString *accessoryPushConfiguration;
@property (nonatomic, assign) SEL viewAccessoryAction;
@property (nonatomic, retain) NSString *viewAccessoryPushConfiguration;

@property (nonatomic, assign) UITableViewCellAccessoryType staticEditingAccessoryType;
@property (nonatomic, retain) NSString *editingAccessoryType;
@property (nonatomic, assign) SEL editingAccessoryTypeSelector;

@property (nonatomic, assign) SEL editAccessoryAction;
@property (nonatomic, retain) NSString *editAccessoryPushConfiguration;


- (id) initWithDictionary: (NSDictionary *)dictionary_
				   forKey: (NSString *)key_;

- (Class) cellClass;

- (NSMutableArray *) rowsForSection: (RCSTableSection *)section
					   startAtIndex: (NSUInteger)startIndex;

- (NSIndexPath *) row: (RCSTableRow *)aRow willSelect: (NSIndexPath *)anIndexPath;

- (NSString *) text: (RCSTableRow *)aRow;

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
