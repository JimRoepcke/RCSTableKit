//
//  RCSTableDefinition.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTableDefinition ()
@property (nonatomic, readwrite, retain) NSDictionary *dictionary;
@property (nonatomic, readwrite, retain) NSString *key;
@property (nonatomic, readwrite, retain) NSMutableArray *displaySectionKeys;
@property (nonatomic, readwrite, retain) NSMutableDictionary *sectionDefinitions;
- (NSMutableDictionary *) _buildSectionDefinitions;
@end

@implementation RCSTableDefinition

@synthesize dictionary=_dictionary;
@synthesize key=_key;
@synthesize displaySectionKeys=_displaySectionKeys;
@synthesize sectionDefinitions=_sectionDefinitions;
@synthesize tableHeaderImagePath=_tableHeaderImagePath;
@synthesize tableHeaderImagePathSelector=_tableHeaderImagePathSelector;

- (id) initWithDictionary: (NSDictionary *)dictionary_
				   forKey: (NSString *)key_
{
	self = [super init];
	if (self != nil) {
		self.dictionary = dictionary_;
		self.key = key_;
		self.displaySectionKeys = [dictionary_ objectForKey: @"displaySectionKeys"];
		if (self.displaySectionKeys == nil) {
			// TODO: use all sections? in what order? alphabetical? throw an exception?
			self.displaySectionKeys = [[[NSMutableArray alloc] init] autorelease];
		}
		self.sectionDefinitions = [self _buildSectionDefinitions];
		self.tableHeaderImagePath = [self stringForKey: @"tableHeaderImagePath" withDefault: nil inDictionary: _dictionary];
		self.tableHeaderImagePathSelector = NSSelectorFromString([self stringForKey: @"tableHeaderImagePathSelector" withDefault: nil inDictionary: dictionary_]);
	}
	return self;
}

- (void) dealloc
{
	[_dictionary release]; _dictionary = nil;
	[_key release]; _key = nil;
	[_displaySectionKeys release]; _displaySectionKeys = nil;
	[_sectionDefinitions release]; _sectionDefinitions = nil;
	[_tableHeaderImagePath release]; _tableHeaderImagePath = nil;
	[super dealloc];
}

- (NSMutableDictionary *) _buildSectionDefinitions
{
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	NSDictionary *dict = self.dictionary;
	NSDictionary *sectionsDict = [dict objectForKey: @"sections"];
	
	if (sectionsDict != nil) {
		RCSTableSectionDefinition *def = nil;
		NSArray *keys = [sectionsDict allKeys];
		for (NSString *sectionKey in keys) {
			def = [[RCSTableSectionDefinition alloc] initWithDictionary: [sectionsDict objectForKey: sectionKey]
																 forKey: sectionKey];
			[result setObject: def forKey: sectionKey];
			[def release];
		}
	}
	return [result autorelease];
}

#pragma mark -
#pragma mark Public API

// called by RCSTable's designated initializer
// returns an array of RCSTableSection objects
- (NSMutableArray *) sectionsForTable: (RCSTable *)table
{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	
	RCSTableSectionDefinition *secDef = nil;
	for (NSString *sectionKey in self.displaySectionKeys) {
		secDef = [self.sectionDefinitions objectForKey: sectionKey];
		[result addObjectsFromArray: [secDef sectionsForTable: table]];
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
