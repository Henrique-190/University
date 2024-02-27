#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int n;
int k;
int threads = 1;

//Coordenadas X e Y dos N pontos, separados em dois arrays
float *pontosX;
float *pontosY;

//Coordenadas X e Y dos K centróides, separados em dois arrays
float *centroidesX;
float *centroidesY;

//Índice das coordenadas do centróide mais próximo de cada ponto
int *centroideNearPonto;

//Distância de cada centróide a um ponto
float *distanciasCentroide;

//Somatório das coordenadas X e Y dos pontos pertencentes a cada cluster, separados em dois arrays
float *SomatorioCentroidesX;
float *SomatorioCentroidesY;

//Número de pontos que cada cluster tem
float *NPontosClusters;

//Índice das coordenadas do centróide mais próximo de cada ponto na iteração anterior
int *oldCentNearPonto;
int igual = 0;

//Inicializa as variáveis globais e cria pontos aleatórios
void inicializa() {
    pontosX = malloc(sizeof(int) * n);
    pontosY = malloc(sizeof(int) * n);

    centroidesX = malloc(sizeof(int) * k);
    centroidesY = malloc(sizeof(int) * k);

    centroideNearPonto = malloc(sizeof(int) * n);

    distanciasCentroide = malloc(sizeof(int) * k);

    SomatorioCentroidesX = malloc(sizeof(int) * k);
    SomatorioCentroidesY = malloc(sizeof(int) * k);

    NPontosClusters = malloc(sizeof(int) * k);

    oldCentNearPonto = malloc(sizeof(int) * n);

    srand(10);
    //srand(time(NULL) ^ omp_get_thread_num());

    for (int i = 0; i < n; i++) {
        pontosX[i] = (float) rand() / RAND_MAX;
        pontosY[i] = (float) rand() / RAND_MAX;
        oldCentNearPonto[i] = -1;
    }

    for (int i = 0; i < k; i++) {
        centroidesX[i] = pontosX[i];
        centroidesY[i] = pontosY[i];
    }
}

//Calcula a distância euclidiana ao quadrado de modo a descobrir o cluster mais perto de cada ponto
void euclidiana() {
    int min __attribute__((aligned (32))) = 0;

#pragma omp parallel for schedule(static,100) num_threads(threads)
    //inicialização do número de pontos que cada cluster tem e do somatório dos pontos (serve para calcular a média)
    for (int i = 0; i < k; i++) {
        NPontosClusters[i] = 0;
        SomatorioCentroidesX[i] = 0;
        SomatorioCentroidesY[i] = 0;
    }

#pragma omp parallel for reduction(min:min) reduction(+:NPontosClusters[:k], SomatorioCentroidesX[:k], SomatorioCentroidesY[:k]) num_threads(threads) schedule(static,20)
    for (int i = 0; i < n; i++) {
        //cálculo da distância de um ponto a cada cluster

        for (int j = 0; j < k; j++) {
            float px __attribute__((aligned (32))) = pontosX[i];
            float cx __attribute__((aligned (32))) = centroidesX[j];
            float py __attribute__((aligned (32))) = pontosY[i];
            float cy __attribute__((aligned (32))) = centroidesY[j];
            distanciasCentroide[j] = ((px - cx) * (px - cx) + (py - cy) * (py - cy));
        }

        //atribuição do centróide mais perto do ponto, com a comparação das distâncias
        centroideNearPonto[i] = 0;
        min = 0;
        int c  __attribute__((aligned (32))) = 1;

        for (c = 1; c < k; c++)
            if (distanciasCentroide[c] < distanciasCentroide[min])
                min = c;


        centroideNearPonto[i] = min;
        NPontosClusters[min] += 1;
        SomatorioCentroidesX[min] += pontosX[i];
        SomatorioCentroidesY[min] += pontosY[i];
    }
}



int main(int argc, char ** argv) {
    double start_time, end_time;
    start_time = omp_get_wtime();
        n = atoi(argv[1]);
        k = atoi(argv[2]);

        if (argc == 4)
            threads = atoi(argv[3]);

        inicializa();

        euclidiana();

        int vezes __attribute__((aligned (32))) = 0;

        while (!igual) {
            igual = 1;
            for (int j = 0; j < n; j++) {
                if (oldCentNearPonto[j] != centroideNearPonto[j]) {
                    igual = 0;
                    oldCentNearPonto[j] = centroideNearPonto[j];
                }
            }

            if (igual == 0 && vezes < 20) {
                vezes++;

                for (int i = 0; i < k; i++) {
                    centroidesX[i] = SomatorioCentroidesX[i] / NPontosClusters[i];
                    centroidesY[i] = SomatorioCentroidesY[i] / NPontosClusters[i];
                }
                euclidiana();
            }
        }

    printf("N = %d, K = %d\n", n, k);

    for (int i = 0; i < k; i++)
        printf("Center: (%.3f, %.3f) : Size: %.0f\n", centroidesX[i], centroidesY[i], NPontosClusters[i]);

    printf("Iterations: %d\n", vezes);
    end_time = omp_get_wtime();
    printf("%f \n", (end_time - start_time));

    return 0;
}