//
//  iLightsViewController.m
//  iLights
//
//  Created by guy on 27/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "iLightsViewController.h"

@implementation iLightsViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	TriosSetEhternet("192.168.1.24", 6969);
	TriosInitBuffer();
	
	for (int rows = 0 ; rows < 4; rows++){
		for (int i = 0; i<6; i++) {
			
			
			_lightIndicator[i+(rows*6)] = [[LightIndicator alloc] initWithMinimum:0 
															  andMaximum:100 
																andIndex:0 
																andValue:100 - (i*20) 
																 andName:[NSString stringWithCString:gpCLightNames[i+(rows*6)]]
																andFrame:CGRectMake(0, 0, 150, 150 )];
			
			[_lightIndicator[i+(rows*6)] setFrameCenter:CGPointMake(75+(i*155),75 + (rows*155))];
			
			[self.view addSubview:_lightIndicator[i+(rows*6)]];
			
		}
	}
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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
