# List Implementation

Contains macros for defining lists and performing various operations on them. 

Lists are generally useful if you want a way to bundle multiple values together, but don't want to necessarily insert them into your ROM directly. Lists exist solely a compile time construct and will **not** be inserted into your ROM unless you explicitly convert them into a table.

`incsrc "stdlib/list/list.asm"` will bring all macros from this folder into scope for convenience.

## Creating lists

Use the `%create_number_list` macro to create a list of numbers:

```
%create_number_list("my_favorite_numbers", 1, 2, 4, 1)
```

and `%create_string_list` for lists of strings (NOTE: due to current asar limitations **all** whitespace inside strings is discarded):

```
%create_string_list("the_best_strings", "Hello", "and", "goodbye")
```

## Element access

After creating a list you can access its elements via `!<list_name_here>_<index_of_element_here>` like this:

```
print dec(!my_favorite_numbers_0)
print dec(!my_favorite_numbers_1)
print dec(!my_favorite_numbers_2)
print dec(!my_favorite_numbers_3)

# Output:
# 1
# 2
# 4
# 1
```

## Printing lists

You can print all elements in a list and which indices they are at using the `%print_list` macro. The second parameter determines the format of the output for number lists, "#", "$" and "%" will result in decimal, hexadecimal or binary formatting respectively. (The second parameter is ignored for string lists)

```
%print_list("my_favorite_numbers", "#") 

# Output:
# my_favorite_numbers:
# 0 -> 1
# 1 -> 2
# 2 -> 4
# 3 -> 1
```

## List size

The size of the list (aka the amount of elements it contains) can be accessed using `!<list_name_here>_SIZE`:

```
print dec(!my_favorite_numbers_SIZE)

# Output:
# 4
```

## Value presence and index determination

You can check if a value is present within a list using `<list_name_here>_contains(<value_to_check_for_here>)`:

```
print dec(my_favorite_numbers_contains(1))
print dec(my_favorite_numbers_contains(382))

# Output:
# 1
# 0
```

and you can get the index a value is at using `<list_name_here>_index_of(<value_to_search_for_here>)`, which will return the index of the leftmost instance of the value within the list if it is found and -1 otherwise:

```
print dec(my_favorite_numbers_index_of(4))
print dec(my_favorite_numbers_index_of(382))
print dec(my_favorite_numbers_index_of(1))

# Output:
# 2
# -1
# 0
```

## Extending lists

Adding additional values to an already created list can be done using the `%extend_list` macro:

```
%extend_list("the_best_strings", "and", "hello", "again!")

%print_list("the_best_strings", "#")

# Output:
# 0 -> Hello
# 1 -> and
# 2 -> goodbye
# 3 -> and 
# 4 -> hello
# 5 -> again!
```

## Converting to table

As stated earlier, lists themselves are purely compile time constructs, meaning they are not inserted into your ROM directly. You can however convert a list into a table explicitly and insert it using the `%as_table` macro:

```
%as_table("my_favorite_numbers", "db")

# results in:

db $01,$02,$04,$01
```

The second parameter denotes the size of the table entries. db, dw and dl are all supported. If any of the individual elements are larger than the specified table entry size (i.e. $123 with db entry size) the macro will throw a warning, if you continue despite the warning the value will be inserted, but truncated (i.e. $123 will be inserted as just $23).

Note that string lists can also be converted to tables, the second parameter is always implicitly "db" in that case. As stated above, whitespace within string lists is always dropped so being able to convert string lists may be of limited use.

## Foreach loops

Finally, various versions of the `%foreach` macro let you execute a user-defined macro for each element within a list.

This could be useful for constructing tables in a more complex manner or for generating repetitive code for multiple slightly different values (loop unrolling?).

```
%create_number_list("vals_to_check", $1, $8, $35)

macro check_number(number)
    CMP.b #<number>
    BEQ Return
endmacro

MyBadCode:
    LDA $1234
    %foreach("vals_to_check", check_number)
    INC $00
Return:
    RTS

# Result:
# 
# MyBadCode:
#     LDA $1234
#     CMP.b #$01
#     BEQ Return
#     CMP.b #$08
#     BEQ Return
#     CMP.b #$35
#     BEQ Return
#     INC $00
# Return:
#     RTS
```

The default `%foreach` macro only allows your macro to take one parameter, the element's value, however there are other versions of it that let you pass additional information to your macro:

- `%foreach_enumerated` will pass your macro the element's index as first and the element's value as second parameter:

```
macro mul_and_print(index, value)
    print dec(<index>),"*",dec(<value>)," -> ",dec(<index>*<value>)
endmacro

%foreach_enumerated("my_favorite_numbers")

# Output:
# 0*1 -> 0
# 1*2 -> 2
# 2*4 -> 8
# 3*1 -> 3
```

- `%foreach_extra` will allow you to pass an extra static parameter to your macro:

```
macro mul_and_print(extra, value)
    print dec(<extra>),"*",dec(<value>)," -> ",dec(<extra>*<value>)
endmacro

%foreach_extra("my_favorite_numbers", 8)

# Output:
# 8*1 -> 8
# 8*2 -> 16
# 8*4 -> 32
# 8*1 -> 8
```

- and `%foreach_enumerated_extra` will let you do both simultaneously:

```
macro mul_and_print(extra, index, value)
    print dec(<extra>),"*",dec(<index>),"*",dec(<value>)," -> ",dec(<extra>*<index><value>)
endmacro

%foreach_enumerated_extra("my_favorite_numbers", 2)

# Output:
# 2*0*1 -> 0
# 2*1*2 -> 4
# 2*2*4 -> 16
# 2*3*1 -> 6
```
