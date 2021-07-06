#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

void freeL (LInt l) 
{
    LInt ant;
    
    while (l != NULL){
      ant = l;
      l=l->prox;
      free(ant);}
}
