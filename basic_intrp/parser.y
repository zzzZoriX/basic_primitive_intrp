%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "./include/types.h"

%}

%union {
    int integ;
    struct Variable* var;
};


%token <var> IDENT
%token <integ> VALUE

%%

start: parse_objects;

parse_objects:
    variables
    ;

variables:
    IDENT = VALUE {
        IDENT.value = $3;
    }