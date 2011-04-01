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
				   [[self detailTextLabel] retain],
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
	CGSize sz = self.contentView.bounds.size;
	CGRect frame = [[self textLabel] frame];
	frame.origin.y = 15.0;
	[[self textLabel] setFrame: frame];
	frame = [[self detailTextLabel] frame];
	frame.origin.y = 13.0;
	frame.size.width = sz.width - frame.origin.x - 5.0;
	NSEnumerator *labelEnumerator = [_labels objectEnumerator];
	for (NSString *line in _lines) {
		UILabel *label = [labelEnumerator nextObject];
		[label setFont: [[self detailTextLabel] font]];
		[label setText: line];
		if ([label superview] == nil) [[self contentView] addSubview: label];
		[label setFrame: frame];
		frame.origin.y += 18.0;
	}
	
}

- (void) setHighlighted: (BOOL)highlighted animated: (BOOL)animated
{
	[super setHighlighted: highlighted animated: animated];
	UIColor *c = (highlighted || [self isSelected]) ? [UIColor whiteColor] : [UIColor blackColor];
	for (UILabel *label in _labels) {
		[label setTextColor: c];
	}
}

- (void) setSelected: (BOOL)selected animated: (BOOL)animated
{
	[super setSelected: selected animated: animated];
	UIColor *c = (selected || [self isHighlighted]) ? [UIColor whiteColor] : [UIColor blackColor];
	for (UILabel *label in _labels) {
		[label setTextColor: c];
	}
}

- (NSString *) string: (NSString *)s { return s == nil ? @"" : s; }
+ (NSString *) string: (NSString *)s { return s == nil ? @"" : s; }

- (BOOL) supportsImages { return NO; }

- (void) setRow: (RCSTableRow *)newRow
{
	[super setRow: newRow];
	if (newRow) {
		id nRO = [newRow object];
		[_lines removeAllObjects];
		NSString *a1, *a2, *a3, *a4;
		a1 = [self string: [nRO valueForKey: @"address1"]];
		a2 = [self string: [nRO valueForKey: @"address2"]];
		a3 = [self string: [nRO valueForKey: @"city"]];
		NSString *state = [self string: [nRO valueForKey: @"state"]];
		if ([a3 length] == 0) {
			a3 = state;
		} else {
			if ([state length] > 0) {
				a3 = [a3 stringByAppendingFormat: @", %@", state];
			}
		}
		a4 = [self string: [nRO valueForKey: @"zip"]];
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
	id co = [conf object];
	a1 = [self string: [co valueForKey: @"address1"]];
	a2 = [self string: [co valueForKey: @"address2"]];
	a3 = [self string: [co valueForKey: @"city"]];
	NSString *state = [co valueForKey: @"state"];
	if ([a3 length] == 0) {
		a3 = state;
	} else {
		if ([state length] > 0) {
			a3 = [a3 stringByAppendingFormat: @", %@", state];
		}
	}
	a4 = [self string: [co valueForKey: @"zip"]];
	int num = 0;
	if ([a1 length] > 0) num++;
	if ([a2 length] > 0) num++;
	if ([a3 length] > 0) num++;
	if ([a4 length] > 0) num++;
	return [NSNumber numberWithFloat: MAX(29.0 + (18.0 * num), 47.0)];
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
