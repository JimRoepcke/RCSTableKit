//
//  RCSTableSectionDefinition.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTable, RCSTableSection;

@interface RCSTableSectionDefinition : RCSBaseDefinition
{
	NSDictionary *_dictionary;
	NSString *_key;
	NSString *_list;
	NSMutableArray *_displayRowKeys;
	NSMutableDictionary *_rowDefinitions;
	
	NSString *_staticTitle;
	NSString *_title;
}

// the source dictionary that generated this definition
@property (nonatomic, readonly, retain) NSDictionary *dictionary;

// The name (key) of this definition, referenced displaySectionKeys
@property (nonatomic, readonly, retain) NSString *key;

// keyPath returning list of objects to be rootObject for sections with this definition
// if nil, there is only one section with this definition and its rootObject is the view controller.
@property (nonatomic, readonly, retain) NSString *list;

// list of row definitions to display, in the order they should appear
@property (nonatomic, readonly, retain) NSMutableArray *displayRowKeys;

// dictionary of definitions for the rows in sections with this definition
@property (nonatomic, readonly, retain) NSMutableDictionary *rowDefinitions;

@property (nonatomic, retain) NSString *staticTitle;
@property (nonatomic, retain) NSString *title;

- (id) initWithDictionary: (NSDictionary *)dictionary_
				   forKey: (NSString *)key_;

- (NSMutableArray *) sectionsForTable: (RCSTable *)table;

- (NSMutableArray *) rowsForSection: (RCSTableSection *)section;

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
