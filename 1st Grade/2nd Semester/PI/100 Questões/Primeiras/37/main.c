#include <stdio.h>

int minInd (int v[], int n) {
    int i=0, menor=0, indice;
    while (i<n){
        if (menor>v[i]){
            menor = v[i];
            indice = i;
            i++;}
        else {i++;}
    }
    return indice;
}