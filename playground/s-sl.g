//https://en.wikipedia.org/wiki/S/SL_programming_language
//https://github.com/alegemaate/s-sl
//https://github.com/open-watcom/open-watcom-v2/tree/master/bld/ssl
// S/SL grammar

%token id string number
%token tInput tOutput tError tType tMechanism tRules tEnd

%%

s_sl :
    definitions tRules rules_decl tEnd
    ;

definitions :
    definition
    | definitions definition
    ;

definition :
    input_decl
    | output_decl
    | input_output_decl
    | error_decl
    | type_decl
    | mechanism_decl
    ;

input_decl :
    tInput ':' id_string_value_list ';'
    ;

output_decl :
    tOutput ':' id_value_list ';'
    ;

input_output_decl :
    tInput tOutput ':' id_string_value_list ';'
    ;

error_decl :
    tError ':' id_value_list ';'
    ;

type_decl :
    tType id ':' type_values ';'
    ;

mechanism_decl :
    tMechanism id ':' proc_func_list ';'
    ;

rules_decl :
    rule_decl
    | rules_decl rule_decl
    ;

rule_decl :
    proc_rule
    | choice_rule
    ;

proc_rule :
    id ':' rhs_id_string_list ';'
    ;

choice_rule :
    id ">>" id ':' rhs_id_string_list ';'
    ;

rhs_id_string_list :
    rhs_id_string
    | rhs_id_string_list rhs_id_string
    ;

rhs_id_string :
    id
    | '@' id
    | '#' id
    | '.' id
    | string
    | id '(' param_list ')'
    | '@' id '(' param_list ')'
    | rhs_choice
    | rhs_cycle
    | ">>"
    | '>'
    ;

rhs_cycle :
    '{' rhs_id_string_list '}'
    ;

rhs_choice :
    '[' rhs_choices ']'
    | '[' id rhs_choices ']'
    | '[' '@' id rhs_choices ']'
    | '[' '*' rhs_choices ']'
    ;

rhs_choices :
    rhs_one_choice
    | rhs_choices rhs_one_choice
    ;

rhs_one_choice :
    '|' id_string_comma_list ':'
    | '|' id_string_comma_list ':' rhs_id_string_list
    | '|' rhs_choice
    | '|' '*' ':'
    | '|' '*' ':' rhs_id_string_list
    ;

id_string_comma_list :
    id
    | string
    | id_string_comma_list ',' id
    | id_string_comma_list ',' string
    ;

id_string_value_list :
    id_string
    | id_string '=' number
    | id_string '=' id
    | id_string_value_list id_string
    | id_string_value_list id_string '=' number
    | id_string_value_list id_string '=' id
    ;

id_value_list :
    id
    | id '=' number
    | id '=' id
    | id_value_list id
    | id_value_list id '=' number
    | id_value_list id '=' id
    ;

id_string :
    id
    | id string
    ;

type_values :
    id
    | id '=' number
    | id '=' id
    | type_values id
    | type_values id '=' number
    | type_values id '=' id
    ;

proc_func_list :
    id
    | proc_return
    | id '(' param_list ')'
    | proc_func_list id
    | proc_func_list proc_return
    ;

proc_return :
    id ">>" id
    ;

param_list :
    id
    | param_list ',' id
    ;

%%

%option caseless

%%

[ \t\r\n\f]+  skip()
"%".*   skip()

"." '.'
";" ';'
"," ','
":" ':'
"=" '='
"(" '('
")" ')'
"[" '['
"]" ']'
"{" '{'
"}" '}'
"*" '*'
"|" '|'
"@" '@'
"#" '#'
">" '>'
">>"    ">>"

"INPUT" tInput
"OUTPUT"    tOutput
"ERROR" tError
"TYPE"  tType
"MECHANISM" tMechanism
"RULES" tRules
"END"   tEnd

"-"?[0-9]+  number

'(\\.|[^'\r\n\\])+' string

[A-Za-z_][A-Za-z0-9_]* id

%%
