#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


int main(int argc, char** argv){
    for(int i = 1; i<argc; i++){
        write(0,argv[i],strlen(argv[i]));
        write(0,"\n",1);
    }
    return 0;
}