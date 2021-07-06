#include <stdio.h>
// link da cena não dá
typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

LInt cloneRev (LInt *l){
    LInt lista = NULL;
    while(*l){
        lista = newLInt((*l)->valor,lista);
        (*l)=(*l)->prox;
    }
    return lista;
}