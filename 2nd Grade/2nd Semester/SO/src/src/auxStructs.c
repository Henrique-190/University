#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "auxStructs.h"

int podeUsarFiltro(Filtro f){ return (f->usados < f->limiteMax);}

Filtro procuraFiltro(Filtro *fs, int num_filters, char *nome_f){
    for(int i=0; i<num_filters; i++){
        if (!strcmp(nome_f, fs[i]->nome)){
            return fs[i];
        }
    }
    return NULL;
}

int validTransform(Filtro *fs, int num_filters, char** filtros){
    for (int i = 0; i < num_filters && filtros[i]; i++){
        if(!podeUsarFiltro(procuraFiltro(fs, num_filters, filtros[i])))
            return 0;
    }
    return 1;
}

void preencheFiltros(Filtro *fs, int num_filros, Cliente c){
    for (int i = 0; i < c->numFiltros; i++){
        Filtro f = procuraFiltro(fs, num_filros, c->filtros[i]);
        if(f && f->usados < f->limiteMax) f->usados = f->usados+1; 
    }
    
}

void libertaFiltros(Filtro *fs, int num_filros, Cliente c){
    for (int i = 0; i < c->numFiltros; i++){
        Filtro f = procuraFiltro(fs, num_filros, c->filtros[i]);
        if(f && f->usados > 0) f->usados = f->usados-1;
    }
    
}

char* showFilterStatus(Filtro f){
    char string[MAX_BUFFER] = "";
    strcat(string, "filter ");
    strcat(string, f->nome);
    strcat(string, ": ");
    char used_max[9];
    sprintf(used_max, "%d/%d ", f->usados, f->limiteMax);
    strcat(string, used_max);
    strcat(string, "(running/max)\n");
    return strdup(string);
}

void initQueue(ClientQueue *fila){
    fila->front = fila->length = fila->numProc = 0;
}

int isEmpty(ClientQueue *fila){
    return (fila->length == 0);
}

int enQueue(ClientQueue *fila, Cliente c){
    int r = 0;
    if(fila->length == MAX_NUM_PROCESS) r = 1;
    else fila->queue[(fila->front + fila->length++) % MAX_NUM_PROCESS] = c;
    return r;
}

void toString(Cliente c){
    printf("Nome        -> cliente%d\n", c->pid);
    printf("Operacao    -> %c\n", c->operacao);
    printf("Input_file  -> %s\n", c->input_filename);
    printf("Output_file -> %s\n", c->output_filename);
    printf("N_filtros   -> %d\n", c->numFiltros);
}

int deQueue(ClientQueue *fila, Cliente *c){
    int r = 0;
    if (fila->length == 0) r = 1;
    else{
        *c = fila->queue[fila->front];
        fila->front = (fila->front + 1) % MAX_NUM_PROCESS;
        fila->length = fila->length-1;
        fila->numProc = fila->numProc-1;
    }
    return r;
}

Cliente initCliente(int nome, char op, char *in_file, char* out_file, int n_filtros, char**filtros){
    Cliente new = malloc(sizeof(struct cliente));
    if(new != NULL){
       new->filtros = (char**)malloc(sizeof(char*) * n_filtros);
       for (int  i = 0; i < n_filtros; i++)
            new->filtros[i] = strdup(filtros[i]);
       new->numFiltros = n_filtros;
       new->pid = nome;
       new->input_filename = strdup(in_file);
       new->output_filename = strdup(out_file);
       new->operacao = op;
       new->executado = 0;
    }
    return new;
}

void destroyClient(Cliente c){
    int i;
    for(i=0;i<c->numFiltros;i++) free(c->filtros[i]);
    free(c->filtros);
    free(c->input_filename);
    free(c->output_filename);
    free(c);
}

int contaEspacos(char *string) {
    int r = 0;
    while (*string) {
        if ((*(string++)) == ' ') r++;
    }
    return r;
}
