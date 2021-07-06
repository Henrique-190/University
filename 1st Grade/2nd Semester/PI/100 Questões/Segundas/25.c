#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

void remreps (LInt l){
    if (l){
        LInt temp;
        while(l->prox){
            if (l->valor == l->prox->valor){
                temp = l->prox;
                l->prox = l->prox->prox;
                free(temp);
            }
            else l = l->prox;
        }
    }
}