/**
 * @file AuxStructs.h
 * @brief Estrutura de dados auxiliar
 * 
 * @author Bohdan Malanka (a93300)
 * @author Henrique José Fernandes Alvelos (a93316)
 * @author Diogo da Silva Rebelo (a93278)
 */
#ifndef AUX_STRUCTS_H
#define AUX_STRUCTS_H 

#include <glib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <time.h>


/**
 * @brief Pointer para um GArray da biblioteca glib.h
 * 
 */
typedef GArray* StrArray;

/**
 * @brief Função que devolve o comprimento do array
 * 
 * @param st Array de Strings 
 * @return int Comprimento do array
 */
int getLength(StrArray st);

/**
 * @brief Devolve um elemento(String) do array dado um índice
 * 
 * @param st Array do qual de pretende obter o elemento
 * @param index Índice do array onde está o elemento
 * @return char* String de retorno
 */
char* getStrElement(StrArray st, int index);

/**
 * @brief Instancia um StrArray novo
 * 
 * @return StrArray StrArray novo
 */
StrArray initStrArray();

/**
 * @brief Instancia um StrArray novo com um tamanho pré-definido
 * 
 * @param N tamanho inicial do novo StrArray
 * @return StrArray StrArray novo
 */
StrArray initStrArraySized(int N);

/**
 * @brief Adiciona um elemento novo no fim do StrArray
 * 
 * @param st StrArray no qual se adiciona o elemento
 * @param value String que é adicionada ao StrArray
 */
void addToStrArray(StrArray st,  char* value );

/**
 * @brief Adiciona um número variável de elementos no StrArray
 * 
 * @param st StrArray no qual se faz a inserção
 * @param count número de elementos a inserir
 * @param ... Strings que vão sendo inseridas no StrArray
 */
void addValuesStrArray(StrArray st,int count,...);

/**
 * @brief Adiciona no StrArray um elemento numa posição específica
 * 
 * @param st StrArray no qual se faz a inserção
 * @param index Posição da inserção
 * @param value String que vai ser inserida
 */
void insertToStrArray(StrArray st, guint index, gpointer value);

/**
 * @brief Função que adiciona um conjunto de elementos ao StrArray
 * 
 * @param st StrArray no qual se faz a inserção
 * @param data Array de Strings que vão ser inseridas no StrArray
 * @param len Número de elementos que vão ser inseridos
 * @return StrArray StrArray com os novos elementos inseridos
 */
StrArray addElementsToStrArray(StrArray st, char** data, int len);

/**
 * @brief Função que substitui a pontuação de uma String por um espaço
 * 
 * @param p String a qual vai-se remover a pontuação
 */
void remove_punct(char *p);

/**
 * @brief Função que adiciona um número variável de elementos ao GPtrArray*
 * 
 * @param gptr Pointer para GPtrArray ao qual vai ser adicionado elementos 
 * @param count Número de elementos 
 * @param ... Elementos que são adicionados 
 */
void addTOGPtrArray(GPtrArray *gptr,int count,...);

/**
 * @brief Função que passa as letras de uma String a minúsculas
 * 
 * @param s String a processar
 * @return char* String processada
 */
char* toLower(char* s);

/**
 * @brief Função que verifica se uma palavra aparece numa linha de texto
 * 
 * @param word1 String a comparar 
 * @param text String que contém a linha de texto
 * @return int Retorna 1 se a word ocorre em text ou 0 caso contrário
 */
int compareword(char* word1, char* text);
/**
 * @brief Função que adiciona um elemento ao GPtrArray numa dada posição
 * 
 * @param array Pointer para GPtrArray ao qual vei ser adicionado o elemento
 * @param index Posição onde vai ser inserido o elemento
 * @param p Elemento do tipo genérico que vai ser inserido 
 */
void addToArrayIndex(GPtrArray * array, int index, gpointer p);

/**
 * @brief Função que destrói um StrArray, libertando memória de cada elemento
 * 
 * @param st StrArray que vai ser destruído
 */
void destroyStrArray(StrArray st);

#endif