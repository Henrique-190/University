#include <stdio.h>
#include <string.h>

int aux(char a, char b[]){
    int x = 0, resultado = 0;
    while (b[x]){
        if (a==b[x])
            resultado = 1;
        x++;
    }
    return resultado;
}

int contida (char a[], char b[]){
    int i = 0, resultado = 1;
    while (a[i]){
        if (aux(a[i],b)==0)
          resultado = 0;
        i++;
    }
    return resultado;
}
