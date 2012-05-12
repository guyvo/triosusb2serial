//
//  UtilityViewSetup.m
//  iLights
//
//  Created by Guy Van Overtveldt on 1/01/11.
//  Copyright 2011 ATOS worldline. All rights reserved.
//

#import "UtilityViewSetup.h"


@implementation UtilityViewSetup


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blackColor];
		self.layer.borderColor =[[UIColor colorWithRed:0.8 green:0.3 blue:0.2 alpha:1]CGColor];
		self.layer.cornerRadius = VIEW_CORNER_RADIUS;
		self.layer.borderWidth = VIEW_BORDER_THIKNESS;
		
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
		
		// retained by view
		[singleFingerSTap release];
		[singleFingerDTap release];
		
        UIImage * image =[[UIImage alloc]initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  
                                                                 stringByAppendingPathComponent:@"cortex.png"]];
        
        UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        
        view.image = image;
        
        view.contentMode = UIViewContentModeScaleAspectFill;
        [image release];
        
        view.alpha = 0.5;
        
        [self addSubview:view];
        
        [self bringSubviewToFront:view];
		
		
		CABasicAnimation * scale = [CABasicAnimation animationWithKeyPath:@"transform"];
		
		scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1)];
		scale.toValue =	[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.4, 1.3, 1)];
		scale.duration = 5;
		scale.repeatCount = 10000;
		scale.removedOnCompletion = NO;
		scale.autoreverses=YES;
		scale.fillMode = kCAFillModeForwards;
		
		//[view.layer addAnimation:scale forKey:@"transform"];
		
		//[image release];
		[view release];		
		
		return self;
		
    }
    return self;
}

- (IBAction)handleSingleTap:(UIGestureRecognizer *)sender {
	
	
}


- (IBAction)handleSingleDoubleTap:(UIGestureRecognizer *)sender {

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
