#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char *argv[]){
    int rfd = (argc == 2) ? open(argv[1],O_RDONLY) : 1;
    char *buffer = malloc(sizeof(char) * 1024);

    while(read(rfd,buffer,1024) > 0)
        write(0,buffer,strlen(buffer));

    close(rfd);

    return 0;
}