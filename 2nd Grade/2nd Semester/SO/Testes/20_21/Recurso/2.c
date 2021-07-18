#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h> 
#include <fcntl.h>
#include <unistd.h>

int rounds = 0;

void sigINThandler(int sig){
    if(sig == SIGINT){
        printf("%d rondas\n",rounds);
        kill(0,SIGKILL);
    }
}
    if(sig == SIGALRM){
        kill(0,SIGKILL);
    }

}

int main(){
      if (signal(SIGINT, handler) == SIG_ERR)
        perror("SIGINT failed");
    if (signal(SIGALRM, handler) == SIG_ERR)
        perror("FALHA");
    signal(SIGINT,handler);
    signal(SIGALRM,handler);
    for(int j=0; j<5; j++){
        for(int i = 0; i<100; i++){
            if(!fork()){
                execlp("cmd","cmd",NULL);
            }
        }
    }
    return 0;
}