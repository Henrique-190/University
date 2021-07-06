#include <stdio.h>

void insere (int s[], int N, int x){
    s[N]=x;
    while (N>0) {
        if (s[N]>=s[N-1]) {N--;}
        else {
            int y = s[N-1];
            s[N-1]=s[N];
            s[N] = y;
        }
    }
}
