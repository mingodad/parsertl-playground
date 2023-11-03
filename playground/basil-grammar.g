//From: https://web.archive.org/web/20191020032112/http://lazycplusplus.com/basil/rules-01.html
//See: https://github.com/mjspncr/basilcc

%token IDENT NL
%token LBRACK
%token RBRACK
%token LPAREN
%token RPAREN
%token GT
%token LT
%token PLUS
%token STAR
%token CARET
%token BANG
%token ARROW
%token NUMBER
%token DOLLAR

%%

start :
    rule_seq_opt
    ;

rule_seq_opt :
    /*empty*/
    | rule_seq
    ;

rule_seq :
    NL
    | rule
    | rule_seq NL
    | rule_seq rule
    ;

rule :
    rule_name_opt symbol ARROW symbol_seq_opt NL
    ;

rule_name_opt :
    /*empty*/
    | rule_name
    | rule_name NL
    ;

rule_name :
    LBRACK slip_spec_opt IDENT RBRACK
    | LBRACK LPAREN IDENT RPAREN RBRACK
    | LBRACK RBRACK
    ;

slip_spec_opt :
    /*empty*/
    | slip_spec
    ;

slip_spec :
    DOLLAR
    ;

symbol_seq_opt :
    /*empty*/
    | symbol_seq
    ;

symbol_seq :
    symbol
    | symbol_seq symbol
    ;

symbol :
    IDENT attrib_seq_opt
    ;

attrib_seq_opt :
    /*empty*/
    | attrib_seq
    ;

attrib_seq :
    attrib
    | attrib_seq attrib
    ;

attrib :
    GT
    | PLUS
    | NUMBER
    | STAR
    | LT
    | CARET
    | LPAREN attrib_seq RPAREN NUMBER
    | BANG
    ;

%%

base_id [A-Za-z_][A-Za-z0-9_-]*
ARROW   "->"

%%

[\r\t ]+	skip()
"#".*\n	skip()
"#".*	skip()

\n+  NL

"["	LBRACK
"]"	RBRACK
"("	LPAREN
")"	RPAREN
">" GT
"<" LT
"+" PLUS
"*"	STAR
"^" CARET
"!" BANG
"$" DOLLAR
{ARROW}	ARROW

[0-9]+  NUMBER
{base_id}	IDENT

%%
