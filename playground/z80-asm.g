//From: https://github.com/BenHanson/z80_assembler

%token A ADD ADC AF AF_PRIME AND B BC Binary BIT C CALL CCF Char CP CPD
%token CPDR CPI CPIR CPL D DAA DB DS DW DE DEC DI DJNZ E EI EQU EX EXX F H
%token HALT Hex HL Integer I IM IN INC IND INDR INI INIR IX IXh IXl
%token IY IYh IYl JP JR L LD LDD LDDR LDI LDIR M Name NC NEG NL NOP NZ OR
%token ORG OTDR OTIR OUT OUTD OUTI P PE PO PUSH POP R RES RET RETI RETN
%token RL RLA RLC RLCA RLD RR RRA RRC RRCA RRD RST SBC SCF SET SLA SLL SP
%token SRA SRL String SUB UMINUS XOR Z

%left '|' '&'
%left '+' '-'
%left '*' '/'
%precedence UMINUS

%%

mnemonics : line NL
	| mnemonics line NL ;
line : %empty | data ;
line : Name EQU full_expr ;
line : ORG integer ;
line : opcode ;
line : label opt_colon opt_opcode_data ;
label : Name ;
opt_colon : %empty | ':' ;
opt_opcode_data : %empty | data ;
opt_opcode_data : opcode ;
data : DB db_list ;
data : DS integer ;
data : DW dw_list ;
db_list : full_expr ;
db_list : String ;
db_list : db_list ',' full_expr ;
db_list : db_list ',' String ;
dw_list : full_expr ;
dw_list : dw_list ',' full_expr ;
opcode : LD r ',' r2 ;
opcode : LD r ',' IXh ;
opcode : LD r ',' IXl ;
opcode : LD r ',' IYh ;
opcode : LD r ',' IYl ;
opcode : LD r ',' expr ;
opcode : LD IXh ',' full_expr ;
opcode : LD IXl ',' full_expr ;
opcode : LD IYh ',' full_expr ;
opcode : LD IYl ',' full_expr ;
opcode : LD r ',' '(' HL ')' ;
opcode : LD r ',' '(' IX plus_minus expr ')' ;
opcode : LD r ',' '(' IY plus_minus expr ')' ;
opcode : LD '(' HL ')' ',' r ;
opcode : LD '(' IX plus_minus expr ')' ',' r ;
opcode : LD '(' IY plus_minus expr ')' ',' r ;
opcode : LD '(' HL ')' ',' full_expr ;
opcode : LD '(' IX plus_minus expr ')' ',' full_expr ;
opcode : LD '(' IY plus_minus expr ')' ',' full_expr ;
// Only A register is legal
opcode : LD r ',' '(' BC ')' ;
// Only A register is legal
opcode : LD r ',' '(' DE ')' ;
// Only A register is legal
opcode : LD r ',' '(' expr ')' ;
opcode : LD '(' BC ')' ',' A ;
opcode : LD '(' DE ')' ',' A ;
opcode : LD '(' expr ')' ',' A ;
// Only A register is legal
opcode : LD r ',' I ;
// Only A register is legal
opcode : LD r ',' R ;
opcode : LD I ',' A ;
opcode : LD R ',' A ;
opcode : LD dd ',' expr ;
opcode : LD IX ',' expr ;
opcode : LD IXh ',' r ;
opcode : LD IXh ',' IXh ;
opcode : LD IXh ',' IXl ;
opcode : LD IXl ',' r ;
opcode : LD IXl ',' IXh ;
opcode : LD IXl ',' IXl ;
opcode : LD IY ',' expr ;
opcode : LD IYh ',' r ;
opcode : LD IYh ',' IYh ;
opcode : LD IYh ',' IYl ;
opcode : LD IYl ',' r ;
opcode : LD IYl ',' IYh ;
opcode : LD IYl ',' IYl ;
opcode : LD dd ',' '(' expr ')' ;
opcode : LD IX ',' '(' expr ')' ;
opcode : LD IY ',' '(' expr ')' ;
opcode : LD '(' expr ')' ',' dd ;
opcode : LD '(' expr ')' ',' IX ;
opcode : LD '(' expr ')' ',' IY ;
// Only SP register is legal
opcode : LD dd ',' HL ;
// Only SP register is legal
opcode : LD dd ',' IX ;
// Only SP register is legal
opcode : LD dd ',' IY ;
opcode : PUSH qq ;
opcode : PUSH IX ;
opcode : PUSH IY ;
opcode : POP qq ;
opcode : POP IX ;
opcode : POP IY ;
opcode : EX DE ',' HL ;
opcode : EX AF ',' AF_PRIME ;
opcode : EXX ;
opcode : EX '(' SP ')' ',' HL ;
opcode : EX '(' SP ')' ',' IX ;
opcode : EX '(' SP ')' ',' IY ;
opcode : LDI ;
opcode : LDIR ;
opcode : LDD ;
opcode : LDDR ;
opcode : CPI ;
opcode : CPIR ;
opcode : CPD ;
opcode : CPDR ;
opcode : ADD A ',' r ;
opcode : ADD A ',' IXh ;
opcode : ADD A ',' IXl ;
opcode : ADD A ',' IYh ;
opcode : ADD A ',' IYl ;
opcode : ADD A ',' expr ;
opcode : ADD A ',' '(' HL ')' ;
opcode : ADD A ',' '(' IX plus_minus expr ')' ;
opcode : ADD A ',' '(' IY plus_minus expr ')' ;
opcode : ADC A ',' r ;
opcode : ADC A ',' IXh ;
opcode : ADC A ',' IXl ;
opcode : ADC A ',' IYh ;
opcode : ADC A ',' IYl ;
opcode : ADC A ',' expr ;
opcode : ADC A ',' '(' HL ')' ;
opcode : ADC A ',' '(' IX plus_minus expr ')' ;
opcode : ADC A ',' '(' IY plus_minus expr ')' ;
opcode : SUB r ;
opcode : SUB IXh ;
opcode : SUB IXl ;
opcode : SUB IYh ;
opcode : SUB IYl ;
opcode : SUB expr ;
opcode : SUB '(' HL ')' ;
opcode : SUB '(' IX plus_minus expr ')' ;
opcode : SUB '(' IY plus_minus expr ')' ;
opcode : SBC A ',' r ;
opcode : SBC A ',' IXh ;
opcode : SBC A ',' IXl ;
opcode : SBC A ',' IYh ;
opcode : SBC A ',' IYl ;
opcode : SBC A ',' expr ;
opcode : SBC A ',' '(' HL ')' ;
opcode : SBC A ',' '(' IX plus_minus expr ')' ;
opcode : SBC A ',' '(' IY plus_minus expr ')' ;
opcode : AND r ;
opcode : AND IXh ;
opcode : AND IXl ;
opcode : AND IYh ;
opcode : AND IYl ;
opcode : AND expr ;
opcode : AND '(' HL ')' ;
opcode : AND '(' IX plus_minus expr ')' ;
opcode : AND '(' IY plus_minus expr ')' ;
opcode : OR r ;
opcode : OR IXh ;
opcode : OR IXl ;
opcode : OR IYh ;
opcode : OR IYl ;
opcode : OR expr ;
opcode : OR '(' HL ')' ;
opcode : OR '(' IX plus_minus expr ')' ;
opcode : OR '(' IY plus_minus expr ')' ;
opcode : XOR r ;
opcode : XOR IXh ;
opcode : XOR IXl ;
opcode : XOR IYh ;
opcode : XOR IYl ;
opcode : XOR expr ;
opcode : XOR '(' HL ')' ;
opcode : XOR '(' IX plus_minus expr ')' ;
opcode : XOR '(' IY plus_minus expr ')' ;
opcode : CP r ;
opcode : CP IXh ;
opcode : CP IXl ;
opcode : CP IYh ;
opcode : CP IYl ;
opcode : CP full_expr ;
opcode : CP '(' HL ')' ;
opcode : CP '(' IX plus_minus expr ')' ;
opcode : CP '(' IY plus_minus expr ')' ;
opcode : INC r ;
opcode : INC IXh ;
opcode : INC IXl ;
opcode : INC IYh ;
opcode : INC IYl ;
opcode : INC '(' HL ')' ;
opcode : INC '(' IX plus_minus expr ')' ;
opcode : INC '(' IY plus_minus expr ')' ;
opcode : DEC r ;
opcode : DEC IXh ;
opcode : DEC IXl ;
opcode : DEC IYh ;
opcode : DEC IYl ;
opcode : DEC '(' HL ')' ;
opcode : DEC '(' IX plus_minus expr ')' ;
opcode : DEC '(' IY plus_minus expr ')' ;
opcode : DAA ;
opcode : CPL ;
opcode : NEG ;
opcode : CCF ;
opcode : SCF ;
opcode : NOP ;
opcode : HALT ;
opcode : DI ;
opcode : EI ;
// Integer can be 0, 1, 2
opcode : IM Integer ;
opcode : ADD HL ',' dd ;
opcode : ADC HL ',' dd ;
opcode : SBC HL ',' dd ;
opcode : ADD IX ',' pp ;
opcode : ADD IY ',' rr ;
opcode : INC dd ;
opcode : INC IX ;
opcode : INC IY ;
opcode : DEC dd ;
opcode : DEC IX ;
opcode : DEC IY ;
opcode : RLA ;
opcode : RLCA ;
opcode : RRCA ;
opcode : RRC '(' IX plus_minus expr ')' ',' r ;
opcode : RRC '(' IY plus_minus expr ')' ',' r ;
opcode : RR '(' IX plus_minus expr ')' ',' r ;
opcode : RR '(' IY plus_minus expr ')' ',' r ;
opcode : RRA ;
opcode : RLC r ;
opcode : RLC '(' HL ')' ;
opcode : RLC '(' IX plus_minus expr ')' ;
opcode : RLC '(' IX plus_minus expr ')' ',' r ;
opcode : RLC '(' IY plus_minus expr ')' ;
opcode : RLC '(' IY plus_minus expr ')' ',' r ;
opcode : RL r ;
opcode : RL '(' HL ')' ;
opcode : RL '(' IX plus_minus expr ')' ;
opcode : RL '(' IX plus_minus expr ')' ',' r ;
opcode : RL '(' IY plus_minus expr ')' ;
opcode : RL '(' IY plus_minus expr ')' ',' r ;
opcode : RRC r ;
opcode : RRC '(' HL ')' ;
opcode : RRC '(' IX plus_minus expr ')' ;
opcode : RRC '(' IY plus_minus expr ')' ;
opcode : RR r ;
opcode : RR '(' HL ')' ;
opcode : RR '(' IX plus_minus expr ')' ;
opcode : RR '(' IY plus_minus expr ')' ;
opcode : SLA r ;
opcode : SLA '(' HL ')' ;
opcode : SLA '(' IX plus_minus expr ')' ;
opcode : SLA '(' IX plus_minus expr ')' ',' r ;
opcode : SLA '(' IY plus_minus expr ')' ;
opcode : SLA '(' IY plus_minus expr ')' ',' r ;
opcode : SLL r ;
opcode : SLL '(' HL ')' ;
opcode : SLL '(' IX plus_minus expr ')' ;
opcode : SLL '(' IX plus_minus expr ')' ',' r ;
opcode : SLL '(' IY plus_minus expr ')' ;
opcode : SLL '(' IY plus_minus expr ')' ',' r ;
opcode : SRA r ;
opcode : SRA '(' HL ')' ;
opcode : SRA '(' IX plus_minus expr ')' ;
opcode : SRA '(' IX plus_minus expr ')' ',' r ;
opcode : SRA '(' IY plus_minus expr ')' ;
opcode : SRA '(' IY plus_minus expr ')' ',' r ;
opcode : SRL r ;
opcode : SRL '(' HL ')' ;
opcode : SRL '(' IX plus_minus expr ')' ;
opcode : SRL '(' IX plus_minus expr ')' ',' r ;
opcode : SRL '(' IY plus_minus expr ')' ;
opcode : SRL '(' IY plus_minus expr ')' ',' r ;
opcode : RLD ;
opcode : RRD ;
// Bit is 0-7
opcode : BIT integer ',' r ;
// Bit is 0-7
opcode : BIT integer ',' '(' HL ')' ;
// Bit is 0-7
opcode : BIT integer ',' '(' IX plus_minus expr ')' ;
// Bit is 0-7
opcode : BIT integer ',' '(' IX plus_minus expr ')' ',' r ;
// Bit is 0-7
opcode : BIT integer ',' '(' IY plus_minus expr ')' ;
// Bit is 0-7
opcode : BIT integer ',' '(' IY plus_minus expr ')' ',' r ;
// Bit is 0-7
opcode : SET integer ',' r ;
// Bit is 0-7
opcode : SET integer ',' '(' HL ')' ;
// Bit is 0-7
opcode : SET integer ',' '(' IX plus_minus expr ')' ;
// Bit is 0-7
opcode : SET integer ',' '(' IX plus_minus expr ')' ',' r ;
// Bit is 0-7
opcode : SET integer ',' '(' IY plus_minus expr ')' ;
// Bit is 0-7
opcode : SET integer ',' '(' IY plus_minus expr ')' ',' r ;
// Bit is 0-7
opcode : RES integer ',' r ;
// Bit is 0-7
opcode : RES integer ',' '(' HL ')' ;
// Bit is 0-7
opcode : RES integer ',' '(' IX plus_minus expr ')' ;
// Bit is 0-7
opcode : RES integer ',' '(' IX plus_minus expr ')' ',' r ;
// Bit is 0-7
opcode : RES integer ',' '(' IY plus_minus expr ')' ;
// Bit is 0-7
opcode : RES integer ',' '(' IY plus_minus expr ')' ',' r ;
opcode : JP expr ;
opcode : JP cc ',' full_expr ;
opcode : JR full_expr ;
opcode : JR c ',' full_expr ;
opcode : JP '(' HL ')' ;
opcode : JP '(' IX ')' ;
opcode : JP '(' IY ')' ;
opcode : DJNZ full_expr ;
opcode : CALL full_expr ;
opcode : CALL cc ',' full_expr ;
opcode : RET ;
opcode : RET cc ;
opcode : RETI ;
opcode : RETN ;
// Integer is 0-7
opcode : RST integer ;
// Only A register is legal
opcode : IN r ',' '(' expr ')' ;
opcode : IN F ',' '(' C ')' ;
opcode : IN '(' C ')' ;
opcode : IN r ',' '(' C ')' ;
opcode : INI ;
opcode : INIR ;
opcode : IND ;
opcode : INDR ;
opcode : OUT '(' expr ')' ',' A ;
opcode : OUT '(' C ')' ',' integer ;
opcode : OUT '(' C ')' ',' r ;
opcode : OUTI ;
opcode : OTIR ;
opcode : OUTD ;
opcode : OTDR ;
plus_minus : '+' ;
plus_minus : '-' ;
r : A ;
r : B ;
r : C ;
r : D ;
r : E ;
r : H ;
r : L ;
r2 : A ;
r2 : B ;
r2 : C ;
r2 : D ;
r2 : E ;
r2 : H ;
r2 : L ;
dd : BC ;
dd : DE ;
dd : HL ;
dd : SP ;
qq : BC ;
qq : DE ;
qq : HL ;
qq : AF ;
pp : BC ;
pp : DE ;
pp : IX ;
rr : BC ;
rr : DE ;
rr : IY ;
rr : SP ;
cc : NZ ;
cc : Z ;
cc : NC ;
cc : C ;
cc : PO ;
cc : PE ;
cc : P ;
cc : M ;
c : C ;
c : NC ;
c : Z ;
c : NZ ;

expr : expr '|' expr
	| expr '&' expr
	| expr '+' expr
	| expr '-' expr
	| expr '*' expr
	| expr '/' expr
	| '-' expr %prec UMINUS
	| item ;
full_expr : full_expr '|' full_expr
	| full_expr '&' full_expr
	| full_expr '+' full_expr
	| full_expr '-' full_expr
	| full_expr '*' full_expr
	| full_expr '/' full_expr
	| '(' full_expr ')'
	| '-' full_expr %prec UMINUS
	| item ;
item : Name
	| Binary
	| Hex
	| Char
	| Integer ;

integer : Binary ;
integer : Hex ;

integer : Char ;
integer : Integer ;

%%

%%

[(]	'('
[)]	')'
[|]	'|'
&	'&'
[+]	'+'
-	'-'
[*]	'*'
[/]	'/'
,	','
:	':'
[.]?ORG	ORG
A	A
ADC	ADC
ADD	ADD
AF	AF
AF'	AF_PRIME
AND	AND
B	B
BC	BC
BIT	BIT
C	C
CALL	CALL
CCF	CCF
CP	CP
CPD	CPD
CPDR	CPDR
CPI	CPI
CPIR	CPIR
CPL	CPL
D	D
DB|DEFB|DEFM	DB
DS|DEFS	DS
DW|DEFW	DW
DAA	DAA
DE	DE
DEC	DEC
DI	DI
DJNZ	DJNZ
E	E
EI	EI
EQU	EQU
EX	EX
EXX	EXX
F	F
H	H
HALT	HALT
HL	HL
I	I
IM	IM
IN	IN
INC	INC
IND	IND
INDR	INDR
INI	INI
INIR	INIR
IX	IX
IXH	IXh
IXL	IXl
IY	IY
IYH	IYh
IYL	IYl
JP	JP
JR	JR
L	L
LD	LD
LDD	LDD
LDDR	LDDR
LDI	LDI
LDIR	LDIR
M	M
NC	NC
NEG	NEG
NOP	NOP
NZ	NZ
OR	OR
OTDR	OTDR
OTIR	OTIR
OUT	OUT
OUTD	OUTD
OUTI	OUTI
P	P
PE	PE
PO	PO
POP	POP
PUSH	PUSH
R	R
RES	RES
RET	RET
RETI	RETI
RETN	RETN
RL	RL
RLA	RLA
RLC	RLC
RLCA	RLCA
RLD	RLD
RR	RR
RRA	RRA
RRC	RRC
RRCA	RRCA
RRD	RRD
RST	RST
SBC	SBC
SCF	SCF
SET	SET
SLA	SLA
SLL	SLL
SP	SP
SRA	SRA
SRL	SRL
SUB	SUB
XOR	XOR
Z	Z
%[01]{8}|[01]{8}b	Binary
[&$][0-9A-Fa-f]+|[0-9A-Fa-f]+[hH]	Hex
'(\\([abefnrtvx\\'"?]|\d{3}|x[\da-f]{2})|[^\\'])'	Char
\d+	Integer
'[^'\r\n]{2,}'|\"[^"\r\n]+\"	String
[A-Z_a-z][0-9A-Z_a-z]*	Name
[ \t]+|;.*|[/][*](?s:.)*?[*][/]	skip()
\r?\n	NL

%%
