//
//  iLightsViewController.h
//  iLights
//
//  Created by guy on 27/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilityView.h"
#import "TriosModel.h"
#import "iLightsTriosWrapper.h"
#import "LightIndicatorView.h"
#import "LightView.h"

#define RASTER_SIZE		136
#define RASTER_ROWS		5
#define RASTER_COLS		5
#define RASTER_SPACING	10

@interface iLightsViewController : UIViewController {
	CGPoint centerPoints[25];
	UtilityView * _utililtyView;
	NSMutableArray * _indicatorViews;
	NSMutableArray * _utilityViews;
	LightIndicatorView * _lightIndicator;
	LightView * _lightView;
	
	
}



@end

