//
//  UtilityViewCortex.m
//  iLights
//
//  Created by Guy Van Overtveldt on 1/01/11.
//  Copyright 2011 ATOS worldline. All rights reserved.
//

#import "UtilityViewCortex.h"
#import "OverviewView.h"


@implementation UtilityViewCortex

- (void) animateTheView{
    
	
	UIImage * image =[[UIImage alloc]initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  
															 stringByAppendingPathComponent:@"cortex.png"]];
	
	UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    
    view.image = image;
	
    view.contentMode = UIViewContentModeScaleAspectFill;
	[image release];
	
	view.alpha = 0.5;
	
	[self addSubview:view];
	
	[self bringSubviewToFront:view];
	
	for (int i = 0 ; i< NUMBER_OF_ONES ; i++){
		
		//CGMutablePathRef  path = CGPathCreateMutable();
		
		//CGPathMoveToPoint(path, NULL, 0 + (i*2), 75);
		//CGPathAddLineToPoint(path, NULL, 150  , 75);
		
		UILabel * one = [[UILabel alloc] init];
        one.text = MESSAGE_DETAIL;
  		one.backgroundColor = [UIColor blackColor];
		one.frame = CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height);
		one.textColor = [UIColor colorWithHue:0.99 saturation:0.8 brightness:0.9 alpha:0.8];
		one.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE];
        one.textAlignment = UITextAlignmentCenter;
    
       
        /*

         if ( i % 2 ){
         one.text = @"1";
         }else{
         one.text = @"0";
         }
         
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		
		animation.path = path;
		CGPathRelease(path);
		
		
		animation.duration = 3+(i*0.75);
		animation.repeatCount = 2;// must be MAX_INT
		animation.removedOnCompletion = YES;
		animation.fillMode = kCAFillModeForwards;
		animation.calculationMode = kCAAnimationPaced;
		
		[one.layer addAnimation:animation forKey:@"position"];
        */
        
		[self.layer insertSublayer:one.layer below:view.layer];
		
	}
    
	/*
	CABasicAnimation * scale = [CABasicAnimation animationWithKeyPath:@"transform"];

	scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.25, 0.25, 1)];
    scale.toValue =	[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.8, 1.5, 1)];
	scale.duration = 5;
	scale.repeatCount = 10000;
	scale.removedOnCompletion = NO;
	scale.autoreverses=YES;
	scale.fillMode = kCAFillModeForwards;

	[view.layer addAnimation:scale forKey:@"transform"];
	*/
    
	// release allocs
	[image release];
	[view release];
	
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
		
		[self animateTheView];

		
		return self;
		
    }
    return self;
}

- (IBAction)handleSingleTap:(UIGestureRecognizer *)sender {
	
	
}


- (IBAction)handleSingleDoubleTap:(UIGestureRecognizer *)sender {
	
	for( UIView * view in self.superview.subviews){
		[view setUserInteractionEnabled:NO];
	}
	
	OverviewView * view = [[OverviewView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
	view.alpha = 0.8;
	[self.superview addSubview:view];

	[self.superview bringSubviewToFront:view];
	[view release];
	
	
	
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
