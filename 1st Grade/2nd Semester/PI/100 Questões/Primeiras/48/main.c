#include <stdio.h>

typedef enum movimento {Norte, Oeste, Sul, Este} Movimento;
typedef struct posicao {
    int x, y;
} Posicao;

int caminho (Posicao inicial, Posicao final, Movimento mov[], int N) {
    int i = 0;

    while (i < N) {
        if (inicial.y < final.y) {
            mov[i] = Norte;
            inicial.y += 1;
            i++;
        }
        if (inicial.y > final.y) {
            mov[i] = Sul;
            inicial.y -= 1;
            i++;
        }

        if (inicial.x < final.x) {
            mov[i] = Este;
            inicial.x += 1;
            i++;
        }
        if (inicial.x > final.x) {
            mov[i] = Oeste;
            inicial.x -= 1;
            i++;
        }
        if ((inicial.x == final.x) && (inicial.y == final.y))
            return i;

    }
    if ((inicial.x != final.x) || (inicial.y != final.y))
        return -1;
    else
        return 0;
}