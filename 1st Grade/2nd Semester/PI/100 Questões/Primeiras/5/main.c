#include <stdio.h>

int trailingZ (unsigned int n) {
    int r = 0;
    if (n==0) r=32;
    while (n>0) {
        if (n % 2 ==0)
            r++;
        n = n/2;
    }
    return r;
}
