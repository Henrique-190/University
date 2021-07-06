typedef struct nodo {
int valor;
struct nodo *esq, *dir;
} *ABin;
//duvida
void inorder (ABin a, LInt *l){
    if(a->esq && a->dir){
        inorder(a->esq,l);
        (*l)->valor = a->valor;
        (*l) = &((*l)->prox);
        (*l) = malloc(sizeof(struct lligada));
        inorder(a->dir,l);  
    }
    else if (a->esq){
        (*l)->valor = a->valor;
        (*l) = &((*l)->prox);
        (*l) = malloc(sizeof(struct lligada));
        inorder(a->esq,l);
        }

    else if (a->dir){
        (*l)->valor = a->valor;
        (*l) = &((*l)->prox);
        (*l) = malloc(sizeof(struct lligada));
        inorder(a->dir,l);
        }
    else {
        (*l)->valor = a->valor;
        (*l) = &((*l)->prox);
        (*l) = malloc(sizeof(struct lligada));
    }
}