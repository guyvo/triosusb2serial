//
//  iLightsTriosWrapper.h
//  iLights
//
//  Created by Guy Van Overtveldt on 27/11/10.
//  Copyright 2010 ATOS worldline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "triosIncludes.h"

/* 
 C function wrapper class used to signal 
 notification events to iOS NotificationCenter
 -> decoupled ANSI-C module from OBJ-C
*/ 

@interface iLightsTriosWrapper : NSObject {

}

// class methods
+(int) TriosSendPostBuffer;
+(int) TriosSendGetBuffer;

@end
