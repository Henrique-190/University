#include <math.h>
#include "dados.h"
#include "listas.h"
#include "io_aux.h"
#include "logica.h"
#include "io.h"

/**
\brief Função que calcula a distância euclidiana e que devolve a coordenada com menor distância.
 \param l Lista de coordenadas;
 \param e Estado do jogo.
 \returns A coordenada com menor distância.
*/
COORDENADA dist_eucl(LISTA l, ESTADO *e) {
    COORDENADA final = obter_jogador_atual(e) == 1 ? (COORDENADA) {0, 0} : (COORDENADA) {7, 7};
    double resultado = 12;
    double restemp;
    COORDENADA result;
    for (; !lista_esta_vazia(l); l = proximo(l)) {
        COORDENADA *coord;
        coord = (COORDENADA *) devolve_cabeca(l);
        restemp = sqrt(pow((*coord).linha - final.linha, 2) + pow((*coord).coluna - final.coluna, 2));
        if (restemp < resultado) {
            resultado = restemp;
            result.linha = coord->linha;
            result.coluna = coord->coluna;
        }
    }
    return result;
}


/**
\brief Função principal do projeto.
 \param argc Número de argumentos;
 \param argv Os argumentos.
*/
int main(int argc, char **argv) {
    if (argc == 3) {
        ESTADO *e;
        e = inicializar_estado();
        *e = le(argv[1]);
        LISTA l = l_coord_adj(obter_ultima_jogada(e), obter_jogador_atual(e));
        l = hipord(l, e);

        if (!jogada_favoravel(l, e)) {
            COORDENADA melhor = dist_eucl(l, e);
            jogar(e, melhor);
        }

        grava(argv[2],e);
        return 0;
    }
}