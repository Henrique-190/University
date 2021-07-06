#include <stdio.h>
#include "indicadores.h"
int main() {
    float peso, altura, indice;
    printf("Indique o seu peso (em Kg): ");
    scanf("%f",&peso);
    printf("Indique a sua altura (em m): ");
    scanf("%f",&altura);
    indice = imc(peso, altura);
    printf("O valor do seu IMC é: %f\n", indice);
    return 0;
}