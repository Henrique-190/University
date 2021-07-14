#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


int main(){
    execl("/bin/ls","ls","-l",NULL);
    return 0;
}