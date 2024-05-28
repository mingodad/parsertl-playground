/* Heavily modified from SML/NJ sources. */

/* ml.grm
 *
 * Copyright 1989,1992 by AT&T Bell Laboratories
 *
 * SML/NJ is released under a HPND-style license.
 * See the file NJ-LICENSE for details.
 */

/* Copyright (C) 2008,2009,2014-2017,2019,2022 Matthew Fluet.
 * Copyright (C) 1999-2006 Henry Cejtin, Matthew Fluet, Suresh
 * Jagannathan, and Stephen Weeks.
 * Copyright (C) 1997-2000 NEC Research Institute.
 *
 * MLton is released under a HPND-style license.
 * See the file MLton-LICENSE for details.
 */

%token CHAR
%token INT
%token SHORTALPHANUMID
%token SHORTSYMID
%token LONGALPHANUMID
%token LONGSYMID
%token REAL
%token STRING
%token TYVAR
%token WORD
%token ABSTYPE AND ANDALSO ARROW AS ASTERISK BAR CASE COLON
%token COLONGT COMMA DATATYPE DOTDOTDOT ELSE END EQUALOP
%token EQTYPE EXCEPTION DO DARROW FN FUN FUNCTOR HANDLE HASH
%token HASHLBRACKET IF IN INCLUDE INFIX INFIXR LBRACE LBRACKET LET
%token LOCAL LPAREN NONFIX ORELSE OF OP OPEN OVERLOAD RAISE
%token RBRACE RBRACKET REC RPAREN SEMICOLON SHARING SIG SIGNATURE
%token STRUCT STRUCTURE THEN TYPE VAL WHERE WHILE WILD WITH
%token WITHTYPE
/* Extensions */
%token BUILD_CONST COMMAND_LINE_CONST CONST
%token ADDRESS EXPORT IMPORT SYMBOL
%token PRIM
%token SHOW_BASIS

%nonassoc WITHTYPE
%right AND
%right ARROW
%right DARROW
%left DO
%left ELSE
%left RAISE
%right HANDLE
%left ORELSE
%left ANDALSO
%right AS
%left COLON

%%

program :
	expsAndTopdecs
	;

expsAndTopdecs :
	exp expsAndTopdecs_Q
	| topdecs
	;

expsAndTopdecs_Q :
	/*empty*/
	| SEMICOLON expsAndTopdecs
	;

topdecs :
	topdec topdecs
	| expsAndTopdecs_Q
	;

topdec :
	topdecnode
	;

topdecnode :
	strdec
	| SIGNATURE sigbinds
	| FUNCTOR funbinds
	;

/*---------------------------------------------------*/
/* Structures */
/*---------------------------------------------------*/

strdecs :
	strdecsnode
 ;

strdecsnode :
	| SEMICOLON strdecs
	| strdec strdecs
	;

strdec :
	strdecnode
	;

strdecnode :
	STRUCTURE strbinds
	| LOCAL strdecs IN strdecs END
	| decnolocal
	| SHOW_BASIS
	;

strbinds :
	strid sigconst EQUALOP strbinds_Q
	;

strbinds_Q :
	strexp1 strbinds_Q1
	| strexp2 strbinds_Q2
	;

strbinds_Q1 :
	strbinds_Q2
	| WHERE whereeqn strbinds_Q1_Q
	;

strbinds_Q1_Q :
	strbinds_Q1
	| AND whereeqn strbinds_Q1_Q
	;

strbinds_Q2 :
	/*empty*/
	| AND strbinds
	;

strexp :
	strexpnode
	;

strexpnode :
	strexp1
	| strexp1 whereeqns
	| strexp2node
	;

strexp1 :
	strexp COLON sigexp_Q
	| strexp COLONGT sigexp_Q
	;

strexp2 :
	strexp2node
	;

strexp2node :
	longstrid
	| STRUCT strdecs END
	| fctid arg_fct
	| LET strdecs IN strexp END
	;

arg_fct :
	LPAREN strexp RPAREN
	| LPAREN strdecs RPAREN
	;

/*---------------------------------------------------*/
/* Signatures */
/*---------------------------------------------------*/

sigexp :
	sigexp_Q
	| sigexp_Q whereeqns
	;

whereeqns :
	whereeqns_Q
	;

whereeqns_Q :
	WHERE whereeqn
	| WHERE whereeqn whereeqns_Q
	| WHERE whereeqn whereandeqns
	;

whereandeqns :
	AND whereeqn
	| AND whereeqn whereandeqns
	| AND whereeqn whereeqns_Q
	;

sigbinds:
	sigid EQUALOP sigexp_Q sigbinds_Q
	;

sigexp_Q :
	sigexp_Qnode
	;

sigexp_Qnode :
	sigid
	| SIG specs END
	;

sigbinds_Q :
	/*empty*/
	| AND sigbinds
	| WHERE whereeqn sigbinds_Q_Q
	;

sigbinds_Q_Q :
	sigbinds_Q
	| AND whereeqn sigbinds_Q_Q
	;

whereeqn :
	TYPE tyvars longtycon EQUALOP ty
	;

sigconst :
	/*empty*/
	| COLON sigexp
	| COLONGT sigexp
	;

specs :
	/*empty*/
	| SEMICOLON specs
	| spec specs
	;

spec :
	specnode
	;

specnode :
	VAL valdescs
	| TYPE typdescs
	| TYPE typBind
	| EQTYPE typdescs
	| DATATYPE datatypeRhs
	| EXCEPTION exndescs
	| STRUCTURE strdescs
	| INCLUDE sigexp
	| INCLUDE sigid sigids
	| sharespec
	;

sharespec :
	SHARING TYPE longtyconeqns
	| SHARING longstrideqns
	;

longstrideqns :
	longstrid EQUALOP longstrid
	| longstrid EQUALOP longstrideqns
	;

longtyconeqns :
	longtycon EQUALOP longtycon
	| longtycon EQUALOP longtyconeqns
	;

strdescs :
	strid COLON sigexp_Q strdescs_Q
	;

strdescs_Q :
	/*empty*/
	| AND strdescs
	| WHERE whereeqn strdescs_Q_Q
	;

strdescs_Q_Q :
	strdescs_Q
	| AND whereeqn strdescs_Q_Q
	;

typdescs :
	typdesc
	| typdesc AND typdescs
	;

typdesc :
	tyvars tycon
	;

valdescs :
	valdesc
	| valdesc AND valdescs
	;

valdesc :
	vid COLON ty
	;

exndescs :
	exndesc
	| exndesc AND exndescs
	;

exndesc :
	con tyOpt
	;

tyOpt :
	/*empty*/
	| OF ty
	;

/*---------------------------------------------------*/
/* Functors */
/*---------------------------------------------------*/

funbinds :
	fctid LPAREN fctarg RPAREN sigconst EQUALOP funbinds_Q
	;

funbinds_Q :
	strexp1 funbinds_Q1
	| strexp2 funbinds_Q2
	;

funbinds_Q1 :
	funbinds_Q2
	| WHERE whereeqn funbinds_Q1_Q
	;

funbinds_Q2 :
	/*empty*/
	| AND funbinds
	;

funbinds_Q1_Q :
	funbinds_Q1
	| AND whereeqn funbinds_Q1_Q
	;

fctarg :
	strid COLON sigexp
	| specs
	;

/*---------------------------------------------------*/
/* Declarations */
/*---------------------------------------------------*/

decs :
	/*empty*/
	| dec decs
	| SEMICOLON decs
	;

dec :
	decnode
	;

decnode :
	decnolocal
	| LOCAL decs IN decs END
	;

decnolocal :
	VAL valbindTop
	| VAL tyvarseq valbindTop
	| DO exp
	| FUN funs
	| FUN tyvarseq funs
	| TYPE typBind
	| DATATYPE datatypeRhs
	| ABSTYPE datBind WITH decs END
	| EXCEPTION ebs
	| OPEN longstrids
	| fixity vids
	| OVERLOAD priority vid COLON ty AS longvidands
 ;

valbindTop :
	valbind
	;

valbind :
	pat EQUALOP exp
	| pat EQUALOP exp AND valbind
	| REC rvalbind
	;

rvalbind :
	REC rvalbind
	| pat EQUALOP FN match
	| pat EQUALOP FN match AND rvalbind
	;

constraint :
	/*empty*/
	| COLON ty
	;

funs :
	clausesTop
	| clausesTop AND funs
	;

clausesTop:
	clauses
	| optbar_Q clauses
	;

clauses :
	clause
	| clause BAR clauses
	;

clause :
	apats constraint EQUALOP exp
	;

typBind :
	tbs
 ;

tbs :
	tbs_Q
	;

tbs_Q :
	tb
	| tb AND tbs_Q
	;

tb :
	tyvars tycon EQUALOP ty
	;

tyvars :
	tyvarseq
	| /*empty*/
	;

tyvarseq:
	tyvar
	| LPAREN tyvar_pc RPAREN
	;

tyvar_pc:
	tyvar
	| tyvar COMMA tyvar_pc
	;

constrs :
	constr
	| constr BAR constrs
	;

constr :
	opcon
	| opcon OF ty
	;

opcon :
	con
	| OP con
	;

ebs :
	eb
	| eb AND ebs
	;

eb :
	opcon ebrhs
	;

ebrhs :
	ebrhsnode
	;

ebrhsnode :
	/*empty*/
	| OF ty
	| EQUALOP longcon
	| EQUALOP OP longcon
	;

fixity :
	INFIX
	| INFIX digit
	| INFIXR
	| INFIXR digit
	| NONFIX
	;

priority :
	/*empty*/
	| digit
	;

int :
	INT
	;

word :
	WORD
	;

digit :
	INT
	;

numericField :
	INT
	;

datatypeRhs :
	datatypeRhsnode
	;

datatypeRhsnode :
	repl
	| datBind
	;

repl :
	tyvars tycon EQUALOP DATATYPE longtycon
 ;

datBind :
	dbs
	| dbs withtypes
	;

dbs :
	dbs_Q
	;

dbs_Q:
	db
	| db AND dbs_Q
	;

db :
	tyvars tycon EQUALOP optbar constrs
	;

withtypes :
	WITHTYPE typBind
	;

longvidands :
	longvid
	| longvid AND longvidands
	;

match :
	optbar rules
	;

rules :
	rule
	| rule BAR rules
	;

rule :
	pat DARROW exp
	;

elabel :
	field EQUALOP exp
	| idField constraint
	;

elabels :
	elabel COMMA elabels
	| elabel
	;

exp_ps :
	exp optsemicolon
	| exp SEMICOLON exp_ps
	;

exp :
	expnode
	;

expnode :
	exp HANDLE match
	| exp ORELSE exp
	| exp ANDALSO exp
	| exp COLON ty
	| app_exp
	| FN match
	| CASE exp OF match
	| WHILE exp DO exp
	| IF exp THEN exp ELSE exp
	| RAISE exp
	;

app_exp :
	aexp
	| aexp app_exp
	| longvid
	| longvid app_exp
	;

aexp :
	OP longvid
	| const
	| HASH field
	| HASHLBRACKET exp_list RBRACKET
	| HASHLBRACKET RBRACKET
	| LBRACE elabels RBRACE
	| LBRACE RBRACE
	| LPAREN RPAREN
	| LPAREN exp_ps RPAREN
	| LPAREN exp_2c RPAREN
	| LBRACKET exp_list RBRACKET
	| LBRACKET RBRACKET
	| LET decs IN exp_ps END
	| ADDRESS string symattributes COLON ty SEMICOLON
	| BUILD_CONST string COLON ty SEMICOLON
	| COMMAND_LINE_CONST string COLON ty EQUALOP constOrBool SEMICOLON
	| CONST string COLON ty SEMICOLON
	| EXPORT string ieattributes COLON ty SEMICOLON
	| IMPORT string ieattributes COLON ty SEMICOLON
	| IMPORT ASTERISK ieattributes COLON ty SEMICOLON
	| PRIM string COLON ty SEMICOLON
	| SYMBOL string symattributes COLON ty SEMICOLON
	| SYMBOL ASTERISK COLON ty SEMICOLON
 ;

ieattributes :
	/*empty*/
	| shortAlphanumId ieattributes
	;

symattributes :
	/*empty*/
	| shortAlphanumId symattributes
	;

exp_2c :
	exp COMMA exp_2c
	| exp COMMA exp
	;

exp_list :
	exp
	| exp COMMA exp_list
	;

/*---------------------------------------------------*/
/* Patterns */
/*---------------------------------------------------*/

pat :
	cpat BAR barcpats
	| cpat
	;

cpat :
	cpatnode
	;

cpatnode :
	cpat AS cpat
	| cpat COLON ty
	| apats
	;

apats :
	apat
	| apat apats
	;

apat :
	apatnode
	;

apatnode :
	longvidNoEqual
	| OP longvid
	| const
	| WILD
	| LPAREN pats RPAREN
	| LBRACKET pats RBRACKET
	| HASHLBRACKET pats RBRACKET
	| LBRACE RBRACE
	| LBRACE patitems RBRACE
	;

pats :
	/*empty*/
	| pat commapats
	;

barcpats :
	cpat
	| cpat BAR barcpats
	;

commapats :
	/*empty*/
	| COMMA pat commapats
	;

patitems :
	patitem COMMA patitems
	| patitem
	| DOTDOTDOT
	;

patitem :
	field EQUALOP pat
	| vid constraint opaspat
	;

opaspat :
	/*empty*/
	| AS pat
	;

/*---------------------------------------------------*/
/* Types */
/*---------------------------------------------------*/

ty :
	tynode
	;

tynode :
	tuple_ty
	| ty ARROW ty
	| ty_Qnode
	;

ty_Q :
	ty_Qnode
	;

ty_Qnode :
	tyvar
	| LBRACE tlabels RBRACE
	| LBRACE RBRACE
	| LPAREN ty0_pc RPAREN longtycon
	| LPAREN ty RPAREN
	| ty_Q longtycon
	| longtycon
	;

tlabel :
	field COLON ty
	;

tlabels :
	tlabel COMMA tlabels
	| tlabel
	;

tuple_ty :
	ty_Q ASTERISK tuple_ty
	| ty_Q ASTERISK ty_Q
	;

ty0_pc :
	ty COMMA ty
	| ty COMMA ty0_pc
	;

/*---------------------------------------------------*/
/* Atoms */
/*---------------------------------------------------*/

optbar :
	/*empty*/
	| optbar_Q
	;

optbar_Q :
	BAR
	;

optsemicolon :
	/*empty*/
	| SEMICOLON
	;

constOrBool :
	const
	| shortAlphanumId
 ;

const :
	const_Q
	;

const_Q :
	int
	| word
	| REAL
	| STRING
	| CHAR
	;

string :
	STRING
	;

shortAlphanumId :
	SHORTALPHANUMID
	;

shortSymId :
	SHORTSYMID
	;

longAlphanumId :
	LONGALPHANUMID
	;

longSymId :
	LONGSYMID
	;

vidNoEqual :
	shortAlphanumId
	| shortSymId
	| ASTERISK
	;

vidEqual :
	EQUALOP
	;

vid :
	vidNoEqual
	| vidEqual
	;

longvidNoEqual :
	vidNoEqual
	| longAlphanumId
	| longSymId
	;

longvidEqual :
	vidEqual
	;

longvid :
	longvidNoEqual
	| longvidEqual
	;

con :
	vid
	;

longcon :
	longvid
	;

tyvar :
	TYVAR
	;

tycon :
	shortAlphanumId
	| shortSymId
	;

longtycon :
	tycon
	| longAlphanumId
	;

idField :
	shortAlphanumId
	| shortSymId
	| ASTERISK
	;

field :
	idField
	| numericField
	;

strid :
	shortAlphanumId
	;

longstrid :
	strid
	| longAlphanumId
	;

sigid :
	shortAlphanumId
	;

fctid :
	shortAlphanumId
	;

vids :
	vid
	| vid vids
	;

sigids :
	sigid
	| sigid sigids
	;

longstrids :
	longstrid
	| longstrid longstrids
	;

%%

ws  \t|"\011"|"\012"|" "
cr  "\013"
nl  "\010"
eol  ({cr}{nl}|{nl}|{cr})

alphanum  [A-Za-z0-9'_]
alphanumId  [A-Za-z]{alphanum}*
sym  "!"|"%"|"&"|"$"|"#"|"+"|"-"|"/"|":"|"<"|"="|">"|"?"|"@"|"\\"|"~"|"`"|"^"|"|"|"*"
symId  {sym}+

tyvarId  "'"{alphanum}*
longSymId  ({alphanumId}".")+{symId}
longAlphanumId  ({alphanumId}".")+{alphanumId}

decDigit  [0-9]
decnum  {decDigit}("_"*{decDigit})*
hexDigit  [0-9a-fA-F]
hexnum  {hexDigit}("_"*{hexDigit})*
binDigit  [0-1]
binnum  {binDigit}("_"*{binDigit})*
frac  "."{decnum}
exp  [eE](~?){decnum}
real  (~?)(({decnum}{frac}?{exp})|({decnum}{frac}{exp}?))

%%

{ws}+  skip()
{eol}  skip()

"(*#showBasis"{ws}+"\""[^"]*"\""{ws}*"*)" SHOW_BASIS
//Should be after SHOW_BASIS to not shadow it
"(*"(?s:.)*?"*)"    skip()


"_address" ADDRESS
"_build_const" BUILD_CONST
"_command_line_const" COMMAND_LINE_CONST
"_const" CONST
"_export" EXPORT
"_import" IMPORT
"_overload" OVERLOAD
"_prim" PRIM
"_symbol" SYMBOL

"#" HASH
"#[" HASHLBRACKET
"(" LPAREN
")" RPAREN
"," COMMA
"->" ARROW
"..." DOTDOTDOT
":" COLON
":>" COLONGT
";" SEMICOLON
"=" EQUALOP
"=>" DARROW
"[" LBRACKET
"]" RBRACKET
"_" WILD
"{" LBRACE
"|" BAR
"}" RBRACE

"abstype" ABSTYPE
"and" AND
"andalso" ANDALSO
"as" AS
"case" CASE
"datatype" DATATYPE
"do" DO
"else" ELSE
"end" END
"eqtype" EQTYPE
"exception" EXCEPTION
"fn" FN
"fun" FUN
"functor" FUNCTOR
"handle" HANDLE
"if" IF
"in" IN
"include" INCLUDE
"infix" INFIX
"infixr" INFIXR
"let" LET
"local" LOCAL
"nonfix" NONFIX
"of" OF
"op" OP
"open" OPEN
"orelse" ORELSE
"raise" RAISE
"rec" REC
"sharing" SHARING
"sig" SIG
"signature" SIGNATURE
"struct" STRUCT
"structure" STRUCTURE
"then" THEN
"type" TYPE
"val" VAL
"where" WHERE
"while" WHILE
"with" WITH
"withtype" WITHTYPE


{alphanumId} SHORTALPHANUMID
"*" ASTERISK
{symId} SHORTSYMID
{tyvarId} TYVAR
{longAlphanumId} LONGALPHANUMID
{longSymId} LONGSYMID


{real} REAL
{decnum} INT
"~"{decnum} INT
"0x"{hexnum} INT
"~0x"{hexnum} INT
"0b"{binnum} INT
"~0b"{binnum} INT
"0w"{decnum} INT
"0wx"{hexnum} WORD
"0wb"{binnum} WORD

\"(\\.|[^"\n\r\\])*\" STRING
"#\""(\\.|[^"\n\r\\])\" CHAR

%%
