//
//  Tests.m
//  iTrios
//
//  Created by Guy Van Overtveldt on 26/11/10.
//  Copyright 2010 ATOS worldline. All rights reserved.
//

#import "Tests.h"


@implementation Tests

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void) testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void) testMath {
    
    STAssertTrue((1+3)==2, @"Compiler isn't feeling well today :-(" );
    
}


#endif


@end