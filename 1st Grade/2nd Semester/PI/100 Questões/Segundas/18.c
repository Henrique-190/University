#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

int maximo (LInt l){
    int max = 0;
    while (l){
        if (l->valor > max)
            max = l->valor;
        l = l->prox;
    }
    return max;
}