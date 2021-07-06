typedef struct nodo {
int valor;
struct nodo *esq, *dir;
} *ABin;

ABin cloneAB (ABin a){
    if (a==NULL) return NULL;
    else {
        ABin c = malloc(sizeof(struct nodo));
        c->esq = cloneAB(a->esq);
        c->dir = cloneAB(a->dir);
        c->valor = a->valor;

        return c;
    }
}