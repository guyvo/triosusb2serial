//
//  LightIndicator.h
//  3Dlayer
//
//  Created by Guy Van Overtveldt on 15/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface LightIndicator : UIView {
	NSInteger _maximum;
	NSInteger _minimum;
	NSInteger _index;
	NSInteger _value;
	NSString * _name;
	UILabel * text;
	UILabel * val;
	
}

- (id)initWithMinimum:(NSInteger) minimum andMaximum:(NSInteger)maximum  andIndex:(NSInteger) index andValue:(NSInteger) value andName:(NSString *) name andFrame:(CGRect) frame;

@end
