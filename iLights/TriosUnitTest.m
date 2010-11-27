//
//  TriosUnitTest.m
//  iLights
//
//  Created by Guy Van Overtveldt on 27/11/10.
//  Copyright 2010 ATOS worldline. All rights reserved.
//

#import "TriosUnitTest.h"


@implementation TriosUnitTest

                  
- (void) testTriosCommunication{
	int err;
	
	TriosSetEhternet("192.168.1.25", 6969);
	TriosInitBuffer();
	err = TriosSendGetBuffer();
	
	STAssertTrue (err == TRIOS_ERROR_OK ,@"Trios communication failed with err %d" ,err);	
}

@end
