//
//  RCSTableSection.m
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSTableSection.h"
#import "RCSTableSectionDefinition.h"
#import "RCSTable.h"
#import "RCSTableRow.h"

@interface RCSTableSection ()
@property (nonatomic, readwrite, retain) RCSTableSectionDefinition *definition;
@property (nonatomic, readwrite, assign) NSObject *object;
@property (nonatomic, readwrite, assign) NSUInteger index;
@property (nonatomic, readwrite, retain) NSMutableArray *rows;
@property (nonatomic, readwrite, assign) RCSTable *table; // parent
@end

@implementation RCSTableSection

@synthesize definition=_definition;
@synthesize index=_index;
@synthesize rows=_rows;
@synthesize object=_object;
@synthesize table=_table;

- (id) initUsingDefintion: (RCSTableSectionDefinition *)definition_
		   withRootObject: (NSObject *)object_
				 forTable: (RCSTable *)table_
				  atIndex: (NSUInteger)index_
{
	if (self = [super init]) {
		self.definition = definition_;
		self.object = object_;
		self.table = table_;
		self.index = index_;
		self.rows = [self.definition rowsForSection: self];
	}
	return self;
}

- (void) dealloc
{
	self.definition = nil;
	self.object = nil;
	self.table = nil;
	self.rows = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Public API

- (NSUInteger) numberOfRows
{
	return [self.rows count];
}

- (RCSTableRow *) rowAtIndex: (NSUInteger)index_
{
	return (RCSTableRow *)[self.rows objectAtIndex: index_];
}

- (NSString *) title
{
	if (_definition.staticTitle != nil) return _definition.staticTitle;
	else if (_definition.title != nil) return [_object valueForKeyPath: _definition.title];
	return nil;
}

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
