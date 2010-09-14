/*! \file TriosModel.h
 *  TriosBase
 *
 *  \author Guy Van Overtveldt 
 *	\date 11/09/10
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

/*! \struct Light
 \brief The Light structure
*/

/*! \typedef TLight
 \brief The TLight type
*/

/*! \typedef pTLight
 \brief The Pointer to TLight
*/

/*! \struct Cortex
 \brief The Cortex structure
*/

/*! \typedef TCortex 
 \brief The TCortex type
*/

/*! \typedef pTCortex
 \brief The Pointer to TCortex
*/

/*! \struct Header
 \brief The Header structure
*/

/*! \typedef TMessageHeader 
 \brief The TMessageHeader type
*/

/*! \typedef pTMessageHeader
 \brief The Pointer to TMessageHeader
*/

/*! \struct Message
 \brief The Messages structure
 */

/*! \typedef TMessage 
 \brief The TMessages type
 */

/*! \typedef pTMessage
 \brief The Pointer to TMessages
 */

/*! \struct Data
 \brief The Data structure
 */

/*! \typedef TData 
 \brief The TData type
 */

/*!
 \typedef pTData
 \brief The Pointer to TData
 \typedef EMSG
 Message enumeration for readbility
 \note use <i> eMSG1 </i> for index 0
*/


#ifndef __TriosModel__ 
#define __TriosModel__

#define MAXLIGHTS			6								/*!< */
#define MESSAGELENGTH		256								/*!< */
#define DATABUFFERLENGTH	4096							/*!< */
#define MESSAGES			DATABUFFERLENGTH/MESSAGELENGTH	/*!< */

/***************************************************/

typedef enum 
{eMSG1,eMSG2,eMSG3,eMSG4,eMSG5,eMSG6,eMSG7,eMSG8,
 eMSG9,eMSG10,eMSG11,eMSG12,eMSG13,eMSG14,eMSG15,eMSG16} EMSG;

typedef struct Light{
	unsigned short value;/*!< value between 0 and 10000 */
	unsigned short minimum;/*!< */
	unsigned short maximum;/*!< */
	unsigned short step;/*!< */
	unsigned short pinmaskin;/*!< */
	unsigned short pinmaskout;/*!< */
} TLight,* pTLight;

typedef struct Cortex{
	unsigned short temperature;/*!< */
	unsigned short watchdogs;/*!< */
	unsigned short toggles;/*!< */
	unsigned short dimmers;/*!< */
	unsigned short hours;/*!< */
	unsigned short masks;/*!< */
} TCortex,* pTCortex;

typedef struct Header{
	unsigned char command;/*!< */
	unsigned char address;/*!< */
	unsigned char commandlength;/*!< */
	unsigned char datalength;/*!< */
} TMessageHeader, *pTMessageHeader;

typedef struct Message{
	TMessageHeader	header;/*!< */
	TLight			lights[MAXLIGHTS];/*!< @see MAXLIGHTS */
	TCortex			cortex;/*!< */
} TMessage , * pTMessage;

typedef struct Data{
	TMessage data[MESSAGES];/*!< */
} TData, * pTData;

typedef TData TTriosDataBuffer;/*!< */

/***************************************************/

/*!
	Clears the data buffer with zero
*/ 

void TriosClearBuffer (void);

/*!
 Gets a pointer to the given msg
 @param msg the message number @see EMSG
 @return the pointer to the message
*/ 

pTMessage TriosGetMessage (EMSG msg);

#endif