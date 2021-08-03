includeonce

macro _insert_number_element(size_idx, element)
    !size = !{STDLIB_NAMESPACE_TABLESIZES_!size_idx}
    !max_size = !{STDLIB_NAMESPACE_MAX_SIZES_!size_idx}

    !sidx #= <size_idx>

    if <element> > !max_size
        warn "<element> is greater than size type !size allows and will be truncated" 
    endif

    !size <element>
endmacro

macro _insert_string_element(element)
    db "<element>"
endmacro

macro as_table(list_name, size)
    assert defined("<list_name>"),"List with name <list_name> does not exist"

    if not(defined("STDLIB_NAMESPACE_TABLESIZES"))
        %create_string_list("STDLIB_NAMESPACE_TABLESIZES", "db", "dw", "dl")
    endif

    if not(defined("STDLIB_NAMESPACE_MAX_SIZES"))
        %create_number_list("STDLIB_NAMESPACE_MAX_SIZES", $FF, $FFFF, $FFFFFF)
    endif

    !is_string_table = stringsequal("!<list_name>_TYPE", "STRING")

    if !is_string_table
        !size_idx = 0
    else
        assert STDLIB_NAMESPACE_TABLESIZES_contains("<size>"),"<size> is not a valid table size"
        !size_idx #= STDLIB_NAMESPACE_TABLESIZES_index_of("<size>")
    endif

    if !is_string_table
        %foreach(<list_name>, _insert_string_element)
    else
        %foreach_extra(<list_name>, _insert_number_element, !size_idx)
    endif
endmacro
