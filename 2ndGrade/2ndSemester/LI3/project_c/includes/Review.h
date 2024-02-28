/**
 * @file Review.h
 * @brief API do módulo Review
 * 
 * @author Bohdan Malanka (a93300)
 * @author Henrique José Fernandes Alvelos (a93316)
 * @author Diogo da Silva Rebelo (a93278)
 */
#ifndef REVIEW_H
#define REVIEW_H 

#include "AuxStructs.h"

/**
 * @brief Pointer para struct review
 * 
 */
typedef struct review *Review;

/**
 * @brief Devolve o ID da Review
 * 
 * @param rev Review
 * @return gchar* String do ID da Review
 */
gchar *getID_review (Review rev);

/**
 * @brief Devolve o ID do User
 * 
 * @param rev Review
 * @return gchar* String do ID do User
 */
gchar *getID_user (Review rev);

/**
 * @brief Devolve o ID do business
 * 
 * @param rev Review
 * @return gchar* String do ID do business
 */
gchar *getID_business(Review rev);

/**
 * @brief Devolve o número de estrelas dadas pelo User a determinado Business
 * 
 * @param rev Review
 * @return gfloat Inteiro stars
 */
gfloat getSTARS(Review rev);

/**
 * @brief Devolve o valor de Useful dado por um User a determinado Business
 * 
 * @param rev Review
 * @return gint 
 */
gint getUSEFUL(Review rev);

/**
 * @brief Devolve o valor de Funny dado por um User a determinado Business
 * 
 * @param rev Review
 * @return gint 
 */
gint getFUNNY(Review rev);

/**
 * @brief Devolve o valor de Cool dado por um User a determinado Business
 * 
 * @param rev Review
 * @return gint 
 */
gint getCOOL(Review rev);

/**
 * @brief Devolve a data da Review
 * 
 * @param rev Review
 * @return gchar* String da data
 */
gchar *getDATE(Review rev);

/**
 * @brief Devolve o texto da Review
 * 
 * @param rev Review
 * @return gchar* String do texto
 */
gchar *getTEXT(Review rev);

/**
 * @brief Construtor de uma review a partir de uma linha com todos os parâmetros separados por um delimitador
 * 
 * @param line Linha oriunda de um ficheiro
 * @param fieldSeparator Delimitador
 * @return Review 
 */
Review initREVIEW_line(char *line,char *fieldSeparator);

/**
 * @brief Libera memória de uma Review
 * 
 * @param rev Review
 */
void freeREVIEW(Review rev);

#endif