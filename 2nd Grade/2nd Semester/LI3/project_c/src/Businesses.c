#include "../includes/Businesses.h"


struct businesses{
    GHashTable* hashT;
};


GHashTable* getHashTable_B(Businesses bs){ return bs->hashT; }


Businesses initBusinesses(){
    Businesses bs_s = malloc(sizeof(struct businesses));
    bs_s->hashT = g_hash_table_new_full(g_str_hash, g_str_equal, free, (GDestroyNotify)destroyBusiness);
    return bs_s;
}


void addR_toBus(gfloat star,char *business_id,Businesses bs){
    Business b = (Business) g_hash_table_lookup(bs->hashT,business_id);
    setBusinessStars(b,(getBusinessStars(b)+star));
    setBusinessReviews(b,getBusinessReviews(b)+1);
    free(business_id);
}

int loadBusinessesFromFile(char* filename, Businesses bs){
    char* buffer = NULL;
    FILE* f = fopen(filename, "r");
    int res = 0;

    if(f!=NULL){
        size_t len = 0;

        int valid = getline(&buffer,&len,f);
        while((valid = getline(&buffer,&len,f)) > 0){
            Business b = initBusinessFromLine(strtok(buffer, "\n"), ";");
            if(b){
                g_hash_table_insert(bs->hashT, getBusinessID(b), b);
                res++;
            }
        }
        free(buffer);
        fclose(f);
    }
    else printf("Error, opening file");
    return res;
}

GPtrArray* getBusinessesByLetter(const Businesses bs, char letter){
    GPtrArray* res = g_ptr_array_new();
    guint glength = 0;
    gpointer* gkeysArr = g_hash_table_get_keys_as_array(bs->hashT, &glength);

    char** keysArr = (char**)gkeysArr;
    int length = (int)glength;
    int i;
    gpointer value;
    char* name = NULL;
    for(i=0; i < length; i++){
        value = g_hash_table_lookup(bs->hashT, keysArr[i]);
        name = getBusinessName((Business)value);
        StrArray element = initStrArray();
        if (name[0] == toupper(letter) ||
            name[0] == tolower(letter)){
            addToStrArray(element, keysArr[i]);
            addToStrArray(element, name);
            g_ptr_array_add(res, element);
        }
    }
    free(name);
    g_free(gkeysArr);
    return res;
}


GPtrArray* getBusinessesByStarsAndCity(Businesses bs, char* city, float stars){
    GPtrArray* res = g_ptr_array_new();
    guint glength = 0;
    gpointer* gkeysArr = g_hash_table_get_keys_as_array(bs->hashT, &glength);

    char** keysArr = (char**)gkeysArr;
    int length = (int)glength;
    int i;
    gpointer value;
    char* town = NULL;
    float estrelas = -1;

    for(i=0; i < length; i++){
        StrArray element = initStrArray();
        value = g_hash_table_lookup(bs->hashT, keysArr[i]);
        
        town = getBusinessCity((Business)value);

        estrelas = getBusinessAverageStars((Business)value);
        
        if (strcasecmp(town, city)==0 && stars <= estrelas){
            addToStrArray(element, keysArr[i]);
            addToStrArray(element, getBusinessName((Business)value));
            g_ptr_array_add(res, element);
        }
    }


    free(town);
    g_free(gkeysArr);
    return res;
} 


void printBusinesses(Businesses bs){
    GHashTableIter iter;
    gpointer key, value;
    int i=1;
    g_hash_table_iter_init (&iter, getHashTable_B(bs));
    while (g_hash_table_iter_next (&iter, &key, &value)){
        
       printf("%d: ", i++);
       printBusiness((Business)value);
    }
}


void freeBusinesses(Businesses bs_s){
    if (bs_s) g_hash_table_destroy(bs_s->hashT);
    free(bs_s);
}