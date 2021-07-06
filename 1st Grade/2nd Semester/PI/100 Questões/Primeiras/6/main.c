int qDig (unsigned int n){
    int r = 1;
    while(n/10>0){
        r++;
        n = n/10;
    }
    return r;
}