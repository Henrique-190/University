#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

int main() {
    int fd = open("fifo", O_RDONLY);
    char *buf = malloc(sizeof(char)*1024);
    int r;
    
    while((r = read(fd,buf,1024)) > 1)
        write(1,buf,r);

    close(fd);
    return 0;
}