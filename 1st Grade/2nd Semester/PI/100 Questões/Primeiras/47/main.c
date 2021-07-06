#include <stdio.h>

typedef enum movimento {Norte, Oeste, Sul, Este} Movimento;
typedef struct posicao {
    int x, y;
} Posicao;

Posicao posFinal (Posicao inicial, Movimento mov[], int N) {
    int i = 0;

    while (i < N) {
        if (mov[i] == Norte)
            inicial.y++;
        else if (mov[i] == Sul)
            inicial.y--;
        else if (mov[i] == Este)
            inicial.x++;
        else inicial.x--;
    }

    return inicial;
}