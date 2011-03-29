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
