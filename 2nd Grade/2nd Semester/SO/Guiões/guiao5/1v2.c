#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h> 


int main(){
    int fildes[2];
    int status;
    if(!pipe(fildes)){
        if(fork()){
            close(fildes[0]);
            sleep(5);
            write(fildes[1],"ola",3);
            close(fildes[1]);
        }
        else{
            close(fildes[1]);
            char *buf = malloc(sizeof(char)*3);
            read(fildes[0],buf,3);
            write(1,buf,3);
            close(fildes[0]);
            _exit(0);
        }
    }
    return 0;
}