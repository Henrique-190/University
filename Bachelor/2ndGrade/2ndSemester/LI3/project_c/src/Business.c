#include "../includes/Business.h"

struct business{
    char* categories;
    char* business_id;
    char* name;
    char* city;
    char* state;
    int totalReviews;
    float totalStars;
};

char* getBusinessID(Business bs) { return strdup(bs->business_id); }
char* getBusinessName(Business bs) { return strdup(bs->name); }
char* getBusinessCity(Business bs) { return strdup(bs->city); }
char* getBusinessState(Business bs) { return strdup(bs->state); }
char* getBusinessCategories(Business bs){ return strdup(bs->categories); }

float getBusinessStars(Business bs){ return bs->totalStars; }
void setBusinessStars(Business bs, float star) { bs->totalStars = star; }

int getBusinessReviews(Business bs){ return bs->totalReviews; }
void setBusinessReviews(Business bs, int reviews) { bs->totalReviews = reviews; }

float getBusinessAverageStars(Business bs){ return bs->totalReviews ? bs->totalStars/bs->totalReviews : 0; }


int validBusiness(char* fileLine, char token){
    int i = 0;
    int result = 0;
    for(;fileLine[i];i++) if (fileLine[i] == token) result++;
    return (result == 4);
}


Business initBusiness(char* bs_id, char* name, char* city, char* state, char* ctg){
    if(bs_id != NULL && name != NULL && city != NULL && state != NULL && ctg != NULL){
        Business bs = malloc(sizeof(struct business));
        bs->business_id = strdup(bs_id);
        bs->name = strdup(name);
        bs->city = strdup(city);
        bs->state = strdup(state);
        bs->categories = strdup(ctg);
        bs->totalReviews = 0;
        bs->totalStars = 0;
        return bs;
    }
    return NULL;
}


Business initBusinessFromLine(char* fileLine, char *fieldSeparator){
        char* bs_id = strsep(&fileLine, fieldSeparator);
        char* name  = strsep(&fileLine, fieldSeparator);
        char* city = strsep(&fileLine, fieldSeparator);
        char* state = strsep(&fileLine, fieldSeparator);
        char* categories = strdup(fileLine);

        if(categories==NULL) categories = "None";

        return initBusiness(bs_id, name, city, state, categories);
}


StrArray parcingCategories(char* ctgs){
    StrArray ct = NULL;
    
    if(ctgs){
        ct = initStrArray();
        
        char* aux = strtok(ctgs, ",");
        for(;aux;aux = strtok(NULL, ","))
            g_array_prepend_val(ct, aux);
        
        free(aux);
    }

    return ct;
}


Business cloneBusiness(Business bs){
    Business new_b = malloc(sizeof(struct business*));
    new_b->business_id = getBusinessID(bs);
    new_b->name = getBusinessName(bs);
    new_b->city = getBusinessCity(bs);
    new_b->state = getBusinessState(bs);
    new_b->categories = getBusinessCategories(bs);
    new_b->totalReviews = getBusinessReviews(bs);
    new_b->totalStars = getBusinessStars(bs);
    return new_b;
}


void printBusiness(Business b){
    char* id = getBusinessID(b);
    char* name = getBusinessName(b);
    char* city = getBusinessCity(b);
    char* state = getBusinessState(b);
    int reviews = b->totalReviews;
    float stars = b->totalStars;
    if (reviews>0) stars = stars/reviews;
    
    printf("ID: %s || Name: %s || City: %s || State: %s || Total Reviews: %d || Stars: %f ||Categories: %s ", id, name, city, state,reviews,stars, b->categories);
    printf("%f\n",getBusinessAverageStars(b));
    free(state);
    free(city);
    free(name);
    free(id);
}


void destroyBusiness(Business bs){
    free(bs->categories);
    free(bs->business_id);
    free(bs->name);
    free(bs->city);
    free(bs->state);
    free(bs);
}