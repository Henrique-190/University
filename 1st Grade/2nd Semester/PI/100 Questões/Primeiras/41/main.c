#include <stdio.h>

void addTo (int N, int M, int a [N][M], int b[N][M]) {
    int i = 0;
    int j = 0;
    while (j < N) {
        while (i < M) {
            a[j][i] += b[j][i];
            i++;
        }
        j++;
        i=0;
    }
}
