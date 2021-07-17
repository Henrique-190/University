#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>

int main(){
    int ans = mkfifo("fifo",0600);
    return 0;
}