includeonce

incsrc "../../list/define_list_functions.asm"

macro _apply_to_list(list_name, func, call_string)
    assert defined("<list_name>"),"List with name <list_name> does not exist"
    assert not(stringsequal("!<list_name>_TYPE", "STRING")),"Cannot apply to string lists"

    !x = 0
    while defined("<list_name>_!x")
        !{<list_name>_!x} #= <func>(<call_string>!{<list_name>_!x})
        !x #= !x+1
    endif

    %_define_list_functions(<list_name>)
endmacro

macro apply_to_list(list_name, func)
    %_apply_to_list(<list_name>, <func>, "")
endmacro

macro apply_to_list_enumerated(list_name, func)
    %_apply_to_list(<list_name>, <func>, "\!x, ")
endmacro
