#include <stdio.h>

void somasAc (int v[], int Ac [], int N) {
    int i = 0;
    int aux = 0;
    int pivo = 0;

    while (i < N) {
        while (aux <= i) {
            pivo = pivo + v[aux];
            aux++;
        }
        Ac[i] = pivo;
        pivo = 0;
        aux = 0;
        i++;
    }
}