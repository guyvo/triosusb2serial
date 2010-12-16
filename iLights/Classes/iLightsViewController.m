//
//  iLightsViewController.m
//  iLights
//
//  Created by guy on 27/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "iLightsViewController.h"

@interface iLightsViewController()

@end

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
	
	TriosSetEthernet("192.168.1.24", 6969);
	TriosInitBuffer();
	
	for (int rows = 0 ; rows < 5; rows++){
		for (int i = 0; i<5; i++) {
			
			
			_lightIndicator[i+(rows*5)] = [[LightIndicator alloc] initWithMinimum:0 
															  andMaximum:100 
																andIndex:0 
																andValue:100 - (i*25)
																 andName:[NSString stringWithCString:gpCLightNames[i] encoding:NSUTF8StringEncoding]
																andFrame:CGRectMake(0, 0, 140, 140 )];
			
			[_lightIndicator[i+(rows*5)] setFrameCenter:CGPointMake(75+(i*145),75 + (rows*145))];
			
			[self.view addSubview:_lightIndicator[i+(rows*5)]];
			
		}
	}
	
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
