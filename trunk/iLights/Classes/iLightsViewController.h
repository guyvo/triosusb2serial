//
//  iLightsViewController.h
//  iLights
//
//  Created by guy on 27/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TriosModel.h"

@interface iLightsViewController : UIViewController {
	NSTimer * update;
	IBOutlet UIActivityIndicatorView * active;

}

@property (nonatomic,retain) UIActivityIndicatorView * active;

@end

