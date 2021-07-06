#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

int length (LInt l){
    int i = 0;
    
    while (l != NULL){
    l=l->prox;
    i++;}

    return i;
}

LInt parteAmeio (LInt *l){
    int tamanho = length(*l)/2;
    LInt primeira = *l;
    LInt anterior = NULL;

    while (tamanho > 0){
        anterior = *l;
        *l = (*l)->prox;
        tamanho--;
    }
    if (anterior) anterior->prox = NULL;
    else primeira = NULL;
    return primeira;
}