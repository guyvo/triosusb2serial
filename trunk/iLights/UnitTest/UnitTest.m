//
//  UnitTest.m
//  UnitTest
//
//  Created by Guy Van Overtveldt on 12/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UnitTest.h"
#import <unistd.h>

#define AMOUNT_OF_TESTS				10
#define LANTRONICS_CLEANUP_DELAY	20000 // in us

@implementation UnitTest

TLightModel		lights[MAXLIGHTS*AMOUNT_OF_CORTEXES];
int				err;

- (void) testTriosGetBufferCompare{
    TriosSetEthernet("192.168.1.250", 6969);
	TriosInitBuffer();
	err = TriosSendGetBuffer();
	printf("start ....\n");
	STAssertTrue (err == TRIOS_ERROR_OK ,@"Trios communication failed with err %d" ,err);
	memcpy ( &lights , &gTriosLights , sizeof(lights));
	
	usleep(LANTRONICS_CLEANUP_DELAY);	
	
	
	for (int i=0; i<AMOUNT_OF_TESTS; i++) {
		
		err = TriosSendGetBuffer();
		STAssertTrue (err == TRIOS_ERROR_OK ,@"Trios communication failed with err %d" ,err);
		
		STAssertEquals (memcmp(lights, gTriosLights, sizeof(lights)), 0 , @"Buffer not equal !");
		
		usleep(LANTRONICS_CLEANUP_DELAY);
		
	}
}

- (void) testTriosGetPost{
    TriosSetEthernet("192.168.1.250", 6969);
	TriosInitBuffer();
	
	for (int i=0; i<AMOUNT_OF_TESTS; i++) {
		
		err = TriosSendGetBuffer();
		
		STAssertTrue (err == TRIOS_ERROR_OK ,@"Trios communication failed with err %d" ,err);
		
		usleep(LANTRONICS_CLEANUP_DELAY);	
		
		err = TriosSendPostBuffer();
		
		STAssertTrue (err == TRIOS_ERROR_OK ,@"Trios communication failed with err %d" ,err);
		
		usleep(LANTRONICS_CLEANUP_DELAY);
	}
}

@end
