#include "../includes/User.h"

struct user {
    char* id;
    char* name;
    char* friends;
    GSList *businessReviewed;
};


char* getUserId(User u){ return strdup(u->id); }
void setUserId (User u, char* id){ u->id = strdup(id); }

char* getUserName(User u){ return strdup(u->name); }
void setUserName(User u, char* name){ u->name = strdup(name); }

char* getUserFriends (User u) { return strdup(u->friends); }
void setUserFriends(User u, char* friends){ u->friends = strdup(friends); }

GSList *getBusinessReviewed(User u) { return u->businessReviewed;}
void setBusinessReviewed(User u, GSList *business){ u->businessReviewed = business; }

User createUser(char* id, char* name, char *friends,GSList *business){
    if(id != NULL && name != NULL){
        User newUser = malloc(sizeof(struct user));
        newUser->id = strdup(id);
        newUser->name = strdup(name);
        newUser->friends = strdup(friends);
        newUser->businessReviewed = business;
        return newUser;
    }
    return NULL;
}


User initUserFromLine(char* fileLine, char* token,int read){
    char* user_id = strsep(&fileLine, token);
    char* user_name = strsep(&fileLine, token);
    char* aux = "NONE";
    char* friends = read ? strdup(fileLine) : strdup(aux);
    return (createUser(user_id,user_name,friends,NULL));
}


User cloneUser(User u){
    char* newId = getUserId(u);
    char* newName = getUserName(u);
    char* newFriends = getUserFriends(u);
    GSList *newList = getBusinessReviewed(u);

    return (createUser(newId,newName,newFriends,newList));
}


int validUser(char* fileLine,char token){
    int result = 0;
    int i = 0;
    for(;fileLine[i];i++) if (fileLine[i] == token) result++;
    return (result == 2);
}


void freeUser(User a){
    if (a){
        free(a->id);
        free(a->name);
        free(a->friends);
        if (a->businessReviewed) g_slist_free(a->businessReviewed);
    }
}