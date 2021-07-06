#include <stdio.h>

int intersectSet (int N, int v1[N], int v2[N],int r[N]) {
    int i = 0;
    while (i<N){
        r[i] = v1[i] && v2[i];
        i++;
    }
}