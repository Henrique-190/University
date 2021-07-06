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