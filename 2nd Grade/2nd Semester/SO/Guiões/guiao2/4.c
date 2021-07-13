#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int main(){
    int status;
    pid_t pid;
    char *buf = malloc(sizeof(char));;

    for(int i = 0, f = 1; i < 10; i++, f++){
        if((pid = fork()) == 0){
            _exit(f);
        }
    }

    for(int i = 0; i < 10; i++){
            wait(&status);
            sprintf(buf,"PAI: %d    FILHO: %d\n",getpid(),WEXITSTATUS(status));
            write(0,buf,strlen(buf));
    }
    
    return 0;
}