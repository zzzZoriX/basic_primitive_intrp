#ifndef VARIABLE_H
#define VARIABLE_H

#include "types.h"
#include <stdio.h>
#include <stdlib.h>


Variable** var_list;
size_t var_list_indx = 0;
size_t current_var_list_size = 0;

/* initialize var_List */
void
init_vars_list(){
    var_list = (Variable**)calloc(200, sizeof(Variable*));
    if(!var_list){
        fprintf(stderr, "Variable list initialize failed\n");
        return;
    }
    current_var_list_size = 200;
}

/* expand var_list size */
void
vars_list_realloc(){
    var_list = (Variable**)realloc(var_list, current_var_list_size * 2);
    current_var_list_size *= 2;
}

/* add variable to variable list */
void
add_var_to_var_list(Variable* variable){
    if(var_list_indx == current_var_list_size)
        vars_list_realloc();

    var_list[var_list_indx++] = variable;
}

/* find and return variable for it name */
Variable*
find_var_for_name(const char* name){
    for(size_t i = 0; i < var_list_indx; ++i){
        if(var_list[i]->name == name)
            return var_list[i];
    }
    return NULL;
}

#endif