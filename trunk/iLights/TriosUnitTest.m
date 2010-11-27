//
//  TriosUnitTest.m
//  iLights
//
//  Created by Guy Van Overtveldt on 27/11/10.
//  Copyright 2010 ATOS worldline. All rights reserved.
//

#import "TriosUnitTest.h"
#import <unistd.h>

#define AMOUNT_OF_TESTS				100
#define LANTRONICS_CLEANUP_DELAY	15000 // in us

@implementation TriosUnitTest

TLightModel		lights[MAXLIGHTS*AMOUNT_OF_CORTEXES];
int				err;

- (void) testTriosGetBufferCompare{
	TriosSetEhternet("192.168.1.24", 6969);
	TriosInitBuffer();
	err = TriosSendGetBuffer();
	
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
	TriosSetEhternet("192.168.1.24", 6969);
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
