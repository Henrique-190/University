/**
 * @file Users.h
 * @brief Estrutura de dados que contém todas as funções que manipulam a HashTable de users (cada key é um user id e o valor é a struct User,
 * ou seja, a estrutura que contém toda a informação de cada user
 * @author Bohdan Malanka (a93300)
 * @author Henrique José Fernandes Alvelos (a93316)
 * @author Diogo da Silva Rebelo (a93278)
 */
#ifndef USERS_H
#define USERS_H

#include "User.h"

/**
 * @brief Pointer para a struct users contém um apontador para a GHashTable de users
 *
 */
typedef struct users *Users;

/**
 * @brief Função que obtém a HashTable de Users
 * @return GHashTable* de Users
 */
GHashTable* getUserHashTable(Users);

/**
 * @brief Função que inicia a struct com a HashTable dos users
 * @return Struct inicializada
 */
Users initUsers();

/**
 * @brief Função que carrega os Users do respetivo ficheiro
 * @param filename nome do ficheiro
 * @param users_s struct com HashTable de Users
 * @param read 1 se for para ler, 0 se não for
 * @return número de users a inserir
 */
int loadUsersFromFile (char* filename,Users users_s,int read);

/**
 * @brief Função que adiciona a cada user os negócios aos quais fez uma review
 * @param business_id identificador do negócio
 * @param user_id identificador do user
 * @param us struct com HashTable de Users
 */
void addB_toUser(char *business_id,char *user_id,Users us);

/**
 * @brief Função que verifica se um user existe na HashTable
 * @param users_s HashTable
 * @param userId Identificador
 * @return 1 caso exista, 0 caso contrário
 */
int existsUser(Users users_s, char* userId);

/**
 * @brief Liberta memória da struct Users
 * 
 * @param users_s struct que contém hash de Users a libertar
 */
void freeUsers(Users users);

#endif
