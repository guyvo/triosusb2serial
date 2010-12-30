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
-(id)   unarchiveRootObject:(NSString *) fileName;
-(id)   loadIndicatorsFromFile:(NSString*) fileName;

@end

@implementation iLightsViewController

@synthesize
_lightIndicator,
_lightView,
_utililtyView,
_indicatorViews,
_utilityViews
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
	
	_utilityViews = [[NSMutableArray alloc] initWithCapacity:5];
	
	for ( int views = 0 ; views < UTILITY_COUNT ; views++){
		
		_utililtyView = [[UtilityView alloc] initWithFrame:CGRectMake(512, 368, 2*RASTER_SIZE, RASTER_SIZE )];
		
		_utililtyView.tag = views + 24;
		_utililtyView.alpha = 0;
		
		[self.view addSubview:_utililtyView];
		
		
		[UIView 
		 animateWithDuration:UTILITY_ANIM_DURATION
		 animations:^{
			 _utililtyView.center = 
			 CGPointMake(centerPoints[UTILITY_COUNT - 1 +(views*UTILITY_COUNT)].x + RASTER_SPACING + RASTER_SIZE+RASTER_SIZE/2, 
						 centerPoints[UTILITY_COUNT - 1 +(views*UTILITY_COUNT)].y);
			 _utililtyView.alpha = 1;
		 }
		 completion:^(BOOL finished){
			 
		 }];
		
		// store them for later use in touches
		[_utilityViews addObject:_utililtyView];
		
		// retained by superview
		[_utililtyView release];
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

-(id) loadIndicatorsFromFile:(NSString*) fileName{
	LightIndicatorView * indicator;
	NSMutableArray * temp;
	
	// in autorelease pool
	temp = [self unarchiveRootObject:fileName];
	
	if (temp != nil){
		if ( _indicatorViews != nil){
			for (indicator in _indicatorViews) {
				[indicator removeFromSuperview];
			}
			
			[_indicatorViews release];
		}
		
		_indicatorViews = [self unarchiveRootObject:fileName];
		
		// retain array after loaded from archive
		[_indicatorViews retain];
		
		for (indicator in _indicatorViews) {
			[self.view addSubview:indicator];
			
			indicator.alpha = 0.1;
			
			[UIView 
			 animateWithDuration:RASTER_ANIM_DURATION 
			 animations:^{
				 indicator.alpha = 1;
			 }
			 completion:^(BOOL finished){
			 }];
			
			if ( indicator.tag != VIEW_TAG_SAVE_LIGTHS ){
				gTriosLights[indicator._index].lights.value = indicator._value;
			}
		}
		
		return _indicatorViews;
	}
	return nil;
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
	
	
	// Release any retained subviews of the main view.
	LightIndicatorView * indicator;
	
	for (indicator in _indicatorViews) {
		[indicator release];
	}
	
	[_indicatorViews release];
	
	_indicatorViews = nil;
	
	UtilityView * utilityView;
	
	for (utilityView in _utilityViews ){
		[utilityView release];
	}
	
	[_utilityViews release];
	
	_utililtyView = nil;
	
	
}

/************************************************************************************************/

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];	
	[_lightIndicator release];
	[_lightView release],
	[_utililtyView release];
	[_indicatorViews release];
	[_utilityViews release];
    [super dealloc];
}

@end
