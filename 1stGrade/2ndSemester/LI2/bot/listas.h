#ifndef BOT_LISTAS_H
#define BOT_LISTAS_H

/**
@file listas.h
Funções que alteram as listas.
*/

/**
\brief Estrutura do nodo.
*/
typedef struct nodo {
/**
\brief Apontador do valor da lista.
*/
    void *valor;
/**
\brief Apontador do próximo valor da lista.
*/
    struct nodo *proximo;
} NODO,
/**
\brief Lista.
*/
*LISTA;


/**
\brief Função que cria uma lista.
 \returns Uma lista.
*/
LISTA criar_lista();


/**
\brief Função que devolve a cabeça da lista.
 \param l Lista.
 \returns  Valor que estava na cabeça.
*/
void *devolve_cabeca(LISTA l);


/**
\brief Função que insere um valor na cabeça da lista.
 \param l Lista;
 \param val Valor que vai ser colocado na cabeça da lista.
 \returns  Lista alterada.
*/
LISTA insere_cabeca(LISTA l, void *val);


/**
\brief Função que verifica se a lista está vazia.
 \param l Lista.
 \returns  Verdadeiro ou falso.
*/
int lista_esta_vazia(LISTA l);


/**
\brief Função que devolve a cauda da lista.
 \param l Lista.
 \returns  A lista inicial mas sem a cabeça.
*/
LISTA proximo(LISTA l);

#endif //BOT_LISTAS_H
