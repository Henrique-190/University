#include <stdio.h>
#include <math.h>

typedef struct posicao {
    int x, y;
} Posicao;

int vizinhos (Posicao p, Posicao pos[], int N){
    int i = 1;
    int r = 0;
    while(i<N){
        if (pos[i].x-p.x<=1 && pos[i].x-p.x>=(-1) && pos[i].y-p.y<=1 && pos[i].y-p.y>=(-1))
            r++;
        i++;
    }
    return 0;
}
