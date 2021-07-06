/**
 * @file Pagination.h
 * @brief Módulo responsável pela manipulação do Interpretador de comandos
 *
 * @author Bohdan Malanka (a93300)
 * @author Henrique José Fernandes Alvelos (a93316)
 * @author Diogo da Silva Rebelo (a93278)
 * 
 */
#ifndef INTERPRETER_H
#define INTERPRETER_H

#include "SGR.h"
#include "Pagination.h"

/**
 * @brief Pointer para a struct variables que contém um apontador para a GHashTable de Tables
 *
 */
typedef struct variables *V_HASH;

/**
 * @brief Função que liberta a memória ocupada pela struct variables
 * @param struct a destruir
 */
void freeVHash(V_HASH hash);

/**
 * @brief Função responsável pela inicialização da struct (aloca memória para variables)
 * @return struct inicializada
 */
V_HASH initVariables();

/**
 * @brief Função que obtém a hashTable de tables
 * @param hash Pointer para a struct que contém a hash
 * @return GHashTable* de tables
 */
GHashTable* getVarHashTable(V_HASH hash);

/**
 * @brief Função que remove os espaços de uma string
 * @param command string em questão
 */
void removeSpaces (char* command);

/**
 * @brief Função que recebe um comando na forma de string e o divide em parâmteros colocando-os num StrArray
 * @param line string com o comando recebido
 * @return StrArray com os elementos do comando separados por relevância e de acordo com a parametrização
 */
StrArray getCommandFromUser(char* line);

/**
 * @brief Função que coloca cada comando recebido (já parametrizado) no respetivo índice do Array de Pointers
 * @param line Conjunto de comandos (previamente separados por um espaço)
 * @return GPtrArray* com os resptivos comandos prontos a usar pelo interpretador
 */
GPtrArray* getCommands (char* line);

/**
 * @brief Função que converte um operator em char* para um operator em OPERATOR
 * @param oper string com o operador
 * @return OPERATOR
 */
OPERATOR getOperator(char* oper);

/**
 * @brief Função que valida uma palavra, ou seja, que recebe a string e verifica se cada elemento é uma letra
 * verifica se a string pode ser usada como nome de uma variável
 * @param word string com a respetiva palavra a validar
 * @return 1 se for palavra ou 0 se não for
 */
int validWord(const char* word);

/**
 * @brief Remove na string a char fornecida
 * @param s string
 * @param c careter
 */
void removeChar(char* s, char c);
/**
 * @brief Substitui todas as ocorrências de uma substring fornecida.
 * @param line string na qual é feita a substituição
 * @param oldString string a substituir
 * @param newString que substitui essa ocorrência
 * @return string resultante das substituições
 */
char* replaceWord(const char* line, const char* oldString, const char* newString);

/**
 * @brief Função que gere o interpretador
 * @param sgr struct da Base de Dados
 * @return 0 se tiver sucesso, 1 se ocorrer erro
 */
int interpreter(SGR sgr);

#endif