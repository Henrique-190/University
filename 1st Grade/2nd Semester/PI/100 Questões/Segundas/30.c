typedef struct nodo {
int valor;
struct nodo *esq, *dir;
} *ABin;

//duvida

void mirror (ABin *a){
    if ((*a)->dir && (*a)->esq){
        ABin endereco = (*a)->dir;
        ((*a)->dir)=((*a)->esq);
        ((*a)->esq)=endereco;
        mirror(&((*a)->dir));
        mirror(&((*a)->esq));
    }
    else if ((*a)->esq){
        ABin *pt;
        ABin nula = NULL;
        ABin endereco = (*a)->esq;
        ((*a)->dir) = malloc(sizeof(struct nodo));
        ((*a)->dir) = endereco;
        mirror(&((*a)->dir));
    } 
    else if ((*a)->dir){
        ABin *pt;
        ABin nula = NULL;
        (*a)->esq = &((*a)->dir);
        (*a)->dir = NULL;
        mirror(&((*a)->esq));
    }
}