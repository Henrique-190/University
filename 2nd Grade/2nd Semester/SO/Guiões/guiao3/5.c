#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>


int main(int argc, char** argv){
    pid_t pid;
    int status;
    for(int i = 0; i < argc; i++){
        if((pid = fork()) == 0){
            execlp(argv[i],argv[i],NULL);
        }
    }
    
    return 0;
}