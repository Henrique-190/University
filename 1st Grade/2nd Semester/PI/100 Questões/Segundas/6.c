#include <stdio.h>
#include <stdlib.h>

typedef struct lligada {
    int valor;
    struct lligada *prox;
} *LInt;


int removeOneOrd (LInt *l, int x) {
    if(!l) return 0;
      
    int ans = 0;
    LInt ant = NULL;
    LInt *pt = l;

    while(*pt && (*pt)->valor != x) { 
        ant = *pt;
        pt = &((*pt)->prox);
    }

    if (!*pt) ans = 1;

    else if (!ant )
        (*pt) = (*pt)->prox;

    else if (*pt) 
        ant->prox = (*pt)->prox;
    

    return ans;
}
