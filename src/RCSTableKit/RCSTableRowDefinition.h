//
//  RCSTableRowDefinition.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableSection;
@class RCSTableRow;

@interface RCSTableRowDefinition : RCSBaseDefinition
{
	NSDictionary *_dictionary;
	NSString *_key;
	NSString *_list;
	
	NSString *_cellNibName;
	BOOL _becomeFirstResponder;
	CGFloat _rowHeight;	

	NSString *_backgroundColor;
	SEL _backgroundColorSelector;
	
	UITableViewCellEditingStyle _editingStyle;
	SEL _editingStyleAction;
	NSString *_editingStylePushConfiguration;

	SEL _action;
	NSString *_pushConfiguration;
	SEL _viewAction;
	NSString *_viewPushConfiguration;
	SEL _editAction;
	NSString *_editPushConfiguration;

	SEL _accessoryAction;
	NSString *_accessoryPushConfiguration;
	SEL _viewAccessoryAction;
	NSString *_viewAccessoryPushConfiguration;

	SEL _editAccessoryAction;
	NSString *_editAccessoryPushConfiguration;	
	
	NSIndexPath *(^_willSelectBlock)(RCSTableRow *row, NSIndexPath *input);
	NSString *(^_textBlock)(RCSTableRow *row);
	NSString *(^_detailTextBlock)(RCSTableRow *row);
	UIImage *(^_imageBlock)(RCSTableRow *row);
	UITableViewCellAccessoryType (^_accessoryTypeBlock)(RCSTableRow *row);
	UITableViewCellAccessoryType (^_editingAccessoryTypeBlock)(RCSTableRow *row);
	UITableViewCellStyle (^_cellStyleBlock)(RCSTableRow *row);
	Class (^_cellClassBlock)(RCSTableRow *row);
}

// the source dictionary that generated this definition
@property (nonatomic, readonly, retain) NSDictionary *dictionary;

// The name (key) of this definition, referenced by displayRowKeys
@property (nonatomic, readonly, retain) NSString *key;

// keyPath returning list of objects to be rootObject for rows with this definition
// if nil, there is only one row with this definition and its rootObject is the view controller.
@property (nonatomic, readonly, retain) NSString *list;


@property (nonatomic, retain) NSString *cellNibName;

@property (nonatomic, assign) BOOL becomeFirstResponder;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, retain) NSString *backgroundColor;
@property (nonatomic, assign) SEL backgroundColorSelector;

@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;
@property (nonatomic, assign) SEL editingStyleAction;
@property (nonatomic, retain) NSString *editingStylePushConfiguration;

@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) NSString *pushConfiguration;
@property (nonatomic, assign) SEL viewAction;
@property (nonatomic, retain) NSString *viewPushConfiguration;
@property (nonatomic, assign) SEL editAction;
@property (nonatomic, retain) NSString *editPushConfiguration;

@property (nonatomic, assign) SEL accessoryAction;
@property (nonatomic, retain) NSString *accessoryPushConfiguration;
@property (nonatomic, assign) SEL viewAccessoryAction;
@property (nonatomic, retain) NSString *viewAccessoryPushConfiguration;

@property (nonatomic, assign) SEL editAccessoryAction;
@property (nonatomic, retain) NSString *editAccessoryPushConfiguration;


- (id) initWithDictionary: (NSDictionary *)dictionary_
				   forKey: (NSString *)key_;

- (NSMutableArray *) rowsForSection: (RCSTableSection *)section;

- (NSIndexPath *) row: (RCSTableRow *)aRow willSelect: (NSIndexPath *)anIndexPath;

- (NSString *) text: (RCSTableRow *)aRow;
- (NSString *) detailText: (RCSTableRow *)aRow;
- (UIImage *) image: (RCSTableRow *)aRow;
- (UITableViewCellAccessoryType) accessoryType: (RCSTableRow *)aRow;
- (UITableViewCellAccessoryType) editingAccessoryType: (RCSTableRow *)aRow;
- (UITableViewCellStyle) cellStyle: (RCSTableRow *)aRow;
- (Class) cellClass: (RCSTableRow *)aRow;

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
