#ifndef RASTROSLI2_INTERFACE_H
#define RASTROSLI2_INTERFACE_H

#include <stdio.h>

/**
@file interface.h
Funções que modificam a interface do jogo.
*/

/**
\brief Função que interpreta o comando dado pelo utilizador.
 \param *antigoe Estado antigo, usado para o comando pos;
 \param *e Estado recebido;
 \param *ficheiro Apontador para o ficheiro, usado para os comandos ler e gr.
 \returns Verdadeiro ou falso (1 ou 0) se o comando dado é valido.
*/
int interpretador(ESTADO *antigoe, ESTADO *e, FILE *ficheiro);


/**
\brief Função que mostra o tabuleiro ao receber um estado
 \param e Estado;
 \param stdout Apontador do ficheiro para onde vai imprimir o tabuleiro;
 \param cmd Número do comando.
*/
void mostrar_tabuleiro(ESTADO *e,FILE *stdout,int cmd);


/**
\brief Função que mostra o tabuleiro, o número de jogadas, o próximo jogador,
 a última jogada e o último comando usado.
 \param e Estado recebido.
 */
void prompt(ESTADO *e);


/**
\brief Função que mostra o vencedor do jogo.
 \param jogador Jogador que venceu o jogo.
*/
void vencedor(int jogador);

#endif //RASTROSLI2_INTERFACE_H
