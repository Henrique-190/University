#include "../includes/Table.h"

#define ID_SIZE 22
#define NAME_SIZE 57
#define CITY_SIZE 35
#define STARS_SIZE 5
#define STATE_SIZE 5
#define TOTAL_REVIEWS_SIZE 13

struct table {
    GPtrArray* header;
    GPtrArray* content;
};

GPtrArray *getContent(TABLE t) { return (t->content); }
void setContent(TABLE t, GPtrArray *cont) { t->content = cont; }

GPtrArray *getHeader(TABLE t) { return (t->header); }
void setHeader(TABLE t, GPtrArray *head) { t->header = head; }

void addHeader(TABLE table,int count,...){
    char * value;
    int i;
    va_list argPtr;
    va_start(argPtr,count);
    for (i = 0; i < count; i++){
        value = va_arg(argPtr,char*);
        g_ptr_array_add(table->header,value);
    }
    va_end(argPtr);
}

TABLE initTable(){
    TABLE newTable = malloc(sizeof(struct table));
    newTable->header = g_ptr_array_new();
    newTable->content = g_ptr_array_new();
    return newTable;
}


void freeTable(TABLE t){
    g_ptr_array_free(t->header, TRUE);
    g_ptr_array_free(t->content, TRUE);
    free(t);
}


void addContent(GPtrArray* contentQ, TABLE table){
    unsigned int i;
    for (i = 0; i < contentQ->len ; i++){
        g_ptr_array_add(table->content,g_ptr_array_index(contentQ,i));
    }
}

TABLE getElemFromTable(TABLE table, int row, int column) {
    TABLE result = initTable();

    if(row >=0 && row<(int)table->content->len && column >= 0 && column<(int)table->header->len){
        g_ptr_array_add(result->header, (char*)g_ptr_array_index(table->header, column));
        char* elem = getStrElement((StrArray) g_ptr_array_index(table->content, row), column);
        StrArray line = initStrArray();
        addToStrArray(line, elem);
        g_ptr_array_add(result->content, line);
    }else return NULL;
    return result;
}

void toCSV(TABLE x, char delim, char* filepath){
    FILE *fp;
    fp = fopen(filepath,"w");
    unsigned int i, j, k;

    if (fp == NULL) perror("Can't open file!");

    for (i = 0; i < x->header->len; i++){
      char * elem = (char*) strdup(g_ptr_array_index(x->header,i));
        fwrite(elem,1, strlen(elem),fp);
        if (i != x->header->len - 1) fwrite(&delim,1,1,fp);
    }

    fwrite("\n",1,1,fp);

    for (j = 0; j < x->content->len; j++) {
        StrArray lines = (StrArray ) g_ptr_array_index(x->content, j);
        for (k = 0; k < lines->len; k++) {
            char* elem2 = getStrElement(lines,(int)k);
            fwrite(elem2,1, strlen(elem2), fp);
            if (k != lines->len -1) fwrite(&delim,1,1,fp);
        }
        fwrite("\n", 1, 1, fp);
    }
    fclose(fp);
}
int getNumberOfFiels (char* line, char delim) {
    int i, n_fields;
    int count = 0;
    for (i = 0; line[i]; i++)
        if (line[i] == delim) count++;
    n_fields = count + 1;

    return n_fields;
}

TABLE fromCSV(char * filepath, char delim){
    int i,j;
    TABLE x = initTable();
    FILE* fp; 
    fp = fopen(filepath,"r");
    size_t len = 0;
    char* buffer = NULL;

    if (fp == NULL) perror("Can't open file!");

    len = getline(&buffer,&len,fp);
    int n_fields = getNumberOfFiels(buffer,delim);
    buffer = strtok(buffer,"\n");
    for (i = 0; i < n_fields; i++){
        char* elem = strdup(strsep(&buffer,&delim));
        g_ptr_array_add(x->header,elem);
    }

    while(getline(&buffer,&len,fp) > 0) {
        buffer = strtok(buffer,"\n");
        n_fields = getNumberOfFiels(buffer,delim);
        StrArray line = initStrArray();
        for (j = 0; j < n_fields; j++) {
            char * separatedElem = strdup(strsep(&buffer,&delim));
            addToStrArray(line,separatedElem);
        }
        g_ptr_array_add(x->content,line);
    }
    fclose(fp);
    return x;
}

TABLE filter(TABLE x, char* column_name, char* value, OPERATOR oper) {
    if(oper==NONE) return x;
    TABLE newTable = initTable();
    unsigned int i;
    int exist_colum = -1;

    for(i=0; i<x->header->len; i++){
        if (!strcmp(column_name, g_ptr_array_index(x->header, i))) exist_colum=i;
    }
    if(exist_colum==-1) return x;

    setHeader(newTable, getHeader(x));
    GPtrArray* newContent = g_ptr_array_new();
    for (i = 0; i < x->content->len; i++) {
        StrArray line = g_array_copy((StrArray)g_ptr_array_index(x->content, i));
        int flag = strcmp(getStrElement(line, exist_colum), value);
        if ((flag==0 && oper == EQ) || (flag < 0 && oper == LT) || (flag > 0 && oper == GT))
            g_ptr_array_add(newContent, line);

    }
    setContent(newTable, newContent);
    return newTable;
}

static int gPtrArraytoInt(GPtrArray* cols, int colums[], TABLE x){
    int k=0;
    unsigned int i, j;
    for(i=0; i< cols->len; i++){
        for(j=0; j<x->header->len; j++){
            if(strcmp((char*)g_ptr_array_index(cols, i), (char*)g_ptr_array_index(x->header, j))==0)
                colums[k++]=j;
        }
    }
    return k;
}

TABLE proj(TABLE x, GPtrArray* cols) {
    TABLE newTable = initTable();
    unsigned int i;
    int j;

    int colums[getHeader(x)->len];
    int len = gPtrArraytoInt(cols, colums, x);


    for (i = 0; i < cols->len; i++) {
        char * elemOfHeader = (char*) g_ptr_array_index(cols, i);
        g_ptr_array_add(newTable->header,(gpointer) elemOfHeader);
    }


    for(i=0; i< x->content->len; i++){
        StrArray elem = initStrArray();
        for(j=0; j<len; j++){
            char* aux = getStrElement((StrArray)g_ptr_array_index(x->content, i),colums[j]);
            if(strlen(aux)>0) addToStrArray(elem, aux);
        }
        if (getLength(elem)>0)
        g_ptr_array_add(newTable->content, elem);
    }

    return newTable;
}


void printCelula(char* conteudo, int size){
    int len = strlen(conteudo);
    int i=0, j=0;

    while (i<(size/2-len/2)){
        putchar(' ');
        i++;
        j++;
    }
    printf("%s", conteudo);
    i +=len;
    while(i<size){
        putchar(' ');
        i++;
    }
}

void printSeparadorTable(GPtrArray* header, int switcher){
    unsigned int i, j;
    char c = '-';
    if(switcher) c = '=';

    char* coluna;
    for(i=0; i<header->len; i++){
        putchar('+');
        coluna = (char*)g_ptr_array_index(header, i);
        j=0;
        if(strcmp(coluna, "Business_ID")==0 || strcmp(coluna, "User_ID")==0 || strcmp(coluna, "Review_ID")==0)
            while(j<ID_SIZE) {putchar(c); j++;}
        else if(strcmp(coluna, "Name")==0) while(j<NAME_SIZE) {putchar(c); j++;}
        else if(strcmp(coluna, "City")==0) while(j<CITY_SIZE) {putchar(c); j++;}
        else if(strcmp(coluna, "State")==0) while(j<STATE_SIZE) {putchar(c); j++;}
        else if(strcmp(coluna, "Stars")==0) while(j<STARS_SIZE) {putchar(c); j++;}
        else while(j<TOTAL_REVIEWS_SIZE) {putchar(c); j++;}
    }    
    printf("+\n");
}

void printTable(TABLE t){
    unsigned int len_header = t->header->len;
    unsigned int len_content = t->content->len;
    unsigned int i, j;


    for(i=0; i<len_header; i++){
        putchar('-');
        j=0;
        switch (i){
        case 0:
            while(j<ID_SIZE) {putchar('-'); j++;}
            break;
        case 1:
            while(j<NAME_SIZE) {putchar('-'); j++;}
            break;    
        
        default:
            while(j<STARS_SIZE) {putchar('-'); j++;}
            break;
        }  
    }
    printf("-\n");

    for(i=0; i<len_header; i++){
        putchar('|');
        switch (i){
        case 0:
            printCelula((char*)g_ptr_array_index(t->header, i), ID_SIZE);
            break;
        case 1:
            printCelula((char*)g_ptr_array_index(t->header, i), NAME_SIZE);    
            break;
        default:
            printCelula((char*)g_ptr_array_index(t->header, i), STARS_SIZE);
            break;
        }
    }
    printf("|\n");

    int switcher = 0;
    for(i=0; i<len_content; i++){
        StrArray line = g_ptr_array_index(t->content, i);
        printSeparadorTable(t->header, switcher);
        
        for(j=0; j<line->len; j++){
            if(strcmp("SWITCHER",getStrElement(line,j))!=0){
                putchar('|');
                switch (j){
                    case 0:
                        printCelula((char*)getStrElement(line,j), ID_SIZE);
                        break;
                    case 1:
                        printCelula((char*)getStrElement(line,j), NAME_SIZE);
                        break;
                    default:
                        printCelula((char*)getStrElement(line,j), STARS_SIZE);
                        break;
                    }  
                switcher = 0;
            }    
            else    switcher = 1;     
        }
        printf("|\n");
    }

    for(i=0; i<len_header; i++){
        putchar('-');
        j=0;
        switch (i){
        case 0:
            while(j<ID_SIZE) {putchar('-'); j++;}
            break;
        case 1:
            while(j<NAME_SIZE) {putchar('-'); j++;}
            break;    
        
        default:
            while(j<STARS_SIZE) {putchar('-'); j++;}
            break;
        }
    }
    printf("-\n");
}

void printHeader(TABLE t){
    unsigned int i;


    printSeparadorTable(t->header, 0);

    char* coluna;
    for(i=0; i<t->header->len; i++){
        putchar('|');
        coluna = (char*)g_ptr_array_index(t->header, i);
        if(strcmp(coluna, "Business_ID")==0 || strcmp(coluna, "User_ID")==0 || strcmp(coluna, "Review_ID")==0)
            printCelula(coluna, ID_SIZE);
        else if(strcmp(coluna, "Name")==0) printCelula(coluna, NAME_SIZE);
        else if(strcmp(coluna, "City")==0) printCelula(coluna, CITY_SIZE);
        else if(strcmp(coluna, "State")==0) printCelula(coluna, STATE_SIZE);
        else if(strcmp(coluna, "Stars")==0) printCelula(coluna, STARS_SIZE);
        else printCelula(coluna, TOTAL_REVIEWS_SIZE);
    }
    printf("|\n");
}

void printContent(TABLE t, int start, int end){
    int i, switcher = 0;

    unsigned int j;
    for(i=start; i<=end; i++){
        StrArray line = g_ptr_array_index(t->content, i);
        printSeparadorTable(t->header, switcher);
        char* coluna;
        for(j=0; j<line->len; j++){
            if(strcmp("SWITCHER",getStrElement(line,j))!=0){
                putchar('|');
                coluna = (char*)g_ptr_array_index(t->header, j);
                if(strcmp(coluna, "Business_ID")==0 || strcmp(coluna, "User_ID")==0 || strcmp(coluna, "Review_ID")==0)
                    printCelula((char*)getStrElement(line,j), ID_SIZE);
                else if(strcmp(coluna, "Name")==0) printCelula((char*)getStrElement(line,j), NAME_SIZE);
                else if(strcmp(coluna, "City")==0) printCelula((char*)getStrElement(line,j), CITY_SIZE);
                else if(strcmp(coluna, "State")==0) printCelula((char*)getStrElement(line,j), STATE_SIZE);
                else if(strcmp(coluna, "Stars")==0) printCelula((char*)getStrElement(line,j), STARS_SIZE);
                else printCelula((char*)getStrElement(line,j), TOTAL_REVIEWS_SIZE);
                switcher = 0;
            }    
            else    switcher = 1;     
        }
        printf("|\n");
    }

    StrArray line = g_ptr_array_index(t->content, end);
        (strcmp("SWITCHER", getStrElement(line, line->len-1))==0) ? printSeparadorTable(t->header, 1) : 
        printSeparadorTable(t->header, 0);

}