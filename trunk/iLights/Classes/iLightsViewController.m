//
//  iLightsViewController.m
//  iLights
//
//  Created by guy on 27/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "iLightsViewController.h"
#import "iLightsTriosWrapper.h"

@class iLightsTriosWrapper;

static int staticPreset;

// private help methods
@interface iLightsViewController()

-(void) calculateCenterPointsFromFrameSize:(CGSize) size;
-(void) makeArrayWithIndicatorViews;
-(void) makeArrayWithUtilityViews;
-(void) archiveRootObject:(NSString *) fileName rootObject:(id)root ;
-(id)   newUnarchiveRootObject:(NSString *) fileName;
-(id)   loadIndicatorsFromFile:(NSString*) fileName;

@end

@implementation iLightsViewController

@synthesize
_lightIndicator,
_lightView,
_indicatorViews,
_utilityViewCortex,
_utilityViewSetup,
_utilityViewFree1,
_utilityViewFree2,
_utilityViewAllOff
;

/************************************************************************************************/

+(void) loadFromFileWithPresetNumber:(NSInteger) preset{
	staticPreset = preset;
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOAD_PRESET  object: self];
	[iLightsTriosWrapper TriosSendPostBuffer];
		
}

/************************************************************************************************/

+(void) savetoFileWithPresetNumber:(NSInteger) preset{
	staticPreset = preset;
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SAVE_PRESET  object: self]; 
	
}

/************************************************************************************************/

- (void) calculateCenterPointsFromFrameSize:(CGSize) size{
	
	int flatIndex=0;
	
	for (int rows=0 ; rows < RASTER_ROWS ; rows++){
		for (int cols=0 ; cols < RASTER_COLS ; cols++){
			
			centerPoints[flatIndex + cols] = 
			CGPointMake( RASTER_SPACING + size.width/2  + ( (size.width  + RASTER_SPACING)* cols), 
						RASTER_SPACING + size.height/2 + ( (size.height + RASTER_SPACING)* rows));
		}
		flatIndex += RASTER_COLS;
	}
}

/************************************************************************************************/

-(void) makeArrayWithIndicatorViews{
	
	CGSize viewSize;
	
	viewSize.width = RASTER_SIZE;
	viewSize.height = RASTER_SIZE;
	
	[self calculateCenterPointsFromFrameSize:viewSize];
	
	
	if ( [self loadIndicatorsFromFile:FILE_NAME_ARCHIVE_INDICATORS] != nil){
		
		// created from archive here
	}
	else{
		// fresh install
		
		_indicatorViews = [[NSMutableArray alloc] initWithCapacity:RASTER_COUNT];
		
		for ( int views=0 ; views < RASTER_COUNT ; views++ ){
			
			@try {
				if (views==24){
					_lightIndicator = [[LightIndicatorView alloc] 
									   initWithMinimum:0 
									   andMaximum:100 
									   andIndex:views
									   andValue: 0
									   andName:[NSString stringWithFormat:@"presets"]
									   andTag:views
									   andFrame:CGRectMake(512, 368, RASTER_SIZE, RASTER_SIZE )];
					
				}
				else{
					_lightIndicator = [[LightIndicatorView alloc] 
									   initWithMinimum:0 
									   andMaximum:100 
									   andIndex:views
									   andValue: gTriosLights[views].lights.value
									   andName:[NSString stringWithCString:gpCLightNames[views] encoding:NSUTF8StringEncoding]
									   andTag:views
									   andFrame:CGRectMake(512, 368, RASTER_SIZE, RASTER_SIZE )];
				}
				
			}
			@catch(NSException *e){
				
			}
			
			
			_lightIndicator.alpha = 0;
			
			[self.view addSubview:_lightIndicator];
			
			[UIView 
			 animateWithDuration:RASTER_ANIM_DURATION
			 animations:^{
				 _lightIndicator.center = centerPoints[views];
				 _lightIndicator.alpha = 1;
			 }
			 completion:^(BOOL finished){
			 }];
			
			// store them for later use in touches
			[_indicatorViews addObject:_lightIndicator];
			
			// retained by superview
			[_lightIndicator release];
			
		}
	}
	
	notifyLoadPreset = [NSNotificationCenter defaultCenter];
	
	[notifyLoadPreset addObserver: self
						 selector: @selector (handleLoadPreset:)
							 name: NOTIFICATION_LOAD_PRESET
						   object: nil];
	
	notifySavePreset = [NSNotificationCenter defaultCenter];
	
	[notifySavePreset addObserver: self
						 selector: @selector (handleSavePreset:)
							 name: NOTIFICATION_SAVE_PRESET
						   object: nil];
}

- (void) handleLoadPreset:(id) notification{
	[self loadIndicatorsFromFile:[NSString stringWithFormat:@"preset_%d",staticPreset]];
	

}

- (void) handleSavePreset:(id) notification{
	[self saveIndicatorsToFile:[NSString stringWithFormat:@"preset_%d",staticPreset]];
}


/************************************************************************************************/
// makeArrayWithIndicatorViews must be called first otherwise the result is unpredictable

-(void) makeArrayWithUtilityViews{
	
	// ************************* cortex
	
	_utilityViewCortex = [[UtilityViewCortex alloc] initWithFrame:CGRectMake(512, 368, 2*RASTER_SIZE, RASTER_SIZE )];
	
	_utilityViewCortex.alpha = 0;
	
	[self.view addSubview:_utilityViewCortex];
	
	
	[UIView 
	 animateWithDuration:UTILITY_ANIM_DURATION
	 animations:^{
		 _utilityViewCortex.center = 
		 CGPointMake(centerPoints[UTILITY_COUNT - 1 ].x + RASTER_SPACING + RASTER_SIZE+RASTER_SIZE/2, 
					 centerPoints[UTILITY_COUNT - 1 ].y);
		 _utilityViewCortex.alpha = 1;
	 }
	 completion:^(BOOL finished){
		 
	 }];
	
	// retained by superview
	[_utilityViewCortex release];
	
	// ************************* setup
	
	_utilityViewSetup = [[UtilityViewSetup alloc] initWithFrame:CGRectMake(512, 368, 2*RASTER_SIZE, RASTER_SIZE )];
	
	_utilityViewSetup.alpha = 0;
	
	[self.view addSubview:_utilityViewSetup];
	
	
	[UIView 
	 animateWithDuration:UTILITY_ANIM_DURATION
	 animations:^{
		 _utilityViewSetup.center = 
		 CGPointMake(centerPoints[UTILITY_COUNT - 1 +(UTILITY_COUNT)].x + RASTER_SPACING + RASTER_SIZE+RASTER_SIZE/2, 
					 centerPoints[UTILITY_COUNT - 1 +(UTILITY_COUNT)].y);
		 _utilityViewSetup.alpha = 1;
	 }
	 completion:^(BOOL finished){
		 
	 }];
	
	// retained by superview
	[_utilityViewSetup release];

	// ************************* free1
	
	_utilityViewFree1 = [[UtilityViewFree1 alloc] initWithFrame:CGRectMake(512, 368, 2*RASTER_SIZE, RASTER_SIZE )];
	
	_utilityViewFree1.alpha = 0;
	
	[self.view addSubview:_utilityViewFree1];
	
	
	[UIView 
	 animateWithDuration:UTILITY_ANIM_DURATION
	 animations:^{
		 _utilityViewFree1.center = 
		 CGPointMake(centerPoints[UTILITY_COUNT - 1 +(2*UTILITY_COUNT)].x + RASTER_SPACING + RASTER_SIZE+RASTER_SIZE/2, 
					 centerPoints[UTILITY_COUNT - 1 +(2*UTILITY_COUNT)].y);
		 _utilityViewFree1.alpha = 1;
	 }
	 completion:^(BOOL finished){
		 
	 }];
	
	// retained by superview
	[_utilityViewFree1 release];

	// ************************* free2
	
	_utilityViewFree2 = [[UtilityViewFree2 alloc] initWithFrame:CGRectMake(512, 368, 2*RASTER_SIZE, RASTER_SIZE )];
	
	_utilityViewFree2.alpha = 0;
	
	[self.view addSubview:_utilityViewFree2];
	
	
	[UIView 
	 animateWithDuration:UTILITY_ANIM_DURATION
	 animations:^{
		 _utilityViewFree2.center = 
		 CGPointMake(centerPoints[UTILITY_COUNT - 1 +(3*UTILITY_COUNT)].x + RASTER_SPACING + RASTER_SIZE+RASTER_SIZE/2, 
					 centerPoints[UTILITY_COUNT - 1 +(3*UTILITY_COUNT)].y);
		 _utilityViewFree2.alpha = 1;
	 }
	 completion:^(BOOL finished){
		 
	 }];
	
	// retained by superview
	[_utilityViewFree2 release];
	
	// ************************* all off

	_utilityViewAllOff = [[UtilityViewAllOff alloc] initWithFrame:CGRectMake(512, 368, 2*RASTER_SIZE, RASTER_SIZE )];
	
	_utilityViewAllOff.alpha = 0;
	
	[self.view addSubview:_utilityViewAllOff];
	
	
	[UIView 
	 animateWithDuration:UTILITY_ANIM_DURATION
	 animations:^{
		 _utilityViewAllOff.center = 
		 CGPointMake(centerPoints[UTILITY_COUNT - 1 +(4*UTILITY_COUNT)].x + RASTER_SPACING + RASTER_SIZE+RASTER_SIZE/2, 
					 centerPoints[UTILITY_COUNT - 1 +(4*UTILITY_COUNT)].y);
		 _utilityViewAllOff.alpha = 1;
	 }
	 completion:^(BOOL finished){
		 
	 }];
	
	// retained by superview
	[_utilityViewAllOff release];
}

/************************************************************************************************/

-(void) archiveRootObject:(NSString *) fileName rootObject:(id) root{
	
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	NSString * filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	[NSKeyedArchiver archiveRootObject:root toFile:filePath];	
}

/************************************************************************************************/

-(id) newUnarchiveRootObject:(NSString *) fileName{
	
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	NSString * filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	return [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] retain];
}

/************************************************************************************************/

-(id) loadIndicatorsFromFile:(NSString*) fileName{
	LightIndicatorView * indicator;

	// already views present ?
	if ( _indicatorViews != nil){
		
		// first remove them form super view	
		for (indicator in _indicatorViews) {
			NSLog(@"before %d",[indicator retainCount]);
			[indicator removeFromSuperview];
			NSLog(@"after %d",[indicator retainCount]);
		}
		
		[_indicatorViews removeAllObjects];
		
		[_indicatorViews release];
		
	}
	
	// load the views form disk
	_indicatorViews = [self newUnarchiveRootObject:fileName];
	
	// check if read from disk was succesfull
	if (_indicatorViews == nil){
		return nil;
	}
	
	// loop the array and add the views to superview
	for (indicator in _indicatorViews) {
		
		// no release needed done by removefromsuperview
		[self.view addSubview:indicator];
		
		indicator.alpha = 0.1;
		
		[UIView 
		 animateWithDuration:RASTER_ANIM_DURATION 
		 animations:^{
			 indicator.alpha = 1;
		 }
		 completion:^(BOOL finished){
		 }];
		
		// refresh our values
		if ( indicator.tag != VIEW_TAG_SAVE_LIGTHS ){
			gTriosLights[indicator._index].lights.value = indicator._value;
		}

	}
	return _indicatorViews;
}

/************************************************************************************************/

-(void) saveIndicatorsToFile:(NSString*) fileName{
	// persist the raster first
	[self archiveRootObject:fileName rootObject:_indicatorViews];
}

/************************************************************************************************/

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.view.layer.borderColor = [[UIColor whiteColor]CGColor];
	self.view.layer.borderWidth = VIEW_BORDER_THIKNESS;
	
	TriosSetEthernet("192.168.1.24", 6969);
	TriosInitBuffer();
	
	[self makeArrayWithIndicatorViews];
	[self makeArrayWithUtilityViews];
	
	[iLightsTriosWrapper TriosSendGetBuffer];
	
}

/************************************************************************************************/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	LightIndicatorView * indicator;
	
	_lightIndicator = nil;
	
	for (UITouch * touch in touches){
		CGPoint point = [touch locationInView:self.view];
		for (indicator in _indicatorViews){
			if ( CGRectContainsPoint(indicator.frame,point) && ( indicator.isUserInteractionEnabled )){
				if (indicator.tag != VIEW_TAG_SAVE_LIGTHS ){
					
					_lightIndicator = indicator;
					_lightIndicator.alpha = 0.5;
					[self.view bringSubviewToFront:_lightIndicator];
					
				}
				else{
				}
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
			if ( (indicator != _lightIndicator) && ( _lightIndicator != nil && (indicator.tag != VIEW_TAG_SAVE_LIGTHS )) ){
				if ( CGRectContainsPoint(indicator.frame,point) && ( indicator.isUserInteractionEnabled ) ){
					
					indicator.alpha = 0.5;
					
					int tmpTag = indicator.tag;
					
					[UIView 
					 animateWithDuration:SWAP_ANIM_DURATION
					 animations:^{
						 indicator.center = centerPoints[_lightIndicator.tag];
						 indicator.alpha = 1; 
					 }
					 completion:^(BOOL finished){
					 }];
					
					indicator.tag = _lightIndicator.tag;
					
					[UIView 
					 animateWithDuration:SWAP_ANIM_DURATION
					 delay:0.5
					 options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 _lightIndicator.center = centerPoints[tmpTag];
						 _lightIndicator.alpha = 1; 
						 
					 }
					 completion:^(BOOL finished){
					 }];
					
					_lightIndicator.tag = tmpTag;	
					
				}
				
			}
			else {
				indicator.alpha = 1;
			}
			
		}
	}
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	_lightIndicator.alpha = 1; 
	
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
	
	
	
}

/************************************************************************************************/

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];	
	[_lightIndicator release];
	[_lightView release],
	[_utilityViewAllOff release];
	[_indicatorViews release];
    [super dealloc];
}

@end
