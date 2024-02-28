#include "../includes/Users.h"

#define BUF_SIZE 1024

struct users{
    GHashTable* userHashT;
};


GHashTable* getUserHashTable(Users users_s){
    return users_s->userHashT;
}


Users initUsers(){
    Users users_s = malloc(sizeof(struct users));
    users_s->userHashT = g_hash_table_new_full(g_str_hash,g_str_equal,free,(GDestroyNotify)freeUser);
    return users_s;
}


int loadUsersFromFile (char* filename,Users users_s,int read){
    char* buffer = NULL;
    FILE *fp = fopen(filename,"r");
    int res = 0;

    if (fp != NULL){
    size_t len = 0;

    int valid = getline(&buffer,&len,fp);
    while((valid = getline(&buffer,&len,fp)) > 0){
        User u = initUserFromLine(strtok(buffer,"\n"),";",read);
        if(u!=NULL) {
            g_hash_table_insert(users_s->userHashT, getUserId(u), u); 
            res++;
        }
    }
    
    free(buffer);
    fclose(fp);
    }
    else printf("Erro na leitura do ficheiro %s",filename);
    
    
    return res;
}


void addB_toUser(char *business_id,char *user_id,Users us){
    User u = (User) g_hash_table_lookup(us->userHashT,user_id);
    setBusinessReviewed(u,g_slist_prepend(getBusinessReviewed(u),business_id));
    free(user_id);
}


int existsUser(Users users_s, char* userId) {
    return (int) g_hash_table_contains(users_s->userHashT, userId);
}


void freeUsers(Users users_s){
    if(users_s) g_hash_table_destroy(users_s->userHashT);
    free(users_s);
}