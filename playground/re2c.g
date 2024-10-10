/*Tokens*/
%token TOKEN_CJUMP
%token TOKEN_CNEXT
%token TOKEN_CLIST
%token TOKEN_CSETUP
%token TOKEN_CZERO
%token TOKEN_CLOSESIZE
%token TOKEN_CODE
%token TOKEN_CONF
%token TOKEN_ID
%token TOKEN_FID
%token TOKEN_FID_END
%token TOKEN_LINE_INFO
%token TOKEN_REGEXP
%token TOKEN_BLOCK
//%token TOKEN_ERROR

%start spec

%%

spec :
	/*empty*/
	| spec TOKEN_BLOCK
	| spec TOKEN_CONF
	| spec def
	| spec rule
	| spec TOKEN_LINE_INFO
	;

def :
	name expr enddef
	| name expr '/'
	;

name :
	TOKEN_ID '='
	| TOKEN_FID
	;

enddef :
	';'
	| TOKEN_FID_END
	;

rule :
	trailexpr TOKEN_CODE
	| '*' TOKEN_CODE
	| '$' TOKEN_CODE
	| TOKEN_CLIST trailexpr ccode
	| TOKEN_CLIST '*' ccode
	| TOKEN_CLIST '$' ccode
	| TOKEN_CSETUP TOKEN_CODE
	| TOKEN_CZERO ccode
	;

ccode :
	TOKEN_CODE
	| TOKEN_CNEXT TOKEN_CODE
	| TOKEN_CJUMP
	;

trailexpr :
	expr
	| expr '/' expr
	;

expr :
	diff
	| expr '|' diff
	;

diff :
	term
	| diff '\\' term
	;

term :
	factor
	| factor term
	;

factor :
	primary
	| primary closes
	| primary TOKEN_CLOSESIZE
	;

closes :
	close
	| closes close
	;

close :
	'*'
	| '+'
	| '?'
	;

primary :
	TOKEN_REGEXP
	| TOKEN_ID
	| '(' expr ')'
	| '(' '!' expr ')'
	;

%%

%x re_class code

eof          "\000"
dstring      "\""([^\x00\n\\"]|"\\"[^\x00\n])*"\""
sstring      "'"([^\x00\n\\']|"\\"[^\x00\n])*"'"
letter       [a-zA-Z]
digit        [0-9]
lineno       [1-9]{digit}*
name         ({letter}|"_")({letter}|{digit}|"_")*
space        [ \t]
ws           ({space}|[\r\n])
eol          "\r"?"\n"
eoc          "*/"
ws_or_eoc    {ws}|{eoc}
linedir      {eol}{space}*"#"{space}*"line"{space}+
lineinf      {lineno}({space}+{dstring})?{eol}
esc          "\\"
hex_digit    [0-9a-fA-F]
esc_hex      {esc}("x"{hex_digit}{2}|[uX]{hex_digit}{4}|"U"{hex_digit}{8})
esc_oct      {esc}[0-3][0-7]{2} // max 1-byte octal value is '\377'
esc_simple   {esc}[abfnrtv\\]

%%

{ws}+	skip()
"//".*  skip()
"/*"(?s:.)*?"*/"	skip()
"="	'='
"|"	'|'
";"	';'
"!"	'!'
"?"	'?'
"/"	'/'
"("	'('
")"	')'
"$"	'$'
"*"	'*'
"\\"	'\\'
"+"	'+'

"!use:"{name}{space}*";"	TOKEN_BLOCK
":"?"=>"{space}*{name}	TOKEN_CJUMP
"<"	TOKEN_CLIST
"{"[0-9]+(","[0-9]*)?"}"	TOKEN_CLOSESIZE
TOKEN_CNEXT	TOKEN_CNEXT
"re2c:"	TOKEN_CONF
{space}*"!"{space}*	TOKEN_CSETUP
{space}*">"	TOKEN_CZERO
TOKEN_FID	TOKEN_FID
TOKEN_FID_END	TOKEN_FID_END
{linedir}	TOKEN_LINE_INFO
[@#]{name}	TOKEN_REGEXP
"."	TOKEN_REGEXP
{sstring}  TOKEN_REGEXP
{dstring}   TOKEN_REGEXP
"["<re_class>
"[^"<re_class>
<re_class>{
    "]"<INITIAL> TOKEN_REGEXP
    \\.<.>
    [^]\r\n\\]+<.>
}

"{"{ws}<>code>
<code>{
    "}"<<> TOKEN_CODE
    "{"<>code>
    {dstring}<.>
    {sstring}<.>
    [^{}]+<.>
}

"{"{name}"}"	TOKEN_ID
{name}  TOKEN_ID

%%
