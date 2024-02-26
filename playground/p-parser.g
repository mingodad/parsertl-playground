//From: https://github.com/p-org/P/blob/24f64b78677a4643bbcb4a9ae625d4daac0758fa/Src/PCompiler/CompilerCore/Parser/PParser.g4
//parser grammar PParser;
//options { tokenVocab=PLexer; }

// A small overview of ANTLRs parser rules:
//
// Parser rules begin with a lower case letter, lexer rules begin
// with an Uppercase letter. To create a parser rule, write the name
// followed by a colon (:) and then a list of alternatives, separated
// by pipe (|) characters. You can use parenthesis for sub-expressions,
// alternatives within those sub-expressions, and kleene * or + on any
// element in a rule.
//
// Every production rule corresponds to a class that gets generated
// in the target language for the ANTLR generator. If we use alternative
// labels, as in `type`, then subclasses of the rule-class will be created
// for each label. If one alternative is labelled, then they all must be.
// The purpose of labels is to call different functions in the generated
// listeners and visitors for the results of these productions.
//
// Lastly, ANTLR's DSL contains a feature that allows us to name the matched
// tokens and productions in an alternative (name=part) or collect multiple
// tokens or productions of the same type into a list (list+=part). The `type`
// production below uses this feature, too.

%token ADD
%token ANNOUNCE
%token ANY
%token AS
%token ASSERT
%token ASSIGN
%token ASSUME
%token BOOL
%token BoolLiteral
%token BREAK
%token CASE
%token CHOOSE
%token COLD
%token COLON
%token COMMA
%token COMPOSE
%token CONTINUE
%token CREATES
%token DATA
%token DEFAULT
%token DEFER
%token DIV
%token DO
%token DOT
%token ELSE
%token ENTRY
%token ENUM
%token EQ
%token EVENT
%token EVENTSET
%token EXIT
%token FAIRNONDET
%token FLOAT
%token FOREACH
%token FORMAT
%token FUN
%token GE
%token GOTO
%token GT
%token HALT
%token HIDEE
%token HIDEI
%token HOT
%token Iden
%token IF
%token IGNORE
%token IMPLEMENTATION
%token IN
%token INSERT
%token INT
%token INTERFACE
%token IntLiteral
%token KEYS
%token LAND
%token LBRACE
%token LBRACK
%token LE
%token LNOT
%token LOR
%token LPAREN
%token LT
%token MACHINE
%token MAIN
%token MAP
%token MOD
%token MODULE
%token MUL
%token NE
%token NEW
%token NONDET
%token NullLiteral
%token OBSERVES
%token ON
%token PRINT
%token RAISE
%token RARROW
%token RBRACE
%token RBRACK
%token RECEIVE
%token RECEIVES
%token REFINES
%token REMOVE
%token RENAME
%token RETURN
%token RPAREN
%token SEMI
%token SEND
%token SENDS
%token SEQ
%token SET
%token SIZEOF
%token SPEC
%token START
%token STATE
%token STRING
%token StringLiteral
%token SUB
%token TEST
%token THIS
%token TO
%token TYPE
%token UNION
%token VALUES
%token VAR
%token WHILE
%token WITH

%nonassoc IF_WITHOUT_ELSE
%nonassoc ELSE
%left  LOR
%left LAND
%nonassoc LNOT
%left LT GT GE LE IN
//%right /*5*/ ASSIGN_OP
%left ADD SUB
%left DIV MUL MOD
//%right /*8*/ '^'
%nonassoc /*9*/ UNARY
//%nonassoc /*10*/ INCR_DECR


%%

program :
	topDecl_list
	;

topDecl_list :
	%empty
	| topDecl_list topDecl
	;

iden : Iden ;
int  : IntLiteral ;

type : SEQ LBRACK type RBRACK     #SeqType
     | SET LBRACK type RBRACK     #SetType
     | MAP LBRACK /*keyType=*/type COMMA /*valueType=*/type RBRACK  #MapType
     | LPAREN /*tupTypes+=*/type (COMMA /*tupTypes+=*/type)* RPAREN #TupleType
     | LPAREN idenTypeList RPAREN #NamedTupleType
     | BOOL      #PrimitiveType
     | INT       #PrimitiveType
     | FLOAT     #PrimitiveType
     | STRING    #PrimitiveType
     | EVENT     #PrimitiveType
     | MACHINE   #PrimitiveType
     | DATA      #PrimitiveType
     | ANY       #PrimitiveType
     | /*name=*/iden #NamedType
     ;

idenTypeList : idenType (COMMA idenType)* ;
idenType : /*name=*/iden COLON type ;

funParamList : funParam (COMMA funParam)* ;
funParam : /*name=*/iden COLON type ;

topDecl : typeDefDecl
        | enumTypeDefDecl
        | eventDecl
        | eventSetDecl
        | interfaceDecl
        | implMachineDecl
        | specMachineDecl
        | funDecl
        | namedModuleDecl
        | testDecl
        | implementationDecl
        ;


typeDefDecl : TYPE /*name=*/iden SEMI #ForeignTypeDef
            | TYPE /*name=*/iden ASSIGN type SEMI #PTypeDef
            ;

enumTypeDefDecl : ENUM /*name=*/iden LBRACE enumElemList RBRACE
                | ENUM /*name=*/iden LBRACE numberedEnumElemList RBRACE
                ;
enumElemList : enumElem (COMMA enumElem)* ;
enumElem : /*name=*/iden ;
numberedEnumElemList : numberedEnumElem (COMMA numberedEnumElem)* ;
numberedEnumElem : /*name=*/iden ASSIGN /*value=*/IntLiteral ;

eventDecl :
	EVENT /*name=*/iden SEMI
	| EVENT /*name=*/iden cardinality SEMI
	| EVENT /*name=*/iden COLON type SEMI
	| EVENT /*name=*/iden cardinality COLON type SEMI
	;
cardinality : ASSERT IntLiteral
            | ASSUME IntLiteral
            ;

eventSetDecl : EVENTSET /*name=*/iden ASSIGN LBRACE eventSetLiteral RBRACE SEMI ;
eventSetLiteral :
	/*events+=*/nonDefaultEvent
	| eventSetLiteral COMMA /*events+=*/nonDefaultEvent
	;

interfaceDecl : INTERFACE /*name=*/iden LPAREN type? RPAREN (RECEIVES nonDefaultEventList?) SEMI ;

// has scope
implMachineDecl : MACHINE /*name=*/iden cardinality? receivesSends* machineBody ;
idenList : /*names+=*/iden (COMMA /*names+=*/iden)* ;

receivesSends : RECEIVES eventSetLiteral? SEMI #MachineReceive
              | SENDS eventSetLiteral? SEMI    #MachineSend
              ;

specMachineDecl : SPEC /*name=*/iden OBSERVES eventSetLiteral machineBody ;

machineBody : LBRACE machineEntry_list RBRACE;
machineEntry_list :
	%empty
	| machineEntry_list machineEntry
	;
machineEntry : varDecl
             | funDecl
             | stateDecl
             ;

varDecl : VAR idenList COLON type SEMI ;

funDecl : FUN /*name=*/iden LPAREN funParamList? RPAREN (COLON type)? (CREATES /*interfaces+=*/iden)? SEMI #ForeignFunDecl
        | FUN /*name=*/iden LPAREN funParamList? RPAREN (COLON type)? functionBody #PFunDecl
        ;

stateDecl :
	start_temp_opt STATE /*name=*/iden LBRACE stateBodyItem_list RBRACE
	;

start_temp_opt :
	%empty
	| START
	| HOT
	| COLD
	| START /*temperature=*/HOT
	| START /*temperature=*/COLD
	;

stateBodyItem_list :
	%empty
	| stateBodyItem_list stateBodyItem
	;

stateBodyItem : ENTRY anonEventHandler       #StateEntry
              | ENTRY /*funName=*/iden SEMI      #StateEntry
              | EXIT noParamAnonEventHandler #StateExit
              | EXIT /*funName=*/iden SEMI       #StateExit
              | DEFER nonDefaultEventList SEMI    #StateDefer
              | IGNORE nonDefaultEventList SEMI   #StateIgnore
              | ON eventList DO /*funName=*/iden SEMI #OnEventDoAction
              | ON eventList DO anonEventHandler  #OnEventDoAction
              | ON eventList GOTO stateName SEMI  #OnEventGotoState
              | ON eventList GOTO stateName WITH anonEventHandler  #OnEventGotoState
              | ON eventList GOTO stateName WITH /*funName=*/iden SEMI #OnEventGotoState
              ;

nonDefaultEventList : /*events+=*/nonDefaultEvent (COMMA /*events+=*/nonDefaultEvent)* ;
nonDefaultEvent : HALT | iden ;

eventList : eventId (COMMA eventId)* ;
eventId : NullLiteral | HALT | iden ;

stateName : /*state=*/iden ;

functionBody :
	LBRACE varDecl_list statement_list RBRACE
	;
varDecl_list :
	%empty
	| varDecl_list varDecl
	;
statement_list :
	%empty
	| statement_list statement
	;
statement : LBRACE statement_list RBRACE							#CompoundStmt
          | ASSERT /*assertion=*/expr (COMMA /*message=*/expr)? SEMI	#AssertStmt
          | PRINT /*message=*/expr SEMI								#PrintStmt
          | RETURN expr? SEMI									#ReturnStmt
          | BREAK SEMI											#BreakStmt
          | CONTINUE SEMI										#ContinueStmt
          | lvalue ASSIGN rvalue SEMI							#AssignStmt
          | lvalue INSERT LPAREN expr COMMA rvalue RPAREN SEMI	#InsertStmt
		  | lvalue INSERT LPAREN rvalue RPAREN SEMI				#AddStmt
          | lvalue REMOVE expr SEMI								#RemoveStmt
          | WHILE LPAREN expr RPAREN statement					#WhileStmt
          | FOREACH LPAREN /*item=*/iden IN /*collection=*/expr
                                        RPAREN statement		#ForeachStmt
          | IF LPAREN expr RPAREN /*thenBranch=*/statement
                            (ELSE /*elseBranch=*/statement)?		#IfStmt
          | NEW iden LPAREN rvalueList? RPAREN SEMI				#CtorStmt
          | /*fun=*/iden LPAREN rvalueList? RPAREN SEMI				#FunCallStmt
          | RAISE expr (COMMA rvalueList)? SEMI					#RaiseStmt
          | SEND /*machine=*/expr COMMA /*event=*/expr
                              (COMMA rvalueList)? SEMI			#SendStmt
          | ANNOUNCE expr (COMMA rvalueList)? SEMI				#AnnounceStmt
          | GOTO stateName (COMMA rvalueList)? SEMI				#GotoStmt
          | RECEIVE LBRACE recvCase+ RBRACE						#ReceiveStmt
          | SEMI												#NoStmt
          ;

lvalue : /*name=*/iden                 #VarLvalue
       | lvalue DOT /*field=*/iden     #NamedTupleLvalue
       | lvalue DOT int            #TupleLvalue
       | lvalue LBRACK expr RBRACK #MapOrSeqLvalue
       ;

recvCase : CASE eventList COLON anonEventHandler ;
anonEventHandler :
	functionBody
	| LPAREN funParam RPAREN functionBody
	;
noParamAnonEventHandler : functionBody;

expr : primitive                                      #PrimitiveExpr
     | LPAREN unnamedTupleBody RPAREN                 #UnnamedTupleExpr
     | LPAREN namedTupleBody RPAREN                   #NamedTupleExpr
     | LPAREN expr RPAREN                             #ParenExpr
     | expr DOT /*field=*/iden                            #NamedTupleAccessExpr
     | expr DOT /*field=*/int                             #TupleAccessExpr
     | /*seq=*/expr LBRACK /*index=*/expr RBRACK              #SeqAccessExpr
     | /*fun=*/KEYS LPAREN expr RPAREN                    #KeywordExpr
     | /*fun=*/VALUES LPAREN expr RPAREN                  #KeywordExpr
     | /*fun=*/SIZEOF LPAREN expr RPAREN                  #KeywordExpr
     | /*fun=*/DEFAULT LPAREN type RPAREN                 #KeywordExpr
     | NEW /*interfaceName=*/iden
                            LPAREN rvalueList? RPAREN #CtorExpr
     | /*fun=*/iden LPAREN rvalueList? RPAREN             #FunCallExpr
     | /*op=*/(SUB | LNOT) expr   %prec UNARY                         #UnaryExpr
     | /*lhs=*/expr /*op=*/(MUL | DIV | MOD) /*rhs=*/expr         #BinExpr
     | /*lhs=*/expr /*op=*/(ADD | SUB) /*rhs=*/expr               #BinExpr
     | expr /*cast=*/(AS | TO) type                       #CastExpr
     | /*lhs=*/expr /*op=*/(LT | GT | GE | LE | IN) /*rhs=*/expr  #BinExpr
     | /*lhs=*/expr /*op=*/(EQ | NE) /*rhs=*/expr                 #BinExpr
     | /*lhs=*/expr /*op=*/LAND /*rhs=*/expr                      #BinExpr
     | /*lhs=*/expr /*op=*/LOR /*rhs=*/expr                       #BinExpr
	 | CHOOSE LPAREN expr? RPAREN					  #ChooseExpr
	 | formatedString								  #StringExpr
     ;

formatedString	:	StringLiteral
				|	FORMAT LPAREN StringLiteral RPAREN
				|	FORMAT LPAREN StringLiteral COMMA rvalueList RPAREN
				;

primitive : iden
          | floatLiteral
          | BoolLiteral
          | IntLiteral
          | NullLiteral
          | NONDET
          | FAIRNONDET
          | HALT
          | THIS
          ;

floatLiteral : /*pre=*/IntLiteral? DOT /*post=*/IntLiteral #DecimalFloat
             | FLOAT LPAREN /*base=*/IntLiteral COMMA /*exp=*/IntLiteral RPAREN #ExpFloat
             ;

unnamedTupleBody : /*fields+=*/rvalue COMMA
                 | /*fields+=*/rvalue (COMMA /*fields+=*/rvalue)+
                 ;

namedTupleBody : /*names+=*/iden ASSIGN /*values+=*/rvalue COMMA
               | /*names+=*/iden ASSIGN /*values+=*/rvalue (COMMA /*names+=*/iden ASSIGN /*values+=*/rvalue)+
               ;

rvalueList :
	rvalue
	| rvalueList COMMA rvalue
	;
rvalue : expr ;

// module system related

modExpr : LPAREN modExpr RPAREN												  #ParenModuleExpr
		| LBRACE /*bindslist+=*/bindExpr (COMMA /*bindslist+=*/bindExpr)* RBRACE      #PrimitiveModuleExpr
        | iden                                                                #NamedModule
        | /*op=*/COMPOSE /*mexprs+=*/modExpr (COMMA /*mexprs+=*/modExpr)+				  #ComposeModuleExpr
        | /*op=*/UNION   /*mexprs+=*/modExpr (COMMA  /*mexprs+=*/modExpr)+				  #UnionModuleExpr
        | /*op=*/HIDEE  nonDefaultEventList IN modExpr							#HideEventsModuleExpr
        | /*op=*/HIDEI idenList IN modExpr										#HideInterfacesModuleExpr
        | /*op=*/ASSERT  idenList IN modExpr									#AssertModuleExpr
        | /*op=*/RENAME  /*oldName=*/iden TO /*newName=*/iden IN modExpr				#RenameModuleExpr
		| /*op=*/MAIN /*mainMachine=*/iden IN modExpr								#MainMachineModuleExpr
        ;


bindExpr : (/*mName=*/iden | /*mName=*/iden RARROW /*iName=*/iden) ;

namedModuleDecl : MODULE /*name=*/iden ASSIGN modExpr SEMI ;

testDecl : TEST /*testName=*/iden (LBRACK MAIN ASSIGN /*mainMachine=*/iden RBRACK) COLON modExpr SEMI                  #SafetyTestDecl
         | TEST /*testName=*/iden (LBRACK MAIN ASSIGN /*mainMachine=*/iden RBRACK) COLON modExpr REFINES modExpr SEMI  #RefinementTestDecl
         ;

implementationDecl : IMPLEMENTATION /*implName=*/iden (LBRACK MAIN ASSIGN /*mainMachine=*/iden RBRACK)? COLON modExpr SEMI ;

%%

%%

ADD	ADD
ANNOUNCE	ANNOUNCE
ANY	ANY
AS	AS
ASSERT	ASSERT
ASSIGN	ASSIGN
ASSUME	ASSUME
BOOL	BOOL
BoolLiteral	BoolLiteral
BREAK	BREAK
CASE	CASE
CHOOSE	CHOOSE
COLD	COLD
COLON	COLON
COMMA	COMMA
COMPOSE	COMPOSE
CONTINUE	CONTINUE
CREATES	CREATES
DATA	DATA
DEFAULT	DEFAULT
DEFER	DEFER
DIV	DIV
DO	DO
DOT	DOT
ELSE	ELSE
ENTRY	ENTRY
ENUM	ENUM
EQ	EQ
EVENT	EVENT
EVENTSET	EVENTSET
EXIT	EXIT
FAIRNONDET	FAIRNONDET
FLOAT	FLOAT
FOREACH	FOREACH
FORMAT	FORMAT
FUN	FUN
GE	GE
GOTO	GOTO
GT	GT
HALT	HALT
HIDEE	HIDEE
HIDEI	HIDEI
HOT	HOT
Iden	Iden
IF	IF
IGNORE	IGNORE
IMPLEMENTATION	IMPLEMENTATION
IN	IN
INSERT	INSERT
INT	INT
INTERFACE	INTERFACE
IntLiteral	IntLiteral
KEYS	KEYS
LAND	LAND
LBRACE	LBRACE
LBRACK	LBRACK
LE	LE
LNOT	LNOT
LOR	LOR
LPAREN	LPAREN
LT	LT
MACHINE	MACHINE
MAIN	MAIN
MAP	MAP
MOD	MOD
MODULE	MODULE
MUL	MUL
NE	NE
NEW	NEW
NONDET	NONDET
NullLiteral	NullLiteral
OBSERVES	OBSERVES
ON	ON
PRINT	PRINT
RAISE	RAISE
RARROW	RARROW
RBRACE	RBRACE
RBRACK	RBRACK
RECEIVE	RECEIVE
RECEIVES	RECEIVES
REFINES	REFINES
REMOVE	REMOVE
RENAME	RENAME
RETURN	RETURN
RPAREN	RPAREN
SEMI	SEMI
SEND	SEND
SENDS	SENDS
SEQ	SEQ
SET	SET
SIZEOF	SIZEOF
SPEC	SPEC
START	START
STATE	STATE
STRING	STRING
StringLiteral	StringLiteral
SUB	SUB
TEST	TEST
THIS	THIS
TO	TO
TYPE	TYPE
UNION	UNION
VALUES	VALUES
VAR	VAR
WHILE	WHILE
WITH	WITH

//lexer grammar PLexer;

// Type names

"any"	ANY
"bool"	BOOL
"enum"	ENUM
"event"	EVENT
"eventset"	EVENTSET
"float"	FLOAT
"int"	INT
"machine"	MACHINE
"interface"	INTERFACE
"map"	MAP
"set"	SET
"string"	STRING
"seq"	SEQ
"data"	DATA

// Keywords

"announce"	ANNOUNCE
"as"	AS
"assert"	ASSERT
"assume"	ASSUME
"break"	BREAK
"case"	CASE
"cold"	COLD
"continue"	CONTINUE
"default"	DEFAULT
"defer"	DEFER
"do"	DO
"else"	ELSE
"entry"	ENTRY
"exit"	EXIT
"foreach"	FOREACH
"format"	FORMAT
"fun"	FUN
"goto"	GOTO
"halt"	HALT
"hot"	HOT
"if"	IF
"ignore"	IGNORE
"in"	IN
"keys"	KEYS
"new"	NEW
"observes"	OBSERVES
"on"	ON
"print"	PRINT
"raise"	RAISE
"receive"	RECEIVE
"return"	RETURN
"send"	SEND
"sizeof"	SIZEOF
"spec"	SPEC
"start"	START
"state"	STATE
"this"	THIS
"type"	TYPE
"values"	VALUES
"var"	VAR
"while"	WHILE
"with"	WITH
"choose"	CHOOSE

// module-system-specific keywords

// module-test-implementation declarations
"module"	MODULE
"implementation"	IMPLEMENTATION
"test"	TEST
"refines"	REFINES

// module constructors
"compose"	COMPOSE
"union"	UNION
"hidee"	HIDEE
"hidei"	HIDEI
"rename"	RENAME
//"safe"	SAFE
"main"	MAIN

// machine annotations
"receives"	RECEIVES
"sends"	SENDS

// Common keywords
"creates"	CREATES
"to"	TO

// Literals

"true"|"false"	BoolLiteral

[0-9]+	IntLiteral

"null"	NullLiteral

\"(\\.|[^"\n\r\\])*\"	StringLiteral

// Symbols

"$$"	FAIRNONDET
"$"	NONDET

"!"	LNOT
"&&"	LAND
"||"	LOR

"=="	EQ
"!="	NE
"<="	LE
">="	GE
"<"	LT
">"	GT
"->"	RARROW

"="	ASSIGN
"+="	INSERT
"-="	REMOVE

"+"	ADD
"-"	SUB
"*"	MUL
"/"	DIV
"%"	MOD

"{"	LBRACE
"}"	RBRACE
"["	LBRACK
"]"	RBRACK
"("	LPAREN
")"	RPAREN
";"	SEMI
","	COMMA
"."	DOT
":"	COLON

// Identifiers

[a-zA-Z_][a-zA-Z0-9_]*	Iden

// Non-code regions

[ \t\r\n\f]+  skip()
"/*"(?s:.)*?"*/"	skip()
"//".*	skip()

%%
