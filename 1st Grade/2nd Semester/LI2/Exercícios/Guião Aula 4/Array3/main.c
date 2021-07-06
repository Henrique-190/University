#include <stdio.h>
#include "library.h"

int main() {
    int funcao, dim, y, isv;
    int x = 0;
    printf("Insira a função: ");
    scanf("%d",&funcao);
    printf("Insira a dimensão do array: ");
    scanf("%d",&dim);
    printf("Insira os números do array: ");

    int arr[dim];
    while (x<dim) {
        scanf("%d",&y);
        arr[x] = y;
        x++;
    }

    printf("Escreva o índice do número:");
    scanf("%d",&isv);

    if (funcao==1) {
        soma_elemento(arr,dim,isv);
    }
    else if (funcao==2) {
        roda_esq(arr,dim,isv);
    } else {remove_menores(arr,dim,isv);}
}