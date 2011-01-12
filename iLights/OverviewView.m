//
//  OverviewView.m
//  iLights
//
//  Created by Guy Van Overtveldt on 12/01/11.
//  Copyright 2011 ATOS worldline. All rights reserved.
//

#import "OverviewView.h"
#import "CortexView.h"

@implementation OverviewView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blackColor];
		self.layer.borderColor =[[UIColor redColor]CGColor];
		self.layer.cornerRadius = VIEW_CORNER_RADIUS;
		self.layer.borderWidth = VIEW_BORDER_THIKNESS;
		
		CortexView * view = [[CortexView alloc]initWithX:100 andWithY:100 andWithIndex:0];
		[self addSubview:view];
		[view release];
		
		CortexView * view1 = [[CortexView alloc]initWithX:500 andWithY:100 andWithIndex:1];
		[self addSubview:view1];
		[view1 release];
		
		CortexView * view2 = [[CortexView alloc]initWithX:100 andWithY:500 andWithIndex:2];
		[self addSubview:view2];
		[view2 release];
		
		CortexView * view3 = [[CortexView alloc]initWithX:500 andWithY:500 andWithIndex:3];
		[self addSubview:view3];
		[view3 release];
		
		UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc]
											initWithTarget:self action:@selector(handleSwipeLeft:)];
		swiper.direction = UISwipeGestureRecognizerDirectionLeft;
		[self  addGestureRecognizer:swiper];
		
		// retained by view
		[swiper release];
		
    }
    return self;
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
		 [self removeFromSuperview];
		 
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
