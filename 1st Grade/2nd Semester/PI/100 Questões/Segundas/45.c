int lookupAB (ABin a, int x){
    while (a && a->valor != x){
        if (a->valor > x)
            a = a->esq;
        else a = a->dir;
    }
    return (a) ? 1:0;
}