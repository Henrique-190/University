#ifndef _AUXSTRUCTS_H_
#define _AUXSTRUCTS_H_

#include <unistd.h>

#define MAX_BUFFER 1024
#define MAX_NUM_PROCESS 100
#define NUM_MAX_FILTERS 16

typedef struct filtro{
    char *nome;
    char *executavel;
    int limiteMax;
    int usados;
} *Filtro;

typedef struct cliente{
    int executado;            // 1 já foi executado 0 ainda não 
    int pid;                  //pid
    char operacao;            // 's' ou 't'
    char* input_filename;     // ficheiro com o audio de input
    char* output_filename;    // ficheiro com o audio de output
    int numFiltros;           // numero de filtros 
    char **filtros;           // Array de filtros 
} *Cliente;

typedef struct queue{
    Cliente queue[MAX_NUM_PROCESS];
    int front;
    int length;
    int numProc;
} ClientQueue;

int podeUsarFiltro(Filtro f);

Filtro procuraFiltro(Filtro *fs, int num_filters, char *nome_f);

int validTransform(Filtro *fs, int num_filters, char** filtros);

void preencheFiltros(Filtro *fs, int num_filros, Cliente c);

void libertaFiltros(Filtro *fs, int num_filros, Cliente c);

char* showFilterStatus(Filtro f);

void initQueue(ClientQueue *fila);

int isEmpty(ClientQueue *fila);

int enQueue(ClientQueue *fila, Cliente c);

int deQueue(ClientQueue *fila, Cliente *c);

void toString(Cliente c);

Cliente initCliente(int nome, char op, char *in_file, char* out_file, int n_filtros, char**filtros);

void destroyClient(Cliente c);

int contaEspacos(char *string);

#endif