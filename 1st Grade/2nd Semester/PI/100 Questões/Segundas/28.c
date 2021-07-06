typedef struct nodo {
int valor;
struct nodo *esq, *dir;
} *ABin;

int altura (ABin a){
    if (a==NULL) return 0;
    else {
        return (altura(a->esq)>altura(a->dir)) ? (altura(a->esq))+1 : ((altura(a->dir))+1);
    }
}