/**
 * @file Business.h
 * @brief API do modulo Business
 * 
 * Este módulo contém as funções necessárias para manipular um Business
 * 
 * @author Bohdan Malanka (a93300)
 * @author Henrique José Fernandes Alvelos (a93316)
 * @author Diogo da Silva Rebelo (a93278)
 * 
 */
#ifndef BUSINESS_H
#define BUSINESS_H

#include "AuxStructs.h"

/**
 * @brief Pointer para struct business
 * 
 */
typedef struct business* Business;

/**
 * @brief Função que devolve o ID de um Business
 * 
 * @param bs Business do qual se pretende obter o ID
 * @return char* String do ID de Business
 */
char* getBusinessID(Business bs);

/**
 * @brief Função que devolve o Name de Business
 * 
 * @param bs Business do qual se pretende obter o nome
 * @return char* String que contém o Name do Business
 */
char* getBusinessName(Business bs);

/**
 * @brief Função que devolve a City de um Business
 * 
 * @param bs Business do qual se pretende obter a cidade
 * @return char* String que contém a City de Businesss
 */
char* getBusinessCity(Business bs);

/**
 * @brief Função que devolve o State de um Business
 * 
 * @param bs Business do qual se pretende obter o estado
 * @return char* String que contém o State do Business
 */
char* getBusinessState(Business bs);

/**
 * @brief Função que devolve as Categories do Businesss (sem parcing)
 * 
 * @param bs Business do qual se pretende obter as categorias 
 * @return char* String com as Categories (juntas) do Business
 */
char* getBusinessCategories(Business bs);

/**
 * @brief Função que retorna o número total de estrelas do Businesss
 * 
 * @param bs Business do qual se pretende obter o número total de Stars
 * @return float Total Stars do Business
 */
float getBusinessStars(Business bs);

/**
 * @brief Função que atualiza o número total de Stars do Business
 * 
 * @param bs Business ao qual se atualiza o atributo totalStars
 * @param star Número de Total Stars novo
 */
void setBusinessStars(Business bs, float star);

/**
 * @brief Função que retorna o número total de reviews do Business
 * 
 * @param bs Business do qual se pretende obter o número total de reviews
 * @return int Total Reviews do Business
 */
int getBusinessReviews(Business bs);

/**
 * @brief Função que atualiza o número total de reviews do Businesss
 * 
 * @param bs Business ao qual se atualiza o atributo totalReviews
 * @param reviews Número de Total Reviews novo
 */
void setBusinessReviews(Business bs, int reviews);

/**
 * @brief Função que calcula o número médio de Stars do Business
 * 
 * @param bs Business do qual se faz o cálculo do seu número de estrelas médio
 * @return float Média de Stars do Business
 */
float getBusinessAverageStars(Business bs);

/**
 * @brief Função que instancia um objeto de Business
 * 
 * @param bs_id Id do Business novo
 * @param name Name do Business novo 
 * @param city City do Business novo
 * @param state State do Business novo
 * @param ctg Categories do Businesss novo
 * @return Business Business novo
 */
Business initBusiness(char* bs_id, char* name, char* city, char* state, char* ctg);

/**
 * @brief Função que faz parcing de uma String válida e cria um Business novo
 * 
 * @param fileLine Linha que contém as informações necessárias do Business
 * @param fieldSeparator Delimitador que separa cada campo de Business
 * @return Business Business novo 
 */
Business initBusinessFromLine(char* fileLine, char* fieldSeparator);

/**
 * @brief Função que faz parcing das Categories e as guarda num StrArray
 * 
 * @param ctgs String que contém as Categories do Business
 * @return StrArray, Pointer do GArray, array de string, que contém as Categories separadas 
 */
StrArray parcingCategories(char* ctgs);

/**
 * @brief Função que faz a validação do Business
 * 
 * @param fileLine Business que vai ser verificado 
 * @param token Separador
 * @return int Retorna 1 se é valido ou 0 caso contrário
 */
int validBusiness(char* fileLine, char token);

/**
 * @brief Função clone(cópia) do Business
 * 
 * @param bs Business que vai ser copiado 
 * @return Business Business novo igual ao Business passado como parámetro
 */
Business cloneBusiness(Business bs);

/**
 * @brief Função que inprime as informações do Businesss
 * 
 * @param b Business do qual se obtém a info
 */
void printBusiness(Business b);

/**
 * @brief Função que liberta memória ocupada pelo Business
 * 
 * @param bs Business que vai ser destruído
 */
void destroyBusiness(Business bs);

#endif