//
//  RCSTableDefinition.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTable, RCSTableViewController;

@interface RCSTableDefinition : RCSBaseDefinition
{
	NSDictionary *_dictionary;
	NSMutableArray *_displaySectionKeys;
	NSMutableDictionary *_sectionDefinitions;
	NSString *_tableHeaderImagePath;
	SEL _tableHeaderImagePathSelector;
	NSString *_nibName;
	NSString *_nibBundleName;
	NSString *_controllerClassName;
}

// the source dictionary that generated this definition
@property (nonatomic, readonly, retain) NSDictionary *dictionary;

// list of section definitions to display, in the order they should appear
@property (nonatomic, readonly, retain) NSMutableArray *displaySectionKeys;

// dictionary of definitions for the sections in tables with this definition
@property (nonatomic, readonly, retain) NSMutableDictionary *sectionDefinitions;

@property (nonatomic, retain) NSString *tableHeaderImagePath;
@property (nonatomic, assign) SEL tableHeaderImagePathSelector;

@property (nonatomic, readonly, retain) NSString *nibName;
@property (nonatomic, readonly, retain) NSString *nibBundleName;
@property (nonatomic, readonly, retain) NSString *controllerClassName;

+ (RCSTableDefinition *) tableDefinitionNamed: (NSString *)name inBundle: (NSBundle *)bundle;

- (id) initWithDictionary: (NSDictionary *)dictionary_;

- (NSMutableArray *) sectionsForTable: (RCSTable *)table;

- (RCSTableViewController *) viewControllerWithRootObject: (NSObject *)object;

- (NSString *) title: (RCSTable *)aTable;

- (BOOL) configurationBoolForKey: (id)key_ withDefault: (BOOL)value;

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
