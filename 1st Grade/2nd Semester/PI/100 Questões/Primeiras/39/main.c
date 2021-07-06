#include <stdio.h>

int triSup (int N, int m [N][N]) {
    int zeros = 0, p=0, resultados = 1;

    while(p<N){
        int i = 0, resultado = 1;
        while (zeros>0){
            if (m [p][i]==0.0){
                i++;
                zeros--;
            }
            else {
                zeros = 0;
                resultado = 0;
            }
        }
        if (resultado==1) {
            p++;
            zeros++;
        }
        else {p=N;
            resultados = 0;}
    }
    return resultados;
}
