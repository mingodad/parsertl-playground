//From: https://github.com/grame-cncm/faust/blob/c861af641d1fee280a0632b00b42fdff6ca8079f/compiler/parser/faustparser.y
/* Parser for the Faust language */

%x comment
%x doc
%x lst

/*Tokens*/
%token SPLIT
%token MIX
%token SEQ
%token PAR
%token REC
%token LT
%token LE
%token EQ
%token GT
%token GE
%token NE
%token ADD
%token SUB
%token OR
%token MUL
%token DIV
%token MOD
%token AND
%token XOR
%token LSH
%token RSH
%token POWOP
%token FDELAY
%token DELAY1
%token MEM
%token PREFIX
%token INTCAST
%token FLOATCAST
%token NOTYPECAST
%token FFUNCTION
%token FCONSTANT
%token FVARIABLE
%token BUTTON
%token CHECKBOX
%token VSLIDER
%token HSLIDER
%token NENTRY
%token VGROUP
%token HGROUP
%token TGROUP
%token HBARGRAPH
%token VBARGRAPH
%token SOUNDFILE
%token ATTACH
%token ACOS
%token ASIN
%token ATAN
%token ATAN2
%token COS
%token SIN
%token TAN
%token EXP
%token LOG
%token LOG10
%token POWFUN
%token SQRT
%token ABS
%token MIN
%token MAX
%token FMOD
%token REMAINDER
%token FLOOR
%token CEIL
%token RINT
%token ROUND
%token RDTBL
%token RWTBL
%token SELECT2
%token SELECT3
%token INT
%token FLOAT
%token LAMBDA
%token DOT
%token WIRE
%token CUT
%token ENDDEF
//%token VIRG
%token LPAR
%token RPAR
%token LBRAQ
%token RBRAQ
%token LCROC
%token RCROC
%token WITH
%token LETREC
%token WHERE
%token DEF
%token IMPORT
%token COMPONENT
%token LIBRARY
%token ENVIRONMENT
%token WAVEFORM
%token ROUTE
%token ENABLE
%token CONTROL
%token IPAR
%token ISEQ
%token ISUM
%token IPROD
%token INPUTS
%token OUTPUTS
%token STRING
%token FSTRING
%token IDENT
//%token EXTRA
%token DECLARE
%token CASE
%token ARROW
%token ASSERTBOUNDS
%token LOWEST
%token HIGHEST
%token FLOATMODE
%token DOUBLEMODE
%token QUADMODE
%token FIXEDPOINTMODE
%token BDOC
%token EDOC
%token BEQN
%token EEQN
%token BDGM
%token EDGM
%token BLST
%token ELST
%token BMETADATA
%token EMETADATA
%token DOCCHAR
%token NOTICE
//%token LISTING
%token LSTTRUE
%token LSTFALSE
%token LSTDEPENDENCIES
%token LSTMDOCTAGS
%token LSTDISTRIBUTED
%token LSTEQ
%token LSTQ

%left /*1*/ WITH
%left /*2*/ LETREC
%right /*3*/ SPLIT MIX
%right /*4*/ SEQ
%right /*5*/ PAR
%left /*6*/ REC
%left /*7*/ LT LE EQ GT GE NE
%left /*8*/ ADD SUB OR
%left /*9*/ MUL DIV MOD AND XOR LSH RSH
%left /*10*/ POWOP
%left /*11*/ FDELAY
%left /*12*/ DELAY1
%left /*13*/ DOT
%left /*14*/ LPAR
%left /*15*/ LCROC

%start program

%%

program :
	stmtlist
	;

stmtlist :
	/*empty*/
	| stmtlist variantlist statement
	;

deflist :
	/*empty*/
	| deflist variantlist definition
	;

variantlist :
	/*empty*/
	| variantlist variant
	;

variant :
	FLOATMODE
	| DOUBLEMODE
	| QUADMODE
	| FIXEDPOINTMODE
	;

reclist :
	/*empty*/
	| reclist recinition
	;

vallist :
	number
	| vallist PAR /*5R*/ number
	;

number :
	INT
	| FLOAT
	| ADD /*8L*/ INT
	| ADD /*8L*/ FLOAT
	| SUB /*8L*/ INT
	| SUB /*8L*/ FLOAT
	;

statement :
	IMPORT LPAR /*14L*/ uqstring RPAR ENDDEF
	| DECLARE name string ENDDEF
	| DECLARE name name string ENDDEF
	| definition
	| BDOC doc EDOC
	;

doc :
	/*empty*/
	| doc docelem
	;

docelem :
	doctxt
	| doceqn
	| docdgm
	| docntc
	| doclst
	| docmtd
	;

doctxt :
	/*empty*/
	| doctxt DOCCHAR
	;

doceqn :
	BEQN expression EEQN
	;

docdgm :
	BDGM expression EDGM
	;

docntc :
	NOTICE
	;

doclst :
	BLST lstattrlist ELST
	;

lstattrlist :
	/*empty*/
	| lstattrlist lstattrdef
	;

lstattrdef :
	LSTDEPENDENCIES LSTEQ LSTQ lstattrval LSTQ
	| LSTMDOCTAGS LSTEQ LSTQ lstattrval LSTQ
	| LSTDISTRIBUTED LSTEQ LSTQ lstattrval LSTQ
	;

lstattrval :
	LSTTRUE
	| LSTFALSE
	;

docmtd :
	BMETADATA name EMETADATA
	;

definition :
	defname LPAR /*14L*/ arglist RPAR DEF expression ENDDEF
	| defname DEF expression ENDDEF
	//| error ENDDEF
	;

recinition :
	recname DEF expression ENDDEF
	//| error ENDDEF
	;

defname :
	ident
	;

recname :
	DELAY1 /*12L*/ ident
	;

params :
	ident
	| params PAR /*5R*/ ident
	;

expression :
	expression WITH /*1L*/ LBRAQ deflist RBRAQ
	| expression LETREC /*2L*/ LBRAQ reclist RBRAQ
	| expression LETREC /*2L*/ LBRAQ reclist WHERE deflist RBRAQ
	| expression PAR /*5R*/ expression
	| expression SEQ /*4R*/ expression
	| expression SPLIT /*3R*/ expression
	| expression MIX /*3R*/ expression
	| expression REC /*6L*/ expression
	| infixexp
	;

infixexp :
	infixexp ADD /*8L*/ infixexp
	| infixexp SUB /*8L*/ infixexp
	| infixexp MUL /*9L*/ infixexp
	| infixexp DIV /*9L*/ infixexp
	| infixexp MOD /*9L*/ infixexp
	| infixexp POWOP /*10L*/ infixexp
	| infixexp FDELAY /*11L*/ infixexp
	| infixexp DELAY1 /*12L*/
	| infixexp DOT /*13L*/ ident
	| infixexp AND /*9L*/ infixexp
	| infixexp OR /*8L*/ infixexp
	| infixexp XOR /*9L*/ infixexp
	| infixexp LSH /*9L*/ infixexp
	| infixexp RSH /*9L*/ infixexp
	| infixexp LT /*7L*/ infixexp
	| infixexp LE /*7L*/ infixexp
	| infixexp GT /*7L*/ infixexp
	| infixexp GE /*7L*/ infixexp
	| infixexp EQ /*7L*/ infixexp
	| infixexp NE /*7L*/ infixexp
	| infixexp LPAR /*14L*/ arglist RPAR
	| infixexp LCROC /*15L*/ deflist RCROC
	| primitive
	;

primitive :
	INT
	| FLOAT
	| ADD /*8L*/ INT
	| ADD /*8L*/ FLOAT
	| SUB /*8L*/ INT
	| SUB /*8L*/ FLOAT
	| WIRE
	| CUT
	| MEM
	| PREFIX
	| INTCAST
	| FLOATCAST
	| ADD /*8L*/
	| SUB /*8L*/
	| MUL /*9L*/
	| DIV /*9L*/
	| MOD /*9L*/
	| FDELAY /*11L*/
	| AND /*9L*/
	| OR /*8L*/
	| XOR /*9L*/
	| LSH /*9L*/
	| RSH /*9L*/
	| LT /*7L*/
	| LE /*7L*/
	| GT /*7L*/
	| GE /*7L*/
	| EQ /*7L*/
	| NE /*7L*/
	| ATTACH
	| ENABLE
	| CONTROL
	| ACOS
	| ASIN
	| ATAN
	| ATAN2
	| COS
	| SIN
	| TAN
	| EXP
	| LOG
	| LOG10
	| POWOP /*10L*/
	| POWFUN
	| SQRT
	| ABS
	| MIN
	| MAX
	| FMOD
	| REMAINDER
	| FLOOR
	| CEIL
	| RINT
	| ROUND
	| RDTBL
	| RWTBL
	| SELECT2
	| SELECT3
	| ASSERTBOUNDS
	| LOWEST
	| HIGHEST
	| ident
	| SUB /*8L*/ ident
	| LPAR /*14L*/ expression RPAR
	| LAMBDA LPAR /*14L*/ params RPAR DOT /*13L*/ LPAR /*14L*/ expression RPAR
	| CASE LBRAQ rulelist RBRAQ
	| ffunction
	| fconst
	| fvariable
	| COMPONENT LPAR /*14L*/ uqstring RPAR
	| LIBRARY LPAR /*14L*/ uqstring RPAR
	| ENVIRONMENT LBRAQ stmtlist RBRAQ
	| WAVEFORM LBRAQ vallist RBRAQ
	| ROUTE LPAR /*14L*/ argument PAR /*5R*/ argument RPAR
	| ROUTE LPAR /*14L*/ argument PAR /*5R*/ argument PAR /*5R*/ expression RPAR
	| button
	| checkbox
	| vslider
	| hslider
	| nentry
	| vgroup
	| hgroup
	| tgroup
	| vbargraph
	| hbargraph
	| soundfile
	| fpar
	| fseq
	| fsum
	| fprod
	| finputs
	| foutputs
	;

ident :
	IDENT
	;

name :
	IDENT
	;

arglist :
	argument
	| arglist PAR /*5R*/ argument
	;

argument :
	argument SEQ /*4R*/ argument
	| argument SPLIT /*3R*/ argument
	| argument MIX /*3R*/ argument
	| argument REC /*6L*/ argument
	| infixexp
	;

string :
	STRING
	;

uqstring :
	STRING
	;

fstring :
	STRING
	| FSTRING
	;

fpar :
	IPAR LPAR /*14L*/ ident PAR /*5R*/ argument PAR /*5R*/ expression RPAR
	;

fseq :
	ISEQ LPAR /*14L*/ ident PAR /*5R*/ argument PAR /*5R*/ expression RPAR
	;

fsum :
	ISUM LPAR /*14L*/ ident PAR /*5R*/ argument PAR /*5R*/ expression RPAR
	;

fprod :
	IPROD LPAR /*14L*/ ident PAR /*5R*/ argument PAR /*5R*/ expression RPAR
	;

finputs :
	INPUTS LPAR /*14L*/ expression RPAR
	;

foutputs :
	OUTPUTS LPAR /*14L*/ expression RPAR
	;

ffunction :
	FFUNCTION LPAR /*14L*/ signature PAR /*5R*/ fstring PAR /*5R*/ string RPAR
	;

fconst :
	FCONSTANT LPAR /*14L*/ type name PAR /*5R*/ fstring RPAR
	;

fvariable :
	FVARIABLE LPAR /*14L*/ type name PAR /*5R*/ fstring RPAR
	;

button :
	BUTTON LPAR /*14L*/ uqstring RPAR
	;

checkbox :
	CHECKBOX LPAR /*14L*/ uqstring RPAR
	;

vslider :
	VSLIDER LPAR /*14L*/ uqstring PAR /*5R*/ argument PAR /*5R*/ argument PAR /*5R*/ argument PAR /*5R*/ argument RPAR
	;

hslider :
	HSLIDER LPAR /*14L*/ uqstring PAR /*5R*/ argument PAR /*5R*/ argument PAR /*5R*/ argument PAR /*5R*/ argument RPAR
	;

nentry :
	NENTRY LPAR /*14L*/ uqstring PAR /*5R*/ argument PAR /*5R*/ argument PAR /*5R*/ argument PAR /*5R*/ argument RPAR
	;

vgroup :
	VGROUP LPAR /*14L*/ uqstring PAR /*5R*/ expression RPAR
	;

hgroup :
	HGROUP LPAR /*14L*/ uqstring PAR /*5R*/ expression RPAR
	;

tgroup :
	TGROUP LPAR /*14L*/ uqstring PAR /*5R*/ expression RPAR
	;

vbargraph :
	VBARGRAPH LPAR /*14L*/ uqstring PAR /*5R*/ argument PAR /*5R*/ argument RPAR
	;

hbargraph :
	HBARGRAPH LPAR /*14L*/ uqstring PAR /*5R*/ argument PAR /*5R*/ argument RPAR
	;

soundfile :
	SOUNDFILE LPAR /*14L*/ uqstring PAR /*5R*/ argument RPAR
	;

signature :
	type fun LPAR /*14L*/ typelist RPAR
	| type fun OR /*8L*/ fun LPAR /*14L*/ typelist RPAR
	| type fun OR /*8L*/ fun OR /*8L*/ fun LPAR /*14L*/ typelist RPAR
	| type fun OR /*8L*/ fun OR /*8L*/ fun OR /*8L*/ fun LPAR /*14L*/ typelist RPAR
	| type fun LPAR /*14L*/ RPAR
	| type fun OR /*8L*/ fun LPAR /*14L*/ RPAR
	| type fun OR /*8L*/ fun OR /*8L*/ fun LPAR /*14L*/ RPAR
	| type fun OR /*8L*/ fun OR /*8L*/ fun OR /*8L*/ fun LPAR /*14L*/ RPAR
	;

fun :
	IDENT
	;

typelist :
	argtype
	| typelist PAR /*5R*/ argtype
	;

rulelist :
	rule
	| rulelist rule
	;

rule :
	LPAR /*14L*/ arglist RPAR ARROW expression ENDDEF
	;

type :
	INTCAST
	| FLOATCAST
	;

argtype :
	INTCAST
	| FLOATCAST
	| NOTYPECAST
	;

%%

DIGIT    [0-9]
ID       [a-zA-Z_][_a-zA-Z0-9]*
LETTER   [a-zA-Z]
NUMBER   ({DIGIT}+"."{DIGIT}*|"."{DIGIT}+|{DIGIT}+)
WSPACE   [ \t\n]
TMACRO   \\{ID}(\[(\ *({ID}|{NUMBER}),?\ *)\])?(\{(\ *({ID}|{NUMBER}),?\ *)*\})*
NSID     {ID}("::"{ID})*

%%

"/*"<comment>
<comment>[^*\x0a\x0d]+        skip()  /* eat anything that's not a '*'         */
<comment>"*"+[^*/\x0a\x0d]*  skip()   /* eat up '*'s not followed by '/'s     */
<comment>\x0a\x0d           skip()    /* no need to increment yylineno here     */
<comment>\x0a              skip()     /* no need to increment yylineno here     */
<comment>\x0d              skip()     /* no need to increment yylineno here     */
<comment>"*"+"/"<INITIAL>	skip()

"<mdoc>"<doc>                        BDOC
<doc>.                          DOCCHAR /* char by char, may be slow ?? */
<doc>\n                         DOCCHAR /* keep newline chars */
<doc>"<notice/>"                NOTICE  /* autoclosing tag */
<doc>"<notice />"               NOTICE  /* autoclosing tag */
<doc>"<listing"<lst>                 BLST /* autoclosing tag */
<doc>"<equation>"<INITIAL>               BEQN
"</equation>"<doc>                   EEQN
<doc>"<diagram>"<INITIAL>                BDGM
"</diagram>"<doc>                    EDGM
<doc>"<metadata>"<INITIAL>               BMETADATA
"</metadata>"<doc>                   EMETADATA
<doc>"</mdoc>"<INITIAL>                  EDOC

<lst>"true"                     LSTTRUE
<lst>"false"                    LSTFALSE
<lst>"dependencies"             LSTDEPENDENCIES
<lst>"mdoctags"                 LSTMDOCTAGS
<lst>"distributed"              LSTDISTRIBUTED
<lst>"="                        LSTEQ
<lst>"\""                       LSTQ
<lst>"/>"<doc>                       ELST


{DIGIT}+            INT

{DIGIT}+"f"                             FLOAT
{DIGIT}+"."{DIGIT}*                     FLOAT
{DIGIT}+"."{DIGIT}*"f"                  FLOAT
{DIGIT}+"."{DIGIT}*e[-+]?{DIGIT}+       FLOAT
{DIGIT}+"."{DIGIT}*e[-+]?{DIGIT}+"f"    FLOAT
{DIGIT}+e[-+]?{DIGIT}+                  FLOAT
{DIGIT}+e[-+]?{DIGIT}+"f"               FLOAT
"."{DIGIT}+                             FLOAT
"."{DIGIT}+"f"                          FLOAT
"."{DIGIT}+e[-+]?{DIGIT}+               FLOAT
"."{DIGIT}+e[-+]?{DIGIT}+"f"            FLOAT

":"           SEQ
","           PAR
"<:"          SPLIT
"+>"          MIX
":>"          MIX
"~"           REC

"+"           ADD
"-"           SUB
"*"           MUL
"/"           DIV
"%"           MOD
"@"           FDELAY
"'"           DELAY1

"&"           AND
"|"           OR
"xor"         XOR

"<<"          LSH
">>"          RSH

"<"           LT
"<="          LE
">"           GT
">="          GE
"=="          EQ
"!="          NE

"_"           WIRE
"!"           CUT

";"           ENDDEF
"="           DEF
"("           LPAR
")"           RPAR
"{"           LBRAQ
"}"           RBRAQ
"["           LCROC
"]"           RCROC

"\\"          LAMBDA
"."           DOT
"with"        WITH
"letrec"      LETREC
"where"       WHERE

"mem"         MEM
"prefix"      PREFIX

"int"         INTCAST
"float"       FLOATCAST
"any"         NOTYPECAST

"rdtable"     RDTBL
"rwtable"     RWTBL

"select2"     SELECT2
"select3"     SELECT3

"ffunction"   FFUNCTION
"fconstant"   FCONSTANT
"fvariable"   FVARIABLE

"button"      BUTTON
"checkbox"    CHECKBOX
"vslider"     VSLIDER
"hslider"     HSLIDER
"nentry"      NENTRY
"vgroup"      VGROUP
"hgroup"      HGROUP
"tgroup"      TGROUP
"vbargraph"   VBARGRAPH
"hbargraph"   HBARGRAPH
"soundfile"   SOUNDFILE

"attach"      ATTACH

"acos"        ACOS
"asin"        ASIN
"atan"        ATAN
"atan2"       ATAN2

"cos"         COS
"sin"         SIN
"tan"         TAN

"exp"         EXP
"log"         LOG
"log10"       LOG10
"^"           POWOP
"pow"         POWFUN
"sqrt"        SQRT

"abs"         ABS
"min"         MIN
"max"         MAX

"fmod"        FMOD
"remainder"   REMAINDER

"floor"       FLOOR
"ceil"        CEIL
"rint"        RINT
"round"       ROUND

"seq"         ISEQ
"par"         IPAR
"sum"         ISUM
"prod"        IPROD

"inputs"      INPUTS
"outputs"     OUTPUTS

"import"      IMPORT
"component"   COMPONENT
"library"     LIBRARY
"environment" ENVIRONMENT

"waveform"    WAVEFORM
"route"       ROUTE
"enable"      ENABLE
"control"     CONTROL

"declare"     DECLARE

"case"        CASE
"=>"          ARROW

"assertbounds" ASSERTBOUNDS
"lowest"       LOWEST
"highest"       HIGHEST

"singleprecision" FLOATMODE
"doubleprecision" DOUBLEMODE
"quadprecision"   QUADMODE
"fixedpointprecision"    FIXEDPOINTMODE


"::"{NSID}       IDENT
{NSID}           IDENT

"\""[^\"]*"\""   STRING

"<"{LETTER}*"."{LETTER}">"    FSTRING
"<"{LETTER}*">"               FSTRING


"//"[^\x0a\x0d]*   skip() /* eat up one-line comments */

[ \t\x0a\x0d]+      skip() /* eat up whitespace */

//<<EOF>>   yyterminate();

//.  printf("extra text is : %s\n", yytext); return EXTRA;

%%
