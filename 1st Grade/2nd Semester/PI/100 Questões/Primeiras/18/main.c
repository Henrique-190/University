#include <stdio.h>
#include <string.h>

int maiorSufixo (char s1 [], char s2 []){
    int lena = strlen(s1)-1;
    int lenb = strlen(s2)-1;
    int suf = 0;
    while ((lena>=0)&&(lenb>=0)){
        if (s1[lena]==s2[lenb]){
            suf++;
            lena--;
            lenb--;
        } else return suf; 
    }
    return suf;
}
