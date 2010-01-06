//
//  RCSAddressCell.m
//  Created by Jim Roepcke.
//  See license below.
//

@implementation RCSAddressCell

- (id) initWithStyle: (UITableViewCellStyle)style reuseIdentifier: (NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: UITableViewCellStyleValue2 reuseIdentifier: reuseIdentifier]) {
        // Initialization code
		_lines = [[NSMutableArray alloc] initWithCapacity: 4];
		_labels = [[NSArray alloc] initWithObjects:
				   [self.detailTextLabel retain],
				   [[UILabel alloc] initWithFrame: CGRectZero],
				   [[UILabel alloc] initWithFrame: CGRectZero],
				   [[UILabel alloc] initWithFrame: CGRectZero], nil];
		[_labels makeObjectsPerformSelector: @selector(release)];
    }
    return self;
}

- (void) dealloc
{
	[_lines release]; _lines = nil;
	[_labels release]; _labels = nil;
    [super dealloc];
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	CGRect frame = self.textLabel.frame;
	frame.origin.y = 15.0;
	self.textLabel.frame = frame;
	frame = self.detailTextLabel.frame;
	frame.origin.y = 13.0;
	NSEnumerator *labelEnumerator = [_labels objectEnumerator];
	for (NSString *line in _lines) {
		UILabel *label = [labelEnumerator nextObject];
		label.font = self.detailTextLabel.font;
		label.text = line;
		if ([label superview] == nil) [self.contentView addSubview: label];
		label.frame = frame;
		frame.origin.y += 18.0;
	}
	
}

- (void) setHighlighted: (BOOL)highlighted animated: (BOOL)animated
{
	[super setHighlighted: highlighted animated: animated];
	UIColor *c = (highlighted || self.selected) ? [UIColor whiteColor] : [UIColor blackColor];
	for (UILabel *label in _labels) {
		label.textColor = c;
	}
}

- (void) setSelected: (BOOL)selected animated: (BOOL)animated
{
	[super setSelected: selected animated: animated];
	UIColor *c = (selected || self.highlighted) ? [UIColor whiteColor] : [UIColor blackColor];
	for (UILabel *label in _labels) {
		label.textColor = c;
	}
}

- (NSString *) string: (NSString *)s { return s == nil ? @"" : s; }
+ (NSString *) string: (NSString *)s { return s == nil ? @"" : s; }

- (void) setRow: (RCSTableRow *)newRow
{
	[super setRow: newRow];
	if (newRow != nil) {
		[_lines removeAllObjects];
		NSString *a1, *a2, *a3, *a4;
		a1 = [self string: [newRow.object valueForKey: @"address1"]];
		a2 = [self string: [newRow.object valueForKey: @"address2"]];
		a3 = [self string: [newRow.object valueForKey: @"city"]];
		NSString *state = [self string: [newRow.object valueForKey: @"state"]];
		if ([a3 length] == 0) {
			a3 = state;
		} else {
			if ([state length] > 0) {
				a3 = [a3 stringByAppendingFormat: @", %@", state];
			}
		}
		a4 = [self string: [newRow.object valueForKey: @"zip"]];
		if ([a1 length] > 0) [_lines addObject: a1];
		if ([a2 length] > 0) [_lines addObject: a2];
		if ([a3 length] > 0) [_lines addObject: a3];
		if ([a4 length] > 0) [_lines addObject: a4];
		[self setNeedsLayout];
	}
}

// TODO: refactor this and setConfiguration: to not duplicate code
+ (NSNumber *) calculateHeightForRCSTableRow: (RCSTableRow *)conf
{
	NSString *a1, *a2, *a3, *a4;
	a1 = [self string: [conf.object valueForKey: @"address1"]];
	a2 = [self string: [conf.object valueForKey: @"address2"]];
	a3 = [self string: [conf.object valueForKey: @"city"]];
	NSString *state = [conf.object valueForKey: @"state"];
	if ([a3 length] == 0) {
		a3 = state;
	} else {
		if ([state length] > 0) {
			a3 = [a3 stringByAppendingFormat: @", %@", state];
		}
	}
	a4 = [self string: [conf.object valueForKey: @"zip"]];
	int num = 0;
	if ([a1 length] > 0) num++;
	if ([a2 length] > 0) num++;
	if ([a3 length] > 0) num++;
	if ([a4 length] > 0) num++;
	return [NSNumber numberWithFloat: MAX(29.0 + (18.0 * num), 47.0)];
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
