#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>

#include "auxStructs.h"

typedef void (*sighandler_t)(int);


void infoComands(){
    printf("Para obter o status atual do servidor execute: ./aurras status\n");
    printf("Para submeter um pedido ao servidor execute:   ./aurras transform input-filename output-filename filter-id-1 filter-id-2 ...\n");
}

int validComand(int argc, char **argv){
    int r = 0;
    if(argc == 1) return 1;
    if(argc == 2 && !strcmp(argv[1], "status")) return 1;
    if(argc > 4 && !strcmp(argv[1], "transform")) return 1;
    return r;
}

char* concatComand(int pid, int nArg, char** argv){
    char* res = malloc(sizeof(char) * MAX_BUFFER);
    char s_pid[16];
    sprintf(s_pid, "%d ", pid);
    res = strcat(res, s_pid);
    for(int i = 1; i<nArg-1; i++){
        res = strcat(res, argv[i]);
        res = strcat(res, " ");
    } 
    res = strcat(res, argv[nArg-1]);
    res = strcat(res, "\0");
    return res;
}

void handler(int signal){
    switch (signal){
    case SIGUSR1:
        write(STDOUT_FILENO, "Processing\n", 11);
        break;
    case SIGUSR2:
        write(STDOUT_FILENO, "Task done.\n", 11);
        kill(getpid(), SIGCONT);
        break;
    case SIGINT:
        write(STDOUT_FILENO, "Invalid input or Server Down\n", 29);
        kill(getpid(), SIGTERM);
        break;
    }
    
}


// gcc -Wall -g -o aurras src/aurras.c src/auxStructs.c
// ./aurras transform samples/sample-1-so.m4a output.m4a alto eco rapido
int main(int argc, char *argv[]) {
    if(!validComand(argc,argv)){
        printf("Comando inválido!\n");
        return 0;
    }

    signal(SIGUSR1, handler);
    signal(SIGUSR2, handler);
    signal(SIGINT, handler);

    if (argc == 1){
        infoComands();
        return 0;
    }

    char *fifo_server = "server";
    char fifo_cliente[128];
    char *comando;
    sprintf(fifo_cliente, "cliente%d", (int)getpid());


    if (mkfifo(fifo_cliente, 0666) == -1) {
        perror("ERROR: Já existe fifo\n");
    }
    printf("Criei a fifo: %s\n", fifo_cliente);

    int fif_cliente;
    int fif_server;
    int r;

    comando = concatComand((int)getpid(), argc, argv);  
    if ((fif_server = open(fifo_server, O_WRONLY, 0666)) == -1) return -1;

    write(fif_server, comando, strlen(comando));
    printf("Escrevi o comando: %s na fifo do server\n", comando);
    close(fif_server);
    write(STDOUT_FILENO, "Pending\n", 8);
    
    if (argc == 2){
        bzero((char*)comando,MAX_BUFFER);
        if ((fif_cliente = open(fifo_cliente, O_RDONLY, 0666)) == -1) return -1;
        while((r = read(fif_cliente, comando, MAX_BUFFER))){
            write(STDOUT_FILENO, comando, r);
        }
        close(fif_cliente);
    }else{
       pause();
       pause();
    } 

    free(comando);
    unlink(fifo_cliente);
    remove(fifo_cliente);
    return 0;
}
