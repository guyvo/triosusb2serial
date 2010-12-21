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
		
		
		UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc]
													initWithTarget:self action:@selector(handleSlider:)];
		swiper.direction = UISwipeGestureRecognizerDirectionLeft;
		[self  addGestureRecognizer:swiper];

    }
    return self;
}

- (IBAction)handleSlider:(UIGestureRecognizer *)sender {
	
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
