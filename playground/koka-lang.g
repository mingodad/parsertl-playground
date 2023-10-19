/*
From: https://github.com/koka-lang/koka/blob/b3122869ac74bfb6f432f7e76eeb723b1f69a491/doc/spec/grammar/parser.y
** Notice that the parser on the playground do not automatically insert '{', '}' and ';'
** so you should explicitly add then for this parser to accept it.
*/
/* Copyright 2012-2021, Microsoft Research, Daan Leijen
   This is free software; you can redistribute it and/or modify it under the
   terms of the Apache License, Version 2.0.
*/
/* Use the "Yash" extension in vscode for nice syntax highlighting.
   Requires at least Bison 3+; you can get a version for windows from
   https://sourceforge.net/projects/winflexbison
   (use the "latest" zip package)
*/

/*Tokens*/
%token ID
%token CONID
%token OP
%token IDOP
%token QID
%token QCONID
%token QIDOP
%token WILDCARD
%token '('
%token ')'
%token '['
%token ']'
%token INT
%token FLOAT
%token STRING
%token CHAR
%token IF
%token THEN
%token ELSE
%token ELIF
%token WITH
%token IN
%token MATCH
%token RARROW
%token LARROW
%token FUN
%token FN
%token VAL
%token VAR
%token TYPE
%token STRUCT
%token EFFECT
%token ALIAS
%token CON
%token FORALL
//%token EXISTS
%token SOME
%token IMPORT
%token AS
%token MODULE
%token PUB
%token ABSTRACT
%token EXTERN
%token INFIX
%token INFIXL
%token INFIXR
//%token LEX_WHITE
//%token LEX_COMMENT
%token INSERTED_SEMI
//%token EXPR_SEMI
//%token LE
%token ASSIGN
%token DCOLON
//%token EXTEND
%token RETURN
%token HANDLER
%token HANDLE
%token NAMED
%token MASK
%token OVERRIDE
%token CTL
%token FINAL
%token RAW
//%token IFACE
//%token UNSAFE
//%token BREAK
//%token CONTINUE
%token ID_CO
%token ID_REC
%token ID_INLINE
%token ID_NOINLINE
%token ID_C
%token ID_CS
%token ID_JS
%token ID_FILE
%token ID_LINEAR
%token ID_OPEN
%token ID_EXTEND
%token ID_BEHIND
%token ID_VALUE
%token ID_REFERENCE
%token ID_SCOPED
%token ID_INITIALLY
%token ID_FINALLY
%token '{'
%token '.'
%token '>'
%token '<'
%token '|'
%token '}'
%token '='
%token ';'
%token ','
%token ':'
%token '!'
%token '~'
%token '^'

%precedence /*1*/ THEN
%precedence /*2*/ ELSE ELIF
%precedence /*3*/ RARROW
%precedence /*4*/ '(' '[' FN '{' '.'
%precedence /*5*/ OP ASSIGN '>' '<' '|'

%start program

%%

program :
	semis MODULE modulepath moduledecl
	| moduledecl
	;

moduledecl :
	'{' /*4P*/ semis modulebody '}' semis
	| semis modulebody
	;

modulebody :
	importdecl semis1 modulebody
	| declarations
	;

importdecl :
	pub IMPORT modulepath
	| pub IMPORT modulepath '=' modulepath
	;

modulepath :
	varid
	| qvarid
	;

pub :
	PUB
	| /*empty*/
	;

semis1 :
	semis1 semi
	| semi
	;

semis :
	semis semi
	| /*empty*/
	;

semi :
	';'
	| INSERTED_SEMI
	;

declarations :
	fixitydecl semis1 declarations
	| topdecls
	;

fixitydecl :
	pub fixity oplist1
	;

fixity :
	INFIX INT
	| INFIXR INT
	| INFIXL INT
	;

oplist1 :
	oplist1 ',' identifier
	| identifier
	;

topdecls :
	topdecls1
	| /*empty*/
	;

topdecls1 :
	topdecls1 topdecl semis1
	| topdecl semis1
	//| topdecls1 error semis1
	//| error semis1
	;

topdecl :
	pub puredecl
	| pub aliasdecl
	| pub externdecl
	| pub typedecl
	| ABSTRACT typedecl
	;

externdecl :
	ID_INLINE EXTERN funid externtype externbody
	| ID_NOINLINE EXTERN funid externtype externbody
	| EXTERN funid externtype externbody
	| EXTERN IMPORT externimpbody
	;

externtype :
	':' typescheme
	| typeparams '(' /*4P*/ parameters ')' annotres
	;

externbody :
	'{' /*4P*/ semis externstats1 '}'
	| '{' /*4P*/ semis '}'
	;

externstats1 :
	externstats1 externstat semis1
	| externstat semis1
	;

externstat :
	externtarget externinline STRING
	| externinline STRING
	;

externinline :
	ID_INLINE
	| /*empty*/
	;

externimpbody :
	'=' externimp
	| '{' /*4P*/ semis externimps1 '}'
	;

externimps1 :
	externimps1 externimp semis1
	| externimp semis1
	;

externimp :
	externtarget varid STRING
	| externtarget '{' /*4P*/ externvals1 '}'
	;

externvals1 :
	externvals1 externval semis1
	| externval semis1
	;

externval :
	varid '=' STRING
	;

externtarget :
	ID_CS
	| ID_JS
	| ID_C
	;

aliasdecl :
	ALIAS typeid typeparams kannot '=' type
	;

typedecl :
	typemod TYPE typeid typeparams kannot typebody
	| structmod STRUCT typeid typeparams kannot conparams
	| effectmod EFFECT varid typeparams kannot opdecls
	| effectmod EFFECT typeparams kannot operation
	| NAMED effectmod EFFECT varid typeparams kannot opdecls
	| NAMED effectmod EFFECT typeparams kannot operation
	| NAMED effectmod EFFECT varid typeparams kannot IN type opdecls
	;

typemod :
	structmod
	| ID_OPEN
	| ID_EXTEND
	| ID_CO
	| ID_REC
	;

structmod :
	ID_VALUE
	| ID_REFERENCE
	| /*empty*/
	;

effectmod :
	ID_REC
	| ID_LINEAR
	| ID_LINEAR ID_REC
	| /*empty*/
	;

typebody :
	'{' /*4P*/ semis constructors '}'
	| /*empty*/
	;

typeid :
	'(' /*4P*/ commas ')'
	| '[' /*4P*/ ']'
	| '<' /*5P*/ '>' /*5P*/
	| '<' /*5P*/ '|' /*5P*/ '>' /*5P*/
	| varid
	;

commas :
	commas1
	| /*empty*/
	;

commas1 :
	commas ','
	;

constructors :
	constructors1 semis1
	| /*empty*/
	;

constructors1 :
	constructors1 semis1 constructor
	| constructor
	;

constructor :
	pub con conid typeparams conparams
	| pub con STRING typeparams conparams
	;

con :
	CON
	| /*empty*/
	;

conparams :
	'(' /*4P*/ parameters1 ')'
	| '{' /*4P*/ semis sconparams '}'
	| /*empty*/
	;

sconparams :
	sconparams parameter semis1
	| /*empty*/
	;

opdecls :
	'{' /*4P*/ semis operations '}'
	;

operations :
	operations operation semis1
	| /*empty*/
	;

operation :
	pub VAL identifier typeparams ':' tatomic
	| pub FUN identifier typeparams '(' /*4P*/ parameters ')' ':' tatomic
	| pub CTL identifier typeparams '(' /*4P*/ parameters ')' ':' tatomic
	;

puredecl :
	inlinemod VAL binder '=' blockexpr
	| inlinemod FUN funid funbody
	;

inlinemod :
	ID_INLINE
	| ID_NOINLINE
	| /*empty*/
	;

fundecl :
	funid funbody
	;

binder :
	identifier
	| identifier ':' type
	;

funid :
	identifier
	| '[' /*4P*/ commas ']'
	| STRING
	;

funbody :
	typeparams '(' /*4P*/ pparameters ')' bodyexpr
	| typeparams '(' /*4P*/ pparameters ')' ':' tresult qualifier block
	;

annotres :
	':' tresult
	| /*empty*/
	;

block :
	'{' /*4P*/ semis statements1 '}'
	;

statements1 :
	statements1 statement semis1
	| statement semis1
	//| error semis1
	;

statement :
	decl
	| withstat
	| withstat IN blockexpr
	| returnexpr
	| basicexpr
	;

decl :
	FUN fundecl
	| VAL apattern '=' blockexpr
	| VAR binder ASSIGN /*5P*/ blockexpr
	;

bodyexpr :
	blockexpr
	| RARROW /*3P*/ blockexpr
	;

blockexpr :
	expr
	;

expr :
	withexpr
	| block
	| returnexpr
	| valexpr
	| basicexpr
	;

basicexpr :
	ifexpr
	| matchexpr
	| handlerexpr
	| fnexpr
	| opexpr %prec RARROW /*3P*/
	;

matchexpr :
	MATCH ntlexpr '{' /*4P*/ semis matchrules '}'
	;

fnexpr :
	FN /*4P*/ funbody
	;

returnexpr :
	RETURN expr
	;

ifexpr :
	IF ntlexpr THEN /*1P*/ blockexpr elifs
	| IF ntlexpr THEN /*1P*/ blockexpr
	| IF ntlexpr RETURN expr
	;

elifs :
	ELIF /*2P*/ ntlexpr THEN /*1P*/ blockexpr elifs
	| ELSE /*2P*/ blockexpr
	;

valexpr :
	VAL apattern '=' blockexpr IN expr
	;

opexpr :
	opexpr qoperator prefixexpr
	| prefixexpr
	;

prefixexpr :
	'!' prefixexpr
	| '~' prefixexpr
	| appexpr %prec RARROW /*3P*/
	;

appexpr :
	appexpr '(' /*4P*/ arguments ')'
	| appexpr '[' /*4P*/ arguments ']'
	| appexpr '.' /*4P*/ atom
	| appexpr block
	| appexpr fnexpr
	| atom
	;

ntlexpr :
	ntlopexpr
	;

ntlopexpr :
	ntlopexpr qoperator ntlprefixexpr
	| ntlprefixexpr
	;

ntlprefixexpr :
	'!' ntlprefixexpr
	| '~' ntlprefixexpr
	| ntlappexpr
	;

ntlappexpr :
	ntlappexpr '(' /*4P*/ arguments ')'
	| ntlappexpr '[' /*4P*/ arguments ']'
	| ntlappexpr '.' /*4P*/ atom
	| atom
	;

atom :
	qidentifier
	| qconstructor
	| literal
	| mask
	| '(' /*4P*/ aexprs ')'
	| '[' /*4P*/ cexprs ']'
	;

literal :
	INT
	| FLOAT
	| CHAR
	| STRING
	;

mask :
	MASK behind '<' /*5P*/ tbasic '>' /*5P*/
	;

behind :
	ID_BEHIND
	| /*empty*/
	;

arguments :
	arguments1
	| /*empty*/
	;

arguments1 :
	arguments1 ',' argument
	| argument
	;

argument :
	expr
	| identifier '=' expr
	;

parameters :
	parameters1
	| /*empty*/
	;

parameters1 :
	parameters1 ',' parameter
	| parameter
	;

parameter :
	borrow paramid ':' type
	| borrow paramid ':' type '=' expr
	;

paramid :
	identifier
	| WILDCARD
	;

borrow :
	'^'
	| /*empty*/
	;

pparameters :
	pparameters1
	| /*empty*/
	;

pparameters1 :
	pparameters1 ',' pparameter
	| pparameter
	;

pparameter :
	borrow pattern
	| borrow pattern ':' type
	| borrow pattern ':' type '=' expr
	| borrow pattern '=' expr
	;

aexprs :
	aexprs1
	| /*empty*/
	;

aexprs1 :
	aexprs1 ',' aexpr
	| aexpr
	;

cexprs :
	cexprs0
	| cexprs0 aexpr
	;

cexprs0 :
	cexprs0 aexpr ','
	| /*empty*/
	;

aexpr :
	expr annot
	;

annot :
	':' typescheme
	| /*empty*/
	;

qoperator :
	op
	;

qidentifier :
	qvarid
	| QIDOP
	| identifier
	;

identifier :
	varid
	| IDOP
	;

qvarid :
	QID
	;

varid :
	ID
	| ID_C
	| ID_CS
	| ID_JS
	| ID_FILE
	| ID_INLINE
	| ID_NOINLINE
	| ID_OPEN
	| ID_EXTEND
	| ID_LINEAR
	| ID_BEHIND
	| ID_VALUE
	| ID_REFERENCE
	| ID_SCOPED
	| ID_INITIALLY
	| ID_FINALLY
	| ID_REC
	| ID_CO
	;

qconstructor :
	conid
	| qconid
	;

qconid :
	QCONID
	;

conid :
	CONID
	;

op :
	OP /*5P*/
	| '>' /*5P*/
	| '<' /*5P*/
	| '|' /*5P*/
	| ASSIGN /*5P*/
	;

matchrules :
	matchrules1 semis1
	| /*empty*/
	;

matchrules1 :
	matchrules1 semis1 matchrule
	| matchrule
	;

matchrule :
	patterns1 '|' /*5P*/ expr RARROW /*3P*/ blockexpr
	| patterns1 RARROW /*3P*/ blockexpr
	;

patterns1 :
	patterns1 ',' pattern
	| pattern
	;

apatterns :
	apatterns1
	| /*empty*/
	;

apatterns1 :
	apatterns1 ',' apattern
	| apattern
	;

apattern :
	pattern annot
	;

pattern :
	identifier
	| identifier AS pattern
	| conid
	| conid '(' /*4P*/ patargs ')'
	| '(' /*4P*/ apatterns ')'
	| '[' /*4P*/ apatterns ']'
	| literal
	| WILDCARD
	;

patargs :
	patargs1
	| /*empty*/
	;

patargs1 :
	patargs ',' patarg
	| patarg
	;

patarg :
	identifier '=' apattern
	| apattern
	;

handlerexpr :
	override HANDLER witheff opclauses
	| override HANDLE witheff ntlexpr opclauses
	| NAMED HANDLER witheff opclauses
	| NAMED HANDLE witheff ntlexpr opclauses
	;

override :
	OVERRIDE
	| /*empty*/
	;

witheff :
	'<' /*5P*/ anntype '>' /*5P*/
	| /*empty*/
	;

withstat :
	WITH basicexpr
	| WITH binder LARROW basicexpr
	| WITH override witheff opclause
	| WITH binder LARROW witheff opclause
	;

withexpr :
	withstat IN blockexpr
	;

opclauses :
	'{' /*4P*/ semis opclauses1 semis1 '}'
	| '{' /*4P*/ semis '}'
	;

opclauses1 :
	opclauses1 semis1 opclausex
	| opclausex
	;

opclausex :
	ID_FINALLY bodyexpr
	| ID_INITIALLY '(' /*4P*/ opparam ')' bodyexpr
	| opclause
	;

opclause :
	VAL qidentifier '=' blockexpr
	| VAL qidentifier ':' type '=' blockexpr
	| FUN qidentifier opparams bodyexpr
	| controlmod CTL qidentifier opparams bodyexpr
	| RETURN '(' /*4P*/ opparam ')' bodyexpr
	;

controlmod :
	FINAL
	| RAW
	| /*empty*/
	;

opparams :
	'(' /*4P*/ opparams0 ')'
	;

opparams0 :
	opparams1
	| /*empty*/
	;

opparams1 :
	opparams1 ',' opparam
	| opparam
	;

opparam :
	paramid
	| paramid ':' type
	;

tbinders :
	tbinders1
	| /*empty*/
	;

tbinders1 :
	tbinders1 ',' tbinder
	| tbinder
	;

tbinder :
	varid kannot
	;

typescheme :
	someforalls tarrow qualifier
	;

type :
	FORALL typeparams1 tarrow qualifier
	| tarrow qualifier
	;

someforalls :
	SOME typeparams1 FORALL typeparams1
	| SOME typeparams1
	| FORALL typeparams1
	| /*empty*/
	;

typeparams :
	typeparams1
	| /*empty*/
	;

typeparams1 :
	'<' /*5P*/ tbinders '>' /*5P*/
	;

qualifier :
	WITH '(' /*4P*/ predicates1 ')'
	| /*empty*/
	;

predicates1 :
	predicates1 ',' predicate
	| predicate
	;

predicate :
	typeapp
	;

tarrow :
	tatomic RARROW /*3P*/ tresult
	| tatomic
	;

tresult :
	tatomic tbasic
	| tatomic
	;

tatomic :
	tbasic
	| '<' /*5P*/ targuments1 '|' /*5P*/ tatomic '>' /*5P*/
	| '<' /*5P*/ targuments '>' /*5P*/
	;

tbasic :
	typeapp
	| '(' /*4P*/ tparams ')'
	| '[' /*4P*/ anntype ']'
	;

typeapp :
	typecon
	| typecon '<' /*5P*/ targuments '>' /*5P*/
	;

typecon :
	varid
	| qvarid
	| WILDCARD
	| '(' /*4P*/ commas1 ')'
	| '[' /*4P*/ ']'
	| '(' /*4P*/ RARROW /*3P*/ ')'
	;

tparams :
	tparams1
	| /*empty*/
	;

tparams1 :
	tparams1 ',' tparam
	| tparam
	;

tparam :
	identifier ':' anntype
	| anntype
	;

targuments :
	targuments1
	| /*empty*/
	;

targuments1 :
	targuments1 ',' anntype
	| anntype
	;

anntype :
	type kannot
	;

kannot :
	DCOLON kind
	| /*empty*/
	;

kind :
	'(' /*4P*/ kinds1 ')' RARROW /*3P*/ katom
	| katom RARROW /*3P*/ kind
	| katom
	;

kinds1 :
	kinds1 ',' kind
	| kind
	;

katom :
	conid
	;

%%

/* Character classes */

Upper           [A-Z]
Lower           [a-z]
Letter          {Lower}|{Upper}
Digit           [0-9]
Hex             [0-9a-fA-F]
Space           [ \t]
Newline         [\r]?[\n]
Final           [\']

/* for editor highlighting ' */

GraphicChar     [ \x21-\x26\x28-\[\]-\x7E]
GraphicStr      [ \x21\x23-\[\]-\x7E]
GraphicRaw      [\t \n\r\x21\x23-\x7E]
GraphicLine     [\t \x21-\x7E]
GraphicBlock    [\t \x21-\)\+-\.0-\x7E]

/* Valid UTF-8 sequences. Based on http://www.w3.org/2005/03/23-lex-U
    Added \xC0\x80 as a valid sequence to represent 0 (also called 'modified' utf-8)
 */
UC              [\x80-\xBF]
U2              [\xC2-\xDF]{UC}
U3              [\xE0][\xA0-\xBF]{UC}|[\xE1-\xEC]{UC}{UC}|[\xED][\x80-\x9F]{UC}|[\xEE-\xEF]{UC}{UC}
U4              [\xF0][\x90-\xBF]{UC}{UC}|[\xF1-\xF3]{UC}{UC}{UC}|[\xF4][\x80-\x8F]{UC}{UC}
Utf8            {U2}|{U3}|{U4}

Symbol          [\$\%\&\*\+\@!\\\^\~=\.\-\:\?\|\<\>]
Symbols         {Symbol}+|[/]
AngleBar        [\<\>\|]
Angle           [\<\>]
Sign            [\-]?

IdChar          {Letter}|{Digit}|[_\-]
ConId           {Upper}{IdChar}*{Final}*
Id              {Lower}{IdChar}*{Final}*

HexEsc          x{Hex}{Hex}|u{Hex}{Hex}{Hex}{Hex}|U{Hex}{Hex}{Hex}{Hex}{Hex}{Hex}
CharEsc         [nrt\\\"\']
/* for editor highlighting " */

LineChar        {GraphicLine}|{Utf8}
BlockChar       {GraphicBlock}|{Utf8}

DigitSep        _{Digit}+
HexSep          _{Hex}+

Digits          {Digit}+{DigitSep}*
HexDigits       {Hex}+{HexSep}*

Decimal         0|[1-9](_?{Digits})?
HexaDecimal     0[xX]{HexDigits}

%%

  /* -------- INITIAL ------------- */

  /* keywords */
infix                     INFIX
infixl                    INFIXL
infixr                    INFIXR

type                      TYPE
alias                     ALIAS
struct                    STRUCT
effect                    EFFECT

forall                    FORALL
//exists                    EXISTS
some                      SOME

abstract                  ABSTRACT
extern                    EXTERN

fun                       FUN
fn                        FN
val                       VAL
var                       VAR
con                       CON

if                        IF
then                      THEN
else                      ELSE
elif                      ELIF
with                      WITH
in                        IN
match                     MATCH
return                    RETURN

module                    MODULE
import                    IMPORT
pub                       PUB
as                        AS

handle                    HANDLE
handler                   HANDLER
ctl                       CTL
final                     FINAL
raw                       RAW
mask                      MASK
override                  OVERRIDE
named                     NAMED

rec                       ID_REC
co                        ID_CO
open                      ID_OPEN
extend                    ID_EXTEND
linear                    ID_LINEAR
value                     ID_VALUE
reference                 ID_REFERENCE

inline                    ID_INLINE
noinline                  ID_NOINLINE
scoped                    ID_SCOPED
behind                    ID_BEHIND
initially                 ID_INITIALLY
finally                   ID_FINALLY

  /* unused reserved identifiers */
//interface                 IFACE
//break                     BREAK
//continue                  CONTINUE
//unsafe                    UNSAFE

  /* reserved operators */
:                         ':'
=                         '='
\.                        '.'
\-\>                      RARROW
\<\-                      LARROW

  /* special operators and identifiers (not reserved but have special meaning in certain contexts) */
:=                        ASSIGN
::                        DCOLON
\|                        '|'
\<                        '<'
\>                        '>'
!                         '!'
\^                        '^'
~                         '~'

file                      ID_FILE
cs                        ID_CS
js                        ID_JS
c                         ID_C

  /* Special symbols (cannot be an operator) */
\)                        ')'
\(                        '('
\{                        '{'
\}                        '}'
\[                        '['
\]                        ']'
;                         ';'
,                         ','
//"`"                         '`'

  /* Comments */
\/\/.*                      skip()
\/\*(?s:.)*?\*\/  skip()

  /* Type operators: these are all illegal operators and should be parsed as single characters
     For example, in types, we can have sequences like "<<exn>|<div|e>>" where "<<", ">|<", and ">>"
     should not be parsed as operator tokens. */
\|\|                      OP
//{AngleBar}{AngleBar}+     { yyless(1); return yytext[0]; }

  /* Numbers */
{Sign}{Decimal}\.{Digits}[eE][\-\+]?{Digit}+         FLOAT
{Sign}{Decimal}[eE][\-\+]?{Digit}+                   FLOAT
{Sign}{Decimal}\.{Digits}                            FLOAT

{Sign}{HexaDecimal}\.{HexDigits}[pP][\-\+]?{Digit}+  FLOAT
{Sign}{HexaDecimal}[pP][\-\+]?{Digit}+               FLOAT
{Sign}{HexaDecimal}\.{HexDigits}                     FLOAT

{Sign}{HexaDecimal}       INT
{Sign}{Decimal}           INT


  /* Identifiers and operators */
({Id}\/)+{ConId}          QCONID
({Id}\/)+{Id}             QID
({Id}\/)+\({Symbols}\)    QIDOP

{ConId}                   CONID
{Id}                      ID
\({Symbols}\)             IDOP
{Symbols}                 OP
_{IdChar}*                WILDCARD

  /* Character literals */
\'{GraphicChar}\'         CHAR
\'\\{HexEsc}\'            CHAR
\'\\{CharEsc}\'           CHAR
\'{Utf8}\'                CHAR
//\'.\'                     { illegalchar(yytext[1],"character literal",yyscanner);

//\'.                       { illegal("illegal character literal",yyscanner);  // '

  /* String literal start  */
\"(\\.|[^"\n\r\\])*\"	STRING

  /* Raw string literal start */
r#*\"([^"])*\"#*	STRING

  /* White space  */
{Space}+                  skip()
{Newline}                 skip()
//{Newline}{Newline}  INSERTED_SEMI
//.                         { illegalchar(yytext[yyleng-1],NULL,yyscanner);

%%
