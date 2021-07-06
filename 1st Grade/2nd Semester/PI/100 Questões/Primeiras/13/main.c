#include <stdio.h>

void delete (int i, char s[]) {
    for (i;s[i];i++)
        s[i]=s[i+1];
}

void truncW (char t[], int n){
    int i = 0;
    int comp = 0;
    char c;
    while (t[i])
        if (t[i] == ' ') {
            comp = 0;
            i++;
        } else if (comp<n) {
            comp++;
            i++;
        }
        else {delete (i,t);
            comp++;
        }
}
