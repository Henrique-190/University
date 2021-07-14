#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


int main(){
    pid_t pid;
    int status;
    if ((pid = fork())==0) {
        execl("/bin/ls","ls","-l",NULL);
        _exit(0);
    }

    return 0;
}