//
//  RCSTableSectionDefinition.m
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSTableSectionDefinition.h"
#import "RCSTableRowDefinition.h"
#import "RCSTable.h"
#import "RCSTableSection.h"

@interface RCSTableSectionDefinition ()
@property (nonatomic, readwrite, retain) NSDictionary *dictionary;
@property (nonatomic, readwrite, retain) NSString *key;
@property (nonatomic, readwrite, retain) NSString *list;
@property (nonatomic, readwrite, retain) NSMutableArray *displayRowKeys;
@property (nonatomic, readwrite, retain) NSMutableDictionary *rowDefinitions;
- (NSMutableDictionary *) _buildRowDefinitions;
@end

@implementation RCSTableSectionDefinition

@synthesize dictionary=_dictionary;
@synthesize key=_key;
@synthesize list=_list;
@synthesize displayRowKeys=_displayRowKeys;
@synthesize rowDefinitions=_rowDefinitions;

@synthesize staticTitle=_staticTitle;
@synthesize title=_title;

- (id) initWithDictionary: (NSDictionary *)dictionary_
				   forKey: (NSString *)key_
{
	self = [super init];
	if (self != nil) {
		self.dictionary = dictionary_;
		self.key = key_;
		self.list = [dictionary_ objectForKey: @"list"];
		self.displayRowKeys = [dictionary_ objectForKey: @"displayRowKeys"];
		self.rowDefinitions = [self _buildRowDefinitions];
		
		self.staticTitle = [self stringForKey: @"staticTitle" withDefault: nil inDictionary: dictionary_];
		self.title = [self stringForKey: @"title" withDefault: nil inDictionary: dictionary_];
	}
	return self;
}

- (void) dealloc
{
	self.dictionary = nil;
	self.key = nil;
	self.list = nil;
	self.rowDefinitions = nil;
	self.staticTitle = nil;
	self.title = nil;
	[super dealloc];
}

- (NSMutableDictionary *) _buildRowDefinitions
{
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	NSDictionary *dict = self.dictionary;
	NSDictionary *rowsDict = [dict objectForKey: @"rows"];
	
	if (rowsDict != nil) {
		RCSTableRowDefinition *def = nil;
		NSArray *keys = [rowsDict allKeys];
		for (NSString *rowKey in keys) {
			def = [[RCSTableRowDefinition alloc] initWithDictionary: [rowsDict objectForKey: rowKey]
															 forKey: rowKey];
			[result setObject: def forKey: rowKey];
			[def release];
		}
	}
	return [result autorelease];
}

- (NSArray *) objectsForSectionsInTable: (RCSTable *)table
{
	NSNull *nullValue = [NSNull null];
	if (self.list == nil) {
		NSString *objectKeyPath = [self stringForKey: @"object"
										 withDefault: nil
										inDictionary: self.dictionary];
		if (objectKeyPath == nil) {
			return [NSArray arrayWithObject: nullValue];
		}
		return [NSArray arrayWithObject: [table.object valueForKeyPath: objectKeyPath]];
	}
	return [table.object valueForKeyPath: self.list];
}

#pragma mark -
#pragma mark Public API

// called by RCSTableDefinition's sectionForTable:
// returns an array of RCSTableSection objects
- (NSMutableArray *) sectionsForTable: (RCSTable *)table
						 startAtIndex: (NSUInteger)startIndex
{
	NSNull *nullValue = [NSNull null];
	NSMutableArray *result = [[NSMutableArray alloc] init];

	NSArray *objects = [self objectsForSectionsInTable: table];
	NSPredicate *sectionPredicate = [NSPredicate predicateWithFormat: [self stringForKey: @"predicate"
																			 withDefault: @"TRUEPREDICATE"
																			inDictionary: self.dictionary]];
	NSObject *sectionObject;
	RCSTableSection *section;
	NSUInteger i = startIndex;
	for (NSObject *obj in objects) {
		sectionObject = obj == nullValue ? table.object : obj;
		if ([sectionPredicate evaluateWithObject: sectionObject]) {
			section = [[RCSTableSection alloc] initUsingDefintion: self
												   withRootObject: sectionObject
														 forTable: table
														  atIndex: i++];
			[result addObject: section];
			[section release];
		}
	}
	
	return [result autorelease];
}

// called by RCSTableSection's designated initializer
// returns an array of RCSTableRow objects
- (NSMutableArray *) rowsForSection: (RCSTableSection *)section
{
	NSMutableArray *result = [[NSMutableArray alloc] init];

	RCSTableRowDefinition *def = nil;
	for (NSString *rowKey in self.displayRowKeys) {
		def = [self.rowDefinitions objectForKey: rowKey];
		[result addObjectsFromArray: [def rowsForSection: section
											startAtIndex: [result count]]];
	}
	return [result autorelease];
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
