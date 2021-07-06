#include <time.h>
#include "modC.h"

int main(int argn, char *argv[])
{
    if(argn == 4 && !strcmp(argv[2],"-m") && !strcmp(argv[3], "c")){
           moduloC(argv[1]);
    }
    else printf("\nInput incorreto\n\n");
    
   return 0;
}


