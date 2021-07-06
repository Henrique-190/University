#include <stdio.h>


void linhaTriangulo(int espaco,int letras) {
     while (espaco>0) {
         printf(" ");
         espaco--;
     }
     int letra = 65;
     while (letras>0) {
         printf ("%c ",letra);
         letra++;
         letras--;
     }
}


void imprime_triangulo (int num_linhas){
     int espaco = num_linhas - 1;
     int letras = 1;
     while (letras<=num_linhas){
         linhaTriangulo(espaco,letras);
         letras++;
         printf("\n");
         espaco--;
     }
}


void imprime_losango (int num) {
    imprime_triangulo(num);
    num = num - 1;
    int espaco = 1;
    while (num>0) {
        linhaTriangulo(espaco,num);
        num--;
        espaco++;
        printf("\n");
    }
}


void primulti (int num){
    int x,y;
    y = num - 1;
    x = num;
    while (x>=0) {
        if (y>0) {printf(" ");
                  y--;}
        else {printf("#");
              x--;}
            }
    printf("\n");
}


void restlinhas (int x, int y) {
    while (x>0) {
        printf(" ");
        x--;
    }
    printf("#");
    while (y>=0) {
        printf(" ");
        y--;
    }
    printf ("#");
}


void imprime_hexagono (int num) {
     primulti(num);
     int w,x,y,z;
     y = num;
     x = num - 2;
     while (x>=0) {
         restlinhas (x,y);
         x--;
         y=y+2;
         printf("\n");
     }

     w = num - 3;
     y = (2*w) + num;
     x = 1;
     z = num - 1;
     while (x<z) {
         restlinhas (x,y);
         y = y - 2;
         x++;
         printf("\n");
     }
     primulti(num);
}
