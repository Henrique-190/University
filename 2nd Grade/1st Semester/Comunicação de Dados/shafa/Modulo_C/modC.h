#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

typedef struct cod
{
    char c;
    char *codigo; 
}COD;

typedef COD CODs[256];

void imprimeOutput(int ,int [], int [], clock_t, char *);

int *find_t_antes(int , unsigned char *);

unsigned char *getbufferC(FILE *);

char *getfichSHAF(char *);

char *getfichCOD(char *);

unsigned char *getbufferO(FILE *, int );

char *getfichOrigin(char *, unsigned char );

CODs *getCod(unsigned char *buffer,int n_blocos, int *max_size);

void pre_binaryBuffer(CODs , char* ,int , int , int *, unsigned char *);
 
unsigned char byteTobit(unsigned char *);

void initFout(FILE *,int );

int Print_binaryBuffer(FILE *, unsigned char *, int , int);

void cleanFile(char *);

void moduloC(char *);
