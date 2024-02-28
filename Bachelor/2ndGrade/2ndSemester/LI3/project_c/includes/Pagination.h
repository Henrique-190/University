/**
 * @file Pagination.h
 * @brief Modulo responsável pela paginação de uma TABLE 
 * 
 * @author Bohdan Malanka (a93300)
 * @author Henrique José Fernandes Alvelos (a93316)
 * @author Diogo da Silva Rebelo (a93278)
 * 
 */
#ifndef _PAGINATION_H_
#define _PAGINATION_H_

#include "Table.h"


#define MAX_LINES 12
#define clear() printf("\033[H\033[J")
#define hide_cursor() printf("\x1B[?25l") 
#define show_cursor() printf("\x1B[?25h")

typedef struct window* Window;

/**
 * @brief Função que instancia uma Window
 * 
 * @return Window nova 
 */
Window initWindow();

/**
 * @brief Função que obtém a pagina atual do Window
 * 
 * @param w Window do qual se pretende obter a página atual 
 * @return int Número da página atual
 */
int getPage(Window w);

/**
 * @brief Função que atualiza o número da página atual
 * 
 * @param w Window ao qual se vai atualizar o campo page
 * @param page Número da página atual nova
 */
void setPage(Window w, int page);

/**
 * @brief Função que retorna a TABLE da Window
 * 
 * @param w Window a qual se pretende buscar a TABLE
 * @return TABLE que pertence ao Window
 */
TABLE getTableFromWindow(Window w);

/**
 * @brief Função que atualiza a TABLE do Window
 * 
 * @param w Window a qual se pretende atualizar a TABLE
 * @param t TABLE a ser inserida na Window
 */
void setTableToWindow(Window w, TABLE t);

/**
 * @brief Função que atualiza a última página do Window
 * 
 * @param w Window ao qual vai ser atualizada a última página
 * @param pg Número da última página
 */
void setLastPage(Window w, int pg);

/**
 * @brief Função que calcula o número da última página
 * 
 * @param w Window que contém a TABLE necessária para o calculo da última página
 * @return int Número da última página
 */
int calcLastPage(Window w);

/**
 * @brief Função que liberta memória ocupada pela Window
 * 
 * @param w Window destruída
 */
void destroyWindow(Window w);

/**
 * @brief Função que avança uma página
 * 
 * @param w Objeto de Window
 */
void nextPage(Window w);

/**
 * @brief Função que recua um página
 * 
 * @param w Objeto de Window
 */
void prevPage(Window w);

/**
 * @brief Função que recua para a primeira página
 * 
 * @param w Objeto de Window
 */
void firstPage(Window w);

/**
 * @brief Função que avança para a última página
 * 
 * @param w Objeto de Window
 */
void lastPage(Window w);

/**
 * @brief Função que imprime apenas a TABLE
 * 
 * @param w Objeto de Window
 */
void printPage(Window w);

/**
 * @brief Função que imprime o menu da Paginação
 * 
 * @param w Objeto de Window
 */
void printMenuBar(Window w);

/**
 * @brief Função que imprime uma Window, uma TABLE e o memu de Paginação
 * 
 * @param w Objeto de Window
 */
void printWindow(Window w);

/**
 * @brief Função que corre a Paginação
 * 
 * @param t TABLE a ser paginada 
 */
void runPagination(TABLE t);

/**
 * @brief Imprime o cabeçalho do programa
 * 
 */
void printCabecalho();

/**
 * @brief Imprime as opções dos comandos e Queries disponíveis
 * 
 */
void printMenuComandos();

/**
 * @brief Imprime um mini prompt para receber comandos do utilizador.
 * 
 * @param s String que contém o comando inserido, se for inválido imprime uma mensagem de erro
 */
void promptComands(char* s);

/**
 * @brief Função que junta a printCabecalho, printMenuComandos e promptComands, correspondendo á janela principal do programa
 * 
 * @param s Último comando inserido
 */
void mainDisplay(char* s);

#endif