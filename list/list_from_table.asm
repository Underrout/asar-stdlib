includeonce

macro create_list_from_table(list_name, table_location, data_size, entry_amount)
    assert not(defined("<list_name>")),"List with name <list_name> already exists"

    if not(defined("STDLIB_NAMESPACE_TABLESIZES"))
        %create_string_list("STDLIB_NAMESPACE_TABLESIZES", "db", "dw", "dl")
    endif

    assert STDLIB_NAMESPACE_TABLESIZES_contains("<data_size>"),"<data_size> is not a valid table size"

    !<list_name> = <list_name>
    !<list_name>_TYPE = "NUMBER"
    !<list_name>_SIZE #= <entry_amount>

    !amount_of_bytes_per_entry #= STDLIB_NAMESPACE_TABLESIZES_index_of("<data_size>")+1
    !read_function = "read!amount_of_bytes_per_entry"

    !x = 0
    while !x != <entry_amount>
        !{<list_name>_!x} = !read_function(<table_location>+(!x*!amount_of_bytes_per_entry))
        !x #= !x+1
    endif

    %_define_list_functions(<list_name>)
endmacro
