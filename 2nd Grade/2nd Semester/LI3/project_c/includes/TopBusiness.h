/**
 * @file TopBusiness.h
 * @brief API responsável pelo módulo do TopBusiness
 * 
 * @author Bohdan Malanka (a93300)
 * @author Henrique José Fernandes Alvelos (a93316)
 * @author Diogo da Silva Rebelo (a93278)
 * 
 */
#ifndef TOP_BUSINESS_H_
#define TOP_BUSINESS_H_

#include "Business.h"

/**
 * @brief Pointer para struct top_business, em que o campo Name é o nome de uma City ou Caterory e o campo business é uma Glist de Business
 * 
 */
typedef struct top_business* TopBusiness;

/**
 * @brief Função que obtém o Name de TopBusiness
 * 
 * @param c TopBusiness do qual se pretende retirar 
 * @return char* String que contém o Nome de TopBusiness
 */
char* getTopBName(TopBusiness c);

/**
 * @brief Função que atualiza o nome da TopBusiness
 * 
 * @param c TopBusiness na qual se atualiza o Name 
 * @param name Name nova da TopBusiness
 */
void setTopBName(TopBusiness c, char* name);

/**
 * @brief Função que devolve a Lista de businesses do TopBusiness
 * 
 * @param c TopBusiness do qual se pretende obter o GList
 * @return GList* Lista ligada em que cada elemento é um objeto do tipo Business
 */
GList* getBusinessList(TopBusiness c);

/**
 * @brief Função que atualiza a Lista de businesses do TopBusiness
 * 
 * @param c TopBusiness ao qual se atualiza a GList
 * @param bus Lista ligada nova 
 */
void setBusinessList(TopBusiness c, GList *bus);

/**
 * @brief Construtor vazio de TopBusiness 
 * 
 * @return TopBusiness novo
 */
TopBusiness initTopBusiness();

/**
 * @brief Construtor parametrizado de TopBusinesss
 * 
 * @param n Name novo
 * @param business Lista de businesses nova 
 * @return TopBusiness novo
 */
TopBusiness initTopB(char* n, GList* business);

/**
 * @brief Função que faz prepend à Lista de business
 * 
 * @param c Objeto do tipo TopBusiness
 * @param b Objeto do tipo Business a ser inserido
 */
void addToBusinessList(TopBusiness c, Business b);

/**
 * @brief Função que atualiza o Name e a GList do TopBusiness
 * 
 * @param tb Objeto do tipo TopBusiness
 * @param b Objeto do tipo Business
 */
void setTopBusiness(TopBusiness tb, Business b);

/**
 * @brief Função que liberta memória de uma TopBusiness
 * 
 * @param c TopBusiness destruida
 */
void freeTopBusiness(TopBusiness c);

#endif