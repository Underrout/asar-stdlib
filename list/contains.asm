includeonce

macro _define_contains_functions(list_name)
    warnings push
    warnings disable W1026

    !type = !<list_name>_TYPE
    !is_string_list = stringsequal("!type", "STRING")

    !x = 0
    !p = -1
    while !x != !<list_name>_SIZE
        if !x == 0
            if !is_string_list
                function _<list_name>_contains_at_0(value) = stringsequal("!{<list_name>_!x}", value)
            else
                function _<list_name>_contains_at_0(value) = equal(!{<list_name>_!x}, value)
            endif
        else
            if !is_string_list
                function _<list_name>_contains_at_!x(value) = or(stringsequal("!{<list_name>_!x}", value), _<list_name>_contains_at_!p(value))
            else
                function _<list_name>_contains_at_!x(value) = or(equal(!{<list_name>_!x}, value), _<list_name>_contains_at_!p(value))
            endif
        endif
        !x #= !x+1
        !p #= !p+1
    endif

    function <list_name>_contains(value) = _<list_name>_contains_at_!p(value)

    warnings pull
endmacro
