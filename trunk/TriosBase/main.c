
/*! \file main.c

*/



#include <stdio.h>
#include <sys/socket.h>
#include "TriosModel.h"

/*! \fn int main (int argc, const char * argv[])
 \param argc number of command line arguments
 \param argv string list containing the arguments
*/ 
int main (int argc, const char * argv[]) {
	int err = TRIOS_ERROR_OK;
	volatile int i =0;
	volatile int j =0;
	
	TriosInitBuffer();
	TriosSetEhternet("192.168.1.24",6969);
	while (i < 10 ){
		TriosSendGetBuffer();
		for (j=0 ; j< 30000000 ; j++) ;
		/*TriosSendPostBuffer();*/
		/*for (j=0 ; j< 3000000 ; j++) ;*/
		i++;
	}
	
    return err;
}
