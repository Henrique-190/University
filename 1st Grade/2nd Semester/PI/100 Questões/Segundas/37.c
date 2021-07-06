typedef struct nodo {
int valor;
struct nodo *esq, *dir;
} *ABin;

int iguaisAB (ABin a, ABin b){
    if (a && b){
        if (a->valor == b->valor){
          int x = iguaisAB(a->dir,b->dir);
          int y = iguaisAB(a->esq,b->esq);
          return (x*y) ? 1 : 0; 
        }
        else return (0);
    }
    else if ((a && !b) || (!a && b)) return 0;
    else return 1;
}