#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;
//duvida
LInt parte (LInt l){
    int i = 0;
    LInt pares = NULL;
    LInt *pt;
    pt = &l;
    while (*pt){
        if (i){
            pares = *pt;
            pares = pares->prox;
            i = 1;   
        }
        else{
            if ((*pt)->prox){
                pt = &((*pt)->prox);
            }
            else *pt=NULL;
            
            i = 0;
        }
        *pt = (*pt)->prox; 
    }
    return pares;
}