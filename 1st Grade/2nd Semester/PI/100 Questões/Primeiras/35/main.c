#include <stdio.h>

int comunsOrd (int a[], int na, int b[], int nb) {
    int ia = 0;
    int ib = 0;
    int r = 0;

    while (ia < na && ib < nb) {
        if (a[ia] == b[ib]) {
            r++;
            ia++;
            ib++;
        } else if (a[ia] > b[ib]) ib++;
        else ia++;
    }
    return r;
}