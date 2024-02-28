#include "../includes/Pagination.h"

struct window{
    TABLE table;
    int page;
    int last_page;
};

Window initWindow(){
    Window new = malloc(sizeof(struct window));
    new->table = initTable();
    new->page = 1;
    new->last_page = 1;
    return new;
}

int getPage(Window w){ return w->page; };
void setPage(Window w, int page){ if(page > 0 && page <= w->last_page) w->page = page; }

TABLE getTableFromWindow(Window w) { return w->table; };
void setTableToWindow(Window w, TABLE t) { w->table = t; };

int getLastPage(Window w) { return w->last_page; };
void setLastPage(Window w, int pg) { if(pg > w->page) w->last_page=pg; };

int calcLastPage(Window w){
    float res = (getContent(w->table)->len+1)/MAX_LINES;
    if(res - (int)res != 0) 
        res++;
    return (int) res; 
};

void destroyWindow(Window w){
    free(w);
}

void nextPage(Window w) { if(w->page < w->last_page) w->page++; };
void prevPage(Window w) { if(w->page > 1) w->page--; };

void firstPage(Window w) { setPage(w, 1); };
void lastPage(Window w) { setPage(w, w->last_page); };

void printPage(Window w){
    if(getContent(w->table)->len==0){ 
        printHeader(w->table);
        printSeparadorTable(getHeader(w->table),0);
    }else if(w->page==1){
        GPtrArray* contt = getContent(w->table);
        printHeader(w->table);
        if(w->page==w->last_page) printContent(w->table, 0, contt->len-1);
        else printContent(w->table, 0, MAX_LINES-2);
    }else if(w->page==w->last_page){
        GPtrArray* contt = getContent(w->table);
        printContent(w->table, (w->page-1)*MAX_LINES-1, contt->len-1);
    }else{
        int start = (w->page-1)*MAX_LINES-1;
        printContent(w->table, start, start+MAX_LINES-1);
    }
}

void printMenuBar(Window w){
    printf("+---------------+---------------+---------------+-----------------------------+---------+\n");
    printf("|%04d/%04d PAGE |  NEXT PAGE: N |  PREV PAGE: P | FIRST PAGE:F | LAST PAGE: L | EXIT: Q |\n", w->page, w->last_page);
    printf("+---------------+---------------+---------------+-----------------------------+---------+\n");
}

void printWindow(Window w){
    printPage(w);
    printMenuBar(w);
}

void runPagination(TABLE t){
    int res;
    hide_cursor();
    int exit = 0;
    char op;

    Window w = initWindow();
    setTableToWindow(w, t);
    setLastPage(w, calcLastPage(w));

    do{
        res = system("clear");
        printWindow(w);
        res = system("/bin/stty raw");
        op = getchar();
        res = system("/bin/stty cooked");
        switch(op){
            case 'n':
                nextPage(w);
                break;
            case 'p':
                prevPage(w);
                break;
            case 'f':
                firstPage(w);
                break;
            case 'l':
                lastPage(w);
                break;        
            case 'q':
                exit = 1;
                break;        
        }
    } while (!exit);
    res++;
    destroyWindow(w);
    show_cursor();
}

void printCabecalho(){
    clear();
            printf("+==============================================================================+\n");
    printf("|\e[1;36m                         ********   ********  *******                         \e[0m|\n");
    printf("|\e[1;36m                        **//////   **//////**/**////**                        \e[0m|\n");
    printf("|\e[1;36m                       /**        **      // /**   /**                        \e[0m|\n");
    printf("|\e[1;36m                       /*********/**         /*******                         \e[0m|\n");
    printf("|\e[1;36m                       ////////**/**    *****/**///**                         \e[0m|\n");
    printf("|\e[1;36m                              /**//**  ////**/**  //**                        \e[0m|\n");
    printf("|\e[1;36m                        ********  //******** /**   //**                       \e[0m|\n");
    printf("|\e[1;36m                       ////////    ////////  //     //                        \e[0m|\n");
            printf("+==============================================================================*\n");
}

void printMenuComandos(){
    printf("+==============================================================================+\n");
    printf("|Commands:  \e[0;33mtoCSV\e[0m(x, delim, filepath);     x = \e[0;33mfromCSV\e[0m(filepath, delim);       |\n");
    printf("|           y = \e[0;33mfilter\e[0m(x, column_name, value, oper);            \e[0;33mshow\e[0m(x);       |\n");

    printf("|           y = \e[0;33mproj\e[0m( x, cols);   z = x[1][1];  \e[0;33mcount\e[0m(x) ;   EXIT: \e[0;33mquit\e[0m;       |\n");
    printf("| Q  x = \e[0;33mbusinesses_started_by_letter\e[0m(SGR sgr, char letter);                   |\n");
    printf("| u  x = \e[0;33mbusiness_info\e[0m(SGR sgr, char *business_id);                            |\n");
    printf("| e  x = \e[0;33mbusinesses_reviewed\e[0m(SGR sgr, char *user_id);                          |\n");
    printf("| r  x = \e[0;33mbusinesses_with_stars_and_city\e[0m(SGR sgr, float stars, char *city);     |\n");
    printf("| i  x = \e[0;33mtop_businesses_by_city\e[0m(SGR sgr, int top);                             |\n");
    printf("| e  x = \e[0;33minternational_users\e[0m(SGR sgr);                                         |\n");
    printf("| s  x = \e[0;33mtop_businesses_with_category\e[0m(SGR sgr, int top, char *category);       |\n");
    printf("|    x = \e[0;33mreviews_with_word\e[0m(SGR sgr, char *word);                               |\n");
    printf("+==============================================================================+\n");


}

void promptComands(char* s){
    printf("%s",s);
    printf("|-> ");
}

void mainDisplay(char* message){
    printCabecalho();
    printMenuComandos();
    promptComands(message);
}
