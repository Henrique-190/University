#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

void delInt (LInt *l, int x){
    LInt anterior = NULL;
    int i = 1;
    while (*l && i){
        if ((*l)->valor==x){
            anterior=*l;
            *l = (*l)->prox;
            i--;
        } else {
            anterior = (*l);
            l = &((*l)->prox);
        }
    }
}

int removeMaiorL (LInt *l){
    LInt pt = *l;
    int max = 0;

    while(pt){
        if (pt->valor>max){
            max = pt->valor;
        }
        else pt=pt->prox;
    }
    delInt (l,max);
    return max;
}