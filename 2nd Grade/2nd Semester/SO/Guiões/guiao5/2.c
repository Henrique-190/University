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
            write(fildes[1],"ola",3);
            close(fildes[1]);
        }
        else{
            close(fildes[1]);
            char *buf = malloc(sizeof(char)*1024);
            int r;
            while(r = read(fildes[0],buf,1024)){
                write(1,buf,r);
            }
            close(fildes[0]);
            _exit(0);
        }
    }
    return 0;
}