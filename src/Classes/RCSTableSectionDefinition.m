//
//  RCSTableSectionDefinition.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTableSectionDefinition ()
@property (nonatomic, readwrite, strong) NSDictionary *dictionary;
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *list;
@property (nonatomic, readwrite, strong) NSArray *displayRows;
@property (nonatomic, readwrite, strong) NSMutableDictionary *rowDefinitions;
- (NSMutableDictionary *) _buildRowDefinitions;
@end

@implementation RCSTableSectionDefinition

@synthesize parent=_parent;
@synthesize dictionary=_dictionary;
@synthesize name=_name;
@synthesize list=_list;
@synthesize displayRows=_displayRows;
@synthesize rowDefinitions=_rowDefinitions;

@synthesize staticTitle=_staticTitle;
@synthesize title=_title;

- (id) initWithName: (NSString *)name_
         dictionary: (NSDictionary *)dictionary_
             parent: (RCSTableDefinition *)parent_
{
	if (self = [super init]) {
		_dictionary = dictionary_;
		_name = [name_ copy];
        _parent = parent_;
		_list = [[[dictionary_ objectForKey: kTKListKey] description] copy];
		_displayRows = [dictionary_ objectForKey: kTKDisplayRowsKey];
		if (_displayRows == nil) {
			// TODO: use all rows? in what order? alphabetical? throw an exception?
			_displayRows = [[NSArray alloc] init];
		}
		_staticTitle = [[[dictionary_ objectForKey: kTKStaticTitleKey] description] copy];
		_title = [[[dictionary_ objectForKey: kTKTitleKey] description] copy];
		_rowDefinitions = [self _buildRowDefinitions];
	}
	return self;
}

- (Class) tableRowDefinitionClass
{
    return [RCSTableRowDefinition class];
}

- (NSMutableDictionary *) _buildRowDefinitions
{
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	NSDictionary *rowsDict = [_dictionary objectForKey: kTKRowsKey];
	
	if (rowsDict) {
		[rowsDict enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
			RCSTableRowDefinition *def = [(RCSTableRowDefinition *)[[self tableRowDefinitionClass] alloc] initWithName: key dictionary: obj parent: self];
			[result setObject: def forKey: key];
		}];
	}
	return result;
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

- (Class) tableSectionClass
{
    return [RCSTableSection class];
}

// called by RCSTableDefinition's sectionForTable:
// returns an array of RCSTableSection objects
- (NSMutableArray *) sectionsForTable: (RCSTable *)table
{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	NSArray *objects = [self objectsForSectionsInTable: table];
	NSString *predicate = [_dictionary objectForKey: kTKPredicateKey];
	NSPredicate *sectionPredicate;
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
			section = [(RCSTableSection *)[[self tableSectionClass] alloc] initUsingDefintion: self
                                                                               withRootObject: sectionObject
                                                                                     forTable: table];
			[result addObject: section];
		}
	}
	
	return result;
}

// called by RCSTableSection's designated initializer
// returns an array of RCSTableRow objects
- (NSMutableArray *) rowsForSection: (RCSTableSection *)section
{
	NSMutableArray *result = [[NSMutableArray alloc] init];

	RCSTableRowDefinition *rowDef;
	for (NSString *rowKey in _displayRows) {
		rowDef = [_rowDefinitions objectForKey: rowKey];
		[result addObjectsFromArray: [rowDef rowsForSection: section]];
	}
	return result;
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
