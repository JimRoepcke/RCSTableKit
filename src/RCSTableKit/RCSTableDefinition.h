//
//  RCSTableDefinition.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTable;

@interface RCSTableDefinition : RCSBaseDefinition {
	NSDictionary *_dictionary;
	NSString *_key;
	NSMutableArray *_displaySectionKeys;
	NSMutableDictionary *_sectionDefinitions;
}

// the source dictionary that generated this definition
@property (nonatomic, readonly, retain) NSDictionary *dictionary;

// The name (key) of this definition (probably the name of the plist containing the dictionary)
@property (nonatomic, readonly, retain) NSString *key;

// list of section definitions to display, in the order they should appear
@property (nonatomic, readonly, retain) NSMutableArray *displaySectionKeys;

// dictionary of definitions for the sections in tables with this definition
@property (nonatomic, readonly, retain) NSMutableDictionary *sectionDefinitions;

- (id) initWithDictionary: (NSDictionary *)dictionary_
				   forKey: (NSString *)key_;

- (NSMutableArray *) sectionsForTable: (RCSTable *)table;

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
