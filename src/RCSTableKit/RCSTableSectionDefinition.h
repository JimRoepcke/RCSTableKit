//
//  RCSTableSectionDefinition.h
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSBaseDefinition.h"

@class RCSTableDefinition;
@class RCSTable;
@class RCSTableSection;

@interface RCSTableSectionDefinition : RCSBaseDefinition

@property (nonatomic, readonly, weak) RCSTableDefinition *parent;

// the source dictionary that generated this definition
@property (nonatomic, readonly, strong) NSDictionary *dictionary;

// The name of this definition, referenced displaySections
@property (nonatomic, readonly, copy) NSString *name;

// keyPath returning list of objects to be rootObject for sections with this definition
// if nil, there is only one section with this definition and its rootObject is the view controller.
@property (nonatomic, readonly, copy) NSString *list;

// list of row definitions to display, in the order they should appear
@property (nonatomic, readonly, strong) NSArray *displayRows;

// dictionary of definitions for the rows in sections with this definition
@property (nonatomic, readonly, strong) NSMutableDictionary *rowDefinitions;

@property (nonatomic, copy) NSString *staticTitle;
@property (nonatomic, copy) NSString *title;

- (id) initWithName: (NSString *)name_
         dictionary: (NSDictionary *)dictionary_
             parent: (RCSTableDefinition *)parent_;

- (NSMutableArray *) sectionsForTable: (RCSTable *)table;

- (NSMutableArray *) rowsForSection: (RCSTableSection *)section;

@end

/*
 * Copyright 2009-2013 Jim Roepcke <jim@roepcke.com>. All rights reserved.
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
