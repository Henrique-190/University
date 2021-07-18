#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h> 
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char **argv){
    int min = -1;
    int max = 0;
    int mean = 0;
    int status;
    
    for(int i = 0; i<10; i++){
        if(!fork()){
            execvp(argv[1],argv+2);
            _exit(1);
        }
        else{
            int child = wait(&status);
            int p[2][2];
            pipe(p[0]);
            pipe(p[1]);

            if(!fork){
                close(p[0][0]);
                dup2(p[0][1],1);
                char *arg = malloc(sizeof(char));
                sprintf(arg,"proc/%d/memstats",child);
                execlp("grep","grep","VmPeak",arg,NULL);
            }
            else{
                if(!fork()){
                    dup2(p[1][1],1);
                    dup2(p[0][0],0);
                    close(p[0][1]);
                    close(p[1][0]);
                    execlp("cut","cut","-d\" \"","-f4",NULL);
                }
                else{
                    wait(&status);
                    char *buf = malloc(sizeof(char)*100);
                    read(p[0][0],buf,100);
                    int mem = atoi(buf);
                    mean += mem;
                    if (min > mem || min == -1) min = mem;
                    if(max < mem) max = mem;    
                }
            }
        }
    }    
    mean /= 10;
    printf("memoria: %d %d %d\n",min,mean,max);
    return 0;
}