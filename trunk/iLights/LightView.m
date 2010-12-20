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
		self.layer.cornerRadius = 30;
		self.layer.borderWidth = 2;
		
		
		UISwipeGestureRecognizer *slider = [[UISwipeGestureRecognizer alloc]
													initWithTarget:self action:@selector(handleSlider:)];
		slider.direction = UISwipeGestureRecognizerDirectionLeft;
		[self  addGestureRecognizer:slider];

    }
    return self;
}

- (IBAction)handleSlider:(UIGestureRecognizer *)sender {
	
	for( UIView * view in self.superview.subviews){
		[view setUserInteractionEnabled:YES];
	}
	
	[[self.superview viewWithTag:50]removeFromSuperview];
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
