/*! 
*  \file TriosModel.h
*  TriosBase
*
*  \author Guy Van Overtveldt 
*  \date 11/09/10
*  Copyright 2010 __MyCompanyName__. All rights reserved.
*
*/

/*!
 \struct Light
 \brief The Light structure
 
 \typedef TLight
 \brief The TLight type
 
 \typedef pTLight
 \brief The Pointer to TLight
 
 \struct Cortex
 \brief The Cortex structure 

 \typedef TCortex 
 \brief The TCortex type
 
 \typedef pTCortex
 \brief The Pointer to TCortex
 
 \struct Header
 \brief The Header structure
 
 \typedef TMessageHeader 
 \brief The TMessageHeader type
 
 \typedef pTMessageHeader
 \brief The Pointer to TMessageHeader
 
 \struct Message
 \brief The Messages structure
 
 \typedef TMessage 
 \brief The TMessages type
 
 \typedef pTMessage
 \brief The Pointer to TMessages
 
 \struct Data
 \brief The Data structure
 
 \typedef TData 
 \brief The TData type

 \typedef pTData
 \brief The Pointer to TData

 \typedef EMSG
 Message enumeration for readbility
 \note use <i> eMSG1 </i> for index 0

 \typedef ECMD
 The command to execute for a message
 \note Only get and put implemented

 \typedef ECORTEXGETADR
 The I2C addresses to issue a get command

 \typedef ECORTEXPUTADR
 The I2C addresses to issue a put command
 
 \typedef ELIGHTS
 The light index to point to light struct
*/


#ifndef __TriosModel__ 
#define __TriosModel__

#define MAXLIGHTS			6								/*!< */
#define MESSAGELENGTH		256								/*!< */
#define DATABUFFERLENGTH	4096							/*!< */
#define MESSAGES			DATABUFFERLENGTH/MESSAGELENGTH	/*!< */

#define FREESIZE			MESSAGELENGTH - \
							sizeof(TMessageHeader) - \
							sizeof(TCortex) - \
							(sizeof(TLight)*MAXLIGHTS)
/*!< Free bytes in a message needed to have the correct total size for struct */

#define LIGHTVALUEMIN		0								/*!< max light */
#define LIGHTVALUEMAX		10000							/*!< min light */

/***********************TYPEDEFS*********************************************/

/*! shorter */
typedef unsigned short cortexint;

typedef enum 
{eMSG1,eMSG2,eMSG3,eMSG4,eMSG5,eMSG6,eMSG7,eMSG8,
 eMSG9,eMSG10,eMSG11,eMSG12,eMSG13,eMSG14,eMSG15,eMSG16} EMSG;

typedef enum 
{	eCMDPUT=0x01,
	eCMDGET=0x02 } ECMD;

typedef enum
{	eCORTEX1GETADR=0x10,
	eCORTEX2GETADR=0x30,
	eCORTEX3GETADR=0x50,
	eCORTEX4GETADR=0x70 } ECORTEXGETADR;

typedef enum
{	eCORTEX1PUTADR=0x20,
	eCORTEX2PUTADR=0x40,
	eCORTEX3PUTADR=0X60,
	eCORTEX4PUTADR=0x80 } ECORTEXPUTADR;

typedef enum
{	eLIGHT1,
	eLIGHT2,
	elIGHT3,
	eLIGHT4,
	eLIGHT5,
	eLIGHT6 } ELIGHTS;

typedef struct Header{
	unsigned char command;/*!< @see ECMD */
	unsigned char address;/*!< @see ECORTEXGETADR,ECORTEXPUTADR */
	unsigned char commandlength;/*!< always 0 not used*/
	unsigned char datalength;/*!< light and cortex struct size*/
} TMessageHeader, *pTMessageHeader;

typedef struct Light{
	unsigned short value;/*!< value between 0 and 10000 */
	unsigned short minimum;/*!< */
	unsigned short maximum;/*!< */
	unsigned short step;/*!< */
	unsigned short pinmaskin;/*!< */
	unsigned short pinmaskout;/*!< */
} TLight,* pTLight;

typedef struct Cortex{
	unsigned short temperature;/*!< readonly*/
	unsigned short watchdogs;/*!< readonly*/
	unsigned short toggles;/*!< readonly*/
	unsigned short dimmers;/*!< readonly*/
	unsigned short hours;/*!< readonly*/
	unsigned short masks;/*!< read/write*/
} TCortex,* pTCortex;

typedef struct Message{
	TMessageHeader	header;/*!< */
	TLight			lights[MAXLIGHTS];/*!< @see MAXLIGHTS */
	TCortex			cortex;/*!< */
	unsigned char	free[FREESIZE];/*!< @see FREESIZE */ 
} TMessage , * pTMessage;

typedef struct Data{
	TMessage data[MESSAGES];/*!< @see MESSAGES */
} TData, * pTData;

typedef TData TTriosDataBuffer;/*!< */
typedef pTData pTTriosDataBuffer;/*!< */

/*************************FUNCTIONS*******************************************/
/*!
 Gets the begin address of the buffer
 @return buffer address
*/

pTTriosDataBuffer TriosGetBuffer (void);
/****************************************************************************/
/*!
 Gets the buffer size
 @return the buffer size in bytes
*/

int TriosGetBufferSize (void);
/****************************************************************************/
/*!
 Clears the data buffer with zero
*/ 

void TriosClearBuffer (void);
/****************************************************************************/
/*!
 Gets a pointer to the given msg index
 @param msg the message index @see EMSG
 @return the pointer to the message
 \note Using return pointer modifies buffer directly !
*/ 

pTMessage TriosGetMessage (EMSG msg);
/****************************************************************************/
/*!
 Gets a pointer to the a light struct
 @param light The light index 
 @param msg The message index to look into 
 @return The pointer to the light struct
 \note Using return pointer modifies buffer directly !
*/ 

pTLight TriosGetLightFromMessage (ELIGHTS light, EMSG msg);
/****************************************************************************/
/*!
 Sets the header to execute a get command for a given cortex
 @param msg the message index
 @param adr the cortex address
*/ 

void TriosPrepareGetInMessage (EMSG msg , ECORTEXGETADR adr);
/****************************************************************************/
/*!
 Sets the header to execute a put command for a given cortex
 @param msg the message index
 @param adr the cortex address
*/ 

void TriosPreparePutInMessage (EMSG msg , ECORTEXPUTADR adr);
/****************************************************************************/
/*!
 Sets the light value pointed to by light index for a given message
 @param value the light value
 @param light the light index
 @param msg the message index
 */ 
void TriosSetLightValueInMessage (cortexint value , ELIGHTS light, EMSG msg );
/****************************************************************************/
/*!
 Sends the buffer and receives the answer using TCP berkeley socket blocking
 @return errorcode
 \note Buffer must have 4k byte size
 */ 
int TriosTransmitBuffer (void);
/****************************************************************************/
#endif