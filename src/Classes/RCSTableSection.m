//
//  RCSTableSection.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTableSection ()
@property (nonatomic, readwrite, strong) RCSTableSectionDefinition *definition;
@property (nonatomic, readwrite, assign) NSObject *object;
@property (nonatomic, readwrite, strong) NSMutableArray *rows;
@property (nonatomic, readwrite, assign) RCSTable *table; // parent
@end

@implementation RCSTableSection

@synthesize definition=_definition;
@synthesize rows=_rows;
@synthesize object=_object;
@synthesize table=_table;

- (id) initUsingDefintion: (RCSTableSectionDefinition *)definition_
		   withRootObject: (NSObject *)object_
				 forTable: (RCSTable *)table_
{
	if (self = [super init]) {
		_definition = definition_;
		_object = object_;
		_table = table_;
		_rows = [definition_ rowsForSection: self];
	}
	return self;
}


#pragma mark -
#pragma mark Public API

- (NSInteger) numberOfRows
{
	return [_rows count];
}

- (RCSTableRow *) rowAtIndex: (NSInteger)index_
{
	return (RCSTableRow *)[_rows objectAtIndex: index_];
}

- (NSString *) title
{
	if ([_definition staticTitle]) return [_definition staticTitle];
	else if ([_definition title]) return [_object valueForKeyPath: [_definition title]];
	return nil;
}

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
