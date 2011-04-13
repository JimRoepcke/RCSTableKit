//
//  RCSEditStringCell.h
//  Created by Jim Roepcke.
//  See license below.
//

extern NSString * const kTKESCAttributeKey;
extern NSString * const kTKESCAutocapitalizationTypeKey;
extern NSString * const kTKESCAutocorrectionTypeKey;
extern NSString * const kTKESCClearButtonModeKey;
extern NSString * const kTKESCStaticPlaceholderKey;
extern NSString * const kTKESCPlaceholderKey;
extern NSString * const kTKESCStaticKeyboardTypeKey;
extern NSString * const kTKESCKeyboardTypeKey;

extern NSString * const kTKESCAutocapitalizationTypeWordsKey;
extern NSString * const kTKESCAutocapitalizationTypeSentencesKey;
extern NSString * const kTKESCAutocapitalizationTypeAllCharactersKey;

extern NSString * const kTKESCAutocorrectionTypeYesKey;
extern NSString * const kTKESCAutocorrectionTypeNoKey;

extern NSString * const kTKESCClearButtonModeWhileEditingKey;
extern NSString * const kTKESCClearButtonModeUnlessEditingKey;
extern NSString * const kTKESCClearButtonModeAlwaysKey;

extern NSString * const kTKESCKeyboardTypeDefaultKey;
extern NSString * const kTKESCKeyboardTypeAsciiCapableKey;
extern NSString * const kTKESCKeyboardTypeNumbersAndPunctuationKey;
extern NSString * const kTKESCKeyboardTypeUrlKey;
extern NSString * const kTKESCKeyboardTypeNumberPadKey;
extern NSString * const kTKESCKeyboardTypePhonePadKey;
extern NSString * const kTKESCKeyboardTypeNamePhonePadKey;
extern NSString * const kTKESCKeyboardTypeEmailAddressKey;

@interface RCSEditStringCell : RCSTableViewCell <UITextFieldDelegate>
{
	UITextField *_editStringTextField;
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
