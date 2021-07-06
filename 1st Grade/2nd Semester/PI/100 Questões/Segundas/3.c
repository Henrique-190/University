#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

void imprimeL (LInt l){
    while (l!=NULL){
        printf("%d",l->valor);
        l = l->prox;
    }
}