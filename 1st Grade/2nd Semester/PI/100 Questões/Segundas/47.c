int maiorAB (ABin a){
    while(a->dir){
        a = a->dir;
    }
    return a->valor;
}