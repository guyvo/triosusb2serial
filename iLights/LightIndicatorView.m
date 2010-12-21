//
//  LightIndicator.m
//  3Dlayer
//
//  Created by Guy Van Overtveldt on 15/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LightIndicatorView.h"

// private defines
#define FONT_SIZE 13

// private method declarations
@interface LightIndicatorView()

@end

// implementation of a subclassed UIView 
@implementation LightIndicatorView

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


//implementing NSCoding protocol to serialize to file
-(void) encodeWithCoder: (NSCoder*) coder {
	
	[coder encodeCGRect:self.frame forKey:@"_frame"];

	[coder encodeInteger: 1 forKey: @"_version"];
	[coder encodeInteger: _maximum forKey: @"_maximum"];
	[coder encodeInteger: _minimum forKey: @"_minimum"];
	[coder encodeInteger: _value forKey: @"_value"];
	[coder encodeInteger: _index forKey: @"_index"];
	[coder encodeInteger: _theTag forKey:@"_tag"];
	
	[coder encodeObject:(id)_name forKey: @"_name"];
}

-(id) initWithCoder: (NSCoder*) coder {
	CGRect theFrame;
	
	theFrame = [coder decodeCGRectForKey:@"_frame"];
	
	_version = [coder decodeIntegerForKey:@"_version"];
	_maximum = [coder decodeIntegerForKey:@"_maximum"];
	_minimum = [coder decodeIntegerForKey:@"_minimum"];
	_value = [coder decodeIntegerForKey:@"_value"];
	_index = [coder decodeIntegerForKey:@"_index"];
	
	_name = [coder decodeObjectForKey:@"_name"];
	_theTag = [coder decodeIntegerForKey:@"_tag"];
	
	
	return ([[LightIndicatorView alloc] initWithMinimum:_minimum 
											 andMaximum:_maximum
											   andIndex:_index 
											   andValue:_value
												andName:_name
												 andTag:_theTag
											   andFrame:theFrame]);
	
}

// overwrite init method
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
	if (self) {
		
		self.backgroundColor = [UIColor blackColor];
		self.layer.borderColor =[[UIColor redColor]CGColor];
		self.layer.cornerRadius = 30;
		self.layer.borderWidth = 2;
		self.tag = _theTag;
				
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
		
		UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc]
													initWithTarget:self action:@selector(handleSingleDoubleTap:)];
		UITapGestureRecognizer *singleFingerSTap = [[UITapGestureRecognizer alloc]
													initWithTarget:self action:@selector(handleSingleTap:)];
		
		singleFingerDTap.numberOfTapsRequired = 2;
		singleFingerSTap.numberOfTapsRequired = 1;
		
		[singleFingerSTap requireGestureRecognizerToFail:singleFingerDTap];

		[singleFingerSTap setDelaysTouchesBegan:YES];
		[singleFingerDTap setDelaysTouchesBegan:YES];
		
		
		[self addGestureRecognizer:singleFingerSTap];
		[self addGestureRecognizer:singleFingerDTap];
		
		
		[singleFingerSTap release];
		[singleFingerDTap release];
		
		return self;
		
    }
	else {
		
		return nil;
	}
}

- (IBAction)handleSingleTap:(UIGestureRecognizer *)sender {
	if ( self._value == 0 ){
		self._value = 100;
		gTriosLights[self._index].lights.value = 100;
	}
	else if ( self._value == 100 ){
		self._value = 0;
		gTriosLights[self._index].lights.value = 0;
	}
	else {
		self._value = 0;
		gTriosLights[self._index].lights.value = 0;
	}
	
	[self setNeedsDisplay];
	[iLightsTriosWrapper TriosSendPostBuffer];
	
}


- (IBAction)handleSingleDoubleTap:(UIGestureRecognizer *)sender {
	LightView * v;

	for( UIView * view in self.superview.subviews){
		[view setUserInteractionEnabled:NO];
	}
	
	v = [[LightView alloc] initWithFrame:CGRectMake(0, 0, 5 , 5)];
	v.center = [sender locationInView:self.superview];
	v.alpha = 0.7;
	v.tag = 50;
	
	[self.superview addSubview:v];
	
	[UIView 
	 animateWithDuration:1 
	 animations:^{
		 
		 v.frame = CGRectMake(0,0, 500 , 500);
		 v.center= CGPointMake(512, 368);
		
	 }
	 completion:^(BOOL finished){
	 }];
	
	
}

// customized init method calling overwrite init at the end
- (id)initWithMinimum:(NSInteger)minimum 
		   andMaximum:(NSInteger)maximum 
			 andIndex:(NSInteger)index 
			 andValue:(NSInteger)value 
			  andName:(NSString *)name
			   andTag:(NSInteger)theTag
			 andFrame:(CGRect)frame
{
	
	_maximum	= maximum;
	_minimum	= minimum;
	_index		= index;
	_name		= name;
	_value		= value;
	_theTag		= theTag;
	
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
	
	//ensure that label is updated when refreshing
	_textValue.text = [NSString stringWithFormat:@"%d%@",_value,@"%"];

}

// release resources
- (void)dealloc {
	[_name release];
	[_textValue release];
	[_textDesciption release];
    [super dealloc];
}

@end
