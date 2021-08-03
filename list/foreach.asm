includeonce

macro _foreach(list_name, macro_name, call_string)
    assert defined("<list_name>"),"List with name <list_name> does not exist"

    !x = 0
    while !x != !<list_name>_SIZE
        if stringsequal("!<list_name>_TYPE", "STRING")
            %<macro_name>(<call_string>"!{<list_name>_!x}")
        else
            %<macro_name>(<call_string>!{<list_name>_!x})
        endif
        !x #= !x+1
    endif 
endmacro

macro foreach(list_name, macro_name)
    %_foreach(<list_name>, <macro_name>, "")
endmacro

macro foreach_enumerated(list_name, macro_name)
    %_foreach(<list_name>, <macro_name>, "\!x ,")
endmacro

macro foreach_extra(list_name, macro_name, extra_parameter)
    %_foreach(<list_name>, <macro_name>, "<extra_parameter> ,")
endmacro

macro foreach_enumerated_extra(list_name, macro_name, extra_parameter)
    %_foreach(<list_name>, <macro_name>, "<extra_parameter>, \!x ,")
endmacro
