//
//  RCSTable.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableSection, RCSTableRow, RCSTableDefinition, RCSTableViewController;

@interface RCSTable : NSObject
{
	RCSTableDefinition *_definition;
	NSObject *_object;
	RCSTableViewController *_controller; // parent
	NSMutableArray *_sections; // children (RCSTableSection)
}

@property (nonatomic, readonly, retain) RCSTableDefinition *definition;
@property (nonatomic, readonly, assign) NSObject *object;
@property (nonatomic, readonly, retain) NSMutableArray *sections;
@property (nonatomic, readonly, assign) RCSTableViewController *controller; // parent

- (id) initUsingDefintion: (RCSTableDefinition *)definition_
		   withRootObject: (NSObject *)object_
		forViewController: (RCSTableViewController *)controller_;

- (NSUInteger) numberOfSections;
- (RCSTableSection *) sectionAtIndex: (NSUInteger)section;
- (NSUInteger) numberOfRowsInSection: (NSUInteger)section_;
- (RCSTableRow *) rowAtIndexPath: (NSIndexPath *)indexPath;
- (BOOL) isEditableAtIndexPath: (NSIndexPath *)indexPath;
- (NSString *) cellReuseIdentifierAtIndexPath: (NSIndexPath *)indexPath;
- (UITableViewCell *) cellForRowAtIndexPath: (NSIndexPath *)indexPath;

- (NSString *) tableHeaderImagePath;

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
