int quantosMaiores (ABin a, int x){
    if (!a) return 0;
    else {
        int resultado = 0;
        if (a->valor>x){
            resultado = quantosMaiores(a->esq,x) + 1 + quantosMaiores(a->dir,x);
        } else resultado = quantosMaiores(a->dir,x);
        return resultado;
    }
}