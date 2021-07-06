#ifndef RASTROSLI2_LOGICA_H
#define RASTROSLI2_LOGICA_H

#include "listas.h"

/**
@file logica.h
Funções que verificam as jogadas e se o jogo acabou.
*/

/**
\brief Função que inicia o jogo.
 \param *e Estado recebido.
 \param c Última coordenada recebida pelo jogador.
*/
void jogar(ESTADO *e, COORDENADA c);


/**
\brief Função que verifica se a coordenada é válida. Para ser válido, ela precisa de
 ser adjacente à última coordenada e o estado da sua casa precisa de ser VAZIO, UM ou DOIS.
 \param e Estado recebido;
 \param c Última coordenada recebida pelo jogador.
 \returns Verdadeiro ou falso (1 ou 0, respetivamente) quanto à possibilidade da coordenada.
 */
int verifica_coord (ESTADO *e, COORDENADA c);


/**
\brief Função que verifica se o jogo acabou. Testa todas as possibilidades de jogada.
 \param e Estado.
 \returns o número do jogador vencedor (1 ou 2) ou
  um número que mostra que ainda há hipoteses de jogar (3 ou mais).*/
int fim_jogo(ESTADO *e);

#endif //RASTROSLI2_LOGICA_H