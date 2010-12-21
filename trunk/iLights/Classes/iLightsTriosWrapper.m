//
//  iLightsTriosWrapper.m
//  iLights
//
//  Created by Guy Van Overtveldt on 27/11/10.
//  Copyright 2010 ATOS worldline. All rights reserved.
//

#import "iLightsTriosWrapper.h"


@implementation iLightsTriosWrapper

-(void) initWithNotications{
	
}

+(int) TriosSendPostBuffer {
	// TODO signal post here
	return TriosSendPostBuffer();
}

+(int) TriosSendGetBuffer {
	int err;
	
	err = TriosSendGetBuffer();
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE  object: self]; 
	
	return err;
	
}

@end
