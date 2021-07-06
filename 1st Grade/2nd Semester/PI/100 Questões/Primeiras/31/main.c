#include <stdio.h>

int maisFreq (int v[], int N) {
    int i = 1;
    int freqM = 0;
    int freq = 1;
    int r = v[0];

    while (i < N) {
        if (v[i] == v[i - 1]) { freq++; }
        else {
            if (freqM < freq) {
                freqM = freq;
                r = v[i - 1];
            }
            freq = 1;
        }
        i++;
    }
    if (freqM < freq) r = v[i - 1];
    return r;
}