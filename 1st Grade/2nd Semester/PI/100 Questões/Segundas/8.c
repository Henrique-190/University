#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

void splitQS (LInt l, int x, LInt *mx, LInt *Mx){
    while (l!=NULL){
        if (l->valor < x){
            (*mx)=l;
            mx = &((*mx)->prox);
        }
        else{
            (*Mx)=l;
            Mx = &((*Mx)->prox);
        }
        l=l->prox;
    }
    (*mx)=NULL;
    (*Mx)=NULL;
}