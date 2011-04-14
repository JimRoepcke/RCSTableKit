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
	
	NSString *_cellReuseIdentifier;
	NSString *_cellNibName;
	BOOL _becomeFirstResponder;
	CGFloat _rowHeight;	

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
	void (^_didSelectBlock)(RCSTableRow *row);
	void (^_accessoryButtonBlock)(RCSTableRow *row);
	NSString *(^_textBlock)(RCSTableRow *row);
	NSString *(^_detailTextBlock)(RCSTableRow *row);
	UIImage *(^_imageBlock)(RCSTableRow *row);
	UITableViewCellAccessoryType (^_accessoryTypeBlock)(RCSTableRow *row);
	UITableViewCellAccessoryType (^_editingAccessoryTypeBlock)(RCSTableRow *row);
	UITableViewCellStyle (^_cellStyleBlock)(RCSTableRow *row);
	Class (^_cellClassBlock)(RCSTableRow *row);
	UIColor *(^_backgroundColorBlock)(RCSTableRow *row);
}

// the source dictionary that generated this definition
@property (nonatomic, readonly, retain) NSDictionary *dictionary;

// The name (key) of this definition, referenced by displayRowKeys
@property (nonatomic, readonly, copy) NSString *key;

// keyPath returning list of objects to be rootObject for rows with this definition
// if nil, there is only one row with this definition and its rootObject is the view controller.
@property (nonatomic, readonly, copy) NSString *list;

@property (nonatomic, readonly, retain) NSString *cellReuseIdentifier;

@property (nonatomic, copy) NSString *cellNibName;

@property (nonatomic, assign) BOOL becomeFirstResponder;
@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;
@property (nonatomic, assign) SEL editingStyleAction;
@property (nonatomic, copy) NSString *editingStylePushConfiguration;

@property (nonatomic, assign) SEL action;
@property (nonatomic, copy) NSString *pushConfiguration;
@property (nonatomic, assign) SEL viewAction;
@property (nonatomic, copy) NSString *viewPushConfiguration;
@property (nonatomic, assign) SEL editAction;
@property (nonatomic, copy) NSString *editPushConfiguration;

@property (nonatomic, assign) SEL accessoryAction;
@property (nonatomic, copy) NSString *accessoryPushConfiguration;
@property (nonatomic, assign) SEL viewAccessoryAction;
@property (nonatomic, copy) NSString *viewAccessoryPushConfiguration;

@property (nonatomic, assign) SEL editAccessoryAction;
@property (nonatomic, copy) NSString *editAccessoryPushConfiguration;


- (id) initWithDictionary: (NSDictionary *)dictionary_
				   forKey: (NSString *)key_;

- (NSMutableArray *) rowsForSection: (RCSTableSection *)section;

- (void) rowCommitEditingStyle: (RCSTableRow *)aRow;
- (NSIndexPath *) row: (RCSTableRow *)aRow willSelect: (NSIndexPath *)anIndexPath;
- (void) rowDidSelect: (RCSTableRow *)aRow;
- (void) rowAccessoryButtonTapped: (RCSTableRow *)aRow;

- (UIColor *) backgroundColor: (RCSTableRow *)aRow;
- (NSString *) text: (RCSTableRow *)aRow;
- (NSString *) detailText: (RCSTableRow *)aRow;
- (UIImage *) image: (RCSTableRow *)aRow;
- (UITableViewCellAccessoryType) accessoryType: (RCSTableRow *)aRow;
- (UITableViewCellAccessoryType) editingAccessoryType: (RCSTableRow *)aRow;
- (UITableViewCellStyle) cellStyle: (RCSTableRow *)aRow;
- (Class) cellClass: (RCSTableRow *)aRow;

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
