//
//  RCSTableRow.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableRowDefinition, RCSTableSectionDefinition, RCSTableSection;

@interface RCSTableRow : NSObject {
	UITableViewCell *_cell;
	RCSTableRowDefinition *_definition;
	NSObject *_object;
	RCSTableSection *_section; // parent
	NSIndexPath *_indexPath;
}

@property (nonatomic, readwrite, assign) UITableViewCell *cell;
@property (nonatomic, readonly, retain) RCSTableRowDefinition *definition;
@property (nonatomic, readonly, assign) NSObject *object;
@property (nonatomic, readonly, retain) NSIndexPath *indexPath;
@property (nonatomic, readonly, assign) RCSTableSection *section; // parent

- (id) initUsingDefintion: (RCSTableRowDefinition *)definition_
		   withRootObject: (NSObject *)object_
			   forSection: (RCSTableSection *)section_
			  atIndexPath: (NSIndexPath *)indexPath_;

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
