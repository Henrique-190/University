#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

LInt rotateL (LInt l){
    if (l){
        int x = l->valor;
        LInt temp;
        if (l->prox){
            temp = l;
            l=l->prox;
            free(temp);
        }
        else return l;
        LInt *result = &l;
        for(;*result;result=&((*result)->prox));
        *result = newLInt (x,NULL);
    
    return l;
}}