#include "../includes/SGR.h"

struct sgr{
    Users us_s;
    Businesses bs_s;
    Reviews rw_s;
    TopBusinesses top_bs;
};


Users get_Users(SGR sgr){ return sgr->us_s; }
void set_Users(SGR sgr,Users us_s){ sgr->us_s = us_s; }

Businesses get_Businesses(SGR sgr){ return sgr->bs_s; }
void set_Businesses(SGR sgr,Businesses bs_s){ sgr->bs_s = bs_s; }

Reviews get_Reviews(SGR sgr) { return sgr->rw_s; }
void set_Reviews(SGR sgr, Reviews rw_s){ sgr->rw_s = rw_s; }

TopBusinesses get_TopBus(SGR sgr) { return sgr->top_bs; }
void set_TopBus(SGR sgr, TopBusinesses tbs) { sgr->top_bs = tbs; }


SGR initSGR(){
    SGR new = malloc(sizeof(struct sgr));
    new->bs_s = initBusinesses();
    new->rw_s = initREVIEWS();
    new->us_s = initUsers();
    new->top_bs = initTopBusinesses();
    return new;
}


void loadTopBusinesses(SGR sgr, int which){
    GHashTableIter iter;
    gpointer key, value;
    g_hash_table_iter_init (&iter, getHashTable_B(get_Businesses(sgr)));
    while (g_hash_table_iter_next (&iter, &key, &value))
        if (which) addBUS_byCITY((Business)value,sgr->top_bs);
        else addBUS_byCTG ((Business)value,sgr->top_bs);
}


int loadREVIEWS(char *filename,SGR s){
    FILE* fp = fopen(filename, "r");
    int res = 0;

    if(fp!=NULL) {
        char *buffer = NULL;
        size_t len = 0;

        int valid = getline(&buffer,&len,fp);
        while((valid = getline(&buffer,&len,fp)) > 0){
            Review nova = initREVIEW_line(strtok(buffer,"\n"),";");
            if(nova!=NULL) {
                gboolean business = g_hash_table_contains(getHashTable_B(s->bs_s),getID_business(nova));
                gboolean user = g_hash_table_contains(getUserHashTable(s->us_s),getID_user(nova));
                if (business && user){
                    g_hash_table_insert(getHASH(get_Reviews(s)),getID_review(nova),nova);
                    addB_toUser(getID_business(nova),getID_user(nova),s->us_s);
                    addR_toBus(getSTARS(nova),getID_business(nova),s->bs_s);
                    res++;
                } else freeREVIEW(nova);
                
            }
        }
        free(buffer);
        fclose(fp);
    }
    else printf("Erro na leitura do ficheiro %s",filename);
    return res;
}


SGR loadSGR(char *users, char *businesses, char *reviews){
    SGR new = initSGR();

    int readUSERS = 0, readBUSINESS = 0, readREVIEWS = 0;
    int read = 2, elem = 0;


    while(elem >= 0 && read != 0 && read != 1){
        printf("\nRead friends?\n 0 - No   1 - Yes: ");
        elem = scanf("%d", &read);
    }

    readUSERS = loadUsersFromFile(users,new->us_s,read);
    if (readUSERS) printf("%s read, %d entries\n",users,readUSERS);

    if (readUSERS) readBUSINESS = loadBusinessesFromFile(businesses,new->bs_s);
    if (readBUSINESS) printf("%s read, %d entries\n",businesses,readBUSINESS);

    if (readUSERS && readBUSINESS) readREVIEWS = loadREVIEWS(reviews,new);
    if (readREVIEWS) printf("%s read, %d entries\n",reviews,readREVIEWS);

    if (readUSERS && readBUSINESS && readREVIEWS) return new; 
    
    freeSGR(new);
    return NULL;
}


TABLE businesses_started_by_letter(SGR sgr, char letter){
    GPtrArray* ids_and_names_by_letter = getBusinessesByLetter(sgr->bs_s, letter);

    StrArray total_b = initStrArray();
    char * aux = malloc(10);
    addToStrArray(total_b, "Total Businesses");
    sprintf(aux, "%d", ids_and_names_by_letter->len);
    addToStrArray(total_b, aux);
    g_ptr_array_add(ids_and_names_by_letter, total_b);

    TABLE t = initTable();
    addTOGPtrArray(getHeader(t), 2, "Business_ID", "Name");
    addContent(ids_and_names_by_letter, t);
    free(aux);
    return t;
}


TABLE business_info(SGR sgr, char *business_id){
    TABLE new = initTable();
    Business bs = (Business) g_hash_table_lookup(getHashTable_B(sgr->bs_s),business_id);
    if(bs!=NULL){
        addHeader(new, 5, "Name", "City", "State", "Stars", "Total Reviews");

        StrArray line = initStrArray();
        addToStrArray(line, getBusinessName(bs));
        addToStrArray(line, getBusinessCity(bs));
        addToStrArray(line, getBusinessState(bs));

        char stars[10], reviews[10];
        sprintf(stars,"%.2f",getBusinessAverageStars(bs));
        addToStrArray(line, stars);
        sprintf(reviews,"%d",getBusinessReviews(bs));
        addToStrArray(line, reviews);
        GPtrArray *content = g_ptr_array_new();
        g_ptr_array_add(content, line);
        addContent(content, new);
    }
    return new;
}


TABLE businesses_reviewed(SGR sgr, char *user_id){
    TABLE businessT = initTable();
    GPtrArray* bsReviewed = g_ptr_array_new();
    User user = (User) g_hash_table_lookup(getUserHashTable(sgr->us_s),user_id);
    addHeader(businessT,2,"Business_ID","Name");

    if (user) {
        GSList *b_list = getBusinessReviewed(user);
        while (b_list) {
            StrArray b = initStrArray();
            addToStrArray(b,(char*)(b_list->data));
            Business bs =(Business)g_hash_table_lookup(getHashTable_B(sgr->bs_s),(char*)b_list->data);
            if(bs==NULL)
                b_list = b_list->next;
            else {
                addToStrArray(b, getBusinessName(bs));
                g_ptr_array_add(bsReviewed, b);
                b_list = b_list->next;
            }
        }
    }
    addContent(bsReviewed,businessT);
    return businessT;
}


TABLE businesses_with_stars_and_city(SGR sgr, float stars, char *city){
    GPtrArray* bs_ids_name=getBusinessesByStarsAndCity(sgr->bs_s, city, stars);
    
    TABLE t = initTable();
    addHeader(t, 2, "Business_ID", "Name");
    addContent(bs_ids_name, t);
    return t;
}


TABLE top_businesses_by_city(SGR sgr, int top){
    if (g_hash_table_size(getHashTable_Top(sgr->top_bs,1))==0){
        loadTopBusinesses(sgr,1);
    }
    GPtrArray* bs_by_city = getTopBusinessesByCity(sgr->top_bs, top);

    TABLE t = initTable();
    addHeader(t, 3, "Business_ID", "Name", "Stars");
    addContent(bs_by_city, t);
    return t;
}


TABLE international_users(SGR sgr){
    TABLE userT = initTable();
    GPtrArray* interUsers = g_ptr_array_new();
    addHeader(userT,1,"User_ID");

    GHashTable* userH = getUserHashTable(sgr->us_s);
    GList* userL = g_hash_table_get_values(userH);

    while(userL) {
        User user = (User) userL->data;
        GSList *b_list = getBusinessReviewed(user);
        GString *string = g_string_new("");
        int international = 0;
        StrArray inter = initStrArray();

        while (b_list && !international) {

            Business b = (Business) g_hash_table_lookup(getHashTable_B(sgr->bs_s),(char*)b_list->data);
            GString *state = g_string_new(getBusinessState(b));
            if (string->len == 0) string = g_string_new(state->str);
            else if (g_strcmp0(state->str, string->str) != 0) {
                addToStrArray(inter,getUserId(user));
                g_ptr_array_add(interUsers,inter);
                international = 1;
            }
            b_list = b_list->next;
        }
        g_string_free(string, TRUE);
        userL = userL->next;
    }

    StrArray totalUsers = initStrArray();
    int len = (int) interUsers->len;
    char* str = malloc(sizeof(char)*12);
    sprintf(str, "%d", len);
    addToStrArray(totalUsers,str);
    g_ptr_array_add(interUsers,totalUsers);
    addContent(interUsers,userT);

    return userT; 
}


TABLE top_businesses_with_category(SGR sgr, int top, char *category){
    if(g_hash_table_size(getHashTable_Top(sgr->top_bs,0))==0) loadTopBusinesses(sgr,0);
    
    GPtrArray* bs_by_ctg = getTopBusinessesByCategory(sgr->top_bs,top,category);

    TABLE t = initTable();
    GPtrArray *head = g_ptr_array_new();
    addTOGPtrArray(head, 3, "Business_ID", "Name", "Stars");
    setHeader(t,head);
    setContent(t,bs_by_ctg);

    return t;
}


TABLE reviews_with_word(SGR sgr, char *word){
    TABLE t = initTable();
    GPtrArray *header = g_ptr_array_new();
    addTOGPtrArray(header,1,"Review_ID");
    setHeader(t,header);

    GPtrArray *content = g_ptr_array_new_with_free_func((GDestroyNotify) destroyStrArray);

    GHashTableIter iter;
    gpointer key, value;
    g_hash_table_iter_init (&iter, getHASH(sgr->rw_s));
    while (g_hash_table_iter_next (&iter, &key, &value)){
        if (compareword(word,getTEXT((Review)value))){
            StrArray cont = initStrArray();
            addToStrArray(cont,getID_review((Review)value));
            addTOGPtrArray(content,1,cont);
        }
    }

    setContent(t,content);

    return t;
}


void freeSGR(SGR sgr){
    if (sgr){
        printf("Free Users...\n");
        freeUsers(sgr->us_s);
        printf("Free Businesses...\n");
        freeBusinesses(sgr->bs_s);
        printf("Free Reviews...\n");
        freeREVIEWS(sgr->rw_s);
        printf("Free Top Businesses...\n");
        freeTopBusinesses(sgr->top_bs);
        printf("DONE\n");
    }
    free(sgr);
}