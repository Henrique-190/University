#define BUF_SIZE 1024
#include <stdio.h>
#include "dados.h"

void mostrar_tabuleiro(ESTADO *e,FILE *stdout,int cmd) {
    COORDENADA c;
    for (int lin = 8; lin > 0; lin--) {
        if (cmd == 2) fprintf(stdout, "%d ", lin);
        for (int col = 0; col <= 7; col++) {
            c.linha = lin - 1;
            c.coluna = col;
            if (cmd == 1) fprintf(stdout, "%c", obter_estado_casa(e, c));
            else fprintf(stdout, "%c ", obter_estado_casa(e, c));
        }
        fprintf(stdout, "\n");
    }
    if (cmd == 2) fprintf(stdout, "  a b c d e f g h \n");
}
