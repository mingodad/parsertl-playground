//From: https://github.com/boschresearch/blech/blob/dcd90ccb219b0c95b367643005206af6b57100e3/src/Frontend/Parser.fsy
// Copyright (c) 2019 - for information on the respective copyright owner
// see the NOTICE file and/or the repository
// https://github.com/boschresearch/blech.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/*Tokens*/
//%token BLECH
%token LINEDOC
%token BLOCKDOC
%token AT
%token ATAT
%token MODULE
%token SIGNATURE
%token IMPORT
%token EXPOSES
%token INTERNAL
%token EXTENSION
%token BOOL
%token BITS8
%token BITS16
%token BITS32
%token BITS64
%token NAT8
%token NAT16
%token NAT32
%token NAT64
%token INT8
%token INT16
%token INT32
%token INT64
%token FLOAT32
%token FLOAT64
%token TYPEALIAS
%token TYPE
%token ENUM
%token STRUCT
%token SHARES
%token QUEST
%token UNIT
%token ACTIVITY
%token FUNCTION
%token SINGLETON
%token PARAM
%token CONST
%token REF
%token VAR
%token SIGNAL
%token LET
%token EXTERN
%token EMIT
%token ASSIGN
%token ASSUME
%token ASSERT
%token ABORT
%token AWAIT
%token DEFAULT
%token DO
%token ELSE
%token ELSEIF
%token END
%token FOR
%token COBEGIN
%token IF
%token IN
%token PAST
%token NEXT
%token OF
//%token PRINT
%token REPEAT
%token RUN
%token RESET
%token RETURN
%token RETURNS
%token SUSPEND
%token THEN
%token TRY
%token THROW
%token THROWS
%token ERROR
%token UNTIL
%token WEAK
%token WHEN
%token WHILE
%token WITH
%token PREV
%token TRUE
%token FALSE
%token NOT
%token AND
%token OR
%token ADD
%token SUB
%token MUL
%token DIV
%token MOD
%token EXP
%token EQU
%token IEQ
%token LES
%token LEQ
%token GRT
%token GEQ
%token IDEQU
%token IDIEQ
%token BNOT
%token BAND
%token BOR
%token BXOR
%token SHL
%token SHR
%token SSHR
%token ROTL
%token ROTR
%token AS
%token ASBANG
%token LEN
%token CAP
%token LBRACE
%token RBRACE
%token LBRACKET
%token RBRACKET
%token LPAREN
%token RPAREN
%token ELLIPSIS
%token COMMA
%token SEMICOLON
%token POINT
%token COLON
%token WILDCARD
%token STRING
%token MULTILINESTRING
%token BINCONST
%token OCTCONST
%token HEXCONST
%token NATCONST
%token FLOATCONST
%token HEXFLOATCONST
%token ID
//%token EOF
//%token EOL
%token LOWEST
%token UNARY
%token HIGHEST

%left /*1*/ LOWEST
%left /*2*/ AS ASBANG COLON
%left /*3*/ OR
%left /*4*/ AND
%left /*5*/ EQU IEQ LES LEQ GRT GEQ IDEQU IDIEQ
%left /*6*/ BOR
%left /*7*/ BXOR
%left /*8*/ BAND
%left /*9*/ SHL SHR SSHR ROTL ROTR
%left /*10*/ ADD SUB
%left /*11*/ MUL DIV MOD
%left /*12*/ UNARY
%left /*13*/ EXP
%left /*14*/ IF TRY
%left /*15*/ HIGHEST

%start Compilation

%%

Name :
	ID
	;

NamePath :
	Name
	| NamePath POINT Name
	;

PointedName :
	NamePath
	;

UnitExpr :
	NATCONST
	| PointedName
	| UnitExpr MUL /*11L*/ UnitExpr %prec MUL /*11L*/
	| UnitExpr DIV /*11L*/ UnitExpr %prec DIV /*11L*/
	| UnitExpr EXP /*13L*/ NATCONST %prec EXP /*13L*/
	| LPAREN UnitExpr RPAREN
	;

Unit :
	OptAnnotations UNIT Name
	| OptAnnotations UNIT Name ASSIGN UnitExpr
	//| OptAnnotations UNIT ErrorBeforeEOL EOL
	;

OptUnitDef :
	/*empty*/
	| LBRACKET UnitExpr RBRACKET
	;

Type :
	Datatype
	| SecondClassType
	;

Datatype :
	PointedName
	| LogicalDatatype
	| NumberDatatype
	| ArrayDatatype
	;

LogicalDatatype :
	BOOL
	| BITS8
	| BITS16
	| BITS32
	| BITS64
	;

NumberDatatype :
	FLOAT32 OptUnitDef
	| FLOAT64 OptUnitDef
	| NAT8 OptUnitDef
	| NAT16 OptUnitDef
	| NAT32 OptUnitDef
	| NAT64 OptUnitDef
	| INT8 OptUnitDef
	| INT16 OptUnitDef
	| INT32 OptUnitDef
	| INT64 OptUnitDef
	;

ArrayDatatype :
	LBRACKET Expr RBRACKET Datatype
	;

SecondClassType :
	SignalType
	| SliceType
	;

SignalType :
	SIGNAL
	| Datatype SIGNAL
	;

SliceType :
	LBRACKET RBRACKET Datatype
	;

OptRef :
	/*empty*/
	| REF
	;

TypeAnnotation :
	COLON /*2L*/ Type
	;

OptTypeAnnotation :
	/*empty*/
	| TypeAnnotation
	;

OptModifiers :
	/*empty*/
	| REF
	| ERROR
	;

TypeAliasDecl :
	OptAnnotations OptModifiers TYPEALIAS Name ASSIGN Type
	//| OptAnnotations OptModifiers TYPEALIAS ErrorBeforeEOL EOL
	;

OpaqueTypeDecl :
	OptAnnotations OptModifiers TYPE Name
	//| OptAnnotations OptModifiers TYPE ErrorBeforeEOL EOL
	;

OptExtension :
	/*empty*/
	| EXTENSION ExtensionMembers
	;

OptExtensionDecl :
	/*empty*/
	| EXTENSION ExtensionMemberDecls
	;

StructDecl :
	OptAnnotations OptModifiers STRUCT Name DynamicMembers OptExtensionDecl END
	//| OptAnnotations OptModifiers STRUCT error END
	;

StructDef :
	OptAnnotations OptModifiers STRUCT Name DynamicMembers OptExtension END
	//| OptAnnotations OptModifiers STRUCT error END
	;

VariableQualifier :
	LET
	| VAR
	;

ConstantQualifier :
	CONST
	| PARAM
	;

EnumDecl :
	OptAnnotations OptModifiers ENUM Name OptRawType EnumTagList OptExtensionDecl END
	//| OptAnnotations OptModifiers ENUM error END
	;

EnumDef :
	OptAnnotations OptModifiers ENUM Name OptRawType EnumTagList OptExtension END
	//| OptAnnotations OptModifiers ENUM error END
	;

OptRawType :
	/*empty*/
	| COLON /*2L*/ Datatype
	;

EnumTagList :
	EnumTag
	| EnumTag EnumTagList
	;

EnumTag :
	Name OptRawValue OptDefault OptSemicolon
	;

OptRawValue :
	/*empty*/
	| ASSIGN Expr
	;

OptDefault :
	/*empty*/
	| DEFAULT
	;

Location :
	Access
	| PREV Access
	| NEXT Access
	;

AssignLocation :
	Location
	| WILDCARD
	;

LocationList :
	Location
	| Location COMMA LocationList
	;

Access :
	Name OptAccess
	;

OptAccess :
	/*empty*/
	| POINT Name OptAccess
	| LBRACKET Expr RBRACKET OptAccess
	| POINT LBRACKET Expr RBRACKET OptAccess
	;

Literal :
	TRUE
	| FALSE
	| BINCONST
	| OCTCONST
	| HEXCONST
	| NumberLiteral
	;

NumberLiteral :
	NATCONST OptUnitDef
	| FLOATCONST OptUnitDef
	| HEXFLOATCONST OptUnitDef
	;

Initialisation :
	SliceInitialiser
	| BraceInitialiser
	;

SliceInitialiser :
	LBRACKET OptExpr COMMA OptExpr RBRACKET Location
	;

OptExpr :
	/*empty*/
	| Expr
	;

BraceInitialiser :
	LBRACE RBRACE
	| LBRACE ArrayFieldExprList OptFieldSep RBRACE
	| LBRACE StructFieldExprList OptFieldSep RBRACE
	//| LBRACE error RBRACE
	;

StructFieldExprList :
	StructFieldExpr
	| StructFieldExprList FieldSep StructFieldExpr
	;

StructFieldExpr :
	Name ASSIGN Expr
	;

ArrayFieldExprList :
	ArrayFieldExpr
	| ArrayFieldExprList FieldSep ArrayFieldExpr
	;

ArrayFieldExpr :
	Expr
	| LBRACKET Expr RBRACKET ASSIGN Expr
	;

OptFieldSep :
	/*empty*/
	| FieldSep
	;

FieldSep :
	COMMA
	;

Expr :
	Expr AND /*4L*/ Expr %prec AND /*4L*/
	| Expr OR /*3L*/ Expr %prec OR /*3L*/
	| Expr ADD /*10L*/ Expr %prec ADD /*10L*/
	| Expr SUB /*10L*/ Expr %prec SUB /*10L*/
	| Expr MUL /*11L*/ Expr %prec MUL /*11L*/
	| Expr DIV /*11L*/ Expr %prec DIV /*11L*/
	| Expr MOD /*11L*/ Expr %prec MOD /*11L*/
	| Expr EXP /*13L*/ Expr %prec EXP /*13L*/
	| Expr EQU /*5L*/ Expr %prec EQU /*5L*/
	| Expr IEQ /*5L*/ Expr %prec IEQ /*5L*/
	| Expr LES /*5L*/ Expr %prec LES /*5L*/
	| Expr GRT /*5L*/ Expr %prec GRT /*5L*/
	| Expr LEQ /*5L*/ Expr %prec LEQ /*5L*/
	| Expr GEQ /*5L*/ Expr %prec GEQ /*5L*/
	| Expr IDEQU /*5L*/ Expr %prec IDEQU /*5L*/
	| Expr IDIEQ /*5L*/ Expr %prec IDIEQ /*5L*/
	| Expr BAND /*8L*/ Expr %prec BAND /*8L*/
	| Expr BOR /*6L*/ Expr %prec BOR /*6L*/
	| Expr BXOR /*7L*/ Expr %prec BXOR /*7L*/
	| Expr SHR /*9L*/ Expr %prec SHR /*9L*/
	| Expr SHL /*9L*/ Expr %prec SHL /*9L*/
	| Expr SSHR /*9L*/ Expr %prec SSHR /*9L*/
	| Expr ROTL /*9L*/ Expr %prec ROTR /*9L*/
	| Expr ROTR /*9L*/ Expr %prec ROTL /*9L*/
	| PrimaryExpr %prec UNARY /*12L*/
	| Expr COLON /*2L*/ Datatype %prec COLON /*2L*/
	| Expr AS /*2L*/ Datatype %prec AS /*2L*/
	| Expr ASBANG /*2L*/ Datatype %prec ASBANG /*2L*/
	| IF /*14L*/ Expr THEN Expr ELSE Expr %prec IF /*14L*/
	| TRY /*14L*/ Expr ELSE Expr %prec TRY /*14L*/
	;

PrimaryExpr :
	NOT Expr %prec UNARY /*12L*/
	| SUB /*10L*/ Expr %prec UNARY /*12L*/
	| BNOT Expr %prec UNARY /*12L*/
	| LEN Expr %prec UNARY /*12L*/
	| CAP Expr %prec UNARY /*12L*/
	| Location
	| LPAREN Expr RPAREN
	| Location Inputs OptOutputs
	| Literal
	| ERROR
	| Initialisation
	;

OptLocationList :
	/*empty*/
	| LocationList
	;

OptExprList :
	/*empty*/
	| ExprList
	;

ExprList :
	Expr
	| Expr COMMA ExprList
	;

ConditionSeq :
	Condition
	| Condition COMMA ConditionSeq
	;

Condition :
	Expr
	| SignalBinding
	;

VerificationCondition :
	ASSUME ConditionSeq
	| ASSUME ConditionSeq STRING
	//| ASSUME ErrorBeforeEOL EOL
	| ASSERT ConditionSeq
	| ASSERT ConditionSeq STRING
	//| ASSERT ErrorBeforeEOL EOL
	;

LocalVariable :
	OptAnnotations VariableQualifier OptRef Name TypeAnnotation
	| OptAnnotations EXTERN VariableQualifier OptRef Name TypeAnnotation
	| OptAnnotations VariableQualifier OptRef Name OptTypeAnnotation ASSIGN Expr
	;

LocalConstant :
	OptAnnotations EXTERN ConstantQualifier OptRef Name TypeAnnotation
	| OptAnnotations ConstantQualifier OptRef Name OptTypeAnnotation ASSIGN Expr
	;

ForLoops :
	FOR FreshLocation ASSIGN Expr COMMA Expr DO Block END
	| FOR FreshLocation ASSIGN Expr COMMA Expr COMMA Expr DO Block END
	| FOR FreshLocation IN Expr DO Block END
	| FOR FreshLocation OF Expr DO Block END
	//| FOR error END
	;

FreshLocation :
	VariableQualifier Name OptTypeAnnotation
	;

FunctionCall :
	Location OptPartial Inputs OptOutputs
	//| Location ErrorBeforeEOL EOL
	;

ValueReceiver :
	AssignLocation
	| FreshLocation
	;

ActivityCall :
	OptNext RUN Location OptPartial Inputs OptOutputs
	| OptNext RUN ValueReceiver ASSIGN Location OptPartial Inputs OptOutputs
	//| OptNext RUN ErrorBeforeEOL EOL
	;

EmitStatement :
	EMIT ValueReceiver
	| EMIT ValueReceiver ASSIGN Expr
	;

Block :
	StmtSequence OptReturn
	;

StmtElseIf :
	ELSEIF ConditionSeq THEN Block StmtElseIf
	| ELSEIF ConditionSeq THEN Block ELSE Block END
	| ELSEIF ConditionSeq THEN Block END
	;

Stmt :
	ELLIPSIS
	| VerificationCondition
	| LocalVariable
	| LocalConstant
	| AssignLocation ASSIGN Expr
	| AWAIT ConditionSeq
	| AWAIT PAST Expr
	| EmitStatement
	| FunctionCall
	| ActivityCall
	| IF /*14L*/ ConditionSeq THEN Block END
	| IF /*14L*/ ConditionSeq THEN Block ELSE Block END
	| IF /*14L*/ ConditionSeq THEN Block StmtElseIf
	//| IF /*14L*/ error END
	| WHILE ConditionSeq REPEAT Block END
	//| WHILE error END
	| REPEAT Block UNTIL ConditionSeq END
	| REPEAT Block END
	//| REPEAT error END
	| ForLoops
	| WHEN ConditionSeq Preemption Block END
	| WHEN ConditionSeq Preemption Block THEN Block END
	//| WHEN error END
	| COBEGIN OptWeak Block StmtParallelTo END
	//| COBEGIN OptWeak error END
	| DO Block END
	//| DO error END
	| TRY /*14L*/ Block END
	| TRY /*14L*/ Block ELSE Block END
	| TRY /*14L*/ Block ELSE Block THEN Block END
	//| TRY /*14L*/ error END
	;

Preemption :
	ABORT
	| RESET
	| SUSPEND
	;

Inputs :
	LPAREN OptExprList RPAREN
	;

OptOutputs :
	/*empty*/
	| LPAREN OptLocationList RPAREN
	;

OptReturn :
	/*empty*/
	| RETURN OptNext RUN Location OptPartial Inputs OptOutputs OptSemicolon
	| RETURN OptExpr OptSemicolon
	| THROW OptExpr OptSemicolon
	;

StmtParallelTo :
	WITH OptWeak Block
	| WITH OptWeak Block StmtParallelTo
	;

StmtSequence :
	/*empty*/
	| Stmt StmtSequence
	| Pragma StmtSequence
	| SEMICOLON StmtSequence
	;

SignalBinding :
	FreshLocation ASSIGN Expr
	;

OptNext :
	/*empty*/
	| NEXT
	;

OptSemicolon :
	/*empty*/
	| SEMICOLON
	;

OptWeak :
	/*empty*/
	| WEAK
	;

//OptSingletonDef :
//	/*empty*/
//	| SINGLETON
//	;

OptSingletonDecl :
	/*empty*/
	| SingletonDecl
	;

SingletonDecl :
	SINGLETON OptSingletonUsage
	;

OptSingletonUsage :
	/*empty*/
	| LBRACKET PointedNameList RBRACKET
	;

PointedNameList :
	PointedName
	| PointedName COMMA PointedNameList
	;

OptPartial :
	/*empty*/
	| QUEST
	;

Subprogram :
	OptAnnotations OptSingletonDecl FunOrAct Name OptPartial InputParameters OptOutputParameters OptReturns OptThrows Block END
	//| OptAnnotations OptSingletonDecl FunOrAct error END
	;

ExternalFunction :
	OptAnnotations EXTERN OptSingletonDecl FUNCTION Name InputParameters OptOutputParameters OptReturns
	//| OptAnnotations EXTERN OptSingletonDecl FUNCTION ErrorBeforeEOL
	;

OpaqueSingleton :
	OptAnnotations SingletonDecl Name
	;

Prototype :
	OptAnnotations OptSingletonDecl FunOrAct Name InputParameters OptOutputParameters OptReturns
	//| OptAnnotations OptSingletonDecl FunOrAct ErrorBeforeEOL
	;

FunOrAct :
	FUNCTION
	| ACTIVITY
	;

InputParameters :
	LPAREN RPAREN
	| LPAREN InputParameterList RPAREN
	//| LPAREN error RPAREN
	;

OptOutputParameters :
	/*empty*/
	| LPAREN RPAREN
	| LPAREN OutputParameterList RPAREN
	//| LPAREN error RPAREN
	;

OptReturns :
	/*empty*/
	| RETURNS OptRef OptSharing Type
	;

OptThrows :
	/*empty*/
	| THROWS Datatype
	;

InputParameterList :
	InputParameter
	| InputParameter COMMA InputParameterList
	;

OutputParameterList :
	OutputParameter
	| OutputParameter COMMA OutputParameterList
	;

InputParameter :
	OptRef Name OptSharing COLON /*2L*/ Type
	;

OutputParameter :
	Name OptSharing COLON /*2L*/ Type
	;

OptSharing :
	/*empty*/
	| SHARES SharedNames
	;

SharedNames :
	Name
	| Name COMMA SharedNames
	;

Constant :
	OptAnnotations ConstantQualifier OptRef Name OptTypeAnnotation ASSIGN Expr
	//| OptAnnotations ConstantQualifier ErrorBeforeEOL EOL
	;

ExternalConstant :
	OptAnnotations EXTERN ConstantQualifier OptRef Name TypeAnnotation
	//| OptAnnotations EXTERN ConstantQualifier ErrorBeforeEOL EOL
	;

Variable :
	OptAnnotations VariableQualifier OptRef Name TypeAnnotation
	| OptAnnotations VariableQualifier OptRef Name OptTypeAnnotation ASSIGN Expr
	//| OptAnnotations VariableQualifier ErrorBeforeEOL EOL
	;

//ExternalVariable :
//	OptAnnotations EXTERN VariableQualifier OptRef Name TypeAnnotation
//	//| OptAnnotations EXTERN VariableQualifier ErrorBeforeEOL EOL
//	;

ModuleMember :
	Unit
	| EnumDef
	| StructDef
	| OpaqueSingleton
	| ExtensionMember
	| Extension
	| Pragma
	;

ExtensionMember :
	Subprogram
	| ExternalFunction
	| Constant
	| ExternalConstant
	| TypeAliasDecl
	;

DynamicMember :
	Variable
	;

ModuleMembers :
	/*empty*/
	| ModuleMember ModuleMembers
	| SEMICOLON ModuleMembers
	;

ExtensionMembers :
	/*empty*/
	| ExtensionMember ExtensionMembers
	| Pragma ExtensionMembers
	| SEMICOLON ExtensionMembers
	;

DynamicMembers :
	/*empty*/
	| DynamicMember DynamicMembers
	| Pragma DynamicMembers
	| SEMICOLON DynamicMembers
	;

Extension :
	EXTENSION Name ExtensionMembers END
	;

ModuleHead :
	MODULE
	| INTERNAL MODULE
	;

ModuleSpec :
	OptAnnotations ModuleHead Exposing
	//| OptAnnotations ModuleHead ErrorBeforeEOL EOL
	;

Exposing :
	/*empty*/
	| EXPOSES NameList
	//| EXPOSES ErrorBeforeEOL EOL
	;

ModulePath :
	STRING
	;

Import :
	IMPORT NameOrWildcard ModulePath Exposing
	| IMPORT INTERNAL NameOrWildcard ModulePath Exposing
	//| IMPORT ErrorBeforeEOL EOL
	;

NameOrWildcard :
	Name
	| WILDCARD
	;

NameList :
	Name
	| Name COMMA NameList
	;

ImportList :
	/*empty*/
	| Import ImportList
	| SEMICOLON ImportList
	;

Module :
	ImportList ModuleSpec ModuleMembers
	;

Program :
	ImportList ModuleMember ModuleMembers
	;

SignatureHead :
	SIGNATURE
	| INTERNAL SIGNATURE
	;

SignatureSpec :
	OptAnnotations SignatureHead
	;

SignatureMember :
	Unit
	| EnumDecl
	| StructDecl
	| OpaqueTypeDecl
	| OpaqueSingleton
	| ExtensionMemberDecl
	| ExtensionDecl
	;

SignatureMembers :
	/*empty*/
	| SignatureMember SignatureMembers
	| Pragma SignatureMembers
	| SEMICOLON SignatureMembers
	;

ExtensionDecl :
	EXTENSION Name ExtensionMemberDecls END
	;

ExtensionMemberDecl :
	Prototype
	| ExternalFunction
	| Constant
	| ExternalConstant
	| TypeAliasDecl
	;

ExtensionMemberDecls :
	/*empty*/
	| ExtensionMemberDecl ExtensionMemberDecls
	| Pragma ExtensionMemberDecls
	| SEMICOLON ExtensionMemberDecls
	;

Signature :
	ImportList SignatureSpec SignatureMembers
	;

Compilation :
	Module //EOF
	| Signature //EOF
	| Program //EOF
	//| error EOF
	;

//ErrorBeforeEOL :
//	error
//	;

Pragma :
	ATAT LBRACKET Attribute RBRACKET
	;

OptAnnotations :
	/*empty*/
	| Annotation OptAnnotations
	;

Annotation :
	AT LBRACKET Attribute RBRACKET
	| LINEDOC
	| BLOCKDOC
	;

Attribute :
	Identifier
	| Identifier ASSIGN AttributeLiteral
	| Identifier LPAREN AttributeSeq RPAREN
	;

Identifier :
	STRING
	| ID
	;

AttributeLiteral :
	STRING
	| MULTILINESTRING
	| TRUE
	| FALSE
	| BINCONST
	| OCTCONST
	| HEXCONST
	| OptSub NATCONST
	| OptSub FLOATCONST
	| OptSub HEXFLOATCONST
	;

OptSub :
	/*empty*/
	| SUB /*10L*/
	;

AttributeSeq :
	/*empty*/
	| Attribute
	| Attribute COMMA AttributeSeq
	;

%%

/* Lexer regex rules */

/* all combinations of ascii end of line sequences */
endofline   \r\n?|\n\r?

/* numbers and bitvecs follow https://www.python.org/dev/peps/pep-0515/ */
hexdigit   [0-9a-fA-F]

binliteral   "0b"("_"?[0-1])+
octliteral   "0o"("_"?[0-7])+
hexliteral   "0x"("_"?{hexdigit})+

digit   [0-9]
nonzerodigit   [1-9]
nonzero   {nonzerodigit}("_"?{digit})*
zero   "0"("_"?"0")*
natliteral   ({nonzero}|{zero})

/* float literals */
digitpart   {digit}("_"?{digit})*
fraction   "."{digitpart}
exponent   [eE][+-]?{digitpart}
pointfloat   {digitpart}?{fraction}|{digitpart}"."
exponentfloat   ({digitpart}|{pointfloat}){exponent}
floatliteral   ({pointfloat}|{exponentfloat})

/* hexadecimal floating point literals with "_" instead of "'" follow
   C++17 http://en.cppreference.com/w/cpp/language/floating_literal and
   C99 http://en.cppreference.com/w/c/language/floating_constant  */
hexdigitpart   {hexdigit}("_"?{hexdigit})*
hexfraction   "."{hexdigitpart}
hexexponent   [pP][+-]?{digitpart}
hexpointfloat   {hexdigitpart}?{hexfraction}|{hexdigitpart}"."
hexexponentfloat   ({hexdigitpart}|{hexpointfloat}){hexexponent}
hexfloatliteral   "0x""_"?{hexexponentfloat}

/* strings and multi-line strings follow Julia https://docs.julialang.org/en/v1/manual/strings/
   line continuations are allowed for both
   escape sequence checking follows Lua https://www.lua.org/manual/5.4/manual.html#3.1 */

linecontinuation   "\\"{endofline}

//unicodelineterminator   ['\u0085' '\u2028' '\u2029'] // NEL, LS and PS are invalid
//
//stringcharacter   [^ '\\' '"']
//
//charcharacter   [^ '\\' '\'']
//
//escape   '\\' ['a' 'b' 'f' 'n' 'r' 't' 'v' '\\' '\'' '\"']
//hexescape   '\\' 'x' hexdigit hexdigit
//decimalescape   '\\' digit digit? digit?
//unicodeescape   '\\' 'u' '{' hexdigit+ '}'
//
//// stringitem   stringcharacter | escape | hexescape
//
//triplequotes   "\"\"\""
//quotes   '"' '"'?
//
//characterchar   [^ '\\' '\'' '\x00'-'\x1f' '\x7f'-'\xff']  // printable unicode only
//charitem   charcharacter | escape | hexescape
//characterliteral   '\'' charitem '\''

identifier   [a-zA-Z_]+[_a-zA-Z0-9]*
wildcard   "_"+

//path   '<' [^ '>''.''/''\\'] [^'>''\\']* '>'
//
//
//chunkwithoutnewline   [^'\n' '\r']*
//chunkwithoutstar   [^'*' '\n' '\r']*
//
//chunkwithoutstarandslash   [^'*' '/' '\n' '\r']*

%%

[ \t\r\n]+	skip()
"//".*  skip()
"/*"(?s:.)*?"*/"    skip()


LINEDOC	LINEDOC
BLOCKDOC	BLOCKDOC

/* ---- file system: reserved directory name for blech transpilations ---- */
//"blech"               BLECH

/* ---- module system ---- */
"module"              MODULE
"import"              IMPORT
"exposes"             EXPOSES
"signature"           SIGNATURE
"internal"            INTERNAL

/* --- extensions --- */

"extension"           EXTENSION

/* ---- predefined types ---- */

"bool"                BOOL

"bits8"               BITS8
"bits16"              BITS16
"bits32"              BITS32
"bits64"              BITS64

"nat8"               NAT8
"nat16"              NAT16
"nat32"              NAT32
"nat64"              NAT64

"int8"                INT8
"int16"               INT16
"int32"               INT32
"int64"               INT64

"float32"             FLOAT32
"float64"             FLOAT64

/* --- user-defined types --- */

"typealias"           TYPEALIAS
"type"                TYPE
"enum"                ENUM
"struct"              STRUCT

/* --- signals --- */
"signal"              SIGNAL

/* --------- units of measure --------- */
"unit"                UNIT

/* --- clocks --- */
/* "clock"               CLOCK
"count"               COUNT
"up"                  UP
"down"                DOWN
"off"                 OFF
"join"                JOIN
"meet"                MEET
"tick"                TICK
"on"                  ON
*/

/* --------- actions --------- */

"emit"                EMIT
"past"                PAST
"="                   ASSIGN
"assume"              ASSUME
"assert"              ASSERT

/* --------- types, activties, functions --------- */

"activity"            ACTIVITY
"function"            FUNCTION
"var"                 VAR
"let"                 LET
"ref"                 REF

"singleton"           SINGLETON
"param"               PARAM
"const"               CONST

"shares"              SHARES

/* ----- FFI ------ */
"extern"              EXTERN

/* --------- Blech statements --------- */

"abort"               ABORT
"await"               AWAIT
"cobegin"             COBEGIN
"default"             DEFAULT
"do"                  DO
"else"                ELSE
"elseif"              ELSEIF
"end"                 END
"for"                 FOR
"if"                  IF
"in"                  IN
"of"                  OF
//"print"               PRINT
"repeat"              REPEAT
"run"                 RUN
"reset"               RESET
"return"              RETURN
"returns"             RETURNS
"suspend"             SUSPEND
"then"                THEN
"until"               UNTIL
"weak"                WEAK
"when"                WHEN
"while"               WHILE
"with"                WITH
"try"                 TRY
"throw"               THROW
"throws"              THROWS

/* ----- error handling -----*/
"error"               ERROR

/* --------- expressions and operators --------- */

"true"                TRUE
"false"               FALSE

/* logical operators */
"not"                 NOT
"and"                 AND
"or"                  OR

/* arithmetic operators */
"+"                   ADD
"-"                   SUB // also unary minus
"*"                   MUL
"/"                   DIV
"%"                   MOD
"**"                  EXP

/* bitwise operators */
"&"                   BAND
"|"                   BOR
"^"                   BXOR
"~"                   BNOT
"<<"                  SHL
">>"                  SHR

/* advanced bitwise operators */
"+>>"                  SSHR // signed shift right
"<<>"                  ROTL // rotate left
"<>>"                  ROTR // rotate right

/* relational operators */
"=="                  EQU
"!="                  IEQ
"<"                   LES
"<="                  LEQ
">"                   GRT
">="                  GEQ

/* identity operators */
"==="                 IDEQU
"!=="                 IDIEQ

/* static cast */
"as"                  AS

/* forced cast */
"as!"                 ASBANG

/* annotations */
"@"                   AT
"@@"                  ATAT

/* length operators on arrays and slices */
"#"                   LEN
"##"                  CAP

/* -------------- Access operators ------------*/
"prev"                PREV
"next"                NEXT



/* --------- delimiters and punctuations --------- */

"{"                   LBRACE
"}"                   RBRACE
"["                   LBRACKET
"]"                   RBRACKET
"("                   LPAREN
")"                   RPAREN
"..."                 ELLIPSIS
"."                   POINT
":"                   COLON
","                   COMMA
";"                   SEMICOLON
"?"                   QUEST

/* --------- literals --------- */

{binliteral}            BINCONST
{octliteral}            OCTCONST
{hexliteral}            HEXCONST
{natliteral}            NATCONST
{floatliteral}          FLOATCONST
{hexfloatliteral}       HEXFLOATCONST
\"(\\.|[^"\r\n\\])*\"	STRING
MULTILINESTRING	MULTILINESTRING
{wildcard}              WILDCARD
{identifier}            ID


%%
