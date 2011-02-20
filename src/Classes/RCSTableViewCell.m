//
//  RCSTableViewCell.m
//  Created by Jim Roepcke.
//  See license below.
//

@implementation RCSTableViewCell

@synthesize row;

- (void) dealloc
{
	[row release]; row = nil;
    [super dealloc];
}

- (BOOL) supportsText { return YES; }
- (BOOL) supportsDetailText { return YES; }
- (BOOL) supportsAccessories { return YES; }
- (BOOL) supportsImages { return YES; }

- (void) didMoveToSuperview
{
	[super didMoveToSuperview];
	if (![self superview]) {
		[self setRow: nil];
	}
}

- (void) setRow: (RCSTableRow *)newRow
{
	if (row != newRow) {
		[self willChangeValueForKey: @"row"];
		[newRow retain];
		[row release];
		row = newRow;
		[self didChangeValueForKey: @"row"];
		[row setCell: nil];
	}
	if (newRow != nil) {
		[newRow setCell: self];
		if ([self supportsText]) {
			self.textLabel.text = [newRow text];
		}
		if ([self supportsDetailText]) {
			self.detailTextLabel.text = [newRow detailText];
		}
		if ([self supportsAccessories]) {
			self.accessoryType = [newRow accessoryType];
			self.editingAccessoryType = [newRow editingAccessoryType];
		}
		if ([self supportsImages]) {
			self.imageView.image = [newRow image];
		}
	}
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
