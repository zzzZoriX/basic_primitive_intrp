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

"+"                             { return ADD; }
"-"                             { return SUB; }
"/"                             { return MUL; }
"*"                             { return DIV; }
"="                             { return ASSIGN; }
"\n"                            { return NEWLINE; }

[a-zA-Z]                        { 
                                    yylval.var = malloc(sizeof(Variable));
                                    yylval.var->name = strdup(yytext); 
                                    return IDENT;
                                }
[0-9]+                          { yylval.integ = atoi(yytext); return VALUE; }

[ \t]                           ; // ничего
"#".*                           ; // комментарий

.                               { printf("Unknown symbol: %s\n", yytext); } 

%%