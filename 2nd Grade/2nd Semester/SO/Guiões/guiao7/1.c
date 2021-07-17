#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>

int segundos = 0;
int ctrlC = 0;

void handler(int s){
    if(s == SIGINT){
        printf(" Tempo: %d segundos\n", segundos);
        ctrlC++;
    }
    else if(s == SIGQUIT){
        printf(" CTRL-C: %d vezes\n", ctrlC);
        kill(getpid(), SIGKILL);
    }
    else if(s == SIGALRM){
        alarm(1);
        segundos++;
    }
}

int main(){
    signal(SIGINT, handler);
    signal(SIGQUIT,handler);
    signal(SIGALRM,handler);
    
    alarm(1);

    while(1) pause();

    return 0;
}