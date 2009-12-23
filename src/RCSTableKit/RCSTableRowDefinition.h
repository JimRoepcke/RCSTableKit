//
//  RCSTableRowDefinition.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableSection;

@interface RCSTableRowDefinition : RCSBaseDefinition {
	NSDictionary *_dictionary;
	NSString *_key;
	NSString *_list;
	
	NSString *_cellClassName;
	Class _cellClass;
	
	UITableViewCellStyle _cellStyle;
	BOOL _becomeFirstResponder;
	CGFloat _rowHeight;	
	NSString *_backgroundColor;
	
	NSString *_staticText;
	NSString *_text;
	NSString *_staticDetailText;
	NSString *_detailText;
	
	UITableViewCellEditingStyle _editingStyle;
	SEL _editingStyleAction;
	NSString *_editingStylePushConfiguration;

	SEL _action;
	NSString *_pushConfiguration;
	SEL _viewAction;
	NSString *_viewPushConfiguration;
	SEL _editAction;
	NSString *_editPushConfiguration;

	UITableViewCellAccessoryType _accessoryType;
	SEL _accessoryAction;
	NSString *_accessoryPushConfiguration;
	SEL _viewAccessoryAction;
	NSString *_viewAccessoryPushConfiguration;

	UITableViewCellAccessoryType _editingAccessoryType;
	SEL _editAccessoryAction;
	NSString *_editAccessoryPushConfiguration;	
}

// the source dictionary that generated this definition
@property (nonatomic, readonly, retain) NSDictionary *dictionary;

// The name (key) of this definition, referenced by displayRowKeys
@property (nonatomic, readonly, retain) NSString *key;

// keyPath returning list of objects to be rootObject for rows with this definition
// if nil, there is only one row with this definition and its rootObject is the view controller.
@property (nonatomic, readonly, retain) NSString *list;


@property (nonatomic, retain) NSString *cellClassName;
@property (nonatomic, assign) Class     cellClass;

@property (nonatomic, assign) UITableViewCellStyle cellStyle;
@property (nonatomic, assign) BOOL becomeFirstResponder;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, retain) NSString *backgroundColor;

@property (nonatomic, retain) NSString *staticText;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *staticDetailText;
@property (nonatomic, retain) NSString *detailText;

@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;
@property (nonatomic, assign) SEL editingStyleAction;
@property (nonatomic, retain) NSString *editingStylePushConfiguration;

@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) NSString *pushConfiguration;
@property (nonatomic, assign) SEL viewAction;
@property (nonatomic, retain) NSString *viewPushConfiguration;
@property (nonatomic, assign) SEL editAction;
@property (nonatomic, retain) NSString *editPushConfiguration;

@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, assign) SEL accessoryAction;
@property (nonatomic, retain) NSString *accessoryPushConfiguration;
@property (nonatomic, assign) SEL viewAccessoryAction;
@property (nonatomic, retain) NSString *viewAccessoryPushConfiguration;

@property (nonatomic, assign) UITableViewCellAccessoryType editingAccessoryType;
@property (nonatomic, assign) SEL editAccessoryAction;
@property (nonatomic, retain) NSString *editAccessoryPushConfiguration;


- (id) initWithDictionary: (NSDictionary *)dictionary_
				   forKey: (NSString *)key_;

- (Class) cellClass;

- (NSMutableArray *) rowsForSection: (RCSTableSection *)section
					   startAtIndex: (NSUInteger)startIndex;

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
