/*
 * File:   main.cpp
 * Author: guy
 *
 * Created on October 31, 2009, 1:39 PM
 */
#define LINUX
#define MAC0SX

#ifndef LINUX
		#include "stdafx.h"
		// not defined in winsock2
		#define MSG_WAITALL 0
#else
        #include <stdlib.h>
        #include <stdio.h>
        #include <memory.h>
        #include <unistd.h>
        #include <netinet/in.h>
		#include <sys/socket.h>
        #include <ftd2xx.h>
		#include <xmlwriter.h>
		#include <parser.h>
		#include <tree.h>
		
#endif


#define u8	UCHAR

// main defines
#define mainMAX_MSG_SIZE                256
#define mainMAX_AMOUNT_OF_MSG           16
#define mainMAX_BUFFER_SIZE             mainMAX_MSG_SIZE * mainMAX_AMOUNT_OF_MSG

//serial FTDI related defines
#define mainBAUDRATE_SERIAL1            4500000
#define mainBAUDRATE_SERIAL2            2250000
#define mainMIN_LATENCY_1MS             1

// command layout
#define mainCMD_NONE                    0x00
#define mainCMD_CORTEX_MASTER_TX        0x01
#define mainCMD_CORTEX_MASTER_RX        0x02

// cortex 1 I2C address map
#define I2C1_SLAVE_ADDRESS10_CORTEX1    0x0310
#define I2C1_SLAVE_ADDRESS7_CORTEX1     0x10
#define I2C2_SLAVE_ADDRESS10_CORTEX1    0x0320
#define I2C2_SLAVE_ADDRESS7_CORTEX1     0x20

// cortex 2 I2C address map
#define I2C1_SLAVE_ADDRESS10_CORTEX2    0x0330
#define I2C1_SLAVE_ADDRESS7_CORTEX2     0x30
#define I2C2_SLAVE_ADDRESS10_CORTEX2    0x0340
#define I2C2_SLAVE_ADDRESS7_CORTEX2     0x40

// cortex 3 I2C address map
#define I2C1_SLAVE_ADDRESS10_CORTEX3    0x0350
#define I2C1_SLAVE_ADDRESS7_CORTEX3     0x50
#define I2C2_SLAVE_ADDRESS10_CORTEX3    0x0360
#define I2C2_SLAVE_ADDRESS7_CORTEX3     0x60

// cortex 4 I2C address map
#define I2C1_SLAVE_ADDRESS10_CORTEX4    0x0370
#define I2C1_SLAVE_ADDRESS7_CORTEX4     0x70
#define I2C2_SLAVE_ADDRESS10_CORTEX4    0x0380
#define I2C2_SLAVE_ADDRESS7_CORTEX4     0x80

// socket defines
#define mainSOCKET_SERVER_PORT          8080

// message buffer
typedef struct TMESSAGE{
    u8  msg[mainMAX_MSG_SIZE];
}TMessage ,* pTMesaage;

// command buffer
typedef struct TI2CCOMMAND{
    u8      command;
    u8      address;
    u8      len_control;
    u8  *   control;
    u8      len_data;
    u8  *   data;
}TI2Ccommand ,* pTI2Ccommand;

// global storage
UCHAR       ucInfoWarnError[mainMAX_BUFFER_SIZE];
TMessage    xCommands[mainMAX_AMOUNT_OF_MSG];
TMessage    xReplies[mainMAX_AMOUNT_OF_MSG];

FT_STATUS stat;
FT_HANDLE hSer1,hSer2;

int       list_s;
int       conn_s;

struct    sockaddr_in servaddr;

#define GETSTAT(stat) if (stat != FT_OK ) return stat;

// HTML headers strings

char theHttp[256];

const char HttpMsg[]="Hello Katrieneke\n";

const char Http[]="HTTP/1.1 200 OK\n";
const char HttpLen[]="Content-Length: 17\n";
const char HttpType[]="Content-Type: text/html\n\n";

char test[4];

void ServerListen (void){

    if ( (list_s = socket(AF_INET, SOCK_STREAM, 0)) < 0 ) {
        exit(EXIT_FAILURE);
    }

    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family      = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port        = htons(mainSOCKET_SERVER_PORT);

    if ( bind(list_s, (struct sockaddr *) &servaddr, sizeof(servaddr)) < 0 ) {
        exit(EXIT_FAILURE);
    }

    if ( listen(list_s, 1) < 0 ) {
            exit(EXIT_FAILURE);
    }
}

FT_STATUS InitSerial ( void ){
	

    GETSTAT( FT_Open( 0, &hSer1 ) );
    GETSTAT( FT_Open( 1, &hSer2 ) );
    GETSTAT( FT_SetBaudRate( hSer1, mainBAUDRATE_SERIAL1 ) );
    GETSTAT( FT_SetBaudRate( hSer2, mainBAUDRATE_SERIAL2 ) );
    GETSTAT( FT_SetDataCharacteristics(hSer1,FT_BITS_8,FT_STOP_BITS_1,FT_PARITY_NONE));
    GETSTAT( FT_SetDataCharacteristics(hSer2,FT_BITS_8,FT_STOP_BITS_1,FT_PARITY_NONE));
    GETSTAT( FT_SetLatencyTimer ( hSer1 , mainMIN_LATENCY_1MS ));
    GETSTAT( FT_SetLatencyTimer ( hSer2 , mainMIN_LATENCY_1MS ));
	
	return FT_OK;
}

FT_STATUS TxRxSerial ( void){

    DWORD written,read;

    printf("TRIOS Server --> USB2I2C task begin\n");
	
	GETSTAT(FT_ResetDevice(hSer1));
	GETSTAT(FT_ResetDevice(hSer2));
	printf("Reset FTDI device OK\n");
	
    GETSTAT( FT_Write( hSer1 , xCommands   , mainMAX_BUFFER_SIZE , &written));
    printf("TRIOS Server --> USB2I2C command channel %d bytes\n",(int)written);
    GETSTAT( FT_Read ( hSer1 , xReplies    , mainMAX_BUFFER_SIZE , &read));
    printf("USB2I2C command channel --> TRIOS SERVER %d bytes\n",(int)read);

    FT_GetQueueStatus ( hSer2 ,&read );
    GETSTAT( FT_Read ( hSer2 , ucInfoWarnError, read ,&read));
    printf("USB2I2C info channel --> TRIOS SERVER %d bytes\n",(int)read);

    FT_Purge(hSer1,FT_PURGE_TX );
    FT_Purge(hSer2,FT_PURGE_RX );

    printf("TRIOS Server --> USB2I2C task done\n");

	return FT_OK;
}

/*
 *
 */
#define MY_ENCODING "UTF-8"

void
parseXml (xmlDocPtr doc, xmlNodePtr cur) {
	xmlChar * key;
	short s;
	
	cur = cur->xmlChildrenNode;
	while (cur != NULL) {
		printf(" %s \n",cur->name);
		if ((!xmlStrcmp(cur->name, (const xmlChar *)"MIN"))) {
			key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 0);
			s = atoi((const char *) key);
			printf("MIN: %s\n", key);
			xmlFree(key);
		}
		else if ((!xmlStrcmp(cur->name, (const xmlChar *)"MAX"))) {
			key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 0);
			printf("MAX: %s\n", key);
			xmlFree(key);
		}
		else if ((!xmlStrcmp(cur->name, (const xmlChar *)"VALUE"))) {
			key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 0);
			printf("VALUE: %s\n", key);
			xmlFree(key);
		}
		else if ((!xmlStrcmp(cur->name, (const xmlChar *)"STEP"))) {
			key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 0);
			printf("STEP: %s\n", key);
			xmlFree(key);
		}
		else if ((!xmlStrcmp(cur->name, (const xmlChar *)"PININ"))) {
			key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 0);
			printf("PININ: %s\n", key);
			xmlFree(key);
		}
		else if ((!xmlStrcmp(cur->name, (const xmlChar *)"PINOUT"))) {
			key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 0);
			printf("PINOUT: %s\n", key);
			xmlFree(key);
		}
		
		
		
		cur = cur->next;
	}
	
}

int main(int argc, char** argv) {

    int iResult=0;
	//int idx;
    char  ok;
	int rc;
	xmlChar * key;
	xmlTextWriterPtr pXml;
	xmlDocPtr doc = NULL;
    xmlNodePtr cur = NULL;
	xmlBufferPtr mem = NULL;
	short v = 10000;
	FILE * fd;
	
	LIBXML_TEST_VERSION
	
	pXml = xmlNewTextWriterFilename("test.xml", 0);
	//mem = xmlBufferCreate();
	//pXml = xmlNewTextWriterMemory(mem, 0);
	
	rc = xmlTextWriterSetIndent(pXml,1);
	 rc = xmlTextWriterSetIndentString(pXml,BAD_CAST " ");
	rc = xmlTextWriterStartDocument(pXml, NULL, MY_ENCODING, NULL);
	
	rc = xmlTextWriterStartElement(pXml, BAD_CAST "CORTEX1");
		rc = xmlTextWriterStartElement(pXml, BAD_CAST "OUT1");
	
			//rc = xmlTextWriterStartElement(pXml, BAD_CAST "VALUE");
			rc = xmlTextWriterWriteFormatElement(pXml, BAD_CAST "VALUE","%d",v);
			//rc = xmlTextWriterEndElement(pXml);
	
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "MIN");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "8000");
			rc = xmlTextWriterEndElement(pXml);

			rc = xmlTextWriterStartElement(pXml, BAD_CAST "MAX");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "2000");
			rc = xmlTextWriterEndElement(pXml);

			rc = xmlTextWriterStartElement(pXml, BAD_CAST "STEP");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "200");
			rc = xmlTextWriterEndElement(pXml);
	
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "PININ");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "0100");
			rc = xmlTextWriterEndElement(pXml);

			rc = xmlTextWriterStartElement(pXml, BAD_CAST "PINOUT");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "0200");
			rc = xmlTextWriterEndElement(pXml);
	
		rc = xmlTextWriterEndElement(pXml);

		rc = xmlTextWriterStartElement(pXml, BAD_CAST "OUT2");
			
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "VALUE");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "10000");
			rc = xmlTextWriterEndElement(pXml);
			
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "MIN");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "8000");
			rc = xmlTextWriterEndElement(pXml);
			
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "MAX");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "2000");
			rc = xmlTextWriterEndElement(pXml);
			
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "STEP");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "200");
			rc = xmlTextWriterEndElement(pXml);
			
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "PININ");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "0100");
			rc = xmlTextWriterEndElement(pXml);
			
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "PINOUT");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "0200");
			rc = xmlTextWriterEndElement(pXml);
	
		rc = xmlTextWriterEndElement(pXml);

		rc = xmlTextWriterStartElement(pXml, BAD_CAST "GENERAL");
		
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "GEN1");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "10000");
			rc = xmlTextWriterEndElement(pXml);
			
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "GEN2");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "8000");
			rc = xmlTextWriterEndElement(pXml);
			
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "GEN3");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "2000");
			rc = xmlTextWriterEndElement(pXml);
			
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "GEN4");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "200");
			rc = xmlTextWriterEndElement(pXml);
			
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "GEN5");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "0100");
			rc = xmlTextWriterEndElement(pXml);
			
			rc = xmlTextWriterStartElement(pXml, BAD_CAST "GEN6");
			rc = xmlTextWriterWriteString(pXml, BAD_CAST "0200");
			rc = xmlTextWriterEndElement(pXml);
		
		rc = xmlTextWriterEndElement(pXml);
	
	rc = xmlTextWriterEndElement(pXml);
	rc = xmlTextWriterEndDocument(pXml);
	
	xmlFreeTextWriter(pXml);
	
	doc = xmlParseFile("test.xml");
	doc = xmlReadFile("test.xml", MY_ENCODING, XML_PARSE_NOBLANKS);
	
	//doc = xmlParseMemory((const char* )mem->content, mem->use);
	
	cur = xmlDocGetRootElement(doc);
	
	//key = xmlNodeListGetString(doc,cur,0);
	
	printf (" %s \n", key);
		
	
	if (xmlStrcmp(cur->name, (const xmlChar *) "CORTEX1")) {
		fprintf(stderr,"document of the wrong type, root node != CORTEX1");
		xmlFreeDoc(doc);
		return -1;
	}
	
	cur = cur->xmlChildrenNode;

	while (cur != NULL) {
		printf(" %s \n",cur->name);
		if ((! xmlStrcmp(cur->name, (const xmlChar *)"OUT1"))){
			parseXml(doc,cur);
			
		}
		else if ((! xmlStrcmp(cur->name, (const xmlChar *)"OUT2"))){
			parseXml(doc,cur);
		}
		
		cur = cur->next;
	}
	
	//fflush(stdout);
	
	xmlBufferFree(mem);
	xmlCleanupParser();
	
	#ifndef LINUX
        WSADATA wsaData;
        iResult = WSAStartup(MAKEWORD(2,2), &wsaData);
        if (iResult != NO_ERROR) {
          printf("WSAStartup failed: %d\n", iResult);
          return 1;
        }
    #endif

    GETSTAT ( InitSerial() );
    ServerListen();

    printf("TRIOS Server --> started\n");

    while ( iResult >= 0 ){

        if ( (conn_s = accept(list_s, NULL, NULL) ) < 0 ) {
                exit(EXIT_FAILURE);
        }

        printf ("TRIOS Server --> connection accepted\n ");
		fd= fdopen(conn_s,"w+");
		fread(xCommands, 1 , 256 , fd);
		
		
		while (iResult >= 0){

            iResult =recv( conn_s, ((char *)xCommands) , mainMAX_BUFFER_SIZE , MSG_WAITALL );
			
			//iResult =recv( conn_s, ((char *)xReplies) , iResult , MSG_WAITALL );
            //printf ("Host program --> TRIOS server %d bytes\n",iResult );
			//printf("%s",(char *)xReplies);
			//fflush(stdout);

			//strcat(theHttp, Http);
            //strcat(theHttp, HttpLen);
            //strcat(theHttp, HttpType);
            //strcat(theHttp, HttpMsg);
            
			//send(conn_s,theHttp,strlen(theHttp),MSG_WAITALL);
			
			//theHttp[0] = 0;
			
			//			break;
			
			TxRxSerial();

            iResult =send( conn_s, (const char *)xReplies , mainMAX_BUFFER_SIZE , MSG_WAITALL);
            printf ("TRIOS Server command channel --> Host program %d bytes\n",iResult );

            iResult =send( conn_s, (const char *)ucInfoWarnError    , mainMAX_BUFFER_SIZE , MSG_WAITALL);
            printf ("TRIOS Server info channel --> Host program %d bytes\n",iResult );

            iResult =recv( conn_s, &ok , 1 , MSG_WAITALL);
            printf ("Host program ack --> TRIOS server %d bytes\n",iResult );

            if ( (ok == 0x5A) && (iResult >= 0) ){
                printf ("TRIOS Server --> OK received \n");
                continue;
            }
            else{
                printf ("TRIOS Server --> Abort received\n");
                break;
            }
		
			
        }

        #ifdef LINUX
            shutdown(conn_s,SHUT_RDWR);
            close( conn_s );
            printf ("TRIOS Server --> Host connection closed");
        #else
            shutdown(conn_s,SD_BOTH);
            closesocket( conn_s );
        #endif
    }

    FT_Close(hSer1);
    FT_Close(hSer2);
    #ifdef LINUX
	    close(list_s);
	#else
		closesocket(conn_s);
	#endif

    return (EXIT_SUCCESS);
}

