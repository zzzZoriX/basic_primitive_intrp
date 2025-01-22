%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "./include/types.h"
#include "./include/variable.h"

int yylex();
int yyerror(const char* err);

extern FILE* yyin;

%}

%union {
    void* null_type;
    int integ;
    struct Variable* var;
};


%token <var> IDENT
%token <integ> VALUE
%token ADD SUB MUL DIV ASSIGN NEWLINE
%token PRINT IF ELSE THEN
%token L LOE GOE G EQ NEQ

%type <integ> expr

%type <integ> condition
%type <null_type> if_body print_command variable

%left ADD SUB
%left MUL DIV

%start start

%%


start: parse_objects;

parse_objects:
      parse_objects if_else
    | parse_objects variable
    | parse_objects print_command
    | /* void */
    ;

variable:
    IDENT ASSIGN expr {
        Variable* var_with_ident_name = find_var_for_name($1->name);
        if(!var_with_ident_name){
            $1->value = $3;
            if(!add_var_to_var_list($1)){
                fprintf(stderr, "Add variable to list failed\n");
                exit(1);
            }
        }
        else{
            var_with_ident_name->value = $3;
            free($1->name);
            free($1);
        }

    }
    ;

print_command:
    PRINT expr {
        printf("%d\n", $2);
    }
    ;

if_else:
    IF condition THEN if_body {
        if($2){
            $4;
        }
    }
    ;

expr:
      expr ADD expr { $$ = $1 + $3; }
    | expr SUB expr { $$ = $1 - $3; }
    | expr MUL expr { $$ = $1 * $3; }
    | expr DIV expr { $$ = $1 / $3; }
    | VALUE { $$ = $1; }
    | IDENT {
        Variable* temp_var = find_var_for_name($1->name);
        if (temp_var == NULL) {
            yyerror("Undefined variable");
            YYERROR; // Прерываем выполнение
        }
        $$ = temp_var->value;
    }
    ;

condition:
      expr L expr     { $$ = $1 < $3 ? 1 : 0; }
    | expr LOE expr   { $$ = $1 <= $3 ? 1 : 0; }
    | expr GOE expr   { $$ = $1 >= $3 ? 1 : 0; }
    | expr G expr     { $$ = $1 > $3 ? 1 : 0; }
    | expr EQ expr    { $$ = $1 == $3 ? 1 : 0; }
    | expr NEQ expr   { $$ = $1 != $3 ? 1 : 0; }
    ;

if_body:
      print_command
    | variable
    | if_body print_command
    | if_body variable
    ;


%%

int yyerror(const char* err){

    extern char* yytext;

    fprintf(stderr, "The character on which the error occurred: '%s'\n", yytext);
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

    if(!init_var_list()){
        fprintf(stderr, "Mmeory allocate for variable list failed\n");
        return 1;
    }

    yyin = ifp;

    yyparse();

    fclose(ifp);

    free_var_list();

    return 0;
}