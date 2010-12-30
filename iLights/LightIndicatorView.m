//
//  LightIndicator.m
//  3Dlayer
//
//  Created by Guy Van Overtveldt on 15/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LightIndicatorView.h"

// must be imported in m obj file otherwise compile errors
#import "iLightsViewController.h"

// forward declarations for acces the static methods
@class iLightsTriosWrapper,iLightsViewController;

// private method declarations
@interface LightIndicatorView()

@end

// implementation of a subclassed UIView 
@implementation LightIndicatorView

// setter/getter automation
@synthesize 
_textDesciption,
_textValue,
_name,
_value,
_index,
_minimum,
_maximum
;


//implementing NSCoding protocol to serialize to file
-(void) encodeWithCoder: (NSCoder*) coder {
	
	[coder encodeCGRect:self.frame forKey:@"_frame"];
	
	[coder encodeInteger: 1 forKey: @"_version"];
	[coder encodeInteger: _maximum forKey: @"_maximum"];
	[coder encodeInteger: _minimum forKey: @"_minimum"];
	[coder encodeInteger: _value forKey: @"_value"];
	[coder encodeInteger: _index forKey: @"_index"];
	[coder encodeInteger: self.tag forKey:@"_tag"];
	
	[coder encodeObject:(id)_name forKey: @"_name"];
}

-(id) initWithCoder: (NSCoder*) coder {
	CGRect theFrame;
	
	theFrame = [coder decodeCGRectForKey:@"_frame"];
	
	_version = [coder decodeIntegerForKey:@"_version"];
	_maximum = [coder decodeIntegerForKey:@"_maximum"];
	_minimum = [coder decodeIntegerForKey:@"_minimum"];
	_value = [coder decodeIntegerForKey:@"_value"];
	_index = [coder decodeIntegerForKey:@"_index"];
	
	_name = [coder decodeObjectForKey:@"_name"];
	_theTag = [coder decodeIntegerForKey:@"_tag"];
	
	
	return ([[LightIndicatorView alloc] initWithMinimum:_minimum 
											 andMaximum:_maximum
											   andIndex:_index 
											   andValue:_value
												andName:_name
												 andTag:_theTag
											   andFrame:theFrame]);
	
}

// overwrite init method
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
	if (self) {
		
		self.backgroundColor = [UIColor blackColor];
		self.layer.borderColor =[[UIColor redColor]CGColor];
		self.layer.cornerRadius = VIEW_CORNER_RADIUS;
		self.layer.borderWidth = VIEW_BORDER_THIKNESS;
		self.tag = _theTag;
		
		notificationUpdateViews = [NSNotificationCenter defaultCenter];
		
		[notificationUpdateViews addObserver: self
									selector: @selector (updateView:)
										name: NOTIFICATION_UPDATE
									  object: nil];
		
		
		if ( self.tag != VIEW_TAG_SAVE_LIGTHS ){
			
			_textDesciption = [[UILabel alloc]initWithFrame:CGRectMake(5, (self.bounds.size.height - 15.0), (self.bounds.size.width - 5.0), 15)];
			_textDesciption.text = _name;
			_textDesciption.backgroundColor = [UIColor blackColor];
			_textDesciption.textColor = [UIColor redColor];
			_textDesciption.adjustsFontSizeToFitWidth = YES;
			_textDesciption.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
			_textDesciption.textAlignment =  UITextAlignmentCenter;
			_textDesciption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE];
			
			[self addSubview:_textDesciption];
			
			_textValue = [[UILabel alloc]initWithFrame:CGRectMake((self.bounds.size.width - 35), 20, 30 , 15)];
			_textValue.text = [NSString stringWithFormat:@"%d%@",_value,@"%"];
			_textValue.backgroundColor = [UIColor blackColor];
			_textValue.textColor = [UIColor redColor];
			_textValue.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
			_textValue.adjustsFontSizeToFitWidth = YES;
			_textValue.textAlignment =  UITextAlignmentCenter;
			_textValue.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE];
			
			[self addSubview:_textValue];
			
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
			
			
			[singleFingerSTap release];
			[singleFingerDTap release];
			
			
			return self;
		}
		else{
			int tag = 100;
			for (int rows=0 ; rows < 3 ; rows++){
				for ( int cols=0 ; cols < 2 ; cols++){
					CGRect subFrame = 
						CGRectMake(cols * self.bounds.size.width/2, 
								   rows * self.bounds.size.height/3, 
								   self.bounds.size.width/2, 
								   self.bounds.size.height/3);
					
					UIImageView * view = [[UIView alloc]initWithFrame:subFrame];
					
					view.backgroundColor = [UIColor blackColor];
					view.layer.borderColor =[[UIColor redColor]CGColor];
					view.layer.cornerRadius = VIEW_CORNER_RADIUS - 5;
					view.layer.borderWidth = VIEW_BORDER_THIKNESS;
					view.tag = tag + cols;
					
					
					
					[self addSubview:view];
					
					UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc]
																initWithTarget:self action:@selector(handleSaveView:)];
					UITapGestureRecognizer *singleFingerSTap = [[UITapGestureRecognizer alloc]
																initWithTarget:self action:@selector(handleLoadView:)];
					
					singleFingerDTap.numberOfTapsRequired = 2;
					singleFingerSTap.numberOfTapsRequired = 1;
					
					[singleFingerSTap requireGestureRecognizerToFail:singleFingerDTap];
					
					[singleFingerSTap setDelaysTouchesBegan:YES];
					[singleFingerDTap setDelaysTouchesBegan:YES];
					
					
					[view addGestureRecognizer:singleFingerSTap];
					[view addGestureRecognizer:singleFingerDTap];
					
					
					[singleFingerSTap release];
					[singleFingerDTap release];
					[view release];
					
				}
				tag += 2;
			}	
		
			return self;
		}
	
    }
	else {
		
		return nil;
	}
}

- (IBAction)handleSaveView:(UIGestureRecognizer *)sender {
	
	[iLightsViewController savetoFileWithPresetNumber:sender.view.tag-100];

}

- (IBAction)handleLoadView:(UIGestureRecognizer *)sender {

	[UIView 
	 animateWithDuration:SCALE_ANIM_INDICATOR 
	 animations:^{
		 sender.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
	 }
	 completion:^(BOOL finished){
		 [UIView 
		  animateWithDuration:SCALE_ANIM_INDICATOR 
		  animations:^{
			  sender.view.transform = CGAffineTransformMakeScale(1,1);
		  }
		  completion:^(BOOL finished){
			  [iLightsViewController loadFromFileWithPresetNumber:sender.view.tag-100];
		  }];
	 }];
	
	

}

- (void) updateView:(id) notification{
	
	self._value = gTriosLights[self._index].lights.value;
	[self setNeedsDisplay];
	
}

- (IBAction)handleSingleTap:(UIGestureRecognizer *)sender {
	
	[self.superview bringSubviewToFront:self];
	
	
	[UIView 
	 animateWithDuration:SCALE_ANIM_INDICATOR 
	 animations:^{
		 self.transform = CGAffineTransformMakeScale(1.5, 1.5);
	 }
	 completion:^(BOOL finished){
		 [UIView 
		  animateWithDuration:SCALE_ANIM_INDICATOR 
		  animations:^{
			  self.transform = CGAffineTransformMakeScale(1,1);
		  }
		  completion:^(BOOL finished){
		  }];
	 }];
	
	// _value is updated via the notification center
	if ( self._value == 0 ){
		gTriosLights[self._index].lights.value = 100;
	}
	else if ( self._value == 100 ){
		gTriosLights[self._index].lights.value = 0;
	}
	else {
		gTriosLights[self._index].lights.value = 0;
	}
	
	//[self setNeedsDisplay];
	[iLightsTriosWrapper TriosSendPostBuffer];
	[iLightsTriosWrapper TriosSendGetBuffer];
	
}


- (IBAction)handleSingleDoubleTap:(UIGestureRecognizer *)sender {
	LightView * v;
	
	[self.superview bringSubviewToFront:self];
	
	for( UIView * view in self.superview.subviews){
		[view setUserInteractionEnabled:NO];
	}
	
	CGPoint tmp = [self center];
	
	
	v = [[LightView alloc] initWithIndex:self._index andFrame:CGRectMake(0, 0, 5 , 5)];
	v.center = [sender locationInView:self.superview];
	v.alpha = 0.8;
	v.tag = VIEW_TAG_LIGHT_DETAIL;
	
	[self.superview addSubview:v];
	
	[UIView 
	 animateWithDuration:1 
	 animations:^{
		 
		 v.frame = CGRectMake(0,0, 500 , 500);
		 v.center= CGPointMake(300 , 368);
		 
	 }
	 completion:^(BOOL finished){
		 [UIView 
		  animateWithDuration:SCALE_ANIM_INDICATOR * 5
		  delay:0
		  options:UIViewAnimationOptionAllowUserInteraction
		  animations:^{
			  self.transform = CGAffineTransformMakeScale(1.5, 1.5);
			  self.center = CGPointMake(800, 368);
		  }
		  completion:^(BOOL finished){
			  [UIView 
			   animateWithDuration:SCALE_ANIM_INDICATOR * 5
			   delay:5
			   options:UIViewAnimationOptionAllowUserInteraction
			   animations:^{
				   self.transform = CGAffineTransformMakeScale(1.0, 1.0);
				   self.center = tmp;
			   }
			   completion:^(BOOL finished){
			   }];
		  }];
	 }];
	
	
}

// customized init method calling overwrite init at the end
- (id)initWithMinimum:(NSInteger)minimum 
		   andMaximum:(NSInteger)maximum 
			 andIndex:(NSInteger)index 
			 andValue:(NSInteger)value 
			  andName:(NSString *)name
			   andTag:(NSInteger)theTag
			 andFrame:(CGRect)frame
{
	
	_maximum	= maximum;
	_minimum	= minimum;
	_index		= index;
	_name		= [name retain];
	_value		= value;
	_theTag		= theTag;
	
	return [self initWithFrame:frame];
}

// alter the center of this view
- (void) setFrameCenter:(CGPoint) center{
	self.center = center;
}

// overwrite parent class to change draw behaviour
- (void)drawRect:(CGRect)rect {
	
    if ( self.tag != VIEW_TAG_SAVE_LIGTHS ){
		
		// create so release ref
		CGGradientRef myGradient;
		CGColorSpaceRef myColorSpace;
		
		// no create no release
		CGContextRef context;
		
		size_t locationCount;
		
		CGPoint startPoint;
		CGPoint endPoint;
		
		CGFloat startRadius;
		CGFloat endRadius;
		
		CGFloat locationList[2];
		
		CGFloat colorList[] = {
			0.0, 0.1, 0.1, 0.95,
			0.85, 0.85, 0.0, 1.0,
		};
		
		context = UIGraphicsGetCurrentContext();
		
		locationCount = 2;
		
		locationList[0] = (100 - _value)/100.0;
		locationList[1] = 1.0;
		
		myColorSpace	= CGColorSpaceCreateDeviceRGB();
		myGradient		= CGGradientCreateWithColorComponents(myColorSpace, colorList, locationList, locationCount);
		
		startPoint.x	= 10;
		startPoint.y	= 10;
		
		endPoint.x		= CGRectGetMaxX(self.bounds)/2;
		endPoint.y		= CGRectGetMaxY(self.bounds)/2+5;
		
		startRadius		= 0;
		endRadius		= CGRectGetMaxY(self.bounds)/2-20;
		
		CGContextDrawRadialGradient(context, myGradient, startPoint, startRadius, endPoint, endRadius, 0);
		
		CGGradientRelease(myGradient);
		CGColorSpaceRelease(myColorSpace);
		
		//ensure that label is updated when refreshing
		_textValue.text = [NSString stringWithFormat:@"%d%@",_value,@"%"];
	}
	else{
		
	}
	
}

// release resources
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_name release];
	[_textValue release];
	[_textDesciption release];
    [super dealloc];
}

@end
