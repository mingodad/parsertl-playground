%token  ID EDGEPT OF PLUS MINUS STAR
%token  SLASH PERCENT UMINUS EOL ASSIGN PLACENAME
%token  COLON ASSERT LP EQ RP DEFINE
%token  CODEBLOCK FILL COLOR THICKNESS PRINT STRING
%token  COMMA CLASSNAME LB RB UP DOWN
%token  LEFT RIGHT CLOSE CHOP FROM TO
%token  THEN HEADING GO AT WITH SAME
%token  AS FIT BEHIND UNTIL EVEN DOT_E
%token  HEIGHT WIDTH RADIUS DIAMETER DOTTED DASHED
%token  CW CCW LARROW RARROW LRARROW INVIS
%token  THICK THIN SOLID CENTER LJUST RJUST
%token  ABOVE BELOW ITALIC BOLD MONO ALIGNED
%token  BIG SMALL AND LT GT ON
%token  WAY BETWEEN THE NTH VERTEX TOP
%token  BOTTOM START END IN THIS DOT_U
%token  LAST NUMBER FUNC1 FUNC2 DIST DOT_XY
%token  X Y DOT_L

%left /*1*/ OF
%left /*2*/ PLUS MINUS
%left /*3*/ STAR SLASH PERCENT
%right /*4*/ UMINUS

%start document

%%

document : statement_list ;

statement_list : statement ;
statement_list : statement_list EOL statement ;

statement : /*empty*/ ;
statement : direction ;
statement : lvalue ASSIGN rvalue ;
statement : PLACENAME COLON unnamed_statement ;
statement : PLACENAME COLON position ;
statement : unnamed_statement ;
statement : print prlist ;
statement : ASSERT LP expr EQ expr RP ;
statement : ASSERT LP position EQ position RP ;
statement : DEFINE ID CODEBLOCK ;

lvalue : ID ;
lvalue : FILL ;
lvalue : COLOR ;
lvalue : THICKNESS ;

rvalue : expr ;
rvalue : PLACENAME ;

print : PRINT ;

prlist : pritem ;
prlist : prlist prsep pritem ;

pritem : FILL ;
pritem : COLOR ;
pritem : THICKNESS ;
pritem : rvalue ;
pritem : STRING ;

prsep : COMMA ;

unnamed_statement : basetype attribute_list ;

basetype : CLASSNAME ;
basetype : STRING textposition ;
basetype : LB savelist statement_list RB ;

savelist : /*empty*/ ;

direction : UP ;
direction : DOWN ;
direction : LEFT ;
direction : RIGHT ;

relexpr : expr ;
relexpr : expr PERCENT /*3L*/ ;

optrelexpr : relexpr ;
optrelexpr : /*empty*/ ;

attribute_list : relexpr alist ;
attribute_list : alist ;

alist : /*empty*/ ;
alist : alist attribute ;

attribute : numproperty relexpr ;
attribute : dashproperty expr ;
attribute : dashproperty ;
attribute : colorproperty rvalue ;
attribute : go direction optrelexpr ;
attribute : go direction even position ;
attribute : CLOSE ;
attribute : CHOP ;
attribute : FROM position ;
attribute : TO position ;
attribute : THEN ;
attribute : THEN optrelexpr HEADING expr ;
attribute : THEN optrelexpr EDGEPT ;
attribute : GO optrelexpr HEADING expr ;
attribute : GO optrelexpr EDGEPT ;
attribute : boolproperty ;
attribute : AT position ;
attribute : WITH withclause ;
attribute : SAME ;
attribute : SAME AS object ;
attribute : STRING textposition ;
attribute : FIT ;
attribute : BEHIND object ;

go : GO ;
go : /*empty*/ ;

even : UNTIL EVEN WITH ;
even : EVEN WITH ;

withclause : DOT_E edge AT position ;
withclause : edge AT position ;

numproperty : HEIGHT ;
numproperty : WIDTH ;
numproperty : RADIUS ;
numproperty : DIAMETER ;
numproperty : THICKNESS ;

dashproperty : DOTTED ;
dashproperty : DASHED ;

colorproperty : FILL ;
colorproperty : COLOR ;

boolproperty : CW ;
boolproperty : CCW ;
boolproperty : LARROW ;
boolproperty : RARROW ;
boolproperty : LRARROW ;
boolproperty : INVIS ;
boolproperty : THICK ;
boolproperty : THIN ;
boolproperty : SOLID ;

textposition : /*empty*/ ;
textposition : textposition CENTER ;
textposition : textposition LJUST ;
textposition : textposition RJUST ;
textposition : textposition ABOVE ;
textposition : textposition BELOW ;
textposition : textposition ITALIC ;
textposition : textposition BOLD ;
textposition : textposition MONO ;
textposition : textposition ALIGNED ;
textposition : textposition BIG ;
textposition : textposition SMALL ;

position : expr COMMA expr ;
position : place ;
position : place PLUS /*2L*/ expr COMMA expr ;
position : place MINUS /*2L*/ expr COMMA expr ;
position : place PLUS /*2L*/ LP expr COMMA expr RP ;
position : place MINUS /*2L*/ LP expr COMMA expr RP ;
position : LP position COMMA position RP ;
position : LP position RP ;
position : expr between position AND position ;
position : expr LT position COMMA position GT ;
position : expr ABOVE position ;
position : expr BELOW position ;
position : expr LEFT OF /*1L*/ position ;
position : expr RIGHT OF /*1L*/ position ;
position : expr ON HEADING EDGEPT OF /*1L*/ position ;
position : expr HEADING EDGEPT OF /*1L*/ position ;
position : expr EDGEPT OF /*1L*/ position ;
position : expr ON HEADING expr FROM position ;
position : expr HEADING expr FROM position ;

between : WAY BETWEEN ;
between : BETWEEN ;
between : OF /*1L*/ THE WAY BETWEEN ;

place : place2 ;
place : edge OF /*1L*/ object ;

place2 : object ;
place2 : object DOT_E edge ;
place2 : NTH VERTEX OF /*1L*/ object ;

edge : CENTER ;
edge : EDGEPT ;
edge : TOP ;
edge : BOTTOM ;
edge : START ;
edge : END ;
edge : RIGHT ;
edge : LEFT ;

object : objectname ;
object : nth ;
object : nth OF /*1L*/ object ;
object : nth IN object ;

objectname : THIS ;
objectname : PLACENAME ;
objectname : objectname DOT_U PLACENAME ;

nth : NTH CLASSNAME ;
nth : NTH LAST CLASSNAME ;
nth : LAST CLASSNAME ;
nth : LAST ;
nth : NTH LB RB ;
nth : NTH LAST LB RB ;
nth : LAST LB RB ;

expr : expr PLUS /*2L*/ expr ;
expr : expr MINUS /*2L*/ expr ;
expr : expr STAR /*3L*/ expr ;
expr : expr SLASH /*3L*/ expr ;
expr : MINUS /*2L*/ expr %prec UMINUS /*4R*/ ;
expr : PLUS /*2L*/ expr %prec UMINUS /*4R*/ ;
expr : LP expr RP ;
expr : LP FILL RP ;
expr : LP COLOR RP ;
expr : LP THICKNESS RP ;
expr : NUMBER ;
expr : ID ;
expr : FUNC1 LP expr RP ;
expr : FUNC2 LP expr COMMA expr RP ;
expr : DIST LP position COMMA position RP ;
expr : place2 DOT_XY X ;
expr : place2 DOT_XY Y ;
expr : object DOT_L numproperty ;
expr : object DOT_L dashproperty ;
expr : object DOT_L colorproperty ;

%%

dot_prop    [.][a-zA-Z]+

%%

[ \t\f\r]+	skip()
#[^\n]*	skip()
"/*"(?s:.)"*/"	skip()
\\[\n]  skip()  /* line continuation */

"above"	ABOVE
"abs"	FUNC1
"aligned"	ALIGNED
"and"	AND
"as"	AS
"assert"	ASSERT
"at"	AT
"behind"	BEHIND
"below"	BELOW
"between"	BETWEEN
"big"	BIG
"bold"	BOLD
"bot"	EDGEPT
"bottom"	BOTTOM
"c"	EDGEPT
"ccw"	CCW
"center"	CENTER
"chop"	CHOP
"close"	CLOSE
"color"	COLOR
"cos"	FUNC1
"cw"	CW
"dashed"	DASHED
"define"	DEFINE
"diameter"	DIAMETER
"dist"	DIST
"dotted"	DOTTED
"down"	DOWN
"e"	EDGEPT
"east"	EDGEPT
"end"	END
"even"	EVEN
"fill"	FILL
"first"	NTH
"fit"	FIT
"from"	FROM
"go"	GO
"heading"	HEADING
"height"	HEIGHT
"ht"	HEIGHT
"in"	IN
"int"	FUNC1
"invis"	INVIS
"invisible"	INVIS
"italic"	ITALIC
"last"{dot_prop}?	LAST
"left"	LEFT
"ljust"	LJUST
"max"	FUNC2
"min"	FUNC2
"n"	EDGEPT
"ne"	EDGEPT
"north"	EDGEPT
"nw"	EDGEPT
"of"	OF
"previous"{dot_prop}?	LAST
"print"	PRINT
"rad"	RADIUS
"radius"	RADIUS
"right"	RIGHT
"rjust"	RJUST
"s"	EDGEPT
"same"	SAME
"se"	EDGEPT
"sin"	FUNC1
"small"	SMALL
"solid"	SOLID
"south"	EDGEPT
"sqrt"	FUNC1
"start"	START
"sw"	EDGEPT
"t"	TOP
"the"	THE
"then"	THEN
"thick"	THICK
"thickness"	THICKNESS
"thin"	THIN
"this"	THIS
"to"	TO
"top"	TOP
"until"	UNTIL
"up"	UP
"vertex"	VERTEX
"w"	EDGEPT
"way"	WAY
"west"	EDGEPT
"wid"	WIDTH
"width"	WIDTH
"with"	WITH
"x"	X
"y"	Y

=	ASSIGN
\/	SLASH
\+	PLUS
\*	STAR
\%	PERCENT
\(	LP
\)	RP
\[	LB
\]	RB
,	COMMA
:	COLON
>	GT
==	EQ
-	MINUS
->|"&rarr;"|"&rightarrow;"	RARROW
\<	LT
\<->	LRARROW
\<-|"&larr;"|"&leftrightarrow;"	LARROW

"\n"	EOL
[A-Z][A-Z0-9]+{dot_prop}?	PLACENAME
"CODEBLOCK"	CODEBLOCK
("arc"|"arrow"|"box"|"circle"|"cylinder"|"dot"|"ellipse"|"file"|"line"|"move"|"oval"|"spline"|"text"|"[]"|"noop")(\.[a-zA-Z]+)?	CLASSNAME
"DOT_E"	DOT_E
"mono"	MONO
"on"	ON
"DOT_U"	DOT_U
"DOT_XY"	DOT_XY
"DOT_L"	DOT_L

[0-9]+(\.[0-9]*)?(in|"%")*	NUMBER
\"(\\.|[^\"\n\r\\])*\"	STRING

/* Order matter if identifier comes before keywords they are classified as identifier */
[$]?[a-z_][a-zA-Z0-9_]*	ID

%%
