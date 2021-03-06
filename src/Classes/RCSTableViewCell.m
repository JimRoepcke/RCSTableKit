//
//  RCSTableViewCell.m
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSTableViewCell.h"
#import "RCSTableKitConstants.h"
#import "RCSTableRow.h"

@implementation RCSTableViewCell

@synthesize row=_row;

- (BOOL) supportsText { return YES; }
- (BOOL) supportsDetailText { return YES; }
- (BOOL) supportsAccessories { return YES; }
- (BOOL) supportsImages { return YES; }
- (BOOL) supportsBackgroundColor { return YES; }

- (void) didMoveToSuperview
{
	[super didMoveToSuperview];
	if (![self superview]) {
		[self setRow: nil];
	}
}

- (void) setRow: (RCSTableRow *)newRow
{
	if (_row != newRow) {
		[self willChangeValueForKey: kTKRowKey];
		_row = newRow;
		[self didChangeValueForKey: kTKRowKey];
		[_row setCell: nil];
	}
	if (newRow) {
		[newRow setCell: self];
		if ([self supportsText]) {
			[[self textLabel] setText: [newRow text]];
		}
		if ([self supportsDetailText]) {
			[[self detailTextLabel] setText: [newRow detailText]];
		}
		if ([self supportsAccessories]) {
			[self setAccessoryType: [newRow accessoryType]];
			[self setEditingAccessoryType: [newRow editingAccessoryType]];
		}
		if ([self supportsImages]) {
			[[self imageView] setImage: [newRow image]];
		}
	}
}

@end

/*
 * Copyright 2009-2013 Jim Roepcke <jim@roepcke.com>. All rights reserved.
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
