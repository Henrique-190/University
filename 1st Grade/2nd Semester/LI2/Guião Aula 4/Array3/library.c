#include <stdio.h>

void soma_elemento(int *arr, int dim, int idx) {
    int x = 0, y = arr[idx];
    while (x<dim) {
        int z = arr[x];
        arr[x] = z+y;
        x++;
    }
    x = 0;

    while (x<dim) {
        printf("%d ",arr[x]);
        x++;
    }
}


void roda(int *arr, int dim){
    int y = arr[0];
    int i = 0;
    while (i<dim) {
        arr[i]=arr[i+1];
        i++;
    }
    arr[dim-1] = y;

}


void roda_esq(int *arr, int dim, int shifter) {
    while (shifter > dim) {
        shifter = shifter - dim;
    }
    while (shifter > 0) {
        roda(arr, dim);
        shifter--;
    }

    int x = 0;
    while (x < dim) {
        printf("%d ", arr[x]);
        x++;
    }
}


int remove_menores (int *arr,int dim, int valor) {
    int x = 0, men = x, mai = x, temp = x, y = dim, menores[dim], maiores[dim], i=0;
    while (x < y) {
        if (arr[x]<valor) {
        menores[men] = arr[x];
        men++;
        x++;}
        else {
            maiores[mai] = arr[x];
            mai++;
            x++;
        }
    }
    x = 0;

    while(mai>0){
        arr[x] = maiores[temp];
        x++;
        temp++;
        mai--;
    }
    temp = 0;
    while(men>0){
        arr[x] = menores[temp];
        x++;
        temp++;
        men--;
    }
    x = 0;
    while (x < dim) {
        printf("%d ", arr[x]);
        x++;
    }
    return 0;
}