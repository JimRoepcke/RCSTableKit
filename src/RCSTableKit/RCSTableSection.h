//
//  RCSTableSection.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableSectionDefinition, RCSTable, RCSTableRow;

@interface RCSTableSection : NSObject {
	RCSTableSectionDefinition *_definition;
	NSObject *_object;
	RCSTable *_table; // parent
	NSUInteger _index;
	NSMutableArray *_rows; // children (RCSTableRow)
}

@property (nonatomic, readonly, retain) RCSTableSectionDefinition *definition;
@property (nonatomic, readonly, assign) NSObject *object;
@property (nonatomic, readonly, assign) NSUInteger index;
@property (nonatomic, readonly, retain) NSMutableArray *rows;
@property (nonatomic, readonly, assign) RCSTable *table; // parent

- (id) initUsingDefintion: (RCSTableSectionDefinition *)definition_
		   withRootObject: (NSObject *)object_
				 forTable: (RCSTable *)table_
				  atIndex: (NSUInteger)index_;

- (NSUInteger) numberOfRows;

- (RCSTableRow *) rowAtIndex: (NSUInteger)index_;

- (NSString *) title;

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
