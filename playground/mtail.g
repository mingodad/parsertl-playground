//From: https://github.com/google/mtail/blob/15b573718cb4e8fe34f0d5378cfd6a230e5f92ef/internal/runtime/compiler/parser/parser.y
// Copyright 2011 Google Inc. All Rights Reserved.
// This file is available under the Apache license.

/*Tokens*/
%token INVALID
%token COUNTER
%token GAUGE
%token TIMER
%token TEXT
%token HISTOGRAM
%token AFTER
%token AS
%token BY
%token CONST
%token HIDDEN
%token DEF
%token DEL
%token NEXT
%token OTHERWISE
%token ELSE
%token STOP
%token BUCKETS
%token LIMIT
%token BUILTIN
%token REGEX
%token STRING
%token CAPREF
%token CAPREF_NAMED
%token ID
%token DECO
%token INTLITERAL
%token FLOATLITERAL
%token DURATIONLITERAL
%token INC
%token DEC
%token DIV
%token MOD
%token MUL
%token MINUS
%token PLUS
%token POW
%token SHL
%token SHR
%token LT
%token GT
%token LE
%token GE
%token EQ
%token NE
%token BITAND
%token XOR
%token BITOR
%token NOT
%token AND
%token OR
%token ADD_ASSIGN
%token ASSIGN
%token MATCH
%token NOT_MATCH
%token LCURLY
%token RCURLY
%token LPAREN
%token RPAREN
%token LSQUARE
%token RSQUARE
%token COMMA
%token NL


%start start

%%

start :
	stmt_list
	;

stmt_list :
	/*empty*/
	| stmt_list stmt
	;

stmt :
	conditional_stmt
	| expr_stmt
	| metric_declaration
	| decorator_declaration
	| decoration_stmt
	| delete_stmt
	| NEXT
	| CONST id_expr opt_nl concat_expr
	| STOP
	| INVALID
	;

conditional_stmt :
	conditional_expr compound_stmt ELSE compound_stmt
	| conditional_expr compound_stmt
	| mark_pos OTHERWISE compound_stmt
	;

conditional_expr :
	pattern_expr
	| pattern_expr logical_op opt_nl logical_expr
	| logical_expr
	;

expr_stmt :
	NL
	| expr NL
	;

compound_stmt :
	LCURLY stmt_list RCURLY
	;

expr :
	assign_expr
	| postfix_expr
	;

assign_expr :
	unary_expr ASSIGN opt_nl logical_expr
	| unary_expr ADD_ASSIGN opt_nl logical_expr
	;

logical_expr :
	bitwise_expr
	| match_expr
	| logical_expr logical_op opt_nl bitwise_expr
	| logical_expr logical_op opt_nl match_expr
	;

logical_op :
	AND
	| OR
	;

bitwise_expr :
	rel_expr
	| bitwise_expr bitwise_op opt_nl rel_expr
	;

bitwise_op :
	BITAND
	| BITOR
	| XOR
	;

rel_expr :
	shift_expr
	| rel_expr rel_op opt_nl shift_expr
	;

rel_op :
	LT
	| GT
	| LE
	| GE
	| EQ
	| NE
	;

shift_expr :
	additive_expr
	| shift_expr shift_op opt_nl additive_expr
	;

shift_op :
	SHL
	| SHR
	;

additive_expr :
	multiplicative_expr
	| additive_expr add_op opt_nl multiplicative_expr
	;

add_op :
	PLUS
	| MINUS
	;

match_expr :
	primary_expr match_op opt_nl pattern_expr
	| primary_expr match_op opt_nl primary_expr
	;

match_op :
	MATCH
	| NOT_MATCH
	;

pattern_expr :
	concat_expr
	;

concat_expr :
	regex_pattern
	| concat_expr PLUS opt_nl regex_pattern
	| concat_expr PLUS opt_nl id_expr
	;

multiplicative_expr :
	unary_expr
	| multiplicative_expr mul_op opt_nl unary_expr
	;

mul_op :
	MUL
	| DIV
	| MOD
	| POW
	;

unary_expr :
	postfix_expr
	| NOT unary_expr
	;

postfix_expr :
	primary_expr
	| postfix_expr postfix_op
	;

postfix_op :
	INC
	| DEC
	;

primary_expr :
	indexed_expr
	| builtin_expr
	| CAPREF
	| CAPREF_NAMED
	| STRING
	| LPAREN logical_expr RPAREN
	| INTLITERAL
	| FLOATLITERAL
	;

indexed_expr :
	id_expr
	| indexed_expr LSQUARE arg_expr_list RSQUARE
	;

id_expr :
	ID
	;

builtin_expr :
	mark_pos BUILTIN LPAREN RPAREN
	| mark_pos BUILTIN LPAREN arg_expr_list RPAREN
	;

arg_expr_list :
	arg_expr
	| arg_expr_list COMMA arg_expr
	;

arg_expr :
	logical_expr
	| pattern_expr
	;

regex_pattern :
	/*mark_pos DIV in_regex*/ REGEX /*DIV*/
	;

metric_declaration :
	metric_hide_spec metric_type_spec metric_decl_attr_spec
	;

metric_hide_spec :
	/*empty*/
	| HIDDEN
	;

metric_decl_attr_spec :
	metric_decl_attr_spec metric_by_spec
	| metric_decl_attr_spec metric_as_spec
	| metric_decl_attr_spec metric_buckets_spec
	| metric_decl_attr_spec metric_limit_spec
	| metric_name_spec
	;

metric_name_spec :
	ID
	| STRING
	;

metric_type_spec :
	COUNTER
	| GAUGE
	| TIMER
	| TEXT
	| HISTOGRAM
	;

metric_by_spec :
	BY metric_by_expr_list
	;

metric_by_expr_list :
	metric_by_expr
	| metric_by_expr_list COMMA metric_by_expr
	;

metric_by_expr :
	id_or_string
	;

metric_as_spec :
	AS STRING
	;

metric_limit_spec :
	LIMIT INTLITERAL
	;

metric_buckets_spec :
	BUCKETS metric_buckets_list
	;

metric_buckets_list :
	FLOATLITERAL
	| INTLITERAL
	| metric_buckets_list COMMA FLOATLITERAL
	| metric_buckets_list COMMA INTLITERAL
	;

decorator_declaration :
	mark_pos DEF ID compound_stmt
	;

decoration_stmt :
	mark_pos DECO compound_stmt
	;

delete_stmt :
	mark_pos DEL postfix_expr AFTER DURATIONLITERAL
	| mark_pos DEL postfix_expr
	;

id_or_string :
	ID
	| STRING
	;

mark_pos :
	/*empty*/
	;

//in_regex :
//	/*empty*/
//	;

opt_nl :
	/*empty*/
	| NL
	;

%%

digit	[0-9]
exp   ([Ee][+-]?{digit}+)
float_lit	{digit}+"."{digit}+|{digit}+{exp}
int_lit [0-9]+
base_id	[A-Za-z_][A-Za-z0-9_]*

%%

[ \t]+	skip()
"#".*\n?	skip()

"after"      AFTER
"as"         AS
"buckets"    BUCKETS
"by"         BY
"const"      CONST
"counter"    COUNTER
"def"        DEF
"del"        DEL
"else"       ELSE
"gauge"      GAUGE
"hidden"     HIDDEN
"histogram"  HISTOGRAM
"limit"      LIMIT
"next"       NEXT
"otherwise"  OTHERWISE
"stop"       STOP
"text"       TEXT
"timer"      TIMER

"+="	ADD_ASSIGN
"&&"	AND
"="	ASSIGN
"&"	BITAND
"|"	BITOR
"$"[0-9]+	CAPREF
"$"{base_id}	CAPREF_NAMED
","	COMMA
"--"	DEC
"@"\S+	DECO
"/"	DIV
"=="	EQ
">="	GE
">"	GT
"++"	INC
__INVALID__	INVALID
"{"	LCURLY
"<="	LE
"("	LPAREN
"["	LSQUARE
"<"	LT
"=~"	MATCH
"-"	MINUS
"%"	MOD
"*"	MUL
"!="	NE
"!"	NOT
"!~"	NOT_MATCH
"||"	OR
"+"	PLUS
"**"	POW
"}"	RCURLY
")"	RPAREN
"]"	RSQUARE
"<<"	SHL
">>"	SHR
"^"	XOR

"bool"|"float"|"getfilename"|"int"|"len"|"settime"|"string"|"strptime"|"strtol"|"subst"|"timestamp"|"tolower"	BUILTIN
\n	NL
\"(\\.|[^"\n\r\\])*\"	STRING
{int_lit}	INTLITERAL
"/"(\\.|[^/\n\r\\])*"/"	REGEX
({int_lit}|{float_lit})[smhd]	DURATIONLITERAL
{float_lit}	FLOATLITERAL
{base_id}	ID

%%
