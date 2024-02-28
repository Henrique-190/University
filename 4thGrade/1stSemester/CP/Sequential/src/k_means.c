#include <stdio.h>
#include <stdlib.h>

#define N 10000000
#define K 4

//Coordenadas X e Y dos N pontos, separados em dois arrays
float pontosX[N] __attribute__((aligned (32)));
float pontosY[N] __attribute__((aligned (32)));

//Coordenadas X e Y dos K centróides, separados em dois arrays
float centroidesX[K] __attribute__((aligned (32)));
float centroidesY[K] __attribute__((aligned (32)));

//Índice das coordenadas do centróide mais próximo de cada ponto
int centroideNearPonto[N] __attribute__((aligned (32)));

//Distância de cada centróide a um ponto
float distanciasCentroide[K] __attribute__((aligned (32)));

//Somatório das coordenadas X e Y dos pontos pertencentes a cada cluster, separados em dois arrays
float SomatorioCentroidesX[K] __attribute__((aligned (32)));
float SomatorioCentroidesY[K] __attribute__((aligned (32)));

//Número de pontos que cada cluster tem
float NPontosClusters[K] __attribute__((aligned (32)));

//Índice das coordenadas do centróide mais próximo de cada ponto na iteração anterior
int oldCentNearPonto[N] __attribute__((aligned (32)));
int igual = 0;

//Inicializa as variáveis globais e cria pontos aleatórios
void inicializa() {
    srand(10);
    for(int i = 0; i < N; i++){
        pontosX[i] = (float) rand() / RAND_MAX;
        pontosY[i] = (float) rand() / RAND_MAX;
        oldCentNearPonto[i] = -1;
    }

    for(int i = 0; i < K; i++){
        centroidesX[i] = pontosX[i];
        centroidesY[i] = pontosY[i];
    }
}

//Calcula a distância euclidiana ao quadrado de modo a descobrir o cluster mais perto de cada ponto
void euclidiana(){
    //inicialização do número de pontos que cada cluster tem e do somatório dos pontos (serve para calcular a média)
    for (int i = 0; i < K; i++){
        NPontosClusters[i] = 0;
        SomatorioCentroidesX[i] = 0;
        SomatorioCentroidesY[i] = 0;
    }

    for (int i = 0; i < N; i++){
        //cálculo da distância de um ponto a cada cluster
        for (int j = 0; j < K; j++){
            float px __attribute__((aligned (32))) = pontosX[i];
            float cx __attribute__((aligned (32))) = centroidesX[j];
            float py __attribute__((aligned (32))) = pontosY[i];
            float cy __attribute__((aligned (32))) = centroidesY[j];
            distanciasCentroide[j] = ((px - cx) * (px - cx) + (py - cy) * (py - cy));
        }
        //atribuição do centróide mais perto do ponto, com a comparação das distâncias
        centroideNearPonto[i] = 0;
        int min __attribute__((aligned (32))) = 0;
        int c  __attribute__((aligned (32))) = 1;
        for (; c < K; c++)
            if (distanciasCentroide[c] < distanciasCentroide[min])
                min = c;
        
        centroideNearPonto[i] = min;
        
        NPontosClusters[min] += 1;
        SomatorioCentroidesX[min] += pontosX[i];
        SomatorioCentroidesY[min] += pontosY[i];
    }
}


int main(){
    inicializa();
    euclidiana();
   
    int vezes __attribute__((aligned (32))) = 0;
    
    while(!igual){
        igual = 1;
        for (int j = 0; j < N; j++){
            if (oldCentNearPonto[j] != centroideNearPonto[j]){
                igual = 0;
                oldCentNearPonto[j] = centroideNearPonto[j];
            }
        }            

        if (igual == 0){
            vezes++;
            for(int i = 0; i < K; i++){
                centroidesX[i] = SomatorioCentroidesX[i] / NPontosClusters[i];
                centroidesY[i] = SomatorioCentroidesY[i] / NPontosClusters[i];
            }
            euclidiana();
        }
    }

    printf("N = %d, K = %d\n", N, K);
    for (int i = 0; i < K; i++)
        printf("Center: (%.3f, %.3f) : Size: %.0f\n", centroidesX[i], centroidesY[i], NPontosClusters[i]);

    printf("Iterations: %d\n", vezes);

    return 0;
}