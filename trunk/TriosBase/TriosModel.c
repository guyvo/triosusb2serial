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
#include "names.h"

/**
* \defgroup Golbals Global Variables
*/

/*@{*/

/** 
 The global data buffer hidden in this module \n
 All functions are provided in the headerfile
 \note size is limited to 1k
*/ 

TTriosDataBuffer	gData;
TLightModel			gTriosLights;

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

int TriosTransmitBuffer (char * ip , int port){

	pUCTriosDataBuffer	pUCData;
	struct sockaddr_in	xSocketAddress;
	int					iClientSocket;
	int					iReallyReceived;
	int					iToReceive;
	int					iBufferSize;
	
	/* calculate only once buffer size */
	iBufferSize = TriosGetBufferSize();
	
	/* address spec given in by args */
	xSocketAddress.sin_family = AF_INET;
	xSocketAddress.sin_port = htons(port); /* must be arg */
	xSocketAddress.sin_addr.s_addr = inet_addr(ip); /* must be arg */
	
	/* realiable socket connection */
	iClientSocket = socket(PF_INET, SOCK_STREAM, 0);
	
	/* establisch connection with server end point */
	if ( connect( iClientSocket,(struct sockaddr *)&xSocketAddress, sizeof(xSocketAddress)) == -1 ){
		return errno;
	}
	
	/* send our prepared buffer */
	if ( send(iClientSocket, &gData, iBufferSize, 0 ) == -1){
		return errno;
	}
	
	/* start of buffer to recv */
	pUCData = (pUCTriosDataBuffer)&gData;
	
	/* first try to recv */
	iReallyReceived = recv(iClientSocket, pUCData , iBufferSize, 0);
	
	/* issue error already no need to continue */
	if (iReallyReceived == -1) {
		return errno;
	}
	
	/* prepare next write location */
	pUCData += iReallyReceived;
	
	/* calculate the recv bytes so far */
	iToReceive = iBufferSize - iReallyReceived;
	
	/* check if have a complete buffer continue to recv if needed */
	while ( iToReceive != 0 ) {
		
		/* get next chunk of bytes */
		iReallyReceived = recv(iClientSocket, pUCData , iToReceive , 0);
		
		/* issue error no need to continue so close socket */
		if (iReallyReceived == -1) {
			close(iClientSocket);
			return errno;
		}		
		
		/* prepare next position */
		pUCData += iReallyReceived;
		
		/* calculate the recv bytes so far */
		iToReceive -= iReallyReceived;
	}
	
	/* if reach this point all went well so close socket */
	close(iClientSocket);
	
	/* return OK */
	return TRIOS_ERROR_OK;
}

/****************************************************************************/
