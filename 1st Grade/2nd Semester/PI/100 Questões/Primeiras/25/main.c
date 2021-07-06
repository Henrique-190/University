#include <stdio.h>
#include <string.h>

/* A função
       int limpaEspacos (char t[])
   elimina repetições sucessivas de espaços por um único espaço.
   A função deve retornar o comprimento da string resultante.
*/
void delete (int i, char s[]) {
    int a = i;
    while (s[a]) {
        s[a]=s[a+1];
        a++;
    }
}


int limpaEspacos (char texto[]) {
    int r=1;
    if (strlen(texto)<1) {r=0;}
    else {
    while (texto[r]){
        if (texto[r]==texto[r-1] && texto[r]==' ') {
            delete(r,texto);
        }
        else {r++;}
    }}
    return r;
}