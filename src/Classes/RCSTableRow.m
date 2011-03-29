//
//  RCSTableRow.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTableRow ()
@property (nonatomic, readwrite, retain) RCSTableRowDefinition *definition;
@property (nonatomic, readwrite, assign) NSObject *object;
@property (nonatomic, readwrite, assign) RCSTableSection *section; // parent
- (void) pushConfiguration: (NSString *)name withRootObject: (NSObject *)object usingController: (RCSTableViewController *)controller;
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
		_cell = nil;
		self.definition = definition_;
		self.object = object_;
		self.section = section_;
	}
	return self;
}

- (void) dealloc
{
	_cell = nil;
	[_definition release]; _definition = nil;
	_object = nil;
	_section = nil;
	[super dealloc];
}

- (void) pushConfiguration: (NSString *)name withRootObject: (NSObject *)object usingController: (RCSTableViewController *)controller
{
	[controller.navigationController pushViewController: [controller.dataSource configuration: name withRootObject: object] animated: YES];
}

#pragma mark -
#pragma mark Public API

- (NSString *) stringForDictionaryKey: (id)key
{
	return [[_definition.dictionary objectForKey: key] description];
}

- (BOOL) isEditable
{
	return _definition.editingStyle != UITableViewCellEditingStyleNone;
}

- (NSString *) cellReuseIdentifier
{
	return [NSString stringWithFormat: @"%d", (int)(_definition.dictionary)];
}

- (UITableViewCell *) createCell
{
	NSString *nibName = _definition.cellNibName;
	UITableViewCell *cell = nil;
	if (nibName) {
		// FIXME: use UINib instead, perhaps data source holds the UINib instances?
		cell = (UITableViewCell *)[[[NSBundle mainBundle] loadNibNamed: nibName owner: self options: nil] objectAtIndex: 0];
	} else {
		cell = [[[[self cellClass] alloc] initWithStyle: [self cellStyle]
										reuseIdentifier: [self cellReuseIdentifier]] autorelease];
	}
	
	return cell;
}

- (UITableViewCellEditingStyle) editingStyle
{
	return _definition.editingStyle;
}

- (RCSTableViewController *) controller { return [[_section table] controller]; }

- (NSString *) text { return [_definition text: self]; }
- (NSString *) detailText { return [_definition detailText: self]; }
- (UIImage *) image { return [_definition image: self]; }
- (UITableViewCellAccessoryType) accessoryType { return [_definition accessoryType: self]; }
- (UITableViewCellAccessoryType) editingAccessoryType { return [_definition editingAccessoryType: self]; }
- (UITableViewCellStyle) cellStyle { return [_definition cellStyle: self]; }
- (Class) cellClass { return [_definition cellClass: self]; }

- (CGFloat) heightWithDefault: (CGFloat)defaultHeight
{
	if (_definition.rowHeight == -1.0) {
		Class CellClass = [self cellClass];
		if ([CellClass respondsToSelector: @selector(calculateHeightForRCSTableRow:)]) {
			NSNumber *result = [CellClass performSelector: @selector(calculateHeightForRCSTableRow:) withObject: self];
			return result == nil ? defaultHeight : [result doubleValue];
		}
		return defaultHeight;
	}
	return _definition.rowHeight;
}

- (UIColor *) backgroundColor
{
	id result = nil;
	if (_definition.backgroundColorSelector) result = [[self controller] performSelector: _definition.backgroundColorSelector withObject: self];
	else if (_definition.backgroundColor != nil) result = [_object valueForKeyPath: _definition.backgroundColor];
	if ([result isKindOfClass: [UIColor class]]) return result;
	return nil;
}

- (void) applyBackgroundColorToCell: (UITableViewCell *)cell
{
	UIColor *c = [self backgroundColor];
	if (c) {
		[cell setBackgroundColor: c];
	}
}

- (void) willDisplayCell: (UITableViewCell *)cell
{
	if (_definition.becomeFirstResponder) {
		[cell becomeFirstResponder];
	}
	[self applyBackgroundColorToCell: cell];
}

// FIXME: committing deletes not yet functional
- (void) commitEditingStyle: (UITableViewCellEditingStyle)editingStyle
{
	RCSTableViewController *controller = [self controller];
	if (_definition.editingStyleAction) {
		[controller performSelector: _definition.editingStyleAction withObject: self];
		// FIXME: this should happen via a callback, or something, right, huh... seems smelly?
		/*if (_definition.editingStyle == UITableViewCellEditingStyleDelete) {
			[[sections objectAtIndex: [indexPath section]] removeObjectAtIndex: [indexPath row]];
			[tableView reloadSections: [NSIndexSet indexSetWithIndex: [indexPath section]] withRowAnimation: UITableViewRowAnimationFade];
		}*/
	} else if (_definition.editingStylePushConfiguration != nil) {
		[self pushConfiguration: _definition.editingStylePushConfiguration withRootObject: _object usingController: controller];
	}
}

- (NSIndexPath *) willSelect: (NSIndexPath *)indexPath { return [_definition row: self willSelect: indexPath]; }

- (void) didSelect
{
	RCSTableViewController *controller = [self controller];
	if (_definition.action) {
		[controller performSelector: _definition.action withObject: self];
	} else if (_definition.pushConfiguration != nil) {
		[self pushConfiguration: _definition.pushConfiguration withRootObject: _object usingController: controller];
	} else if (controller.editing) {
		if (_definition.editAction) {
			[controller performSelector: _definition.editAction withObject: self];
		} else if (_definition.editPushConfiguration != nil) {
			[self pushConfiguration: _definition.editPushConfiguration withRootObject: _object usingController: controller];
		}
	} else {
		if (_definition.viewAction) {
			[controller performSelector: _definition.viewAction withObject: self];
		} else if (_definition.viewPushConfiguration != nil) {
			[self pushConfiguration: _definition.viewPushConfiguration withRootObject: _object usingController: controller];
		}
	}
}

- (void) accessoryButtonTapped
{
	RCSTableViewController *controller = [self controller];
	if (_definition.accessoryAction) {
		[controller performSelector: _definition.accessoryAction withObject: self];
	} else if (_definition.accessoryPushConfiguration != nil) {
		[self pushConfiguration: _definition.accessoryPushConfiguration withRootObject: self usingController: controller];
	} else if (controller.editing) {
		if (_definition.editAccessoryAction) {
			[controller performSelector: _definition.editAccessoryAction withObject: self];
		} else if (_definition.editAccessoryPushConfiguration != nil) {
			[self pushConfiguration: _definition.editAccessoryPushConfiguration withRootObject: self usingController: controller];
		}
	} else {
		if (_definition.viewAccessoryAction) {
			[controller performSelector: _definition.viewAccessoryAction withObject: self];
		} else if (_definition.viewAccessoryPushConfiguration != nil) {
			[self pushConfiguration: _definition.viewAccessoryPushConfiguration withRootObject: self usingController: controller];
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
