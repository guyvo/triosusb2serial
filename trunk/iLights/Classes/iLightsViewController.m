//
//  iLightsViewController.m
//  iLights
//
//  Created by guy on 27/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "iLightsViewController.h"

// private help methods
@interface iLightsViewController()
-(void) calculateCenterPointsFromFrameSize:(CGSize) size;
-(void) makeArrayWithIndicatorViews;
-(void) makeArrayWithUtilityViews;
-(void) archiveRootObject:(NSString *) fileName rootObject:(id)root ;
-(id)   unarchiveRootObject:(NSString *) fileName;
-(void) loadIndicatorsFromFile:(NSString*) fileName;
@end

@implementation iLightsViewController

/************************************************************************************************/

- (void) calculateCenterPointsFromFrameSize:(CGSize) size{
	int flatIndex=0;
	
	for (int rows=0 ; rows < RASTER_ROWS ; rows++){
		for (int cols=0 ; cols < RASTER_COLS ; cols++){
			
			centerPoints[flatIndex + cols] = 
					CGPointMake( RASTER_SPACING + size.width/2  + ( (size.width  + RASTER_SPACING)* cols), 
								 RASTER_SPACING + size.height/2 + ( (size.height + RASTER_SPACING)* rows));
		}
		flatIndex += 5;
	}
}

/************************************************************************************************/

-(void) makeArrayWithIndicatorViews{
	CGSize viewSize;
	
	viewSize.width = RASTER_SIZE;
	viewSize.height = RASTER_SIZE;
	
	[self calculateCenterPointsFromFrameSize:viewSize];
	
	_indicatorViews = [[NSMutableArray alloc] initWithCapacity:25];
	
	for ( int views=0 ; views < 25 ; views++ ){
		_lightIndicator = 
		[[LightIndicatorView alloc] initWithMinimum:0 
									 andMaximum:100 
									   andIndex:views
									   andValue: gTriosLights[views].lights.value
										andName:[NSString stringWithCString:gpCLightNames[views] encoding:NSUTF8StringEncoding]
										 andTag:views
									   andFrame:CGRectMake(0, 0, RASTER_SIZE, RASTER_SIZE )];
		
		_lightIndicator.alpha = 0;
		
		[self.view addSubview:_lightIndicator];

		[_indicatorViews addObject:_lightIndicator];
		
		[_lightIndicator release];

		[UIView 
		 animateWithDuration:2
		 animations:^{
			 _lightIndicator.center = centerPoints[views];
			 _lightIndicator.alpha = 1;
		 }
		 completion:^(BOOL finished){
		 
		 }];
		
		
	}
	
	//[self archiveRootObject:@"/myview.archive" rootObject:_indicatorViews];
}

/************************************************************************************************/
// makeArrayWithIndicatorViews must be called first otherwise the result is unpredictable

-(void) makeArrayWithUtilityViews{
	
	_utilityViews = [[NSMutableArray alloc] initWithCapacity:5];
	
	for ( int views = 0 ; views < 5 ; views++){
		_utililtyView = [[UtilityView alloc] initWithFrame:CGRectMake(0, 0, 2*RASTER_SIZE, RASTER_SIZE )];
		
		_utililtyView.tag = views;
		_utililtyView.alpha = 0;
		
		[self.view addSubview:_utililtyView];
		
		[_utilityViews addObject:_utililtyView];
		
		[_utililtyView release];

		[UIView 
		 animateWithDuration:2
		 animations:^{
			 _utililtyView.center = CGPointMake(centerPoints[4+(views*5)].x + RASTER_SPACING + RASTER_SIZE+RASTER_SIZE/2, 
												centerPoints[4+(views*5)].y);
			 _utililtyView.alpha = 1;
		 }
		 completion:^(BOOL finished){
			 
		 }];
	}
}

/************************************************************************************************/

-(void) archiveRootObject:(NSString *) fileName rootObject:(id) root{
	
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	NSString * filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	[NSKeyedArchiver archiveRootObject:root toFile:filePath];	
}

/************************************************************************************************/

-(id) unarchiveRootObject:(NSString *) fileName{
	
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	NSString * filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

/************************************************************************************************/

-(void) loadIndicatorsFromFile:(NSString*) fileName{
	
	_indicatorViews = [self unarchiveRootObject:fileName];
	
	LightIndicatorView * indicator;
	
	for (indicator in _indicatorViews) {
		[self.view addSubview:indicator];
	}
}

/************************************************************************************************/
 
- (void)viewDidLoad {

    [super viewDidLoad];
	
	self.view.layer.borderColor = [[UIColor whiteColor]CGColor];
	self.view.layer.borderWidth = 2;
	
	TriosSetEthernet("192.168.1.24", 6969);
	TriosInitBuffer();
	
	[iLightsTriosWrapper TriosSendGetBuffer];

				   
	[self makeArrayWithIndicatorViews];
	[self makeArrayWithUtilityViews];	

}

/************************************************************************************************/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	LightIndicatorView * indicator;
	
	_lightIndicator = nil;
	
	for (UITouch * touch in touches){
		CGPoint point = [touch locationInView:self.view];
		for (indicator in _indicatorViews){
			if ( CGRectContainsPoint(indicator.frame,point) && ( indicator.isUserInteractionEnabled )){
				_lightIndicator = indicator;
				_lightIndicator.alpha = 0.5;
				[self.view bringSubviewToFront:_lightIndicator];
			}
			
		}
	}
}

/************************************************************************************************/

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	for (UITouch * touch in touches){
		CGPoint point = [touch locationInView:self.view];
		if(_lightIndicator != nil){
			if ( CGRectContainsPoint(_lightIndicator.frame,point) ){
				_lightIndicator.center = point;
			}
		}
	}
}

/************************************************************************************************/

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	LightIndicatorView * indicator;

	for (UITouch * touch in touches){
		CGPoint point = [touch locationInView:self.view];
		for (indicator in _indicatorViews){
			if ( (indicator != _lightIndicator) && ( _lightIndicator != nil ) ){
				if ( CGRectContainsPoint(indicator.frame,point) && ( indicator.isUserInteractionEnabled ) ){
					
					indicator.alpha = 0.5;
					
					int tmpTag = indicator.tag;
					
					[UIView 
					 animateWithDuration:1
					 animations:^{
						indicator.center = centerPoints[_lightIndicator.tag];
						 indicator.alpha = 1; 
						 _lightIndicator.center = centerPoints[tmpTag];
						 _lightIndicator.alpha = 1; 
					 }
					 completion:^(BOOL finished){
					 }];
					
					indicator.tag = _lightIndicator.tag;
					/*
					[UIView 
					 animateWithDuration:1
					 delay:0.5
					 options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						_lightIndicator.center = centerPoints[tmpTag];
						 _lightIndicator.alpha = 1; 
						
					 }
					 completion:^(BOOL finished){
					 }];
					 */
					_lightIndicator.tag = tmpTag;	
					
				}

			}
			else {
				indicator.alpha = 1.0;
			}
			
		}
	}
}

/************************************************************************************************/
// Override to allow orientations other than the default portrait orientation.

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeRight) || 
			(interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}

/************************************************************************************************/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

/************************************************************************************************/

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	
	LightIndicatorView * indicator;
	
	for (indicator in _indicatorViews) {
		[indicator release];
	}
	
	[_indicatorViews release];
	
	UtilityView * utilityView;
	
	for (utilityView in _utilityViews ){
		[utilityView release];
	}
	
	[_utilityViews release];
	
}

/************************************************************************************************/

- (void)dealloc {
    [super dealloc];
}

@end
