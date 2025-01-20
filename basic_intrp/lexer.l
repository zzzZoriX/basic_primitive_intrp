%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "parser.tab.h"

%}

%option noyywrap

%%

[a-zA-Z]                        { yylval->var.name = strdup(yytext); return IDENT; }
[0-9]+                          { yylval.integ = atoi(yytext); return VALUE; }

[ \t\n]                         ; // ничего

%%