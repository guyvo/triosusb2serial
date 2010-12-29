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
	
	NSNotificationCenter * notifyLoadPreset;
	NSNotificationCenter * notifySavePreset;
	
}

// properties not multithreade and retained after assign
@property (nonatomic,retain) LightIndicatorView * _lightIndicator;
@property (nonatomic,retain) LightView * _lightView;
@property (nonatomic,retain) UtilityView * _utililtyView;
@property (nonatomic,retain) NSMutableArray * _indicatorViews;
@property (nonatomic,retain) NSMutableArray * _utilityViews;


-(void) saveIndicatorsToFile:(NSString*) fileName;

+(void) loadFromFileWithPresetNumber:(NSInteger) preset;
+(void) savetoFileWithPresetNumber:(NSInteger) preset;

@end

