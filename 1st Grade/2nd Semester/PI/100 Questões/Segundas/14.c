#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

void appendL (LInt *l, int x){
    LInt nova = newLInt (x,NULL);
    if (!(*l)) *l=nova;
    else{
        while ((*l)->prox)
          l=&((*l)->prox);
        (*l)->prox = nova;
    }
}