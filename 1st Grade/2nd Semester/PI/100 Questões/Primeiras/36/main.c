#include <stdio.h>

int comuns (int a[], int na, int b[], int nb) {
    int aa = 0;
    int bb = 0;
    int r = 0;

    while (aa < na) {
        while (bb < nb) {
            if (a[aa] == b[bb]) {
                bb = nb;
                r++;
            }
            bb++;
        }
        aa++;
        bb = 0;
    }

    return r;
}