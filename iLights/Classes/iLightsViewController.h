//
//  iLightsViewController.h
//  iLights
//
//  Created by guy on 27/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TriosModel.h"
#import "iLightsTriosWrapper.h"
#import "LightIndicator.h"
#import "ButtonUtilities.h"

#define RASTER_SIZE		137
#define RASTER_ROWS		5
#define RASTER_COLS		5
#define RASTER_SPACING	10

@interface iLightsViewController : UIViewController {
	CGPoint centerPoints[25];
	NSMutableArray * _indicatorViews;
	NSMutableArray * _buttonUtilitiesViews;
	LightIndicator * _lightIndicator;
	ButtonUtilities * _buttonUtilities;
	
}



@end

