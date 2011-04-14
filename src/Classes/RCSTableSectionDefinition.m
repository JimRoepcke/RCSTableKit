//
//  RCSTableSectionDefinition.m
//  Created by Jim Roepcke.
//  See license below.
//

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
		_dictionary = [dictionary_ retain];
		_key = [key_ retain];
		_list = [[[dictionary_ objectForKey: kTKListKey] description] retain];
		_displayRowKeys = [[dictionary_ objectForKey: kTKDisplayRowKeys] retain];
		_staticTitle = [[[dictionary_ objectForKey: kTKStaticTitleKey] description] retain];
		_title = [[[dictionary_ objectForKey: kTKTitleKey] description] retain];
		_rowDefinitions = [[self _buildRowDefinitions] retain];
	}
	return self;
}

- (void) dealloc
{
	[_dictionary release]; _dictionary = nil;
	[_key release]; _key = nil;
	[_list release]; _list = nil;
	[_displayRowKeys release]; _displayRowKeys = nil;
	[_rowDefinitions release]; _rowDefinitions = nil;
	[_staticTitle release]; _staticTitle = nil;
	[_title release]; _title = nil;
	[super dealloc];
}

- (NSMutableDictionary *) _buildRowDefinitions
{
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	NSDictionary *rowsDict = [_dictionary objectForKey: kTKRowsKey];
	
	if (rowsDict) {
		[rowsDict enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
			RCSTableRowDefinition *def = [[RCSTableRowDefinition alloc] initWithDictionary: obj forKey: key];
			[result setObject: def forKey: key];
			[def release];
		}];
	}
	return [result autorelease];
}

- (NSArray *) objectsForSectionsInTable: (RCSTable *)table
{
	if (_list == nil) {
		NSString *objectKeyPath = [[_dictionary objectForKey: kTKObjectKey] description];
		return [NSArray arrayWithObject: objectKeyPath ? [[table object] valueForKeyPath: objectKeyPath] : [NSNull null]];
	}
	return [[table object] valueForKeyPath: _list];
}

#pragma mark -
#pragma mark Public API

// called by RCSTableDefinition's sectionForTable:
// returns an array of RCSTableSection objects
- (NSMutableArray *) sectionsForTable: (RCSTable *)table
{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	NSArray *objects = [self objectsForSectionsInTable: table];
	NSString *predicate = [_dictionary objectForKey: kTKPredicateKey];
	NSPredicate *sectionPredicate = nil;
	if ([predicate length] > 0) {
		sectionPredicate = [NSPredicate predicateWithFormat: predicate];
	}
	NSObject *sectionObject;
	RCSTableSection *section;
	NSObject *tableObject = [table object];
	NSNull *nullValue = [NSNull null];
	for (NSObject *obj in objects) {
		sectionObject = obj == nullValue ? tableObject : obj;
		if ((sectionPredicate == nil) || [sectionPredicate evaluateWithObject: sectionObject]) {
			section = [[RCSTableSection alloc] initUsingDefintion: self
												   withRootObject: sectionObject
														 forTable: table];
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

	RCSTableRowDefinition *rowDef = nil;
	for (NSString *rowKey in _displayRowKeys) {
		rowDef = [_rowDefinitions objectForKey: rowKey];
		[result addObjectsFromArray: [rowDef rowsForSection: section]];
	}
	return [result autorelease];
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
