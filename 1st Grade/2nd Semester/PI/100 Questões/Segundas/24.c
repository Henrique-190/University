#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

LInt somasAcL (LInt l){
    int resultado = 0;
    LInt lista = NULL;
    LInt *nova=&lista;
    while(l){
        resultado += l->valor;
        *nova = newLInt(resultado,NULL);
        nova = &((*nova)->prox);
        l=l->prox;
    }
    return lista;
}