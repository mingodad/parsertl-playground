//From: https://github.com/davidgiven/cowgol/blob/ec33ae1293df3937c6397575a0f7defb5e3b4a4d/src/cowfe/parser.y

%token  ASM ASSIGN BREAK CLOSEPAREN CLOSESQ COLON
%token  CONST DOT ELSE END EXTERN IF
%token  LOOP MINUS NOT OPENPAREN OPENSQ PERCENT
%token  PLUS RECORD RETURN SEMICOLON SLASH STAR
%token  SUB THEN TILDE VAR WHILE //TYPE
%token  OPENBR CLOSEBR ID NUMBER AT BYTESOF
%token  ELSEIF INT TYPEDEF SIZEOF STRING IMPL
%token  DECL INTERFACE COMMA AND OR PIPE
%token  CARET LTOP LEOP GTOP GEOP EQOP
%token  NEOP LSHIFT RSHIFT AS AMPERSAND NEXT
%token  PREV INDEXOF CONTINUE CASE IS WHEN
%token  ALIAS IMPLEMENTS INCLUDE

%left /*1*/ COMMA
%left /*2*/ AND
%left /*3*/ OR
%left /*4*/ PIPE
%left /*5*/ CARET
%nonassoc /*6*/ LTOP LEOP GTOP GEOP EQOP NEOP
%left /*7*/ LSHIFT RSHIFT
%left /*8*/ MINUS PLUS
%left /*9*/ PERCENT SLASH STAR
%left /*10*/ AS
%left /*11*/ AMPERSAND
%right /*12*/ NEXT PREV
%right /*13*/ NOT TILDE
%right /*14*/ BYTESOF INDEXOF
%right /*15*/ CLOSESQ OPENSQ
%right /*16*/ DOT

%start program

%%

program : statements ;

statements : /*empty*/ ;
statements : statements statement ;

statement : SEMICOLON ;
statement : RETURN SEMICOLON ;
statement : VAR newid COLON typeref SEMICOLON ;
statement : VAR newid COLON typeref ASSIGN expression SEMICOLON ;
statement : VAR newid ASSIGN expression SEMICOLON ;
statement : expression ASSIGN expression SEMICOLON ;
statement : startloopstatement statements END LOOP ;

statement : INCLUDE STRING SEMICOLON ;

startloopstatement : LOOP ;

statement : startwhilestatement statements END LOOP ;

initwhilestatement : WHILE ;

startwhilestatement : initwhilestatement conditional LOOP ;

statement : BREAK SEMICOLON ;
statement : CONTINUE SEMICOLON ;
statement : IF if_begin if_conditional THEN statements if_optional_else END IF ;

if_begin : /*empty*/ ;

if_conditional : conditional ;

if_optional_else : /*empty*/ ;
if_optional_else : if_else statements ;
if_optional_else : if_elseif if_conditional THEN statements if_optional_else ;

if_else : ELSE ;

if_elseif : ELSEIF ;

statement : startcase whens END CASE SEMICOLON ;

startcase : CASE expression IS ;

whens : /*empty*/ ;
whens : whens when ;

when : beginwhen statements ;

beginwhen : WHEN cvalue COLON ;
beginwhen : WHEN ELSE COLON ;

conditional : OPENPAREN conditional CLOSEPAREN ;
conditional : NOT /*13R*/ conditional ;
conditional : conditional AND /*2L*/ conditional ;
conditional : conditional OR /*3L*/ conditional ;
conditional : expression EQOP /*6N*/ expression ;
conditional : expression NEOP /*6N*/ expression ;
conditional : expression LTOP /*6N*/ expression ;
conditional : expression GEOP /*6N*/ expression ;
conditional : expression GTOP /*6N*/ expression ;
conditional : expression LEOP /*6N*/ expression ;

leafexpression : NUMBER ;
leafexpression : OPENPAREN expression CLOSEPAREN ;

expression : leafexpression ;
expression : MINUS /*8L*/ expression ;
expression : TILDE /*13R*/ expression ;
expression : expression PLUS /*8L*/ expression ;
expression : expression MINUS /*8L*/ expression ;
expression : expression STAR /*9L*/ expression ;
expression : expression SLASH /*9L*/ expression ;
expression : expression PERCENT /*9L*/ expression ;
expression : expression CARET /*5L*/ expression ;
expression : expression AMPERSAND /*11L*/ expression ;
expression : expression PIPE /*4L*/ expression ;
expression : expression LSHIFT /*7L*/ expression ;
expression : expression RSHIFT /*7L*/ expression ;
expression : expression AS /*10L*/ typeref ;
expression : AMPERSAND /*11L*/ expression ;
expression : ALIAS AMPERSAND /*11L*/ expression ;
expression : NEXT /*12R*/ expression ;
expression : PREV /*12R*/ expression ;
expression : BYTESOF /*14R*/ varortypeid ;
expression : SIZEOF varortypeid ;

leafexpression : oldid ;
leafexpression : OPENSQ /*15R*/ expression CLOSESQ /*15R*/ ;

expression : expression OPENSQ /*15R*/ expression CLOSESQ /*15R*/ ;
expression : expression DOT /*16R*/ ID ;

leafexpression : STRING ;

cvalue : expression ;

statement : CONST newid ASSIGN cvalue SEMICOLON ;

typeref : INT OPENPAREN cvalue COMMA /*1L*/ cvalue CLOSEPAREN ;
typeref : eitherid ;
typeref : OPENSQ /*15R*/ typeref CLOSESQ /*15R*/ ;
typeref : typeref OPENSQ /*15R*/ cvalue CLOSESQ /*15R*/ ;
typeref : typeref OPENSQ /*15R*/ CLOSESQ /*15R*/ ;
typeref : INDEXOF /*14R*/ varortypeid ;

statement : TYPEDEF ID IS typeref SEMICOLON ;

newid : ID ;

oldid : ID ;

eitherid : ID ;

varortypeid : oldid ;
varortypeid : OPENPAREN typeref CLOSEPAREN ;

expression : startsubcall inputargs ;

statement : startsubcall inputargs SEMICOLON ;
statement : outputargs ASSIGN startsubcall inputargs SEMICOLON ;

startsubcall : leafexpression ;

inputargs : OPENPAREN inputarglist CLOSEPAREN ;
inputargs : OPENPAREN CLOSEPAREN ;

inputarglist : inputarg ;
inputarglist : inputarglist COMMA /*1L*/ inputarg ;

inputarg : expression ;

outputargs : OPENPAREN outputarglist COMMA /*1L*/ outputarg CLOSEPAREN ;

outputarglist : outputarg ;
outputarglist : outputarglist COMMA /*1L*/ outputarg ;

outputarg : expression ;

statement : SUB newsubid subparams submodifiers substart statements subend SEMICOLON ;
statement : DECL SUB newsubid subparams submodifiers SEMICOLON ;
statement : subimpldecl substart statements subend SEMICOLON ;
statement : INTERFACE newsubid subparams submodifiers SEMICOLON ;
statement : implementsstart substart statements subend SEMICOLON ;

implementsstart : SUB newsubid IMPLEMENTS typeref ;

submodifiers : /*empty*/ ;
submodifiers : submodifiers EXTERN OPENPAREN STRING CLOSEPAREN ;

newsubid : newid ;

subimpldecl : IMPL SUB oldid ;

substart : IS ;

subend : END SUB ;

subparams : inparamlist ;
subparams : inparamlist COLON paramlist ;

inparamlist : paramlist ;

paramlist : OPENPAREN CLOSEPAREN ;
paramlist : OPENPAREN params CLOSEPAREN ;

params : param ;
params : param COMMA /*1L*/ params ;

param : ID COLON typeref ;

statement : RECORD recordstart recordinherits IS recordmembers END RECORD ;

recordstart : eitherid ;

recordinherits : /*empty*/ ;
recordinherits : COLON typeref ;

recordmembers : /*empty*/ ;
recordmembers : recordmember recordmembers ;

recordmember : memberid recordat COLON typeref SEMICOLON ;

recordat : /*empty*/ ;
recordat : AT OPENPAREN cvalue CLOSEPAREN ;

memberid : ID ;

statement : initdecl OPENBR initialisers CLOSEBR SEMICOLON ;

initdecl : VAR newid COLON typeref ASSIGN ;

initialisers : initialiser ;
initialisers : initialisers COMMA /*1L*/ initialiser ;

initialiser : /*empty*/ ;
initialiser : expression ;
initialiser : startbracedinitialiser initialisers CLOSEBR ;

startbracedinitialiser : OPENBR ;

statement : asmstart asms SEMICOLON ;

asmstart : ASM ;

asms : asm ;
asms : asm COMMA /*1L*/ asms ;

asm : STRING ;
asm : NUMBER ;
asm : oldid ;

%%

//%option caseless

%%

[\n\r\t ]+	skip()
"#".*	skip()

"@alias"	ALIAS
"&"	AMPERSAND
"and"	AND
"as"	AS
"@asm"	ASM
":="	ASSIGN
"@at"	AT
"break"	BREAK
"@bytesof"	BYTESOF
"^"	CARET
"case"	CASE
"}"	CLOSEBR
")"	CLOSEPAREN
"]"	CLOSESQ
":"	COLON
","	COMMA
"const"	CONST
"continue"	CONTINUE
"@decl"	DECL
"."	DOT
"else"	ELSE
"elseif"	ELSEIF
"end"	END
"=="	EQOP
"@extern"	EXTERN
">="	GEOP
">"	GTOP
"if"	IF
"@impl"	IMPL
"implements"	IMPLEMENTS
"include"	INCLUDE
"@indexof"	INDEXOF
"int"	INT
"interface"	INTERFACE
"is"	IS
"<="	LEOP
"loop"	LOOP
"<<"	LSHIFT
"<"	LTOP
"-"	MINUS
"!="	NEOP
"@next"	NEXT
"not"	NOT
"{"	OPENBR
"("	OPENPAREN
"["	OPENSQ
"or"	OR
"%"	PERCENT
"|"	PIPE
"+"	PLUS
"@prev"	PREV
"record"	RECORD
"return"	RETURN
">>"	RSHIFT
";"	SEMICOLON
"@sizeof"	SIZEOF
"/"	SLASH
"*"	STAR
"sub"	SUB
"then"	THEN
"~"	TILDE
"typedef"	TYPEDEF
"var"	VAR
"when"	WHEN
"while"	WHILE


[0-9]+	NUMBER
"0b"[01]+	NUMBER
"0o"[0-8]+	NUMBER
"0d"[0-9]+	NUMBER
"0x"[0-9A-Fa-f]+	NUMBER
'(\\.|[^'\n\r\\])'	NUMBER

\"(\\.|[^"\n\r\\])*\"	STRING

[A-Za-z_][A-Za-z0-9_]*	ID

%%
