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
	UtilityViewCortex * _utilityViewCortex;
	UtilityViewSetup * _utilityViewSetup;
	UtilityViewFree1 * _utilityViewFree1;
	UtilityViewFree2 * _utilityViewFree2;
	UtilityViewAllOff * _utilityViewAllOff;
	
	// collections of views
	NSMutableArray * _indicatorViews;
	
	NSNotificationCenter * notifyLoadPreset;
	NSNotificationCenter * notifySavePreset;
	
}

// properties not multithreaded and retained after assign
@property (nonatomic,retain) LightIndicatorView * _lightIndicator;
@property (nonatomic,retain) LightView * _lightView;
@property (nonatomic,retain) UtilityViewCortex * _utilityViewCortex;
@property (nonatomic,retain) UtilityViewSetup * _utilityViewSetup;
@property (nonatomic,retain) UtilityViewFree1 * _utilityViewFree1;
@property (nonatomic,retain) UtilityViewFree2 * _utilityViewFree2;
@property (nonatomic,retain) UtilityViewAllOff * _utilityViewAllOff;
@property (nonatomic,retain) NSMutableArray * _indicatorViews;


-(void) saveIndicatorsToFile:(NSString*) fileName;

+(void) loadFromFileWithPresetNumber:(NSInteger) preset;
+(void) savetoFileWithPresetNumber:(NSInteger) preset;

@end

