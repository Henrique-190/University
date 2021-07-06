#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

int removeAll (LInt *l, int x){
    int i = 0;
    LInt anterior = NULL;
    while (*l){
        if ((*l)->valor==x){
            anterior=*l;
            *l = (*l)->prox;
            i++;
        } else {
            anterior = (*l);
            l = &((*l)->prox);
        }
    }
    return i;
}


int removeDups (LInt *l){
    
    while (*l){
        int a = removeAll(&(*l)->prox,(*l)->valor);
        l=&(*l)->prox;
    } 
    return 0;
}