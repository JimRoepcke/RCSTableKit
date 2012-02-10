//
//  RCSEditStringCell.m
//  Created by Jim Roepcke.
//  See license below.
//

NSString * const kTKESCAttributeKey = @"attribute";
NSString * const kTKESCAutocapitalizationTypeKey = @"autocapitalizationType";
NSString * const kTKESCAutocorrectionTypeKey = @"autocorrectionType";
NSString * const kTKESCClearButtonModeKey = @"clearButtonMode";
NSString * const kTKESCStaticPlaceholderKey = @"staticPlaceholder";
NSString * const kTKESCPlaceholderKey = @"placeholder";
NSString * const kTKESCStaticKeyboardTypeKey = @"staticKeyboardType";
NSString * const kTKESCKeyboardTypeKey = @"keyboardType";

NSString * const kTKESCAutocapitalizationTypeWordsKey = @"words";
NSString * const kTKESCAutocapitalizationTypeSentencesKey = @"sentences";
NSString * const kTKESCAutocapitalizationTypeAllCharactersKey = @"allCharacters";

NSString * const kTKESCAutocorrectionTypeYesKey = @"yes";
NSString * const kTKESCAutocorrectionTypeNoKey = @"no";

NSString * const kTKESCClearButtonModeWhileEditingKey = @"whileEditing";
NSString * const kTKESCClearButtonModeUnlessEditingKey = @"unlessEditing";
NSString * const kTKESCClearButtonModeAlwaysKey = @"always";

NSString * const kTKESCKeyboardTypeDefaultKey = @"default";
NSString * const kTKESCKeyboardTypeAsciiCapableKey = @"asciiCapable";
NSString * const kTKESCKeyboardTypeNumbersAndPunctuationKey = @"numbersAndPunctuation";
NSString * const kTKESCKeyboardTypeUrlKey = @"url";
NSString * const kTKESCKeyboardTypeNumberPadKey = @"numberPad";
NSString * const kTKESCKeyboardTypePhonePadKey = @"phonePad";
NSString * const kTKESCKeyboardTypeNamePhonePadKey = @"namePhonePad";
NSString * const kTKESCKeyboardTypeEmailAddressKey = @"emailAddress";

@interface RCSEditStringCell ()
@property (nonatomic, readwrite, retain) UITextField *editStringTextField;
@end

@implementation RCSEditStringCell

@synthesize editStringTextField=_editStringTextField;

- (id) initWithStyle: (UITableViewCellStyle)style reuseIdentifier: (NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        // Initialization code
		_editStringTextField = [[UITextField alloc] initWithFrame: CGRectZero];
		[_editStringTextField setDelegate: self];
		[_editStringTextField setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		for (UIView *view in [[self contentView] subviews]) {
			[view removeFromSuperview];
		}
		[[self contentView] addSubview: _editStringTextField];
    }
    return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[_editStringTextField setDelegate: nil];
	[_editStringTextField release]; _editStringTextField = nil;
    [super dealloc];
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	CGRect boundsFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
	CGRect textFieldFrame = CGRectInset(boundsFrame, 10.0, 5.0);
	textFieldFrame.origin.y += 2.0;
	[_editStringTextField setFrame: textFieldFrame];
}

- (BOOL) supportsText { return NO; }
- (BOOL) supportsDetailText { return NO; }
- (BOOL) supportsAccessories { return NO; }
- (BOOL) supportsImages { return NO; }

- (void) setRow: (RCSTableRow *)newRow
{
	[super setRow: newRow];
	if (newRow) {
		[[NSNotificationCenter defaultCenter] addObserver: self
												 selector: @selector(viewWillDisappear:)
													 name: kTKViewWillDisappearNotificationName
												   object: [newRow controller]];
		[_editStringTextField setFont: [UIFont boldSystemFontOfSize: 24.0]];
		[_editStringTextField setAdjustsFontSizeToFitWidth: YES];
		[_editStringTextField setMinimumFontSize: 16.0];
		[_editStringTextField setText: [[newRow object] valueForKeyPath: [newRow stringForDictionaryKey: kTKESCAttributeKey]]];
		NSString *autocapitalizationTypeString = [newRow stringForDictionaryKey: kTKESCAutocapitalizationTypeKey];
		if (autocapitalizationTypeString) {
			if ([kTKESCAutocapitalizationTypeWordsKey isEqualToString: autocapitalizationTypeString]) {
				[_editStringTextField setAutocapitalizationType: UITextAutocapitalizationTypeWords];
			} else if ([kTKESCAutocapitalizationTypeSentencesKey isEqualToString: autocapitalizationTypeString]) {
				[_editStringTextField setAutocapitalizationType: UITextAutocapitalizationTypeSentences];
			} else if ([kTKESCAutocapitalizationTypeAllCharactersKey isEqualToString: autocapitalizationTypeString]) {
				[_editStringTextField setAutocapitalizationType: UITextAutocapitalizationTypeAllCharacters];
			}
		}
		NSString *autocorrectionTypeString = [newRow stringForDictionaryKey: kTKESCAutocorrectionTypeKey];
		if (autocorrectionTypeString) {
			if ([kTKESCAutocorrectionTypeYesKey isEqualToString: autocorrectionTypeString]) {
				[_editStringTextField setAutocorrectionType: UITextAutocorrectionTypeYes];
			} else if ([kTKESCAutocorrectionTypeNoKey isEqualToString: autocorrectionTypeString]) {
				[_editStringTextField setAutocorrectionType: UITextAutocorrectionTypeNo];
			}
		}
		NSString *clearButtonMode = [newRow stringForDictionaryKey: kTKESCClearButtonModeKey];
		if (clearButtonMode) {
			if ([kTKESCClearButtonModeWhileEditingKey isEqualToString: clearButtonMode]) {
				[_editStringTextField setClearButtonMode: UITextFieldViewModeWhileEditing];
			} else if ([kTKESCClearButtonModeUnlessEditingKey isEqualToString: clearButtonMode]) {
				[_editStringTextField setClearButtonMode: UITextFieldViewModeUnlessEditing];
			} else if ([kTKESCClearButtonModeAlwaysKey isEqualToString: clearButtonMode]) {
				[_editStringTextField setClearButtonMode: UITextFieldViewModeAlways];
			}
		}
		NSString *staticPlaceholder = [newRow stringForDictionaryKey: kTKESCStaticPlaceholderKey];
		if (staticPlaceholder) {
			[_editStringTextField setPlaceholder: staticPlaceholder];
		} else {
			NSString *placeholder = [newRow stringForDictionaryKey: kTKESCPlaceholderKey];
			if (placeholder) {
				[_editStringTextField setPlaceholder: [[newRow object] valueForKeyPath: placeholder]];
			}
		}
		NSString *keyboardType = [newRow stringForDictionaryKey: kTKESCStaticKeyboardTypeKey];
		if (keyboardType == nil) {
			keyboardType = [newRow stringForDictionaryKey: kTKESCKeyboardTypeKey];
			if (keyboardType) {
				keyboardType = [[newRow object] valueForKeyPath: keyboardType];
			}
		}
		if (keyboardType) {
			if ([kTKESCKeyboardTypeDefaultKey isEqualToString: keyboardType]) {
				[_editStringTextField setKeyboardType: UIKeyboardTypeDefault];
			} else if ([kTKESCKeyboardTypeAsciiCapableKey isEqualToString: keyboardType]) {
				[_editStringTextField setKeyboardType: UIKeyboardTypeASCIICapable];
			} else if ([kTKESCKeyboardTypeNumbersAndPunctuationKey isEqualToString: keyboardType]) {
				[_editStringTextField setKeyboardType: UIKeyboardTypeNumbersAndPunctuation];
			} else if ([kTKESCKeyboardTypeUrlKey isEqualToString: keyboardType]) {
				[_editStringTextField setKeyboardType: UIKeyboardTypeURL];
			} else if ([kTKESCKeyboardTypeNumberPadKey isEqualToString: keyboardType]) {
				[_editStringTextField setKeyboardType: UIKeyboardTypeNumberPad];
			} else if ([kTKESCKeyboardTypePhonePadKey isEqualToString: keyboardType]) {
				[_editStringTextField setKeyboardType: UIKeyboardTypePhonePad];
			} else if ([kTKESCKeyboardTypeNamePhonePadKey isEqualToString: keyboardType]) {
				[_editStringTextField setKeyboardType: UIKeyboardTypeNamePhonePad];
			} else if ([kTKESCKeyboardTypeEmailAddressKey isEqualToString: keyboardType]) {
				[_editStringTextField setKeyboardType: UIKeyboardTypeEmailAddress];
			}
		}
	}
}

- (void) removeFromSuperview
{
	[[[self row] object] setValue: [_editStringTextField text]
					   forKeyPath: [[self row] stringForDictionaryKey: kTKESCAttributeKey]];
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: kTKViewWillDisappearNotificationName
												  object: nil];
	[super removeFromSuperview];
}

- (BOOL) becomeFirstResponder
{
	[super becomeFirstResponder];
	return [_editStringTextField becomeFirstResponder];
}

- (BOOL) resignFirstResponder
{
	[super resignFirstResponder];
	[[[self row] object] setValue: [_editStringTextField text]
					   forKeyPath: [[self row] stringForDictionaryKey: kTKESCAttributeKey]];
	return [_editStringTextField resignFirstResponder];
}

#pragma mark -
#pragma mark RCSTableViewController notifications

- (void) viewWillDisappear: (NSNotification *)notification
{
	[[[self row] object] setValue: [_editStringTextField text]
					   forKeyPath: [[self row] stringForDictionaryKey: kTKESCAttributeKey]];
}

#pragma mark -
#pragma mark Text Field Delegate methods

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing: YES called
- (void) textFieldDidEndEditing: (UITextField *)textField
{
	[[[self row] object] setValue: [_editStringTextField text]
					   forKeyPath: [[self row] stringForDictionaryKey: kTKESCAttributeKey]];
}

- (BOOL) textFieldShouldReturn: (UITextField *)textField
{
	[self endEditing: NO];
	return NO;
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
