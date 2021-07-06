    typedef struct nodo {
    int valor;
    struct nodo *esq, *dir;
    } *ABin;
//duvida
int depth (ABin a, int x) {
    int i = 1;
    if (a->dir && a->esq){
        int direita = depth(a->dir,x);
        int esquerda = depth(a->esq,x);
        if (direita == esquerda && direita ==0)
            return (a->valor == x) ? i : 0;
        
    return (direita>esquerda) ? (direita+1) : (esquerda+1);
        }
    else if (a->dir) {
        int direita = depth(a->dir,x);
        if (direita ==0)
            return (a->valor == x) ? i : 0;
        else return (direita+1);
    }
    else if (a->esq){
        int esquerda = depth(a->esq,x);
        if (esquerda==0)
            return (a->valor == x) ? i : 0;
        else return (esquerda+1);
    }
    else if (a)
            return (a->valor == x) ? i:0;
}