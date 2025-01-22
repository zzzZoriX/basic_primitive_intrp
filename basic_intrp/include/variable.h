#ifndef VARIABLE_H
#define VARIABLE_H

#include "types.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


Variable** var_list;
size_t var_list_indx = 0;
size_t current_var_list_size = 0;

/* initialize var_List */
int
init_var_list(){
    var_list = (Variable**)calloc(200, sizeof(Variable*));
    if(!var_list){
        fprintf(stderr, "Variable list initialize failed\n");
        return 0;
    }
    current_var_list_size = 200;
    return 1;
}

/* expand var_list size */
int
vars_list_realloc(){
    var_list = (Variable**)realloc(var_list, current_var_list_size * 2);
    if(!var_list)
        return 0;
    current_var_list_size *= 2;

    return 1;
}

/* add variable to variable list */
int
add_var_to_var_list(Variable* variable){
    if(var_list_indx == current_var_list_size)
        if(!vars_list_realloc())
            return 0;

    var_list[var_list_indx++] = variable;
    return 1;
}

/* find and return variable for it name */
Variable*
find_var_for_name(const char* name){
    if(name == NULL || var_list == NULL)
        return NULL;

    for(size_t i = 0; i < var_list_indx; ++i){
        if(var_list[i] != NULL && strcmp(var_list[i]->name, name) == 0)
            return var_list[i];
    }

    return NULL;
}

/* frees var_list and all variable */
void
free_var_list(){
    for(size_t i = 0; i < var_list_indx; ++i){
        free(var_list[i]->name);
        free(var_list[i]);
    }
    free(var_list);
}

/* remove variable from var_list */
void
remove_variable(const char* name){
    for(size_t i = 0; i < var_list_indx; ++i){
        if(var_list[i] && strcmp(var_list[i]->name, name) == 0){
            free(var_list[i]->name);
            free(var_list[i]);
        }
    }
}

#endif