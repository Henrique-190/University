#include <stdio.h>

int menosFreq (int v[], int N) {
    int i = 1;
    int freq = 0;
    int freqm = N;
    int men = v[0];

    while (i < N) {
        if (v[i] == v[i-1]) freq++;
        else {
            if (freq < freqm) {
                freqm = freq;
                men = v[i-1];
            }
            freq = 0;
        }
        i++;
    }
    if (freq<freqm){
        men=v[i-1];
    }

    return men;
}