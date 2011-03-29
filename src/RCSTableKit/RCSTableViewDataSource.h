//
//  RCSTableDataSource.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableViewController;
@class RCSTableDefinition, RCSTable, RCSTableRow;

@interface RCSTableViewDataSource : NSObject <UITableViewDataSource>
{
	RCSTableViewController *_viewController;
	NSObject *_rootObject;
	NSDictionary *_dictionary;
	NSString *_key;
	RCSTableDefinition *_tableDefinition;
	RCSTable *_table;
}

@property (nonatomic, readonly, assign) RCSTableViewController *viewController;
@property (nonatomic, readonly, retain) NSObject *rootObject;
@property (nonatomic, readonly, retain) NSDictionary *dictionary;
@property (nonatomic, readonly, retain) NSString *key;
@property (nonatomic, readonly, retain) RCSTableDefinition *tableDefinition;
@property (nonatomic, readonly, retain) RCSTable *table;

+ (NSDictionary *) configurationNamed: (NSString *)name inBundle: (NSBundle *)bundle;
+ (NSDictionary *) configurationNamed: (NSString *)name;

- (id) initForViewController: (RCSTableViewController *)viewController_
			  withRootObject: (NSObject *)rootObject_
		  usingConfiguration: (NSDictionary *)configuration_
					   named: (NSString *)name_;

- (RCSTableRow *) rowAtIndexPath: (NSIndexPath *)indexPath;

- (void) reloadData;
- (void) setEditing: (BOOL)editing animated: (BOOL)animated;

- (BOOL) configurationBoolForKey: (id)key withDefault: (BOOL)value;
- (NSInteger) configurationIntegerForKey: (id)key withDefault: (NSInteger)value;
- (NSString *) configurationStringForKey: (id)key withDefault: (NSString *)value;

- (RCSTableViewController *) configuration: (NSString *)name withRootObject: (NSObject *)object;

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
