//
//  RCSTableViewDelegate.m
//  Created by Jim Roepcke.
//  See license below.
//

@implementation RCSTableViewDelegate

@synthesize dataSource=_dataSource;
@synthesize viewController=_viewController;

- (id) initForViewController: (UIViewController *)viewController_ withDataSource: (RCSTableViewDataSource *)dataSource_
{
	self = [super init];
	if (self != nil) {
		self.dataSource = dataSource_;
		self.viewController = viewController_;
	}
	return self;
}

- (void) tableView: (UITableView *) tableView willDisplayCell: (UITableViewCell *)cell forRowAtIndexPath: (NSIndexPath *)indexPath
{
	[[self.dataSource rowAtIndexPath: indexPath] willDisplayCell: cell];
}

- (UITableViewCellEditingStyle) tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return [((RCSTableRow *)[self.dataSource rowAtIndexPath: indexPath]) editingStyle];
}

- (void) tableView: (UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath
{
    [[self.dataSource rowAtIndexPath: indexPath] accessoryButtonTapped];
}

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
	return [((RCSTableRow *)[self.dataSource rowAtIndexPath: indexPath]) heightWithDefault: tableView.rowHeight];
}

- (NSIndexPath *) tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	return [[self.dataSource rowAtIndexPath: indexPath] willSelect: indexPath];
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	[[self.dataSource rowAtIndexPath: indexPath] didSelect];
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
