#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int main(){
    pid_t p;
    int status;
    char *buffer = malloc(sizeof(char));

    if((p = fork()) == 0){
        sprintf(buffer,"Sou o filho. MEUPR: %d    PAIPR: %d\n",getpid(),getppid());
        write(0,buffer,strlen(buffer));
        _exit(0);    
    }
    else{
        pid_t filho = wait(&status);
        sprintf(buffer,"Sou o pai.   MEUPR: %d    FILHO: %d\n",getpid(),filho);
        write(0,buffer,strlen(buffer));    
    }

    return 0;
}