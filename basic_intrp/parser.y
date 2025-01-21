%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "./include/types.h"

int yylex();
int yyerror(const char* err);

extern FILE* yyin;

%}

%union {
    int integ;
    struct Variable* var;
};


%token <var> IDENT
%token <integ> VALUE
%token PRINT ADD SUB MUL DIV ASSIGN

%type <integ> expr

%left ADD SUB
%left MUL DIV

%start start

%%


start: parse_objects;

parse_objects:
    variable
    ;

variable:
    IDENT ASSIGN expr

expr:
      expr ADD expr { $$ = $1 + $3; }
    | expr SUB epxr { $$ = $1 - $3; }
    | expr MUL expr { $$ = $1 * $3; }
    | expr DIV expr { $$ = $1 / $3; }
    


%%

int yyerror(const char* err){
    fprintf(stderr, "Error: %s\n", err);
    return 0;
}

int main(int argc, char** argv){

    if(argc < 2){
        printf("correct use: %s <input_file>", argv[0]);
        return 1;
    }
    FILE* ifp = fopen(argv[1], "r");
    if(!ifp){
        perror("Error occured while opening input file!");
        return 1;
    }

    yyin = ifp;

    yyparse();

    fclose(ifp);

    return 0;
}