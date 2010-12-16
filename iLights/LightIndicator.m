//
//  LightIndicator.m
//  3Dlayer
//
//  Created by Guy Van Overtveldt on 15/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LightIndicator.h"


@implementation LightIndicator


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.backgroundColor = [UIColor blackColor];
		self.layer.borderColor =[[UIColor lightTextColor]CGColor];
		self.layer.cornerRadius = 10;
		self.layer.borderWidth = 1;
		
		text = [[UILabel alloc]initWithFrame:CGRectMake(5, 85, 95, 15)];
		text.text = @"1234567890";
		text.backgroundColor = [UIColor blackColor];
		text.textColor = [UIColor lightTextColor];
		text.adjustsFontSizeToFitWidth = YES;
		text.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		text.textAlignment =  UITextAlignmentCenter;
		text.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:10];
		
		[self addSubview:text];
		
		
		val = [[UILabel alloc]initWithFrame:CGRectMake(75, 40, 25, 15)];
		val.text = @"0%";
		val.backgroundColor = [UIColor blackColor];
		val.textColor = [UIColor lightTextColor];
		val.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		val.adjustsFontSizeToFitWidth = YES;
		val.textAlignment =  UITextAlignmentCenter;
		val.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:10];
		
		[self addSubview:val];
		
		 
    }
    return self;
}

- (id)initWithMinimum:(NSInteger)minimum andMaximum:(NSInteger)maximum andIndex:(NSInteger)index andValue:(NSInteger) value andName:(NSString *) name andFrame:(CGRect)frame{
	_maximum = maximum;
	_minimum = minimum;
	_index = index;
	_name = name;
	_value = value;
	return [self initWithFrame:frame];
}

- (void)drawRect:(CGRect)rect {
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGGradientRef myGradient;
	CGColorSpaceRef myColorSpace;
	
	size_t locationCount = 2;
	
	CGFloat locationList[] = {0.1, 1.0};
	
	CGFloat colorList[] = {
		0.0, 0.0, 0.0, 0.7, //red, green, blue, alpha
		1.0, 1.0, 0.0, 1.0,
	};
	
	myColorSpace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents(myColorSpace, colorList, locationList, locationCount);
	
	CGPoint startPoint, endPoint;
	startPoint.x = 10;
	startPoint.y = 10;
	endPoint.x = CGRectGetMaxX(self.bounds)/2-10;
	endPoint.y = CGRectGetMaxY(self.bounds)/2;
	
	float startRadius = 0;
	float endRadius = CGRectGetMaxY(self.bounds)/2-20;
	
	CGContextDrawRadialGradient(context, myGradient, startPoint, startRadius, endPoint, endRadius, 0);
	CGGradientRelease(myGradient);
	
	
}

- (void)dealloc {
    [super dealloc];
}


@end
