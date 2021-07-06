#include <stdio.h>
#include <string.h>

/* a função remRep deve remover da string argumento
   todos os caracteres que se repetem sucessivamente
   deixando lá apenas uma cópia
*/
void delete (int i, char s[]) {
    int a = i;
    while (s[a]) {
        s[a]=s[a+1];
        a++;
    }
}

int remRep (char texto []) {
    int i = 1;
    while(texto[i]){
        if (texto[i]==texto[i-1]) {
            delete(i,texto);
        }
        else {i++;}
    }
    int a = strlen(texto);
    return a;
}