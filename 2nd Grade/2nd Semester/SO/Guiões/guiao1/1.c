#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>

int main (int argc, char *argv[]){
    if(argc == 3){
        int rfd = open(argv[1],O_RDONLY);
        int wfd = open(argv[2],O_CREAT | O_APPEND | O_RDWR, 0600);
        char *buffer = malloc(sizeof(char) * 1024);

        while(read(rfd,buffer,1024) > 0){
            write(wfd,buffer,strlen(buffer));
        }

        close(rfd);
        close(wfd);

        write(0,"Lido",4);
    }
    else write(0,"Não lido",8);
    return 0;
}