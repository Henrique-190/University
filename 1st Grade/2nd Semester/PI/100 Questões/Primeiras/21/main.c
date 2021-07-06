#include <stdio.h>

int contaVogais (char s[]){
    int i = 0, x = 0;

    while (s[x]){
        if (s[x]=='A' || s[x]=='E' || s[x]=='I' || s[x]=='O' || s[x]=='U' || s[x]=='a' || s[x]=='e' || s[x]=='i' || s[x]=='o' || s[x]=='u'){
            x++;
            i++;
        } else x++;
    }
    return i;
}
