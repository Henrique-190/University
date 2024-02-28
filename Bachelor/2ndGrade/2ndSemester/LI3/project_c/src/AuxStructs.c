#include"../includes/AuxStructs.h"

int getLength(StrArray st){ return st->len; }
char* getStrElement(StrArray st, int index){ return strdup(g_array_index( st, char*, index )); }

StrArray initStrArray(){ return g_array_new(FALSE,FALSE, sizeof(char*)); }
StrArray initStrArraySized(int N){ return g_array_sized_new(FALSE, FALSE, sizeof(char*), N);}


void addToStrArray(StrArray st,  char* value ){
	char* copy = strdup(value);
	g_array_append_val(st,copy);
}


void addValuesStrArray(StrArray st,int count,...){
	char * value;
    int i;
    va_list argPtr;
    va_start(argPtr,count);
    for (i = 0; i < count; i++){
        value = va_arg(argPtr,char*);
        addToStrArray(st,value);
    }
    va_end(argPtr);
}


void insertToStrArray(StrArray st, guint index, gpointer value){ g_array_insert_val(st, index, value); }


void addTOGPtrArray(GPtrArray *gptr,int count,...){
    char * value;
    int i;
    va_list argPtr;
    va_start(argPtr,count);
    for (i = 0; i < count; i++){
        value = va_arg(argPtr,char*);
        g_ptr_array_add(gptr,value);
    }
    va_end(argPtr);
}


StrArray addElementsToStrArray(StrArray st, char** data, int len){
	char** copy = data;
	int i;
	for(i=0; i<len; i++) copy[i] = strdup(data[i]);
	g_array_append_vals(st, copy, len);
	return st;
}


void addToArrayIndex(GPtrArray * array, int index, gpointer p){ return g_ptr_array_insert(array,index,p);}


void destroyStrArray(StrArray st){
	int i;
	for (i = 0; i < getLength(st); i++){
		free(getStrElement( st, i));
	}
	g_array_free (st,TRUE);
}


void remove_punct(char *p){
    int i = 0;
    for(;p[i];i++)
        if(ispunct(p[i]))
            p[i] = ' ';
}


char* toLower(char* s) {
    char *p;
    for(p=s; *p; p++) *p=tolower(*p);
    return s;
}


int compareword(char* word1, char* text){
    int found = 0;
    while(text && !found){
        remove_punct(text);
        char *word2 = strsep(&text," ");
        found = !strcasecmp(word1,word2);
    }
    return found;
}