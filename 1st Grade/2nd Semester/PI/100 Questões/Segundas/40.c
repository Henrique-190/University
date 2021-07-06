merda

int dumpAbin (ABin a, int v[], int N){
    if (!a) return 0,
    
    if (N>0 && a){
        if(a->esq && a->dir);
        int esq = dumpAbin(a->esq,v,N);
        N -= esq;
        v[esq] = a->valor;
        N--;
        int dir = dumpAbin(a->dir,v+1+esq);
        N -= dir;
        else if (a->esq){
            int esq = dumpAbin(a->esq,v,N);
            N -= esq;
            v[esq] = a->valor;
            N--;
        } else if (a->dir){
            v[esq] = a->valor;
            N--;
            int dir = dumpAbin(a->dir,v+1+esq);
            N -= dir;
        }
        else {v[esq] = a->valor;
                N--;
            }
    }
}