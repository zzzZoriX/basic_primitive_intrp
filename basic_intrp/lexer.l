%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "parser.tab.h"
#include "./include/types.h"

%}

%option noyywrap

%%

"print"                         { return PRINT; }
"if"                            { return IF; }
"else"                          { return ELSE; }
"then"                          { return THEN; }

"<"                             { return L; }
"<="                            { return LOE; }
">="                            { return GOE; }
">"                             { return G; }
"=="                            { return EQ; }
"!="                            { return NEQ; }

"+"                             { return ADD; }
"-"                             { return SUB; }
"/"                             { return DIV; }
"*"                             { return MUL; }
"="                             { return ASSIGN; }

[a-zA-Z]                        { 
                                    yylval.var = malloc(sizeof(Variable));
                                    if(!yylval.var){
                                        fprintf(stderr, "Memory allocate for variable\n");
                                        exit(1);
                                    }

                                    yylval.var->name = strdup(yytext); 
                                    if(!yylval.var->name){
                                        fprintf(stderr,"Memory allocate for variable failed\n");
                                        free(yylval.var);
                                        exit(1);
                                    }

                                    return IDENT;
                                }
[0-9]+                          { yylval.integ = atoi(yytext); return VALUE; }

[ \t\n]                         ; // ничего
"#".*                           ; // комментарий

.                               { printf("Unknown symbol: %s\n", yytext); } 

%%