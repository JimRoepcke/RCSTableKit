//
//  RCSTableSamplerAppDelegate.m
//  RCSTableSampler
//
//  Created by Jim Roepcke on 09-12-22.
//  Copyright Roepcke Computing Solutions 2009. All rights reserved.
//

#import "RCSTableSamplerAppDelegate.h"
#import "RootViewController.h"
#import "RCSTableKit.h"

@implementation RCSTableSamplerAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (void) applicationDidFinishLaunching: (UIApplication *)application
{
	RCSTableDefinition *def = [RCSTableDefinition tableDefinitionNamed: @"Root" inBundle: nil];
	UIViewController *c = [def viewControllerWithRootObject: nil];
	[self.navigationController pushViewController: c animated: NO];

	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}

#pragma mark -
#pragma mark Memory management


@end
