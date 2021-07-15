
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
            execlp("wc","wc","-l",NULL);
            close(fildes[0]);
            _exit(0);
        }
        else{
            close(fildes[0]);
            int r;
            dup2(fildes[1],1);
            execlp("ls","ls","/etc",NULL);
        }
    }
    return 0;
}
