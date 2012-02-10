//
//  RCSTableDefinition.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTableDefinition ()
@property (nonatomic, readwrite, copy) NSDictionary *dictionary;
@property (nonatomic, readwrite, strong) NSArray *displaySectionKeys;
@property (nonatomic, readwrite, strong) NSMutableDictionary *sectionDefinitions;
@property (nonatomic, readwrite, copy) NSString *nibName;
@property (nonatomic, readwrite, copy) NSString *nibBundleName;
@property (nonatomic, readwrite, copy) NSString *controllerClassName;
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
@synthesize nibBundle=_nibBundle;
@synthesize controllerClassName=_controllerClassName;

- (id) initWithDictionary: (NSDictionary *)dictionary_
{
	if (self = [super init]) {
		_dictionary = [dictionary_ copy];
		_nibName = [[dictionary_ objectForKey: kTKNibNameKey] copy];
		_nibBundleName = [[dictionary_ objectForKey: kTKNibBundleNameKey] copy];
		_controllerClassName = [[dictionary_ objectForKey: kTKControllerClassNameKey] copy];
		_displaySectionKeys = [dictionary_ objectForKey: kTKDisplaySectionKeysKey];
		if (_displaySectionKeys == nil) {
			// TODO: use all sections? in what order? alphabetical? throw an exception?
			_displaySectionKeys = [[NSArray alloc] init];
		}
		_sectionDefinitions = [self _buildSectionDefinitions];
		_tableHeaderImagePath = [[dictionary_ objectForKey: kTKTableHeaderImagePath] copy];
		_tableHeaderImagePathSelector = NSSelectorFromString([dictionary_ objectForKey: kTKTableHeaderImagePathSelector]);
	}
	return self;
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
	return result;
}

- (NSBundle *) nibBundle
{
	if (_nibBundle == nil) {
		NSString *nibBundleName = [self nibBundleName];
		if ([nibBundleName length]) {
			NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: nibBundleName];
			_nibBundle = [NSBundle bundleWithPath: path];
		}
	}
	return _nibBundle;
}

- (RCSTableViewController *) viewControllerWithRootObject: (NSObject *)object
{

	NSString *name = [self controllerClassName];
	Class controllerClass = name ? NSClassFromString(name) : [RCSTableViewController class];
	RCSTableViewController *c = nil;
	if ([controllerClass isSubclassOfClass: [RCSTableViewController class]]) {
		c = [[controllerClass alloc] initWithNibName: [self nibName] bundle: [self nibBundle]];
		[c setRootObject: object];
		[c setTableDefinition: self];
	}
	return c;
}

- (NSMutableDictionary *) _buildSectionDefinitions
{
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	NSDictionary *sectionsDict = [_dictionary objectForKey: kTKSectionsKey];
	
	if (sectionsDict) {
		[sectionsDict enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
			RCSTableSectionDefinition *def = [[RCSTableSectionDefinition alloc] initWithDictionary: obj forKey: key];
			[result setObject: def forKey: key];
		}];
	}
	return result;
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
	return result;
}

- (NSString *) title: (RCSTable *)aTable
{
	NSString *title = [_dictionary objectForKey: kTKStaticTitleKey];
	if (title == nil) {
		title = [_dictionary objectForKey: kTKTitleKey];
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        result = [[table controller] performSelector: _tableHeaderImagePathSelector
										  withObject: table];
#pragma clang diagnostic pop
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
