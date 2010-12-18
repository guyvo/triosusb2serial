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
-(void) makeButtonUtilities;
-(void) archiveRootObject:(NSString *) fileName rootObject:(id)root ;
- (id) unarchiveRootObject:(NSString *) fileName;
@end

@implementation iLightsViewController

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
									   andFrame:CGRectMake(0, 0, RASTER_SIZE, RASTER_SIZE )];
		
		[_lightIndicator setFrameCenter:centerPoints[views]];
		
		[self.view addSubview:_lightIndicator];
		
		[_indicatorViews addObject:_lightIndicator];

	
	}
	
	//[self archiveRootObject:@"/myview.archive" rootObject:_indicatorViews];
}

// makeArrayWithIndicatorViews must be called first otherwise the result is unpredictable
-(void) makeButtonUtilities{
	_utilityViews = [[NSMutableArray alloc] initWithCapacity:5];
	
	for ( int views = 0 ; views < 5 ; views++){
		_utililtyView = [[UtilityView alloc] initWithFrame:CGRectMake(0, 0, 2*RASTER_SIZE, RASTER_SIZE )];
		_utililtyView.center = CGPointMake(centerPoints[4+(views*5)].x + RASTER_SPACING + RASTER_SIZE+RASTER_SIZE/2, 
										   centerPoints[4+(views*5)].y);
		
		[self.view addSubview:_utililtyView];								   
		
		[_utilityViews addObject:_utililtyView];
	}
}

-(void) archiveRootObject:(NSString *) fileName rootObject:(id) root{
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	NSString * filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	[NSKeyedArchiver archiveRootObject:root toFile:filePath];	
}

-(id) unarchiveRootObject:(NSString *) fileName{
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	NSString * filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (void)viewDidLoad {

    [super viewDidLoad];
	
	self.view.layer.borderColor = [[UIColor whiteColor]CGColor];
	self.view.layer.borderWidth = 2;
	
	TriosSetEthernet("192.168.1.24", 6969);
	TriosInitBuffer();
	
	[iLightsTriosWrapper TriosSendGetBuffer];

				   
	[self makeArrayWithIndicatorViews];
	[self makeButtonUtilities];	
	
	//_indicatorViews = [self unarchiveRootObject:@"/myview.archive"];
	/*
	LightIndicator * indicator;
	
	for (indicator in _indicatorViews) {
		
		[self.view addSubview:indicator];
	}
	 */
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	
}

- (void)dealloc {
    [super dealloc];
}

@end
