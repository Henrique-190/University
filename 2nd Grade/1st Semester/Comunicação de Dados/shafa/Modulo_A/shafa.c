#include "modA.h"

int main(int argn, char *argv[])
{
    if (!strcmp(argv[2], "-m") && !strcmp(argv[3], "f"))
    {
        char bs = arg_tam(argn, argv);

        if (!strcmp(argv[4], "-c") && !strcmp(argv[5], "r"))
            main_modA(argv[1], 1, bs); // módulo f com rle
        else
        {
            main_modA(argv[1], 0, bs); // módulo f normal
        }
    }

    return 0;
}