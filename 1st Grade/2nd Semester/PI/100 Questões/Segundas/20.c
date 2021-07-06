#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

int drop (int n, LInt *l){
    LInt nova = NULL;
    int i = 0;
    while (*l && n){
        LInt temp = ((*l)->prox);
        free(*l);
        *l = temp;
        i++;
        n--;
    }
    return i;
}