includeonce

incsrc "contains.asm"
incsrc "index_of.asm"

macro _define_list_functions(list_name)
    %_define_contains_functions(<list_name>)
    %_define_index_of_functions(<list_name>)
endmacro
