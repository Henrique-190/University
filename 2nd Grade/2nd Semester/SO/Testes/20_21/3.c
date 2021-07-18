#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h> 
#include <fcntl.h>

void siginthand(int sig){
    
}

int vacinado(char* cidadao){
    int status;
    for(int i = 1; i < 10; i++){
        char *file = malloc(sizeof(char));
        sprintf(file,"%d.c",i);
        if(!fork()){
            char *arg = malloc(sizeof(char));
            sprintf(arg,"\"cidadao\"");
            execlp("grep","grep",arg,file,NULL);
        }
        else {
            wait(&status);
            if(WEXITSTATUS(status) == 0) return 1;
        }
    }

    return 0;

}

int main(){
    int ans = vacinado("0;");
    printf("%d",ans);
    return 0;
}