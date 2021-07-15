#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/wait.h> 


int main(){
    int fildes[2];
    int status;
    char *buf = malloc(sizeof(char)*20);
    
    if(!pipe(fildes)){
        if(!fork()){
            close(fildes[1]);
            dup2(fildes[0],0);
            execlp("wc","wc",NULL);
            close(fildes[0]);
            _exit(0);
        }
        else{
            close(fildes[0]);
            int r;
            while((r = read(0,buf,1024))>1)
                write(fildes[1],buf,r);            
            close(fildes[1]);
            wait(&status);
        }
    }
    return 0;
}