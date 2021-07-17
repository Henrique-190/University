#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h> 

int segundos = 0;
int ctrlC = 0;

void handler(int s){
    printf("Tempo superior a 10 segundos");
    kill(getpid(),SIGKILL);
}

int main(int argc, char **argv){
    if(argc>2){
        signal(SIGALRM,handler);
        alarm(10);
        int status;

        int pid = getpid();

        for(int i = 2; i<argc; i++){
            if(!fork()){
                execlp("grep","grep",argv[1],argv[i],NULL);
            }
        }

        for(int i = 2; i<argc && wait(&status); i++){
            if(pid != getpid()) exit(0);
        }
    }

    return 0;
}