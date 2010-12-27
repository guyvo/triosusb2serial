//
//  LightView.m
//  iLights
//
//  Created by Guy Van Overtveldt on 27/11/10.
//  Copyright 2010 ATOS worldline. All rights reserved.
//

#import "LightView.h"


@implementation LightView
@synthesize 
_textDesciption,
_textValue,
_textMin,
_textMax,
_textStep,
_indexLight
;

- (UISlider*) createSlider:(CGPoint)point{
	
	UISlider * sliderValue = [[UISlider alloc] initWithFrame:CGRectMake(0,0,300,20)];
	sliderValue.transform = CGAffineTransformScale(sliderValue.transform,SLIDERS_SCALE, 1);
	sliderValue.center = point;
	sliderValue.transform = CGAffineTransformRotate(sliderValue.transform, 270.0/180*M_PI);
	sliderValue.minimumValue = 0.0;
	sliderValue.maximumValue = 100.0;
	sliderValue.continuous = YES;
	
	UIImage* thumbImage = [UIImage imageNamed:@"raster.png"];
	[sliderValue setThumbImage:thumbImage forState:UIControlStateNormal];
	[sliderValue setThumbImage:thumbImage forState:UIControlStateHighlighted];
	
	thumbImage = [UIImage imageNamed:@"yellow100x100.png"];
	[sliderValue setMinimumTrackImage:thumbImage forState:UIControlStateNormal]; 
	
	thumbImage = [UIImage imageNamed:@"grey.png"];
	[sliderValue setMaximumTrackImage:thumbImage forState:UIControlStateNormal];
	
	return sliderValue;
	
}

- (id) initWithIndex:(NSInteger)index andFrame:(CGRect)frame{
	_indexLight = index;
	return [self initWithFrame:frame];
	
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blackColor];
		self.layer.borderColor =[[UIColor redColor]CGColor];
		self.layer.cornerRadius = VIEW_CORNER_RADIUS;
		self.layer.borderWidth = VIEW_BORDER_THIKNESS;
		
		UISlider * sliderValue = [self createSlider:CGPointMake(SLIDERS_LEFT_POS, 250)];
		sliderValue.value = gTriosLights[_indexLight].lights.value;
		[sliderValue addTarget:(id)self action:@selector(handleSliderValue:) forControlEvents:UIControlEventValueChanged];

		UISlider * sliderMin = [self createSlider:CGPointMake(SLIDERS_LEFT_POS + SLIDERS_SPACING, 250)];
		sliderMin.value = gTriosLights[_indexLight].lights.minimum;
		[sliderMin addTarget:(id)self action:@selector(handleSliderMin:) forControlEvents:UIControlEventValueChanged];
		
		UISlider * sliderMax = [self createSlider:CGPointMake(SLIDERS_LEFT_POS + 2*SLIDERS_SPACING, 250)];
		sliderMax.value = gTriosLights[_indexLight].lights.maximum;
		[sliderMax addTarget:(id)self action:@selector(handleSliderMax:) forControlEvents:UIControlEventValueChanged];
		
		UISlider * sliderStep = [self createSlider:CGPointMake(SLIDERS_LEFT_POS + 3*SLIDERS_SPACING, 250)];
		sliderStep.value = gTriosLights[_indexLight].lights.step;
		[sliderStep addTarget:(id)self action:@selector(handleSliderStep:) forControlEvents:UIControlEventValueChanged];
		
		[self addSubview:sliderValue];
		[self addSubview:sliderMin];
		[self addSubview:sliderMax];
		[self addSubview:sliderStep];
		
		// retained by view
		[sliderValue release];
		[sliderMin release];
		[sliderMax release];
		[sliderStep release];
		
		// label value
		_textDesciption = [[UILabel alloc]initWithFrame:CGRectMake(SLIDERS_LEFT_POS-25, 425, 50 , 35)];
		_textDesciption.text = @"value";
		_textDesciption.backgroundColor = [UIColor blackColor];
		_textDesciption.textColor = [UIColor redColor];
		_textDesciption.adjustsFontSizeToFitWidth = YES;
		_textDesciption.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_textDesciption.textAlignment =  UITextAlignmentCenter;
		_textDesciption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE_SLIDERS];
		
		[self addSubview:_textDesciption];
		
		// label Min
		_textDesciption = [[UILabel alloc]initWithFrame:CGRectMake(SLIDERS_LEFT_POS + 1*SLIDERS_SPACING-25, 425, 50 , 35)];
		_textDesciption.text = @"min";
		_textDesciption.backgroundColor = [UIColor blackColor];
		_textDesciption.textColor = [UIColor redColor];
		_textDesciption.adjustsFontSizeToFitWidth = YES;
		_textDesciption.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_textDesciption.textAlignment =  UITextAlignmentCenter;
		_textDesciption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE_SLIDERS];
		
		[self addSubview:_textDesciption];
		
		// label Max
		_textDesciption = [[UILabel alloc]initWithFrame:CGRectMake(SLIDERS_LEFT_POS + 2*SLIDERS_SPACING-25, 425, 50 , 35)];
		_textDesciption.text = @"max";
		_textDesciption.backgroundColor = [UIColor blackColor];
		_textDesciption.textColor = [UIColor redColor];
		_textDesciption.adjustsFontSizeToFitWidth = YES;
		_textDesciption.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_textDesciption.textAlignment =  UITextAlignmentCenter;
		_textDesciption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE_SLIDERS];
		
		[self addSubview:_textDesciption];
		
		// label Step
		_textDesciption = [[UILabel alloc]initWithFrame:CGRectMake(SLIDERS_LEFT_POS + 3*SLIDERS_SPACING-25, 425, 50 , 35)];
		_textDesciption.text = @"step";
		_textDesciption.backgroundColor = [UIColor blackColor];
		_textDesciption.textColor = [UIColor redColor];
		_textDesciption.adjustsFontSizeToFitWidth = YES;
		_textDesciption.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_textDesciption.textAlignment =  UITextAlignmentCenter;
		_textDesciption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE_SLIDERS];
		
		[self addSubview:_textDesciption];
		
		_textValue = [[UILabel alloc]initWithFrame:CGRectMake(SLIDERS_LEFT_POS-20, 40, 50 , 35)];
		_textValue.text = [NSString stringWithFormat:@"%d%@",gTriosLights[_indexLight].lights.value,@"%"];
		_textValue.backgroundColor = [UIColor blackColor];
		_textValue.textColor = [UIColor redColor];
		_textValue.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_textValue.adjustsFontSizeToFitWidth = YES;
		_textValue.textAlignment =  UITextAlignmentCenter;
		_textValue.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE_SLIDERS];
		
		[self addSubview:_textValue];
		
		_textMin = [[UILabel alloc]initWithFrame:CGRectMake(SLIDERS_LEFT_POS + SLIDERS_SPACING -20, 40, 50 , 35)];
		_textMin.text = [NSString stringWithFormat:@"%d%@",gTriosLights[_indexLight].lights.minimum,@"%"];
		_textMin.backgroundColor = [UIColor blackColor];
		_textMin.textColor = [UIColor redColor];
		_textMin.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_textMin.adjustsFontSizeToFitWidth = YES;
		_textMin.textAlignment =  UITextAlignmentCenter;
		_textMin.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE_SLIDERS];
		
		[self addSubview:_textMin];

		_textMax = [[UILabel alloc]initWithFrame:CGRectMake(SLIDERS_LEFT_POS + 2*SLIDERS_SPACING -20, 40, 50 , 35)];
		_textMax.text =[NSString stringWithFormat:@"%d%@",gTriosLights[_indexLight].lights.maximum,@"%"];
		_textMax.backgroundColor = [UIColor blackColor];
		_textMax.textColor = [UIColor redColor];
		_textMax.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_textMax.adjustsFontSizeToFitWidth = YES;
		_textMax.textAlignment =  UITextAlignmentCenter;
		_textMax.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE_SLIDERS];
		
		[self addSubview:_textMax];
		
		_textStep = [[UILabel alloc]initWithFrame:CGRectMake(SLIDERS_LEFT_POS + 3*SLIDERS_SPACING - 20, 40, 50 , 35)];
		_textStep.text = [NSString stringWithFormat:@"%d%@",gTriosLights[_indexLight].lights.step,@"%"];
		_textStep.backgroundColor = [UIColor blackColor];
		_textStep.textColor = [UIColor redColor];
		_textStep.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_textStep.adjustsFontSizeToFitWidth = YES;
		_textStep.textAlignment =  UITextAlignmentCenter;
		_textStep.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE_SLIDERS];
		
		[self addSubview:_textStep];
		
		UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc]
													initWithTarget:self action:@selector(handleSwipeLeft:)];
		swiper.direction = UISwipeGestureRecognizerDirectionLeft;
		[self  addGestureRecognizer:swiper];
		
		// retained by view
		[swiper release];

    }
    return self;
}

- (IBAction)handleSliderValue:(id)sender{
	UISlider * slider = sender;
	
	if ((int)[slider value] < gTriosLights[_indexLight].lights.minimum){
		slider.value = 0;
		
	}
	else if ((int)[slider value] > gTriosLights[_indexLight].lights.maximum){
		slider.value = 100;
	}
	_textValue.text = [NSString stringWithFormat:@"%d%@",(int)[slider value],@"%"];
	gTriosLights[_indexLight].lights.value = (ushort)[slider value];
	
}

- (IBAction)handleSliderMin:(id)sender{
	UISlider * slider = sender;
	
	_textMin.text = [NSString stringWithFormat:@"%d%@",(int)[slider value],@"%"];
	gTriosLights[_indexLight].lights.minimum = (ushort)[slider value];
	
}

- (IBAction)handleSliderMax:(id)sender{
	UISlider * slider = sender;
	
	_textMax.text = [NSString stringWithFormat:@"%d%@",(int)[slider value],@"%"];
	gTriosLights[_indexLight].lights.maximum = (ushort)[slider value];
}

- (IBAction)handleSliderStep:(id)sender{
	UISlider * slider = sender;
	
	_textStep.text = [NSString stringWithFormat:@"%d%@",(int)[slider value],@"%"];
	gTriosLights[_indexLight].lights.step = (ushort)[slider value];
	
}

- (IBAction)handleSwipeLeft:(UIGestureRecognizer *)sender {
	
	for( UIView * view in self.superview.subviews){
		[view setUserInteractionEnabled:YES];
	}
	
	[UIView 
	 animateWithDuration:SWIPE_ANIM_DURATION
	 delay:0
	 options:UIViewAnimationCurveEaseInOut
	 animations:^{
		 self.center = CGPointMake(-250, 368);
		 self.alpha = 0.1;
		 
	 }
	 completion:^(BOOL finished){
		 
		 // remove and release this object
		 [[self.superview viewWithTag:VIEW_TAG_LIGHT_DETAIL]removeFromSuperview];
		 [self release];
		 
		 // update trios with new values
		 [iLightsTriosWrapper TriosSendPostBuffer];
		 [iLightsTriosWrapper TriosSendGetBuffer];
	 }];
	
	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[_textMax release];
	[_textMin release];
	[_textStep release];
	[_textValue release];
	[_textDesciption release];

    [super dealloc];
}


@end
