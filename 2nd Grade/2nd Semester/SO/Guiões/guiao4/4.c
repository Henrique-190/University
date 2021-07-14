//redir [-i fich_entrada] [-o fich_saida] comando arg1 arg2 ...

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>


int main(int argc, char** argv){
    if (argc > 0){
        int command = 1;
        if(!strcmp(argv[1],"-i")){
            int fo = open(argv[2], O_RDONLY);
            dup2(fo,0);
            close(fo);
            command = 3;
            
            if(!strcmp(argv[3],"-o")){
                int oo = open(argv[4],O_WRONLY | O_APPEND | O_CREAT,0644);
                dup2(oo,1);
                close(oo);
                command = 5;
            }
        } else if(!strcmp(argv[1],"-o")){
            int oo = open(argv[2],O_WRONLY | O_APPEND | O_CREAT,0644);
            dup2(oo,1);
            close(oo);
            command = 3;
        }

        execvp(argv[command],argv+command);  
    }
    return 0;
}