//From: https://github.com/katef/libfsm/blob/fdd18f40a70b9ecf04d733bed64f28971f7a2b95/src/lx/parser.sid
/*
 * Copyright 2008-2017 Katherine Flavel
 *
 * See LICENCE for the full copyright terms.
 */

%token AND
%token BANG
%token BIND
%token CHAR
%token CLOSE
%token COMMA
%token CROSS
%token DASH
%token DOT
%token ESC
%token HAT
%token HEX
%token IDENT
%token LPAREN
%token MAP
%token OCT
%token OPEN
%token PIPE
%token QMARK
%token RE
%token RPAREN
%token SEMI
%token STAR
%token STR
%token TILDE
%token TO
%token TOKEN

%%

lx :
	list_of_things //EOF
	;

list_of_things :
	thing
	| list_of_things thing
	;

thing :
	token_thing
	| bind_thing
	| zone_thing
	| oneway_thing
	;

token_thing :
	token_mapping SEMI
	;

token_mapping :
	alt_expr
	| alt_expr MAP TOKEN
	;

alt_expr :
	and_expr
	| alt_expr PIPE and_expr
	;

and_expr :
	sub_expr
	| and_expr AND sub_expr
	;

sub_expr :
	cat_expr
	| sub_expr DASH cat_expr
	;

cat_expr :
	dot_expr
	| cat_expr dot_expr
	;

dot_expr :
	prefix_expr
	| dot_expr DOT prefix_expr
	;

prefix_expr :
	postfix_expr
	| TILDE prefix_expr
	| BANG prefix_expr
	| HAT prefix_expr
	;

postfix_expr :
	primary_expr
	| postfix_expr STAR
	| postfix_expr CROSS
	| postfix_expr QMARK
	;

primary_expr :
	pattern
	| LPAREN alt_expr RPAREN
	;

pattern :
	IDENT
	| TOKEN
	| body STR
	| body RE
	;

body :
	/*empty*/
	| body (ESC
	| OCT
	| HEX
	| CHAR)
	;

bind_thing :
	IDENT BIND alt_expr SEMI
	;

zone_thing :
	list_of_zone_mappings TO list_of_zone_mappings (SEMI
	| compund_things)
	;

list_of_zone_mappings :
	token_mapping
	| list_of_zone_mappings COMMA token_mapping
	;

oneway_thing :
	token_mapping compund_things
	;

compund_things :
    OPEN list_of_things CLOSE
    ;

%%

ident [A-Za-z_][A-Za-z0-9_]*

%%

[ \t\r\n]+  skip()
"#".*   skip()

"="	BIND
";"	SEMI
".."	TO
"->"	MAP

"{"	OPEN
"}"	CLOSE
"("	LPAREN
")"	RPAREN

// regexp operators
"*"	STAR
"+"	CROSS
"?"	QMARK

// prefix operators
"~"	TILDE
"!"	BANG
"^"	HAT  // complete

// binary operators
"-"	DASH
"."	DOT
"|"	PIPE
"&"	AND // intersection

","	COMMA

\"(\\.|[^"\r\n\\])+\"	STR
'([^'\r\n])+'	STR
"/"[^/]+"/""i"?	RE
[^\\'"/&|^!~?+*(){}\[\]=#;,.-]    CHAR
\\.	ESC
\\[0-7]+	OCT
\\[A-Fa-f0-9]+	HEX

{ident}	IDENT
"$"{ident}	TOKEN


%%
