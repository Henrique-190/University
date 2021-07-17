#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

int main() {
    int fd = open("fifo", O_WRONLY);
    char *buf = malloc(sizeof(char)*1024);
    int r;
    
    while((r = read(0,buf,1024)) > 0)
        write(fd,buf,r);

    close(fd);
    return 0;
}