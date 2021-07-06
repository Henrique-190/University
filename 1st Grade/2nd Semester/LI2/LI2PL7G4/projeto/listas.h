#ifndef RASTROSLI2_LISTAS_H
#define RASTROSLI2_LISTAS_H

/**
@file listas.h
Funções que alteram as listas.
*/

/** @struct nodo
 * @brief Lista ligada.
 * @var nodo::valor
 * Valor apresentado na lista.
 * @var nodo::proximo
 * Apontador para a cauda da lista.
*/
typedef struct nodo {
    void *valor;
    struct nodo *proximo;
}
/**
\brief Nodo.
*/ 
NODO, 
/**
\brief Lista ligada.
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
 \param *val Valor que vai ser colocado na cabeça da lista.
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


/**
\brief Função que remove a cabeça da lista (libertando o espaço ocupado) e devolve a cauda da lista.
 \param l Lista.
 \returns  A lista inicial mas sem a cabeça.
*/
LISTA remove_cabeca(LISTA l);


/**
\brief Função que calcula o tamanho da lista.
 \param l Lista.
 \returns  O tamanho.
*/
int tamanho_lista(LISTA l);

#endif //RASTROSLI2_LISTAS_H
