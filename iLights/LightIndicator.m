//
//  LightIndicator.m
//  3Dlayer
//
//  Created by Guy Van Overtveldt on 15/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LightIndicator.h"

// private defines
#define FONT_SIZE 13

// private method declarations
@interface LightIndicator()

@end

// implementation of a subclassed UIView 
@implementation LightIndicator

// setter/getter automation
@synthesize 
	_textDesciption,
	_textValue,
	_name,
	_value,
	_index,
	_minimum,
	_maximum
;

// overwrite init method
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
	if (self) {
		
		self.backgroundColor = [UIColor blackColor];
		self.layer.borderColor =[[UIColor redColor]CGColor];
		self.layer.cornerRadius = 30;
		self.layer.borderWidth = 1;
				
		_textDesciption = [[UILabel alloc]initWithFrame:CGRectMake(5, (self.bounds.size.height - 15.0), (self.bounds.size.width - 5.0), 15)];
		_textDesciption.text = _name;
		_textDesciption.backgroundColor = [UIColor blackColor];
		_textDesciption.textColor = [UIColor redColor];
		_textDesciption.adjustsFontSizeToFitWidth = YES;
		_textDesciption.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_textDesciption.textAlignment =  UITextAlignmentCenter;
		_textDesciption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE];
		
		[self addSubview:_textDesciption];
		
		_textValue = [[UILabel alloc]initWithFrame:CGRectMake((self.bounds.size.width - 35), 20, 30 , 15)];
		_textValue.text = [NSString stringWithFormat:@"%d%@",_value,@"%"];
		_textValue.backgroundColor = [UIColor blackColor];
		_textValue.textColor = [UIColor redColor];
		_textValue.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_textValue.adjustsFontSizeToFitWidth = YES;
		_textValue.textAlignment =  UITextAlignmentCenter;
		_textValue.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE];
		
		[self addSubview:_textValue];
	 
		return self;
		
    }
	else {
		
		return nil;
	}
}

// customized init method calling overwrite init at the end
- (id)initWithMinimum:(NSInteger)minimum 
		   andMaximum:(NSInteger)maximum 
			 andIndex:(NSInteger)index 
			 andValue:(NSInteger)value 
			  andName:(NSString *)name
			 andFrame:(CGRect)frame
{
	
	_maximum	= maximum;
	_minimum	= minimum;
	_index		= index;
	_name		= name;
	_value		= value;
	
	return [self initWithFrame:frame];
}

// alter the center of this view
- (void) setFrameCenter:(CGPoint) center{
	self.center = center;
}

// overwrite parent class to change draw behaviour
- (void)drawRect:(CGRect)rect {
    
	// create so release ref
	CGGradientRef myGradient;
	CGColorSpaceRef myColorSpace;
	
	// no create no release
	CGContextRef context;

	size_t locationCount;
	
	CGPoint startPoint;
	CGPoint endPoint;

	CGFloat startRadius;
	CGFloat endRadius;

	CGFloat locationList[2];

	CGFloat colorList[] = {
		0.0, 0.1, 0.1, 0.95,
		0.85, 0.85, 0.0, 1.0,
	};
	
	context = UIGraphicsGetCurrentContext();
	
	locationCount = 2;
	
	locationList[0] = (100 - _value)/100.0;
	locationList[1] = 1.0;
	
	myColorSpace	= CGColorSpaceCreateDeviceRGB();
	myGradient		= CGGradientCreateWithColorComponents(myColorSpace, colorList, locationList, locationCount);
	
	startPoint.x	= 10;
	startPoint.y	= 10;
	
	endPoint.x		= CGRectGetMaxX(self.bounds)/2;
	endPoint.y		= CGRectGetMaxY(self.bounds)/2+5;
	
	startRadius		= 0;
	endRadius		= CGRectGetMaxY(self.bounds)/2-20;
	
	CGContextDrawRadialGradient(context, myGradient, startPoint, startRadius, endPoint, endRadius, 0);
	
	CGGradientRelease(myGradient);
	CGColorSpaceRelease(myColorSpace);

}

// release resources
- (void)dealloc {
	[_name release];
	[_textValue release];
	[_textDesciption release];
    [super dealloc];
}

@end
