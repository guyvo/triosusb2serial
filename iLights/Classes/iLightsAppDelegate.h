//
//  iLightsAppDelegate.h
//  iLights
//
//  Created by guy on 27/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iLightsViewController;

@interface iLightsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iLightsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iLightsViewController *viewController;

@end

