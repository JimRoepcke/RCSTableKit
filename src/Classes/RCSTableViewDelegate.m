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
		_dataSource = dataSource_;
		_viewController = viewController_;
	}
	return self;
}

- (void) tableView: (UITableView *) tableView willDisplayCell: (UITableViewCell *)cell forRowAtIndexPath: (NSIndexPath *)indexPath
{
	[[_dataSource rowAtIndexPath: indexPath] willDisplayCell: cell];
}

- (UITableViewCellEditingStyle) tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return [((RCSTableRow *)[_dataSource rowAtIndexPath: indexPath]) editingStyle];
}

- (void) tableView: (UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath
{
    [[_dataSource rowAtIndexPath: indexPath] accessoryButtonTapped];
}

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
	return [((RCSTableRow *)[_dataSource rowAtIndexPath: indexPath]) heightWithDefault: tableView.rowHeight];
}

- (NSIndexPath *) tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	return [[_dataSource rowAtIndexPath: indexPath] willSelect: indexPath];
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	[[_dataSource rowAtIndexPath: indexPath] didSelect];
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
