//
//  RCSTableSection.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableSectionDefinition, RCSTable, RCSTableRow;

@interface RCSTableSection : NSObject

@property (nonatomic, readonly, retain) RCSTableSectionDefinition *definition;
@property (nonatomic, readonly, assign) NSObject *object;
@property (nonatomic, readonly, retain) NSMutableArray *rows;
@property (nonatomic, readonly, assign) RCSTable *table; // parent

- (id) initUsingDefintion: (RCSTableSectionDefinition *)definition_
		   withRootObject: (NSObject *)object_
				 forTable: (RCSTable *)table_;

- (NSInteger) numberOfRows;

- (RCSTableRow *) rowAtIndex: (NSInteger)index_;

- (NSString *) title;

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
