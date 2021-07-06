#include "../includes/TopBusiness.h"

struct top_business{
    char* name;
    GList* business;
};

char* getTopBName(TopBusiness c) { return strdup(c->name); };
void setTopBName(TopBusiness c, char* name) {c->name = strdup(name);}
GList* getBusinessList(TopBusiness c) { return c->business; }
void setBusinessList(TopBusiness c, GList *bus){ c->business = bus; }
void addToBusinessList(TopBusiness c, Business b){ setBusinessList(c,g_list_append(c->business,b));}


void setTopBusiness(TopBusiness tb, Business b){
    tb->name = getBusinessCity(b);
    addToBusinessList(tb,b);
}

TopBusiness initTopB(char* n, GList* business){
    TopBusiness c = malloc(sizeof(struct top_business));
    c->name = strdup(n);
    c->business = business;

    return c;
}

TopBusiness initTopBusiness(){
    TopBusiness new = malloc(sizeof(struct top_business));
    new->name = NULL;
    new->business = NULL;
    return new;
}

void freeTopBusiness(TopBusiness c){
    free(c->name);
    g_list_free_full(c->business,(GDestroyNotify) destroyBusiness);
    free(c);
}