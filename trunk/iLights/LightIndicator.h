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
	
	UILabel * _textDesciption;
	UILabel * _textValue;
	
}

// properties
@property (nonatomic,retain) UILabel * _textDesciption;
@property (nonatomic,retain) UILabel * _textValue;
@property (nonatomic,retain) NSString * _name;

@property (nonatomic) NSInteger _value;
@property (nonatomic) NSInteger _index;
@property (nonatomic) NSInteger _minimum;
@property (nonatomic) NSInteger _maximum;

// instance methodes
- (id)initWithMinimum:(NSInteger)minimum
		   andMaximum:(NSInteger)maximum  
			 andIndex:(NSInteger)index 
			 andValue:(NSInteger)value 
			  andName:(NSString *)name 
			 andFrame:(CGRect) frame;

- (void) setFrameCenter:(CGPoint) center;

// class methodes

@end
