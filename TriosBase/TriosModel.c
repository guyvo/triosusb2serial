/*! \file TriosModel.c
 *  TriosBase
 *
 *  Created by Guy Van Overtveldt on 11/09/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <errno.h>
#include "TriosModel.h"


/**
* \defgroup Golbals Global Variables
*/

/*@{*/

/** 
 The global data buffer hidden in this module \n
 All functions are provided in the headerfile
 \note size is limited to 4k
*/ 

TTriosDataBuffer gData;
TTriosDataBuffer gTemp;


/*@}*/

/****************************************************************************/

int TriosGetBufferSize (void){
	return sizeof(gData);
}

/****************************************************************************/

void TriosClearBuffer (void){
	memset(&gData,0,sizeof(gData));
}

/****************************************************************************/

pTTriosDataBuffer TriosGetBuffer (void){
	return &gData;
}

/****************************************************************************/

pTMessage TriosGetMessage (EMSG msg){
	return &gData.data[msg];
}

/****************************************************************************/

pTLight TriosGetLightFromMessage (ELIGHTS light, EMSG msg){
	return &gData.data[msg].lights[light];
}

/****************************************************************************/

void TriosPrepareGetInMessage (EMSG msg , ECORTEXGETADR adr){
	gData.data[msg].header.command = eCMDGET;
	gData.data[msg].header.commandlength = 0;
	gData.data[msg].header.address = adr;
	gData.data[msg].header.datalength = (sizeof(TLight) * 6) + sizeof (TCortex);
}

/****************************************************************************/

void TriosPreparePutInMessage (EMSG msg , ECORTEXPUTADR adr){
	gData.data[msg].header.command = eCMDPUT;
	gData.data[msg].header.commandlength = 0;
	gData.data[msg].header.address = adr;
	gData.data[msg].header.datalength = (sizeof(TLight) * 6) + sizeof (TCortex);
}

/****************************************************************************/

void TriosSetLightValueInMessage (cortexint value , ELIGHTS light, EMSG msg ){
	if ( ( value > LIGHTVALUEMIN ) && ( value < LIGHTVALUEMAX )){
		gData.data[msg].lights[light].value = value;
	}
}

/****************************************************************************/

int TriosTransmitBuffer (void){
	int client;
	struct sockaddr_in adr;
	int bytes;
		
	adr.sin_family = AF_INET;
	adr.sin_port = htons(6969); /* must be arg */
	adr.sin_addr.s_addr = inet_addr("127.0.0.1"); /* must be arg */
	
	client = socket(PF_INET, SOCK_STREAM, 0);
	
	if ( connect( client,(struct sockaddr *)&adr, sizeof(adr)) == -1 ){
		return errno;
	}
	
	if ( send(client, &gData,sizeof(gData), 0 ) == -1){
		return errno;
	}
	
	bytes = recv(client, &gTemp, sizeof(gTemp),0 );
	if ( bytes == -1){
		return errno;
	}
	printf("bytes received : %d\n",bytes);
	
	close(client);
	return 0;
}

/****************************************************************************/
