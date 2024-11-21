//From: https://github.com/victorhornet/typeling/blob/fa01cf5ad2989ef80e6eb839b299a0d29cd8c857/src/language/grammar/typeling.y

%token ALIAS
%token ARROW
%token BOOL
%token CASE
%token COLON
%token COMMA
%token ELSE
%token FALSE
%token FLOAT
%token FLOAT_LIT
%token FN
%token FREE
%token IF
%token INT
%token INT_LIT
%token LBRACE
%token PIPE
%token PRINT
%token RBRACE
%token RETURN
%token RETURNS
%token RPAREN
%token SEMICOLON
%token STRING
%token STRING_LIT
%token TRUE
%token TYPE
%token WHILE
%token WILDCARD

%right ASSIGN
%left OR
%left AND
%nonassoc EQ NEQ LT GT LTE GTE
%left PLUS MINUS
%left TIMES DIVIDE MOD
%left DOT
%nonassoc NOT
%right IDENT TYPE_IDENT LPAREN

%start file

%%

file
    : item_list
    | %empty
    ;

item_list
    : item
    | item_list item
    ;

item
    : function_decl
    | type_decl
    | alias_decl
    ;

alias_decl
    : ALIAS TYPE_IDENT ASSIGN type
    ;

type_decl
    : TYPE TYPE_IDENT generics type_def
    ;

generics
    : %empty
    | generic_list
    ;

generic_list
    : IDENT
    | generic_list IDENT
    ;

type_def
    : shorthand_def
    | ASSIGN type_constructors
    ;

type_constructors
    : type_constructor
    | type_constructors PIPE type_constructor
    ;

type_constructor
    : TYPE_IDENT type_constructor_params
    | TYPE_IDENT shorthand_def
    ;


type_constructor_params
    : anonymous_type_constructor_param_list
    | named_type_constructor_param_list
    ;

anonymous_type_constructor_param_list
    : type
    | anonymous_type_constructor_param_list type
    ;

named_type_constructor_param_list
    : named_field
    | named_type_constructor_param_list named_field
    ;

shorthand_def
    : %empty
    | LPAREN tuple_params RPAREN
    | struct_def
    ;

struct_def
    : LBRACE RBRACE
    | LBRACE struct_fields RBRACE
    | LBRACE struct_fields COMMA RBRACE
    ;

tuple_params
    : type
    | tuple_params COMMA type
    ;

struct_fields
    : named_field
    | struct_fields COMMA named_field
    ;

named_field
    : IDENT COLON type
    ;

function_decl
    : function_sig block
    ;

function_sig
    : FN IDENT function_proto
    ;

function_proto
    : LPAREN params RPAREN function_decl_return
    ;

function_decl_return
    : RETURNS type
    | %empty
    ;

params
    : %empty
    | param_list
    ;

param_list
    : param
    | param_list COMMA param
    ;

param
    : IDENT COLON type
    ;

block
    : LBRACE block_contents RBRACE
    ;

block_contents
    : stmt_list
    | %empty
    ;


stmt_list
    : stmt
    | stmt_list stmt
    ;

stmt
    : expr SEMICOLON
    | block
    | if_stmt
    | while_stmt
    | return_stmt
    | print_stmt
    | var_decl
    | assign_stmt
    | free_stmt
    ;

if_stmt
    : IF expr block
    | IF expr block ELSE block
    ;

while_stmt
    : WHILE expr block
    ;

return_stmt
    : RETURN expr SEMICOLON
    | RETURN SEMICOLON
    ;

print_stmt
    : PRINT LPAREN expr RPAREN SEMICOLON
    ;

var_decl
    : IDENT COLON type SEMICOLON
    | IDENT COLON type ASSIGN expr SEMICOLON
    | IDENT COLON ASSIGN expr SEMICOLON
    ;

assign_stmt
    : assignable_expr ASSIGN expr SEMICOLON
    ;

free_stmt
    : FREE LPAREN assignable_expr RPAREN SEMICOLON
    ;

type
    : primitive_type
    | TYPE_IDENT
    ;

primitive_type
    : INT
    | FLOAT
    | STRING
    | BOOL
    | LPAREN RPAREN
    ;


args
    : %empty
    | arg_list
    ;

arg_list
    : expr
    | arg_list COMMA expr
    ;

expr
    : expr AND expr
    | expr PLUS expr
    | expr MINUS expr
    | expr TIMES expr
    | expr DIVIDE expr
    | expr MOD expr
    | expr EQ expr
    | expr NEQ expr
    | expr LT expr
    | expr LTE expr
    | expr GT expr
    | expr GTE expr
    | expr OR expr
    | case_expr
    | factor
    ;

member_access
    : assignable_expr DOT IDENT
    | assignable_expr DOT INT_LIT
    ;

factor
    : unary_op term
    | term
    ;

assignable_expr
    : IDENT
    | member_access
    ;


comma_separated_exprs
    : expr
    | comma_separated_exprs COMMA expr
    ;

term
    : assignable_expr
    | IDENT LPAREN args RPAREN
    | TYPE_IDENT
    | TYPE_IDENT LPAREN comma_separated_exprs RPAREN
    | TYPE_IDENT LPAREN construct_type_arg_list_named_elems RPAREN
    | STRING_LIT
    | LPAREN expr RPAREN
    | primitive_value
    ;

primitive_value
    : INT_LIT
    | FLOAT_LIT
    | FALSE
    | TRUE
    ;

construct_type_arg_list_named_elems
    : construct_type_arg_list_named_elem
    | construct_type_arg_list_named_elems COMMA construct_type_arg_list_named_elem
    ;

construct_type_arg_list_named_elem
    : IDENT ASSIGN expr
    ;


unary_op
    : MINUS
    | NOT
    ;


case_expr
    : CASE expr LBRACE case_expr_arms RBRACE
    | CASE expr LBRACE case_expr_arms COMMA RBRACE
    ;

case_expr_arms
    : case_expr_arm
    | case_expr_arms COMMA case_expr_arm
    ;

case_expr_arm
    : case_pattern ARROW expr
    | case_pattern ARROW block
    ;

case_pattern
    : IDENT
    | type_pattern
    | equality_check_pattern
    | WILDCARD
    ;

type_pattern
    : TYPE_IDENT
    | TYPE_IDENT LPAREN comma_separated_patterns RPAREN
    ;

equality_check_pattern
    : primitive_value
    ;

comma_separated_patterns
    : case_pattern
    | comma_separated_patterns COMMA case_pattern
    ;


%%

%%

fn FN
return RETURN
if IF
else ELSE
while WHILE
print PRINT
type TYPE
alias ALIAS


case CASE

free FREE

[0-9]+ INT_LIT
[0-9][_0-9]*\.(([0-9]+[_0-9]*)|([0-9]*))f FLOAT_LIT
\"([^\\\"]|\\[\'\"ntr])*\" STRING_LIT
true TRUE
false FALSE

\_ WILDCARD

\+ PLUS
\- MINUS
\* TIMES
\/ DIVIDE
\% MOD

\== EQ
\!= NEQ
\> GT
\< LT
\>= GTE
\<= LTE
and AND
or OR
not NOT

\= ASSIGN
\| PIPE
\; SEMICOLON
\: COLON
\( LPAREN
\) RPAREN

<INITIAL>\{ LBRACE
<INITIAL>\} RBRACE


\, COMMA
\. DOT

i64 INT
f64 FLOAT
str STRING
bool BOOL

-> RETURNS
=> ARROW

[_a-z][_a-zA-Z0-9]* IDENT
[A-Z][_a-zA-Z0-9]* TYPE_IDENT


[ \t\r\n]+ skip()
"//".* skip()
"/*"([^*]|\*[^/])*"*/" skip()

%%
