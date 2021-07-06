#include <stdio.h>
#include <stdlib.h>
#include "desenhos.h"

int main(int argc, char *argv[]) {
    if(argc == 3) {
        int tarefa = atoi(argv[1]);
        int numero = atoi(argv[2]);
        switch(tarefa) {
            case 1: imprime_triangulo(numero); break;
            case 2: imprime_losango(numero); break;
            case 3: imprime_hexagono(numero); break;
            default: printf("Erro! Tarefa desconhecida: %d\n", tarefa);
        }
    }
    return 0;
}
