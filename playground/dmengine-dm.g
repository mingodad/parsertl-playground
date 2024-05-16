//From: https://github.com/ortelius/ortelius/blob/8ac44fd0122755e23fa817d03aa2da04b9403932/dmengine/dmapi/dm.ypp
/* Deployment Manager Scripting Language.  */

/*Tokens*/
//%token CLMI
//%token CLPL
//%token DOLBR
%token DOLIDENT
//%token GE
%token IDENT
//%token LE
//%token MAP
//%token ME
//%token NE
%token NOWS
%token NUM
//%token PE
//%token REDIR
//%token START_ACTION
//%token START_EXPR
//%token START_STMTLIST
%token STR
%token STR2
%token T_ACTION
%token T_BOOL
%token T_BREAK
%token T_CASE
%token T_CATCH
%token T_CONTINUE
%token T_DECR
%token T_DEFAULT
//%token TE
%token T_ECHO
%token T_ELSE
%token T_EVAL
%token T_FINALLY
%token T_FOR
%token T_FOREACH
%token T_FUNC
%token T_IF
%token T_IN
%token T_INCR
%token T_ITERATE
%token T_NULL
%token T_PARALLEL
%token T_POST
%token T_PRE
%token T_PSLOOP
%token T_RETURN
%token T_SEQUENTIAL
%token T_SET
%token T_SWITCH
%token T_TRY
%token T_USING
%token T_WHILE

%left /*1*/ '&' '|'
%left /*2*/ "!=" ">=" "<=" '=' '>' '<' '~'
%left /*3*/ NOWS '-' '+'
%left /*4*/ '*' '/' '%'
%left /*5*/ '[' '.'
%left /*6*/ NEG '!'

%start input

%%

input :
	//START_ACTION actnlist
	//| START_EXPR exp
	//| START_STMTLIST stmtlist
	actnlist
	| stmtlist
	;

actnlist :
	actn
	| actnlist actn
	;

actn :
	T_ACTION IDENT block
	| T_FUNC IDENT '(' opt_fnarglist ')' block
	;

opt_fnarglist :
	/*empty*/
	| fnarglist
	;

fnarglist :
	IDENT
	| fnarglist ',' IDENT
	;

block :
	';'
	| '{' '}'
	| '{' stmtlist '}'
	;

stmtlist :
	stmt
	| stmtlist stmt
	;

stmt :
	T_IF '(' exp ')' block
	| T_IF '(' exp ')' block T_ELSE block
	| T_WHILE '(' exp ')' block
	| T_FOR '(' namelist '=' /*2L*/ exp ';' exp ';' namelist '=' /*2L*/ exp ')' block
	| T_FOREACH '(' arg ')' block
	| T_FOREACH IDENT T_IN exp block
	| T_ITERATE '(' arg ')' block
	| T_ITERATE IDENT T_IN exp block
	| T_SET opt_setopt namelist '=' /*2L*/ exp ';'
	| T_SET opt_setopt namelist "+=" exp ';'
	| T_SET opt_setopt namelist "-=" exp ';'
	| T_SET opt_setopt namelist "*=" exp ';'
	| T_INCR namelist ';'
	| T_DECR namelist ';'
	| T_ECHO exp opt_stream ';'
	| T_TRY block T_CATCH '(' IDENT ')' block opt_finally
	| T_SWITCH '(' exp ')' '{' caselist '}'
	| T_BREAK ';'
	| T_CONTINUE ';'
	| T_PSLOOP block
	| T_PARALLEL block
	| T_SEQUENTIAL block
	| T_USING IDENT simpexp block
	| T_RETURN ';'
	| T_RETURN exp ';'
	| T_EVAL '(' exp ')' ';'
	| IDENT block
	| IDENT '(' arglist ')' block
	| IDENT '(' arglist ')' '{' T_PRE block '}'
	| IDENT '(' arglist ')' '{' T_POST block '}'
	| IDENT '(' arglist ')' '{' T_PRE block T_POST block '}'
	| IDENT '(' opt_explist ')' ';'
	| namelist '.' /*5L*/ IDENT '(' opt_explist ')' ';'
	;

opt_setopt :
	/*empty*/
	| opt_setopt '-' /*3L*/ IDENT
	;

opt_stream :
	/*empty*/
	| ">>" '$' IDENT
	;

opt_finally :
	/*empty*/
	| T_FINALLY block
	;

caselist :
	caseblock
	| caselist caseblock
	;

caseblock :
	T_CASE exp ':' stmtlist
	| T_DEFAULT ':' stmtlist
	;

arglist :
	arg
	| arglist ',' arg
	;

arg :
	IDENT ':' exp
	;

arrayinit :
	arrayele
	| arrayinit ',' arrayele
	;

arrayele :
	simpexp "=>" exp
	;

listinit :
	listele
	| listinit ',' listele
	;

listele :
	exp
	;

jsonobjinit :
	jsonobjele
	| jsonobjinit ',' jsonobjele
	;

jsonobjele :
	STR2 ':' NUM
	| STR2 ':' STR2
	| STR2 ':' T_BOOL
	| STR2 ':' T_NULL
	| STR2 ':' '{' '}'
	| STR2 ':' '{' jsonobjinit '}'
	| STR2 ':' '[' /*5L*/ jsonlistinit ']'
	| STR2 ':' '[' /*5L*/ ']'
	;

jsonlistinit :
	jsonlistele
	| jsonlistinit ',' jsonlistele
	;

jsonlistele :
	exp
	;

exp :
	simpexp
	| '{' '}'
	| '{' arrayinit '}'
	| '{' listinit '}'
	| '{' jsonobjinit '}'
	| '[' /*5L*/ ']'
	| '[' /*5L*/ jsonlistinit ']'
	;

simpexp :
	T_BOOL
	| T_NULL
	| NUM
	| STR
	| STR2
	| '$' IDENT
	| DOLIDENT
	| "${" namelist '}'
	| "${" namelist ":+" exp '}'
	| "${" namelist ":-" exp '}'
	| exp NOWS /*3L*/ exp
	| exp '+' /*3L*/ exp
	| exp '-' /*3L*/ exp
	| exp '*' /*4L*/ exp
	| exp '/' /*4L*/ exp
	| exp '%' /*4L*/ exp
	| exp '&' /*1L*/ exp
	| exp '|' /*1L*/ exp
	| '-' /*3L*/ exp %prec NEG /*6L*/
	| '!' /*6L*/ exp %prec NEG /*6L*/
	| '(' exp ')'
	| exp '=' /*2L*/ exp
	| exp "!=" /*2L*/ exp
	| exp '>' /*2L*/ exp
	| exp ">=" /*2L*/ exp
	| exp '<' /*2L*/ exp
	| exp "<=" /*2L*/ exp
	| exp '~' /*2L*/ exp
	| IDENT '(' opt_explist ')'
	| exp '[' /*5L*/ exp ']'
	;

name :
	IDENT
	| '$' IDENT
	| DOLIDENT
	| "${" namelist '}'
	;

namelist :
	name
	| namelist NOWS /*3L*/ name
	| namelist '[' /*5L*/ exp ']'
	| namelist '.' /*5L*/ name
	| namelist '.' /*5L*/ IDENT '(' opt_explist ')'
	;

opt_explist :
	/*empty*/
	| explist
	;

explist :
	exp
	| explist ',' exp
	;

%%

str_dq "@"?\"(\\.|[^"\r\n\\])*\"
str_sq "@"?'(\\.|[^'\r\n\\])*'
ident [A-Za-z_][A-Za-z0-9_]*

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"~"	'~'
"<"|"-gt"	'<'
"="|"-eq"	'='
">"|"-lt"	'>'
"|"|"-o"	'|'
"-"	'-'
","	','
";"	';'
":"	':'
"!"	'!'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"$"	'$'
"*"	'*'
"&"|"-a"	'&'
"%"	'%'
"+"	'+'
"<="|"-le"	"<="
"=>"	"=>"
">="|"-ge"	">="
">>"	">>"
"-="	"-="
":-"	":-"
":+"	":+"
"!="|"-ne"	"!="
"${"	"${"
"*="	"*="
"+="	"+="

//START_ACTION	START_ACTION
//START_EXPR	START_EXPR
//START_STMTLIST	START_STMTLIST
action	T_ACTION
true|false	T_BOOL
break	T_BREAK
case	T_CASE
catch	T_CATCH
continue	T_CONTINUE
decr	T_DECR
default	T_DEFAULT
echo	T_ECHO
else	T_ELSE
eval	T_EVAL
finally	T_FINALLY
for	T_FOR
foreach	T_FOREACH
function	T_FUNC
if	T_IF
in	T_IN
incr	T_INCR
iterate	T_ITERATE
null	T_NULL
parallel	T_PARALLEL
post	T_POST
pre	T_PRE
psloop	T_PSLOOP
return	T_RETURN
sequential	T_SEQUENTIAL
set	T_SET
switch	T_SWITCH
try	T_TRY
using	T_USING
while	T_WHILE

{str_dq}(\s*{str_dq})*	STR
{str_sq}(\s*{str_sq})*	STR2

NOWS	NOWS
[0-9]+("."[0-9]+)?	NUM
[?$!]	DOLIDENT
{ident}	IDENT

%%
