#include <stdio.h>

void insere (int s[], int N, int x){
    s[N]=x;
    while (N>0) {
        if (s[N]>=s[N-1]) {N--;}
        else {
            int y = s[N-1];
            s[N-1]=s[N];
            s[N] = y;
        }
    }
}

void merge (int r [], int a[], int b[], int na, int nb){
    int i =0, y=na;
    while(y>0){
        r[i]=a[i];
        y--;
        i++;
    }
    i=0;
    while(nb>0){
        insere(r,na,b[i]);
        na++;
        i++;
        nb--;
    }
}
