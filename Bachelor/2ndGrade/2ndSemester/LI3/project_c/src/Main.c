#include "../includes/Interpreter.h"

int main(){
    
    printCabecalho();
    int read;
    
    printf("Where to read?\n");
    printf("Case \"default\": write \"1\" ; Otherwise: write \"0\": ");

    while(scanf("%d",&read)<=0);
    char* users = malloc(sizeof(char)*60);
    char* business = malloc(sizeof(char)*60);
    char* reviews = malloc(sizeof(char)*60);
    
    if(!read){
       printf("Path to Users: ");
       while(scanf("%s",users)<=0);
       printf("Path to Business: ");
       while(scanf("%s",business)<=0);
       printf("Path to Reviews: ");
       while(scanf("%s",reviews)<=0);
    }
    else{
        users = "input_files/users_full.csv";
        business = "input_files/business_full.csv";
        reviews = "input_files/reviews_1M.csv";
    }

    SGR sgr = loadSGR(users,business,reviews);
    if (sgr!=NULL) {
        interpreter(sgr);
        freeSGR(sgr);
    }
    else printf("\nInvalid files.");
    return 0;

}