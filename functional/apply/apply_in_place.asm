includeonce

incsrc "../../list/string_list.asm"
incsrc "../../list/number_list.asm"

macro _apply_in_place(func, location, data_size, element_amount, call_string)
    if not(defined("STDLIB_NAMESPACE_TABLESIZES"))
        %create_string_list("STDLIB_NAMESPACE_TABLESIZES", "db", "dw", "dl")
    endif

    assert STDLIB_NAMESPACE_TABLESIZES_contains("<data_size>"),"<data_size> is not a valid table size"

    if not(defined("STDLIB_NAMESPACE_MAX_SIZES"))
        %create_number_list("STDLIB_NAMESPACE_MAX_SIZES", $FF, $FFFF, $FFFFFF)
    endif

    !amount_of_bytes_per_entry #= STDLIB_NAMESPACE_TABLESIZES_index_of("<data_size>")+1
    !read_function = "read!amount_of_bytes_per_entry"

    !size_idx #= STDLIB_NAMESPACE_TABLESIZES_index_of("<data_size>")

    !max_size = !{STDLIB_NAMESPACE_MAX_SIZES_!size_idx}

    org <location>
        !x = 0
        while !x != <element_amount>
            !res #= <func>(<call_string>!read_function(<location>+(!x*!amount_of_bytes_per_entry)))

            if !res > !max_size
                warn "!res is greater than size type <data_size> allows and will be truncated" 
            endif

            <data_size> !res
            !x #= !x+1
        endif
endmacro

macro apply_in_place(func, location, data_size, element_amount)
    %_apply_in_place(<func>, <location>, <data_size>, <element_amount>, "")
endmacro

macro apply_in_place_enumerated(func, location, data_size, element_amount)
    %_apply_in_place(<func>, <location>, <data_size>, <element_amount>, "\!x, ")
endmacro
