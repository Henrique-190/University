/**
 * @file Reviews.h
 * @brief Módulo responsável pela manipulação das reviews
 * 
 * @author Bohdan Malanka (a93300)
 * @author Henrique José Fernandes Alvelos (a93316)
 * @author Diogo da Silva Rebelo (a93278)
 * 
 */
#ifndef REVIEWS_H
#define REVIEWS_H

#include "Review.h"

/**
 * @brief Apontador para a struct Reviews
 * 
 */
typedef struct reviews *Reviews;

/**
 * @brief Obtém a hashtable das Reviews
 * 
 * @param revs Struct Reviews
 * @return GHashTable* Hashtable
 */
GHashTable *getHASH(Reviews revs);

/**
 * @brief Obtém todos os valores de uma hashtable
 * 
 * @param revs Struct Reviews
 * @return GList* Lista dos valores
 */
GList *getALL_reviews(Reviews revs);

/**
 * @brief Inicializa uma Struct Reviews
 * 
 * @return Reviews Reviews
 */
Reviews initREVIEWS();

/**
 * @brief Liberta memória da struct Reviews 
 *  
 * @param revs
 */
void freeREVIEWS(Reviews rev);

#endif