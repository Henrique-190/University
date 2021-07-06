typedef struct nodo {
int valor;
struct nodo *esq, *dir;
} *ABin;

ABin somasAcA (ABin a) {
        if (!a) return NULL;
        else {
        ABin nova = malloc(sizeof(struct nodo));
        nova->esq = somasAcA(a->esq);
        nova->dir = somasAcA(a->dir);

        nova->valor = a->valor + ((nova->dir) ? nova->dir->valor : 0) + ((nova->esq) ? nova->esq->valor : 0);
        return nova;
    }
}