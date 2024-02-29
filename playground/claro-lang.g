//From: https://github.com/JasonSteving99/claro-lang/blob/d7297f79d46e1c083fd3f2dbe77c5a10bb23007d/src/java/com/claro/ClaroParser.cup

/*
Replaced right recursion by left recursion
*/

%token LPAR RPAR
%token LCURLY RCURLY LBRACKET RBRACKET
%token EXPONENTIATE
%token MULTIPLY DIVIDE MODULUS
%token PLUS MINUS
%token INCREMENT DECREMENT
%token SEMICOLON
%token COLON
%token COMMA
%token BAR
%token EQUALS NOT_EQUALS
%token UNDERSCORE
%token VAR ASSIGNMENT
%token L_ANGLE_BRACKET R_ANGLE_BRACKET LTE GTE
%token OR AND NOT
%token IN
%token INSTANCEOF
%token ARROW UP_ARROW PIPE_ARROW IMPLICATION_ARROW
%token TRUE FALSE
// An integer is also a terminal but it's of type Integer.
%token INTEGER
%token LONG FLOAT
%token DOUBLE
// A string is also a terminal but it's of type String.
%token STRING FMT_STRING_PART
%token CHAR
// A variable identifier is just a sequence of chars.
%token IDENTIFIER
%token SCOPED_IDENTIFIER
// The prefix "log_" of the function log_x(y) is also a terminal.
// This is good practice for figuring out how to handle functions
// once I get to Claro consider this a function hard-coded into the
// grammar.
%token LOG_PREFIX
// This grammar also has a builtin print() function for printing expr values.
%token PRINT
// This grammar also has a builtin sleep() function.
%token SLEEP
// This grammar also has a builtin numeric() function for casting booleans to doubles.
%token NUMERIC_BOOL
// This grammar also has a builtin input() function for reading a line from stdin.
%token INPUT
// This grammar also has a builtin copy() function for efficiently and conveniently copying data.
%token COPY
// This grammar also has a builtin fromJson() function for efficiently and conveniently parsing JSON.
%token FROM_JSON
// This grammar also has a builtin isInputReady() function for checking whether a line is ready to be read on stdin.
%token IS_INPUT_READY
// This grammar also has a builtin len() function for getting the length of an Iterable.
%token LEN
// This grammar also has a builtin type() function for getting the type of an Expr.
%token TYPE
// This grammar also has a builtin append() function for appending an element to a List.
%token REMOVE
%token IF ELSE
%token WHILE FOR REPEAT BREAK CONTINUE WHERE MATCH CASE
// Builtin Types (with keywords instead of symbolic notation e.g. list is [<type>]).
%token INT_TYPE LONG_TYPE FLOAT_TYPE DOUBLE_TYPE BOOLEAN_TYPE STRING_TYPE CHAR_TYPE
%token TUPLE_TYPE STRUCT_TYPE ONEOF FUNCTION_TYPE CONSUMER_FUNCTION_TYPE
%token PROVIDER_FUNCTION_TYPE LAMBDA
%token ALIAS
%token ATOM NEWTYPE UNWRAP INITIALIZERS UNWRAPPERS
%token RETURN QUESTION_MARK_ASSIGNMENT
%token MUT
%token DOT
%token MODULE BIND TO AS USING
%token FUTURE BLOCKING_GET BLOCKING MAYBE_BLOCKING GRAPH ROOT NODE LEFT_ARROW AT
%token CONTRACT IMPLEMENT REQUIRES
%token CAST
%token HTTP_SERVICE HTTP_CLIENT GET_HTTP_CLIENT HTTP_SERVER HTTP_RESPONSE ENDPOINT_HANDLERS GET_BASIC_HTTP_SERVER_FOR_PORT
%token PRIVILEGED_INLINE_JAVA SYNTHETIC_JAVA_TYPE
// DEBUGGING keywords which should be removed when we want a real release....
%token DEBUG_DUMP_SCOPE

// Declare which type will be returned by each nonterminal grammar production.
// Unfortunately IntelliJ is starting to take a dump on this file since it's gotten massive so it will no longer
// correctly parse this type even though JCup and Java are handling the file like a champ.
// This is just because Java is hot garbage and doesn't have tuples. The first entry will be a sink stmt.
// The second entry will be an ImmutableList.Builder<Expr>. The Expr will be required to contain some
// backreference to the value piped from the previous expr.

//  except that it will also need to be able to either make itself a codegen inlining of the prior expr or it will
//  need to reference a generated identifier for an intermediate temporary.
// Lower precedence things at the top higher precedence things at the bottom.
// ...but also I've basically put no thought whatsoever into the order these ACTUALLY appear in.
%right ARROW
//%right QUESTION_MARK_ASSIGNMENT
%left INSTANCEOF
%left IN
%left COMMA
%left IDENTIFIER
%left SEMICOLON
%left ASSIGNMENT
%left COLON
%left EQUALS NOT_EQUALS
%left AND OR NOT
%left L_ANGLE_BRACKET R_ANGLE_BRACKET LTE GTE
%left PLUS MINUS
%left INCREMENT DECREMENT
%left MULTIPLY DIVIDE MODULUS
%left EXPONENTIATE
%left LOG_PREFIX IF ELSE
%left WHILE FOR REPEAT BREAK WHERE
%left QUESTION_MARK_ASSIGNMENT
%left DOT
%left LPAR RPAR LBRACKET RBRACKET

%%

// This is where the grammar starts.
program :
    stmts_and_defs_list
  ;

// TODO(steving) Add procedure defs to this target so that they also can only be used at the top level.
stmts_and_defs_list :
  // We'll allow files with only a single one of these following stmts as well.
    stmt
  | module_definition_stmt
  | contract_definition_stmt
  | contract_implementation_stmt
  | generic_function_definition_stmt
  | generic_consumer_function_definition_stmt
  | generic_provider_function_definition_stmt
  | stmts_and_defs_list stmt
  | stmts_and_defs_list module_definition_stmt
  | stmts_and_defs_list contract_definition_stmt
  | stmts_and_defs_list contract_implementation_stmt
  | stmts_and_defs_list generic_function_definition_stmt
  | stmts_and_defs_list generic_consumer_function_definition_stmt
  | stmts_and_defs_list generic_provider_function_definition_stmt
  ;

stmt_list :
    stmt
  | stmt_list stmt
  | debug_stmts
  ;

debug_stmts :
    DEBUG_DUMP_SCOPE LPAR RPAR SEMICOLON
  ;

stmt :
    print
  | show_type
  | identifier_declaration
  | identifier_assignment
  | trashcan_assignment
  | identifier_increment_stmt
  | identifier_decrement_stmt
  | struct_field_assignment_stmt
  | list_element_assignment
  | if_else_chain_stmt
  | match_stmt
  | while_stmt
  | for_loop_stmt
  | repeat_stmt
  | break_stmt
  | continue_stmt
  | function_definition_stmt
  | consumer_function_definition_stmt
  | provider_function_definition_stmt
  | consumer_function_call_stmt
  | graph_function_definition_stmt
  | graph_provider_definition_stmt
  | graph_consumer_definition_stmt
  | initializers_block_stmt
  | unwrappers_block_stmt
  | return_stmt
  | alias_stmt
  | atom_def_stmt
  | newtype_def_stmt
  | using_block_stmt
  | pipe_chain_stmt
  | http_service_def_stmt
  | endpoint_handlers_block_stmt
  | sleep
  | privileged_inline_java
  ;

module_definition_stmt :
    MODULE IDENTIFIER LCURLY bind_stmts_list RCURLY
  | MODULE IDENTIFIER USING LPAR identifier_list RPAR LCURLY bind_stmts_list RCURLY
  ;

bind_stmts_list :
    bind_stmt
  | bind_stmts_list bind_stmt
  ;

bind_stmt :
    BIND IDENTIFIER COLON builtin_type TO expr SEMICOLON
  ;

using_block_stmt :
    USING LPAR identifier_list RPAR LCURLY stmt_list RCURLY
  ;

print :
    PRINT LPAR expr RPAR SEMICOLON
  ;

show_type :
    TYPE LPAR expr RPAR SEMICOLON
  ;

unwrap_expr :
    UNWRAP LPAR expr RPAR
  ;

identifier_declaration :
    VAR IDENTIFIER ASSIGNMENT expr SEMICOLON
  | VAR IDENTIFIER COLON builtin_type SEMICOLON
  | VAR IDENTIFIER COLON builtin_type ASSIGNMENT expr SEMICOLON
  // Blocking variants.
  | VAR IDENTIFIER COLON builtin_type BLOCKING_GET expr SEMICOLON
  | VAR IDENTIFIER BLOCKING_GET expr SEMICOLON
  // Automatic error propagation variants.
  | VAR IDENTIFIER COLON builtin_type QUESTION_MARK_ASSIGNMENT expr SEMICOLON
  | VAR IDENTIFIER QUESTION_MARK_ASSIGNMENT expr SEMICOLON
  ;

alias_stmt :
    ALIAS IDENTIFIER COLON builtin_type
  ;

atom_def_stmt :
    ATOM identifier
  ;

newtype_def_stmt :
    NEWTYPE IDENTIFIER COLON builtin_type
  | NEWTYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET COLON builtin_type
  ;

initializers_block_stmt :
    INITIALIZERS IDENTIFIER LCURLY initializers_or_unwrappers_proc_defs_list RCURLY
  ;

unwrappers_block_stmt :
    UNWRAPPERS IDENTIFIER LCURLY initializers_or_unwrappers_proc_defs_list RCURLY
  ;

  // TODO(steving) Add support for Generic Graph Procedures when available.
initializers_or_unwrappers_proc_defs_list :
    function_definition_stmt
  | provider_function_definition_stmt
  | consumer_function_definition_stmt
  | graph_function_definition_stmt
  | graph_provider_definition_stmt
  | generic_function_definition_stmt
  | generic_provider_function_definition_stmt
  | generic_consumer_function_definition_stmt
  | initializers_or_unwrappers_proc_defs_list function_definition_stmt
  | initializers_or_unwrappers_proc_defs_list provider_function_definition_stmt
  | initializers_or_unwrappers_proc_defs_list consumer_function_definition_stmt
  | initializers_or_unwrappers_proc_defs_list graph_function_definition_stmt
  | initializers_or_unwrappers_proc_defs_list graph_provider_definition_stmt
  | initializers_or_unwrappers_proc_defs_list generic_function_definition_stmt
  | initializers_or_unwrappers_proc_defs_list generic_provider_function_definition_stmt
  | initializers_or_unwrappers_proc_defs_list generic_consumer_function_definition_stmt
  ;

builtin_type :
    base_builtin_type_without_mutability_modifier
  | MUT base_builtin_type_without_mutability_modifier
  ;

base_builtin_type_without_mutability_modifier :
    INT_TYPE
  | LONG_TYPE
  | FLOAT_TYPE
  | DOUBLE_TYPE
  | BOOLEAN_TYPE
  | STRING_TYPE
  | CHAR_TYPE
  | LBRACKET builtin_type RBRACKET
  | LCURLY builtin_type RCURLY
  | LCURLY builtin_type COLON builtin_type RCURLY
    // Maps are defined like {string} to avoid a new keyword `map` since I'd like to not impair functional style
    // where map is a well known function.
  | ONEOF L_ANGLE_BRACKET builtin_types_list R_ANGLE_BRACKET
  | FUNCTION_TYPE L_ANGLE_BRACKET builtin_type ARROW builtin_type R_ANGLE_BRACKET
  | FUNCTION_TYPE L_ANGLE_BRACKET BAR builtin_types_list BAR ARROW builtin_type R_ANGLE_BRACKET
  | BLOCKING FUNCTION_TYPE L_ANGLE_BRACKET builtin_type ARROW builtin_type R_ANGLE_BRACKET
  | BLOCKING FUNCTION_TYPE L_ANGLE_BRACKET BAR builtin_types_list BAR ARROW builtin_type R_ANGLE_BRACKET
  | CONSUMER_FUNCTION_TYPE L_ANGLE_BRACKET builtin_types_list R_ANGLE_BRACKET
  | BLOCKING CONSUMER_FUNCTION_TYPE L_ANGLE_BRACKET builtin_types_list R_ANGLE_BRACKET
  | PROVIDER_FUNCTION_TYPE L_ANGLE_BRACKET builtin_type R_ANGLE_BRACKET
  | BLOCKING PROVIDER_FUNCTION_TYPE L_ANGLE_BRACKET builtin_type R_ANGLE_BRACKET
  | TUPLE_TYPE L_ANGLE_BRACKET builtin_types_list R_ANGLE_BRACKET
  | FUTURE L_ANGLE_BRACKET builtin_type R_ANGLE_BRACKET
  | IDENTIFIER
  | SCOPED_IDENTIFIER
  | IDENTIFIER L_ANGLE_BRACKET builtin_types_list R_ANGLE_BRACKET
  | SCOPED_IDENTIFIER L_ANGLE_BRACKET builtin_types_list R_ANGLE_BRACKET
  | STRUCT_TYPE LCURLY function_args_types_list RCURLY
    // Structs are defined like `struct{field1: int ... fieldN: string}`. This is intended to resemble a sequence of
    // variable declarations which will align with the initialization syntax `{field1 = 1 ... fieldN = "foo"}` which
    // in turn is intended to resemble a sequence of variable initializations. I appreciate the metaphore of a struct as
    // a bundle of variables.
  | HTTP_RESPONSE
  | HTTP_CLIENT L_ANGLE_BRACKET builtin_type R_ANGLE_BRACKET
  | HTTP_SERVER L_ANGLE_BRACKET builtin_type R_ANGLE_BRACKET
  | SYNTHETIC_JAVA_TYPE LPAR STRING RPAR
  | SYNTHETIC_JAVA_TYPE L_ANGLE_BRACKET builtin_types_list R_ANGLE_BRACKET LPAR STRING RPAR
  ;

builtin_types_list :
    backwards_builtin_types_list
  ;

backwards_builtin_types_list :
    builtin_type
  | backwards_builtin_types_list COMMA builtin_type
  ;

identifier_assignment :
    identifier ASSIGNMENT expr SEMICOLON
  ;

trashcan_assignment :
    UNDERSCORE ASSIGNMENT expr SEMICOLON
  | UNDERSCORE QUESTION_MARK_ASSIGNMENT expr SEMICOLON
  ;

identifier_increment_stmt :
    identifier_increment SEMICOLON
  ;

identifier_increment :
    INCREMENT identifier
  | identifier INCREMENT
  ;

identifier_decrement_stmt :
    identifier_decrement SEMICOLON
  ;

identifier_decrement :
    DECREMENT identifier
  | identifier DECREMENT
  ;

list_element_assignment :
    collection_subscript ASSIGNMENT expr SEMICOLON
  | collection_subscript QUESTION_MARK_ASSIGNMENT expr SEMICOLON
  ;

list_remove_expr :
    REMOVE LPAR expr COMMA expr RPAR
  ;

// In order to support function calls w/in single-expr lambda bodies w/o making the grammar think that it has reached
// the end of the lambda at the first occurrence of `(` in the expr body I am making a separate grammar production for
// "all of the exprs including lambdas" and "all of the exprs not including lambdas" so that function application can be
// restricted to not work on lambdas right away. Solves the ambiguity in a minimally annoying way. To immediately call a
// lambda you'd need to wrap the lambda in parens or something.
expr :
    non_lambda_exprs
  | lambda_function_expr
  ;

non_lambda_exprs :
    MINUS expr
  | expr PLUS expr
  | identifier_increment
  | identifier_decrement
  | expr MINUS expr
  | expr MULTIPLY expr
  | expr DIVIDE expr
  | expr MODULUS expr
  | expr EXPONENTIATE expr
  | expr IN expr
  | parenthesized_expr
  | LOG_PREFIX float LPAR expr RPAR
  | LOG_PREFIX integer LPAR expr RPAR
  | NUMERIC_BOOL LPAR expr RPAR
  | input
  | list_remove_expr
  | unwrap_expr
  | is_input_ready
  | copy_expr
  | from_json_expr
  | list
  | map
  | list_comprehension_expr
  | set_comprehension_expr
  | map_comprehension_expr
  | collection_subscript
  | LEN LPAR expr RPAR
  | bool_expr
  | fmt_string
  | term
  | function_call_expr
  | typed_lambda_function_expr
  | provider_function_call_expr
  | tuple
  | set
  | struct
  | struct_field_access_expr
    // This is some unfortunate syntax for casting but this actually was necessary to avoid having casting create an
    // ambiguous grammar deciding whether `(i < len(l))` was a malformed cast (e.g. for some parameterized custom type
    // like `(MyType<foo>)`) or if it was actually a "less-than" operator within a parenthesized expression. From some
    // perspective this is an issue with JCUP being set to use too low of a lookahead....but I don't fully understand
    // the implications of trying to increase that so it'll stay this way.
  | CAST LPAR builtin_type COMMA expr RPAR
  | get_http_client_expr
  | get_basic_http_server_for_port_expr
  //| error
    // TODO(steving) This is super helpful do the same thing for stmts.
    // There's been some syntax error in an expression somewhere.. meaning that this expression is getting thrown away
    // in order to continue checking for other errors in the input program. So "repair" the program by giving it some
    // arbitrary Expr that won't complain a second time during AST type checking.
  ;

parenthesized_expr :
    LPAR expr RPAR
  ;

sleep :
    SLEEP LPAR expr RPAR SEMICOLON
  ;

input :
    INPUT LPAR STRING RPAR
  | INPUT LPAR RPAR
  ;

is_input_ready :
    IS_INPUT_READY LPAR RPAR
  ;

copy_expr :
    COPY LPAR expr RPAR
  ;

from_json_expr :
    FROM_JSON LPAR expr RPAR
  ;

list :
    LBRACKET args_list RBRACKET
  | LBRACKET RBRACKET
  | MUT LBRACKET args_list RBRACKET
  | MUT LBRACKET RBRACKET
  ;

map :
    LCURLY RCURLY
  | LCURLY map_initializer_kv_list RCURLY
  | MUT LCURLY RCURLY
  | MUT LCURLY map_initializer_kv_list RCURLY
  ;

map_initializer_kv_list :
    expr COLON expr
  | map_initializer_kv_list COMMA expr COLON expr
  ;

tuple :
    // Tuples distinguish themselves from parenthesized expressions by having at least one comma.
    LPAR expr COMMA args_list RPAR
  | MUT LPAR expr COMMA args_list RPAR
  ;

set :
    // Sets distinguish themselves from parenthesized expressions by having at least one comma and tuples by {} instead of ().
    LCURLY expr COMMA args_list RCURLY
  | MUT LCURLY expr COMMA args_list RCURLY
  ;

args_list :
   expr
  | args_list COMMA expr
  ;

struct :
    LCURLY struct_field_initializers_list RCURLY
  | MUT LCURLY struct_field_initializers_list RCURLY
  ;

// Note that we're again building this up backwards for convenience (remember that all guava collections respect ordering).
struct_field_initializers_list :
    IDENTIFIER ASSIGNMENT expr
  | struct_field_initializers_list COMMA IDENTIFIER ASSIGNMENT expr
  ;

struct_field_access_expr :
    expr DOT IDENTIFIER
  ;

struct_field_assignment_stmt :
    struct_field_access_expr ASSIGNMENT expr SEMICOLON
  ;

collection_subscript :
    expr LBRACKET expr RBRACKET
  ;

bool_expr :
    equality
  | inequality
  | bool_arithmetic
  | instanceof_expr
  ;

// This calculator can evaluate an equality check of expressions.
equality :
    expr EQUALS expr
  | expr NOT_EQUALS expr
  ;

if_else_chain_stmt :
    if_stmt else_if_stmt_chain
  | if_stmt else_stmt
  | if_stmt
  ;

if_stmt :
    IF LPAR expr RPAR LCURLY stmt_list RCURLY
  ;

else_if_stmt_chain :
    else_if_stmt else_if_stmt_chain
  | else_if_stmt else_stmt
  | else_if_stmt
  ;

else_if_stmt :
    ELSE if_stmt
  ;

// We can simply return the StmtListNode itself because this is actually gonna be run by the IfStmt it's associated
// with.
else_stmt :
    ELSE LCURLY stmt_list RCURLY
  ;

match_stmt :
    MATCH LPAR expr RPAR LCURLY match_cases_list_stmt RCURLY
  ;

match_cases_list_stmt :
   CASE match_case_patterns ARROW stmt_list
  | CASE match_multi_expr_case ARROW stmt_list
  | match_cases_list_stmt CASE match_case_patterns ARROW stmt_list
  | match_cases_list_stmt CASE match_multi_expr_case ARROW stmt_list
  ;

match_case_patterns :
    primitive
  | MINUS INTEGER
  | identifier
  | identifier LPAR primitive RPAR
  | identifier LPAR match_case_patterns RPAR
  | scoped_identifier LPAR primitive RPAR
  | scoped_identifier LPAR match_case_patterns RPAR
  | LPAR match_case_patterns COMMA match_case_patterns_list RPAR
  | MUT LPAR match_case_patterns COMMA match_case_patterns_list RPAR
  | LCURLY match_case_pattern_struct_field_list RCURLY
  | MUT LCURLY match_case_pattern_struct_field_list RCURLY
  | UNDERSCORE COLON builtin_type
  | identifier COLON builtin_type
  | UNDERSCORE
    // TODO(steving) This should model `_` as an Expr to have something to point at in errors.
  ;

// TODO(steving) TESTING!! Make multi-expr-case support arbitrary patterns.
match_multi_expr_case :
    primitive BAR primitive
  | identifier LPAR primitive RPAR BAR identifier LPAR primitive RPAR
  | match_multi_expr_case BAR primitive
  | match_multi_expr_case BAR identifier LPAR primitive RPAR
  ;

match_case_patterns_list :
    match_case_patterns
  | match_case_patterns_list COMMA match_case_patterns
  ;

match_case_pattern_struct_field_list :
    identifier ASSIGNMENT match_case_patterns
  | match_case_pattern_struct_field_list COMMA identifier ASSIGNMENT match_case_patterns
  ;

while_stmt :
    WHILE LPAR expr RPAR LCURLY stmt_list RCURLY
  ;

for_loop_stmt :
    FOR LPAR identifier IN expr RPAR LCURLY stmt_list RCURLY
  ;

repeat_stmt :
    REPEAT LPAR expr RPAR LCURLY stmt_list RCURLY
  ;

break_stmt :
    BREAK SEMICOLON
  ;

continue_stmt :
    CONTINUE SEMICOLON
  ;

list_comprehension_expr :
    LBRACKET expr BAR identifier IN expr RBRACKET
  | MUT LBRACKET expr BAR identifier IN expr RBRACKET
  | LBRACKET expr BAR identifier IN expr WHERE expr RBRACKET
  | MUT LBRACKET expr BAR identifier IN expr WHERE expr RBRACKET
  ;

set_comprehension_expr :
    LCURLY expr BAR identifier IN expr RCURLY
  | MUT LCURLY expr BAR identifier IN expr RCURLY
  | LCURLY expr BAR identifier IN expr WHERE expr RCURLY
  | MUT LCURLY expr BAR identifier IN expr WHERE expr RCURLY
  ;

map_comprehension_expr :
    LCURLY expr COLON expr BAR identifier IN expr RCURLY
  | MUT LCURLY expr COLON expr BAR identifier IN expr RCURLY
  | LCURLY expr COLON expr BAR identifier IN expr WHERE expr RCURLY
  | MUT LCURLY expr COLON expr BAR identifier IN expr WHERE expr RCURLY
  ;

function_definition_stmt :
   FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | USING LPAR injected_keys_list RPAR FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | BLOCKING FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | USING LPAR injected_keys_list RPAR BLOCKING FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | generic_blocking_on FUNCTION_TYPE IDENTIFIER LPAR procedure_args_w_generic_blocking RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | USING LPAR injected_keys_list RPAR generic_blocking_on FUNCTION_TYPE IDENTIFIER LPAR procedure_args_w_generic_blocking RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  ;

generic_function_definition_stmt :
   FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR function_args_types_list RPAR ARROW builtin_type LCURLY stmt_list RCURLY
 | REQUIRES LPAR required_contracts RPAR FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR function_args_types_list RPAR ARROW builtin_type LCURLY stmt_list RCURLY
 | BLOCKING FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR function_args_types_list RPAR ARROW builtin_type LCURLY stmt_list RCURLY
 | REQUIRES LPAR required_contracts RPAR BLOCKING FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR function_args_types_list RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | generic_blocking_on FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR procedure_args_w_generic_blocking RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | REQUIRES LPAR required_contracts RPAR generic_blocking_on FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR procedure_args_w_generic_blocking RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  ;

generic_blocking_on :
    BLOCKING COLON identifier_bar_sep_list
  ;

identifier_bar_sep_list :
    IDENTIFIER
  | identifier_bar_sep_list BAR IDENTIFIER
  ;

maybe_blocking_procedure_types :
    MAYBE_BLOCKING FUNCTION_TYPE L_ANGLE_BRACKET builtin_type ARROW builtin_type R_ANGLE_BRACKET
  | MAYBE_BLOCKING FUNCTION_TYPE L_ANGLE_BRACKET BAR builtin_types_list BAR ARROW builtin_type R_ANGLE_BRACKET
  | MAYBE_BLOCKING CONSUMER_FUNCTION_TYPE L_ANGLE_BRACKET builtin_types_list R_ANGLE_BRACKET
  | MAYBE_BLOCKING PROVIDER_FUNCTION_TYPE L_ANGLE_BRACKET builtin_type R_ANGLE_BRACKET
  ;

// TODO(steving) I need to enable generic functions to be generic over only a partial subset of the required
// TODO(steving) Contract's type params.
required_contracts :
    IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET
  | scoped_identifier L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET
  | required_contracts COMMA IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET
  | required_contracts COMMA scoped_identifier L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET
  ;

lambda_function_expr :
    IDENTIFIER ARROW expr
  | IDENTIFIER ARROW LCURLY stmt_list RCURLY
  | LAMBDA LPAR IDENTIFIER COMMA identifier_list RPAR ARROW expr
  | LAMBDA LPAR IDENTIFIER COMMA identifier_list RPAR ARROW LCURLY stmt_list RCURLY
  | LPAR RPAR ARROW expr
  | LPAR RPAR ARROW LCURLY stmt_list RCURLY
  ;

// TODO(steving) Lambda syntax has been complicated by parsing constraints. I don't actually want the `lambda` keyword
// TODO(steving) EVER. Figure out a way to actually define all lambda forms w/o ever using `lambda` keyword.
typed_lambda_function_expr :
    LPAR function_args_types_list RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | LAMBDA LPAR function_args_types_list RPAR ARROW LCURLY stmt_list RCURLY
  | LAMBDA LPAR RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  ;

identifier_list :
    IDENTIFIER
  | identifier_list COMMA IDENTIFIER
  ;

consumer_function_definition_stmt :
    CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list RPAR LCURLY stmt_list RCURLY
  | USING LPAR injected_keys_list RPAR CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list RPAR LCURLY stmt_list RCURLY
  | BLOCKING CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list RPAR LCURLY stmt_list RCURLY
  | USING LPAR injected_keys_list RPAR BLOCKING CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list RPAR LCURLY stmt_list RCURLY
  | generic_blocking_on CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR procedure_args_w_generic_blocking RPAR LCURLY stmt_list RCURLY
  | USING LPAR injected_keys_list RPAR generic_blocking_on CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR procedure_args_w_generic_blocking RPAR LCURLY stmt_list RCURLY
  ;

generic_consumer_function_definition_stmt :
   CONSUMER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR function_args_types_list RPAR LCURLY stmt_list RCURLY
 | REQUIRES LPAR required_contracts RPAR CONSUMER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR function_args_types_list RPAR LCURLY stmt_list RCURLY
 | BLOCKING CONSUMER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR function_args_types_list RPAR LCURLY stmt_list RCURLY
 | REQUIRES LPAR required_contracts RPAR BLOCKING CONSUMER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR function_args_types_list RPAR LCURLY stmt_list RCURLY
  | generic_blocking_on CONSUMER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR procedure_args_w_generic_blocking RPAR LCURLY stmt_list RCURLY
  | REQUIRES LPAR required_contracts RPAR generic_blocking_on CONSUMER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR procedure_args_w_generic_blocking RPAR LCURLY stmt_list RCURLY
  ;

provider_function_definition_stmt :
    PROVIDER_FUNCTION_TYPE IDENTIFIER LPAR RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | USING LPAR injected_keys_list RPAR PROVIDER_FUNCTION_TYPE IDENTIFIER LPAR RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | BLOCKING PROVIDER_FUNCTION_TYPE IDENTIFIER LPAR RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | USING LPAR injected_keys_list RPAR BLOCKING PROVIDER_FUNCTION_TYPE IDENTIFIER LPAR RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  ;

generic_provider_function_definition_stmt :
    PROVIDER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | REQUIRES LPAR required_contracts RPAR PROVIDER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | BLOCKING PROVIDER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  | REQUIRES LPAR required_contracts RPAR BLOCKING PROVIDER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR RPAR ARROW builtin_type LCURLY stmt_list RCURLY
  ;

injected_keys_list :
    identifier COLON builtin_type
  | identifier COLON builtin_type AS IDENTIFIER
  | injected_keys_list COMMA identifier COLON builtin_type
  | injected_keys_list COMMA identifier COLON builtin_type AS IDENTIFIER
  ;

// TODO(steving) Be less lazy and don't bother using a Map where we should just be using a List of pairs....but Java is so garbage it doesn't have tuples so.....
// Note that we're again building this up backwards for convenience (remember that all guava collections respect ordering).
function_args_types_list :
    IDENTIFIER COLON builtin_type
  | function_args_types_list COMMA IDENTIFIER COLON builtin_type
  ;

// LITERALLY THE ONLY DIFFERENCE BETWEEN THIS AND THE ABOVE `function_args_types_list` production is that this one gives
// IdentifierReferenceTerms instead of Strings. Useful for logging error messages. Only really applicable to Graphs for
// now since we don't actually have restrictions on procedure args in general.
// TODO(steving) Also use this production for blocking generic args so that we can indicate when blocking generics were used incorrectly.
function_args_types_list_identifiers :
    identifier COLON builtin_type
  | function_args_types_list_identifiers COMMA identifier COLON builtin_type
  ;

procedure_args_w_generic_blocking :
    IDENTIFIER COLON maybe_blocking_procedure_types
  | procedure_args_w_generic_blocking COMMA IDENTIFIER COLON maybe_blocking_procedure_types
  | IDENTIFIER COLON builtin_type
  | procedure_args_w_generic_blocking COMMA IDENTIFIER COLON builtin_type
  ;

return_stmt :
    RETURN expr SEMICOLON
  ;

// Just to make sure that graphs are somewhat consistent you must either choose between putting the root node as the
// first or last node definition in the graph body. Let's encourage ordering these sanely because it can be hard to
// trace declarative code without a pattern.
graph_function_definition_stmt :
    GRAPH FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list_identifiers RPAR ARROW builtin_type LCURLY root_node non_root_nodes_list RCURLY
  | GRAPH FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list_identifiers RPAR ARROW builtin_type LCURLY non_root_nodes_list root_node RCURLY
  | USING LPAR injected_keys_list RPAR GRAPH FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list_identifiers RPAR ARROW builtin_type LCURLY root_node non_root_nodes_list RCURLY
  | USING LPAR injected_keys_list RPAR GRAPH FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list_identifiers RPAR ARROW builtin_type LCURLY non_root_nodes_list root_node RCURLY
  ;

// Just to make sure that graphs are somewhat consistent you must either choose between putting the root node as the
// first or last node definition in the graph body. Let's encourage ordering these sanely because it can be hard to
// trace declarative code without a pattern.
graph_provider_definition_stmt :
    GRAPH PROVIDER_FUNCTION_TYPE IDENTIFIER LPAR RPAR ARROW builtin_type LCURLY root_node non_root_nodes_list RCURLY
  | GRAPH PROVIDER_FUNCTION_TYPE IDENTIFIER LPAR RPAR ARROW builtin_type LCURLY non_root_nodes_list root_node RCURLY
  | USING LPAR injected_keys_list RPAR GRAPH PROVIDER_FUNCTION_TYPE IDENTIFIER LPAR RPAR ARROW builtin_type LCURLY root_node non_root_nodes_list RCURLY
  | USING LPAR injected_keys_list RPAR GRAPH PROVIDER_FUNCTION_TYPE IDENTIFIER LPAR RPAR ARROW builtin_type LCURLY non_root_nodes_list root_node RCURLY
  ;

graph_consumer_definition_stmt :
    GRAPH CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list_identifiers RPAR LCURLY root_node non_root_nodes_list RCURLY
  | GRAPH CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list_identifiers RPAR LCURLY non_root_nodes_list root_node RCURLY
  | USING LPAR injected_keys_list RPAR GRAPH CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list_identifiers RPAR LCURLY root_node non_root_nodes_list RCURLY
  | USING LPAR injected_keys_list RPAR GRAPH CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list_identifiers RPAR LCURLY non_root_nodes_list root_node RCURLY
  ;

root_node :
    ROOT IDENTIFIER LEFT_ARROW expr SEMICOLON
  ;

non_root_node :
    NODE IDENTIFIER LEFT_ARROW expr SEMICOLON
  ;

non_root_nodes_list :
    non_root_node
  | non_root_nodes_list non_root_node
  ;

node_reference :
    AT IDENTIFIER
  ;

contract_definition_stmt :
    CONTRACT IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LCURLY contract_signature_defs_list RCURLY
  | CONTRACT IDENTIFIER L_ANGLE_BRACKET identifier_list IMPLICATION_ARROW identifier_list R_ANGLE_BRACKET LCURLY contract_signature_defs_list RCURLY
  ;

contract_signature_defs_list :
    contract_procedure_signature_definition_stmt
  | contract_signature_defs_list contract_procedure_signature_definition_stmt
  ;

contract_procedure_signature_definition_stmt :
   // FUNCTIONS
   FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list RPAR ARROW builtin_type SEMICOLON
 | BLOCKING FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list RPAR ARROW builtin_type SEMICOLON
 | generic_blocking_on FUNCTION_TYPE IDENTIFIER LPAR procedure_args_w_generic_blocking RPAR ARROW builtin_type SEMICOLON
 | FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR function_args_types_list RPAR ARROW builtin_type SEMICOLON
 | BLOCKING FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR procedure_args_w_generic_blocking RPAR ARROW builtin_type SEMICOLON
 | generic_blocking_on FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR procedure_args_w_generic_blocking RPAR ARROW builtin_type SEMICOLON
   // CONSUMERS
 | CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list RPAR SEMICOLON
 | BLOCKING CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR function_args_types_list RPAR SEMICOLON
 | generic_blocking_on CONSUMER_FUNCTION_TYPE IDENTIFIER LPAR procedure_args_w_generic_blocking RPAR SEMICOLON
 | CONSUMER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR function_args_types_list RPAR SEMICOLON
 | BLOCKING CONSUMER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR procedure_args_w_generic_blocking RPAR SEMICOLON
 | generic_blocking_on CONSUMER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR procedure_args_w_generic_blocking RPAR SEMICOLON
   // PROVIDERS
 | PROVIDER_FUNCTION_TYPE IDENTIFIER LPAR RPAR ARROW builtin_type SEMICOLON
 | BLOCKING PROVIDER_FUNCTION_TYPE IDENTIFIER LPAR RPAR ARROW builtin_type SEMICOLON
 | PROVIDER_FUNCTION_TYPE IDENTIFIER L_ANGLE_BRACKET identifier_list R_ANGLE_BRACKET LPAR RPAR ARROW builtin_type SEMICOLON
  ;

contract_implementation_stmt :
    IMPLEMENT IDENTIFIER L_ANGLE_BRACKET builtin_types_list R_ANGLE_BRACKET LCURLY contract_implementations_list RCURLY
  | IMPLEMENT scoped_identifier L_ANGLE_BRACKET builtin_types_list R_ANGLE_BRACKET LCURLY contract_implementations_list RCURLY
  ;

contract_implementations_list :
    function_definition_stmt
  | consumer_function_definition_stmt
  | provider_function_definition_stmt
  | generic_function_definition_stmt
  | generic_consumer_function_definition_stmt
  | contract_implementations_list function_definition_stmt
  | contract_implementations_list consumer_function_definition_stmt
  | contract_implementations_list provider_function_definition_stmt
  | contract_implementations_list generic_function_definition_stmt
  | contract_implementations_list generic_consumer_function_definition_stmt
  ;

pipe_chain_stmt :
    expr pipe_chain
  ;

pipe_chain :
    PIPE_ARROW expr pipe_chain
  | PIPE_ARROW consumer_function_call_stmt
  | PIPE_ARROW identifier_assignment
  | PIPE_ARROW identifier_declaration
  | PIPE_ARROW list_element_assignment
  | PIPE_ARROW print
  ;

function_call_expr :
    non_lambda_exprs LPAR args_list RPAR
  | scoped_identifier LPAR args_list RPAR
  // Foo:(arg1 ... argN)
  ;

provider_function_call_expr :
    non_lambda_exprs LPAR RPAR
  | scoped_identifier LPAR RPAR
  ;

consumer_function_call_stmt :
    non_lambda_exprs LPAR args_list RPAR SEMICOLON
  | scoped_identifier LPAR args_list RPAR SEMICOLON
  ;

inequality :
    expr L_ANGLE_BRACKET expr
  | expr R_ANGLE_BRACKET expr
  | expr LTE expr
  | expr GTE expr
  ;

bool_arithmetic :
    expr AND expr
  | expr OR expr
  | NOT expr
  ;

instanceof_expr :
    expr INSTANCEOF builtin_type
  ;

fmt_string :
    FMT_STRING_PART expr fmt_string
  | FMT_STRING_PART expr STRING
  ;

http_service_def_stmt :
    HTTP_SERVICE identifier LCURLY http_endpoints_list RCURLY
  ;

http_endpoints_list :
    identifier COLON fmt_string COMMA http_endpoints_list
  | identifier COLON STRING COMMA http_endpoints_list
  | identifier COLON fmt_string
  | identifier COLON STRING
  ;

endpoint_handlers_block_stmt :
    ENDPOINT_HANDLERS identifier LCURLY endpoint_handler_impl_graphs_list RCURLY
  ;

endpoint_handler_impl_graphs_list :
    graph_function_definition_stmt endpoint_handler_impl_graphs_list
  | graph_provider_definition_stmt endpoint_handler_impl_graphs_list
  | graph_function_definition_stmt
  | graph_provider_definition_stmt
  ;

get_http_client_expr :
    GET_HTTP_CLIENT LPAR expr RPAR
  ;

get_basic_http_server_for_port_expr :
    GET_BASIC_HTTP_SERVER_FOR_PORT LPAR expr RPAR
  ;

privileged_inline_java :
    PRIVILEGED_INLINE_JAVA
  ;

// The last production 'term' closes the grammar. It's a primitive or identifier reference.
term :
    primitive
  | identifier
  | scoped_identifier
  | node_reference
  | UP_ARROW
  ;

identifier :
    IDENTIFIER
  ;

scoped_identifier :
    SCOPED_IDENTIFIER
  ;

primitive :
    float
  | DOUBLE
  | integer
  | LONG
  | STRING
  | CHAR
  | TRUE
  | FALSE
  ;

float :
    FLOAT
  ;

integer :
    INTEGER
  ;

%%

%x PRIVILEGED_INLINE_JAVA

Integer        [0-9]+
Long           [0-9]+L
Float          {Integer}\.{Integer}F
Double         {Integer}\.{Integer}
Char           '(\\.|[^'\n\r\\])'

// A variable identifier. We'll just do uppercase for vars.
Identifier     ([a-z]|[A-Z])([a-z]|[A-Z]|_|[0-9])*

// An identifier found within an explicitly defined scope. This is explicitly defined in order to avoid running into a
// situation where the parser's single token lookahead would be insufficient to distinguish between various uses of
// scoped symbols e.g. `std::Error(std::Nothing)` parsed incorrectly as a syntax error before this change.
ScopedIdentifier {Identifier}::{Identifier}

// An identifier that explicitly references a contract procedure from some contract defined in a dep module. Follows the
// scoping as follows:
//    <dep module name>::<contract name>::<procedure name>
DepModuleContractProcedure {Identifier}::{Identifier}::{Identifier}

// A line terminator is a \r (carriage return), \n (line feed), or \r\n. */
LineTerminator \r|\n|\r\n

/* White space is a line terminator, space, tab, or line feed. */
WhiteSpace     [ \t\f]

PrivilegedInlineJavaTypeCaptures "$$TYPES<"({Identifier},)*{Identifier}>\n

%%

// YYINITIAL is the initial state at which the lexer begins scanning.

/* Create a new parser symbol for the lexem. */
"+"	PLUS
"++"	INCREMENT
"--"	DECREMENT
"-"	MINUS
"*"	MULTIPLY
"**"	EXPONENTIATE
"/"	DIVIDE
"%"	MODULUS
"("	LPAR
")"	RPAR
"{"	LCURLY
"}"	RCURLY
"["	LBRACKET
"]"	RBRACKET
"=="	EQUALS
"!="	NOT_EQUALS
"<"	L_ANGLE_BRACKET
">"	R_ANGLE_BRACKET
"<="	LTE
">="	GTE
"or"	OR
"and"	AND
"not"	NOT
"->"	ARROW
"|>"	PIPE_ARROW
"=>"	IMPLICATION_ARROW
"true"	TRUE
"false"	FALSE
"var"	VAR
"="	ASSIGNMENT
";"	SEMICOLON
":"	COLON
","	COMMA
"."	DOT
"|"	BAR
"if"	IF
"else"	ELSE
"match"	MATCH
"case"	CASE
"while"	WHILE
"for"	FOR
"repeat"	REPEAT
"break"	BREAK
"continue"	CONTINUE
"where"	WHERE
"return"	RETURN
"?="	QUESTION_MARK_ASSIGNMENT

// Builtin functions are currently processed at the grammar level.. maybe there's a better generalized way.
"log_"	LOG_PREFIX
"print"	PRINT
"numeric_bool"	NUMERIC_BOOL
"input"	INPUT
"isInputReady"	IS_INPUT_READY
"len"	LEN
"type"	TYPE
"remove"	REMOVE
"in"	IN
"instanceof"	INSTANCEOF
"copy"	COPY
"fromJson"	FROM_JSON
"sleep"	SLEEP

// DEBUGGING keywords that should be removed when we want a real release...
"$dumpscope"	DEBUG_DUMP_SCOPE

// This is an internal-only feature, reserved for implementing the stdlib.
"$$BEGIN_JAVA\n"<PRIVILEGED_INLINE_JAVA>

"$java_type"	SYNTHETIC_JAVA_TYPE

// Builtin Types.
"int"	INT_TYPE
"long"	LONG_TYPE
"float"	FLOAT_TYPE
"double"	DOUBLE_TYPE
"boolean"	BOOLEAN_TYPE
"string"	STRING_TYPE
"char"	CHAR_TYPE
"tuple"	TUPLE_TYPE
"oneof"	ONEOF
"struct"	STRUCT_TYPE
"function"	FUNCTION_TYPE
"consumer"	CONSUMER_FUNCTION_TYPE
"provider"	PROVIDER_FUNCTION_TYPE
"lambda"	LAMBDA
"alias"	ALIAS
"atom"	ATOM
"newtype"	NEWTYPE
"unwrap"	UNWRAP
"initializers"	INITIALIZERS
"unwrappers"	UNWRAPPERS

// Modifiers go here.
"mut"	MUT

// Module related bindings go here.
"module"	MODULE
"bind"	BIND
"to"	TO
"as"	AS
"using"	USING

"cast"	CAST

// Graph related things go here.
"future"	FUTURE
"graph"	GRAPH
"root"	ROOT
"node"	NODE
"blocking"	BLOCKING
"blocking?"	MAYBE_BLOCKING
"<-"	LEFT_ARROW
"@"	AT
"<-|"	BLOCKING_GET

// This up arrow is used for the pipe chain backreference term.
"^"	UP_ARROW

// Contract tokens.
"contract"	CONTRACT
"implement"	IMPLEMENT
"requires"	REQUIRES

"_"	UNDERSCORE

// Symbols related to builtin HTTP support go here.
// TODO(steving) The Http related types should all also require http:: namespacing.
// TODO(steving) This `http` module should be completely reimplemented as a proper claro_module_internal() target once possible.
"HttpService"	HTTP_SERVICE
"HttpClient"	HTTP_CLIENT
"http::getHttpClient"	GET_HTTP_CLIENT
"http::getBasicHttpServerForPort"	GET_BASIC_HTTP_SERVER_FOR_PORT
// This is a major hack that simply allows the detection of the synthetic http optional stdlib module for which extra java deps will need to be added to the build.
"http::startServerAndAwaitShutdown"	IDENTIFIER
"HttpResponse"	HTTP_RESPONSE
"HttpServer"	HTTP_SERVER
"endpoint_handlers"	ENDPOINT_HANDLERS

\"(\\.|[^"\n\r\\])*\"	STRING

FMT_STRING_PART	FMT_STRING_PART

// A String is a sequence of any printable characters between quotes.
//<STRING> {
//    \"<INITIAL>	STRING
//    [^\n\r\"\\{]+<.>
//    \\t<.>
//    \\n<.>
//
//    \\r<.>
//    \\\"<.>
//    \\<.>
//    \\\{<.>
//    "{"<INITIAL>	FMT_STRING_PART
//}

<PRIVILEGED_INLINE_JAVA> {
    {PrivilegedInlineJavaTypeCaptures}<.>
    .|\n<.>
    "$$END_JAVA\n"<INITIAL>	PRIVILEGED_INLINE_JAVA
}

// If the line comment symbol is found, ignore the token and then switch to the LINECOMMENT lexer state.
"#".*	skip()

// If an integer is found, return the token INTEGER that represents an integer and the value of
// the integer that is held in the string yytext
{Integer}	INTEGER
{Long}	LONG
{Char}	CHAR
// If float is found, return the token FLOAT that represents a float and the value of
// the float that is held in the string yytext
{Float}	FLOAT
{Double}	DOUBLE

{Identifier}	IDENTIFIER
{ScopedIdentifier}	SCOPED_IDENTIFIER
{DepModuleContractProcedure}	SCOPED_IDENTIFIER

/* Don't do anything if whitespace is found */
{WhiteSpace}       skip()

{LineTerminator}   skip()

%%