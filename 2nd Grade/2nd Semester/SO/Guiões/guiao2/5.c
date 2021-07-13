#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int main(){
    int status;
    pid_t pid;
    char *buf = malloc(sizeof(char));;

    for(int i = 0; i <= 10; i++){
        if((pid = fork()) == 0){
            sprintf(buf,"MEU: %d    PAI: %d\n",getpid(),getppid());
            write(0,buf,strlen(buf));
        }
        else {
            wait(&status);
            _exit(0);
        }
    }

    return 0;
}