includeonce

macro _print_string_element(i, element)
    print "<i>-> <element>"
endmacro

macro _print_number_element(number_type, i, element)
    print "<i>-> ",<number_type>(<element>)
endmacro

macro print_list(list_name, number_symbol)
    if stringsequal("!<list_name>_TYPE", "STRING")
        print "<list_name>:"
        %foreach_enumerated(<list_name>, _print_string_element)
    else
        if not(defined("LIST_NAMESPACE_NUMBER_TYPES"))
            %create_string_list("LIST_NAMESPACE_NUMBER_TYPES", "dec", "hex", "bin")
            %create_string_list("LIST_NAMESPACE_NUMBER_SYMBOLS", "#", "$", "%")
        endif
        assert LIST_NAMESPACE_NUMBER_SYMBOLS_contains("<number_symbol>"),"<number_symbol> does not correspond to a valid number type"

        !symbol_index #= LIST_NAMESPACE_NUMBER_SYMBOLS_index_of("<number_symbol>")
        print "<list_name>:"
        %foreach_enumerated_extra(<list_name>, _print_number_element, !{LIST_NAMESPACE_NUMBER_TYPES_!symbol_index})
    endif
endmacro
