//
//  RCSTableRowDefinition.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableSection;
@class RCSTableRow;

@interface RCSTableRowDefinition : RCSBaseDefinition {}

// the source dictionary that generated this definition
@property (nonatomic, readonly, strong) NSDictionary *dictionary;

// The name (key) of this definition, referenced by displayRowKeys
@property (nonatomic, readonly, copy) NSString *key;

// keyPath returning list of objects to be rootObject for rows with this definition
// if nil, there is only one row with this definition and its rootObject is the view controller.
@property (nonatomic, readonly, copy) NSString *list;

@property (nonatomic, readonly, strong) NSString *cellReuseIdentifier;

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
