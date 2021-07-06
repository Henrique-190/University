#include <stdio.h>
void delete (int i, int s[],int n) {
    int a = i;
    while (a<n) {
        s[a]=s[a+1];
        a++;
    }
}

int elimRep (int v[], int n) {
    int i = 0;
    int j;
    int l = 0;
    int a = n;
    int pivo;
    while (l < n) {
        pivo = v[l];
        i++;
        while (i < a) {
            if (v[i] == pivo) {
                delete(i,v,n);
                a--;
            } else {
                i++;
            }
        }
        l++;
        i=l;
    }
    return a;
}