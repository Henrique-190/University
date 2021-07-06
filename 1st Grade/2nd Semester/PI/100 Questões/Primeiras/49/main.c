#include <stdio.h>
#include <math.h>

typedef struct posicao {
    int x, y;
} Posicao;

int maiscentral (Posicao pos[], int N) {
    float a = sqrt((pow(pos[0].x, 2) + pow(pos[0].y, 2)));
    a++;
    float b;
    int ii = 0;
    int i = 0;
    while (i < N) {
        b = sqrt((pow(pos[i].x, 2) + pow(pos[i].y, 2)));
        if (a > b) {
            a = b;
            ii = i;
        }
        i++;
    }
    return ii;
}