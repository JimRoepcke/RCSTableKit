//
//  RCSTableSectionDefinition.h
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSBaseDefinition.h"

@class RCSTable, RCSTableSection;

@interface RCSTableSectionDefinition : RCSBaseDefinition {
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

- (NSMutableArray *) sectionsForTable: (RCSTable *)table
						 startAtIndex: (NSUInteger)startIndex;

- (NSMutableArray *) rowsForSection: (RCSTableSection *)section;

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
