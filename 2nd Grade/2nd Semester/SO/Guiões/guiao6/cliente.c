#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

int main() {
    int ans = mkfifo("fifo",0600);
    int fd = open("fifo", O_WRONLY);
    char *buf = malloc(sizeof(char)*1024);
    int r;
    
    while((r = read(0,buf,1024)) > 1)
        write(fd,buf,r);

    close(fd);
    return 0;
}