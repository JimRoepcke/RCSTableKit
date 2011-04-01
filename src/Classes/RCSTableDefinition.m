//
//  RCSTableDefinition.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTableDefinition ()
@property (nonatomic, readwrite, retain) NSDictionary *dictionary;
@property (nonatomic, readwrite, retain) NSMutableArray *displaySectionKeys;
@property (nonatomic, readwrite, retain) NSMutableDictionary *sectionDefinitions;
@property (nonatomic, readwrite, retain) NSString *nibName;
@property (nonatomic, readwrite, retain) NSString *nibBundleName;
@property (nonatomic, readwrite, retain) NSString *controllerClassName;
- (NSMutableDictionary *) _buildSectionDefinitions;
@end

@implementation RCSTableDefinition

@synthesize dictionary=_dictionary;
@synthesize displaySectionKeys=_displaySectionKeys;
@synthesize sectionDefinitions=_sectionDefinitions;
@synthesize tableHeaderImagePath=_tableHeaderImagePath;
@synthesize tableHeaderImagePathSelector=_tableHeaderImagePathSelector;
@synthesize nibName=_nibName;
@synthesize nibBundleName=_nibBundleName;
@synthesize controllerClassName=_controllerClassName;

- (id) initWithDictionary: (NSDictionary *)dictionary_
{
	self = [super init];
	if (self != nil) {
		_dictionary = [dictionary_ retain];
		_nibName = [[dictionary_ objectForKey: @"nibName"] retain];
		_nibBundleName = [[dictionary_ objectForKey: @"nibBundleName"] retain];
		_controllerClassName = [[dictionary_ objectForKey: @"controllerClassName"] retain];
		_displaySectionKeys = [[dictionary_ objectForKey: @"displaySectionKeys"] retain];
		if (_displaySectionKeys == nil) {
			// TODO: use all sections? in what order? alphabetical? throw an exception?
			_displaySectionKeys = [[NSMutableArray alloc] init];
		}
		_sectionDefinitions = [[self _buildSectionDefinitions] retain];
		_tableHeaderImagePath = [[dictionary_ objectForKey: @"tableHeaderImagePath"] retain];
		_tableHeaderImagePathSelector = NSSelectorFromString([dictionary_ objectForKey: @"tableHeaderImagePathSelector"]);
	}
	return self;
}

- (void) dealloc
{
	[_dictionary release]; _dictionary = nil;
	[_nibName release]; _nibName = nil;
	[_nibBundleName release]; _nibBundleName = nil;
	[_controllerClassName release]; _controllerClassName = nil;
	[_displaySectionKeys release]; _displaySectionKeys = nil;
	[_sectionDefinitions release]; _sectionDefinitions = nil;
	[_tableHeaderImagePath release]; _tableHeaderImagePath = nil;
	[super dealloc];
}

+ (RCSTableDefinition *) tableDefinitionNamed: (NSString *)name inBundle: (NSBundle *)bundle
{
	RCSTableDefinition *result = nil;
	NSDictionary *dict = nil;
	if (bundle == nil) { bundle = [NSBundle mainBundle]; }
	if (name) {
		dict = [NSDictionary dictionaryWithContentsOfFile: [bundle pathForResource: name ofType: @"plist"]];
		if (dict) {
			result = [[RCSTableDefinition alloc] initWithDictionary: dict];
		}
	}
	return [result autorelease];
}

- (RCSTableViewController *) viewControllerWithRootObject: (NSObject *)object
{
	NSBundle *bundle = nil;
	NSString *nibBundleName = [self nibBundleName];
	if ([nibBundleName length]) {
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: nibBundleName];
		bundle = [NSBundle bundleWithPath: path];
	}
	NSString *nibName = [self nibName];

	NSString *name = [self controllerClassName];
	Class controllerClass = name ? NSClassFromString(name) : [RCSTableViewController class];
	RCSTableViewController *c = nil;
	if ([controllerClass isSubclassOfClass: [RCSTableViewController class]]) {
		c = [[controllerClass alloc] initWithNibName: nibName bundle: bundle];
		[c setRootObject: object];
		[c setTableDefinition: self];
	}
	return [c autorelease];
}

- (NSMutableDictionary *) _buildSectionDefinitions
{
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	NSDictionary *sectionsDict = [_dictionary objectForKey: @"sections"];
	
	if (sectionsDict) {
		[sectionsDict enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
			RCSTableSectionDefinition *def = [[RCSTableSectionDefinition alloc] initWithDictionary: obj forKey: key];
			[result setObject: def forKey: key];
			[def release];
		}];
	}
	return [result autorelease];
}

#pragma mark -
#pragma mark Public API

- (BOOL) configurationBoolForKey: (id)key_ withDefault: (BOOL)value
{
	NSNumber *num = [_dictionary objectForKey: key_];
	return num == nil ? value : [num boolValue];
}

// called by RCSTable's designated initializer
// returns an array of RCSTableSection objects
- (NSMutableArray *) sectionsForTable: (RCSTable *)table
{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	
	RCSTableSectionDefinition *secDef = nil;
	for (NSString *sectionKey in _displaySectionKeys) {
		secDef = [_sectionDefinitions objectForKey: sectionKey];
		[result addObjectsFromArray: [secDef sectionsForTable: table]];
	}
	return [result autorelease];
}

- (NSString *) title: (RCSTable *)aTable
{
	NSString *title = [_dictionary objectForKey: @"staticTitle"];
	if (title == nil) {
		title = [_dictionary objectForKey: @"title"];
		if ([title length]) {
			title = [[aTable object] valueForKeyPath: title];
		}
	}
	return title;
}

- (NSString *) tableHeaderImagePath: (RCSTable *)table
{
	NSString *result = nil;
	if (_tableHeaderImagePathSelector) {
		result = [[table controller] performSelector: _tableHeaderImagePathSelector
										  withObject: table];
	} else if (_tableHeaderImagePath) {
		result = [[table object] valueForKeyPath: _tableHeaderImagePath];
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
