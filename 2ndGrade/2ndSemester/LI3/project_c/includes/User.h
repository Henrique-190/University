/**
 * @file User.h
 * @brief Estrutura de dados que contém todas as funções que manipulam a informação de cada user (id, name, friend id's & business id's revistos)
 * @author Bohdan Malanka (a93300)
 * @author Henrique José Fernandes Alvelos (a93316)
 * @author Diogo da Silva Rebelo (a93278)
 */
#ifndef USER_H
#define USER_H

#include "AuxStructs.h"

/**
 * @brief Pointer para a struct user que contém as informações de um User
 *
 */
typedef struct user *User;

/**
 * @brief Função que obtém um identificador de um user
 * @param u user
 * @return respetivo user id
 */
char* getUserId(User u);

/**
 * @brief Função que alterar o indentificador de um user para o pretendido
 * @param u user
 * @param id novo user id
 */
void setUserId (User u, char* id);

/**
 * @brief Função que obtém o nome de um user
 * @param u user
 * @return o respetivo nome
 */
char* getUserName(User u);

/**
 * @brief Função que substitui o nome de um user para o respetivo
 * @param u user
 * @param name novo nome
 */
void setUserName(User u, char* name);

/**
 * @brief Função que obtém o conjunto dos id's dos friends de um user
 * @param u user
 * @return string com os resptivos identificadores
 */
char* getUserFriends (User u);

/**
 * @brief Função que altera o array de id's de friends de um user
 * @param u user
 * @param friends array com os novos identificadores dos friends desse user
 */
void setUserFriends(User u, char* friends);

/**
 * @brief Função que obtém uma lista de strings com os business id's dos negócios que o respetivo user fez review
 * @param u user
 * @return Pointer para a respetiva GSList de business id's
 */
GSList *getBusinessReviewed(User u);

/**
 * @brief Função que altera a lista de business id's a que um user fez review
 * @param u user
 * @param business Lista de strings de business id's revistos por um user
 */
void setBusinessReviewed(User u, GSList *business);

/**
 * @brief Função que aloca a memória necessária para a criação de um novo user
 * @param id identificador do user
 * @param name nome do user
 * @param friends array com id's de friends de um user sem parcing
 * @param business lista de business id's revisto pelo user
 * @return novo user
 */
User createUser(char* id, char* name, char *friends,GSList *business);

/**
 * @brief Função que inicializa um user dada a respetiva linha do ficheiro. Faz o parsing desejdo de forma a alocar na
 * struct User a sua informação
 * @param fileLine linha o ficheiro
 * @param token delimitador
 * @param read 1 se for para ler, 0 caso contrário
 * @return novo user criado (struct do user)
 */
User initUserFromLine(char* fileLine, char* token,int read);

/**
 * @brief Função de clona um user
 * @param u user
 * @return clone
 */
User cloneUser(User u);

/**
 * @brief Função que valida um user dada a linha de um ficheiro e o respetivo delimitador
 * @param fileLine string com a linha lida do ficheiro
 * @param token delimitador
 * @return 1 se válido, 0 caso contrário
 */
int validUser(char* fileLine,char token);

/**
 * @brief Função que liberta a memória alocada por uma struct User
 * @param a user
 */
void freeUser(User a);

#endif 
