#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

void init (LInt *l){
    while ((*l)->prox)
        l=&((*l)->prox);
    (*l)=NULL;
}