/**
 * @file TopBusinesses.h
 * @brief API do módulo TopBusinesses
 * 
 * @author Bohdan Malanka (a93300)
 * @author Henrique José Fernandes Alvelos (a93316)
 * @author Diogo da Silva Rebelo (a93278)
 */
#ifndef TOP_BUSINESSES_H_
#define TOP_BUSINESSES_H_

#include "TopBusiness.h"
#include "Businesses.h"

/**
 * @brief Pointer para struct top_businesses que contém  duas GHashTable de TopBusiness, uma para as Cities e outra para as Categories
 * 
 */
typedef struct top_businesses* TopBusinesses;

/**
 * @brief Função que devolve a HashTable de TopBusiness
 * 
 * @param cs TopBusinesses a qual se pretende obter a HashTable
 * @param which Flag que determina qual HashTable retornar, 1 para as Cities 0 para Categories
 * @return GHashTable* pretendida
 */
GHashTable* getHashTable_Top(TopBusinesses cs,int which);

/**
 * @brief Função que instancia um TopBusinesses
 * 
 * @return TopBusinesses novo 
 */
TopBusinesses initTopBusinesses();

/**
 * @brief Função load de TopBusinesses para as Categorias;
 * 
 * @param b Business a adicionar
 * @param tpb TopBusinesses
 */
void addBUS_byCTG(Business b,TopBusinesses tpb);

/**
 * @brief Função load de TopBusinesses para as Cities;
 * 
 * @param b Business a adicionar
 * @param tpb TopBusinesses
 */
void addBUS_byCITY(Business b,TopBusinesses tpb);

/**
 * @brief Liberta memória da struct TopBusinesses
 * 
 * @param cs TopBusinesses destruído
 */
void freeTopBusinesses(TopBusinesses cs);

void sortTopBusinessByStars(TopBusinesses tb);

/**
 * @brief Função responsável pela Query 6, ordena a Glist de cada City presente na HashTable e vai buscar os primeiros top
 * 
 * @param top_b TopBusiness com a informação das Cities
 * @param top Top businesses de cada city
 * @return GPtrArray* Array de StrArray, em que cada indice é uma linha que contém Business_ID e Name num StrArray
 */
GPtrArray* getTopBusinessesByCity(TopBusinesses top_b, int top);

/**
 * @brief Função responsável pela Query 8, ordena a Glist da Category dada presente na HashTable e vai buscar os primeiros top
 * 
 * @param top_b TopBusiness com a informação das Categories
 * @param top  Top businesses da category
 * @param category Category dada
 * @return GPtrArray* Array de StrArray, em que cada indice é uma linha que contém Business_ID, Name e Stars num StrArray
 */
GPtrArray* getTopBusinessesByCategory(TopBusinesses top_b, int top, char* category);

#endif