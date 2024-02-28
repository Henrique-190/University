#include "../includes/Reviews.h"

struct review{
    GString *review_id;
    GString *user_id;
    GString *business_id;
    gfloat stars;
    gint useful;
    gint funny;
    gint cool;
    GString *date;
    GString *text;
};

gchar *getID_review (Review rev){ return strdup(rev->review_id->str); }
gchar *getID_user (Review rev){ return strdup(rev->user_id->str); }
gchar *getID_business(Review rev){ return strdup(rev->business_id->str); }
gfloat getSTARS(Review rev){ return rev->stars; }
gint getUSEFUL(Review rev){ return rev->useful; }
gint getFUNNY(Review rev){ return rev->funny; }
gint getCOOL(Review rev){ return rev->cool; }
gchar *getDATE(Review rev){ return strdup(rev->date->str); }
gchar *getTEXT(Review rev){ return strdup(rev->text->str); }

int validREVIEWLine(char* fileLine, char token){
    int i = 0;
    int result = 0;
    for(;fileLine[i] && result != 8;i++) if (fileLine[i] == token) result++;
    return result==8;
 }

Review initREVIEW(char *review, char *user, char *business, float stars, int useful, 
 int funny, int cool, char *date, char *text){
    Review new = malloc(sizeof(struct review));
    new->review_id = g_string_new(review);
    new->user_id = g_string_new(user);
    new->business_id = g_string_new(business);
    new->stars = stars;
    new->useful = useful;
    new->funny = funny;
    new->cool = cool;
    new->date = g_string_new(date);
    new->text = g_string_new(text);
    return new;
}

Review initREVIEW_line(char *line,char *fieldSeparator){
    if(validREVIEWLine(line,*fieldSeparator)){
        char* review_id = strsep(&line, fieldSeparator);
        char* user_id  = strsep(&line, fieldSeparator);
        char* business_id = strsep(&line, fieldSeparator);
        float stars = atoi(strsep(&line, fieldSeparator));
        int useful = atoi(strsep(&line, fieldSeparator));
        int funny = atoi(strsep(&line, fieldSeparator));
        int cool = atoi(strsep(&line, fieldSeparator));
        char *date = strsep(&line, fieldSeparator);
        char *text = strsep(&line, fieldSeparator);
        return initREVIEW(review_id,user_id,business_id,stars,useful,funny,cool,date,text);
    }
    return NULL;
}

void freeREVIEW(Review rev){
    g_string_free(rev->review_id,TRUE);
    g_string_free(rev->business_id,TRUE);
    g_string_free(rev->date,TRUE);
    g_string_free(rev->user_id,TRUE);
    g_string_free(rev->text,TRUE);
    free(rev);
}