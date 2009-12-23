//
//  RCSTableUIViewControllerAdditions.m
//  Created by Jim Roepcke.
//  See license below.
//

#import "RCSTableUIViewControllerAdditions.h"
#import "RCSTableViewController.h"

@implementation UIViewController (RCSTableUIViewControllerAdditions)

+ (NSDictionary *) configurationNamed: (NSString *)name
{
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
	return [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
}

- (BOOL) boolForKey: (id)key withDefault: (BOOL)value inDictionary: (NSDictionary *)dict
{
	NSNumber *num = [dict objectForKey:key];
	return num == nil ? value : [num boolValue];
}

- (NSInteger) integerForKey: (id)key withDefault: (NSInteger)value inDictionary: (NSDictionary *)dict
{
	NSNumber *num = [dict objectForKey:key];
	return num == nil ? value : [num integerValue];
}

- (NSString *) stringForKey: (id)key withDefault: (NSString *)value inDictionary: (NSDictionary *)dict
{
	NSString *s = [dict objectForKey:key];
	return s == nil ? value : s;
}

- (void) pushConfiguration: (NSString *)name withRootObject: (NSObject *)object
{
	[self.navigationController pushViewController: [self configuration: name withRootObject: object] animated: YES];
}

- (RCSTableViewController *) configuration: (NSString *)name withRootObject: (NSObject *)object
{
	NSDictionary *conf = [[self class] configurationNamed: name];
	Class defaultControllerClass = [self isKindOfClass: [RCSTableViewController class]] ? [self class] : [RCSTableViewController class];
	NSString *controllerClassName = [self stringForKey: @"controllerClassName" withDefault: NSStringFromClass(defaultControllerClass) inDictionary: conf];
	Class controllerClass = NSClassFromString(controllerClassName);
	RCSTableViewController *c = [[controllerClass alloc] initWithRootObject: (object == self ? nil : object) configuration: conf named: name];
	return [c autorelease];
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
