//
//  UtilityViewCortex.m
//  iLights
//
//  Created by Guy Van Overtveldt on 1/01/11.
//  Copyright 2011 ATOS worldline. All rights reserved.
//

#import "UtilityViewCortex.h"


@implementation UtilityViewCortex

-(id) initWithIcon:(UIImage *) icon andFrame:(CGRect)frame{
	[self initWithFrame:frame];
	if (self != nil){
		
		UIImageView * icon = [[UIImageView alloc]initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  
																 stringByAppendingPathComponent:@"cortex.png"]];
		
		[self addSubview:icon];
		
	}
	
	return nil;
}


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
		
		UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(85, 25, 90, 90)];
		
		//view.backgroundColor = [UIColor blackColor];
		//view.layer.borderColor =[[UIColor redColor]CGColor];
		//view.layer.cornerRadius = VIEW_CORNER_RADIUS - 5;
		//view.layer.borderWidth = VIEW_BORDER_THIKNESS;
		
		view.image = [[UIImage alloc]initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  
																		 stringByAppendingPathComponent:@"cortex.png"]];
		
		
		
		[self addSubview:view];
		
		CGMutablePathRef  path = CGPathCreateMutable();
		
		CGPathMoveToPoint(path, NULL, 150, 50);
		CGPathAddLineToPoint(path, NULL, 200, 50);
		CGPathAddLineToPoint(path, NULL, 200, 0);
		CGPathAddLineToPoint(path, NULL, 50, 0);
		CGPathAddLineToPoint(path, NULL, 50, 75);
		CGPathAddLineToPoint(path, NULL, 150, 50);
		
		
		CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];

		animation.path = path;
		animation.duration = 10;
		animation.repeatCount = 10;
		animation.removedOnCompletion = YES;
		animation.fillMode = kCAFillModeForwards;
		animation.calculationMode = kCAAnimationCubicPaced;
/*
		animation.values = [NSArray arrayWithObjects:
							//[NSNumber numberWithFloat:(0.0 / 180.0) * M_PI],
							[NSNumber numberWithFloat:(179.0 / 180.0) * M_PI],
							[NSNumber numberWithFloat:(-179.0 / 180.0) * M_PI], nil];
		
*/		
//		view.layer.anchorPoint = CGPointMake(0,0);
		[view.layer addAnimation:animation forKey:@"position"];
		
		
		/*
		[UIView 
		 animateWithDuration:SWIPE_ANIM_DURATION
		 delay:0
		 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
		 animations:^{
			 view.layer.transform = CATransform3DMakeRotation(M_PI*0.99, 0, 0, 1);
			 view.layer.transform = CATransform3DMakeRotation(-M_PI*0.99, 0, 0, 1);
			 
		 }
		 completion:^(BOOL finished){
			 //view.layer.transform = CATransform3DMakeRotation(0, 0, 1, 1);
		 }];
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
