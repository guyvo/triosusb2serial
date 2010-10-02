
/*! \file main.c

*/


/*! \mainpage My Personal Index Page
 *
 * \section intro_sec Introduction
 *
 * This is the introduction.
 *
 * \section install_sec Installation
 *
 * \subsection step1 Step 1: Opening the box
 *
 * etc...
*/

#include <stdio.h>
#include <sys/socket.h>
#include "TriosModel.h"

/*! \fn int main (int argc, const char * argv[])
 \param argc number of command line arguments
 \param argv string list containing the arguments
*/ 
int main (int argc, const char * argv[]) {
	int err;
	int looper;
	
    printf("buffer size : %d",TriosGetBufferSize());
	for (looper=0;looper<10;looper++)
		 err = TriosTransmitBuffer("192.168.1.27",6969);
    return err;
}
