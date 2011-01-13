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
		
		CGRect subFrame = 
		CGRectMake(60, 
				   20, 
				   900, 
				   250);
		
		UIImageView * main1 = [[UIImageView alloc]initWithFrame:subFrame];
		
		main1.backgroundColor =[UIColor blackColor];
		
		main1.alpha = 0.3;
		
		UIImage * image = [[UIImage alloc] initWithContentsOfFile:
						   [[[NSBundle mainBundle] resourcePath]  
							stringByAppendingPathComponent:@"main.jpg"]];
		
		main1.image = image;
		main1.layer.borderColor =[[UIColor redColor]CGColor];
		main1.layer.cornerRadius = VIEW_CORNER_RADIUS - 5;
		main1.layer.borderWidth = VIEW_BORDER_THIKNESS+0.5;
		
		
		[image release];
		
		[self addSubview:main1];
		
		[main1 release];

		
		CGRect subFrame1 = 
		CGRectMake(60, 
				   460, 
				   900, 
				   250);
		
		UIImageView * main2 = [[UIImageView alloc]initWithFrame:subFrame1];
		
		main2.backgroundColor =[UIColor blackColor];
		
		main2.alpha = 0.3;
		
		UIImage * image1 = [[UIImage alloc] initWithContentsOfFile:
						   [[[NSBundle mainBundle] resourcePath]  
							stringByAppendingPathComponent:@"main.jpg"]];
		
		main2.image = image1;
		main2.layer.borderColor =[[UIColor redColor]CGColor];
		main2.layer.cornerRadius = VIEW_CORNER_RADIUS - 5;
		main2.layer.borderWidth = VIEW_BORDER_THIKNESS+0.5;
		
		
		[image1 release];
		
		[self addSubview:main2];
		
		[main2 release];

		CGRect subFrame2 = 
		CGRectMake(60, 
				   300, 
				   900, 
				   130);
		
		UIImageView * wifi = [[UIImageView alloc]initWithFrame:subFrame2];
		
		wifi.backgroundColor =[UIColor blackColor];
		
		wifi.alpha = 0.3;
		
		UIImage * image2 = [[UIImage alloc] initWithContentsOfFile:
							[[[NSBundle mainBundle] resourcePath]  
							 stringByAppendingPathComponent:@"wifi.jpg"]];
		
		wifi.image = image2;
		wifi.layer.borderColor =[[UIColor redColor]CGColor];
		wifi.layer.cornerRadius = VIEW_CORNER_RADIUS - 5;
		wifi.layer.borderWidth = VIEW_BORDER_THIKNESS+0.5;
		
		[image2 release];
		
		[self addSubview:wifi];
		
		[wifi release];
		
		CortexView * view = [[CortexView alloc]initWithX:270 andWithY:100 andWithIndex:0];
		[self addSubview:view];
		[view release];
		
		CortexView * view1 = [[CortexView alloc]initWithX:610 andWithY:100 andWithIndex:1];
		[self addSubview:view1];
		[view1 release];
		
		CortexView * view2 = [[CortexView alloc]initWithX:270 andWithY:540 andWithIndex:2];
		[self addSubview:view2];
		[view2 release];
		
		CortexView * view3 = [[CortexView alloc]initWithX:610 andWithY:540 andWithIndex:3];
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
