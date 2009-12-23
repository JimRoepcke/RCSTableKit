//
//  RCSTableViewController.h
//  Created by Jim Roepcke.
//  See license below.
//

#import <UIKit/UIKit.h>

@class RCSTableViewDataSource, RCSTableViewDelegate;

@interface RCSTableViewController : UIViewController {
	UITableView *_tableView;
	NSString *_configurationName;
	NSDictionary *_configuration;
	RCSTableViewDataSource *_dataSource;
	RCSTableViewDelegate *_tableViewDelegate;
}

@property (nonatomic, retain) IBOutlet  UITableView *tableView;
@property (nonatomic, readonly, copy)   NSString *configurationName;
@property (nonatomic, readonly, retain) NSDictionary *configuration;
@property (nonatomic, retain) RCSTableViewDataSource *dataSource;
@property (nonatomic, retain) RCSTableViewDelegate *tableViewDelegate;

- (id) initWithRootObject: (NSObject *)rootObject_
			configuration: (NSDictionary *)configuration_
					named: (NSString *) name_;

- (NSObject *) rootObject;

- (void) reloadData;

- (NSDictionary *) relaunchRestorationState;

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
