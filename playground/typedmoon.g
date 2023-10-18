%token Name
%token LiteralString
%token Numeral

%nonassoc NOARG
%nonassoc '('
%left "or"
%left "and"
%left '<' '>' "<=" ">=" "~=" "=="
%left '|'
%left '~'
%left '&'
%left "<<" ">>"
%right ".."
%left '+' '-'
%left '*' '/' "//" '%'
%left "not" '#'
%left "as"
%right '^'

%%

start :
	chunk /*EOF*/
	;

chunk :
	block
	;

block :
    /*empty*/
	| statlist retstatopt
	| retstat
	;

retstatopt :
	retstat
	| /*empty*/
	;

statlist :
	stat
	| statlist stat
	;

stat :
	';'
	| varlist '=' explist
	| functioncall
	| label
	| "break"
	| "goto" Name
	| "do" block "end"
	| "while" exp "do" block "end"
	| "repeat" block "until" exp
	| "if" exp "then" block elseif_zom else_zoo "end"
	| "for" Name '=' exp ',' exp forstep_zoo "do" block "end"
	| "for" namelist "in" explist "do" block "end"
	| "function" funcname funcbody
	| "local" attnamelist colontypelist_zoo eqexplist_zoo
	| "local" functiondecl
	| "local" recorddecl
	| "local" enumdecl
	| "local" "type" Name '=' newtype
	| "global" attnamelist ':' typelist eqexplist_zoo
	| "global" attnamelist '=' explist
	| "global" functiondecl
	| "global" recorddecl
	| "global" enumdecl
	| "global" "type" Name eqnewtype_zoo
	;

recorddecl :
    "record" Name recordbody
    ;

functiondecl :
    "function" Name funcbody
    ;

enumdecl :
    "enum" Name enumbody
    ;

eqnewtype_zoo :
	/*empty*/
	| '=' newtype
	;

eqexplist_zoo :
	/*empty*/
	| '=' explist
	;

colontypelist_zoo :
	/*empty*/
	| ':' typelist
	;

forstep_zoo:
	/*empty*/
	| ',' exp
	;

else_zoo:
	/*empty*/
	| "else" block
	;

elseif_zom :
	/*empty*/
	| elseif_zom "elseif" exp "then" block
	;

attnamelist :
	attname
	| attnamelist ',' attname
	;

attname :
	Name
	| Name attrib
	;

attrib :
	'<' Name '>'
	;

retstat :
	"return"
	| "return" ';'
	| "return" explist
	| "return" explist ';'
	;

label :
	"::" Name "::"
	;

funcname :
	Name dotname_zom colonname_zoo
	;

colonname_zoo:
	/*empty*/
	| ':' Name
	;

dotname_zom:
	/*empty*/
	| dotname_zom '.' Name
	;

varlist :
	var
	| varlist ',' var
	;

var :
	Name
	| prefixexp '[' exp ']'
	| prefixexp '.' Name
	;

namelist :
	Name
	| namelist ',' Name
	;

explist :
	exp
	| explist ',' exp
	;

exp :
	"nil"
	| "false"
	| "true"
	| Numeral
	| LiteralString
	| "..."
	| functiondef
	| prefixexp
	| tableconstructor
	| exp '+' exp
	| exp '-' exp
	| exp '*' exp
	| exp '/' exp
	| exp "//" exp
	| exp '^' exp
	| exp '%' exp
	| exp '&' exp
	| exp '~' exp
	| exp '|' exp
	| exp ">>" exp
	| exp "<<" exp
	| exp ".." exp
	| exp '<' exp
	| exp "<=" exp
	| exp '>' exp
	| exp ">=" exp
	| exp "==" exp
	| exp "~=" exp
	| exp "and" exp
	| exp "or" exp
	| '-' exp %prec "not"
	| "not" exp
	| '#' exp
	| '~' exp %prec "not"
	| exp "as" type
	| exp "as" '(' typelist ')'
	| Name "is" type
	;

prefixexp :
	var %prec NOARG
	| functioncall %prec NOARG
	| '(' exp ')'
	;

functioncall :
	prefixexp args
	| prefixexp ':' Name args
	;

args :
	'(' ')'
	| '(' explist ')'
	| tableconstructor
	| LiteralString
	;

functiondef :
	"function" funcbody
	;

funcbody :
	typeargs_zoo '(' parlist_zoo ')' colonretlist_zoo block "end"
	;

parlist_zoo :
	/*empty*/
	| parlist
	;

parlist :
	parnamelist
	| ellipsistype_opt
	| parnamelist ',' ellipsistype_opt
	;

ellipsistype_opt :
	"..." colontype_zoo
	;

tableconstructor :
	'{' '}'
	| '{' fieldlist '}'
	;

fieldlist :
	fieldlist_oom
	| fieldlist_oom fieldsep
	;

fieldlist_oom :
	field
	| fieldlist_oom fieldsep field
	;

field :
	'[' exp ']' '=' exp
	| Name colontype_zoo '=' exp
	| exp
	;

fieldsep :
	','
	| ';'
	;

colontype_zoo :
	/*empty*/
	| colontype
	;

colontype :
	':' type
	;

type :
	'(' type ')'
	| basetype orbasetype_zom
	;

orbasetype_zom:
	/*empty*/
	| orbasetype_zom '|' basetype
	;

basetype :
    "any"
	//| "string"
	| "boolean"
	| "nil"
	| "number"
	| '{' type typelist_zoo '}'
	| '{' type colontype '}'
	| functiontype
	| Name dotname_zom typeargs_zoo
	;

typelist_zoo :
	/*empty*/
	| typelist
	;

typelist :
	type
	| typelist ',' type
	;

retlist :
	'(' typelist ellipsis_zoo ')'
	| typelist ellipsis_zoo
	;

ellipsis_zoo :
	/*empty*/
	| "..."
	;

typeargs_zoo :
	/*empty*/
	| typeargs
	;

typeargs :
	'<' Name namelist_zoo '>'
	;

namelist_zoo :
	/*empty*/
	| namelist
	;

newtype :
	"record" recordbody
	| "enum" enumbody
	| type
	;

recordbody :
	typeargs_zoo recordentry_zom "end"
	;

recordentry_zom :
	/*empty*/
	| recordentry_zom recordentry
	;

recordentry :
	"userdata"
	| '{' type '}'
	| "type" Name '=' newtype
	| metamethod_zoo recordkey colontype
	| recorddecl
	| enumdecl
	;

metamethod_zoo :
	/*empty*/
	| "metamethod"
	;

recordkey :
	Name
	| '[' LiteralString ']'
	;

enumbody :
	LiteralString_zom "end"
	;

LiteralString_zom:
	/*empty*/
	| LiteralString_zom LiteralString
	;

functiontype :
	"function" typeargs_zoo '(' partypelist ')' colonretlist_zoo
	;

colonretlist_zoo :
	/*empty*/
	| ':' retlist
	;

partypelist :
	partype
	| partypelist ',' partype
	;

partype :
	type
	| Name colontype
	| "..." colontype
	;

parnamelist :
	parname
	| parnamelist ',' parname
	;

parname :
	Name
	| Name colontype
	;

%%

HexDigit	[0-9A-Fa-f]

HexEscape	"\\x"{HexDigit}{2}

UtfEscape	"\\u{"{HexDigit}+'}'

Digit	[0-9]

ExponentPart	[Ee][+-]?{Digit}+

DecimalEscape	"\\"{Digit}|"\\"{Digit}{2}| "\\"[0-2]{Digit}{2}

// World of Warcraft Lua additionally escapes |$#
EscapeSequence	"\\"[abfnrtvz"'|$#\\]|\\\r?\n|{DecimalEscape}|{HexEscape}|{UtfEscape}

INT	{Digit}+

HEX	0[Xx]{HexDigit}+

FLOAT	{Digit}+"."{Digit}*{ExponentPart}?|"."{Digit}+{ExponentPart}?|{Digit}+{ExponentPart}

%%

[\n\r\t ]+	skip()
"--".*	skip()

"^"	'^'
"~"	'~'
"<"	'<'
"="	'='
">"	'>'
"|"	'|'
"-"	'-'
","	','
";"	';'
":"	':'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"*"	'*'
"&"	'&'
"#"	'#'
"%"	'%'
"+"	'+'

"~="	"~="
"<<"	"<<"
"<="	"<="
"=="	"=="
">="	">="
">>"	">>"
"::"	"::"
"//"	"//"
"..."	"..."
".."	".."
"and"	"and"
"any"   "any"
"as"	"as"
"boolean"	"boolean"
"break"	"break"
"do"	"do"
"else"	"else"
"elseif"	"elseif"
"end"	"end"
"enum"	"enum"
"false"	"false"
"for"	"for"
"function"	"function"
"global"	"global"
"goto"	"goto"
"if"	"if"
"in"	"in"
"is"	"is"
"local"	"local"
"metamethod"	"metamethod"
"nil"	"nil"
"not"	"not"
"number"	"number"
"or"	"or"
"record"	"record"
"repeat"	"repeat"
"return"	"return"
//"string"	"string"
"then"	"then"
"true"	"true"
"type"	"type"
"until"	"until"
"userdata"	"userdata"
"while"	"while"


\"({EscapeSequence}|[^\\"])*\"	LiteralString

{HEX}	Numeral
{INT}	Numeral
{FLOAT}	Numeral

[A-Za-z_][A-Za-z_0-9]*	Name

%%

