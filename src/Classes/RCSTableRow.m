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
- (void) pushConfiguration: (NSString *)name withRootObject: (NSObject *)object usingController: (RCSTableViewController *)controller;
- (UITableViewCellStyle) cellStyle;
@end

@implementation RCSTableRow

@synthesize cell=_cell;
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
		_cell = nil;
		self.definition = definition_;
		self.object = object_;
		self.section = section_;
		self.indexPath = indexPath_;
	}
	return self;
}

- (void) dealloc
{
	_cell = nil;
	[_definition release]; _definition = nil;
	_object = nil;
	_section = nil;
	[_indexPath release]; _indexPath = nil;
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
		cell = [[[_definition.cellClass alloc] initWithStyle: [self cellStyle]
											 reuseIdentifier: [self cellReuseIdentifier]] autorelease];
	}
	
	return cell;
}

- (UITableViewCellEditingStyle) editingStyle
{
	return _definition.editingStyle;
}

- (UITableViewCellStyle) cellStyle
{
	NSString *s = nil;
	if (_definition.cellStyle != nil) s = [[_object valueForKeyPath: _definition.cellStyle] description];
	else if (_definition.cellStyleSelector != (SEL)0) s = [[self.section.table.controller performSelector: _definition.cellStyleSelector withObject: self] description];
	else return _definition.staticCellStyle;
	if (s) {
		if ([@"value1" isEqualToString: s]) {
			return UITableViewCellStyleValue1;
		} else if ([@"value2" isEqualToString: s]) {
			return UITableViewCellStyleValue2;
		} else if ([@"subtitle" isEqualToString: s]) {
			return UITableViewCellStyleSubtitle;
		} else {
			return UITableViewCellStyleDefault;
		}
	} else {
		return UITableViewCellStyleDefault;
	}
}

- (NSString *) text
{
	if (_definition.staticText != nil) return _definition.staticText;
	else if (_definition.text != nil) return [_object valueForKeyPath: _definition.text];
	else if (_definition.textSelector != (SEL)0) return [self.section.table.controller performSelector: _definition.textSelector withObject: self];
	return nil;
}

- (NSString *) detailText
{
	if (_definition.staticDetailText != nil) return _definition.staticDetailText;
	else if (_definition.detailText != nil) return [_object valueForKeyPath: _definition.detailText];
	else if (_definition.detailTextSelector != (SEL)0) return [self.section.table.controller performSelector: _definition.detailTextSelector withObject: self];
	return nil;
}

- (UIImage *) image
{
	if (_definition.staticImageName != nil) return [UIImage imageNamed: _definition.staticImageName];
	else if (_definition.image != nil) return [_object valueForKeyPath: _definition.image];
	else if (_definition.imageSelector != (SEL)0) return [self.section.table.controller performSelector: _definition.imageSelector withObject: self];
	return nil;
}

- (UITableViewCellAccessoryType) accessoryType
{
	RCSTableViewController *controller = _section.table.controller;
	if (controller.editing) return [self editingAccessoryType];

	if (_definition.accessoryTypeSelector != (SEL)0) {
		NSNumber *type = [controller performSelector: _definition.accessoryTypeSelector withObject: self];
		return (UITableViewCellAccessoryType)[type intValue];
	} else if (_definition.accessoryType != nil) {
		NSNumber *type = [_object valueForKeyPath: _definition.accessoryType];
		return (UITableViewCellAccessoryType)[type intValue];
	}
	
	return _definition.staticAccessoryType;
}

- (UITableViewCellAccessoryType) editingAccessoryType
{
	if (_definition.editingAccessoryTypeSelector != (SEL)0) {
		RCSTableViewController *controller = _section.table.controller;
		NSNumber *type = [controller performSelector: _definition.editingAccessoryTypeSelector withObject: self];
		return (UITableViewCellAccessoryType)[type intValue];
	} else if (_definition.editingAccessoryType != nil) {
		NSNumber *type = [_object valueForKeyPath: _definition.editingAccessoryType];
		return (UITableViewCellAccessoryType)[type intValue];
	}
	
	return _definition.staticEditingAccessoryType;
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

- (UIColor *) backgroundColor
{
	id result = nil;
	if (_definition.backgroundColorSelector != (SEL)0) result = [self.section.table.controller performSelector: _definition.backgroundColorSelector withObject: self];
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
	RCSTableViewController *controller = _section.table.controller;
	if (_definition.editingStyleAction != (SEL)0) {
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
		[self pushConfiguration: _definition.pushConfiguration withRootObject: _object usingController: controller];
	} else if (controller.editing) {
		if (_definition.editAction != (SEL)0) {
			[controller performSelector: _definition.editAction withObject: self];
		} else if (_definition.editPushConfiguration != nil) {
			[self pushConfiguration: _definition.editPushConfiguration withRootObject: _object usingController: controller];
		}
	} else {
		if (_definition.viewAction != (SEL)0) {
			[controller performSelector: _definition.viewAction withObject: self];
		} else if (_definition.viewPushConfiguration != nil) {
			[self pushConfiguration: _definition.viewPushConfiguration withRootObject: _object usingController: controller];
		}
	}
}

- (void) accessoryButtonTapped
{
	RCSTableViewController *controller = self.section.table.controller;
	if (_definition.accessoryAction != (SEL)0) {
		[controller performSelector: _definition.accessoryAction withObject: self];
	} else if (_definition.accessoryPushConfiguration != nil) {
		[self pushConfiguration: _definition.accessoryPushConfiguration withRootObject: self usingController: controller];
	} else if (controller.editing) {
		if (_definition.editAccessoryAction != (SEL)0) {
			[controller performSelector: _definition.editAccessoryAction withObject: self];
		} else if (_definition.editAccessoryPushConfiguration != nil) {
			[self pushConfiguration: _definition.editAccessoryPushConfiguration withRootObject: self usingController: controller];
		}
	} else {
		if (_definition.viewAccessoryAction != (SEL)0) {
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
