#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

int take (int n, LInt *l){
    int i = 0;
    LInt nova = NULL;
    while (*l && n){
        l = &((*l)->prox);
        i++;
        n--;
    }
    if (*l){
        *l=nova;
    }
    return i;
}