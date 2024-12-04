//From: https://github.com/oridb/mc/blob/74d91a0021de012908cfdb35fb61a1473a376130/parse/gram.y

/*Tokens*/
%token Taddeq
%token Tasn
%token Tattr
%token Tauto
%token Tband
%token Tbandeq
%token Tbnot
%token Tboollit
%token Tbor
%token Tboreq
%token Tbreak
%token Tbsl
%token Tbsleq
%token Tbsr
%token Tbsreq
%token Tbxor
%token Tbxoreq
%token Tcbrace
%token Tchrlit
%token Tcolon
%token Tcomma
%token Tconst
%token Tcontinue
%token Tcparen
%token Tcsqbrac
%token Tdec
%token Tderef
%token Tdiv
%token Tdiveq
%token Tdot
%token Telif
%token Tellipsis
%token Telse
%token Tendblk
%token Tendln
%token Teq
%token Tfloatlit
%token Tfor
%token Tgap
%token Tge
%token Tgeneric
%token Tgoto
%token Tgt
%token Tident
%token Tif
%token Timpl
%token Tinc
%token Tintlit
%token Tland
%token Tle
%token Tlnot
%token Tlor
%token Tlt
%token Tmatch
%token Tminus
%token Tmod
%token Tmodeq
%token Tmul
%token Tmuleq
%token Tne
%token Tobrace
%token Toparen
%token Tosqbrac
%token Tpkg
%token Tplus
%token Tqmark
%token Tret
%token Tsizeof
%token Tstrlit
%token Tstruct
%token Tsubeq
%token Ttick
%token Ttrait
%token Ttyparam
%token Ttype
%token Tunion
%token Tuse
%token Tvar
%token Tvoidlit
%token Twhile
%token Twith

%left /*1*/ Ttick
%left /*2*/ Tplus Tminus Tband

%start file

%%

file :
	toplev
	| file Tendln toplev
	;

toplev :
	package
	| use
	| implstmt
	| traitdef
	| tydef
	| decl
	| /*empty*/
	;

decl :
	attrs Tvar decllist traitspec
	| attrs Tconst decllist traitspec
	| attrs Tgeneric decllist traitspec
	;

attrs :
	/*empty*/
	| attrs Tattr
	;

traitspec :
	Twith traits
	| /*empty*/
	;

traits :
	traitvar
	| traits listsep traitvar
	;

traitvar :
	traitlist generictype
	| traitlist generictype Tret type
	;

traitlist :
	name
	| traitlist listsep name
	;

decllist :
	declbody
	| decllist listsep declbody
	;

use :
	Tuse Tident
	| Tuse Tstrlit
	;

optident :
	Tident
	| /*empty*/
	;

package :
	Tpkg optident Tasn pkgbody Tendblk
	;

pkgbody :
	pkgitem
	| pkgbody Tendln pkgitem
	;

pkgitem :
	decl
	| pkgtydef
	| traitdef
	| implstmt
	| /*empty*/
	;

pkgtydef :
	attrs tydef
	;

declbody :
	declcore
	| declcore Tasn expr
	;

declcore :
	name
	| typedeclcore
	;

typedeclcore :
	name Tcolon type
	| Tcolon type
	;

name :
	Tident
	| Tident Tdot Tident
	;

implstmt :
	Timpl name type optauxtypes traitspec
	| Timpl name type optauxtypes traitspec Tasn Tendln implbody Tendblk
	;

implbody :
	optendlns
	| implbody Tident Tasn exprln optendlns
	;

traitdef :
	Ttrait Tident generictype optauxtypes traitspec
	| Ttrait Tident generictype optauxtypes traitspec Tasn traitbody Tendblk
	;

optauxtypes :
	Tret typelist
	| /*empty*/
	;

traitbody :
	optendlns
	| traitbody Tident Tcolon type optendlns
	;

tydef :
	Ttype typeid traitspec
	| Ttype typeid traitspec Tasn type
	;

typeid :
	Tident
	| Tident Toparen typarams Tcparen
	;

typarams :
	generictype
	| typarams listsep generictype
	;

type :
	structdef
	| tupledef
	| uniondef
	| compoundtype
	| generictype
	| Tellipsis
	;

generictype :
	Ttyparam
	;

compoundtype :
	functype
	| type Tosqbrac Tcolon Tcsqbrac
	| type Tosqbrac expr Tcsqbrac
	| type Tosqbrac Tellipsis Tcsqbrac
	| name Toparen typelist Tcparen
	| type Tderef
	| Tvoidlit
	| name
	;

functype :
	Toparen funcsig Tcparen
	;

funcsig :
	argdefs Tret type
	;

argdefs :
	typedeclcore
	| argdefs listsep typedeclcore
	| /*empty*/
	;

tupledef :
	Toparen typelist Tcparen
	;

typelist :
	type
	| typelist listsep type
	;

structdef :
	Tstruct structbody Tendblk
	;

structbody :
	structent
	| structbody structent
	;

structent :
	declcore Tendln
	| Tendln
	;

uniondef :
	Tunion unionbody Tendblk
	;

unionbody :
	unionelt
	| unionbody unionelt
	;

unionelt :
	Ttick /*1L*/ name type Tendln
	| Ttick /*1L*/ name Tendln
	| Tendln
	;

goto :
	Tgoto Tident
	;

retexpr :
	Tret expr
	| expr
	;

optexpr :
	expr
	| /*empty*/
	;

loopcond :
	exprln
	| Tendln
	;

optexprln :
	exprln
	| Tendln
	;

exprln :
	expr Tendln
	;

expr :
	ternexpr asnop expr
	| ternexpr
	;

asnop :
	Tasn
	| Taddeq
	| Tsubeq
	| Tmuleq
	| Tdiveq
	| Tmodeq
	| Tboreq
	| Tbxoreq
	| Tbandeq
	| Tbsleq
	| Tbsreq
	;

ternexpr :
	lorexpr
	| lorexpr Tqmark lorexpr Tcolon lorexpr
	;

lorexpr :
	lorexpr Tlor landexpr
	| landexpr
	;

landexpr :
	landexpr Tland cmpexpr
	| cmpexpr
	;

cmpexpr :
	cmpexpr cmpop borexpr
	| borexpr
	;

cmpop :
	Teq
	| Tgt
	| Tlt
	| Tge
	| Tle
	| Tne
	;

borexpr :
	borexpr Tbor bandexpr
	| borexpr Tbxor bandexpr
	| bandexpr
	;

bandexpr :
	bandexpr Tband /*2L*/ addexpr
	| addexpr
	;

addexpr :
	addexpr addop mulexpr
	| mulexpr
	;

addop :
	Tplus /*2L*/
	| Tminus /*2L*/
	;

mulexpr :
	mulexpr mulop shiftexpr
	| shiftexpr
	;

mulop :
	Tmul
	| Tdiv
	| Tmod
	;

shiftexpr :
	shiftexpr shiftop prefixexpr
	| prefixexpr
	;

shiftop :
	Tbsl
	| Tbsr
	;

prefixexpr :
	Tauto prefixexpr
	| Tinc prefixexpr
	| Tdec prefixexpr
	| Tband /*2L*/ prefixexpr
	| Tlnot prefixexpr
	| Tbnot prefixexpr
	| Tminus /*2L*/ prefixexpr
	| Tplus /*2L*/ prefixexpr
	| Ttick /*1L*/ name prefixexpr
	| Ttick /*1L*/ name
	| postfixexpr
	;

postfixexpr :
	postfixexpr Tdot Tident
	| postfixexpr Tdot Tintlit
	| postfixexpr Tinc
	| postfixexpr Tdec
	| postfixexpr Tosqbrac expr Tcsqbrac
	| postfixexpr Tosqbrac optexpr Tcolon optexpr Tcsqbrac
	| postfixexpr Tderef
	| postfixexpr Toparen arglist Tcparen
	| atomicexpr
	;

arglist :
	expr
	| arglist listsep expr
	| /*empty*/
	;

atomicexpr :
	Tident
	| Tgap
	| literal
	| Toparen expr Tcparen
	| Toparen expr Tcolon type Tcparen
	| Tsizeof Toparen type Tcparen
	| Timpl Toparen name listsep type Tcparen
	;

tupbody :
	tuphead tuprest
	;

tuphead :
	expr listsep
	;

tuprest :
	/*empty*/
	| expr
	| tuprest listsep expr
	;

literal :
	funclit
	| littok
	| seqlit
	| tuplit
	;

tuplit :
	Toparen tupbody Tcparen
	;

littok :
	strlit
	| Tchrlit
	| Tfloatlit
	| Tboollit
	| Tvoidlit
	| Tintlit
	;

strlit :
	Tstrlit
	| strlit Tstrlit
	;

obrace :
	Tobrace
	;

funclit :
	obrace params traitspec Tendln blkbody Tcbrace
	| obrace params Tret type traitspec Tendln blkbody Tcbrace
	;

params :
	fnparam
	| params listsep fnparam
	| /*empty*/
	;

fnparam :
	declcore
	| Tgap
	| Tgap Tcolon type
	;

seqlit :
	Tosqbrac optendlns arrayelts optcomma Tcsqbrac
	| Tosqbrac optendlns structelts optcomma Tcsqbrac
	| Tosqbrac optendlns optcomma Tcsqbrac
	;

arrayelts :
	arrayelt
	| arrayelts listsep arrayelt
	;

arrayelt :
	expr optendlns
	| Tdot Tosqbrac expr Tcsqbrac Tasn expr optendlns
	;

structelts :
	structelt
	| structelts listsep structelt
	;

structelt :
	Tdot Tident Tasn expr optendlns
	;

listsep :
	Tcomma optendlns
	;

optcomma :
	Tcomma optendlns
	| /*empty*/
	;

optendlns :
	/*empty*/
	| optendlns Tendln
	;

stmt :
	goto
	| break
	| continue
	| retexpr
	| label
	| ifstmt
	| forstmt
	| whilestmt
	| matchstmt
	| /*empty*/
	;

break :
	Tbreak
	;

continue :
	Tcontinue
	;

forstmt :
	Tfor optexprln loopcond optexprln block
	| Tfor expr Tcolon exprln block
	| Tfor decl Tendln loopcond optexprln block
	;

whilestmt :
	Twhile exprln block
	;

ifstmt :
	Tif exprln blkbody elifs
	;

elifs :
	Telif exprln blkbody elifs
	| Telse block
	| Tendblk
	;

matchstmt :
	Tmatch exprln optendlns Tbor matches Tendblk
	;

matches :
	match
	| matches Tbor match
	;

match :
	expr Tcolon blkbody Tendln
	;

block :
	blkbody Tendblk
	;

blkbody :
	decl
	| stmt
	| tydef
	| blkbody Tendln stmt
	| blkbody Tendln decl
	| blkbody Tendln tydef
	;

label :
	Tcolon Tident
	;

%%

%%

[ \t\r]+	skip()
^"#".*	skip()
"/*"(?s:.)*?"*/"	skip()

"{"	Tobrace
"}"	Tcbrace
"("	Toparen
")"	Tcparen
"["	Tosqbrac
"]"	Tcsqbrac
","	Tcomma
"`"	Ttick
"#"	Tderef
"?"	Tqmark
":"	Tcolon
"::"	Twith
"~"	Tbnot
";"|"\n"	Tendln
";;"	Tendblk
"."	Tdot
"..."	Tellipsis
"+"	Tplus
"++"	Tinc
"+="	Taddeq
"-"	Tminus
"--"	Tdec
"-="	Tsubeq
"->"	Tret
"*"	Tmul
"*="	Tmuleq
"/"	Tdiv
"/="	Tdiveq
"%"	Tmod
"%="	Tmodeq
"="	Tasn
"=="	Teq
"|"	Tbor
"||"	Tlor
"|="	Tboreq
"&"	Tband
"&&"	Tland
"&="	Tbandeq
"^"	Tbxor
"^="	Tbxoreq
"<"	Tlt
"<="	Tle
"<<"	Tbsl
"<<="	Tbsleq
">"	Tgt
">="	Tge
">>"	Tbsr
">>="	Tbsreq
"!"	Tlnot
"!="	Tne

"$noret"	Tattr
"_"	Tgap
"auto"	Tauto
"break"	Tbreak
"const"	Tconst
"continue"	Tcontinue
"elif"	Telif
"else"	Telse
"extern"	Tattr
"false"	Tboollit
"for"	Tfor
"generic"	Tgeneric
"goto"	Tgoto
"if"	Tif
"impl"	Timpl
"match"	Tmatch
"pkg"	Tpkg
"pkglocal"	Tattr
"sizeof"	Tsizeof
"struct"	Tstruct
"trait"	Ttrait
"true"	Tboollit
"type"	Ttype
"union"	Tunion
"use"	Tuse
"var"	Tvar
"void"	Tvoidlit
"while"	Twhile

[0-9]+	Tintlit
"0x"[0-9A-Fa-f]+	Tintlit
"0o"[0-8]+	Tintlit
"0b"[01]+	Tintlit

[0-9]+"."[0-9]+	Tfloatlit

'(\\.|[^'\r\n\\])'	Tchrlit
\"(\\.|[^"\r\n\\])*\"	Tstrlit

"@"[A-Za-z_][A-Za-z0-9_]*	Ttyparam
[A-Za-z_$][A-Za-z0-9_]*	Tident

%%
