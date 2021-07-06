#include <stdio.h>

int retiraNeg (int v[], int N) {
    int i = 0;
    int r = 0;
    int j;
    while (i < N) {
        if (v[i] >= 0) {
            r++;
            i++;
        } else {
            j = i;
            while (j < N) {
                v[j] = v[j + 1];
                j++;
            }
            N--;
        }
    }

    return r;
}
