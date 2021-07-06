#include <stdio.h>
#include <stdlib.h>
#include "listas.h"

LInt newLInt (int v, LInt t){
    LInt new = (LInt) malloc (sizeof (struct lligada));
    
    if (new!=NULL) {
        new->valor = v;
        new->prox  = t;
    }
    return new;
}

LInt insere_cabeca (LInt tl, int x){
    LInt sl;
    sl = malloc(sizeof(struct lligada));

    sl->valor = x;
    sl->prox = tl;

    return sl;
}

LInt reverseL (LInt l){
    if (l==NULL) return l;
    else{
    LInt sl;
    sl = malloc(sizeof(struct lligada));
    sl->valor = l->valor;
    l = l->prox;
    while (l!=NULL){
        sl = insere_cabeca (sl,l->valor);
        l = l->prox;
    }

    l = sl;
    return l;
    }   
}