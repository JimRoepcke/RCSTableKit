//
//  RCSTableDataSource.h
//  Created by Jim Roepcke.
//  See license below.
//

@class RCSTableViewController;
@class RCSTableDefinition, RCSTable, RCSTableRow;

@interface RCSTableViewDataSource : NSObject <UITableViewDataSource> {
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
