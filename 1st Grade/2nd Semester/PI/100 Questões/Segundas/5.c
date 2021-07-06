#include <stdio.h>

typedef struct lligada {
    int valor;
    struct lligada *prox;
} *LInt;


void insertOrd (LInt *l, int x){
    LInt sl = malloc(sizeof(struct lligada));

    while (*l && (*l)->valor<x){
        l = &((*l)->prox);
    }

    sl->valor = x;
    sl->prox = (*l);
    *l = sl;
}