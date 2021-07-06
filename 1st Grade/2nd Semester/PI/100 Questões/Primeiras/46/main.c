#include <stdio.h>

int cardinalMSet (int N, int v[N]){
    int i = 0;
    int r = 0;

    while(i<N){
        r += v[i];
        i++;
    }

    return r;
}