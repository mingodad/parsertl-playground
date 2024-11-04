//From: https://github.com/urweb/urweb/blob/55a881ff9b50d9e5c3b2fd564f5cd44a5cc5e6bc/src/urweb.grm
/* Copyright (c) 2008-2016, Adam Chlipala
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * - The names of contributors may not be used to endorse or promote products
 *   derived from this software without specific prior written permission.
 *
 * THIS SOFTARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

/* Grammar for Ur/Web programs */

%token STRING INT FLOAT CHAR
%token SYMBOL CSYMBOL
%token LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE
%token EQ COMMA COLON DCOLON DCOLONWILD TCOLON TCOLONWILD DOT HASH UNDER UNDERUNDER BAR
%token PLUS MINUS DIVIDE DOTDOTDOT MOD AT
%token CON LTYPE VAL REC AND FUN MAP UNIT CLASS FFI
%token DATATYPE OF
%token ARROW LARROW DARROW STAR SEMI KARROW DKARROW BANG
%token FN PLUSPLUS MINUSMINUS MINUSMINUSMINUS DOLLAR TWIDDLE CARET
%token LET IN
%token STRUCTURE SIGNATURE STRUCT SIG END FUNCTOR WHERE SQL SELECT1
%token INCLUDE OPEN CONSTRAINT CONSTRAINTS EXPORT TABLE SEQUENCE VIEW INDEX
%token COOKIE STYLE TASK POLICY
%token CASE IF THEN ELSE ANDALSO ORELSE

%token XML_BEGIN XML_END XML_BEGIN_END
%token NOTAGS
%token BEGIN_TAG END_TAG

%token SELECT DISTINCT FROM AS CWHERE GROUP ORDER BY HAVING
%token UNION INTERSECT EXCEPT
%token LIMIT OFFSET ALL
%token TRUE FALSE CAND OR NOT
%token COUNT AVG SUM MIN MAX RANK PARTITION OVER
%token ASC DESC RANDOM
%token INSERT INTO VALUES UPDATE SET DELETE NULL IS COALESCE LIKE DISTANCE
%token CURRENT_TIMESTAMP
%token NE LT LE GT GE
%token CCONSTRAINT UNIQUE CHECK PRIMARY FOREIGN KEY ON NO ACTION RESTRICT CASCADE REFERENCES
%token JOIN INNER CROSS OUTER LEFT RIGHT FULL
%token CIF CTHEN CELSE
%token FWDAPP REVAPP COMPOSE ANDTHEN
%token BACKTICK_PATH

%right KARROW
%nonassoc DKARROW
%right SEMI
%nonassoc LARROW
%nonassoc IF THEN ELSE
%nonassoc DARROW
%left ORELSE
%left ANDALSO
%nonassoc COLON
%nonassoc DCOLON TCOLON DCOLONWILD TCOLONWILD
%left UNION INTERSECT EXCEPT ALL
%right COMMA
%right JOIN INNER CROSS OUTER LEFT RIGHT FULL
%right OR
%right CAND CIF /*FIXME CIF*/
%nonassoc EQ NE LT LE GT GE IS LIKE DISTANCE /*FIXME DISTANCE*/
%right ARROW

%left REVAPP
%right FWDAPP
%left BACKTICK_PATH
%right COMPOSE ANDTHEN

%right CARET PLUSPLUS
%left MINUSMINUS MINUSMINUSMINUS
%left PLUS MINUS
%left STAR DIVIDE MOD
%left NOT
%nonassoc TWIDDLE
%nonassoc DOLLAR
%left DOT
%nonassoc LBRACE RBRACE

%start file

%%

file :
	decls
	| SIG sgis
	;

decls :
	%empty
	| decls decl
	;

decl :
	CON SYMBOL cargl2 kopt EQ cexp
	| LTYPE SYMBOL cargl2 EQ cexp
	| DATATYPE dtypes
	| DATATYPE SYMBOL dargs EQ DATATYPE CSYMBOL DOT path
	| VAL pat eargl2 copt EQ eexp
	| VAL REC valis
	| FUN valis
	| SIGNATURE CSYMBOL EQ sgn
	| STRUCTURE CSYMBOL EQ str
	| STRUCTURE CSYMBOL COLON sgn EQ str
	| FUNCTOR CSYMBOL LPAREN CSYMBOL COLON sgn RPAREN EQ str
	| FUNCTOR CSYMBOL LPAREN CSYMBOL COLON sgn RPAREN COLON sgn EQ str
	| OPEN mpath
	| OPEN mpath LPAREN str RPAREN
	| OPEN CONSTRAINTS mpath
	| CONSTRAINT cterm TWIDDLE cterm
	| EXPORT spath
	| TABLE SYMBOL COLON cterm pkopt commaOpt cstopt
	| INDEX eterm COLON eterm
	| INDEX eterm COLON eterm IN cterm
	| SEQUENCE SYMBOL
	| VIEW SYMBOL EQ query
	| VIEW SYMBOL EQ LBRACE eexp RBRACE
	| COOKIE SYMBOL COLON cexp
	| STYLE SYMBOL
	| TASK eapps EQ eexp
	| POLICY eexp
	| FFI SYMBOL ffi_modes COLON cexp
	;

dtype :
	SYMBOL dargs EQ barOpt dcons
	;

dtypes :
	dtype
	| dtypes AND dtype
	;

kopt :
	%empty
	| DCOLON kind
	| DCOLONWILD
	;

dargs :
	%empty
	| dargs SYMBOL
	;

barOpt :
	%empty
	| BAR
	;

dcons :
	dcon
	| dcons BAR dcon
	;

dcon :
	CSYMBOL
	| CSYMBOL OF cexp
	;

vali :
	SYMBOL eargl2 copt EQ eexp
	;

copt :
	%empty
	| COLON cexp
	;

cstopt :
	%empty
	| csts
	;

csts :
	CCONSTRAINT tname cst
	| csts COMMA csts
	| LBRACE LBRACE eexp RBRACE RBRACE
	;

cst :
	UNIQUE tnames
	| CHECK sqlexp
	| FOREIGN KEY tnames REFERENCES texp LPAREN tnames_Q RPAREN pmodes
	| LBRACE eexp RBRACE
	;

tnameW :
	tname
	;

tnames :
	tnameW
	| LPAREN tnames_Q RPAREN
	;

tnames_Q :
	tnameW
	| tnames_Q COMMA tnameW
	;

pmode :
	ON pkind prule
	;

pkind :
	DELETE
	| UPDATE
	;

prule :
	NO ACTION
	| RESTRICT
	| CASCADE
	| SET NULL
	;

pmodes :
	%empty
	| pmodes pmode
	;

commaOpt :
	%empty
	| COMMA
	;

pk :
	LBRACE LBRACE eexp RBRACE RBRACE
	| tnames
	;

pkopt :
	%empty
	| PRIMARY KEY pk
	;

valis :
	vali
	| valis AND vali
	;

sgn :
	sgntm
	| FUNCTOR LPAREN CSYMBOL COLON sgn RPAREN COLON sgn
	;

sgntm :
	SIG sgis END
	| mpath
	| sgntm WHERE CON path EQ cexp
	| sgntm WHERE LTYPE path EQ cexp
	| LPAREN sgn RPAREN
	;

cexpO :
	%empty
	| EQ cexp
	;

sgi :
	LTYPE SYMBOL
	| CON SYMBOL cargl2 kopt cexpO
	| LTYPE SYMBOL EQ cexp
	| LTYPE SYMBOL cargp cargl2 cexpO
	| DATATYPE dtypes
	| DATATYPE SYMBOL dargs EQ DATATYPE CSYMBOL DOT path
	| VAL SYMBOL COLON cexp
	| STRUCTURE CSYMBOL COLON sgn
	| SIGNATURE CSYMBOL EQ sgn
	| FUNCTOR CSYMBOL LPAREN CSYMBOL COLON sgn RPAREN COLON sgn
	| INCLUDE sgn
	| CONSTRAINT cterm TWIDDLE cterm
	| TABLE SYMBOL COLON cterm pkopt commaOpt cstopt
	| SEQUENCE SYMBOL
	| VIEW SYMBOL COLON cexp
	| CLASS SYMBOL
	| CLASS SYMBOL DCOLON kind
	| CLASS SYMBOL EQ cexp
	| CLASS SYMBOL DCOLON kind EQ cexp
	| CLASS SYMBOL SYMBOL EQ cexp
	| CLASS SYMBOL LPAREN SYMBOL DCOLON kind RPAREN EQ cexp
	| COOKIE SYMBOL COLON cexp
	| STYLE SYMBOL
	;

sgis :
	%empty
	| sgis sgi
	;

str :
	STRUCT decls END
	| spath
	| FUNCTOR LPAREN CSYMBOL COLON sgn RPAREN DARROW str
	| FUNCTOR LPAREN CSYMBOL COLON sgn RPAREN COLON sgn DARROW str
	| spath LPAREN str RPAREN
	;

spath :
	CSYMBOL
	| spath DOT CSYMBOL
	;

kind :
	LBRACE kind RBRACE
	| kind ARROW kind
	| LPAREN kind RPAREN
	| UNDERUNDER
	| LPAREN ktuple RPAREN
	| CSYMBOL
	| CSYMBOL KARROW kind
	;

ktuple :
	kind STAR kind
	| ktuple STAR kind
	;

capps :
	cterm
	| capps cterm
	;

cexp :
	capps
	| cexp ARROW cexp
	| SYMBOL kcolon kind ARROW cexp
	| CSYMBOL KARROW cexp
	| cexp PLUSPLUS cexp
	| FN cargs DARROW cexp
	| LBRACK cexp TWIDDLE cexp RBRACK DARROW cexp
	| CSYMBOL DKARROW cexp
	| LPAREN cexp RPAREN DCOLON kind
	| UNDER DCOLON kind
	| ctuple
	;

kcolon :
	DCOLON
	| TCOLON
	;

cargs :
	carg
	| cargl
	;

cargl :
	cargp cargp
	| cargl cargp
	;

cargl2 :
	%empty
	| cargl2 cargp
	;

carg :
	SYMBOL DCOLON kind
	| UNDER DCOLON kind
	| SYMBOL DCOLONWILD
	| UNDER DCOLONWILD
	| cargp
	;

cargp :
	SYMBOL
	| UNDER
	| LPAREN SYMBOL kopt ckl RPAREN
	;

ckl :
	%empty
	| ckl COMMA SYMBOL kopt
	;

path :
	SYMBOL
	| CSYMBOL DOT path
	;

cpath :
	CSYMBOL
	| CSYMBOL DOT cpath
	;

mpath :
	CSYMBOL
	| mpath DOT CSYMBOL
	;

cterm :
	LPAREN cexp RPAREN
	| LBRACK rcon RBRACK
	| LBRACK rconn RBRACK
	| LBRACE rcone RBRACE
	| DOLLAR cterm
	| HASH CSYMBOL
	| HASH INT
	| path
	| path DOT INT
	| UNDER
	| MAP
	| UNIT
	| LPAREN ctuplev RPAREN
	;

ctuplev :
	cexp COMMA cexp
	| ctuplev COMMA cexp
	;

ctuple :
	capps STAR capps
	| capps STAR ctuple
	;

rcon :
	%empty
	| rpath EQ cexp
	| rcon COMMA rpath EQ cexp
	;

rconn :
	rpath
	| rconn COMMA rpath
	;

rcone :
	%empty
	| rpath COLON cexp
	| rcone COMMA rpath COLON cexp
	;

ident :
	CSYMBOL
	| INT
	| SYMBOL
	;

eapps :
	eterm
	| eapps eterm
	| eapps LBRACK cexp RBRACK
	| eapps BANG
	;

eexp :
	eapps
	| FN eargs DARROW eexp
	| CSYMBOL DKARROW eexp
	| eexp COLON cexp
	| eexp MINUSMINUS cexp
	| eexp MINUSMINUSMINUS cexp
	| CASE eexp OF barOpt branchs
	| IF eexp THEN eexp ELSE eexp
	| bind SEMI eexp
	| eexp EQ eexp
	| eexp NE eexp
	| MINUS eterm
	| eexp PLUS eexp
	| eexp MINUS eexp
	| eapps STAR eexp
	| eexp DIVIDE eexp
	| eexp MOD eexp
	| eexp LT eexp
	| eexp LE eexp
	| eexp GT eexp
	| eexp GE eexp
	| eexp FWDAPP eexp
	| eexp REVAPP eexp
	| eexp COMPOSE eexp
	| eexp ANDTHEN eexp
	| eexp BACKTICK_PATH eexp
	| eexp ANDALSO eexp
	| eexp ORELSE eexp
	| eexp PLUSPLUS eexp
	| eexp CARET eexp
	| eapps DCOLON eexp
	;

bind :
	eapps LARROW eapps
	| eapps
	;

eargs :
	earg
	| eargl
	;

eargl :
	eargp eargp
	| eargl eargp
	;

eargl2 :
	%empty
	| eargl2 eargp
	;

earg :
	patS
	| earga
	;

eargp :
	pterm
	| earga
	;

earga :
	LBRACK SYMBOL RBRACK
	| LBRACK SYMBOL DCOLONWILD RBRACK
	| LBRACK SYMBOL kcolon kind RBRACK
	| LBRACK SYMBOL TCOLONWILD RBRACK
	| LBRACK cexp TWIDDLE cexp RBRACK
	| LBRACK CSYMBOL RBRACK
	;

eterm :
	LPAREN eexp RPAREN
	| LPAREN etuple RPAREN
	| path
	| cpath
	| AT path
	| AT AT path
	| AT cpath
	| AT AT cpath
	| LBRACE rexp RBRACE
	| LBRACE RBRACE
	| UNIT
	| INT
	| FLOAT
	| STRING
	| CHAR
	| path DOT idents
	| LPAREN eexp RPAREN DOT idents
	| AT path DOT idents
	| AT AT path DOT idents
	| XML_BEGIN xml XML_END
	| XML_BEGIN XML_END
	| XML_BEGIN_END
	| LPAREN query RPAREN
	| LPAREN CWHERE sqlexp RPAREN
	| LPAREN SQL sqlexp RPAREN
	| LPAREN FROM tables RPAREN
	| LPAREN SELECT1 query1 RPAREN
	| LPAREN INSERT INTO texp LPAREN fields RPAREN VALUES LPAREN sqlexps RPAREN RPAREN
	| LPAREN enterDml UPDATE texp SET fsets CWHERE sqlexp leaveDml RPAREN
	| LPAREN enterDml DELETE FROM texp CWHERE sqlexp leaveDml RPAREN
	| UNDER
	| LET edecls IN eexp END
	| LET eexp WHERE edecls END
	| LBRACK RBRACK
	;

edecls :
	%empty
	| edecls edecl
	;

edecl :
	VAL pat EQ eexp
	| VAL REC valis
	| FUN valis
	;

enterDml :
	%empty
	;

leaveDml :
	%empty
	;

texp :
	SYMBOL
	| LBRACE LBRACE eexp RBRACE RBRACE
	;

fields :
	fident
	| fields COMMA fident
	;

sqlexps :
	sqlexp
	| sqlexps COMMA sqlexp
	;

fsets :
	fident EQ sqlexp
	| fsets COMMA fident EQ sqlexp
	;

idents :
	ident
	| idents DOT ident
	;

etuple :
	eexp COMMA eexp
	| etuple COMMA eexp
	;

branch :
	pat DARROW eexp
	;

branchs :
	branch
	| branchs BAR branch
	;

patS :
	pterm
	| pterm DCOLON patS
	| patS COLON cexp
	;

pat :
	patS
	| cpath pterm
	;

pterm :
	SYMBOL
	| cpath
	| UNDER
	| INT
	| MINUS INT
	| STRING
	| CHAR
	| LPAREN pat RPAREN
	| LBRACE RBRACE
	| UNIT
	| LBRACE rpat RBRACE
	| LPAREN ptuple RPAREN
	| LBRACK RBRACK
	;

rpat :
	CSYMBOL EQ pat
	| INT EQ pat
	| DOTDOTDOT
	| rpat COMMA CSYMBOL EQ pat
	| rpat COMMA INT EQ pat
	;

ptuple :
	pat COMMA pat
	| ptuple COMMA pat
	;

rexp :
	DOTDOTDOT
	| rpath EQ eexp
	| rexp COMMA rpath EQ eexp
	;

rpath :
	path
	| CSYMBOL
	;

xml :
	xml xmlOne
	| xmlOne
	;

xmlOpt :
	xml
	| %empty
	;

xmlOne :
	NOTAGS
	| tag DIVIDE GT
	| tag GT xmlOpt END_TAG
	| LBRACE eexp RBRACE
	| LBRACE LBRACK eexp RBRACK RBRACE
	;

tag :
	tagHead attrs
	;

tagHead :
	BEGIN_TAG
	| tagHead LBRACE cexp RBRACE
	;

attrs :
	%empty
	| attrs attr
	;

attr :
	SYMBOL EQ attrv
	| SYMBOL
	;

attrv :
	INT
	| FLOAT
	| STRING
	| LBRACE eexp RBRACE
	;

query :
	query1 obopt lopt ofopt
	;

dopt :
	%empty
	| DISTINCT
	;

query1 :
	SELECT dopt select FROM tables wopt gopt hopt
	| query1 UNION query1
	| query1 INTERSECT query1
	| query1 EXCEPT query1
	| query1 UNION ALL query1
	| query1 INTERSECT ALL query1
	| query1 EXCEPT ALL query1
	| LBRACE LBRACE LBRACE eexp RBRACE RBRACE RBRACE
	;

tables :
	fitem
	| tables COMMA fitem
	;

fitem :
	table_Q
	| LBRACE LBRACE eexp RBRACE RBRACE
	| fitem JOIN fitem ON sqlexp
	| fitem INNER JOIN fitem ON sqlexp
	| fitem CROSS JOIN fitem
	| fitem LEFT JOIN fitem ON sqlexp
	| fitem LEFT OUTER JOIN fitem ON sqlexp
	| fitem RIGHT JOIN fitem ON sqlexp
	| fitem RIGHT OUTER JOIN fitem ON sqlexp
	| fitem FULL JOIN fitem ON sqlexp
	| fitem FULL OUTER JOIN fitem ON sqlexp
	| LPAREN query RPAREN AS tname
	| LPAREN LBRACE LBRACE eexp RBRACE RBRACE RPAREN AS tname
	| LPAREN fitem RPAREN
	;

tname :
	CSYMBOL
	| LBRACE cexp RBRACE
	;

table :
	SYMBOL
	| SYMBOL AS tname
	| LBRACE LBRACE eexp RBRACE RBRACE AS tname
	;

table_Q :
	table
	;

tident :
	SYMBOL
	| CSYMBOL
	| LBRACE LBRACE cexp RBRACE RBRACE
	;

fident :
	CSYMBOL
	| LBRACE cexp RBRACE
	;

seli :
	/*tident DOT fident //already in sqlexp
	|*/ sqlexp
	| sqlexp AS fident
	| tident DOT LBRACE LBRACE cexp RBRACE RBRACE
	| tident DOT STAR
	;

selis :
	seli
	| selis COMMA seli
	;

select :
	STAR
	| selis
	;

sqlexp :
	TRUE
	| FALSE
	| INT
	| FLOAT
	| STRING
	| CURRENT_TIMESTAMP
	| tident DOT fident
	| CSYMBOL
	| LBRACE eexp RBRACE
	| sqlexp EQ sqlexp
	| sqlexp NE sqlexp
	| sqlexp LT sqlexp
	| sqlexp LE sqlexp
	| sqlexp GT sqlexp
	| sqlexp GE sqlexp
	| sqlexp PLUS sqlexp
	| sqlexp MINUS sqlexp
	| sqlexp STAR sqlexp
	| sqlexp DIVIDE sqlexp
	| sqlexp MOD sqlexp
	| sqlexp CAND sqlexp
	| sqlexp OR sqlexp
	| sqlexp LIKE sqlexp
	| sqlexp DISTANCE sqlexp
	| NOT sqlexp
	| MINUS sqlexp
	| sqlexp IS NULL
	| CIF sqlexp CTHEN sqlexp CELSE sqlexp
	| LBRACE LBRACK eexp RBRACK RBRACE
	| LPAREN sqlexp RPAREN
	| NULL
	| COUNT LPAREN STAR RPAREN window
	| COUNT LPAREN sqlexp RPAREN window
	| sqlagg LPAREN sqlexp RPAREN window
	| RANK UNIT window
	| COALESCE LPAREN sqlexp COMMA sqlexp RPAREN
	| fname LPAREN sqlexp RPAREN
	| fname LPAREN sqlexp COMMA sqlexp RPAREN
	| LPAREN query RPAREN
	;

window :
	%empty
	| OVER LPAREN pbopt obopt RPAREN
	;

pbopt :
	%empty
	| PARTITION BY sqlexp
	;

fname :
	SYMBOL
	| LBRACE eexp RBRACE
	;

wopt :
	%empty
	| CWHERE sqlexp
	;

groupi :
	tident DOT fident
	| tident DOT LBRACE LBRACE cexp RBRACE RBRACE
	;

groupis :
	groupi
	| groupis COMMA groupi
	;

gopt :
	%empty
	| GROUP BY groupis
	;

hopt :
	%empty
	| HAVING sqlexp
	;

obopt :
	%empty
	| ORDER BY obexps
	| ORDER BY LBRACE LBRACE LBRACE eexp RBRACE RBRACE RBRACE
	;

obitem :
	sqlexp diropt
	;

obexps :
	obitem
	| obitem COMMA obexps
	| RANDOM popt
	;

popt :
	%empty
	| LPAREN RPAREN
	| UNIT
	;

diropt :
	%empty
	| ASC
	| DESC
	| LBRACE eexp RBRACE
	;

lopt :
	%empty
	| LIMIT ALL
	| LIMIT sqlint
	;

ofopt :
	%empty
	| OFFSET sqlint
	;

sqlint :
	INT
	| LBRACE eexp RBRACE
	;

sqlagg :
	AVG
	| SUM
	| MIN
	| MAX
	;

ffi_mode :
	SYMBOL
	| SYMBOL STRING
	;

ffi_modes :
	%empty
	| ffi_modes ffi_mode
	;

%%

%x XML XMLTAG XMLCOMMENT XMLCODE

id   [a-z_][A-Za-z0-9_']*
xmlid   [A-Za-z][A-Za-z0-9_-]*
cid   [A-Z][A-Za-z0-9_']*
ws   [\ \t\012\r]
intconst   [0-9]+
realconst   [0-9]+\.[0-9]*
hexconst   0x[0-9A-F]+
notags   ([^<{\n(]|(\([^\*<{\n]))+
oint   [0-9][0-9][0-9]
xint   x[0-9a-fA-F][0-9a-fA-F]
str	\"(\\.|[^"\n\r\\])*\"

%%

{ws}+   skip()
\n  skip()
"(*"(?s:.)*?"*)"	skip()


"()"       UNIT
"("        LPAREN
")"        RPAREN
"["        LBRACK
"]"        RBRACK
"{"         LBRACE
"}"         RBRACE

"-->"      KARROW
"->"       ARROW
"==>"      DKARROW
"=>"       DARROW
"++"       PLUSPLUS
"--"       MINUSMINUS
"---"      MINUSMINUSMINUS
"^"        CARET

"&&"       ANDALSO
"||"       ORELSE

"<<<"      COMPOSE
">>>"      ANDTHEN
"<|"       FWDAPP
"|>"       REVAPP

"`"({cid}".")*{id}"`" BACKTICK_PATH

"="        EQ
"<>"       NE
"<"        LT
">"        GT
"<="       LE
">="       GE
","        COMMA
":::_"     TCOLONWILD
":::"      TCOLON
"::_"      DCOLONWILD
"::"       DCOLON
":"        COLON
"..."      DOTDOTDOT
"."        DOT
"$"        DOLLAR
"#"        HASH
"__"       UNDERUNDER
"_"        UNDER
"~"        TWIDDLE
"|"        BAR
"*"        STAR
"<-"       LARROW
";"        SEMI
"!"        BANG

"+"        PLUS
"-"        MINUS
"/"        DIVIDE
"%"        MOD
"@"        AT

"con"      CON
"type"     LTYPE
"datatype" DATATYPE
"of"       OF
"val"      VAL
"rec"      REC
"and"      AND
"fun"      FUN
"fn"       FN
"map"      MAP
"case"     CASE
"if"       IF
"then"     THEN
"else"     ELSE


"structure" STRUCTURE
"signature" SIGNATURE
"struct"   STRUCT
"sig"       SIG
"let"      LET
"in"       IN
"end"      END
"functor"  FUNCTOR
"where"    WHERE
"include"  INCLUDE
"open"     OPEN
"constraint" CONSTRAINT
"constraints" CONSTRAINTS
"export"   EXPORT
"table"    TABLE
"sequence" SEQUENCE
"view"     VIEW
"ensure_index" INDEX
"class"    CLASS
"cookie"   COOKIE
"style"    STYLE
"task"     TASK
"policy"   POLICY
"ffi"      FFI

"SELECT"   SELECT
"DISTINCT" DISTINCT
"FROM"     FROM
"AS"       AS
"WHERE"    CWHERE
"SQL"      SQL
"GROUP"    GROUP
"ORDER"    ORDER
"BY"       BY
"HAVING"   HAVING
"LIMIT"    LIMIT
"OFFSET"   OFFSET
"ALL"      ALL
"SELECT1"  SELECT1

"JOIN"     JOIN
"INNER"    INNER
"CROSS"    CROSS
"OUTER"    OUTER
"LEFT"     LEFT
"RIGHT"    RIGHT
"FULL"     FULL

"UNION"    UNION
"INTERSECT" INTERSECT
"EXCEPT"   EXCEPT

"TRUE"     TRUE
"FALSE"    FALSE
"AND"      CAND
"OR"       OR
"NOT"      NOT

"COUNT"    COUNT
"AVG"      AVG
"SUM"      SUM
"MIN"      MIN
"MAX"      MAX
"RANK"     RANK
"PARTITION" PARTITION
"OVER"     OVER

"IF"       CIF
"THEN"     CTHEN
"ELSE"     CELSE

"ASC"      ASC
"DESC"     DESC
"RANDOM"   RANDOM

"INSERT"   INSERT
"INTO"     INTO
"VALUES"   VALUES
"UPDATE"   UPDATE
"SET"      SET
"DELETE"   DELETE
"NULL"     NULL
"IS"       IS
"COALESCE" COALESCE
"LIKE"     LIKE
"<->"      DISTANCE

"CONSTRAINT" CCONSTRAINT
"UNIQUE"   UNIQUE
"CHECK"    CHECK
"PRIMARY"  PRIMARY
"FOREIGN"  FOREIGN
"KEY"      KEY
"ON"       ON
"NO"       NO
"ACTION"   ACTION
"RESTRICT" RESTRICT
"CASCADE"  CASCADE
"REFERENCES" REFERENCES

"CURRENT_TIMESTAMP" CURRENT_TIMESTAMP

BEGIN_TAG	BEGIN_TAG
END_TAG	END_TAG
INDEX	INDEX
INTERSECT	INTERSECT
NOTAGS	NOTAGS
PARTITION	PARTITION
SIGNATURE	SIGNATURE
STRUCTURE	STRUCTURE

"_LOC_" STRING

"<"{xmlid}"/>"	XML_BEGIN_END
"<"{xmlid}">"<>XML>	XML_BEGIN
<XML> {
	"<"{xmlid}<XMLTAG>	BEGIN_TAG
	"</"{xmlid}">"<<>	XML_END
	{notags}    NOTAGS
	"(" NOTAGS
	"{"<>XMLCODE> LBRACE
	{ws}+  skip()
	"<!--"<>XMLCOMMENT>
}

<XMLCODE>{
    "}"<<> RBRACE
    "{"<>XMLCODE> skip()
    [^{}]+  STRING //FIXME
}

<XMLCOMMENT>{
    "-->"<<>    skip()
    .|\n<.>
}

<XMLTAG> {
	{xmlid}	SYMBOL
	"="	EQ
	{intconst}	INT
	{realconst}	FLOAT
	{str}	STRING
	"/"	DIVIDE
	">"<XML>	GT
	{ws}+<.>
	"{"<>XMLCODE>	LBRACE
	"("<INITIAL>	LPAREN
}

"#"{str}	CHAR
{str}	STRING

{id}       SYMBOL
{cid}      CSYMBOL

{hexconst}  INT

{intconst}  INT
{realconst} FLOAT

%%

