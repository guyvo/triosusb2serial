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
@synthesize otherView;
@synthesize trios;
@synthesize button;


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
- (IBAction) switchBack2:(id)sender{
}

- (IBAction) switchBack:(id)sender{
	/*
	[UIView transitionFromView:trios
						toView:trios 
					  duration:1.0 
					   options:  UIViewAnimationOptionCurveEaseInOut |   UIViewAnimationOptionTransitionCurlUp  
					completion:^(BOOL finished){
						
					}
	 
	 ];
	 */
	self.view = otherView;
	
}
- (IBAction) switchViews:(id)sender{
	/*
	[UIView transitionFromView:trios
						toView:trios 
					  duration:1.0 
					   options:  UIViewAnimationOptionCurveEaseInOut |   UIViewAnimationOptionTransitionCurlUp  
					completion:^(BOOL finished){
						
					}
	 ];
	*/
	
	CGPoint p = trios.center;
	float a = trios.alpha;
	
	[UIView animateWithDuration:1.0 
					 animations:^{
						 [trios setCenter:CGPointMake(p.x + 100, p.y)];
						 [trios setAlpha:0.1];
						 
					 }
	 
					 completion:^(BOOL finished){
						 [UIView animateWithDuration:5
											   delay:1
											 options:UIViewAnimationOptionOverrideInheritedDuration
										  animations:^{
											  [trios setCenter:p];
											  [trios setAlpha:1.0];
											  
										  }
										  completion:^(BOOL finished){ }
						  
						  ];
					 }
	 ];
	/*
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatCount:0];
	[UIView setAnimationRepeatAutoreverses:NO];
	[trios setCenter:CGPointMake(p.x + 100, p.y)];
	[trios setAlpha:0.1];
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatCount:0];
	[UIView setAnimationRepeatAutoreverses:NO];
	[trios setCenter:p];
	[trios setAlpha:a];
	[UIView commitAnimations];
	*/
}

- (void) start{
	[active startAnimating];
	
}

-(void) work:(id)anObject {
	int err;
	
	err = TriosSendGetBuffer();
	
	[NSThread sleepForTimeInterval:0.5];

	err = TriosSendPostBuffer();

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
	[button release];
	[trios release];
	[otherView release];
	[active release];
    [super dealloc];
}

@end
