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
	IBOutlet UIView * otherView;
	IBOutlet UIImageView * trios;
	IBOutlet UIButton * button;
	IBOutlet UIButton * buttonback;

}

@property (nonatomic,retain) UIActivityIndicatorView * active;
@property (nonatomic,retain) UIView * otherView;
@property (nonatomic,retain) UIImageView * trios;
@property (nonatomic,retain) UIButton * button;
@property (nonatomic,retain) UIButton * buttonBack;

- (IBAction) switchViews:(id)sender;
- (IBAction) switchBack:(id)sender;
- (IBAction) switchBack2:(id)sender;

@end

