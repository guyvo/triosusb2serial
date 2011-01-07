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
		/*
		CGMutablePathRef  path = CGPathCreateMutable();
		
		CGPathMoveToPoint(path, NULL, 150, 50);
		CGPathAddLineToPoint(path, NULL, 200, 50);
		CGPathAddLineToPoint(path, NULL, 200, 0);
		CGPathAddLineToPoint(path, NULL, 50, 0);
		CGPathAddLineToPoint(path, NULL, 50, 75);
		CGPathAddLineToPoint(path, NULL, 150, 50);
		
		CAShapeLayer * shape = [CAShapeLayer layer];
		
		shape.path = path;
		shape.strokeColor = [[UIColor colorWithHue:0.15 saturation:0.2 brightness:0.5 alpha:0.8]CGColor];
		shape.strokeEnd = 1;
		shape.strokeStart= 0;
		
		[self.layer addSublayer:shape];
		*/
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
