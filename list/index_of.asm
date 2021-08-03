includeonce

macro _define_index_of_functions(list_name)
    warnings push
    warnings disable W1026

    !x = 0
    !p = -1
    while !x != !<list_name>_SIZE
        if !x == 0
            function _<list_name>_index_at_0(value) = _<list_name>_contains_at_0(value)-1
        elseif !x != !<list_name>_SIZE-1
            function _<list_name>_index_at_!x(value) = _<list_name>_contains_at_!x(value)+_<list_name>_index_at_!p(value)
        else
            function _<list_name>_index_at_!x(value) = !<list_name>_SIZE-1-(_<list_name>_contains_at_!x(value)+_<list_name>_index_at_!p(value))-\
                (equal(!<list_name>_SIZE, !<list_name>_SIZE-1-(_<list_name>_contains_at_!x(value)+_<list_name>_index_at_!p(value)))*(!<list_name>_SIZE+1))
        endif

        !x #= !x+1
        !p #= !p+1
    endif

    function <list_name>_index_of(value) = _<list_name>_index_at_!p(value)

    warnings pull
endmacro
