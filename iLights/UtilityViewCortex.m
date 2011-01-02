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
		
		UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(75, 2, 130, 130)];
		
		//view.backgroundColor = [UIColor blackColor];
		//view.layer.borderColor =[[UIColor redColor]CGColor];
		//view.layer.cornerRadius = VIEW_CORNER_RADIUS - 5;
		//view.layer.borderWidth = VIEW_BORDER_THIKNESS;
		
		view.image = [[UIImage alloc]initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  
																		 stringByAppendingPathComponent:@"cortex.png"]];
		
		[self addSubview:view];
		
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
