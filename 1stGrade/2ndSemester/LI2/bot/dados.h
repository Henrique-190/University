#ifndef BOT_DADOS_H
#define BOT_DADOS_H

/**
 \brief BUF_SIZE
 */
#define BUF_SIZE 1024

/**
@file dados.h
Funções que vão buscar ou alterar dados ao estado do jogo.
Estrutura de dados do jogo.
*/


/**
\brief Tipo de dados para a casa.
*/
typedef enum {
    UM = '1',
    DOIS = '2',
    VAZIO = '.',
    BRANCA = '*',
    PRETA = '#'
} CASA;


/**
\brief Tipo de dados para as coordenadas.
*/
typedef struct {
/**
\brief Coluna da coordenada.
*/
    int coluna;
/**
\brief Linha da coordenada.
*/
    int linha;
} COORDENADA;


/**
\brief Tipo de dados para a jogada.
*/
typedef struct {
/**
\brief Coordenada do jogador 1.
*/
    COORDENADA jogador1;
/**
\brief Coordenada do jogador 2.
*/
    COORDENADA jogador2;
} JOGADA;


/**
\brief Tipo de dados para as jogadas.
*/
typedef JOGADA JOGADAS[32];


/**
\brief Tipo de dados para o estado.
*/


typedef struct {
    /** O tabuleiro. */
    CASA tab[9][9];
    /** As jogadas. */
    JOGADAS jogadas;
    /** O número das jogadas, usado no prompt. */
    int num_jogadas;
    /** O jogador atual. */
    int jogador_atual;
    /** O nº de comando, usado no prompt. */
    int num_comando;
    /** A coordenada da última jogada. */
    COORDENADA ultima_jogada;
} ESTADO;



/**
\brief Função que atualiza o número do comando.
 \param *e Estado;
 \param cmd Último comando usado.
*/
void altera_comando(ESTADO *e, int cmd);


/**
\brief Função que armazena as duas coordenadas no array das jogadas no estado
 \param c1 Coordenada do jogador 1;
 \param c2 Coordenada do jogador 2;
 \param i Número da jogada;
 \param *estado Estado.
*/
void armazena_jogada(COORDENADA c1, COORDENADA c2, int i, ESTADO *estado);


/**
\brief Função que inicia o estado com o tabuleiro vazio. Atualiza-se o jogador atual para 2,
 o número de jogadas para -1 para que, depois com a chamada da refresh_board, o jogador atual
 passe a ser 1 e o número de jogadas passe a ser 0.
  \returns O estado inicializado, com a primeira jogada em e4.
*/
ESTADO *inicializar_estado();


/**
\brief Função que obtém o número do comando.
 \param *e Estado.
 \returns Número do comando, existem diferentes números consoante o tipo de comando.
*/
int obter_comando(ESTADO *e);


/**
\brief Função que obtem o estado atual da casa.
 \param *e Estado.
 \param c Coordenada dada;
 \returns Estado da coordenada.
*/
CASA obter_estado_casa(ESTADO *e, COORDENADA c);


/**
\brief Função que obtém o número do jogador atual.
 \param *e Estado.
 \returns O jogador que jogará a seguir.
*/
int obter_jogador_atual(ESTADO *e);


/**
\brief Função que obtem o número de jogadas efetuadas
 \param *e Estado.
 \returns O número de jogadas.
*/
int obter_numero_de_jogadas(ESTADO *e);


/**
\brief Função que obtém a última jogada.
 \param *e Estado.
 \returns A última jogada.
*/
COORDENADA obter_ultima_jogada(ESTADO *e);


/**
\brief Função que vai buscar uma coordenada de um jogador a uma jogada
 \param *e Estado;
 \param i Número da jogada;
 \param jogador Jogador.
*/
COORDENADA obter_x_jogada(ESTADO *e,int i,int jogador);


/**
\brief Função que atualiza o tabuleiro com a nova jogada.
 \param *e Estado;
 \param c Última coordenada dada pelo jogador.
*/
void refresh_board (ESTADO *e, COORDENADA c);


/**
\brief Função que coloca altera o estado de cada casa de acordo com a char string recebida.
 \param linha Apontador para a string que é uma linha do tabuleiro;
 \param *estado Estado;
 \param l Número da linha.
*/
void str_to_casa (const char *linha, ESTADO *estado, int l);

#endif //BOT_DADOS_H
