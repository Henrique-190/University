#include <assert.h>
#include <mpi.h>
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

int n;
int k;
int threads = 1;

//Coordenadas X e Y dos N pontos
float *pontos;

//Coordenadas X e Y dos K centróides
float *centroides;

//Distância de cada centróide a um ponto

//Somatório das coordenadas X e Y dos pontos pertencentes a cada cluster, separados em dois arrays
float *SomatorioCentroidesX;
float *SomatorioCentroidesY;

//Número de pontos que cada cluster tem
int *NPontosClusters;

//Índice das coordenadas do centróide mais próximo de cada ponto na iteração anterior
int *oldCentNearPonto;
int igual = 0;


float *create_rand_nums(int num_elements) {
    float *rand_nums = (float *)malloc(sizeof(float) * num_elements * 2);
    assert(rand_nums != NULL);
    int i;
    for (i = 0; i < num_elements * 2; i++) {
        rand_nums[i] = (rand() / (float)RAND_MAX);
    }
    return rand_nums;
}



int main(int argc, char ** argv) {
    if (argc != 3) {
        fprintf(stderr, "Args errados\n");
        exit(1);
    }

    double start_time, end_time;
    start_time = omp_get_wtime();

    
    n = atoi(argv[1]);
    k = atoi(argv[2]);
    int vezes = 0;

    MPI_Status status;
    MPI_Init(&argc, &argv);
    int world_rank;
    int world_size;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    centroides = malloc(sizeof(float) * k * 2);

 
    if (world_rank == 0) {
        pontos = create_rand_nums(n);

        for (int i = 0; i < k; i++){
            centroides[i*2] = pontos[i*2];
            centroides[(i*2)+1] = pontos[(i*2)+1];
        }
        NPontosClusters = (int *)calloc(k, sizeof(int));
        SomatorioCentroidesX = (float *)calloc(k, sizeof(float));
        SomatorioCentroidesY = (float *)calloc(k, sizeof(float));
    }
    
    int elements_per_proc = n/world_size * 2;
    float *sub_pontos = (float *)calloc(elements_per_proc, sizeof(float));
    MPI_Scatter(pontos,                 elements_per_proc,      MPI_FLOAT,      sub_pontos,                 elements_per_proc, MPI_FLOAT,   0, MPI_COMM_WORLD);
        
    while(vezes < 20){
        MPI_Bcast(centroides,               k * 2 ,  MPI_FLOAT,      0,      MPI_COMM_WORLD);
        
        float *sub_somX = (float *)calloc(k, sizeof(float));
        float *sub_somY = (float *)calloc(k, sizeof(float));
        int *sub_NPontosCentroide = (int *)calloc(k, sizeof(int));

        float sub_avg = 5;

        int min = 0;
        float *distanciasCentroide = malloc(sizeof(int) * k);
        int aaa = 0;
        for (int i = 0; i < elements_per_proc; i+=2) {     
            float px = sub_pontos[i];
            float py = sub_pontos[i+1];

            for (int j = 0; j < k; j++) {
                float cx = centroides[j*2];
                float cy = centroides[j*2+1];
                distanciasCentroide[j] = ((px - cx) * (px - cx) + (py - cy) * (py - cy));
            }

            min = 0;
            int c = 1;
            aaa++;
            for (c = 1; c < k; c++)
                if (distanciasCentroide[c] < distanciasCentroide[min])
                    min = c;

            sub_NPontosCentroide[min] += 1;
            sub_somX[min] += sub_pontos[i];
            sub_somY[min] += sub_pontos[i+1];
        }
        

        MPI_Reduce(sub_NPontosCentroide,        NPontosClusters,        k,  MPI_INT,      MPI_SUM,      0,      MPI_COMM_WORLD);
        MPI_Reduce(sub_somX,                    SomatorioCentroidesX,   k,  MPI_FLOAT,      MPI_SUM,    0,      MPI_COMM_WORLD);
        MPI_Reduce(sub_somY,                    SomatorioCentroidesY,   k,  MPI_FLOAT,      MPI_SUM,    0,      MPI_COMM_WORLD);

        MPI_Barrier(MPI_COMM_WORLD);

        free(sub_somX);
        free(sub_somY);
        free(sub_NPontosCentroide);

        if (world_rank == 0) {
            for (int i = 0; i < k; i++) {
                if (NPontosClusters[i]>0){
                    centroides[i] = SomatorioCentroidesX[i] / NPontosClusters[i];
                    centroides[i+1] = SomatorioCentroidesY[i] / NPontosClusters[i];
                }
            }
        }
        vezes++;
    }


    if(world_rank == 0){
        free(pontos);
        printf("N = %d, K = %d\n", n, k);
        int a = 0;

        for (int i = 0; i < k; i++){
            a += NPontosClusters[i];
            printf("Center: (%.3f, %.3f) : Size: %d\n", centroides[i], centroides[i+1], NPontosClusters[i]);
        }

        if(a!=n){
            printf("ERRADOOOOOOOOOO!!!!VCVASVHASDHJVDHHDHJASJDADAHVHJVADSJDSAJHJHKVDASDSA");
        }
        printf("Iterations: %d\n", vezes);
    
        end_time = omp_get_wtime();
        printf("Time: %f\n", (end_time - start_time));
    }

    MPI_Finalize();
    return 0;
}