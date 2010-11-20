//
//  iTriosAppDelegate.h
//  iTrios
//
//  Created by Guy Van Overtveldt on 20/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iTriosViewController;

@interface iTriosAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iTriosViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iTriosViewController *viewController;

@end

