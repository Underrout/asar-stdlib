includeonce

macro extend_list(list_name, ...)
    assert defined("<list_name>"),"List with name <list_name> does not exist"

    print hex(!<list_name>_SIZE)

    !x = 0
    while defined("<list_name>_!x")  ; don't ask me why, but !<list_name>_SIZE is apparently an "invalid number"
                                     ; so I need to do it like this (maybe???)
        !x #= !x+1
    endif

    !arg = 0
    while !x != !<list_name>_SIZE+sizeof(...)
        if stringsequal("!<list_name>_TYPE", "STRING")
            !<list_name>_!x = "<!arg>"
        else
            !<list_name>_!x = <!arg>
        endif
        !x #= !x+1
        !arg #= !arg+1
    endif

    !<list_name>_SIZE #= !<list_name>_SIZE+sizeof(...)

    %_define_list_functions(<list_name>)
endmacro
