typedef struct nodo {
int valor;
struct nodo *esq, *dir;
} *ABin;
//escaxa
LInt nivelL (ABin a, int n){
    LInt l = malloc(sizeof(struct lligada));
    LInt *pt;
    pt = &l;
    if (a){
        if (n>1){
        *pt = nivelL(a->dir,n-1);
        *pt = nivelL(a->esq,n-1);
        return l;
        }
        else {
        (*pt)->valor = a->valor;
        pt = &((*pt)->prox);
        return l;
    }
    }
}