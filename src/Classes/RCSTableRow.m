//
//  RCSTableRow.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTableRow ()
@property (nonatomic, readwrite, strong) RCSTableRowDefinition *definition;
@property (nonatomic, readwrite, assign) NSObject *object;
@property (nonatomic, readwrite, assign) RCSTableSection *section; // parent
- (UITableViewCellStyle) cellStyle;
@end

@implementation RCSTableRow

@synthesize cell=_cell;
@synthesize definition=_definition;
@synthesize object=_object;
@synthesize section=_section;

- (id) initUsingDefintion: (RCSTableRowDefinition *)definition_
		   withRootObject: (NSObject *)object_
			   forSection: (RCSTableSection *)section_
{
	if (self = [super init]) {
		_definition = definition_;
		_object = object_;
		_section = section_;
	}
	return self;
}


#pragma mark -
#pragma mark Public API

- (RCSTableViewController *) controller { return [[_section table] controller]; }

- (NSString *) stringForDictionaryKey: (id)key
{
	return [[[_definition dictionary] objectForKey: key] description];
}

- (BOOL) isEditable
{
	return [_definition editingStyle] != UITableViewCellEditingStyleNone;
}

- (UITableViewCell *) createCell
{
	NSString *nibName = [_definition cellNibName];
	UITableViewCell *cell;
	if (nibName) {
		// FIXME: use UINib instead, perhaps data source holds the UINib instances?
		NSArray *a = [[NSBundle mainBundle] loadNibNamed: nibName
												   owner: self
												 options: nil];
		cell = [a objectAtIndex: 0];
	} else {
		cell = [[[self cellClass] alloc] initWithStyle: [self cellStyle]
                                        reuseIdentifier: [self cellReuseIdentifier]];
	}
	
	return cell;
}

- (UIColor *) backgroundColor { return [_definition backgroundColor: self]; }
- (NSString *) text { return [_definition text: self]; }
- (NSString *) detailText { return [_definition detailText: self]; }
- (UIImage *) image { return [_definition image: self]; }
- (UITableViewCellEditingStyle) editingStyle { return [_definition editingStyle]; }
- (UITableViewCellAccessoryType) accessoryType { return [_definition accessoryType: self]; }
- (UITableViewCellAccessoryType) editingAccessoryType { return [_definition editingAccessoryType: self]; }
- (UITableViewCellStyle) cellStyle { return [_definition cellStyle: self]; }
- (NSString *) cellReuseIdentifier { return [_definition cellReuseIdentifier]; }
- (Class) cellClass { return [_definition cellClass: self]; }

- (CGFloat) heightWithDefault: (CGFloat)defaultHeight
{
	if ([_definition rowHeight] == -1.0) {
		Class CellClass = [self cellClass];
		if ([CellClass respondsToSelector: @selector(calculateHeightForRCSTableRow:)]) {
			NSNumber *result = [CellClass performSelector: @selector(calculateHeightForRCSTableRow:) withObject: self];
			return result ? [result doubleValue] : defaultHeight;
		}
		return defaultHeight;
	}
	return [_definition rowHeight];
}

- (void) applyBackgroundColorToCell: (UITableViewCell *)cell
{
	UIColor *c = [_definition backgroundColor: self];
	if ([c isKindOfClass: [UIColor class]]) {
		[cell setBackgroundColor: c];
	}
}

- (void) willDisplayCell: (UITableViewCell *)cell
{
	if ([_definition becomeFirstResponder]) {
		[cell becomeFirstResponder];
	}
	if ([cell isKindOfClass: [RCSTableViewCell class]] &&
		[(RCSTableViewCell *)cell supportsBackgroundColor]) {
		[self applyBackgroundColorToCell: cell];
	}
}

- (void) commitEditingStyle: (UITableViewCellEditingStyle)editingStyle { [_definition rowCommitEditingStyle: self]; }
- (NSIndexPath *) willSelect: (NSIndexPath *)indexPath { return [_definition row: self willSelect: indexPath]; }
- (void) didSelect { [_definition rowDidSelect: self]; }
- (void) accessoryButtonTapped { [_definition rowAccessoryButtonTapped: self]; }

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
