
#define MAX_D 8000000

/*
Function fsize() to get the size of files and the number of blocks contained
in the file (for a given block size).

The function works for files already opened (and pointed by <fp_in>) and also
for files not already opened (in this case the file is identified by <filename>).

This function works on files of any size and on any operating system and on
any machine architecture. Bear in mind that for files larger than 2 GBytes the
function is very slow. Block size of FSIZE_DEFAULT_BLOCK_SIZE should yield
the best results in terms of execution time but it may be dependent of the
operating system and/or machine architecture/hardware.

The function returns directly the number of blocks contained in the file of
a given block size in <*the_block_size>. It also returns, indirectly, the
actual block size used in <*the_block_size>, which may be different than
the original size in <*the_block_size>. If the original value of <*the_block_size>
is smaller than FSIZE_MIN_BLOCK_SIZE then FSIZE_MIN_BLOCK_SIZE is used.
Also, if the original value of <*the_block_size> is bigger than FSIZE_MAX_BLOCK_SIZE
then FSIZE_MAX_BLOCK_SIZE is used. If the original value of <*the_block_size> is
equal to 0 (zero) then FSIZE_DEFAULT_BLOCK_SIZE is used. Bear in mind that the last
block may have a smaller size and its value is returned in <*size_of_last_block>.

If n_blocks is the returned number of blocks then:
   total_file_size = n_blocks * <*the_block_size> + <*size_of_last_block>

Arguments:
  FILE *fp_in - a file pointer (if NULL, then the file is identified by <filename>)
  unsigned char *filename - if NULL then file must be identified by < *fp>
  unsigned long *the_block_size - this is used to pass the intended size for each block
                                  and to receive the actual block size used
  long *size_of_last_block - this is used to receive the size of the last block

This code is open source and free to use as long as the original author is identified.

(c) 2020, Bruno A.F. Dias - University of Minho, Informatics Department
*/
long long fsize(FILE *fp_in, unsigned char *filename, unsigned long *the_block_size, long *size_of_last_block);
int numero_de_blocos(char *fileSHAF);
void output(char *fileSHAF, double tempo, char *nome, int tipo);
char *shaf_COD(char *file_SHAF, char *file_COD, int rle);
char *rle_SHAF_cod(char *fileRLE_SHAF, char *fileRLE_COD, char *mode);