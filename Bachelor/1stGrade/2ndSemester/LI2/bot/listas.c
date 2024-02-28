#include <stdio.h>
#include <stdlib.h>
#include "listas.h"

LISTA criar_lista() {
    LISTA l = malloc(sizeof(NODO));
    l->valor= NULL;
    return l;
}


void * devolve_cabeca(LISTA l) {
    return l->valor;
}


LISTA insere_cabeca(LISTA l, void *val) {
    LISTA s = malloc(sizeof(NODO));
    s->valor = val;
    s->proximo = l;
    return s;
}


int lista_esta_vazia(LISTA l) {
    return l->valor == NULL ? 1 : 0;
}


LISTA proximo(LISTA l) {
    return l->proximo;
}