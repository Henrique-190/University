#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

void concatL (LInt *a, LInt b){
    while ((*a))
    a=&((*a)->prox);
    
    (*a) = b;
}