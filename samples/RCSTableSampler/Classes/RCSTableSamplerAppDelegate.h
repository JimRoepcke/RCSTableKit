//
//  RCSTableSamplerAppDelegate.h
//  RCSTableSampler
//
//  Created by Jim Roepcke on 09-12-22.
//  Copyright Roepcke Computing Solutions 2009. All rights reserved.
//

@interface RCSTableSamplerAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

