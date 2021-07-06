#include <stdio.h>
#include <ctype.h>

/*
    1. Tornar o buffer dinâmico;
    2. Tornar o word boundary mais inteligente.
*/

#define SIZE 200

int main()
{
    char buffer[SIZE];
    int index, c;

    /* initalize variables */
    c = 1;                          /* avoid random EOF */
    index = 0;
    buffer[index] = '\0';

    /* process standard input */
    while(c != EOF)
    {
        c = getchar();
        if( !isalpha(c) && c != '-' && index)            /* whitespace found */
        {
            buffer[index] = '\0';   /* cap the string */
            puts(buffer);
            index = 0;              /* reset index */
        }
        else if(isalpha(c) || c == '-')                       /* keep filling the buffer */
        {
            buffer[index] = c;
            index++;
        }
    }
    
    return(0);
}

11:54
#ifndef _DIC
#define _DIC

typedef struct entrada{
    char *palavra;
    int ocorr;
    struct entrada *prox;
} *Palavras;


#endif