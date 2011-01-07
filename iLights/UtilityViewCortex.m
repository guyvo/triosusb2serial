//
//  UtilityViewCortex.m
//  iLights
//
//  Created by Guy Van Overtveldt on 1/01/11.
//  Copyright 2011 ATOS worldline. All rights reserved.
//

#import "UtilityViewCortex.h"


@implementation UtilityViewCortex

- (void) animateTheView{
	UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(85, 25, 90, 90)];
	
	
	view.image = [[UIImage alloc]initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  
														 stringByAppendingPathComponent:@"cortex.png"]];
	
	view.alpha = 0.6;
	
	[self addSubview:view];
	
	[self bringSubviewToFront:view];
	
	for (int i = 0 ; i< NUMBER_OF_ONES ; i++){
		
		CGMutablePathRef  path = CGPathCreateMutable();
		
		CGPathMoveToPoint(path, NULL, 0 + (i*5), 75);
		CGPathAddLineToPoint(path, NULL, 250 + (i*1) , 75);
		
		CATextLayer * one = [CATextLayer layer];
		
		if ( i % 2 ){
			one.string = @"1";
		}else{
			one.string = @"0";
		}
		
		one.fontSize = 20;
		one.frame = CGRectMake(0, 0, 20, 20);
		one.foregroundColor = [[UIColor colorWithHue:0.99 saturation:0.9 brightness:0.9 alpha:0.8]CGColor];
		
		CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		
		animation.path = path;
		CGPathRelease(path);
		animation.duration = 5+(i*0.75);
		animation.repeatCount = 10000;// must be MAX_INT
		animation.removedOnCompletion = NO;
		animation.fillMode = kCAFillModeForwards;
		animation.calculationMode = kCAAnimationPaced;
		
		[one addAnimation:animation forKey:@"position"];
		[self.layer insertSublayer:one below:view.layer];
		
	}
	
	[UIView 
	 animateWithDuration:SWIPE_ANIM_DURATION
	 delay:0
	 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
	 animations:^{
		 view.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1);
		 view.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
	 }
	 completion:^(BOOL finished){
	 }];
	
	
}

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
		NSNotificationCenter * enterBackground = [NSNotificationCenter defaultCenter];
		
		[enterBackground addObserver: self
							selector: @selector (stopAnimating:)
								name: UIApplicationDidEnterBackgroundNotification
							  object: nil];

		NSNotificationCenter * enterForeground = [NSNotificationCenter defaultCenter];
		
		[enterForeground addObserver: self
							selector: @selector (startAnimating:)
								name: UIApplicationWillEnterForegroundNotification
							  object: nil];
		
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
		
		[self animateTheView];

		
		return self;
		
    }
    return self;
}



- (void) stopAnimating:(id) notification{
	[self.layer removeAllAnimations];
	
}

- (void) startAnimating:(id) notification{
	[self animateTheView];
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
