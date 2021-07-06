#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "auxStructs.h"

typedef void (*sighandler_t)(int);

int terminado = 1;
int jaLeu = 0;

int fif_server;
int fif_cliente;

Filtro *filtros;
int num_filros;
ClientQueue fila;

int setFiltersLimit(char *filePath, char* executablePath){
    int fd, n_filtros = 0;
    char c;
    char *buff = malloc(MAX_BUFFER);
    char *line = malloc(MAX_BUFFER);
    

    if ((fd = open(filePath, O_RDONLY, 0666)) == -1){
        perror("Erro ao tentar ler o ficheiro de configurração!\n");
        return 1;
    }
    while (read(fd, &c, 1) == 1)
        if (c == '\n') n_filtros++;
    filtros = (Filtro*)malloc(sizeof(struct filtro*) * n_filtros);
    lseek(fd, 0, SEEK_SET);
    num_filros = 0;    

    read(fd,buff,MAX_BUFFER);
    strcat(executablePath, "/");
    for(num_filros = 0; num_filros<n_filtros; num_filros++){
        filtros[num_filros] = malloc(sizeof(struct filtro));
        line = strsep(&buff, "\n\0");   
        filtros[num_filros]->nome = strdup(strsep(&line, " "));
        char aux[MAX_BUFFER];
        strcpy(aux, executablePath);
        filtros[num_filros]->executavel = strdup(strcat(aux, strsep(&line, " ")));
        filtros[num_filros]->usados = 0;
        filtros[num_filros]->limiteMax = (int)strtol(line, NULL, 10);

    }
    close(fd);
    return 0;
}

Cliente parseComand(char* clientLine){
    Cliente res = malloc(sizeof(struct cliente));

    int space = contaEspacos(clientLine);
    char* aux;
    aux = strdup(strsep(&clientLine, " "));
    res->pid = (int) strtol(aux, NULL, 10);
    res->executado = 0;
    
    if(space == 1){
        //status
        res->operacao = 's';
        res->input_filename = NULL;
        res->output_filename = NULL;
        res->numFiltros = 0;
        res->filtros = NULL;
    }else if(space >= 4){
        //transform
        strsep(&clientLine, " ");
        res->operacao = 't';
        res->input_filename = strdup(strsep(&clientLine, " "));
        res->output_filename = strdup(strsep(&clientLine, " "));
        res->numFiltros = 0;
        res->filtros = (char**)malloc(sizeof(char*) * space - 3);
        while ((aux = strsep(&clientLine, " ")) != NULL){
            res->filtros[res->numFiltros++] = strdup(aux);
        }
    }else {printf("Operação inválida\n"); return NULL;}
    free(aux);
    return res;
}

char* showStatus(){
    char* status = malloc(MAX_BUFFER);
    //---------Tascks-------------------
    for (int i = 0; i < fila.numProc; i++){
        char cliente[32] = "cliente";
        char pid[25];
        sprintf(pid, "%d", fila.queue[i]->pid);
        strcat(cliente, pid);
        strcat(status, cliente);
        strcat(status, ": ");
        strcat(status, "transform ");
        strcat(status, fila.queue[i]->input_filename);
        strcat(status, " ");
        strcat(status, fila.queue[i]->output_filename);
        strcat(status, " ");
        int j=0;
        while (j<fila.queue[i]->numFiltros){
            strcat(status, fila.queue[i]->filtros[j]);
            strcat(status, " ");
            j++;
        }
        strcat(status, "\n");
    }
    
    //-----------Filtros----------------
    for (int i = 0; i < num_filros; i++){
        char *filter_status = showFilterStatus(filtros[i]);
        strcat(status, filter_status);
    }
    char server_pid[30];
    sprintf(server_pid, "pid: %d\n", getpid());
    strcat(status, server_pid);
    return status;
}

void atualizaNumProcess(ClientQueue *cq){
    int swap = 0;
    int indexSwap = 0, ultimaPos = 0;
    int posSwap[fila.length]; 

    for (int i = 0; i < fila.length; i++){
        if(validTransform(filtros, num_filros, fila.queue[i]->filtros)){
            preencheFiltros(filtros, num_filros, fila.queue[i]);
            fila.numProc++;
            if(swap){
                Cliente aux = fila.queue[i];
                fila.queue[i] = fila.queue[posSwap[indexSwap]];
                fila.queue[posSwap[indexSwap]] = aux;
                indexSwap++;
            }
        }else{
            swap = 1;
            posSwap[ultimaPos] = i;
            ultimaPos++;
        }    
    }
    
}
int execUmCLiente(){
    Cliente c;
    if(deQueue(&fila, &c)) return 1;

    //Sinal de Processing
    kill(c->pid, SIGUSR1);

    int file_in, file_out;
    file_in = open(c->input_filename, O_RDONLY, 0666);
    if(file_in == -1) { return 1;}

    file_out = open(c->output_filename, O_CREAT | O_WRONLY | O_TRUNC, 0666);
    if(file_out == -1) { return 1;}

    dup2(file_in, STDIN_FILENO); close(file_in);
    dup2(file_out, STDOUT_FILENO); close(file_out);


    int fd[2];
    int i;
    for (i = 0; i < c->numFiltros-1; i++){
        if(pipe(fd) == -1) { return 1;}

        Filtro f = procuraFiltro(filtros, num_filros, c->filtros[i]);
        int pid_child = fork();
        if(pid_child == 0){
            dup2(fd[1], 1);
            close(fd[1]);
            close(fd[0]);
            if(execl(f->executavel, f->executavel, NULL) == -1){
                perror("Erro no exec de um filtro\n");
                _exit(1);
            } 
        }else{
            dup2(fd[0], 0);
            close(fd[0]);
            close(fd[1]);
        }
    }
    pid_t pid;
    Filtro f = procuraFiltro(filtros, num_filros, c->filtros[i]);
    if ((pid = fork()) == 0){
        if(execl(f->executavel, f->executavel, NULL))
            _exit(1);
    }
    else{
            int status;
            waitpid(pid,&status,0);
            if(WEXITSTATUS(status) == 0){
                kill(c->pid, SIGUSR2); //task done
                c->executado = 1;
                //libertaFiltros(filtros, num_filros, c);
                destroyClient(c);
            }else kill(c->pid, SIGINT);  
            return WEXITSTATUS(status);
    }     
    return 0;
}

int execVariosClientes(){
    if(fila.numProc > 0){
        int pids[fila.numProc];
        int i = 0;
        while(fila.numProc > 0){
            pids[i] = fork();
            if(pids[i] == -1) return 1;
            if(pids[i] == 0){
                int exit = execUmCLiente();
                _exit(exit);
            }else{
                int status;
                waitpid(pids[i], &status, 0);
                return WEXITSTATUS(status);
            }
            i++;
        }
    }    
    return 0;
}

void autulizaVariaveisGlobais(){
    for (int i = 0; i < fila.length; i++){
        if (fila.queue[i]->executado == 1){
             Cliente c;
             deQueue(&fila, &c);
             libertaFiltros(filtros, num_filros, c);
             destroyClient(c);
        }
    }
}

void handleExit(int signal){
    if (terminado == 0) {
        if (jaLeu == 1) {
            execVariosClientes();
        }
        close(fif_server);
        remove("server");
        kill(getpid(), SIGKILL);
    } else
    write(STDOUT_FILENO, "Fechando o servidor!\n", 22);
    close(fif_server);
    remove("server");
    // unlink("server");
    exit(0);

}

//./aurrasd etc/aurrasd.conf bin/aurrasd-filters
// gcc -Wall -g -o aurrasd src/aurrasd.c src/auxStructs.c
int main(int argc, char* argv[]) {
    if (setFiltersLimit(argv[1], argv[2]) == 1) return 1;
    initQueue(&fila);
    

    char *fifo_server = "server";
    char clientLine[MAX_BUFFER];
    Cliente c;
    int r;
    char *status;

    signal(SIGTERM, handleExit);


    mkfifo(fifo_server, 0666);
    printf("Criei a fifo: %s\n", fifo_server);

    if ((fif_server = open(fifo_server, O_RDONLY, 0666)) == -1) return -1;
    while (1) {
        terminado = 0;
        bzero(clientLine, MAX_BUFFER);
        while ((r = read(fif_server, clientLine, MAX_BUFFER)) > 0) {
            jaLeu = 1;
            c = parseComand(clientLine);
            if(c != NULL){
                printf("Recebi o cliente:\n");
                toString(c);
                
                if (c->operacao == 's'){
                    //processar o comando status
                    char cliente[32] = "cliente";
                    char pid[25];
                    sprintf(pid, "%d", c->pid);
                    strcat(cliente, pid);
                    if ((fif_cliente = open(cliente, O_WRONLY, 0666)) == -1) return -1;
                    printf("Abri o %s para a escrita\n", cliente);
                    status = showStatus();
                    write(fif_cliente, status, strlen(status));
                    printf("Escrevi %s em %s\n", status, cliente);
                    close(fif_cliente);
                    destroyClient(c);
                }else if(c->operacao == 't'){
                    //processar o comandos transform
                    if(enQueue(&fila, c)) printf("Não há mais espaço para mais processos!\n");
                    atualizaNumProcess(&fila);

                    if(execVariosClientes()){
                        perror("Erro ao executar transform\n");
                        return 1;
                    }
                    autulizaVariaveisGlobais();
                }
            }
            jaLeu = 0;
        }
        terminado = 1;
    }
    close(fif_server);
    remove(fifo_server);
    return 0;
}