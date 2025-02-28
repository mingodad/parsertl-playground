//From: https://github.com/PrincetonUniversity/lucid/blob/c82780d7d5eb7036e56d082cad85ad9a87fb1c28/src/lib/frontend/Parser.mly

/*Tokens*/
%token ID
%token QID
%token NUM
%token NUMWITDH
%token BITPAT
%token STRING
%token INCLUDE
%token TRUE
%token FALSE
%token EQ
%token NEQ
%token AND
%token OR
%token CONCAT
%token NOT
%token UNORDERED
%token LESS
%token MORE
%token PLUS
%token SUB
%token SATSUB
%token ASSIGN
%token IF
%token ELSE
%token SEMI
%token HANDLE
%token FUN
%token MEMOP
%token RETURN
%token PRINTF
%token SIZE
%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token LBRACKET
%token RBRACKET
%token COMMA
%token DOT
%token TBOOL
%token EVENT
%token GENERATE
%token SGENERATE
%token MGENERATE
%token PGENERATE
%token TINT
%token GLOBAL
%token CONST
%token VOID
%token HASH
%token AUTO
%token GROUP
%token CONTROL
%token EGRESS
%token MAIN
%token PACKET
%token ANNOT
%token MATCH
%token WITH
%token PIPE
%token ARROW
%token EXTERN
%token TYPE
%token NOINLINE
%token TABLE_TYPE
%token KEY_TYPE
%token ARG_TYPE
%token RET_TYPE
%token ACTION
%token ACTION_CONSTR
%token TABLE_CREATE
%token TABLE_MATCH
%token TABLE_INSTALL
%token TABLE_MULTI_INSTALL
%token PATAND
%token PARSER
%token READ
%token SKIP
%token DROP
%token BITSTRING
%token CONSTR
%token PROJ
%token MODULE
%token BITAND
%token LEQ
%token GEQ
%token COLON
%token LSHIFT
%token RSHIFT
%token END
%token FOR
%token SIZECAST
%token BITXOR
%token SATPLUS
%token BITNOT
%token SYMBOLIC
%token FLOOD
%token WILDCARD
%token PATCAST
//%token EOF

%right /*1*/ ID EVENT
%left /*2*/ AND OR
%nonassoc /*3*/ EQ NEQ LESS MORE LEQ GEQ
%left /*4*/ PLUS SUB SATSUB SATPLUS
%left /*5*/ CONCAT
%left /*6*/ PIPE BITAND LSHIFT RSHIFT BITXOR
%left /*7*/ PATAND
%nonassoc /*8*/ PROJ
%right /*9*/ NOT RPAREN BITNOT FLOOD
%right /*10*/ LBRACKET

%start prog

/* FIXME: the RPAREN thing is a hack to make casting work, and I'm not even sure it's correct
   Same with LBRACKET. */

%%

ty :
	TINT single_poly
	| TINT
	| TBOOL
	| QID
	| AUTO
	| cid
	| cid poly
	| cid ty_poly
	| EVENT /*1R*/
	| VOID
	| GROUP
	| MEMOP poly
	| LBRACE record_def RBRACE
	| ty LBRACKET /*10R*/ size RBRACKET
	| BITSTRING
	;

tys :
	ty
	| tys COMMA ty
	;

cid :
	ID /*1R*/
	| cid DOT ID /*1R*/
	;

size :
	NUM
	| ID /*1R*/
	| QID
	| AUTO
	| size PLUS /*4L*/ size
	| LPAREN RPAREN /*9R*/
	| LPAREN sizes RPAREN /*9R*/
	;

sizes :
	size
	| sizes COMMA size
	;

polys :
	size
	| polys COMMA size
	;

poly :
	LESS /*3N*/ polys MORE /*3N*/
	;

single_poly :
	LESS /*3N*/ size MORE /*3N*/
	;

ty_or_empty_tuple :
	ty
	| LPAREN RPAREN /*9R*/
	;

ty_polys :
	ty_or_empty_tuple
	| ty_polys COMMA ty_or_empty_tuple
	;

ty_poly :
	LSHIFT /*6L*/ ty_polys RSHIFT /*6L*/
	;

paren_args :
	LPAREN RPAREN /*9R*/
	| LPAREN args RPAREN /*9R*/
	;

binop :
	exp PLUS /*4L*/ exp
	| exp SUB /*4L*/ exp
	| exp SATPLUS /*4L*/ exp
	| exp SATSUB /*4L*/ exp
	| exp LESS /*3N*/ exp
	| exp MORE /*3N*/ exp
	| exp LEQ /*3N*/ exp
	| exp GEQ /*3N*/ exp
	| exp AND /*2L*/ exp
	| exp OR /*2L*/ exp
	| exp EQ /*3N*/ exp
	| exp NEQ /*3N*/ exp
	| exp BITXOR /*6L*/ exp
	| exp BITAND /*6L*/ exp
	| exp PIPE /*6L*/ exp
	| exp CONCAT /*5L*/ exp
	| exp LSHIFT /*6L*/ exp
	| exp RSHIFT /*6L*/ exp
	| exp PATAND /*7L*/ exp
	// unordered call. put here to avoid conflict with exp LESS exp
	| exp LESS /*3N*/ UNORDERED MORE /*3N*/ paren_args
	;

pattern :
	cid
	| NUM
	| BITPAT
	| cid paramsdef
	| WILDCARD
	;

patterns :
	pattern
	| patterns COMMA pattern
	;

exp :
	BITPAT
	| WILDCARD
	| cid
	| NUMWITDH
	| NUM
	| TRUE
	| FALSE
	| cid paren_args
	//| cid LESS UNORDERED MORE paren_args
	| binop
	| NOT /*9R*/ exp
	| SUB /*4L*/ exp
	| BITNOT /*9R*/ exp
	| HASH single_poly LPAREN args RPAREN /*9R*/
	| PATCAST LPAREN exp RPAREN /*9R*/
	| LPAREN TINT single_poly RPAREN /*9R*/ exp
	| exp PROJ /*8N*/ ID /*1R*/
	 //| LPAREN exp RPAREN
	| exp LBRACKET /*10R*/ size COLON size RBRACKET
	| LBRACE record_entries RBRACE
	| LBRACE exp WITH record_entries RBRACE
	| exp LBRACKET /*10R*/ size RBRACKET
	| LBRACKET /*10R*/ exp FOR ID /*1R*/ LESS /*3N*/ size RBRACKET
	| LBRACKET /*10R*/ exps RBRACKET
	| SIZECAST LPAREN size RPAREN /*9R*/
	| SIZECAST single_poly LPAREN size RPAREN /*9R*/
	| FLOOD /*9R*/ exp
	| LBRACE args RBRACE
	| TABLE_CREATE LESS /*3N*/ ty MORE /*3N*/ LPAREN exp COMMA exp COMMA exp RPAREN /*9R*/
	| TABLE_MATCH LPAREN exp COMMA exp COMMA exp RPAREN /*9R*/
	| paren_exp
	;

// an expression with a parenthesis is a tuple, unless its a single-element tuple, in which case its just the element.
// note that user-written tuples may not appear in the AST, so any parsed tuple must be unpacked with
// SyntaxUtils.unpack_tuple before calling a AST node constructor
paren_exp :
	LPAREN args RPAREN /*9R*/
	| LPAREN RPAREN /*9R*/
	;

exps :
	exp
	//| exp SEMI
	| exps SEMI exp
	;

record_entry :
	ID /*1R*/ ASSIGN exp
	;

record_entries :
	record_entry
	| record_entry SEMI
	| record_entry SEMI record_entries
	;

args :
	exp
	| args COMMA exp
	;

opt_args :
	LPAREN args RPAREN /*9R*/
	| LPAREN RPAREN /*9R*/
	;

paramsdef :
	LPAREN RPAREN /*9R*/
	| LPAREN params RPAREN /*9R*/
	;

event_sort :
	EVENT /*1R*/
	| PACKET EVENT /*1R*/
	;

speclist :
	cid LESS /*3N*/ cid
	| cid LEQ /*3N*/ cid
	| speclist cid LESS /*3N*/
	| speclist cid LEQ /*3N*/
	;

constr :
	speclist
	| END cid
	;

constrs :
	constr
	| constrs SEMI constr
	;

constr_list :
	LBRACKET /*10R*/ RBRACKET
	| LBRACKET /*10R*/ constrs RBRACKET
	;

interface_spec :
	FUN ty ID /*1R*/ paramsdef SEMI
	| FUN ty ID /*1R*/ paramsdef constr_list SEMI
	| CONSTR ty ID /*1R*/ paramsdef SEMI
	| ty ID /*1R*/ SEMI
	| EVENT /*1R*/ ID /*1R*/ paramsdef SEMI
	| EVENT /*1R*/ ID /*1R*/ paramsdef constr_list SEMI
	| SIZE ID /*1R*/ SEMI
	| MODULE ID /*1R*/ COLON LBRACE interface RBRACE
	| GLOBAL TYPE tyname_def ASSIGN ty
	| GLOBAL TYPE tyname_def SEMI
	| TYPE tyname_def ASSIGN ty
	| TYPE tyname_def SEMI
	;

interface :
	interface_spec
	| interface_spec interface
	;

event_decl :
	event_sort ID /*1R*/ paramsdef
	| event_sort ID /*1R*/ paramsdef constr_list
	| event_sort ID /*1R*/ ANNOT paramsdef
	| event_sort ID /*1R*/ ANNOT paramsdef constr_list
	;

handle_sort :
	HANDLE
	| CONTROL HANDLE
	| EGRESS HANDLE
	;

tyname_def :
	ID /*1R*/
	| ID /*1R*/ poly
	;

ty_args :
	LPAREN tys RPAREN /*9R*/
	| LPAREN RPAREN /*9R*/
	| ty
	;

dt_table :
	ID /*1R*/ ASSIGN LBRACE KEY_TYPE ty_args ARG_TYPE ty_args RET_TYPE ty RBRACE
	;

// an expression that can appear as the lhs of an assign in the parser
lexp :
	cid
	| lexp PROJ /*8N*/ ID /*1R*/
	;

parser_action :
	// skip(int, payload);
	SKIP LPAREN ty COMMA exp RPAREN /*9R*/ SEMI
	// int foo = read(payload);
	| ty ID /*1R*/ ASSIGN READ LPAREN exp RPAREN /*9R*/ SEMI
	// int foo = hash...(checksum, ...)...;
	| ty ID /*1R*/ ASSIGN exp SEMI
	// ??? not sure what this is for. Don't assigns mess slot analysis up?
	| lexp ASSIGN exp SEMI
	;

parser_branch :
	PIPE /*6L*/ pattern ARROW LBRACE parser_block RBRACE
	;

parser_branches :
	parser_branch
	| parser_branches parser_branch
	;

parser_step :
	GENERATE exp SEMI
	| cid paren_args SEMI
	| MATCH exp WITH parser_branches
	| DROP SEMI
	;

parser_block :
	parser_step
	| parser_action parser_block
	;

decl :
	CONST ty ID /*1R*/ ASSIGN exp SEMI
	| EXTERN ty ID /*1R*/ SEMI
	| EXTERN ID /*1R*/ paramsdef SEMI
	| SYMBOLIC ty ID /*1R*/ SEMI
	| event_decl SEMI
	| event_decl LBRACE statement RBRACE
	| handle_sort ID /*1R*/ paramsdef LBRACE statement RBRACE
	| FUN ty ID /*1R*/ paramsdef LBRACE statement RBRACE
	| FUN ty ID /*1R*/ paramsdef constr_list LBRACE statement RBRACE
	| MAIN decl
	| ACTION_CONSTR ID /*1R*/ paramsdef ASSIGN LBRACE RETURN ACTION ty ID /*1R*/ paramsdef LBRACE statement RBRACE SEMI RBRACE SEMI
	| ACTION ty ID /*1R*/ paramsdef paramsdef LBRACE statement RBRACE
	| MEMOP ID /*1R*/ paramsdef LBRACE statement RBRACE
	| SYMBOLIC SIZE ID /*1R*/ SEMI
	| SIZE ID /*1R*/ ASSIGN size SEMI
	| MODULE ID /*1R*/ LBRACE decls RBRACE
	| MODULE ID /*1R*/ COLON LBRACE interface RBRACE LBRACE decls RBRACE
	| MODULE ID /*1R*/ ASSIGN cid IF exp ELSE cid SEMI
	| TYPE tyname_def ASSIGN ty
	| CONSTR ty ID /*1R*/ paramsdef ASSIGN exp SEMI
	| GLOBAL ty ID /*1R*/ ASSIGN exp SEMI
	| TABLE_TYPE dt_table
	| PARSER ID /*1R*/ paramsdef LBRACE parser_block RBRACE
	;

decls :
	decl
	| decls decl
	;

param :
	ty ID /*1R*/
	;

params :
	param
	| params COMMA param
	;

record_def :
	param SEMI
	| record_def param SEMI
	;

statement :
	statement0
	| statement statement0
	;

statement0 :
	matched
	| unmatched
	| statement1
	;

matched :
	IF LPAREN exp RPAREN /*9R*/ LBRACE statement RBRACE ELSE LBRACE statement RBRACE
	;

unmatched :
	IF LPAREN exp RPAREN /*9R*/ LBRACE statement RBRACE ELSE unmatched
	| IF LPAREN exp RPAREN /*9R*/ LBRACE statement RBRACE
	;

branch :
	PIPE /*6L*/ patterns ARROW LBRACE statement RBRACE
	;

branches :
	branch
	| branches branch
	;

table_entry :
	/* an entry with no priority */
	opt_args ARROW ID /*1R*/ opt_args
	/* an entry with a priority */
	| LBRACKET /*10R*/ NUM RBRACKET opt_args ARROW ID /*1R*/ opt_args
	;

table_entries :
	table_entry
	| table_entries SEMI table_entry
	;

// TODO: remove multiargs for match statements -- no need to suport match x, y, ... with syntax (no parens for multiple args)
multiargs :
	exp COMMA args
	;

statement1 :
	SKIP SEMI
	| ty ID /*1R*/ ASSIGN exp SEMI
	| NOINLINE ty ID /*1R*/ ASSIGN exp SEMI
	| ID /*1R*/ ASSIGN exp SEMI
	| NOINLINE ID /*1R*/ ASSIGN exp SEMI
	| RETURN SEMI
	| RETURN exp SEMI
	| GENERATE exp SEMI
	| SGENERATE LPAREN exp COMMA exp RPAREN /*9R*/ SEMI
	| MGENERATE LPAREN exp COMMA exp RPAREN /*9R*/ SEMI
	| PGENERATE LPAREN exp COMMA exp RPAREN /*9R*/ SEMI
	| cid LESS /*3N*/ UNORDERED MORE /*3N*/ paren_args SEMI
	| cid paren_args SEMI
	| MATCH exp WITH branches
	| MATCH multiargs WITH branches
	| PRINTF LPAREN STRING RPAREN /*9R*/ SEMI
	| PRINTF LPAREN STRING COMMA args RPAREN /*9R*/ SEMI
	| FOR LPAREN ID /*1R*/ LESS /*3N*/ size RPAREN /*9R*/ LBRACE statement RBRACE
	| TABLE_MULTI_INSTALL LPAREN exp COMMA LBRACE table_entries RBRACE RPAREN /*9R*/ SEMI
	| TABLE_INSTALL LPAREN exp COMMA LBRACE table_entries RBRACE RPAREN /*9R*/ SEMI
	;

includes :
	/*empty*/
	| INCLUDE STRING
	| includes INCLUDE STRING
	;

prog :
	///*empty*/
	/*|*/ includes decls //EOF
	| decls //EOF
	;

%%

num  [0-9]+|"0b"[01]+|"0x"[0-9a-fA-F]+
width  "w"{num}
bitpat  "0b"[01*]+
id  [a-zA-Z_][a-zA-Z_0-9]*
wspace  [ \t]
/* str = '"'['a'-'z' 'A'-'Z' '_' '0'-'9' '~' '!' '@' '#' '$' '%' '^' '&' '|' ':' '?' '>' '<' '[' ']' '=' '-' '.' ' ' '\\' ',']*'"' */
str  \"(\\.|[^"\r\n\\])*\"
filename  \"([a-zA-Z0-9_\\/.-])+\"

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"include"         INCLUDE
"false"           FALSE
"true"            TRUE
"if"              IF
"else"            ELSE
"int"             TINT
"bool"            TBOOL
"event"           EVENT
"generate"        GENERATE
"generate_switch" SGENERATE
"generate_ports"  MGENERATE
"generate_port"   PGENERATE
"printf"          PRINTF
"handle"	        HANDLE
"fun"             FUN
"memop" MEMOP
"memop"           MEMOP
"return"          RETURN
"size"            SIZE
"global"          GLOBAL
"unordered"       UNORDERED
"const"           CONST
"extern"          EXTERN
"void"            VOID
"hash"            HASH
"auto"            AUTO
"group"           GROUP
"control"         CONTROL
"@egress"         EGRESS
"@"{num}      ANNOT
"@main"           MAIN
"packet"          PACKET
"match"           MATCH
"with"            WITH
"type"            TYPE
"noinline"        NOINLINE

"table_type"              TABLE_TYPE
"key_type:"               KEY_TYPE
"arg_type:"               ARG_TYPE
"ret_type:"               RET_TYPE
"action_constr"           ACTION_CONSTR
"action"                  ACTION
"table_create"            TABLE_CREATE
"table_match"             TABLE_MATCH
"table_install"           TABLE_INSTALL
"table_multi_install"     TABLE_MULTI_INSTALL

"parser"          PARSER
"read"            READ
"skip"            SKIP
"drop"            DROP
"bitstring"       BITSTRING

"constructor"     CONSTR
"constr"          CONSTR
"module"          MODULE
"end"             END
"for"             FOR
"size_to_int"     SIZECAST
"symbolic"        SYMBOLIC
"flood"           FLOOD
"int_to_pat"      PATCAST
"#"               PROJ
"|+|"             SATPLUS
"+"               PLUS
"|-|"             SATSUB
"-"               SUB
"!"               NOT
"&&"              AND
"||"              OR
"&"               BITAND
"=="              EQ
"!="              NEQ
"<<"              LSHIFT
">>"              RSHIFT
"<="              LEQ
">="              GEQ
"<"               LESS
">"               MORE
"^^"              BITXOR
"^"               CONCAT
"~"               BITNOT
";"               SEMI
":"               COLON
"("               LPAREN
")"               RPAREN
"="               ASSIGN
"{"               LBRACE
"}"               RBRACE
"["               LBRACKET
"]"               RBRACKET
","               COMMA
"."               DOT
"|"               PIPE
"->"              ARROW
"&&&"             PATAND
"_"               WILDCARD

{num}{width}    NUMWITDH
{num}           NUM
{bitpat}        BITPAT

{str}          STRING

"'"{id}      QID
{id}           ID

%%
