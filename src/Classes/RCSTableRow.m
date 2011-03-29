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
	// FIXME: avoid creating a new RCSTableDefinition here if possible
	// TODO: support pulling the bundle from the same bundle as the current definition came from
	RCSTableDefinition *def = [RCSTableDefinition tableDefinitionNamed: name inBundle: nil];
	UIViewController *vc = [def viewControllerWithRootObject: object];
	[controller.navigationController pushViewController: vc animated: YES];
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
