#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

LInt arrayToList (int v[], int N){
    LInt l=NULL;
    int i = 0;
    while (v && N){
        *pt = malloc(sizeof(struct lligada));
        (*pt)->valor = v[i];
        pt = &((*pt)->prox);
        i++;
        N--;
    }
    return l;
}