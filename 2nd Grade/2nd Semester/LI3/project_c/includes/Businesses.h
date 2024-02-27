/**
 * @file Businesses.h
 * @brief API do modulo Businesses
 * 
 * Este módulo contém as funções necessárias para manipular um Businesses
 * 
 * @author Bohdan Malanka (a93300)
 * @author Henrique José Fernandes Alvelos (a93316)
 * @author Diogo da Silva Rebelo (a93278)
 */
#ifndef BUSINESSES_H_
#define BUSINESSES_H_

#include "Business.h"

/**
 * @brief Pointer para struct businesses
 * 
 */
typedef struct businesses* Businesses;

/**
 * @brief Função que obtém a HashTable de Businesses
 * 
 * @param bs Businesses do qual se obtém a HashTable
 * @return GHashTable* Hash Table com a key ID de Business e value um Business
 */
GHashTable* getHashTable_B(Businesses bs);

/**
 * @brief Função que instancia uma HashTable de Business com g_hash_table_new_full
 * 
 * @return Businesses Businesses novo
 */
Businesses initBusinesses();

/**
 * @brief Função que atualiza o número total de Stars e a lista de Reviews de um Business específico
 * 
 * @param star Stars para adicionar ao Business
 * @param business_id ID do qual Business inserir as Stars
 * @param bs Businesses que contém o Business desejado
 */
void addR_toBus(gfloat star,char *business_id,Businesses bs);

/**
 * @brief Algoritmo principal da query 2
 *
 * @param bs HashTables de Businesses 
 * @param letter Letra pela qual devem começar o Name do Business
 * @return GPtrArray* Array de pointers em que cada índice é um array que corresponde a uma linha da TABLE
 */
GPtrArray* getBusinessesByLetter(const Businesses bs, char letter);

/**
 * @brief Algoritmo principal da query 5
 * 
 * @param bs HashTables de Businesses
 * @param city City que deve conter o Business
 * @param stars Stars que o Business deve ter ou igual ou a mais
 * @return GPtrArray* Array de pointers em que cada índice é um array que corresponde a uma linha da TABLE
 */
GPtrArray* getBusinessesByStarsAndCity(Businesses bs, char* city, float stars);

/**
 * @brief Carrega o ficheiro que forma a struct Businesses
 * 
 * @param filename Nome do ficheiro
 * @param bs Struct Businesses
 * @return int Número de entradas válidas
 */
int loadBusinessesFromFile(char* filename, Businesses bs);

/**
 * @brief Função que liberta memória ocupada por Businesses
 * 
 * @param bs_s Businesses que vai ser destruido
 */
void freeBusinesses(Businesses bs_s);

#endif