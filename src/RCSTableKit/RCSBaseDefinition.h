//
//  RCSBaseDefinition.h
//  Created by Jim Roepcke.
//  See license below.
//

@interface RCSBaseDefinition : NSObject

#pragma mark -
#pragma mark Configuration methods

- (BOOL)         boolForKey: (id)key_ withDefault: (BOOL)value       inDictionary: (NSDictionary *)dict;
- (NSInteger) integerForKey: (id)key_ withDefault: (NSInteger)value  inDictionary: (NSDictionary *)dict;
- (float)       floatForKey: (id)key_ withDefault: (float)value      inDictionary: (NSDictionary *)dict;
- (double)     doubleForKey: (id)key_ withDefault: (double)value     inDictionary: (NSDictionary *)dict;
- (NSString *) stringForKey: (id)key_ withDefault: (NSString *)value inDictionary: (NSDictionary *)dict;

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
