#include <stdio.h>

int aux(char p, char a[],int x){
    int i = 0;
    for (i;p==a[x];i++,x++);
    return i;
}


int iguaisConsecutivos (char s[]){
    int x = 0;
    int a = 0;
    int b;
    char d;
    while (s[x]){
        b = aux(s[x],s,x);
        if (b>a)
            a = b;
        x++;
    }
    return a;
}
