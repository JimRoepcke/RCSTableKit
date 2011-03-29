//
//  RCSTableRow.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableViewController, RCSTableRowDefinition, RCSTableSectionDefinition, RCSTableSection;

@interface RCSTableRow : NSObject
{
	UITableViewCell *_cell;
	RCSTableRowDefinition *_definition;
	NSObject *_object;
	RCSTableSection *_section; // parent
}

@property (nonatomic, readwrite, assign) UITableViewCell *cell;
@property (nonatomic, readonly, retain) RCSTableRowDefinition *definition;
@property (nonatomic, readonly, assign) NSObject *object;
@property (nonatomic, readonly, assign) RCSTableSection *section; // parent

- (id) initUsingDefintion: (RCSTableRowDefinition *)definition_
		   withRootObject: (NSObject *)object_
			   forSection: (RCSTableSection *)section_;

- (RCSTableViewController *) controller;

- (NSString *)stringForDictionaryKey: (id)key;

- (BOOL) isEditable;
- (NSString *) cellReuseIdentifier;
- (UITableViewCell *) createCell;
- (CGFloat) heightWithDefault: (CGFloat)defaultHeight;
- (void) willDisplayCell: (UITableViewCell *)cell;
- (void) commitEditingStyle: (UITableViewCellEditingStyle)editingStyle;
- (NSIndexPath *) willSelect: (NSIndexPath *)indexPath;
- (void) didSelect;
- (void) accessoryButtonTapped;

- (UITableViewCellEditingStyle) editingStyle;
- (UIColor *) backgroundColor;
- (NSString *) text;
- (NSString *) detailText;
- (UIImage *) image;
- (UITableViewCellAccessoryType) accessoryType;
- (UITableViewCellAccessoryType) editingAccessoryType;
- (Class) cellClass;

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
