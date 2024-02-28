#include "../includes/Reviews.h"

struct reviews{
    GHashTable *hash;
};


GHashTable *getHASH(Reviews revs){ return revs->hash; }


GList *getALL_reviews(Reviews revs){ return g_hash_table_get_values(revs->hash); }


Reviews initREVIEWS(){
    Reviews rev = malloc(sizeof(struct reviews));
    rev->hash = g_hash_table_new_full(g_str_hash, g_str_equal, free, (GDestroyNotify)freeREVIEW);
    return rev;
}


void freeREVIEWS(Reviews revs){
    if (revs) g_hash_table_destroy(revs->hash);
    free(revs);
}