#include "../includes/Interpreter.h"

struct variables {
    GHashTable* varHash;
};

void freeVHash(V_HASH hash){
    if(g_hash_table_size(hash->varHash)>0) g_hash_table_destroy(hash->varHash);
    free(hash);
}

V_HASH initVariables(){
    V_HASH hash = malloc(sizeof(struct variables));
    hash->varHash = g_hash_table_new_full(g_str_hash,g_str_equal,free,(GDestroyNotify)freeTable);
    return hash;
}

GHashTable* getVarHashTable(V_HASH hash){
    return hash->varHash;
}

void addQueryResult(V_HASH vars, char* key, TABLE value){
    if(g_hash_table_contains(vars->varHash, key)){
        g_hash_table_replace(vars->varHash, key, value);
    }else g_hash_table_insert(vars->varHash, key, value);
}

void removeChar(char* s, char c){
    int i, j;
    for (i = j = 0; s[i]; i++){
        if (s[i] != c) s[j++] = s[i];
    }
    s[j] = '\0';
}

void removeSpaces (char* command) {
    int i, cont = 0;
    for (i = 0; command[i]; i++)
        if (command[i] != ' ') command[cont++] = command[i];
    command[cont] = '\0';
}

StrArray getCommandFromUser(char* line){
    StrArray inputsElem = initStrArray();
    char tokens[] = {'=','(','[',',','\0'};
    while (line != NULL){
        char* elem = strsep(&line,tokens);
        if (strcmp(elem,"\"") != 0 && strlen(elem) > 0 && strcmp(elem,"\n") != 0)
            addToStrArray(inputsElem,elem);
    }

    return inputsElem;
}

GPtrArray* getCommands (char* line) {
    GPtrArray *commands = g_ptr_array_new_with_free_func((GDestroyNotify)destroyStrArray);
    char* command = NULL;
    StrArray separatedC;

    while (line != NULL){
        command = (strsep(&line," "));
        separatedC = getCommandFromUser(command);
        if (separatedC->data)
            g_ptr_array_add(commands,separatedC);
    }

    return commands;
}

OPERATOR getOperator(char* oper){
    if (!strcmp(oper,"LT")) return LT;
    if (!strcmp(oper,"EQ")) return EQ;
    if (!strcmp(oper,"GT")) return GT;
    return NONE;
}

int validWord(const char* word){
    int i;
    if (strlen(word) <= 0) return 0;
    for (i = 0; word[i];i++){
        if (!isalpha(word[i])) return 0;
    }
    return 1;
}

char* replaceWord(const char* line, const char* oldString, const char* newString){
    char* result;
    int i, count = 0;
    int lenOfNewS = (int)strlen(newString);
    int lenOfOldS =(int)strlen(oldString);

    for (i = 0; line[i] != '\0'; i++) {
        if (strstr(&line[i], oldString) == &line[i]) {
            count++;
            i += lenOfOldS - 1;
        }
    }

    result = (char*)malloc(i + count * (lenOfNewS - lenOfOldS) + 1);

    i = 0;
    while (*line) {
        if (strstr(line, oldString) == line) {
            strcpy(&result[i], newString);
            i += lenOfNewS;
            line += lenOfOldS;
        }
        else
            result[i++] = *line++;
    }

    result[i] = '\0';
    return result;
}

int interpreter(SGR sgr) {
    char *buffer = NULL;
    size_t size = 0, bufsize = 0;
    char* message = malloc(sizeof(char)*256);
    GPtrArray *commands = NULL;
    
    V_HASH varH = initVariables();
    int exit = 0;

    strcpy(message, "\n");
    while(!exit) {
        
        mainDisplay(message);
        bufsize = getline(&buffer, &size, stdin);
        
        if(bufsize>1){
            clock_t begin = clock();
            strcpy(message,buffer);
            
            removeSpaces(buffer);
            removeChar(buffer, '\n');
            removeChar(buffer, '"');
            removeChar(buffer, '\'');
            removeChar(buffer, '\0');

            buffer = replaceWord(buffer, ");", " ");
            buffer = replaceWord(buffer, "];", " ");
            buffer = replaceWord(buffer, "][", ",");

            commands = getCommands(buffer);

            int i = 0;
            for(;i < (int)commands->len; i++){
                StrArray command = (StrArray)g_ptr_array_index(commands,i);
                switch (getLength(command))
                {
                case 1:
                    if (!strcasecmp(getStrElement(command, 0), "quit")){
                        exit = 1;
                        freeVHash(varH);
                    }
                    break;

                case 2:
                    if (!strcasecmp(getStrElement(command, 0), "show")){
                        char* variable = strdup(getStrElement(command,1));
                        if (g_hash_table_contains(varH->varHash,variable))
                            runPagination((TABLE)g_hash_table_lookup(varH->varHash,variable));
                        else strcpy(message, "Table does not exist");
                        free(variable);
                    }
                    else if (!strcasecmp(getStrElement(command, 0), "count")) {
                        char *table = strdup(getStrElement(command, 1));
                        if (g_hash_table_contains(varH->varHash, table)) {
                            TABLE number = (TABLE) g_hash_table_lookup(varH->varHash, table);
                            int len = (int) getContent(number)->len;
                            char *lenString = malloc(sizeof(char) * 10);
                            sprintf(lenString, "%d", len);
                            message = strsep(&message,"\n");
                            strcat(message, " --> ");
                            strcat(message, lenString);
                            free(lenString);
                        } 
                        else strcpy(message, "Table does not exist");
                    }
                    else strcpy(message,"Invalid command");
                    break;

                case 3:
                    if (!strcasecmp(getStrElement(command, 1), "international_users")){
                        char *variable = getStrElement(command, 0);
                        if (!strcasecmp(getStrElement(command, 2), "sgr")) 
                            g_hash_table_insert(varH->varHash,strdup(variable),international_users(sgr));
                        else strcpy(message,"Invalid SGR");
                    }
                    break;
                
                case 4:
                    if(!strcasecmp(getStrElement(command,0),"toCSV")){
                        if (g_hash_table_contains(varH->varHash, getStrElement(command, 1))) {
                            TABLE table = (TABLE) g_hash_table_lookup(varH->varHash, getStrElement(command, 1));
                            toCSV(table, *getStrElement(command, 2), getStrElement(command, 3));
                        }
                        else strcpy(message,"Variable does not exist");
                    }
                    else if(!strcasecmp(getStrElement(command, 1), "fromCSV")){
                        TABLE newTable = fromCSV(getStrElement(command, 2), *getStrElement(command, 3));
                        g_hash_table_insert(varH->varHash, getStrElement(command, 0), newTable);
                    }
                    else if(!strcasecmp(getStrElement(command,1),"proj")){
                        char *variable = strdup(getStrElement(command,2));
                        if (g_hash_table_contains(varH->varHash,variable)){
                            TABLE table = (TABLE) g_hash_table_lookup(varH->varHash, getStrElement(command, 2));
                            GPtrArray *cols = g_ptr_array_new();
                            char *columns = strdup(getStrElement(command,3));
                            char *col;
                            while((col = strsep(&columns,";"))!=NULL) g_ptr_array_add(cols,col);
                            
                            g_hash_table_insert(varH->varHash, getStrElement(command, 0), proj(table, cols));
                        }
                        else strcpy(message, "Table does not exist");
                    }
                    else if(g_hash_table_contains(varH->varHash,getStrElement(command,1))){
                        char *row = getStrElement(command, 2);
                        int integerRow = (int) strtol(row, NULL, 10);
                        char *column = getStrElement(command, 3);
                        int integerColumn = (int) strtol(column, NULL, 10);

                        TABLE table = (TABLE) g_hash_table_lookup(varH->varHash, getStrElement(command, 1));
                        TABLE elem = getElemFromTable(table, integerRow, integerColumn);
                        g_hash_table_insert(varH->varHash, getStrElement(command, 0), elem);
                    }
                    else if(!strcasecmp("businesses_started_by_letter",getStrElement(command,1))){
                        if(!strcasecmp("sgr",getStrElement(command,2))){
                            g_hash_table_insert(varH->varHash,strdup(getStrElement(command,0)),businesses_started_by_letter(sgr,*strdup(getStrElement(command,3))));
                        }
                        else strcpy(message,"Invalid SGR");
                    }
                    else if(!strcasecmp("business_info",getStrElement(command,1))){
                        if(!strcasecmp("sgr",getStrElement(command,2))){
                            g_hash_table_insert(varH->varHash,strdup(getStrElement(command,0)),business_info(sgr,strdup(getStrElement(command,3))));
                        }
                        else strcpy(message,"Invalid SGR");
                    }
                    else if(!strcasecmp("businesses_reviewed",getStrElement(command,1))){
                        if(!strcasecmp("sgr",getStrElement(command,2))){
                            g_hash_table_insert(varH->varHash,strdup(getStrElement(command,0)),businesses_reviewed(sgr,strdup(getStrElement(command,3))));
                        }
                        else strcpy(message,"Invalid SGR");
                    }
                    else if(!strcasecmp("top_businesses_by_city",getStrElement(command,1))){
                        if(!strcasecmp("sgr",getStrElement(command,2))){
                            g_hash_table_insert(varH->varHash,strdup(getStrElement(command,0)),top_businesses_by_city(sgr,(int)strtol(getStrElement(command,3),NULL,10)));
                        }
                        else strcpy(message,"Invalid SGR");
                    }
                    else if(!strcasecmp("reviews_with_word",getStrElement(command,1))){
                        if(!strcasecmp("sgr",getStrElement(command,2))){
                            g_hash_table_insert(varH->varHash,strdup(getStrElement(command,0)),reviews_with_word(sgr,strdup(getStrElement(command,3))));
                        }
                        else strcpy(message,"Invalid SGR");
                    }
                    else strcpy(message,"Invalid command");
                    break;

                case 5:
                    if(!strcasecmp("businesses_with_stars_and_city",getStrElement(command,1))){
                        if(!strcasecmp("sgr",getStrElement(command,2))){
                            g_hash_table_insert(varH->varHash,strdup(getStrElement(command,0)),businesses_with_stars_and_city(sgr,atof(getStrElement(command,3)),strdup(getStrElement(command,4))));
                        }
                        else strcpy(message,"Invalid SGR");
                    }
                    
                    else if(!strcasecmp("top_businesses_with_category",getStrElement(command,1))){
                        char *sgr_parameter = getStrElement(command, 2);
                        int integerTop = (int) strtol(getStrElement(command, 3), NULL, 10);
                        char *category = getStrElement(command, 4);   
                        if (!strcmp(sgr_parameter, "sgr") && strlen(category) > 0) {
                            char *variable_name = getStrElement(command, 0);
                            TABLE query = top_businesses_with_category(sgr, integerTop, category);
                            g_hash_table_insert(varH->varHash, variable_name, query);
                        } else strcpy(message,"Parameters are not valid");
                    }
                    else strcpy(message,"Invalid command");
                    break;
                case 6:
                    if (!g_strcmp0(getStrElement(command, 1), "filter")) {
                        if (!g_hash_table_contains(varH->varHash, getStrElement(command, 2))) {
                            strcpy(message,"Table does not exist");
                        } else {
                            TABLE table = (TABLE) g_hash_table_lookup(varH->varHash, getStrElement(command, 2));
                            char *column_name = getStrElement(command, 3);
                            char *value = getStrElement(command, 4);
                            OPERATOR oper = getOperator(getStrElement(command, 5));
                            TABLE filteredTable = filter(table, column_name, value, oper);
                            g_hash_table_insert(varH->varHash, getStrElement(command, 0), filteredTable);
                        }
                    } 
                    else strcpy(message,"Invalid command");

                break;  
                
                default:
                    strcpy(message,"Invalid command");
                    break;
                }
                clock_t end = clock();
                double time = (double)(end - begin) / CLOCKS_PER_SEC;
                char *t = malloc(sizeof(char)*256);
                int res = sprintf(t,"     ---------------------> TIME: %.3f",time);
                strcat(t,"\n");
                message = strsep(&message,"\n");
                res++;
                strcat(message,t);
                free(t);
            }
        }
    }
    free(message);
    return 0;
}