//
//  RCSTableKitConstants.m
//  Created by Jim Roepcke.
//  See license below.
//

// view controller
NSString * const kTKViewWillDisappearNotificationName = @"RCSTableViewControllerViewWillDisappear";
NSString * const kTKAllowsSelectionDuringEditingKey = @"allowsSelectionDuringEditing";
NSString * const kTKAllowsSelectionKey = @"allowsSelection";
NSString * const kTKIsEditableKey = @"isEditable";

// table view cell
NSString * const kTKRowKey = @"row"; // KVO property key

// table definition
NSString * const kTKNibKey = @"nib";
NSString * const kTKNibBundleKey = @"nibBundle";
NSString * const kTKControllerClassKey = @"controllerClass";
NSString * const kTKDisplaySectionsKey = @"displaySections";
NSString * const kTKTableHeaderImagePath = @"tableHeaderImagePath";
NSString * const kTKTableHeaderImagePathSelector = @"tableHeaderImagePathSelector";
NSString * const kTKSectionsKey = @"sections";

// table definition and table section definition
NSString * const kTKStaticTitleKey = @"staticTitle";
NSString * const kTKTitleKey = @"title";

// table section definition
NSString * const kTKDisplayRowsKey = @"displayRows";
NSString * const kTKRowsKey = @"rows";

// table section definition and table row definition
NSString * const kTKListKey = @"list";
NSString * const kTKObjectKey = @"object";
NSString * const kTKPredicateKey = @"predicate";

// table row definition
NSString * const kTKStaticCellKey = @"staticCell";
NSString * const kTKCellKey = @"cell";
NSString * const kTKCellSelectorKey = @"cellSelector";
NSString * const kTKCellNibKey = @"cellNib";
NSString * const kTKEditingStyleKey = @"editingStyle";
NSString * const kTKEditPushConfigurationKey = @"editPushConfiguration";
NSString * const kTKViewPushConfigurationKey = @"viewPushConfiguration";
NSString * const kTKPushConfigurationKey = @"pushConfiguration";
NSString * const kTKAccessoryPushConfigurationKey = @"accessoryPushConfiguration";
NSString * const kTKEditAccessoryPushConfigurationKey = @"editAccessoryPushConfiguration";
NSString * const kTKViewAccessoryPushConfigurationKey = @"viewAccessoryPushConfiguration";
NSString * const kTKBecomeFirstResponderKey = @"becomeFirstResponder";
NSString * const kTKEditingStyleActionKey = @"editingStyleAction";
NSString * const kTKEditingStylePushConfigurationKey = @"editingStylePushConfiguration";
NSString * const kTKEditActionKey = @"editAction";
NSString * const kTKViewActionKey = @"viewAction";
NSString * const kTKActionKey = @"action";
NSString * const kTKEditAccessoryActionKey = @"editAccessoryAction";
NSString * const kTKViewAccessoryActionKey = @"viewAccessoryAction";
NSString * const kTKAccessoryActionKey = @"accessoryAction";
NSString * const kTKRowHeightKey = @"rowHeight";
NSString * const kTKBackgroundColorKey = @"backgroundColor";
NSString * const kTKBackgroundColorSelectorKey = @"backgroundColorSelector";
NSString * const kTKStaticTextKey = @"staticText";
NSString * const kTKTextKey = @"text";
NSString * const kTKTextSelectorKey = @"textSelector";
NSString * const kTKStaticDetailTextKey = @"staticDetailText";
NSString * const kTKDetailTextKey = @"detailText";
NSString * const kTKDetailTextSelectorKey = @"detailTextSelector";
NSString * const kTKStaticImageKey = @"staticImage";
NSString * const kTKImageKey = @"image";
NSString * const kTKImageSelectorKey = @"imageSelector";
NSString * const kTKStaticEditingAccessoryTypeKey = @"staticEditingAccessoryType";
NSString * const kTKEditingAccessoryTypeKey = @"editingAccessoryType";
NSString * const kTKEditingAccessoryTypeSelectorKey = @"editingAccessoryTypeSelector";
NSString * const kTKStaticAccessoryTypeKey = @"staticAccessoryType";
NSString * const kTKAccessoryTypeKey = @"accessoryType";
NSString * const kTKAccessoryTypeSelectorKey = @"accessoryTypeSelector";
NSString * const kTKStaticCellStyleKey = @"staticCellStyle";
NSString * const kTKCellStyleKey = @"cellStyle";
NSString * const kTKCellStyleSelectorKey = @"cellStyleSelector";

NSString * const kTKEditingStyleInsertKey = @"insert";
NSString * const kTKEditingStyleDeleteKey = @"delete";

NSString * const kTKAccessoryTypeDisclosureIndicatorKey = @"disclosureIndicator";
NSString * const kTKAccessoryTypeDetailDisclosureIndicatorKey = @"detailDisclosureIndicator";
NSString * const kTKAccessoryTypeCheckmarkKey = @"checkmark";

NSString * const kTKCellStyleValue1Key = @"value1";
NSString * const kTKCellStyleValue2Key = @"value2";
NSString * const kTKCellStyleSubtitleKey = @"subtitle";

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
