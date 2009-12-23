//
//  RCSTableRow.m
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSTableRow ()
@property (nonatomic, readwrite, retain) RCSTableRowDefinition *definition;
@property (nonatomic, readwrite, assign) NSObject *object;
@property (nonatomic, readwrite, retain) NSIndexPath *indexPath;
@property (nonatomic, readwrite, assign) RCSTableSection *section; // parent
@end

@implementation RCSTableRow

@synthesize definition=_definition;
@synthesize indexPath=_indexPath;
@synthesize object=_object;
@synthesize section=_section;

- (id) initUsingDefintion: (RCSTableRowDefinition *)definition_
		   withRootObject: (NSObject *)object_
			   forSection: (RCSTableSection *)section_
			  atIndexPath: (NSIndexPath *)indexPath_
{
	if (self = [super init]) {
		self.definition = definition_;
		self.object = object_;
		self.section = section_;
		self.indexPath = indexPath_;
	}
	return self;
}

- (void) dealloc
{
	self.definition = nil;
	self.object = nil;
	self.section = nil;
	self.indexPath = nil;
	[super dealloc];
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

- (UITableViewCell *) cell
{
	UITableViewCell *cell = [[_definition.cellClass alloc] initWithStyle: _definition.cellStyle
														 reuseIdentifier: [self cellReuseIdentifier]];
	
	return [cell autorelease];
}

- (UITableViewCellEditingStyle) editingStyle
{
	return _definition.editingStyle;
}

- (NSString *) text
{
	if (_definition.staticText != nil) return _definition.staticText;
	else if (_definition.text != nil) return [_object valueForKeyPath: _definition.text];
	return nil;
}

- (NSString *) detailText
{
	if (_definition.staticDetailText != nil) return _definition.staticDetailText;
	else if (_definition.detailText != nil) return [_object valueForKeyPath: _definition.detailText];
	return nil;
}

- (UITableViewCellAccessoryType) accessoryType
{
	if (_definition.editingAccessoryType != UITableViewCellAccessoryNone) {
		RCSTableViewController *controller = _section.table.controller;
		if (controller.editing && (_definition.editingStyle == UITableViewCellEditingStyleNone)) {
			return _definition.editingAccessoryType;
		}
	}
	return _definition.accessoryType;
}

- (UITableViewCellAccessoryType) editingAccessoryType
{
	return _definition.editingAccessoryType;
}

- (CGFloat) heightWithDefault: (CGFloat)defaultHeight
{
	if (_definition.rowHeight == -1.0) {
		Class CellClass = _definition.cellClass;
		if ([CellClass respondsToSelector: @selector(calculateHeightForRCSTableRow:)]) {
			NSNumber *result = [CellClass performSelector: @selector(calculateHeightForRCSTableRow:) withObject: self];
			return result == nil ? defaultHeight : [result doubleValue];
		}
		return defaultHeight;
	}
	return _definition.rowHeight;
}

- (void) willDisplayCell: (UITableViewCell *)cell
{
	if (_definition.becomeFirstResponder) {
		[cell becomeFirstResponder];
	}
	if (_definition.backgroundColor != nil) {
		UIColor *c = [_object valueForKeyPath: _definition.backgroundColor];
		if (c != nil) {
			cell.backgroundView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
			cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			cell.backgroundView.frame = cell.bounds;
			cell.backgroundView.backgroundColor = c;
			cell.textLabel.backgroundColor = [UIColor clearColor];
			cell.detailTextLabel.backgroundColor = [UIColor clearColor];
		}
	}
}

// FIXME: committing deletes not yet functional
- (void) commitEditingStyle: (UITableViewCellEditingStyle)editingStyle
{
	RCSTableViewController *controller = _section.table.controller;
	if (_definition.editingStyleAction != (SEL)0) {
		[controller performSelector: _definition.editingStyleAction withObject: self];
		// FIXME: this should happen via a callback, or something, right, huh... seems smelly?
		/*if (_definition.editingStyle == UITableViewCellEditingStyleDelete) {
			[[sections objectAtIndex: [indexPath section]] removeObjectAtIndex: [indexPath row]];
			[tableView reloadSections: [NSIndexSet indexSetWithIndex: [indexPath section]] withRowAnimation: UITableViewRowAnimationFade];
		}*/
	} else if (_definition.editingStylePushConfiguration != nil) {
		[controller pushConfiguration: _definition.editingStylePushConfiguration withRootObject: _object];
	}
}

- (NSIndexPath *) willSelect: (NSIndexPath *)indexPath
{
	RCSTableViewController *controller = self.section.table.controller;
	if (_definition.action != (SEL)0) {
		return indexPath;
	} else if (_definition.pushConfiguration != nil) {
		return indexPath;
	} else if (controller.editing) {
		if (_definition.editAction != (SEL)0) {
			return indexPath;
		} else if (_definition.editPushConfiguration != nil) {
			return indexPath;
		}
	} else {
		if (_definition.viewAction != (SEL)0) {
			return indexPath;
		} else if (_definition.viewPushConfiguration != nil) {
			return indexPath;
		}
	}
	return nil;
}

- (void) didSelect
{
	RCSTableViewController *controller = self.section.table.controller;
	if (_definition.action != (SEL)0) {
		[controller performSelector: _definition.action withObject: self];
	} else if (_definition.pushConfiguration != nil) {
		[controller pushConfiguration: _definition.pushConfiguration withRootObject: _object];
	} else if (controller.editing) {
		if (_definition.editAction != (SEL)0) {
			[controller performSelector: _definition.editAction withObject: self];
		} else if (_definition.editPushConfiguration != nil) {
			[controller pushConfiguration: _definition.editPushConfiguration withRootObject: _object];
		}
	} else {
		if (_definition.viewAction != (SEL)0) {
			[controller performSelector: _definition.viewAction withObject: self];
		} else if (_definition.viewPushConfiguration != nil) {
			[controller pushConfiguration: _definition.viewPushConfiguration withRootObject: _object];
		}
	}
}

- (void) accessoryButtonTapped
{
	RCSTableViewController *controller = self.section.table.controller;
	if (_definition.accessoryAction != (SEL)0) {
		[controller performSelector: _definition.accessoryAction withObject: _object];
	} else if (_definition.accessoryPushConfiguration != nil) {
		[controller pushConfiguration: _definition.accessoryPushConfiguration withRootObject: _object];
	} else if (controller.editing) {
		if (_definition.editAccessoryAction != (SEL)0) {
			[controller performSelector: _definition.editAccessoryAction withObject: _object];
		} else if (_definition.editAccessoryPushConfiguration != nil) {
			[controller pushConfiguration: _definition.editAccessoryPushConfiguration withRootObject: _object];
		}
	} else {
		if (_definition.viewAccessoryAction != (SEL)0) {
			[controller performSelector: _definition.viewAccessoryAction withObject: _object];
		} else if (_definition.viewAccessoryPushConfiguration != nil) {
			[controller pushConfiguration: _definition.viewAccessoryPushConfiguration withRootObject: _object];
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
