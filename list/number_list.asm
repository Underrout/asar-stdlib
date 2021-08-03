includeonce

macro create_number_list(list_name, ...)
    assert not(defined("<list_name>")),"List with name <list_name> already exists"

    !<list_name> = <list_name>
    !<list_name>_TYPE = "NUMBER"
    !<list_name>_SIZE #= sizeof(...)
    
    !x = 0
    while !x != !<list_name>_SIZE
        !<list_name>_!x = <!x>
        !x #= !x+1
    endif

    %_define_list_functions(<list_name>)
endmacro
