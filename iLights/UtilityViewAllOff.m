//
//  UtilityView.m
//  iLights
//
//  Created by Guy Van Overtveldt on 18/12/10.
//  Copyright 2010 ATOS worldline. All rights reserved.
//

#import "UtilityViewAllOff.h"


@implementation UtilityViewAllOff


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

		
		UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(90, 25, 90, 90)];
		
		UIImage * image =[[UIImage alloc]initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  
																 stringByAppendingPathComponent:@"cortex.png"]];
		view.image = image;
		
		[image release];
		
		view.alpha = 0.7;
		
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
		
		[view.layer addAnimation:scale forKey:@"transform"];
		
		[image release];
		[view release];		
		
		return self;
		
    }
    return self;
}

- (IBAction)handleSingleTap:(UIGestureRecognizer *)sender {
	
	
}


- (IBAction)handleSingleDoubleTap:(UIGestureRecognizer *)sender {
	for (int i = 0 ; i < 24; i++){
		gTriosLights[i].lights.value = 0;
	}
	[iLightsTriosWrapper TriosSendPostBuffer ];
	[iLightsTriosWrapper TriosSendGetBuffer ];
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
