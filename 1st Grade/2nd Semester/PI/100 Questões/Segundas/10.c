#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

int removeAll (LInt *l, int x){
    int i = 0;
    LInt anterior = NULL;
    while (*l){
        if ((*l)->valor==x){
            anterior=*l;
            *l = (*l)->prox;
            i++;
        } else {
            anterior = (*l);
            l = &((*l)->prox);
        }
    }
    return i;
}