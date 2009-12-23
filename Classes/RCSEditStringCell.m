//
//  RCSEditStringCell.m
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSEditStringCell.h"
#import "RCSTable.h"
#import "RCSTableSection.h"
#import "RCSTableRow.h"

@implementation RCSEditStringCell

- (id)initWithStyle: (UITableViewCellStyle)style reuseIdentifier: (NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        // Initialization code
		_editStringTextField = [[UITextField alloc] initWithFrame: CGRectZero];
		_editStringTextField.delegate = self;
		_editStringTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		for (UIView *view in self.contentView.subviews) {
			[view removeFromSuperview];
		}
		[self.contentView addSubview: _editStringTextField];
    }
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[_editStringTextField release];
    [super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	CGRect boundsFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
	CGRect textFieldFrame = CGRectInset(boundsFrame, 10.0, 5.0);
	textFieldFrame.origin.y += 2.0;
	_editStringTextField.frame = textFieldFrame;
}

- (BOOL) supportsText { return NO; }
- (BOOL) supportsDetailText { return NO; }
- (BOOL) supportsAccessories { return NO; }

- (void) setRow: (RCSTableRow *)newRow
{
	[super setRow: newRow];
	if (newRow != nil) {
		[[NSNotificationCenter defaultCenter] addObserver: self
												 selector: @selector(viewWillDisappear:)
													 name: @"RCSTableViewControllerViewWillDisappear"
												   object: newRow.section.table.controller];
		_editStringTextField.font = [UIFont boldSystemFontOfSize: 24.0];
		_editStringTextField.adjustsFontSizeToFitWidth = YES;
		_editStringTextField.minimumFontSize = 16.0;
		_editStringTextField.text = [newRow.object valueForKeyPath: [newRow stringForDictionaryKey: @"attribute"]];
		NSString *autocapitalizationTypeString = [newRow stringForDictionaryKey: @"autocapitalizationType"];
		if (autocapitalizationTypeString != nil) {
			if ([@"words" isEqualToString: autocapitalizationTypeString]) {
				_editStringTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
			} else if ([@"sentences" isEqualToString: autocapitalizationTypeString]) {
				_editStringTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
			} else if ([@"allCharacters" isEqualToString: autocapitalizationTypeString]) {
				_editStringTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
			}
		}
		NSString *autocorrectionTypeString = [newRow stringForDictionaryKey: @"autocorrectionType"];
		if (autocorrectionTypeString != nil) {
			if ([@"yes" isEqualToString: autocorrectionTypeString]) {
				_editStringTextField.autocorrectionType = UITextAutocorrectionTypeYes;
			} else if ([@"no" isEqualToString: autocorrectionTypeString]) {
				_editStringTextField.autocorrectionType = UITextAutocorrectionTypeNo;
			}
		}
		NSString *clearButtonMode = [newRow stringForDictionaryKey: @"clearButtonMode"];
		if (clearButtonMode != nil) {
			if ([@"whileEditing" isEqualToString: clearButtonMode]) {
				_editStringTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
			} else if ([@"unlessEditing" isEqualToString: clearButtonMode]) {
				_editStringTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
			} else if ([@"always" isEqualToString: clearButtonMode]) {
				_editStringTextField.clearButtonMode = UITextFieldViewModeAlways;
			}
		}
		NSString *staticPlaceholder = [newRow stringForDictionaryKey: @"staticPlaceholder"];
		if (staticPlaceholder != nil) {
			_editStringTextField.placeholder = staticPlaceholder;
		} else {
			NSString *placeholder = [newRow stringForDictionaryKey: @"placeholder"];
			if (placeholder != nil) {
				_editStringTextField.placeholder = [newRow.object valueForKeyPath: placeholder];
			}
		}
		NSString *keyboardType = [newRow stringForDictionaryKey: @"staticKeyboardType"];
		if (keyboardType == nil) {
			keyboardType = [newRow stringForDictionaryKey: @"keyboardType"];
			if (keyboardType != nil) {
				keyboardType = [newRow.object valueForKeyPath: keyboardType];
			}
		}
		if (keyboardType != nil) {
			if ([@"default" isEqualToString: keyboardType]) {
				_editStringTextField.keyboardType = UIKeyboardTypeDefault;
			} else if ([@"asciiCapable" isEqualToString: keyboardType]) {
				_editStringTextField.keyboardType = UIKeyboardTypeASCIICapable;
			} else if ([@"numbersAndPunctuation" isEqualToString: keyboardType]) {
				_editStringTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
			} else if ([@"url" isEqualToString: keyboardType]) {
				_editStringTextField.keyboardType = UIKeyboardTypeURL;
			} else if ([@"numberPad" isEqualToString: keyboardType]) {
				_editStringTextField.keyboardType = UIKeyboardTypeNumberPad;
			} else if ([@"phonePad" isEqualToString: keyboardType]) {
				_editStringTextField.keyboardType = UIKeyboardTypePhonePad;
			} else if ([@"namePhonePad" isEqualToString: keyboardType]) {
				_editStringTextField.keyboardType = UIKeyboardTypeNamePhonePad;
			} else if ([@"emailAddress" isEqualToString: keyboardType]) {
				_editStringTextField.keyboardType = UIKeyboardTypeEmailAddress;
			}
		}
	}
}

- (void)removeFromSuperview
{
	[self.row.object setValue: _editStringTextField.text
				   forKeyPath: [self.row stringForDictionaryKey: @"attribute"]];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super removeFromSuperview];
}

- (BOOL)becomeFirstResponder
{
	[super becomeFirstResponder];
	return [_editStringTextField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
	[super resignFirstResponder];
	[self.row.object setValue: _editStringTextField.text
				   forKeyPath: [self.row stringForDictionaryKey: @"attribute"]];
	return [_editStringTextField resignFirstResponder];
}

#pragma mark -
#pragma mark RCSTableViewController notifications

- (void)viewWillDisappear: (NSNotification *)notification
{
	[self.row.object setValue: _editStringTextField.text
				   forKeyPath: [self.row stringForDictionaryKey: @"attribute"]];
}

#pragma mark -
#pragma mark Text Field Delegate methods

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[self.row.object setValue: _editStringTextField.text
				   forKeyPath: [self.row stringForDictionaryKey: @"attribute"]];
}

- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
	[self endEditing: NO];
	return NO;
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
