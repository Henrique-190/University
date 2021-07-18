#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h> 
#include <fcntl.h>

int vacinados(char* regiao, int idade){
    int p[2][2];
    int status;
    pipe(p[0]);
    pipe(p[1]);
    int ans = 0;

    if(!fork()){
        close(p[0][0]);
        close(p[1][0]);
        dup2(p[0][1],1);
        char *aux = malloc(sizeof(char));
        sprintf(aux,"%d",idade);
        execlp("grep","grep",aux,regiao,NULL);
    }
    else{
        if(!fork()){
            close(p[0][1]);
            close(p[1][0]);
            dup2(p[0][0],0);
            dup2(p[1][1],1);

            execlp("wc","wc","-l",NULL);
        }
        else{
            char *res = malloc(sizeof(char)*100);
            close(p[0][0]);
            close(p[0][1]);
            close(p[1][1]);
            read(p[1][0],res,100);
            ans = atoi(res);
        }
    }
    return ans;
}

int main(){
    int ans = vacinados("a.txt",500);
    printf("%d",ans);
    return 0;
}