//
//  iLightsViewController.m
//  iLights
//
//  Created by guy on 27/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "iLightsViewController.h"

@implementation iLightsViewController

@synthesize active;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) start{
	[active startAnimating];
	
}

-(void) work:(id)anObject {
	int err;
	
	err = TriosSendGetBuffer();
	
	[NSThread sleepForTimeInterval:0.5];

	[active stopAnimating];	

	[NSThread exit];
}

-(void) doUpdate:(NSTimer *) timer{
	
	[active startAnimating];
	[NSThread detachNewThreadSelector:@selector(work:) toTarget:self withObject:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	TriosSetEhternet("192.168.1.24", 6969);
	TriosInitBuffer();

	update = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(doUpdate:) userInfo:nil repeats:YES];
	
	[active setFrame:CGRectMake(0, 0, 100, 100)];
	[active setCenter:CGPointMake(368, 512)];

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
	self.active = nil;
}


- (void)dealloc {
	[active release];
    [super dealloc];
}

@end
