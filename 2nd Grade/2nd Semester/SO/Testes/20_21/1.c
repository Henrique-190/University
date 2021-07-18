#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h> 
#include <fcntl.h>
#include <string.h>

int main(){
    int fd = open("fifo",O_RDONLY);
    char *buf = malloc(sizeof(char)*1024);
    while(read(fd,buf,1024)>0){
        while(buf){
            char**entry = parse_entry(&buf);
            int rd = open(entry[2],O_CREAT | O_TRUNC, 0666);
            char *en = malloc(sizeof(char));
            sprintf(en,"%s %s %s\n",entry[0],entry[1],entry[2]);
            write(rd,en,strlen(en));
        }
        buf = malloc(sizeof(char)*1024);
    }
}