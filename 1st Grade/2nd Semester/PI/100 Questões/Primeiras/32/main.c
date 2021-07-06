#include <stdio.h>

int maxCresc (int v[], int N) {
    int s = 1;
    int ms = 0;
    int i = 1;
    while (i < N) {
        if (v[i] >= v[i - 1]) s++;
        else {
            if (s > ms) {
                ms = s;
            }
            s = 1;
        }
        i++;
    }

    if (s > ms) {
        ms = s;
    }
    return ms;
}