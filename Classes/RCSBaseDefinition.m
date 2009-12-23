//
//  RCSBaseDefinition.m
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSBaseDefinition.h"


@implementation RCSBaseDefinition

#pragma mark -
#pragma mark Configuration methods

- (BOOL) boolForKey: (id)key_ withDefault: (BOOL)value inDictionary: (NSDictionary *)dict
{
	NSNumber *num = [dict objectForKey:key_];
	return num == nil ? value : [num boolValue];
}

- (NSInteger) integerForKey: (id)key_ withDefault: (NSInteger)value inDictionary: (NSDictionary *)dict
{
	NSNumber *num = [dict objectForKey:key_];
	return num == nil ? value : [num integerValue];
}

- (double) doubleForKey: (id)key_ withDefault: (double)value inDictionary: (NSDictionary *)dict
{
	NSNumber *num = [dict objectForKey:key_];
	return num == nil ? value : [num doubleValue];
}

- (float) floatForKey: (id)key_ withDefault: (float)value inDictionary: (NSDictionary *)dict
{
	NSNumber *num = [dict objectForKey:key_];
	return num == nil ? value : [num floatValue];
}

- (NSString *) stringForKey: (id)key_ withDefault: (NSString *)value inDictionary: (NSDictionary *)dict
{
	NSString *s = [dict objectForKey:key_];
	return s == nil ? value : s;
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
