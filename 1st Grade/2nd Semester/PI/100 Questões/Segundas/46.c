int depthOrd (ABin a, int x) {
    int i = 1;
    while (a && a->valor != x){
        a = (a->valor<x) ? a->dir:a->esq;
        i++;
    }
    return (a) ? i:(-1);
}