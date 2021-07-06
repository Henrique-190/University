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