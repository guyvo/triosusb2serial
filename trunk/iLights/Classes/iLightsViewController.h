//
//  iLightsViewController.h
//  iLights
//
//  Created by guy on 27/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "triosIncludes.h"

@interface iLightsViewController : UIViewController {
	
	CGPoint centerPoints[25];
	
	// custom views
	LightIndicatorView * _lightIndicator;
	LightView * _lightView;
	UtilityView * _utililtyView;
	
	// collections of views
	NSMutableArray * _indicatorViews;
	NSMutableArray * _utilityViews;
	
}

-(void) saveIndicatorsToFile:(NSString*) fileName;

@end

