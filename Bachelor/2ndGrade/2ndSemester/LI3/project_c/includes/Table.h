/**
 * @file Table.h
 * @brief Estrutura de dados que contém todas as funções que manipulam o tipo TABLE (contém um cabeçalho e o respetivo
 * conteúdo, onde ambos são um array de apontadores). O cabeçalho é um GPtrArray de strings, enquanto o content é um
 * GPtrArray de linhas da tabela (cada índice deste array contém a informação de uma linha). Note-se que pode ser
 * entendido como um GPtrArray de StrArrays.
 *
 * @author Bohdan Malanka (a93300)
 * @author Henrique José Fernandes Alvelos (a93316)
 * @author Diogo da Silva Rebelo (a93278)
 */
#ifndef TABLE_H
#define TABLE_H

#include "Reviews.h"
#include "Users.h"
#include "TopBusinesses.h"

/**
 * @brief Pointer para a struct table contém as informações de uma tabela
 *
 */
typedef struct table * TABLE;

/**
 * @brief Estrutura que aglomera os operadores. O operador NONE é um OPERATOR que não é utilizado com o mesmo
 * significado que os outros, é apenas usado caso uma string não possa ser convertida num operador válido
 *
 */
typedef enum operator {LT, EQ, GT, NONE} OPERATOR;

/**
 * @brief Função que obtém um Pointer para o array de apontadores do conteúdo de uma tabela
 * @param t tabela
 * @return respetivo conteúdo na forma de GPtrArray *
 */
GPtrArray *getContent(TABLE t);

/**
 * @brief Função que altera o conteúdo de uma tabela
 * @param t tabela
 * @param cont novo conteúdo
 */
void setContent(TABLE t, GPtrArray *cont);

/**
 * @brief Função que adiciona os cabeçalhos de uma tabela
 * @param table tabela
 * @param count número de elementos a adicionar do cabeçalho
 * @param ... respetivas strings que identificam cada célula do cabeçalho
 */
void addHeader(TABLE table,int count,...);

/**
 * @brief Função que obtém o cabeçalho de uma tabela
 * @param t tabela
 * @return Array de apontadores para o respetivo conteúdo
 */
GPtrArray *getHeader(TABLE t);

/**
 * @brief Função que substitui o cabeçalho de uma table por um novo
 * @param t tabela
 * @param head novo cabeçalho
 */
void setHeader(TABLE t, GPtrArray *head);

/**
 * @brief Função que inicializa a nova tabela, alocando a memória necessária para os seus campos
 * @return tabela inicializada
 */
TABLE initTable();

/**
 * @brief Função que liberta a memória alocada para a tabela
 * @param t tabela
 */
void freeTable(TABLE t);

/**
 * @brief Função que adiciona conteúdo à tabela, adicionando esse conteúdo por linhas
 * @param contentQ conteúdo a adicionar, normalmente manipulado em queries
 * @param table tabela
 */
void addContent(GPtrArray* contentQ, TABLE table);

/**
 * @brief Função que determina o número de campos separados por um delimitador, num um ficheiro
 * @param line linha lida
 * @return número de campos
 */
int getNumberOfFiels (char* line, char delim);

/**
 * @brief Função que obtém um elemento de uma tabela, um célula
 * @param table tabela
 * @param row linha
 * @param column coluna
 * @return elemento
 */
GPtrArray* gCopyFunc(GPtrArray* source);
TABLE getElemFromTable(TABLE table, int row, int column);

/**
 * @brief Função que converte uma tabela num ficheiro csv
 * @param x tabela
 * @param delim delimitador
 * @param filepath localização do ficheiro a obter
 */
void toCSV(TABLE x, char delim, char* filepath);

/**
 * @brief Função que converte um ficheiro csv na respetiva tabela
 * @param filepath localização do ficheiro
 * @param delim delimitador
 * @return tabela resultante da conversão
 */
TABLE fromCSV(char * filepath, char delim);

/**
 * @brief Função que imprime uma célula da tabela
 * @param conteúdo string a imprimir
 * @param size tamanho da string
 */
void printCelula(char* conteudo, int size);

/**
 * @brief Função que imprime um separador da tabela, seja ele uma linha de "-" ou "="
 * @param header cabeçalho
 * @param switcher flag
 */
void printSeparadorTable(GPtrArray* header, int switcher);

/**
 * @brief Função que imprime uma tabela
 * @param t tabela a imprimir
 */
void printTable(TABLE t);

/**
 * @brief Função que filtra um determinado elemento de uma tabela por comparação lexicográfica
 * @param x tabela
 * @param column_name nome da coluna
 * @param value valor
 * @param oper operador de comparação
 * @return tabela com elementos filtrados
 */
TABLE filter(TABLE x, char* column_name, char* value, OPERATOR oper);

/**
 * @brief Função que obtém uma projeção de colunas de uma tabela
 * @param x tabela
 * @param cols cabeçalho da subtabela a obter
 * @return projeção final
 */
TABLE proj(TABLE x, GPtrArray* cols);

/**
 * @brief Função que imprime o cabeçalho de uma tabela
 * @param t tabela
 */
void printHeader(TABLE t);

/**
 * @brief Função que imprime o conteúdo de uma tabela, utilizada para obter a paginação
 * @param t tabela
 * @param start inicio da pagína
 * @param end fim da página
 */
void printContent(TABLE t, int start, int end);

#endif