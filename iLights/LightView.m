//
//  LightView.m
//  iLights
//
//  Created by Guy Van Overtveldt on 27/11/10.
//  Copyright 2010 ATOS worldline. All rights reserved.
//

#import "LightView.h"


@implementation LightView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blackColor];
		self.layer.borderColor =[[UIColor redColor]CGColor];
		self.layer.cornerRadius = VIEW_CORNER_RADIUS;
		self.layer.borderWidth = VIEW_BORDER_THIKNESS;
		
		UISlider * sliderValue = [[UISlider alloc] initWithFrame:CGRectMake(0,0,200,20)];
		sliderValue.transform = CGAffineTransformScale(sliderValue.transform,2, 1);
		sliderValue.center = CGPointMake(50, 250);
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
		
		[sliderValue addTarget:(id)self action:@selector(handleSlider:) forControlEvents:UIControlEventValueChanged];
		
		[self addSubview:sliderValue];
		
		[sliderValue release];
		
		UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc]
													initWithTarget:self action:@selector(handleSwipeLeft:)];
		swiper.direction = UISwipeGestureRecognizerDirectionLeft;
		[self  addGestureRecognizer:swiper];

    }
    return self;
}

- (IBAction)handleSlider:(id)sender{

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
    [super dealloc];
}


@end
