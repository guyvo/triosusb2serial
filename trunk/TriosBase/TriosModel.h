/*! \file TriosModel.h
 *  TriosBase
 *
 *  Created by Guy Van Overtveldt on 11/09/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

/*! \struct Light
	\brief declaration of the light
 
*/

#ifndef __TriosModel__
#define __TriosModel__

#define MAXLIGHTS			6
#define MESSAGELENGTH		256
#define DATABUFFERLENGTH	4096
#define MESSAGES			DATABUFFERLENGTH/MESSAGELENGTH

typedef struct Light {
	unsigned short value;
	unsigned short minimum;
	unsigned short maximum;
	unsigned short step;
	unsigned short pinmaskin;
	unsigned short pinmaskout;
} TLight,* pTLight;

typedef struct Cortex{
	unsigned short temperature;
	unsigned short watchdogs;
	unsigned short toggles;
	unsigned short dimmers;
	unsigned short hours;
	unsigned short masks;
} TCortex,* pTCortex;

typedef struct MessageHeader{
	unsigned char command;
	unsigned char address;
	unsigned char commandlength;
	unsigned char datalength;
} TMessageHeader, *pTMessageHeader;

typedef struct Message{
	TMessageHeader	header;
	TLight			lights[MAXLIGHTS];
	TCortex			cortex;
} TMessage , * pTMessage;

typedef struct Data{
	TMessage data[MESSAGES];
} TData, * pTData;

typedef TData TTriosDataBuffer; 

#endif