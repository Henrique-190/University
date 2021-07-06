#include <stdio.h>
#include <string.h>

int palindroma (char s[]) {
    int x = 0, a = strlen(s), resultado = 0;
    char arr[a];
    a--;
    while (a>0){
        arr[x]=s[a];
        x++;
        a--;
    }
    x=0;
    if(strlen(s)==0) {return 1;}
    else {
    while (s[x]){
        if (s[x]==arr[x]) {x++;
                         resultado++;}
        else {x++;}
    }}
    return (resultado<strlen(s)-1)? 0:1;
}