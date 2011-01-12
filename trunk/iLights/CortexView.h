//
//  CortexView.h
//  iLights
//
//  Created by Guy Van Overtveldt on 12/01/11.
//  Copyright 2011 ATOS worldline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "triosIncludes.h"

@interface CortexView : UIView {
	
	NSInteger _index;
	CGFloat _x,_y;
	
	UILabel * _temperature;
	UILabel * _dimCount;
	UILabel * _toggleCount;
	UILabel * _hoursRun;
	UILabel * _watchdogCount;

}

-(id) initWithX:(CGFloat) x andWithY:(CGFloat) y andWithIndex:(NSInteger)index;

@end
