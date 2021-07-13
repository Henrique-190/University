#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>


int main(){
    pid_t p;
    int status;
    if((p = fork()) == 0){
        char *buffer = malloc(sizeof(char));
        sprintf(buffer,"Filho: %d e Pai: %d", getpid(),getppid());
        write(0,buffer,strlen(buffer));
        _exit(0);
    }
    else{
        wait(&status);
    }
    return 0;
}