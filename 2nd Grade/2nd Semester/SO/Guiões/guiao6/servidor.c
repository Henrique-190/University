#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>


int main() {
    int fd = open("fifo", O_RDONLY);
    int logd = open("log.txt", O_CREAT | O_APPEND | O_WRONLY, 0666);
    char *buf = malloc(sizeof(char)*1024);
    int r;

    while(1){
        while((r = read(fd,buf,1024)) > 1)
            write(logd,buf,r);
    }
    close(logd);
    close(fd);
    return 0;
}