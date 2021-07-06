#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "mod_b.h"

#define MAX 256

int main(int argn, char *argv[])
{
    if (!strcmp(argv[2], "-m"))
    {
        if (!strcmp(argv[3], "t"))
            mod_b(argv[1]);
    }
    else
        printf("\n\nInput incorreto\n\n");

    return 0;
}
