#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


int main(int argc, char** argv){
    argv[0] = "ex4";
    int ret = execvp("3.out",argv);
    return 0;
}