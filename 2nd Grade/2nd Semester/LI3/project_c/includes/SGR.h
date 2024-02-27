#ifndef SGR_H
#define SGR_H

#include "Table.h"

/**
 * @brief Apontador para a struct sgr
 * 
 */
typedef struct sgr *SGR;

/**
 * @brief Obtém o objeto Users
 * 
 * @param sgr Struct sgr
 * @return Users 
 */
Users get_Users(SGR sgr);

/**
 * @brief Define o objeto Users
 * 
 * @param sgr Struct sgr
 * @param us_s 
 */
void set_Users(SGR sgr,Users us_s);

/**
 * @brief Obtém o objeto Businesses
 * 
 * @param sgr Struct Businesses
 * @return Businesses 
 */
Businesses get_Businesses(SGR sgr);

/**
 * @brief Define o objeto Businesses
 * 
 * @param sgr Struct sgr
 * @param bs_s 
 */
void set_Businesses(SGR sgr,Businesses bs_s);

/**
 * @brief Obtém o objeto Reviews
 * 
 * @param sgr Struct sgr
 * @return Reviews 
 */
Reviews get_Reviews(SGR sgr);

/**
 * @brief Define o objeto Reviews na struct sgr
 * 
 * @param sgr Struct sgr
 * @param rw_s Struct reviews
 */
void set_Reviews(SGR sgr, Reviews rw_s);

/**
 * @brief Obtém o objeto TopBusinesses
 * 
 * @param sgr Struct sgr
 * @return TopBusinesses 
 */
TopBusinesses get_TopBus(SGR sgr);

/**
 * @brief Define o TopBusinesses da struct sgr
 * 
 * @param sgr Struct sgr
 * @param tbs Struct TopBusinesses
 */
void set_TopBus(SGR sgr, TopBusinesses tbs);

/**
 * @brief Construtor da struct SGR
 * 
 * @return SGR 
 */
SGR initSGR();

/**
 * @brief Carrega o ficheiro reviews, adiciona o ID do business ao user correspondente (da struct users) 
 * e o ID da review ao business correspondente (da struct business)
 * 
 * @param filename Nome do ficheiro
 * @param s Struct SGR
 * @return int Número de reviews válidas
 */
int loadREVIEWS(char *filename,SGR s);

/**
 * @brief QUERY 1 - Carrega os ficheiros necessários para a struct sgr
 * 
 * @param users Ficheiro dos users
 * @param businesses Ficheiro dos businesses
 * @param reviews Ficheiro das reviews
 * @return SGR 
 */
SGR loadSGR(char *users, char *businesses, char *reviews);

/**
 * @brief QUERY 2 - Devolve o número de business que começam com determinada letra
 * 
 * @param sgr Struct sgr
 * @param letter Letra inicial
 * @return TABLE Resultado
 */
TABLE businesses_started_by_letter(SGR sgr, char letter);

/**
 * @brief QUERY 3 - Obtém a informação do business (nome, cidade, estado, stars e número total de reviews)
 * 
 * @param sgr Struct sgr
 * @param business_id Business ID
 * @return TABLE Resultado
 */
TABLE business_info(SGR sgr, char *business_id);

/**
 * @brief QUERY 4 - Devolve os business que determinado user fez review sobre
 * 
 * @param sgr Struct sgr
 * @param user_id User ID
 * @return TABLE Resultado
 */
TABLE businesses_reviewed(SGR sgr, char *user_id);

/**
 * @brief QUERY 5 - Negócios de determinada cidade cuja avaliação (stars) esteja acima da pedida
 * 
 * @param sgr Struct sgr
 * @param stars Número de estrelas dadas inicialmente
 * @param city Cidade
 * @return TABLE Tabela com os determinados negócios
 */
TABLE businesses_with_stars_and_city(SGR sgr, float stars, char *city);

/**
 * @brief QUERY 6 - Devolve os melhores business por cidade, em termos de classificação de estrelas.
 * 
 * @param sgr Struct sgr
 * @param top Número de business por cidade
 * @return TABLE Resultado
 */
TABLE top_businesses_by_city(SGR sgr, int top);

/**
 * @brief QUERY 7 - Devolve todos os User que visitaram mais que um estado
 * 
 * @param sgr Struct sgr
 * @return TABLE Resultado
 */
TABLE international_users(SGR sgr);

/**
 * @brief QUERY 8 - Devolve o top n business por categoria
 * 
 * @param sgr Struct sgr
 * @param top Número de business por categoria
 * @param category Categoria do Business
 * @return TABLE Resultado
 */
TABLE top_businesses_with_category(SGR sgr, int top, char *category);

/**
 * @brief Devolve todas as reviews cujo texto contenha uma determinada palavra
 * 
 * @param sgr Struct sgr
 * @param word Palavra
 * @return TABLE Resultado
 */
TABLE reviews_with_word(SGR sgr, char *word);

/**
 * @brief Liberta memória da struct sgr
 * 
 * @param sgr Struct sgr
 */
void freeSGR(SGR sgr);

#endif