typedef struct nodo {
int valor;
struct nodo *esq, *dir;
} *ABin;
//duvida no querer passar outra parte do vetor
int nivelV (ABin a, int n, int v[]){
    if (n==1 && a){
        int i = 0;
        v[i]=a->valor;
        return 1;
    }
    else if(a){
        int b = nivelV(a->esq,n-1,v)
        int c = nivelV(a->esq,n-1,*(v+b));
        return b+c;
    }
    else return 0;
}