#include "../includes/TopBusinesses.h"

struct top_businesses{
    GHashTable* ctg_topBS;
    GHashTable* city_topBS;
};

GHashTable* getHashTable_Top(TopBusinesses cs,int which){
    return which ? cs->city_topBS : cs->ctg_topBS;
}


TopBusinesses initTopBusinesses(){
    TopBusinesses cs = malloc(sizeof(struct top_businesses));
    cs->ctg_topBS = g_hash_table_new(g_str_hash, g_str_equal);
    cs->city_topBS = g_hash_table_new(g_str_hash, g_str_equal);
    return cs;
}


void freeTopBusinesses(TopBusinesses cs){
    if (cs){
        if(g_hash_table_size(cs->city_topBS)>0) g_hash_table_destroy(cs->city_topBS);
        if(g_hash_table_size(cs->ctg_topBS)>0) g_hash_table_destroy(cs->ctg_topBS);
    }
    free(cs);
}

void addBUS_byCTG(Business b,TopBusinesses tpb){
    char *categories = getBusinessCategories(b);
    char* category;
    while((category = strsep(&categories,","))){
        char *ctg = toLower(category);
        TopBusiness tb = (TopBusiness) g_hash_table_lookup(tpb->ctg_topBS,ctg);
        if (tb == NULL) {
            tb = initTopBusiness();
            setTopBName(tb,strdup(category));
            setBusinessList(tb,g_list_prepend(getBusinessList(tb),b));
            g_hash_table_insert(tpb->ctg_topBS,ctg,tb);
        }
        else setBusinessList(tb,g_list_prepend(getBusinessList(tb),b));
    }
}


void addBUS_byCITY(Business b,TopBusinesses tpb){
    TopBusiness tb = (TopBusiness) g_hash_table_lookup(tpb->city_topBS,toLower(getBusinessCity(b)));
    if (tb == NULL){
        tb = initTopBusiness();
        setTopBName(tb,getBusinessCity(b));
        setBusinessList(tb,g_list_prepend(getBusinessList(tb),b));
        g_hash_table_insert(tpb->city_topBS,getBusinessCity(b),tb);
    }
    else setBusinessList(tb,g_list_prepend(getBusinessList(tb),b));
}

static gint sortBusinesses(gconstpointer a, gconstpointer b){
    gint res;
    Business b1 = (Business) a;
    Business b2 = (Business) b;
    if(getBusinessAverageStars(b1)==getBusinessAverageStars(b2)) res = 0;
    else if(getBusinessAverageStars(b1)<getBusinessAverageStars(b2)) res = 1;
    else res = -1;
    return res;
}


GPtrArray* getTopBusinessesByCity(TopBusinesses top_b, int top){
    GPtrArray* res = g_ptr_array_new();
    int num, i;
    char stars[10];
    
    guint glength = 0;
    gpointer* gkeysArr = g_hash_table_get_keys_as_array(top_b->city_topBS, &glength);
    char** keysArr = (char**)gkeysArr;
    int length = (int)glength;
    
    char *id, *name;
    gpointer value;
    GList* businessList = NULL;
    for(i=0; i < length; i++){
        value = g_hash_table_lookup(top_b->city_topBS, keysArr[i]);
        if(value){
            businessList = g_list_sort(getBusinessList((TopBusiness)value), (GCompareFunc) sortBusinesses);
            num = top;
            StrArray element;
            while(num>0 && businessList){
                element = initStrArray();

                id = getBusinessID((Business)businessList->data);
                addToStrArray(element, id);

                name = getBusinessName((Business)businessList->data);
                addToStrArray(element, name);

                sprintf(stars, "%.2f", getBusinessAverageStars((Business)businessList->data));
                addToStrArray(element, stars);

                if(num==1 || businessList->next==NULL) {
                    addToStrArray(element, "SWITCHER");
                }  
                g_ptr_array_add(res, element);
                
                businessList = businessList->next;
                num--;    
            }
        }    
    }
    g_free(gkeysArr);
    return res;
}

GPtrArray* getTopBusinessesByCategory(TopBusinesses top_b, int top, char* category){
    GPtrArray* res = g_ptr_array_new();
    int num;
    char stars[10];
    char *ctg = toLower(strdup(category));
    TopBusiness b =  (TopBusiness)g_hash_table_lookup(top_b->ctg_topBS, ctg);
    if(b){
        GList* businessList = g_list_sort(getBusinessList(b), (GCompareFunc) sortBusinesses);
        num = top;
        while(num>0 && businessList){
            StrArray element = initStrArray();

            addToStrArray(element, getBusinessID((Business)businessList->data));
            addToStrArray(element, getBusinessName((Business)businessList->data));
            sprintf(stars, "%.2f", getBusinessAverageStars((Business)businessList->data));
            addToStrArray(element, stars);
            g_ptr_array_add(res, element);
            businessList = businessList->next;
            num--;    
        }
    }

    return res;
}

