//
//  RCSTableDefinition.h
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSBaseDefinition.h"

@class RCSTable, RCSTableViewController;

@interface RCSTableDefinition : RCSBaseDefinition

@property (nonatomic, readonly, strong) NSBundle *bundle;

@property (nonatomic, readonly, copy) NSString *name;

// the source dictionary that generated this definition
@property (nonatomic, readonly, copy) NSDictionary *dictionary;

// list of section definitions to display, in the order they should appear
@property (nonatomic, readonly, strong) NSArray *displaySections;

// dictionary of definitions for the sections in tables with this definition
@property (nonatomic, readonly, strong) NSMutableDictionary *sectionDefinitions;

@property (nonatomic, copy) NSString *tableHeaderImagePath;
@property (nonatomic, assign) SEL tableHeaderImagePathSelector;

@property (nonatomic, readonly, copy) NSString *nibName;
@property (nonatomic, readonly, copy) NSString *nibBundleName;
@property (nonatomic, readonly, strong) NSBundle *nibBundle;
@property (nonatomic, readonly, copy) NSString *controllerClassName;

+ (RCSTableDefinition *) tableDefinitionNamed: (NSString *)name;
+ (RCSTableDefinition *) tableDefinitionNamed: (NSString *)name inBundle: (NSBundle *)bundle;

- (id) initWithDictionary: (NSDictionary *)dictionary_;
- (id) initWithName: (NSString *)name_
         dictionary: (NSDictionary *)dictionary_;
- (id) initWithName: (NSString *)name_
         dictionary: (NSDictionary *)dictionary_
             bundle: (NSBundle *)bundle_;

- (NSMutableArray *) sectionsForTable: (RCSTable *)table;

- (RCSTableViewController *) viewControllerWithRootObject: (NSObject *)object;

- (NSString *) title: (RCSTable *)aTable;
- (NSString *) tableHeaderImagePath: (RCSTable *)table;

- (BOOL) isEditable;
- (BOOL) allowsSelection;
- (BOOL) allowsSelectionDuringEditing;
- (BOOL) allowsMultipleSelection;
- (BOOL) allowsMultipleSelectionDuringEditing;

@end

/*
 * Copyright 2009-2012 Jim Roepcke <jim@roepcke.com>. All rights reserved.
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
