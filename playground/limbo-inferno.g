/*Tokens*/
%token Laddeq
%token Ladt
%token Lalt
%token Landand
%token Landeq
%token Larray
%token Lbreak
%token Lcase
%token Lchan
%token Lcomm
%token Lcon
%token Lcons
%token Lconst
%token Lcont
%token Lcyclic
%token Ldec
%token Ldeclas
%token Ldiveq
%token Ldo
//%token Ldynamic
%token Lelse
%token Leq
%token Lexcept
%token Lexit
%token Lexp
%token Lexpeq
%token Lfix
%token Lfn
%token Lfor
%token Lgeq
%token Lhd
%token Lid
%token Lif
%token Limplement
%token Limport
%token Linc
%token Linclude
%token Llabs
%token Llen
%token Lleq
%token Llist
%token Lload
%token Llsh
%token Llsheq
%token Lmdot
%token Lmodeq
%token Lmodule
%token Lmuleq
%token Lneq
%token Lnil
%token Lof
%token Lor
%token Loreq
%token Loror
%token Lpick
%token Lraise
%token Lraises
%token Lrconst
%token Lref
%token Lreturn
%token Lrsh
%token Lrsheq
%token Lsconst
%token Lself
%token Lspawn
%token Lsubeq
%token Ltagof
%token Ltid
%token Ltl
%token Lto
%token Ltype
%token Lwhile
%token Lxoreq

//%fallback Lid Lraise

%right /*1*/ '=' Landeq Loreq Lxoreq Llsheq Lrsheq Laddeq Lsubeq Lmuleq Ldiveq Lmodeq Lexpeq Ldeclas
%left /*2*/ Lload
%left /*3*/ Loror
%left /*4*/ Landand
%right /*5*/ Lcons
%left /*6*/ '|'
%left /*7*/ '^'
%left /*8*/ '&'
%left /*9*/ Leq Lneq
%left /*10*/ '<' '>' Lleq Lgeq
%left /*11*/ Llsh Lrsh
%left /*12*/ '+' '-'
%left /*13*/ '*' '/' '%'
%right /*14*/ Lexp
%right /*15*/ Lcomm
%left /*16*/ '(' ')' '[' ']' Linc Ldec Lof Lref
%right /*17*/ Lif Lelse Lfn ':' Lexcept Lraises
%left /*18*/ Lmdot
%left /*19*/ '.'
%left /*20*/ Lto
%left /*21*/ Lor
%nonassoc /*22*/ Lrconst
%nonassoc /*23*/ Lconst
%nonassoc /*24*/ Lid Ltid Lsconst
%nonassoc /*25*/ Llabs Lnil '!' '~' Llen Lhd Ltl Ltagof '{' '}' ';' Limplement Limport Linclude Lcon Ltype Lmodule Lcyclic Ladt Larray Llist Lchan Lself Ldo Lwhile Lfor Lbreak Lalt Lcase Lpick Lcont Lreturn Lexit Lspawn Lraise Lfix //Ldynamic

%start prog

%%

prog :
	Limplement /*25N*/ ids ';' /*25N*/ topdecls
	| topdecls
	;

topdecls :
	topdecl
	| topdecls topdecl
	;

topdecl :
	//error ';' /*25N*/
	decl
	| fndef
	| adtdecl ';' /*25N*/
	| mdecl ';' /*25N*/
	| idatom '=' /*1R*/ exp ';' /*25N*/
	| idterm '=' /*1R*/ exp ';' /*25N*/
	| idatom Ldeclas /*1R*/ exp ';' /*25N*/
	| idterm Ldeclas /*1R*/ exp ';' /*25N*/
	| idterms ':' /*17R*/ type ';' /*25N*/
	| idterms ':' /*17R*/ type '=' /*1R*/ exp ';' /*25N*/
	;

idterms :
	idterm
	| idterms ',' idterm
	;

decl :
	Linclude /*25N*/ Lsconst /*24N*/ ';' /*25N*/
	| ids ':' /*17R*/ Ltype /*25N*/ type ';' /*25N*/
	| ids ':' /*17R*/ Limport /*25N*/ exp ';' /*25N*/
	| ids ':' /*17R*/ type ';' /*25N*/
	| ids ':' /*17R*/ type '=' /*1R*/ exp ';' /*25N*/
	| ids ':' /*17R*/ Lcon /*25N*/ exp ';' /*25N*/
	| edecl
	;

edecl :
	ids ':' /*17R*/ Lexcept /*17R*/ ';' /*25N*/
	| ids ':' /*17R*/ Lexcept /*17R*/ '(' /*16L*/ tuplist ')' /*16L*/ ';' /*25N*/
	;

mdecl :
	ids ':' /*17R*/ Lmodule /*25N*/ '{' /*25N*/ mfields '}' /*25N*/
	;

mfields :
	/*empty*/
	| mfields mfield
	//| error
	;

mfield :
	ids ':' /*17R*/ type ';' /*25N*/
	| adtdecl ';' /*25N*/
	| ids ':' /*17R*/ Ltype /*25N*/ type ';' /*25N*/
	| ids ':' /*17R*/ Lcon /*25N*/ exp ';' /*25N*/
	| edecl
	;

adtdecl :
	ids ':' /*17R*/ Ladt /*25N*/ polydec '{' /*25N*/ fields '}' /*25N*/ forpoly
	| ids ':' /*17R*/ Ladt /*25N*/ polydec Lfor /*25N*/ '{' /*25N*/ tpolys '}' /*25N*/ '{' /*25N*/ fields '}' /*25N*/
	;

forpoly :
	/*empty*/
	| Lfor /*25N*/ '{' /*25N*/ tpolys '}' /*25N*/
	;

fields :
	/*empty*/
	| fields field
	//| error
	;

field :
	dfield
	| pdecl
	| ids ':' /*17R*/ Lcon /*25N*/ exp ';' /*25N*/
	;

dfields :
	/*empty*/
	| dfields dfield
	;

dfield :
	ids ':' /*17R*/ Lcyclic /*25N*/ type ';' /*25N*/
	| ids ':' /*17R*/ type ';' /*25N*/
	;

pdecl :
	Lpick /*25N*/ '{' /*25N*/ pfields '}' /*25N*/
	;

pfields :
	pfbody dfields
	//| pfbody error
	//| error
	;

pfbody :
	ptags Llabs /*25N*/
	| pfbody dfields ptags Llabs /*25N*/
	//| pfbody error ptags Llabs /*25N*/
	;

ptags :
	rptags
	;

rptags :
	Lid /*24N*/
	| rptags Lor /*21L*/ Lid /*24N*/
	;

ids :
	rids
	;

rids :
	Lid /*24N*/
	| rids ',' Lid /*24N*/
	;

fixtype :
	Lfix /*25N*/ '(' /*16L*/ exp ',' exp ')' /*16L*/
	| Lfix /*25N*/ '(' /*16L*/ exp ')' /*16L*/
	;

types :
	type
	| Lcyclic /*25N*/ type
	| types ',' type
	| types ',' Lcyclic /*25N*/ type
	;

type :
	Ltid /*24N*/
	| iditype
	| dotiditype
	| type Lmdot /*18L*/ Lid /*24N*/
	| type Lmdot /*18L*/ Lid /*24N*/ '[' /*16L*/ types ']' /*16L*/
	| Lref /*16L*/ type
	| Lchan /*25N*/ Lof /*16L*/ type
	| '(' /*16L*/ tuplist ')' /*16L*/
	| Larray /*25N*/ Lof /*16L*/ type
	| Llist /*25N*/ Lof /*16L*/ type
	| Lfn /*17R*/ polydec fnargretp raises
	| fixtype
	;

iditype :
	Lid /*24N*/
	| Lid /*24N*/ '[' /*16L*/ types ']' /*16L*/
	;

dotiditype :
	type '.' /*19L*/ Lid /*24N*/
	| type '.' /*19L*/ Lid /*24N*/ '[' /*16L*/ types ']' /*16L*/
	;

tuplist :
	type
	| tuplist ',' type
	;

polydec :
	/*empty*/
	| '[' /*16L*/ ids ']' /*16L*/
	;

fnarg :
	'(' /*16L*/ forms ')' /*16L*/
	| '(' /*16L*/ '*' /*13L*/ ')' /*16L*/
	| '(' /*16L*/ ftypes ',' '*' /*13L*/ ')' /*16L*/
	;

fnargret :
	fnarg %prec ':' /*17R*/
	| fnarg ':' /*17R*/ type
	;

fnargretp :
	fnargret %prec '=' /*1R*/
	| fnargret Lfor /*25N*/ '{' /*25N*/ tpolys '}' /*25N*/
	;

forms :
	/*empty*/
	| ftypes
	;

ftypes :
	ftype
	| ftypes ',' ftype
	;

ftype :
	nids ':' /*17R*/ type
	| nids ':' /*17R*/ adtk
	| idterms ':' /*17R*/ type
	| idterms ':' /*17R*/ adtk
	;

nids :
	nrids
	;

nrids :
	Lid /*24N*/
	| Lnil /*25N*/
	| nrids ',' Lid /*24N*/
	| nrids ',' Lnil /*25N*/
	;

adtk :
	Lself /*25N*/ iditype
	| Lself /*25N*/ Lref /*16L*/ iditype
	| Lself /*25N*/ dotiditype
	| Lself /*25N*/ Lref /*16L*/ dotiditype
	;

fndef :
	fnname fnargretp raises fbody
	;

raises :
	Lraises /*17R*/ '(' /*16L*/ idlist ')' /*16L*/
	| Lraises /*17R*/ idatom
	| %prec Lraises /*17R*/ /*empty*/
	;

fbody :
	'{' /*25N*/ stmts '}' /*25N*/
	//| error '}' /*25N*/
	//| error '{' /*25N*/ stmts '}' /*25N*/
	;

fnname :
	Lid /*24N*/ polydec
	| fnname '.' /*19L*/ Lid /*24N*/ polydec
	;

stmts :
	/*empty*/
	| stmts decl
	| stmts stmt
	;

elists :
	'(' /*16L*/ elist ')' /*16L*/
	| elists ',' '(' /*16L*/ elist ')' /*16L*/
	;

stmt :
	//error ';' /*25N*/
	//| error '}' /*25N*/
	//| error '{' /*25N*/ stmts '}' /*25N*/
	'{' /*25N*/ stmts '}' /*25N*/
	| elists ':' /*17R*/ type ';' /*25N*/
	| elists ':' /*17R*/ type '=' /*1R*/ exp ';' /*25N*/
	| zexp ';' /*25N*/
	| Lif /*17R*/ '(' /*16L*/ exp ')' /*16L*/ stmt
	| Lif /*17R*/ '(' /*16L*/ exp ')' /*16L*/ stmt Lelse /*17R*/ stmt
	| bclab Lfor /*25N*/ '(' /*16L*/ zexp ';' /*25N*/ zexp ';' /*25N*/ zexp ')' /*16L*/ stmt
	| bclab Lwhile /*25N*/ '(' /*16L*/ zexp ')' /*16L*/ stmt
	| bclab Ldo /*25N*/ stmt Lwhile /*25N*/ '(' /*16L*/ zexp ')' /*16L*/ ';' /*25N*/
	| Lbreak /*25N*/ bctarg ';' /*25N*/
	| Lcont /*25N*/ bctarg ';' /*25N*/
	| Lreturn /*25N*/ zexp ';' /*25N*/
	| Lspawn /*25N*/ exp ';' /*25N*/
	| Lraise /*25N*/ zexp ';' /*25N*/
	| bclab Lcase /*25N*/ exp '{' /*25N*/ cqstmts '}' /*25N*/
	| bclab Lalt /*25N*/ '{' /*25N*/ qstmts '}' /*25N*/
	| bclab Lpick /*25N*/ Lid /*24N*/ Ldeclas /*1R*/ exp '{' /*25N*/ pstmts '}' /*25N*/
	| Lexit /*25N*/ ';' /*25N*/
	| '{' /*25N*/ stmts '}' /*25N*/ Lexcept /*17R*/ idexc '{' /*25N*/ eqstmts '}' /*25N*/
	;

bclab :
	/*empty*/
	| ids ':' /*17R*/
	;

bctarg :
	/*empty*/
	| Lid /*24N*/
	;

qstmts :
	qbodies stmts
	;

qbodies :
	qual Llabs /*25N*/
	| qbodies stmts qual Llabs /*25N*/
	;

cqstmts :
	cqbodies stmts
	;

cqbodies :
	qual Llabs /*25N*/
	| cqbodies stmts qual Llabs /*25N*/
	;

eqstmts :
	eqbodies stmts
	;

eqbodies :
	qual Llabs /*25N*/
	| eqbodies stmts qual Llabs /*25N*/
	;

qual :
	exp
	| exp Lto /*20L*/ exp
	| '*' /*13L*/
	| qual Lor /*21L*/ qual
	//| error
	;

pstmts :
	pbodies stmts
	;

pbodies :
	pqual Llabs /*25N*/
	| pbodies stmts pqual Llabs /*25N*/
	;

pqual :
	Lid /*24N*/
	| '*' /*13L*/
	| pqual Lor /*21L*/ pqual
	//| error
	;

zexp :
	/*empty*/
	| exp
	;

exp :
	monexp
	| exp '=' /*1R*/ exp
	| exp Landeq /*1R*/ exp
	| exp Loreq /*1R*/ exp
	| exp Lxoreq /*1R*/ exp
	| exp Llsheq /*1R*/ exp
	| exp Lrsheq /*1R*/ exp
	| exp Laddeq /*1R*/ exp
	| exp Lsubeq /*1R*/ exp
	| exp Lmuleq /*1R*/ exp
	| exp Ldiveq /*1R*/ exp
	| exp Lmodeq /*1R*/ exp
	| exp Lexpeq /*1R*/ exp
	| exp Lcomm /*15R*/ '=' /*1R*/ exp
	| exp Ldeclas /*1R*/ exp
	| Lload /*2L*/ Lid /*24N*/ exp %prec Lload /*2L*/
	| exp Lexp /*14R*/ exp
	| exp '*' /*13L*/ exp
	| exp '/' /*13L*/ exp
	| exp '%' /*13L*/ exp
	| exp '+' /*12L*/ exp
	| exp '-' /*12L*/ exp
	| exp Lrsh /*11L*/ exp
	| exp Llsh /*11L*/ exp
	| exp '<' /*10L*/ exp
	| exp '>' /*10L*/ exp
	| exp Lleq /*10L*/ exp
	| exp Lgeq /*10L*/ exp
	| exp Leq /*9L*/ exp
	| exp Lneq /*9L*/ exp
	| exp '&' /*8L*/ exp
	| exp '^' /*7L*/ exp
	| exp '|' /*6L*/ exp
	| exp Lcons /*5R*/ exp
	| exp Landand /*4L*/ exp
	| exp Loror /*3L*/ exp
	;

monexp :
	term
	| '+' /*12L*/ monexp
	| '-' /*12L*/ monexp
	| '!' /*25N*/ monexp
	| '~' /*25N*/ monexp
	| '*' /*13L*/ monexp
	| Linc /*16L*/ monexp
	| Ldec /*16L*/ monexp
	| Lcomm /*15R*/ monexp
	| Lhd /*25N*/ monexp
	| Ltl /*25N*/ monexp
	| Llen /*25N*/ monexp
	| Lref /*16L*/ monexp
	| Ltagof /*25N*/ monexp
	| Larray /*25N*/ '[' /*16L*/ exp ']' /*16L*/ Lof /*16L*/ type
	| Larray /*25N*/ '[' /*16L*/ exp ']' /*16L*/ Lof /*16L*/ '{' /*25N*/ initlist '}' /*25N*/
	| Larray /*25N*/ '[' /*16L*/ ']' /*16L*/ Lof /*16L*/ '{' /*25N*/ initlist '}' /*25N*/
	| Llist /*25N*/ Lof /*16L*/ '{' /*25N*/ celist '}' /*25N*/
	| Lchan /*25N*/ Lof /*16L*/ type
	| Lchan /*25N*/ '[' /*16L*/ exp ']' /*16L*/ Lof /*16L*/ type
	| Larray /*25N*/ Lof /*16L*/ Ltid /*24N*/ monexp
	| Ltid /*24N*/ monexp
	| Lid /*24N*/ monexp
	| fixtype monexp
	;

term :
	idatom
	| term '(' /*16L*/ zelist ')' /*16L*/
	| '(' /*16L*/ elist ')' /*16L*/
	| term '.' /*19L*/ Lid /*24N*/
	| term Lmdot /*18L*/ term
	| term '[' /*16L*/ export ']' /*16L*/
	| term '[' /*16L*/ zexp ':' /*17R*/ zexp ']' /*16L*/
	| term Linc /*16L*/
	| term Ldec /*16L*/
	| Lsconst /*24N*/
	| Lconst /*23N*/
	| Lrconst /*22N*/
	| term '[' /*16L*/ exportlist ',' export ']' /*16L*/
	;

idatom :
	Lid /*24N*/
	| Lnil /*25N*/
	;

idterm :
	'(' /*16L*/ idlist ')' /*16L*/
	;

exportlist :
	export
	| exportlist ',' export
	;

export :
	exp
	| texp
	;

texp :
	Ltid /*24N*/
	| Larray /*25N*/ Lof /*16L*/ type
	| Llist /*25N*/ Lof /*16L*/ type
	| Lcyclic /*25N*/ type
	;

idexc :
	Lid /*24N*/
	| /*empty*/
	;

idlist :
	idterm
	| idatom
	| idlist ',' idterm
	| idlist ',' idatom
	;

zelist :
	/*empty*/
	| elist
	;

celist :
	elist
	| elist ','
	;

elist :
	exp
	| elist ',' exp
	;

initlist :
	elemlist
	| elemlist ','
	;

elemlist :
	elem
	| elemlist ',' elem
	;

elem :
	exp
	| qual Llabs /*25N*/ exp
	;

tpolys :
	tpoly dfields
	;

tpoly :
	ids Llabs /*25N*/
	| tpoly dfields ids Llabs /*25N*/
	;

%%

expn    [Ee][+-]?[0-9]+

%%

[ \t\r\n\v\f]+	skip()
"#".*   skip()

"!"	'!'
"%"	'%'
"&"	'&'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"-"	'-'
"."	'.'
"/"	'/'
":"	':'
";"	';'
"<"	'<'
"="	'='
">"	'>'
"["	'['
"]"	']'
"^"	'^'
"{"	'{'
"|"	'|'
"}"	'}'
"~"	'~'

//tokwords
"&="	Landeq
"|="	Loreq
"^="	Lxoreq
"<<="	Llsheq
">>="	Lrsheq
"+="	Laddeq
"-="	Lsubeq
"*="	Lmuleq
"/="	Ldiveq
"%="	Lmodeq
"**=" Lexpeq
":="	Ldeclas
"||"	Loror
"&&"	Landand
"::"	Lcons
"=="	Leq
"!="	Lneq
"<="	Lleq
">="	Lgeq
"<<"	Llsh
">>"	Lrsh
"<-"	Lcomm
"++" Linc
"--"	Ldec
"->" Lmdot
"=>" Llabs
"**" Lexp

//Keywords
"adt"		Ladt
"alt"		Lalt
"array"	Larray
"big"		Ltid
"break"	Lbreak
"byte"		Ltid
"case"		Lcase
"chan"		Lchan
"con"		Lcon
"continue"	Lcont
"cyclic"	Lcyclic
"do"		Ldo
//"dynamic"	Ldynamic
"else"		Lelse
"exception"	Lexcept
"exit"		Lexit
"fixed"	Lfix
"fn"		Lfn
"for"		Lfor
"hd"		Lhd
"if"		Lif
"implement"	Limplement
"import"	Limport
"include"	Linclude
"int"		Ltid
"len"		Llen
"list"		Llist
"load"		Lload
"module"	Lmodule
"nil"		Lnil
"of"		Lof
"or"		Lor
"pick"		Lpick
"raise"	Lraise
"raises"	Lraises
"real"		Ltid
"ref"		Lref
"return"	Lreturn
"self"		Lself
"spawn"	Lspawn
"string"	Ltid
"tagof"	Ltagof
"tl"		Ltl
"to"		Lto
"type"		Ltype
"while"	Lwhile

[0-9]+"."[0-9]*{expn}?	Lrconst
"."[0-9]*{expn}?	Lrconst
[0-9]+[Rr][0-9A-Fa-f]+ Lrconst
[0-9]+{expn} Lrconst
[0-9]+	Lconst
"'''"|'(\\.|[^'\r\n\\]+|\\u[0-9A-Fa-f]{4})'	Lconst

\"(\\.|[^"\r\n\\])*\"	Lsconst
"`"(\\.|[^`\r\n\\])*"`"	Lsconst

[A-Za-z_][A-Za-z0-9_]*	Lid

%%
