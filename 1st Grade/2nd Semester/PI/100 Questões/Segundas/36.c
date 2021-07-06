typedef struct nodo {
int valor;
struct nodo *esq, *dir;
} *ABin;

 int freeAB (ABin a){
    if (a){
        int b = freeAB(a->dir);
        int c = freeAB(a->esq);
        ABin *temp = malloc(sizeof(struct nodo));
        free(a);
        return b+c+1;
    }
    else return 0;
}
 //escaxa no numero de nodos

int pruneAB (ABin *a, int l) {
      int i = 0;
    if (l>1 && (*a)){
        pruneAB(&((*a)->esq),l-1);
        pruneAB(&((*a)->dir),l-1);}
    else if (*a){
        i += freeAB((*a)->dir);
        (*a)->dir = NULL;
        i += freeAB((*a)->esq);
        (*a)->esq = NULL;
        return i;
    }
 }