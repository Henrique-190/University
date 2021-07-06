void removeMaiorA (ABin *a){
    while((*a) && (*a)->dir){
        a=&((*a)->dir);
    }
    (*a) = (*a)->esq;
}