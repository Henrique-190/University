#include <stdio.h>

int maiorPrefixo (char s1 [], char s2 []){
    int x = 0, i = 0;
    while (s1[x] && s2[x]){
        if (s1[x]==s2[x]){
            x++;
            i++;
        }
        else{return i;}
    }
    return i;
}
