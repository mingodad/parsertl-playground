//From: https://github.com/moonbitlang/moonyacc/blob/fd1930879f5ee8f9b8b134616992384d43460b0f/src/lib/parser/parser.mbty

%token ARROW_CODE
%token IDENT
%token LANGLE_CODE_RANGLE
%token LBRACE_CODE_RBRACE
%token PERCENT_LBRACE_CODE_PERCENT_RBRACE
//%token PERCENT_PERCENT_CODE_EOF
%token STRING

%%

spec
    : header decl_list "%%" rule_list trailer //EOF
    ;

header
    : PERCENT_LBRACE_CODE_PERCENT_RBRACE
    | %empty
    ;

trailer
    : PERCENT_LBRACE_CODE_PERCENT_RBRACE
    | "%%" //PERCENT_PERCENT_CODE_EOF
    | %empty
    ;

decl_list
    : decl_list decl
    | %empty
    ;

decl
    : "%start" nonempty_symbol_list
    | "%token" opt_type nonempty_symbol_list
    | "%token" opt_type symbol STRING
    | "%type" LANGLE_CODE_RANGLE nonempty_symbol_list
    | "%position" LANGLE_CODE_RANGLE
    | "%left" nonempty_symbol_list
    | "%right" nonempty_symbol_list
    | "%nonassoc" nonempty_symbol_list
    | "%derive" LANGLE_CODE_RANGLE IDENT
    ;

opt_type
    : LANGLE_CODE_RANGLE
    | %empty
    ;

rule_list
    : rule
    | rule_list rule
    ;

rule
    : rule_no_modifiers
    | "%inline" rule_no_modifiers
    ;

rule_no_modifiers
    : symbol rule_type ":" clause_list ";"
    ;

rule_type
    : ARROW_CODE
    | %empty
    ;

clause_list
    : clause
    | clause_list "|" clause
    ;

clause
    : item_list rule_prec clause_action
    ;

clause_action
    : LBRACE_CODE_RBRACE
    | %empty
    ;

rule_prec
    : "%prec" symbol
    | %empty
    ;

item_list
    : item_list item
    | %empty
    ;

item
    : item_symbol
    | IDENT "=" item_symbol
    ;

item_symbol
    : symbol
    | STRING
    ;

nonempty_symbol_list
    : symbol
    | nonempty_symbol_list symbol
    ;

symbol
    : IDENT
    ;

%%

%x ANGLE_CODE BRACE_CODE

%%

<*>[ \t\r\n]+	skip()
<*>"(*"(?s:.)*?"*)"	skip()
<*>"/*"(?s:.)*?"*/"	skip()

"%%"	"%%"
"%derive"	"%derive"
"%inline"	"%inline"
"%left"	"%left"
"%nonassoc"	"%nonassoc"
"%position"	"%position"
"%prec"	"%prec"
"%right"	"%right"
"%start"	"%start"
"%token"	"%token"
"%type"	"%type"
":"	":"
";"	";"
"="	"="
"|"	"|"

"->"\s*[^\s:]+	ARROW_CODE
"<"<>ANGLE_CODE>
<ANGLE_CODE>{
	">"<<>	LANGLE_CODE_RANGLE
	"<"<>ANGLE_CODE>
	.|\n<.>
}
"{"<>BRACE_CODE>
<BRACE_CODE>{
	"}"<<>	LBRACE_CODE_RBRACE
	"{"<>BRACE_CODE>
	.|\n<.>
}
"%{"(?s:.)*?"%}"	PERCENT_LBRACE_CODE_PERCENT_RBRACE
//PERCENT_PERCENT_CODE_EOF	PERCENT_PERCENT_CODE_EOF

\"(\\.|[^"\r\n\\])+\"	STRING

[A-Za-z_][A-Za-z0-9_]*	IDENT

%%
