#include <stdio.h>

int bitsUm (unsigned int x){
    int r = 0;
    while (x>0){
        if (x % 2 ==1) r++;
        x = x/2;
    }
    return r;
}
