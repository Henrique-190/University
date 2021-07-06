#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

LInt NForward (LInt l, int N){
    while (l && N){
    l=l->prox;
    N--;}
    return l;
}