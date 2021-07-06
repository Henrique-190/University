#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

LInt newLInt (int v, LInt t){
    LInt new = (LInt) malloc (sizeof (struct lligada));
    
    if (new!=NULL) {
        new->valor = v;
        new->prox  = t;
    }
    return new;
}

LInt cloneL (LInt *l){
    LInt d = NULL;
    LInt t = NULL;

    while (*l){
        d = newLInt((*l)->valor,d);
        (*l)=(*l)->prox;
    }

    while (d){
        t = newLInt((*l)->valor,t);
        (*l)=(*l)->prox;
    }

    return t;
}