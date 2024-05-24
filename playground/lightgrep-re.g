//From: https://github.com/strozfriedberg/lightgrep/blob/4f8695686700361feee1f06eaf7af2629aec7797/src/lib/re_grammar.ypp

/*Tokens*/
%token BYTE
%token CHAR
%token DIGIT
%token HYPHEN_HYPHEN
%token AMP_AMP
%token TILDE_TILDE
%token TEXT_START
%token TEXT_END
%token NON_WORD_BOUNDARY
%token KILL
%token WHACK_SMALL_B
//%token BAD
%token SET

%token EOL

%token '-'
%token '|'
%token '('
%token '?'
%token ')'
%token 'a'
%token 'i'
%token '*'
%token '+'
%token '{'
%token '}'
%token ','
%token '<'
%token '='
%token '!'
%token '^'
%token '$'
%token '.'
%token ']'
%token '['

%left /*1*/ LEAST
%left /*2*/ UNION
%left /*3*/ INTERSECT MINUS XOR
%nonassoc /*4*/ '-'

//%start regexp

%%

input :
    regexp
    | input EOL regexp
    ;

regexp :
	alt
	;

alt :
	concat
	| alt '|' concat
	| switch alt
	;

concat :
	rep
	| concat rep
	| concat KILL
	| concat switch
	;

switch :
	'(' '?' switches_on ')'
	| '(' '?' '-' /*4N*/ switches_off ')'
	| '(' '?' switches_on '-' /*4N*/ switches_off ')'
	;

switches_on :
	switch_on
	| switches_on switch_on
	;

switch_on :
	'a'
	| 'i'
	;

switches_off :
	switch_off
	| switches_off switch_off
	;

switch_off :
	'a'
	| 'i'
	;

rep :
	atom
	| atom '*' '?'
	| atom '+' '?'
	| atom '?' '?'
	| atom '{' number '}' '?'
	| atom '{' number ',' '}' '?'
	| atom '{' number ',' number '}' '?'
	| atom '*'
	| atom '+'
	| atom '?'
	| atom '{' number '}'
	| atom '{' number ',' '}'
	| atom '{' number ',' number '}'
	;

number :
	DIGIT
	| number DIGIT
	;

atom :
	'(' alt ')'
	//| '(' error
	| '(' '?' '<' '=' alt ')'
	| '(' '?' '<' '!' alt ')'
	| '(' '?' '=' alt ')'
	| '(' '?' '!' alt ')'
	| WHACK_SMALL_B
	| NON_WORD_BOUNDARY
	| TEXT_START
	| TEXT_END
	| '^'
	| '$'
	| literal
	;

literal :
	BYTE
	| character
	| '.'
	| HYPHEN_HYPHEN
	| AMP_AMP
	| TILDE_TILDE
	| charclass
	;

character :
	CHAR
	| DIGIT
	| 'a'
	| 'i'
	| ']'
	| '-' /*4N*/
	| '{'
	| '}'
	| ','
	| '<'
	| '='
	| '!'
	;

charclass :
	'[' cc_expr_pos ']'
	| '[' '^' cc_expr_neg ']'
	//| '[' cc_expr_pos error
	//| '[' error
	//| '[' '^' cc_expr_neg error
	//| '[' '^' error
	| '[' AMP_AMP
	| '[' cc_expr_pos AMP_AMP ']'
	| '[' cc_expr_pos AMP_AMP AMP_AMP
	| '[' HYPHEN_HYPHEN
	| '[' cc_expr_pos HYPHEN_HYPHEN ']'
	| '[' cc_expr_pos HYPHEN_HYPHEN HYPHEN_HYPHEN
	| '[' TILDE_TILDE
	| '[' cc_expr_pos TILDE_TILDE ']'
	| '[' cc_expr_pos TILDE_TILDE TILDE_TILDE
	| '[' '^' AMP_AMP
	| '[' '^' cc_expr_neg AMP_AMP ']'
	| '[' '^' cc_expr_neg AMP_AMP AMP_AMP
	| '[' '^' HYPHEN_HYPHEN
	| '[' '^' cc_expr_neg HYPHEN_HYPHEN ']'
	| '[' '^' cc_expr_neg HYPHEN_HYPHEN HYPHEN_HYPHEN
	| '[' '^' TILDE_TILDE
	| '[' '^' cc_expr_neg TILDE_TILDE ']'
	| '[' '^' cc_expr_neg TILDE_TILDE TILDE_TILDE
	| cc_named
	;

cc_expr_pos :
	cc_expr_pos cc_atom %prec UNION /*2L*/
	| cc_expr_pos AMP_AMP cc_atom %prec INTERSECT /*3L*/
	| cc_expr_pos HYPHEN_HYPHEN cc_atom %prec MINUS /*3L*/
	| cc_expr_pos TILDE_TILDE cc_atom %prec XOR /*3L*/
	| cc_char_first '-' /*4N*/ cc_char_not_first %prec '-' /*4N*/
	| cc_char_first '-' /*4N*/ charclass
	| BYTE '-' /*4N*/ BYTE %prec '-' /*4N*/
	| BYTE '-' /*4N*/ charclass
	| charclass
	| cc_char_first %prec LEAST /*1L*/
	| BYTE %prec LEAST /*1L*/
	;

cc_expr_neg :
	cc_expr_neg cc_atom %prec UNION /*2L*/
	| cc_expr_neg AMP_AMP cc_atom %prec INTERSECT /*3L*/
	| cc_expr_neg HYPHEN_HYPHEN cc_atom %prec MINUS /*3L*/
	| cc_expr_neg TILDE_TILDE cc_atom %prec XOR /*3L*/
	| cc_atom %prec LEAST /*1L*/
	;

cc_atom :
	cc_char_not_first '-' /*4N*/ cc_char_not_first %prec '-' /*4N*/
	| cc_char_not_first '-' /*4N*/ charclass
	| BYTE '-' /*4N*/ BYTE %prec '-' /*4N*/
	| BYTE '-' /*4N*/ charclass
	| charclass
	| cc_char_not_first %prec LEAST /*1L*/
	| '-' /*4N*/ %prec LEAST /*1L*/
	| BYTE %prec LEAST /*1L*/
	;

cc_char_first :
	']'
	| '-' /*4N*/
	| cc_char
	;

cc_char_not_first :
	'^'
	| cc_char
	;

cc_char :
	CHAR
	| DIGIT
	| 'a'
	| 'i'
	| '|'
	| '('
	| ')'
	| '?'
	| '+'
	| '*'
	| '.'
	| '{'
	| '}'
	| ','
	| '<'
	| '='
	| '!'
	| '$'
	| WHACK_SMALL_B
	;

cc_named :
	SET
	;

%%

%x MIUNS_RBRACK

%%

\n  EOL

"-"	'-'
"|"	'|'
"("	'('
"?"	'?'
")"	')'
"a"	'a'
"i"	'i'
"*"	'*'
"+"	'+'
"{"	'{'
"}"	'}'
","	','
"<"	'<'
"="	'='
"!"	'!'
"^"	'^'
"$"	'$'
"."	'.'
"]"	']'
"["	'['

"-]"<MIUNS_RBRACK>  reject()
<MIUNS_RBRACK>"-"<INITIAL>  CHAR

"\\z_"[0-9A-Fa-f]{2}"_"	BYTE
"\\x{"[[0-9A-Fa-f]*"}"	BYTE
"\\N{U+"[zx][0-9A-Fa-f]*"}"	BYTE
[0-9]	DIGIT
"--"	HYPHEN_HYPHEN
"&&"	AMP_AMP
"~~"	TILDE_TILDE
"\\A"	TEXT_START
"\\Z"	TEXT_END
"\\B"	NON_WORD_BOUNDARY
"\\K"	KILL
"\\b"	WHACK_SMALL_B
"\\"[dDsShHvVwW]	SET
// metacharacters as themselves
"\\"[|()?+*.\[\]^$\-{}&~<=!\\]	CHAR

.	CHAR

%%
