#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;


int listToArray (LInt l, int v[], int N){
    int i = 0;
    while (l && N){
        v[i] = l->valor;
        l=l->prox;
        i++;
        N--;
    }
    return i;
}