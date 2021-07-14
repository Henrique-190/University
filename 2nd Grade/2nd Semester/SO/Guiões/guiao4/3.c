#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>


int main(){
    int fo = open("/etc/passwd", O_RDONLY);
    dup2(fo,0);
    close(fo);

    int oo = open("saida.txt",O_WRONLY | O_APPEND | O_CREAT,0644);
    dup2(oo,1);
    close(oo);

    int eo = open("erros.txt",O_WRONLY | O_APPEND | O_CREAT,0644);
    dup2(eo,2);
    close(eo);

    execlp("wc","wc",NULL);
    return 0;
}