#include <stdio.h>

int crescente (int a[], int i, int j) {
    int r = 1;

    while (a[i] && i < j) {
        if (a[i] > a[i + 1]) return 0;
        else {
            i++;
        }
    }
    return r;
}
