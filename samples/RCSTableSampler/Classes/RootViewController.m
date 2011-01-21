//
//  RootViewController.m
//  RCSTableSampler
//
//  Created by Jim Roepcke on 09-12-22.
//  Copyright Roepcke Computing Solutions 2009. All rights reserved.
//

#import "RootViewController.h"
#import "RCSTableKit.h"

@implementation RootViewController

- (NSString *) text: (RCSTableRow *)row
{
	return [row.indexPath description];
}

- (UIColor *) subBackgroundColor
{
	return [UIColor cyanColor];
}

@end

