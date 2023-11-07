//From: https://github.com/fsprojects/FsLexYacc/blob/70abefd5fc21e7897b60deff0b4212b652e82353/src/FsYacc.Core/fsyaccpars.fsy
/* (c) Microsoft Corporation 2005-2008.  */
/*Tokens*/
%token IDENT
%token HEADER
%token CODE
%token BAR
%token PERCENT_PERCENT
%token START
%token LEFT
%token RIGHT
%token NONASSOC
//%token LESS
//%token GREATER
%token COLON
%token PREC
%token SEMI
//%token EOF
%token ERROR
%token TYPE
%token TOKEN

%left /*1*/ BAR

%start spec

%%

spec :
	headeropt decls PERCENT_PERCENT rules
	;

headeropt :
	/*empty*/
	| HEADER
	;

decls :
	/*empty*/
	| decls decl
	;

decl :
	TOKEN idents
	| TYPE idents
	| START idents
	| LEFT idents
	| RIGHT idents
	| NONASSOC idents
	;

idents :
	idents IDENT
	| /*empty*/
	;

rules :
	rules rule
	| rule
	;

rule :
	IDENT COLON optbar clauses optsemi
	;

optbar :
	/*empty*/
	| BAR /*1L*/
	;

optsemi :
	/*empty*/
	| SEMI
	;

clauses :
	clauses BAR /*1L*/  clause
	| clause
	;

clause :
	syms optprec CODE
	;

syms :
	IDENT syms
	| ERROR syms
	| /*empty*/
	;

optprec :
	/*empty*/
	| PREC IDENT
	;

%%

%x code header fs_type_token fs_type

letter   [A-Za-z]
digit   [0-9]
whitespace   [ \t]
newline   (\n|\r\n)
ident_start_char   {letter}
ident_char   ({ident_start_char}|{digit}|['_])
ident   {ident_start_char}{ident_char}*

string	\"(\\.|[^"\n\r\\])*\"

%%

"%{"<header>
<header> {
	"%}"<INITIAL>	HEADER
	{string}<.>
	\n|.<.>
}
"%%"  PERCENT_PERCENT
"%token"{whitespace}*"<"<>fs_type_token>
<fs_type_token> {
  "<"<>fs_type_token>
  ">"<<> TOKEN
  [^<>]<.>
}
"%token"  TOKEN
"%start" START
"%prec" PREC
"%type"{whitespace}*"<"<>fs_type>
<fs_type> {
  "<"<>fs_type>
  ">"<<> TYPE
  [^<>]<.>
}
"%left"  LEFT
"%right"  RIGHT
"%nonassoc"  NONASSOC
"error"  ERROR
//"<"  LESS
//">"  GREATER
";"  SEMI
"{"<>code>
<code> {
	"{"<>code>
	"}"<<>	CODE
	{string}<.>
	\n|.<.>
}
{whitespace}+  skip()
{newline} skip()
{ident}  IDENT
"|"  BAR
"/*"(?s:.)*?"*/"	skip()
"//".*	skip()
":"  COLON

%%
