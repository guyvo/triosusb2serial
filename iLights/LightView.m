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
_textValue;


- (UISlider*) createSlider:(CGPoint)point{
	
	UISlider * sliderValue = [[UISlider alloc] initWithFrame:CGRectMake(0,0,300,20)];
	sliderValue.transform = CGAffineTransformScale(sliderValue.transform,SLIDERS_SCALE, 1);
	sliderValue.center = point;
	sliderValue.transform = CGAffineTransformRotate(sliderValue.transform, 270.0/180*M_PI);
	sliderValue.minimumValue = 0.0;
	sliderValue.maximumValue = 100.0;
	sliderValue.continuous = YES;
	sliderValue.value = 50.0;
	
	UIImage* thumbImage = [UIImage imageNamed:@"raster.png"];
	[sliderValue setThumbImage:thumbImage forState:UIControlStateNormal];
	[sliderValue setThumbImage:thumbImage forState:UIControlStateHighlighted];
	
	thumbImage = [UIImage imageNamed:@"yellow100x100.png"];
	[sliderValue setMinimumTrackImage:thumbImage forState:UIControlStateNormal]; 
	
	thumbImage = [UIImage imageNamed:@"grey.png"];
	[sliderValue setMaximumTrackImage:thumbImage forState:UIControlStateNormal];
	
	return sliderValue;
	
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blackColor];
		self.layer.borderColor =[[UIColor redColor]CGColor];
		self.layer.cornerRadius = VIEW_CORNER_RADIUS;
		self.layer.borderWidth = VIEW_BORDER_THIKNESS;
		
		UISlider * sliderValue = [self createSlider:CGPointMake(SLIDERS_LEFT_POS, 250)];
		[sliderValue addTarget:(id)self action:@selector(handleSliderValue:) forControlEvents:UIControlEventValueChanged];

		UISlider * sliderMin = [self createSlider:CGPointMake(SLIDERS_LEFT_POS + SLIDERS_SPACING, 250)];
		[sliderMin addTarget:(id)self action:@selector(handleSliderMin:) forControlEvents:UIControlEventValueChanged];
		
		UISlider * sliderMax = [self createSlider:CGPointMake(SLIDERS_LEFT_POS + 2*SLIDERS_SPACING, 250)];
		[sliderMax addTarget:(id)self action:@selector(handleSliderMax:) forControlEvents:UIControlEventValueChanged];
		
		UISlider * sliderStep = [self createSlider:CGPointMake(SLIDERS_LEFT_POS + 3*SLIDERS_SPACING, 250)];
		[sliderStep addTarget:(id)self action:@selector(handleSliderStep:) forControlEvents:UIControlEventValueChanged];
		
		[self addSubview:sliderValue];
		[self addSubview:sliderMin];
		[self addSubview:sliderMax];
		[self addSubview:sliderStep];
		
		[sliderValue release];
		[sliderMin release];
		[sliderMax release];
		[sliderStep release];
		
		_textDesciption = [[UILabel alloc]initWithFrame:CGRectMake(SLIDERS_LEFT_POS-20, 450, 50 , 35)];
		_textDesciption.text = @"value";
		_textDesciption.backgroundColor = [UIColor blackColor];
		_textDesciption.textColor = [UIColor redColor];
		_textDesciption.adjustsFontSizeToFitWidth = YES;
		_textDesciption.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_textDesciption.textAlignment =  UITextAlignmentCenter;
		_textDesciption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE_SLIDERS];
		
		[self addSubview:_textDesciption];
		
		_textValue = [[UILabel alloc]initWithFrame:CGRectMake(SLIDERS_LEFT_POS-20, 20, 50 , 35)];
		_textValue.text = @"100%";
		_textValue.backgroundColor = [UIColor blackColor];
		_textValue.textColor = [UIColor redColor];
		_textValue.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_textValue.adjustsFontSizeToFitWidth = YES;
		_textValue.textAlignment =  UITextAlignmentCenter;
		_textValue.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE_SLIDERS];
		
		[self addSubview:_textValue];
		
		
		UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc]
													initWithTarget:self action:@selector(handleSwipeLeft:)];
		swiper.direction = UISwipeGestureRecognizerDirectionLeft;
		[self  addGestureRecognizer:swiper];

    }
    return self;
}

- (IBAction)handleSliderValue:(id)sender{

}

- (IBAction)handleSliderMin:(id)sender{
	
}

- (IBAction)handleSliderMax:(id)sender{
	
}

- (IBAction)handleSliderStep:(id)sender{
	
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
		 self.alpha = 0.2;
		 
	 }
	 completion:^(BOOL finished){
		 [[self.superview viewWithTag:VIEW_TAG_LIGHT_DETAIL]removeFromSuperview];
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
	[_textValue release];
	[_textDesciption release];

    [super dealloc];
}


@end
