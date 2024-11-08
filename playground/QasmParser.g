//From: https://github.com/openqasm/qe-qasm/blob/654ea08129b51950c000972d97f536d19558c7d8/lib/Parser/QasmParser.y

/* -*- coding: utf-8 -*-
 *
 * Copyright 2023 IBM RESEARCH. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */

/*Tokens*/
%token TOK_ADD_ASSIGN
%token TOK_ADD_OP
//%token TOK_ALPHA
//%token TOK_AMPERSAND
%token TOK_AND_ASSIGN
%token TOK_AND_OP
%token TOK_ANGLE
%token TOK_ANNOTATION
%token TOK_ARCCOS
%token TOK_ARCSIN
%token TOK_ARCTAN
%token TOK_ARRAY
%token TOK_ASSOCIATION_OP
%token TOK_BANG
%token TOK_BARRIER
//%token TOK_BETA
%token TOK_BIT
%token TOK_BOOL
%token TOK_BOOLEAN_CONSTANT
%token TOK_BOUND_QUBIT
%token TOK_BOX
%token TOK_BOXAS
%token TOK_BOXTO
%token TOK_BREAK
%token TOK_CAL
%token TOK_CASE
%token TOK_CCX
//%token TOK_CHAR
//%token TOK_CHI
%token TOK_CIMAG
%token TOK_CNOT
%token TOK_COMMA
%token TOK_COMPLEX
%token TOK_CONST
%token TOK_CONTINUE
%token TOK_COS
%token TOK_CREAL
%token TOK_CREG
%token TOK_CTRL
%token TOK_CX
%token TOK_DEC_OP
%token TOK_DEFAULT
%token TOK_DEFCAL
%token TOK_DEFCAL_GRAMMAR
%token TOK_DELAY
//%token TOK_DELTA
//%token TOK_DIRTY
%token TOK_DIV_OP
%token TOK_DIV_OP_ASSIGN
%token TOK_DO
%token TOK_DOUBLE
%token TOK_DURATION
%token TOK_DURATIONOF
%token TOK_ELLIPSIS
%token TOK_ELSE
%token TOK_ELSEIF
//%token TOK_END
//%token TOK_ENUM
//%token TOK_EPSILON
%token TOK_EQ_OP
%token TOK_EQUAL_ASSIGN
//%token TOK_ERROR
//%token TOK_ETA
//%token TOK_EULER
//%token TOK_EULER_NUMBER
%token TOK_EXP
%token TOK_EXTERN
%token TOK_FILE
//%token TOK_FIXED
%token TOK_FLOAT
%token TOK_FOR
%token TOK_FP_CONSTANT
%token TOK_FRAME
%token TOK_FREQUENCY
//%token TOK_FUNC_NAME
%token TOK_FUNCTION_DEFINITION
//%token TOK_GAMMA
%token TOK_GATE
%token TOK_GE_OP
//%token TOK_GOTO
%token TOK_GPHASE
%token TOK_GT_OP
%token TOK_HADAMARD
//%token TOK_HORIZONTAL_TAB
%token TOK_IBMQASM
%token TOK_IDENTIFIER
%token TOK_IF
%token TOK_IMAGINARY
//%token TOK_IMPLEMENTS
%token TOK_IN
%token TOK_INCLUDE
%token TOK_INC_OP
%token TOK_INPUT
%token TOK_INT
%token TOK_INTEGER_CONSTANT
%token TOK_INVERSE
//%token TOK_IOTA
//%token TOK_KAPPA
//%token TOK_KERNEL
//%token TOK_LAMBDA
//%token TOK_LEFT_ARROW
%token TOK_LEFT_BRACKET
%token TOK_LEFT_CURLY
%token TOK_LEFT_PAREN
%token TOK_LEFT_SHIFT_ASSIGN
%token TOK_LEFT_SHIFT_OP
//%token TOK_LENGTH
//%token TOK_LENGTHOF
%token TOK_LE_OP
%token TOK_LET
%token TOK_LINE
%token TOK_LN
//%token TOK_LONG
//%token TOK_LONG_DOUBLE
%token TOK_LT_OP
%token TOK_MEASURE
%token TOK_MINUS
%token TOK_MOD_OP
%token TOK_MOD_ASSIGN
//%token TOK_MU
//%token TOK_MUL
%token TOK_MUL_ASSIGN
%token TOK_MUL_OP
//%token TOK_NEG
%token TOK_NEGCTRL
%token TOK_NE_OP
%token TOK_NEWFRAME
%token TOK_NEWLINE
//%token TOK_NU
//%token TOK_OMEGA
//%token TOK_OMICRON
%token TOK_OPAQUE
%token TOK_OR_ASSIGN
%token TOK_OR_OP
%token TOK_OUTPUT
%token TOK_PERIOD
%token TOK_PHASE
//%token TOK_PHI
//%token TOK_PI
%token TOK_PLAY
//%token TOK_PLUS
%token TOK_POPCOUNT
%token TOK_PORT
%token TOK_POW
//%token TOK_POW_OP
%token TOK_PRAGMA
//%token TOK_PSI
//%token TOK_PTR_OP
%token TOK_QREG
%token TOK_QUBIT
//%token TOK_QUBITS
//%token TOK_QUESTION
%token TOK_RESET
%token TOK_RETURN
//%token TOK_RHO
%token TOK_RIGHT_ARROW
%token TOK_RIGHT_BRACKET
%token TOK_RIGHT_CURLY
%token TOK_RIGHT_PAREN
%token TOK_RIGHT_SHIFT_ASSIGN
%token TOK_RIGHT_SHIFT_OP
%token TOK_ROTL
%token TOK_ROTR
%token TOK_SEMICOLON
//%token TOK_SHORT
//%token TOK_SIGMA
//%token TOK_SIGNED
%token TOK_SIN
//%token TOK_SIZEOF
%token TOK_SQRT
%token TOK_START_OPENPULSE
%token TOK_START_OPENQASM
%token TOK_STRETCH
//%token TOK_STRETCHINF
//%token TOK_STRETCH_N
%token TOK_STRING_LITERAL
//%token TOK_STRUCT
%token TOK_SUB_ASSIGN
//%token TOK_SUB_OP
%token TOK_SWITCH
%token TOK_TAN
//%token TOK_TAU
//%token TOK_THETA
//%token TOK_TILDE
%token TOK_TIME
%token TOK_TIME_UNIT
//%token TOK_TYPEDEF_NAME
%token TOK_U
%token TOK_UINT
%token TOK_UNBOUND_QUBIT
//%token TOK_UNION
//%token TOK_UNSIGNED
//%token TOK_UPSILON
//%token TOK_VERBATIM
//%token TOK_VERTICAL_TAB
//%token TOK_VOID
%token TOK_WAVEFORM
%token TOK_WHILE
//%token TOK_XI
%token TOK_XOR_ASSIGN
%token TOK_XOR_OP
//%token TOK_ZETA
%token XELSEIF
%token XIF

%right /*1*/ TOK_EQUAL_ASSIGN
%right /*2*/ TOK_AND_ASSIGN TOK_XOR_ASSIGN TOK_OR_ASSIGN
%right /*3*/ TOK_LEFT_SHIFT_ASSIGN TOK_RIGHT_SHIFT_ASSIGN
%right /*4*/ TOK_ADD_ASSIGN TOK_SUB_ASSIGN
%right /*5*/ TOK_MUL_ASSIGN TOK_DIV_OP_ASSIGN TOK_MOD_ASSIGN
%left /*6*/ TOK_OR_OP
%left /*7*/ TOK_AND_OP
%left /*8*/ '|'
%left /*9*/ TOK_XOR_OP
%left /*10*/ '&'
%left /*11*/ TOK_EQ_OP TOK_NE_OP
%left /*12*/ TOK_LEFT_SHIFT_OP TOK_RIGHT_SHIFT_OP
%left /*13*/ TOK_LE_OP TOK_GE_OP TOK_LT_OP TOK_GT_OP
%left /*14*/ TOK_ADD_OP TOK_MINUS //TOK_SUB_OP
%left /*15*/ TOK_MUL_OP TOK_DIV_OP TOK_MOD_OP
%right /*16*/ TOK_BANG TOK_TILDE
%left /*17*/ TOK_INC_OP TOK_DEC_OP TOK_RIGHT_ARROW //TOK_LEFT_ARROW
%left /*18*/ TOK_ASSOCIATION_OP //'@'
%left /*19*/ TOK_SEMICOLON
%nonassoc /*20*/ TOK_NEG
%nonassoc /*21*/ XIF
%nonassoc /*22*/ XELSEIF
%nonassoc /*23*/ TOK_IF
%nonassoc /*24*/ TOK_ELSEIF
%nonassoc /*25*/ TOK_ELSE

%start Start

%%

Start :
	OpenQASMProgram
	//| TOK_END
	//| TOK_START_OPENQASM OpenQASMProgram
	//| TOK_START_OPENPULSE OpenPulseProgram
	;

OpenPulseProgram :
	OpenPulseStmtList
	| TOK_IBMQASM TOK_FP_CONSTANT TOK_SEMICOLON /*19L*/ StmtListImpl
	| TOK_IBMQASM TOK_INTEGER_CONSTANT TOK_SEMICOLON /*19L*/ StmtList
	| TOK_START_OPENQASM OpenQASMProgram
	;

OpenQASMProgram :
	StmtList
	| TOK_IBMQASM TOK_FP_CONSTANT TOK_SEMICOLON /*19L*/ StmtListImpl
	| TOK_IBMQASM TOK_INTEGER_CONSTANT TOK_SEMICOLON /*19L*/ StmtList
	| TOK_START_OPENPULSE OpenPulseProgram
	;

StmtList :
	StmtListImpl //TOK_END
	;

StmtListImpl :
	/*empty*/
	| StmtListImpl Statement
	| StmtListImpl OpenPulseStatement
	;

OpenPulseStmtList :
	OpenPulseStmtListImpl
	;

OpenPulseStmtListImpl :
	/*empty*/
	| OpenPulseStmtListImpl OpenPulseStatement
	| OpenPulseStmtListImpl Statement
	;

ForStmtList :
	ForStmtListImpl
	;

ForStmtListImpl :
	/*empty*/
	| ForStmtListImpl Statement
	;

BoxStmtList :
	BoxStmtListImpl
	;

BoxStmtListImpl :
	/*empty*/
	| BoxStmtListImpl Statement
	;

FuncStmtList :
	FuncStmtListImpl
	;

FuncStmtListImpl :
	/*empty*/
	| FuncStmtListImpl Statement
	| FuncStmtListImpl Statement TOK_COMMA
	;

InitExpressionNodeList :
	InitExpressionNodeListImpl
	;

InitExpressionNodeListImpl :
	/*empty*/
	| InitExpressionNode
	| InitExpressionNodeListImpl TOK_COMMA InitExpressionNode
	;

InitializerList :
	InitializerListImpl
	;

InitializerListImpl :
	/*empty*/
	| TOK_LEFT_CURLY InitExpressionNodeList TOK_RIGHT_CURLY
	| InitializerListImpl TOK_COMMA TOK_LEFT_CURLY InitExpressionNodeList TOK_RIGHT_CURLY
	;

QubitList :
	QubitListImpl
	;

QubitListImpl :
	/*empty*/
	| QubitListImpl BoundQubit
	| QubitListImpl IndexedBoundQubit
	| QubitListImpl BoundQubit TOK_COMMA
	| QubitListImpl IndexedBoundQubit TOK_COMMA
	| QubitListImpl UnboundQubit
	| QubitListImpl IndexedUnboundQubit
	| QubitListImpl UnboundQubit TOK_COMMA
	| QubitListImpl IndexedUnboundQubit TOK_COMMA
	;

IndexedSubscriptExpr :
	TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET
	| TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET
	| TOK_LEFT_BRACKET BinaryOp TOK_RIGHT_BRACKET
	| TOK_LEFT_BRACKET UnaryOp TOK_RIGHT_BRACKET
	;

IndexedSubscriptList :
	IndexedSubscriptListImpl
	;

IndexedSubscriptListImpl :
	/*empty*/
	| IndexedSubscriptListImpl IndexedSubscriptExpr
	;

KernelStmtList :
	KernelStmtListImpl
	;

KernelStmtListImpl :
	/*empty*/
	| KernelStmtListImpl Statement
	| KernelStmtListImpl Statement TOK_COMMA
	;

DefcalStmtList :
	DefcalStmtListImpl
	;

DefcalStmtListImpl :
	/*empty*/
	| DefcalStmtListImpl Statement
	| DefcalStmtListImpl Statement TOK_COMMA
	| DefcalStmtListImpl OpenPulseStatement
	| DefcalStmtListImpl OpenPulseStatement TOK_COMMA
	;

IfStmtList :
	IfStmtListImpl
	;

IfStmtListImpl :
	/*empty*/
	| IfStmtListImpl Statement
	;

ElseIfStmtList :
	ElseIfStmtListImpl
	;

ElseIfStmtListImpl :
	/*empty*/
	| ElseIfStmtListImpl Statement
	;

ElseStmtList :
	ElseStmtListImpl
	;

ElseStmtListImpl :
	/*empty*/
	| ElseStmtListImpl Statement
	;

WhileStmtList :
	WhileStmtListImpl
	;

WhileStmtListImpl :
	/*empty*/
	| WhileStmtListImpl Statement
	;

DoWhileStmtList :
	DoWhileStmtListImpl
	;

DoWhileStmtListImpl :
	/*empty*/
	| DoWhileStmtListImpl Statement
	;

SwitchStmtList :
	SwitchStmtListImpl
	;

SwitchStmtListImpl :
	/*empty*/
	| SwitchStmtListImpl SwitchCaseStmt
	| SwitchStmtListImpl SwitchDefaultStmt
	;

Statement :
	Decl
	| ConstDecl
	| FuncDecl
	| GateDecl
	| OpaqueDecl
	| GateQOp
	| Barrier
	| IfStmt
	| ElseIfStmt
	| ElseStmt
	| ForStmt
	| WhileStmt
	| DoWhileStmt
	| ReturnStmt
	| SwitchStmt
	| BreakStmt
	| ContinueStmt
	| DelayStmt
	| StretchStmt
	| BinaryOpStmt
	| BoxStmt
	| FunctionCallStmt
	| IncludeStmt
	| RotateOpStmt
	| PopcountOpStmt
	| GateCtrlExprStmt
	| GateNegCtrlExprStmt
	| GateInvExprStmt
	| GatePowExprStmt
	| PragmaStmt
	| AnnotationStmt
	| LineDirective
	| FileDirective
	| Newline
	;

OpenPulseStatement :
	OpenPulseDecl
	| OpenPulseStmt
	;

Decl :
	TOK_QREG Identifier TOK_SEMICOLON /*19L*/
	| TOK_CREG Identifier TOK_SEMICOLON /*19L*/
	| TOK_CREG Identifier TOK_EQUAL_ASSIGN /*1R*/ Integer TOK_SEMICOLON /*19L*/
	| TOK_CREG TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_CREG TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Integer TOK_SEMICOLON /*19L*/
	| TOK_CREG TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_STRING_LITERAL TOK_SEMICOLON /*19L*/
	| TOK_BOOL Identifier TOK_SEMICOLON /*19L*/
	| TOK_BOOL Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_BOOLEAN_CONSTANT TOK_SEMICOLON /*19L*/
	| TOK_BOOL Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_INTEGER_CONSTANT TOK_SEMICOLON /*19L*/
	| TOK_BOOL Identifier TOK_EQUAL_ASSIGN /*1R*/ BinaryOpExpr TOK_SEMICOLON /*19L*/
	| TOK_BOOL Identifier TOK_EQUAL_ASSIGN /*1R*/ UnaryOp TOK_SEMICOLON /*19L*/
	| TOK_BOOL Identifier TOK_EQUAL_ASSIGN /*1R*/ LogicalNotExpr TOK_SEMICOLON /*19L*/
	| TOK_BOOL Identifier TOK_EQUAL_ASSIGN /*1R*/ Identifier TOK_SEMICOLON /*19L*/
	| TOK_BOOL Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_INT Identifier TOK_SEMICOLON /*19L*/
	| TOK_INT Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_INT Identifier TOK_EQUAL_ASSIGN /*1R*/ Statement
	| TOK_INT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_INT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_INT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_INT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_INT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_INT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_UINT Identifier TOK_SEMICOLON /*19L*/
	| TOK_UINT Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_UINT Identifier TOK_EQUAL_ASSIGN /*1R*/ Statement
	| TOK_UINT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_UINT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_UINT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_UINT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_UINT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_UINT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_DOUBLE Identifier TOK_SEMICOLON /*19L*/
	| TOK_DOUBLE Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_FLOAT Identifier TOK_SEMICOLON /*19L*/
	| TOK_FLOAT Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_FLOAT Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_CONST TOK_IDENTIFIER TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_CONST TOK_IDENTIFIER TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_CONST TOK_IDENTIFIER TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_ANGLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_ANGLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_ANGLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_ANGLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_ANGLE Identifier TOK_SEMICOLON /*19L*/
	| TOK_ANGLE Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_ANGLE Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_ANGLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_ANGLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| DurationOfDecl TOK_SEMICOLON /*19L*/
	| DurationDecl TOK_SEMICOLON /*19L*/
	| TOK_BIT Identifier TOK_SEMICOLON /*19L*/
	| TOK_BIT Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_INTEGER_CONSTANT TOK_SEMICOLON /*19L*/
	| TOK_BIT Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_STRING_LITERAL TOK_SEMICOLON /*19L*/
	| TOK_BIT Identifier TOK_EQUAL_ASSIGN /*1R*/ Identifier TOK_SEMICOLON /*19L*/
	| TOK_BIT Identifier TOK_EQUAL_ASSIGN /*1R*/ GateQOp
	| TOK_BIT Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_BIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_BIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_BIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_BIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_BIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_BIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_QUBIT Identifier TOK_SEMICOLON /*19L*/
	| TOK_QUBIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_QUBIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_SEMICOLON /*19L*/
	| TOK_QUBIT Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_QUBIT Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_QUBIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_QUBIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_QUBIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr TOK_SEMICOLON /*19L*/
	| TOK_QUBIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	| TOK_LET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_IDENTIFIER TOK_LEFT_BRACKET TOK_INTEGER_CONSTANT TOK_COMMA IntegerList TOK_RIGHT_BRACKET TOK_SEMICOLON /*19L*/
	| TOK_LET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_IDENTIFIER TOK_LEFT_BRACKET TOK_INTEGER_CONSTANT ':' IntegerList TOK_RIGHT_BRACKET TOK_SEMICOLON /*19L*/
	| TOK_LET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_IDENTIFIER IndexedSubscriptExpr TOK_SEMICOLON /*19L*/
	| TOK_LET Identifier TOK_EQUAL_ASSIGN /*1R*/ Identifier TOK_OR_OP /*6L*/ QubitConcatList TOK_SEMICOLON /*19L*/
	| TOK_LET Identifier TOK_EQUAL_ASSIGN /*1R*/ Identifier TOK_INC_OP /*17L*/ QubitConcatList TOK_SEMICOLON /*19L*/
	| FuncResult
	| KernelDecl
	| DefcalDecl
	| DefcalGrammarDecl
	| ArrayExpr TOK_SEMICOLON /*19L*/
	| InitArrayExpr TOK_SEMICOLON /*19L*/
	| MPComplexDecl TOK_SEMICOLON /*19L*/
	| MPComplexFunctionCallDecl TOK_SEMICOLON /*19L*/
	| ModifierDecl
	;

ConstDecl :
	TOK_CONST Decl
	;

ModifierDecl :
	TOK_INPUT Decl
	| TOK_OUTPUT Decl
	;

OpenPulseDecl :
	OpenPulseFrame TOK_SEMICOLON /*19L*/
	| OpenPulsePort TOK_SEMICOLON /*19L*/
	| OpenPulseWaveform TOK_SEMICOLON /*19L*/
	| OpenPulseWaveform
	;

OpenPulseStmt :
	OpenPulsePlay TOK_SEMICOLON /*19L*/
	| OpenPulseCalibration
	;

OpenPulseFrame :
	TOK_FRAME Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_NEWFRAME TOK_LEFT_PAREN ExprList TOK_RIGHT_PAREN
	| TOK_EXTERN TOK_FRAME Identifier
	| TOK_NEWFRAME TOK_LEFT_PAREN ExprList TOK_RIGHT_PAREN
	;

OpenPulsePort :
	TOK_EXTERN TOK_PORT Identifier
	;

OpenPulseWaveform :
	TOK_WAVEFORM Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_BRACKET ExprList TOK_RIGHT_BRACKET
	| TOK_WAVEFORM Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY ExprList TOK_RIGHT_CURLY
	| TOK_WAVEFORM Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	;

OpenPulsePlay :
	TOK_PLAY TOK_LEFT_PAREN TOK_LEFT_BRACKET ExprList TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_PAREN
	| TOK_PLAY TOK_LEFT_PAREN TOK_LEFT_BRACKET ExprList TOK_RIGHT_BRACKET TOK_COMMA OpenPulseFrame TOK_RIGHT_PAREN
	| TOK_PLAY TOK_LEFT_PAREN OpenPulseWaveform TOK_COMMA Identifier TOK_RIGHT_PAREN
	| TOK_PLAY TOK_LEFT_PAREN Identifier TOK_COMMA Identifier TOK_RIGHT_PAREN
	| TOK_PLAY TOK_LEFT_PAREN Identifier TOK_COMMA OpenPulseFrame TOK_RIGHT_PAREN
	| TOK_PLAY TOK_LEFT_PAREN OpenPulseWaveform TOK_COMMA OpenPulseFrame TOK_RIGHT_PAREN
	| TOK_PLAY TOK_LEFT_PAREN ParenFunctionCallExpr TOK_COMMA Identifier TOK_RIGHT_PAREN
	| TOK_PLAY TOK_LEFT_PAREN ParenFunctionCallExpr TOK_COMMA OpenPulseFrame TOK_RIGHT_PAREN
	;

OpenPulseCalibration :
	TOK_CAL TOK_LEFT_CURLY OpenPulseStmtList TOK_RIGHT_CURLY
	;

NamedTypeDeclList :
	NamedTypeDeclListImpl NamedTypeDecl
	| NamedTypeDeclListImpl ParamTypeDecl
	;

NamedTypeDeclListImpl :
	/*empty*/
	| NamedTypeDeclListImpl NamedTypeDecl
	| NamedTypeDeclListImpl NamedTypeDecl TOK_COMMA
	| NamedTypeDeclListImpl ParamTypeDecl TOK_COMMA
	;

PragmaExpr :
	TOK_PRAGMA TOK_STRING_LITERAL
	;

PragmaStmt :
	PragmaExpr
	;

AnnotationExpr :
	TOK_ANNOTATION StringList
	;

AnnotationStmt :
	AnnotationExpr
	;

FuncResult :
	TOK_RIGHT_ARROW /*17L*/ TOK_ANGLE
	| TOK_RIGHT_ARROW /*17L*/ TOK_ANGLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET
	| TOK_RIGHT_ARROW /*17L*/ TOK_ANGLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET
	| TOK_RIGHT_ARROW /*17L*/ TOK_ANGLE TOK_LEFT_BRACKET BinaryOpExpr TOK_RIGHT_BRACKET
	| TOK_RIGHT_ARROW /*17L*/ TOK_BIT
	| TOK_RIGHT_ARROW /*17L*/ TOK_BIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET
	| TOK_RIGHT_ARROW /*17L*/ TOK_BIT TOK_LEFT_BRACKET BinaryOpExpr TOK_RIGHT_BRACKET
	| TOK_RIGHT_ARROW /*17L*/ TOK_BIT TOK_LEFT_BRACKET TOK_INTEGER_CONSTANT TOK_RIGHT_BRACKET
	| TOK_RIGHT_ARROW /*17L*/ TOK_QUBIT
	| TOK_RIGHT_ARROW /*17L*/ TOK_QUBIT TOK_LEFT_BRACKET Expr TOK_RIGHT_BRACKET
	| TOK_RIGHT_ARROW /*17L*/ TOK_BOOL
	| TOK_RIGHT_ARROW /*17L*/ TOK_INT
	| TOK_RIGHT_ARROW /*17L*/ TOK_UINT
	| TOK_RIGHT_ARROW /*17L*/ MPIntegerType
	| TOK_RIGHT_ARROW /*17L*/ TOK_FLOAT
	| TOK_RIGHT_ARROW /*17L*/ TOK_DOUBLE
	| TOK_RIGHT_ARROW /*17L*/ MPDecimalType
	| TOK_RIGHT_ARROW /*17L*/ MPComplexType
	| TOK_RIGHT_ARROW /*17L*/ TOK_WAVEFORM
	| TOK_RIGHT_ARROW /*17L*/ TOK_FRAME
	;

FuncDecl :
	TOK_FUNCTION_DEFINITION Identifier TOK_LEFT_PAREN NamedTypeDeclList TOK_RIGHT_PAREN FuncResult TOK_LEFT_CURLY FuncStmtList TOK_RIGHT_CURLY
	| TOK_FUNCTION_DEFINITION Identifier TOK_LEFT_PAREN TOK_RIGHT_PAREN FuncResult TOK_LEFT_CURLY FuncStmtList TOK_RIGHT_CURLY
	| TOK_FUNCTION_DEFINITION Identifier FuncResult TOK_LEFT_CURLY FuncStmtList TOK_RIGHT_CURLY
	| TOK_FUNCTION_DEFINITION Identifier TOK_LEFT_PAREN NamedTypeDeclList TOK_RIGHT_PAREN TOK_LEFT_CURLY FuncStmtList TOK_RIGHT_CURLY
	| TOK_FUNCTION_DEFINITION Identifier TOK_LEFT_PAREN TOK_RIGHT_PAREN TOK_LEFT_CURLY FuncStmtList TOK_RIGHT_CURLY
	| TOK_FUNCTION_DEFINITION Identifier TOK_LEFT_CURLY FuncStmtList TOK_RIGHT_CURLY
	;

GateDecl :
	TOK_GATE Identifier TOK_LEFT_PAREN NamedTypeDeclList TOK_RIGHT_PAREN GateQubitParamList TOK_LEFT_CURLY GateOpList TOK_RIGHT_CURLY
	| TOK_GATE Identifier GateQubitParamList TOK_LEFT_CURLY GateOpList TOK_RIGHT_CURLY
	| TOK_GATE TOK_CX GateQubitParamList TOK_LEFT_CURLY GateOpList TOK_RIGHT_CURLY
	| TOK_GATE TOK_HADAMARD GateQubitParamList TOK_LEFT_CURLY GateOpList TOK_RIGHT_CURLY
	| TOK_GATE TOK_HADAMARD TOK_LEFT_PAREN NamedTypeDeclList TOK_RIGHT_PAREN GateQubitParamList TOK_LEFT_CURLY GateOpList TOK_RIGHT_CURLY
	;

OpaqueDecl :
	TOK_OPAQUE Identifier TOK_LEFT_PAREN NamedTypeDeclList TOK_RIGHT_PAREN GateQubitParamList TOK_SEMICOLON /*19L*/
	| TOK_OPAQUE Identifier GateQubitParamList TOK_SEMICOLON /*19L*/
	;

BinaryOpAssign :
	Identifier TOK_EQUAL_ASSIGN /*1R*/ Expr
	| Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallExpr
	| Identifier TOK_EQUAL_ASSIGN /*1R*/ ComplexInitializerExpr
	| Identifier TOK_EQUAL_ASSIGN /*1R*/ BinaryOpSelfAssign
	| Identifier TOK_EQUAL_ASSIGN /*1R*/ BinaryOpAssign
	| Identifier TOK_EQUAL_ASSIGN /*1R*/ BinaryOpPrePost
	| Identifier TOK_EQUAL_ASSIGN /*1R*/ RotateOpExpr
	| Identifier TOK_EQUAL_ASSIGN /*1R*/ PopcountOpExpr
	| Identifier TOK_EQUAL_ASSIGN /*1R*/ TimeUnit
	| Identifier TOK_EQUAL_ASSIGN /*1R*/ BooleanConstant
	| TOK_INTEGER_CONSTANT TOK_EQUAL_ASSIGN /*1R*/ Expr
	| TOK_FP_CONSTANT TOK_EQUAL_ASSIGN /*1R*/ Expr
	| TOK_STRING_LITERAL TOK_EQUAL_ASSIGN /*1R*/ Expr
	| BinaryOp TOK_EQUAL_ASSIGN /*1R*/ BinaryOp
	| BinaryOp TOK_EQUAL_ASSIGN /*1R*/ BinaryOpAssign
	| BinaryOp TOK_EQUAL_ASSIGN /*1R*/ BinaryOpSelfAssign
	| BinaryOp TOK_EQUAL_ASSIGN /*1R*/ BinaryOpPrePost
	| BinaryOp TOK_EQUAL_ASSIGN /*1R*/ UnaryOp
	| BinaryOp TOK_EQUAL_ASSIGN /*1R*/ RotateOpExpr
	| BinaryOp TOK_EQUAL_ASSIGN /*1R*/ PopcountOpExpr
	| BinaryOp TOK_EQUAL_ASSIGN /*1R*/ FunctionCallExpr
	| BinaryOp TOK_EQUAL_ASSIGN /*1R*/ ComplexInitializerExpr
	| BinaryOp TOK_EQUAL_ASSIGN /*1R*/ TimeUnit
	| BinaryOp TOK_EQUAL_ASSIGN /*1R*/ BooleanConstant
	| BinaryOpSelfAssign TOK_EQUAL_ASSIGN /*1R*/ BinaryOp
	| BinaryOpPrePost TOK_EQUAL_ASSIGN /*1R*/ BinaryOp
	| UnaryOp TOK_EQUAL_ASSIGN /*1R*/ BinaryOp
	| UnaryOp TOK_EQUAL_ASSIGN /*1R*/ BinaryOpSelfAssign
	| UnaryOp TOK_EQUAL_ASSIGN /*1R*/ BinaryOpPrePost
	;

BinaryOpSelfAssign :
	Expr TOK_RIGHT_SHIFT_ASSIGN /*3R*/ Expr
	| Expr TOK_RIGHT_SHIFT_ASSIGN /*3R*/ ParenFunctionCallExpr
	| BinaryOpSelfAssign TOK_RIGHT_SHIFT_ASSIGN /*3R*/ Expr
	| BinaryOpPrePost TOK_RIGHT_SHIFT_ASSIGN /*3R*/ Expr
	| Expr TOK_RIGHT_SHIFT_ASSIGN /*3R*/ BinaryOpSelfAssign
	| Expr TOK_RIGHT_SHIFT_ASSIGN /*3R*/ BinaryOpPrePost
	| Expr TOK_LEFT_SHIFT_ASSIGN /*3R*/ Expr
	| Expr TOK_LEFT_SHIFT_ASSIGN /*3R*/ ParenFunctionCallExpr
	| BinaryOpSelfAssign TOK_LEFT_SHIFT_ASSIGN /*3R*/ Expr
	| BinaryOpPrePost TOK_LEFT_SHIFT_ASSIGN /*3R*/ Expr
	| Expr TOK_LEFT_SHIFT_ASSIGN /*3R*/ BinaryOpSelfAssign
	| Expr TOK_LEFT_SHIFT_ASSIGN /*3R*/ BinaryOpPrePost
	| Expr TOK_ADD_ASSIGN /*4R*/ Expr
	| Expr TOK_ADD_ASSIGN /*4R*/ ParenFunctionCallExpr
	| BinaryOpSelfAssign TOK_ADD_ASSIGN /*4R*/ Expr
	| BinaryOpPrePost TOK_ADD_ASSIGN /*4R*/ Expr
	| Expr TOK_ADD_ASSIGN /*4R*/ BinaryOpSelfAssign
	| Expr TOK_ADD_ASSIGN /*4R*/ BinaryOpPrePost
	| Expr TOK_SUB_ASSIGN /*4R*/ Expr
	| Expr TOK_SUB_ASSIGN /*4R*/ ParenFunctionCallExpr
	| BinaryOpSelfAssign TOK_SUB_ASSIGN /*4R*/ Expr
	| BinaryOpPrePost TOK_SUB_ASSIGN /*4R*/ Expr
	| Expr TOK_SUB_ASSIGN /*4R*/ BinaryOpSelfAssign
	| Expr TOK_SUB_ASSIGN /*4R*/ BinaryOpPrePost
	| Expr TOK_MUL_ASSIGN /*5R*/ Expr
	| Expr TOK_MUL_ASSIGN /*5R*/ ParenFunctionCallExpr
	| BinaryOpSelfAssign TOK_MUL_ASSIGN /*5R*/ Expr
	| BinaryOpPrePost TOK_MUL_ASSIGN /*5R*/ Expr
	| Expr TOK_MUL_ASSIGN /*5R*/ BinaryOpSelfAssign
	| Expr TOK_MUL_ASSIGN /*5R*/ BinaryOpPrePost
	| Expr TOK_DIV_OP_ASSIGN /*5R*/ Expr
	| Expr TOK_DIV_OP_ASSIGN /*5R*/ ParenFunctionCallExpr
	| BinaryOpSelfAssign TOK_DIV_OP_ASSIGN /*5R*/ Expr
	| BinaryOpPrePost TOK_DIV_OP_ASSIGN /*5R*/ Expr
	| Expr TOK_DIV_OP_ASSIGN /*5R*/ BinaryOpSelfAssign
	| Expr TOK_DIV_OP_ASSIGN /*5R*/ BinaryOpPrePost
	| Expr TOK_MOD_ASSIGN /*5R*/ Expr
	| Expr TOK_MOD_ASSIGN /*5R*/ ParenFunctionCallExpr
	| BinaryOpSelfAssign TOK_MOD_ASSIGN /*5R*/ Expr
	| BinaryOpPrePost TOK_MOD_ASSIGN /*5R*/ Expr
	| Expr TOK_MOD_ASSIGN /*5R*/ BinaryOpSelfAssign
	| Expr TOK_MOD_ASSIGN /*5R*/ BinaryOpPrePost
	| Expr TOK_AND_ASSIGN /*2R*/ Expr
	| Expr TOK_AND_ASSIGN /*2R*/ ParenFunctionCallExpr
	| BinaryOpSelfAssign TOK_AND_ASSIGN /*2R*/ Expr
	| BinaryOpPrePost TOK_AND_ASSIGN /*2R*/ Expr
	| Expr TOK_AND_ASSIGN /*2R*/ BinaryOpSelfAssign
	| Expr TOK_AND_ASSIGN /*2R*/ BinaryOpPrePost
	| Expr TOK_OR_ASSIGN /*2R*/ Expr
	| Expr TOK_OR_ASSIGN /*2R*/ ParenFunctionCallExpr
	| BinaryOpSelfAssign TOK_OR_ASSIGN /*2R*/ Expr
	| BinaryOpPrePost TOK_OR_ASSIGN /*2R*/ Expr
	| Expr TOK_OR_ASSIGN /*2R*/ BinaryOpSelfAssign
	| Expr TOK_OR_ASSIGN /*2R*/ BinaryOpPrePost
	| Expr TOK_XOR_ASSIGN /*2R*/ Expr
	| Expr TOK_XOR_ASSIGN /*2R*/ ParenFunctionCallExpr
	| BinaryOpSelfAssign TOK_XOR_ASSIGN /*2R*/ Expr
	| BinaryOpPrePost TOK_XOR_ASSIGN /*2R*/ Expr
	| Expr TOK_XOR_ASSIGN /*2R*/ BinaryOpSelfAssign
	| Expr TOK_XOR_ASSIGN /*2R*/ BinaryOpPrePost
	;

BinaryOpPrePost :
	TOK_DEC_OP /*17L*/ Identifier
	| TOK_DEC_OP /*17L*/ TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_INC_OP /*17L*/ Identifier
	| TOK_INC_OP /*17L*/ TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| Identifier TOK_DEC_OP /*17L*/
	| TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN TOK_DEC_OP /*17L*/
	| Identifier TOK_INC_OP /*17L*/
	| TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN TOK_INC_OP /*17L*/
	;

BinaryOp :
	Expr TOK_ADD_OP /*14L*/ Expr
	| Expr TOK_ADD_OP /*14L*/ ParenFunctionCallExpr
	| Expr TOK_ADD_OP /*14L*/ BinaryOpPrePost
	| Expr TOK_ADD_OP /*14L*/ BinaryOpSelfAssign
	| BinaryOpPrePost TOK_ADD_OP /*14L*/ Expr
	| BinaryOpSelfAssign TOK_ADD_OP /*14L*/ Expr
	| Expr TOK_MINUS /*14L*/ Expr
	| Expr TOK_MINUS /*14L*/ ParenFunctionCallExpr
	| Expr TOK_MINUS /*14L*/ BinaryOpPrePost
	| Expr TOK_MINUS /*14L*/ BinaryOpSelfAssign
	| BinaryOpPrePost TOK_MINUS /*14L*/ Expr
	| BinaryOpSelfAssign TOK_MINUS /*14L*/ Expr
	| Expr TOK_MUL_OP /*15L*/ Expr
	| Expr TOK_MUL_OP /*15L*/ ParenFunctionCallExpr
	| Expr TOK_MUL_OP /*15L*/ BinaryOpPrePost
	| Expr TOK_MUL_OP /*15L*/ BinaryOpSelfAssign
	| BinaryOpPrePost TOK_MUL_OP /*15L*/ Expr
	| BinaryOpSelfAssign TOK_MUL_OP /*15L*/ Expr
	| Expr TOK_MUL_OP /*15L*/ TOK_MUL_OP /*15L*/ Expr
	| Expr TOK_MUL_OP /*15L*/ TOK_MUL_OP /*15L*/ ParenFunctionCallExpr
	| Expr TOK_MUL_OP /*15L*/ TOK_MUL_OP /*15L*/ BinaryOpPrePost
	| Expr TOK_MUL_OP /*15L*/ TOK_MUL_OP /*15L*/ BinaryOpSelfAssign
	| BinaryOpPrePost TOK_MUL_OP /*15L*/ TOK_MUL_OP /*15L*/ Expr
	| BinaryOpSelfAssign TOK_MUL_OP /*15L*/ TOK_MUL_OP /*15L*/ Expr
	| Expr TOK_DIV_OP /*15L*/ Expr
	| Expr TOK_DIV_OP /*15L*/ ParenFunctionCallExpr
	| Expr TOK_DIV_OP /*15L*/ BinaryOpPrePost
	| Expr TOK_DIV_OP /*15L*/ BinaryOpSelfAssign
	| BinaryOpPrePost TOK_DIV_OP /*15L*/ Expr
	| BinaryOpSelfAssign TOK_DIV_OP /*15L*/ Expr
	| Expr TOK_MOD_OP /*15L*/ Expr
	| Expr TOK_MOD_OP /*15L*/ ParenFunctionCallExpr
	| Expr TOK_MOD_OP /*15L*/ BinaryOpPrePost
	| Expr TOK_MOD_OP /*15L*/ BinaryOpSelfAssign
	| BinaryOpPrePost TOK_MOD_OP /*15L*/ Expr
	| BinaryOpSelfAssign TOK_MOD_OP /*15L*/ Expr
	| Expr TOK_XOR_OP /*9L*/ Expr
	| Expr TOK_XOR_OP /*9L*/ ParenFunctionCallExpr
	| Expr TOK_XOR_OP /*9L*/ BinaryOpPrePost
	| BinaryOpPrePost TOK_XOR_OP /*9L*/ Expr
	| Expr TOK_XOR_OP /*9L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign TOK_XOR_OP /*9L*/ Expr
	| Expr '|' /*8L*/ Expr
	| Expr '|' /*8L*/ ParenFunctionCallExpr
	| Expr '|' /*8L*/ BinaryOpPrePost
	| BinaryOpPrePost '|' /*8L*/ Expr
	| Expr '|' /*8L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign '|' /*8L*/ Expr
	| Expr '&' /*10L*/ Expr
	| Expr '&' /*10L*/ ParenFunctionCallExpr
	| Expr '&' /*10L*/ BinaryOpPrePost
	| BinaryOpPrePost '&' /*10L*/ Expr
	| Expr '&' /*10L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign '&' /*10L*/ Expr
	| Expr TOK_LT_OP /*13L*/ Expr
	| Expr TOK_LT_OP /*13L*/ ParenFunctionCallExpr
	| Expr TOK_LT_OP /*13L*/ BinaryOpPrePost
	| BinaryOpPrePost TOK_LT_OP /*13L*/ Expr
	| Expr TOK_LT_OP /*13L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign TOK_LT_OP /*13L*/ Expr
	| Expr TOK_GT_OP /*13L*/ Expr
	| Expr TOK_GT_OP /*13L*/ ParenFunctionCallExpr
	| Expr TOK_GT_OP /*13L*/ BinaryOpPrePost
	| BinaryOpPrePost TOK_GT_OP /*13L*/ Expr
	| Expr TOK_GT_OP /*13L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign TOK_GT_OP /*13L*/ Expr
	| Expr TOK_LE_OP /*13L*/ Expr
	| Expr TOK_LE_OP /*13L*/ ParenFunctionCallExpr
	| Expr TOK_LE_OP /*13L*/ BinaryOpPrePost
	| BinaryOpPrePost TOK_LE_OP /*13L*/ Expr
	| Expr TOK_LE_OP /*13L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign TOK_LE_OP /*13L*/ Expr
	| Expr TOK_GE_OP /*13L*/ Expr
	| Expr TOK_GE_OP /*13L*/ ParenFunctionCallExpr
	| Expr TOK_GE_OP /*13L*/ BinaryOpPrePost
	| BinaryOpPrePost TOK_GE_OP /*13L*/ Expr
	| Expr TOK_GE_OP /*13L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign TOK_GE_OP /*13L*/ Expr
	| Expr TOK_OR_OP /*6L*/ Expr
	| Expr TOK_OR_OP /*6L*/ ParenFunctionCallExpr
	| Expr TOK_OR_OP /*6L*/ BinaryOpPrePost
	| BinaryOpPrePost TOK_OR_OP /*6L*/ Expr
	| Expr TOK_OR_OP /*6L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign TOK_OR_OP /*6L*/ Expr
	| Expr TOK_AND_OP /*7L*/ Expr
	| Expr TOK_AND_OP /*7L*/ ParenFunctionCallExpr
	| Expr TOK_AND_OP /*7L*/ BinaryOpPrePost
	| BinaryOpPrePost TOK_AND_OP /*7L*/ Expr
	| Expr TOK_AND_OP /*7L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign TOK_AND_OP /*7L*/ Expr
	| Expr TOK_EQ_OP /*11L*/ Expr
	| Expr TOK_EQ_OP /*11L*/ ParenFunctionCallExpr
	| Expr TOK_EQ_OP /*11L*/ BinaryOpPrePost
	| BinaryOpPrePost TOK_EQ_OP /*11L*/ Expr
	| Expr TOK_EQ_OP /*11L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign TOK_EQ_OP /*11L*/ Expr
	| Expr TOK_NE_OP /*11L*/ Expr
	| Expr TOK_NE_OP /*11L*/ ParenFunctionCallExpr
	| Expr TOK_NE_OP /*11L*/ BinaryOpPrePost
	| BinaryOpPrePost TOK_NE_OP /*11L*/ Expr
	| Expr TOK_NE_OP /*11L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign TOK_NE_OP /*11L*/ Expr
	| Expr TOK_LEFT_SHIFT_OP /*12L*/ Expr
	| Expr TOK_LEFT_SHIFT_OP /*12L*/ ParenFunctionCallExpr
	| Expr TOK_LEFT_SHIFT_OP /*12L*/ BinaryOpPrePost
	| BinaryOpPrePost TOK_LEFT_SHIFT_OP /*12L*/ Expr
	| Expr TOK_LEFT_SHIFT_OP /*12L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign TOK_LEFT_SHIFT_OP /*12L*/ Expr
	| Expr TOK_RIGHT_SHIFT_OP /*12L*/ Expr
	| Expr TOK_RIGHT_SHIFT_OP /*12L*/ ParenFunctionCallExpr
	| Expr TOK_RIGHT_SHIFT_OP /*12L*/ BinaryOpPrePost
	| BinaryOpPrePost TOK_RIGHT_SHIFT_OP /*12L*/ Expr
	| Expr TOK_RIGHT_SHIFT_OP /*12L*/ BinaryOpSelfAssign
	| BinaryOpSelfAssign TOK_RIGHT_SHIFT_OP /*12L*/ Expr
	| Expr TOK_ASSOCIATION_OP /*18L*/ Expr
	| Expr TOK_ASSOCIATION_OP /*18L*/ ParenFunctionCallExpr
	;

BinaryOpExpr :
	BinaryOp
	| BinaryOpAssign
	| BinaryOpSelfAssign
	| BinaryOpPrePost
	| ArithPowExpr
	;

BinaryOpStmt :
	BinaryOpAssign TOK_SEMICOLON /*19L*/
	| BinaryOpSelfAssign TOK_SEMICOLON /*19L*/
	| BinaryOpPrePost TOK_SEMICOLON /*19L*/
	;

Barrier :
	TOK_BARRIER IdentifierList TOK_SEMICOLON /*19L*/
	| TOK_BARRIER TOK_SEMICOLON /*19L*/
	;

Reset :
	TOK_RESET Identifier TOK_SEMICOLON /*19L*/
	;

Measure :
	MeasureDecl TOK_SEMICOLON /*19L*/
	| Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_MEASURE Identifier TOK_SEMICOLON /*19L*/
	| TOK_IDENTIFIER TOK_LEFT_BRACKET Integer ':' Integer TOK_RIGHT_BRACKET TOK_EQUAL_ASSIGN /*1R*/ TOK_MEASURE TOK_IDENTIFIER TOK_LEFT_BRACKET Integer ':' Integer TOK_RIGHT_BRACKET TOK_SEMICOLON /*19L*/
	| TOK_MEASURE Identifier TOK_SEMICOLON /*19L*/
	;

MeasureDecl :
	TOK_MEASURE Identifier TOK_RIGHT_ARROW /*17L*/ Identifier
	| TOK_MEASURE Identifier TOK_RIGHT_ARROW /*17L*/ TOK_BIT
	| TOK_MEASURE TOK_IDENTIFIER TOK_LEFT_BRACKET Integer ':' Integer TOK_RIGHT_BRACKET TOK_RIGHT_ARROW /*17L*/ TOK_IDENTIFIER TOK_LEFT_BRACKET Integer ':' Integer TOK_RIGHT_BRACKET
	| TOK_MEASURE Identifier TOK_RIGHT_ARROW /*17L*/ TOK_BIT TOK_LEFT_BRACKET TOK_INTEGER_CONSTANT TOK_RIGHT_BRACKET
	;

DefcalDecl :
	TOK_DEFCAL Identifier TOK_LEFT_PAREN ExprList TOK_RIGHT_PAREN QubitList TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL Identifier QubitList TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL String Identifier TOK_LEFT_PAREN ExprList TOK_RIGHT_PAREN QubitList TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL String Identifier QubitList TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL MeasureDecl TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL String MeasureDecl TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL TOK_RESET Identifier TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL String TOK_RESET Identifier TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL TOK_DELAY TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET QubitList TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL String TOK_DELAY TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET QubitList TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL TOK_DELAY TOK_LEFT_BRACKET DurationOfDecl TOK_RIGHT_BRACKET QubitList TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL TOK_DELAY TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET QubitList TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL String TOK_DELAY TOK_LEFT_BRACKET DurationOfDecl TOK_RIGHT_BRACKET QubitList TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	| TOK_DEFCAL String TOK_DELAY TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET QubitList TOK_LEFT_CURLY DefcalStmtList TOK_RIGHT_CURLY
	;

DefcalGrammarDecl :
	TOK_DEFCAL_GRAMMAR String TOK_SEMICOLON /*19L*/
	;

DurationOfDecl :
	TOK_DURATIONOF TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN
	| TOK_DURATIONOF TOK_LEFT_PAREN TOK_LEFT_CURLY GateEOp TOK_SEMICOLON /*19L*/ TOK_RIGHT_CURLY TOK_RIGHT_PAREN
	;

DurationDecl :
	TOK_DURATION Identifier TOK_EQUAL_ASSIGN /*1R*/ TimeUnit
	| TOK_DURATION Identifier TOK_EQUAL_ASSIGN /*1R*/ DurationOfDecl
	| TOK_DURATION TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Identifier
	| TOK_DURATION Identifier TOK_EQUAL_ASSIGN /*1R*/ Identifier
	| TOK_DURATION Identifier TOK_EQUAL_ASSIGN /*1R*/ BinaryOp
	| TOK_DURATION Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmt
	;

ImplicitDuration :
	TimeUnit
	;

IfStmt :
	TOK_IF /*23N*/ TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN Statement %prec XIF /*21N*/
	| TOK_IF /*23N*/ TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN TOK_LEFT_CURLY IfStmtList TOK_RIGHT_CURLY %prec XIF /*21N*/
	;

ElseIfStmt :
	TOK_ELSEIF /*24N*/ TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN Statement %prec XELSEIF /*22N*/
	| TOK_ELSEIF /*24N*/ TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN TOK_LEFT_CURLY ElseIfStmtList TOK_RIGHT_CURLY %prec XELSEIF /*22N*/
	;

ElseStmt :
	TOK_ELSE /*25N*/ Statement
	| TOK_ELSE /*25N*/ TOK_LEFT_CURLY ElseStmtList TOK_RIGHT_CURLY
	;

ForStmt :
	TOK_FOR Identifier TOK_IN TOK_LEFT_BRACKET IntegerList TOK_RIGHT_BRACKET TOK_LEFT_CURLY ForStmtList TOK_RIGHT_CURLY
	| TOK_FOR Identifier TOK_IN TOK_LEFT_BRACKET IntegerList TOK_RIGHT_BRACKET Statement
	| TOK_FOR Identifier TOK_IN TOK_LEFT_CURLY IntegerList TOK_RIGHT_CURLY Statement
	| TOK_FOR Identifier TOK_IN TOK_LEFT_CURLY IntegerList TOK_RIGHT_CURLY TOK_LEFT_CURLY ForStmtList TOK_RIGHT_CURLY
	| TOK_FOR Identifier TOK_IN TOK_LEFT_BRACKET ForLoopRangeExpr TOK_RIGHT_BRACKET TOK_LEFT_CURLY ForStmtList TOK_RIGHT_CURLY
	| TOK_FOR Identifier TOK_IN TOK_LEFT_BRACKET ForLoopRangeExpr TOK_RIGHT_BRACKET Statement
	| TOK_FOR IntScalarType Identifier TOK_IN TOK_LEFT_BRACKET IntegerList TOK_RIGHT_BRACKET TOK_LEFT_CURLY ForStmtList TOK_RIGHT_CURLY
	| TOK_FOR IntScalarType Identifier TOK_IN TOK_LEFT_BRACKET IntegerList TOK_RIGHT_BRACKET Statement
	| TOK_FOR IntScalarType Identifier TOK_IN TOK_LEFT_CURLY IntegerList TOK_RIGHT_CURLY TOK_LEFT_CURLY ForStmtList TOK_RIGHT_CURLY
	| TOK_FOR IntScalarType Identifier TOK_IN TOK_LEFT_CURLY IntegerList TOK_RIGHT_CURLY Statement
	| TOK_FOR IntScalarType Identifier TOK_IN TOK_LEFT_BRACKET ForLoopRangeExpr TOK_RIGHT_BRACKET TOK_LEFT_CURLY ForStmtList TOK_RIGHT_CURLY
	| TOK_FOR IntScalarType Identifier TOK_IN TOK_LEFT_BRACKET ForLoopRangeExpr TOK_RIGHT_BRACKET Statement
	;

KernelDecl :
	TOK_EXTERN Identifier TOK_LEFT_PAREN NamedTypeDeclList TOK_RIGHT_PAREN FuncResult TOK_SEMICOLON /*19L*/
	| TOK_EXTERN Identifier TOK_LEFT_PAREN NamedTypeDeclList TOK_RIGHT_PAREN TOK_SEMICOLON /*19L*/
	| TOK_EXTERN Identifier TOK_LEFT_PAREN TOK_RIGHT_PAREN TOK_SEMICOLON /*19L*/
	| TOK_EXTERN Identifier TOK_LEFT_PAREN TOK_RIGHT_PAREN FuncResult TOK_SEMICOLON /*19L*/
	| TOK_EXTERN Identifier FuncResult TOK_SEMICOLON /*19L*/
	| TOK_EXTERN Identifier TOK_LEFT_PAREN NamedTypeDeclList TOK_RIGHT_PAREN FuncResult TOK_LEFT_CURLY KernelStmtList TOK_RIGHT_CURLY
	;

WhileStmt :
	TOK_WHILE TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN TOK_LEFT_CURLY WhileStmtList TOK_RIGHT_CURLY
	;

DoWhileStmt :
	TOK_DO TOK_LEFT_CURLY DoWhileStmtList TOK_RIGHT_CURLY TOK_WHILE TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN TOK_SEMICOLON /*19L*/
	;

SwitchScopedStatement :
	IfStmt
	| ElseIfStmt
	| ElseStmt
	| ForStmt
	| ContinueStmt
	| WhileStmt
	| DoWhileStmt
	| SwitchStmt
	| ReturnStmt
	| FunctionCallStmt
	| BinaryOpStmt
	| Decl
	| Barrier
	| DelayStmt
	| StretchStmt
	| BoxStmt
	| GateQOp
	| RotateOpStmt
	| PopcountOpStmt
	| IncludeStmt
	| LineDirective
	| FileDirective
	| Newline
	;

SwitchUnscopedStatement :
	IfStmt
	| ElseIfStmt
	| ElseStmt
	| ForStmt
	| ContinueStmt
	| WhileStmt
	| DoWhileStmt
	| SwitchStmt
	| ReturnStmt
	| FunctionCallStmt
	| BinaryOpStmt
	| Decl
	| Barrier
	| DelayStmt
	| StretchStmt
	| BoxStmt
	| GateQOp
	| RotateOpStmt
	| PopcountOpStmt
	| IncludeStmt
	| LineDirective
	| FileDirective
	| Newline
	;

SwitchScopedStmtList :
	SwitchScopedStmtListImpl
	;

SwitchScopedStmtListImpl :
	/*empty*/
	| SwitchScopedStmtListImpl SwitchScopedStatement
	;

SwitchUnscopedStmtList :
	SwitchUnscopedStmtListImpl
	;

SwitchUnscopedStmtListImpl :
	/*empty*/
	| SwitchUnscopedStmtListImpl SwitchUnscopedStatement
	;

SwitchStmt :
	TOK_SWITCH TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_LEFT_CURLY SwitchStmtList TOK_RIGHT_CURLY
	| TOK_SWITCH TOK_LEFT_PAREN BinaryOp TOK_RIGHT_PAREN TOK_LEFT_CURLY SwitchStmtList TOK_RIGHT_CURLY
	| TOK_SWITCH TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN TOK_LEFT_CURLY SwitchStmtList TOK_RIGHT_CURLY
	| TOK_SWITCH TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN TOK_LEFT_CURLY SwitchStmtList TOK_RIGHT_CURLY
	| TOK_SWITCH TOK_LEFT_PAREN ParenFunctionCallExpr TOK_RIGHT_PAREN TOK_LEFT_CURLY SwitchStmtList TOK_RIGHT_CURLY
	;

ReturnStmt :
	TOK_RETURN Expr TOK_SEMICOLON /*19L*/
	| TOK_RETURN BinaryOpAssign TOK_SEMICOLON /*19L*/
	| TOK_RETURN BinaryOpSelfAssign TOK_SEMICOLON /*19L*/
	| TOK_RETURN BinaryOpPrePost TOK_SEMICOLON /*19L*/
	| TOK_RETURN FunctionCallStmt
	| TOK_RETURN Measure
	| TOK_RETURN TOK_SEMICOLON /*19L*/
	| TOK_RETURN TOK_BOOLEAN_CONSTANT TOK_SEMICOLON /*19L*/
	;

BreakStmt :
	TOK_BREAK TOK_SEMICOLON /*19L*/
	;

ContinueStmt :
	TOK_CONTINUE TOK_SEMICOLON /*19L*/
	;

GateOpList :
	/*empty*/
	| GateOpList GateUOp
	| GateOpList Barrier
	| GateOpList Measure
	| GateOpList GPhaseStmt
	| GateOpList GateCtrlExpr
	| GateOpList GateCtrlStmt
	| GateOpList GateNegCtrlExpr
	| GateOpList GateNegCtrlStmt
	| GateOpList GateInvExpr
	| GateOpList GateInvStmt
	| GateOpList GatePowExpr
	| GateOpList GatePowStmt
	| GateOpList GateGPhaseExpr
	| GateOpList GateGPhaseStmt
	| GateOpList GPhaseExpr
	| GateOpList LineDirective
	| GateOpList FileDirective
	;

GateQOp :
	GateUOp
	| Measure
	| Reset
	| GPhaseStmt
	;

GateEOp :
	Identifier ArgsList AnyList
	| TOK_U ArgsList AnyList
	| TOK_CX IdentifierList
	| TOK_CCX ArgsList AnyList
	| TOK_CNOT ArgsList AnyList
	| TOK_HADAMARD ArgsList AnyList
	;

GateUOp :
	GateEOp TOK_SEMICOLON /*19L*/
	;

ArgsList :
	/*empty*/
	| TOK_LEFT_PAREN ExprList TOK_RIGHT_PAREN
	;

IdentifierList :
	IdentifierListImpl Identifier
	;

IdentifierListImpl :
	/*empty*/
	| IdentifierListImpl Identifier TOK_COMMA
	;

StringList :
	StringListImpl String
	| StringListImpl TOK_ANNOTATION
	;

StringListImpl :
	/*empty*/
	| StringListImpl TOK_IDENTIFIER
	| StringListImpl TOK_INTEGER_CONSTANT
	| StringListImpl TOK_FP_CONSTANT
	| StringListImpl TOK_LEFT_PAREN
	| StringListImpl TOK_RIGHT_PAREN
	| StringListImpl TOK_LEFT_BRACKET
	| StringListImpl TOK_RIGHT_BRACKET
	| StringListImpl TOK_LEFT_CURLY
	| StringListImpl TOK_RIGHT_CURLY
	| StringListImpl TOK_COMMA
	| StringListImpl ':'
	;

GateQubitParamList :
	GateQubitParamListImpl Identifier
	;

GateQubitParamListImpl :
	/*empty*/
	| GateQubitParamListImpl Identifier TOK_COMMA
	| GateQubitParamListImpl Identifier
	;

AnyList :
	AnyListImpl Identifier
	;

AnyListImpl :
	/*empty*/
	| AnyListImpl Identifier TOK_COMMA
	| AnyListImpl LineDirective
	| AnyListImpl FileDirective
	;

FunctionCallArgExprList :
	/*empty*/
	| FunctionCallArgExprListImpl Expr
	;

FunctionCallArgExprListImpl :
	/*empty*/
	| FunctionCallArgExprListImpl Expr TOK_COMMA
	;

FunctionCallArg :
	Identifier TOK_LEFT_PAREN FunctionCallArgExprList TOK_RIGHT_PAREN
	;

ExprList :
	/*empty*/
	| ExprListImpl Expr
	| ExprListImpl BinaryOpAssign
	| ExprListImpl TOK_LEFT_PAREN BinaryOpAssign TOK_RIGHT_PAREN
	| ExprListImpl BinaryOpSelfAssign
	| ExprListImpl TOK_LEFT_PAREN BinaryOpSelfAssign TOK_RIGHT_PAREN
	| ExprListImpl BinaryOpPrePost
	| ExprListImpl TOK_LEFT_PAREN BinaryOpPrePost TOK_RIGHT_PAREN
	| ExprListImpl ComplexInitializerExpr
	| ExprListImpl FunctionCallArg
	| ExprListImpl ImplicitDuration
	| ExprListImpl LineDirective
	| ExprListImpl FileDirective
	;

ExprListImpl :
	/*empty*/
	| ExprListImpl Expr TOK_COMMA
	| ExprListImpl BinaryOpAssign TOK_COMMA
	| ExprListImpl TOK_LEFT_PAREN BinaryOpAssign TOK_RIGHT_PAREN TOK_COMMA
	| ExprListImpl BinaryOpSelfAssign TOK_COMMA
	| ExprListImpl TOK_LEFT_PAREN BinaryOpSelfAssign TOK_RIGHT_PAREN TOK_COMMA
	| ExprListImpl BinaryOpPrePost TOK_COMMA
	| ExprListImpl TOK_LEFT_PAREN BinaryOpPrePost TOK_RIGHT_PAREN TOK_COMMA
	| ExprListImpl Expr ':'
	| ExprListImpl ComplexInitializerExpr
	| ExprListImpl ComplexInitializerExpr TOK_COMMA
	| ExprListImpl FunctionCallArg
	| ExprListImpl FunctionCallArg TOK_COMMA
	| ExprListImpl ImplicitDuration
	| ExprListImpl ImplicitDuration TOK_COMMA
	;

Expr :
	Real
	| Integer
	| String
	| Identifier
	| UnaryOp
	| BinaryOp
	| ArithPowExpr
	| TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| LogicalNotExpr
	| CastExpr
	| TOK_MINUS /*14L*/ Identifier
	| TOK_ADD_OP Identifier
	| TOK_MINUS /*14L*/ TOK_LEFT_PAREN BinaryOpSelfAssign TOK_RIGHT_PAREN
	| TOK_MINUS /*14L*/ TOK_LEFT_PAREN BinaryOpAssign TOK_RIGHT_PAREN
	| TOK_MINUS /*14L*/ TOK_LEFT_PAREN BinaryOpPrePost TOK_RIGHT_PAREN
	| TOK_ADD_OP TOK_LEFT_PAREN BinaryOpSelfAssign TOK_RIGHT_PAREN
	| TOK_ADD_OP TOK_LEFT_PAREN BinaryOpAssign TOK_RIGHT_PAREN
	| TOK_ADD_OP TOK_LEFT_PAREN BinaryOpPrePost TOK_RIGHT_PAREN
	| TOK_MINUS /*14L*/ UnaryOp
	| TOK_ADD_OP UnaryOp
	| TOK_MINUS /*14L*/ TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_ADD_OP TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_MINUS /*14L*/ FunctionCallExpr
	| TOK_ADD_OP FunctionCallExpr
	| TOK_MINUS /*14L*/ TOK_LEFT_PAREN FunctionCallExpr TOK_RIGHT_PAREN
	| TOK_ADD_OP TOK_LEFT_PAREN FunctionCallExpr TOK_RIGHT_PAREN
	;

InitExpressionNode :
	TOK_LEFT_CURLY Real TOK_RIGHT_CURLY
	| Real
	| TOK_LEFT_CURLY Integer TOK_RIGHT_CURLY
	| Integer
	| TOK_LEFT_CURLY String TOK_RIGHT_CURLY
	| String
	| TOK_LEFT_CURLY MPIntegerType TOK_RIGHT_CURLY
	| MPIntegerType
	| TOK_LEFT_CURLY MPDecimalType TOK_RIGHT_CURLY
	| MPDecimalType
	| TOK_LEFT_CURLY MPComplexType TOK_RIGHT_CURLY
	| MPComplexType
	| TOK_LEFT_CURLY ComplexInitializerExpr TOK_RIGHT_CURLY
	| ComplexInitializerExpr
	| TOK_LEFT_CURLY CastExpr TOK_RIGHT_CURLY
	| CastExpr
	| TOK_LEFT_CURLY BinaryOpExpr TOK_RIGHT_CURLY
	| BinaryOpExpr
	| TOK_LEFT_CURLY UnaryOp TOK_RIGHT_CURLY
	| UnaryOp
	;

LogicalNotExpr :
	TOK_BANG /*16R*/ TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_BANG /*16R*/ Identifier
	| TOK_BANG /*16R*/ UnaryOp
	| TOK_BANG /*16R*/ BinaryOpPrePost
	| TOK_BANG /*16R*/ TOK_LEFT_PAREN BinaryOpPrePost TOK_RIGHT_PAREN
	| TOK_BANG /*16R*/ TOK_LEFT_PAREN BinaryOpSelfAssign TOK_RIGHT_PAREN
	| TOK_BANG /*16R*/ TOK_LEFT_PAREN BinaryOpAssign TOK_RIGHT_PAREN
	| TOK_BANG /*16R*/ LogicalNotExpr
	| TOK_BANG /*16R*/ ArithPowExpr
	| TOK_BANG /*16R*/ FunctionCallExpr
	| TOK_BANG /*16R*/ TOK_LEFT_PAREN FunctionCallExpr TOK_RIGHT_PAREN
	;

PopcountOpExpr :
	TOK_POPCOUNT TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN
	| TOK_POPCOUNT TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN
	;

PopcountOpStmt :
	PopcountOpExpr TOK_SEMICOLON /*19L*/
	;

RotateOpExpr :
	TOK_ROTL TOK_LEFT_PAREN Identifier TOK_COMMA Integer TOK_RIGHT_PAREN
	| TOK_ROTL TOK_LEFT_PAREN Identifier TOK_COMMA Identifier TOK_RIGHT_PAREN
	| TOK_ROTR TOK_LEFT_PAREN Identifier TOK_COMMA Integer TOK_RIGHT_PAREN
	| TOK_ROTR TOK_LEFT_PAREN Identifier TOK_COMMA Identifier TOK_RIGHT_PAREN
	;

RotateOpStmt :
	RotateOpExpr TOK_SEMICOLON /*19L*/
	;

UnaryOp :
	TOK_SIN TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN
	| TOK_SIN TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_SIN TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN
	| TOK_SIN TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN
	| TOK_SIN TOK_LEFT_PAREN Real TOK_RIGHT_PAREN
	| TOK_COS TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN
	| TOK_COS TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_COS TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN
	| TOK_COS TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN
	| TOK_COS TOK_LEFT_PAREN Real TOK_RIGHT_PAREN
	| TOK_TAN TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN
	| TOK_TAN TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_TAN TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN
	| TOK_TAN TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN
	| TOK_TAN TOK_LEFT_PAREN Real TOK_RIGHT_PAREN
	| TOK_ARCSIN TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN
	| TOK_ARCSIN TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN
	| TOK_ARCSIN TOK_LEFT_PAREN Real TOK_RIGHT_PAREN
	| TOK_ARCSIN TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_ARCSIN TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN
	| TOK_ARCCOS TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN
	| TOK_ARCCOS TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN
	| TOK_ARCCOS TOK_LEFT_PAREN Real TOK_RIGHT_PAREN
	| TOK_ARCCOS TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_ARCCOS TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN
	| TOK_ARCTAN TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN
	| TOK_ARCTAN TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN
	| TOK_ARCTAN TOK_LEFT_PAREN Real TOK_RIGHT_PAREN
	| TOK_ARCTAN TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_ARCTAN TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN
	| TOK_EXP TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN
	| TOK_EXP TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_EXP TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN
	| TOK_EXP TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN
	| TOK_EXP TOK_LEFT_PAREN Real TOK_RIGHT_PAREN
	| TOK_LN TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN
	| TOK_LN TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_LN TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN
	| TOK_LN TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN
	| TOK_LN TOK_LEFT_PAREN Real TOK_RIGHT_PAREN
	| TOK_SQRT TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN
	| TOK_SQRT TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_SQRT TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN
	| TOK_SQRT TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN
	| TOK_SQRT TOK_LEFT_PAREN Real TOK_RIGHT_PAREN
	| TOK_TILDE Expr
	;

ArithPowExpr :
	TOK_POW TOK_LEFT_PAREN Integer TOK_COMMA Integer TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Integer TOK_COMMA Real TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Real TOK_COMMA Integer TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Real TOK_COMMA Real TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Identifier TOK_COMMA Integer TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Identifier TOK_COMMA Real TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Integer TOK_COMMA Identifier TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Real TOK_COMMA Identifier TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Identifier TOK_COMMA Identifier TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Integer TOK_COMMA BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Real TOK_COMMA BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Identifier TOK_COMMA BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Integer TOK_COMMA UnaryOp TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Real TOK_COMMA UnaryOp TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN Identifier TOK_COMMA UnaryOp TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN BinaryOpExpr TOK_COMMA Integer TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN BinaryOpExpr TOK_COMMA Real TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN BinaryOpExpr TOK_COMMA Identifier TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN UnaryOp TOK_COMMA Integer TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN UnaryOp TOK_COMMA Real TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN UnaryOp TOK_COMMA Identifier TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN BinaryOpExpr TOK_COMMA UnaryOp TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN UnaryOp TOK_COMMA BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN BinaryOpExpr TOK_COMMA BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_POW TOK_LEFT_PAREN UnaryOp TOK_COMMA UnaryOp TOK_RIGHT_PAREN
	;

Identifier :
	TOK_IDENTIFIER
	| UnboundQubit
	| BoundQubit
	| ComplexCReal
	| ComplexCImag
	| OpenPulseFramePhase
	| OpenPulseFrameFrequency
	| OpenPulseFrameTime
	| TOK_IDENTIFIER IndexedSubscriptExpr IndexedSubscriptList
	| BoundQubit IndexedSubscriptExpr IndexedSubscriptList
	| UnboundQubit IndexedSubscriptExpr IndexedSubscriptList
	| TOK_IDENTIFIER TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET
	;

Integer :
	TOK_INTEGER_CONSTANT
	;

IntegerList :
	IntegerListImpl
	;

IntegerListImpl :
	/*empty*/
	| IntegerListImpl Integer
	| IntegerListImpl Integer TOK_COMMA
	| IntegerListImpl Integer ':'
	| IntegerListImpl LineDirective
	| IntegerListImpl FileDirective
	;

QubitConcatList :
	QubitConcatListImpl
	;

QubitConcatListImpl :
	/*empty*/
	| QubitConcatListImpl Identifier
	| QubitConcatListImpl Identifier TOK_OR_OP /*6L*/
	| QubitConcatListImpl Identifier TOK_INC_OP /*17L*/
	;

Real :
	TOK_FP_CONSTANT
	;

Ellipsis :
	TOK_ELLIPSIS
	;

String :
	TOK_STRING_LITERAL
	;

TimeUnit :
	TOK_TIME_UNIT
	;

BooleanConstant :
	TOK_BOOLEAN_CONSTANT
	;

BoundQubit :
	TOK_BOUND_QUBIT
	;

IndexedBoundQubit :
	TOK_BOUND_QUBIT IndexedSubscriptExpr
	;

UnboundQubit :
	TOK_UNBOUND_QUBIT
	;

IndexedUnboundQubit :
	TOK_UNBOUND_QUBIT IndexedSubscriptExpr
	;

ComplexCReal :
	TOK_IDENTIFIER TOK_PERIOD TOK_CREAL
	;

ComplexCImag :
	TOK_IDENTIFIER TOK_PERIOD TOK_CIMAG
	;

OpenPulseFramePhase :
	TOK_IDENTIFIER TOK_PHASE
	;

OpenPulseFrameFrequency :
	TOK_IDENTIFIER TOK_FREQUENCY
	;

OpenPulseFrameTime :
	TOK_IDENTIFIER TOK_TIME
	;

IntScalarType :
	TOK_INT
	| TOK_UINT
	;

FloatScalarType :
	TOK_FLOAT
	;

MPIntegerType :
	TOK_INT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET
	| TOK_INT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET
	| TOK_INT TOK_LEFT_BRACKET BinaryOpExpr TOK_RIGHT_BRACKET
	| TOK_UINT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET
	| TOK_UINT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET
	| TOK_UINT TOK_LEFT_BRACKET BinaryOpExpr TOK_RIGHT_BRACKET
	;

MPDecimalType :
	TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET
	| TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET
	| TOK_FLOAT TOK_LEFT_BRACKET BinaryOpExpr TOK_RIGHT_BRACKET
	;

MPComplexDecl :
	TOK_COMPLEX Identifier
	| TOK_COMPLEX TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier
	| TOK_COMPLEX TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ ComplexInitializerExpr
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ ComplexInitializerExpr
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ BinaryOp
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ UnaryOp
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ ComplexInitializerExpr
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ BinaryOp
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ UnaryOp
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Identifier
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ Identifier
	;

MPComplexFunctionCallDecl :
	TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmtExpr
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ FunctionCallStmtExpr
	;

MPComplexType :
	TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET
	;

BitType :
	TOK_BIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET
	| TOK_BIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET
	| TOK_BIT
	;

AngleType :
	TOK_ANGLE
	| TOK_ANGLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET
	| TOK_ANGLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET
	;

QubitType :
	TOK_QUBIT
	| TOK_QUBIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET
	| TOK_QUBIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET
	;

DurationType :
	TOK_DURATION
	| TOK_DURATION TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET
	;

ArrayType :
	TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET DurationOfDecl TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET DurationOfDecl TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET DurationOfDecl TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET DurationOfDecl TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET DurationOfDecl TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET DurationOfDecl TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FRAME TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FRAME TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FRAME TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FRAME TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FRAME TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FRAME TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_PORT TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_PORT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_PORT TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_PORT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_PORT TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_PORT TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_WAVEFORM TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_WAVEFORM TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_WAVEFORM TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_WAVEFORM TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_WAVEFORM TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_WAVEFORM TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_GATE TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_GATE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_GATE TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_GATE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DEFCAL TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DEFCAL TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DEFCAL TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DEFCAL TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BARRIER TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BARRIER TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BARRIER TOK_COMMA Identifier TOK_RIGHT_BRACKET
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BARRIER TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET
	;

ParamTypeDecl :
	IntScalarType
	| TOK_CONST IntScalarType
	| FloatScalarType
	| TOK_CONST FloatScalarType
	| MPDecimalType
	| TOK_CONST MPDecimalType
	| MPIntegerType
	| TOK_CONST MPIntegerType
	| MPComplexType
	| TOK_CONST MPComplexType
	| BitType
	| TOK_CONST BitType
	| AngleType
	| TOK_CONST AngleType
	| QubitType
	| TOK_CONST QubitType
	| DurationType
	| TOK_CONST DurationType
	| ArrayType
	| TOK_CONST ArrayType
	;

CastExpr :
	TOK_BOOL TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_INT TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_UINT TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_FLOAT TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_DOUBLE TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_BIT TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_BIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_BIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_ANGLE TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_ANGLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_ANGLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_INT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_INT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_UINT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_UINT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_LEFT_PAREN Expr TOK_RIGHT_PAREN
	;

NamedTypeDecl :
	TOK_INT Identifier
	| TOK_CONST TOK_INT Identifier
	| TOK_INT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_INT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_INT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_INT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_UINT Identifier
	| TOK_CONST TOK_UINT Identifier
	| TOK_UINT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_UINT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_UINT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_UINT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_FLOAT Identifier
	| TOK_CONST TOK_FLOAT Identifier
	| TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_DOUBLE Identifier
	| TOK_CONST TOK_DOUBLE Identifier
	| TOK_DOUBLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_DOUBLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_DOUBLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_DOUBLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier
	| TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET Identifier
	| TOK_DURATION Identifier
	| TOK_CONST TOK_DURATION Identifier
	| TOK_DURATION TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_DURATION TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET Identifier
	| TOK_BOOL Identifier
	| TOK_CONST TOK_BOOL Identifier
	| TOK_QUBIT Identifier
	| TOK_CONST TOK_QUBIT Identifier
	| TOK_QUBIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_QUBIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_QUBIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_QUBIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_BIT Identifier
	| TOK_CONST TOK_BIT Identifier
	| TOK_BIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_BIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_BIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_BIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ANGLE Identifier
	| TOK_CONST TOK_ANGLE Identifier
	| TOK_ANGLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_ANGLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ANGLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_CONST TOK_ANGLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET Identifier
	| Identifier
	| Ellipsis
	| ArrayExpr
	| TOK_CONST ArrayExpr
	| TOK_WAVEFORM Identifier
	| TOK_CONST TOK_WAVEFORM Identifier
	| TOK_FRAME Identifier
	| TOK_CONST TOK_FRAME Identifier
	| TOK_PORT Identifier
	| TOK_CONST TOK_PORT Identifier
	| TOK_EXTERN TOK_PORT Identifier
	| TOK_CONST TOK_EXTERN TOK_PORT Identifier
	;

ArrayExpr :
	TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET DurationOfDecl TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET DurationOfDecl TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET DurationOfDecl TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET DurationOfDecl TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET DurationOfDecl TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET DurationOfDecl TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FRAME TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FRAME TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FRAME TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FRAME TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FRAME TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FRAME TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_PORT TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_PORT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_PORT TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_PORT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_PORT TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_PORT TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_WAVEFORM TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_WAVEFORM TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_WAVEFORM TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_WAVEFORM TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_WAVEFORM TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_WAVEFORM TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_GATE TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_GATE TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_GATE TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_GATE TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DEFCAL TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DEFCAL TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DEFCAL TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DEFCAL TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BARRIER TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BARRIER TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BARRIER TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BARRIER TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier
	;

InitArrayExpr :
	TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BIT TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_QUBIT TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_ANGLE TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_BOOL TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_INT TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_UINT TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_FLOAT TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DOUBLE TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DOUBLE TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DOUBLE TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DOUBLE TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DOUBLE TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DOUBLE TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_DURATION TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Integer TOK_COMMA Identifier TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	| TOK_ARRAY TOK_LEFT_BRACKET TOK_COMPLEX TOK_LEFT_BRACKET TOK_FLOAT TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET TOK_RIGHT_BRACKET TOK_COMMA Identifier TOK_COMMA Integer TOK_RIGHT_BRACKET Identifier TOK_EQUAL_ASSIGN /*1R*/ TOK_LEFT_CURLY InitializerList TOK_RIGHT_CURLY
	;

ForLoopRangeExpr :
	IntegerList Identifier TOK_ADD_OP Integer
	| IntegerList Identifier TOK_ADD_OP Identifier
	| IntegerList Identifier TOK_MINUS /*14L*/ Integer
	| IntegerList Identifier TOK_MINUS /*14L*/ Identifier
	| IntegerList Identifier TOK_MUL_OP Integer
	| IntegerList Identifier TOK_MUL_OP Identifier
	| IntegerList Identifier TOK_DIV_OP Integer
	| IntegerList Identifier TOK_DIV_OP Identifier
	| IntegerList Identifier TOK_MOD_OP Integer
	| IntegerList Identifier TOK_MOD_OP Identifier
	| IntegerList Identifier TOK_LEFT_SHIFT_OP /*12L*/ Integer
	| IntegerList Identifier TOK_LEFT_SHIFT_OP /*12L*/ Identifier
	| IntegerList Identifier TOK_RIGHT_SHIFT_OP /*12L*/ Integer
	| IntegerList Identifier TOK_RIGHT_SHIFT_OP /*12L*/ Identifier
	| IntegerList Identifier TOK_LEFT_SHIFT_ASSIGN /*3R*/ Integer
	| IntegerList Identifier TOK_LEFT_SHIFT_ASSIGN /*3R*/ Identifier
	| IntegerList Identifier TOK_RIGHT_SHIFT_ASSIGN /*3R*/ Integer
	| IntegerList Identifier TOK_RIGHT_SHIFT_ASSIGN /*3R*/ Identifier
	;

GPhaseExpr :
	TOK_GPHASE TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN
	| TOK_GPHASE TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN
	| TOK_GPHASE TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN
	;

GPhaseStmt :
	GPhaseExpr TOK_SEMICOLON /*19L*/
	;

GateCtrlExpr :
	TOK_CTRL TOK_ASSOCIATION_OP /*18L*/ GateEOp
	| TOK_CTRL TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateEOp
	| TOK_CTRL TOK_ASSOCIATION_OP /*18L*/ GateCtrlExpr
	| TOK_CTRL TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateCtrlExpr
	| TOK_CTRL TOK_ASSOCIATION_OP /*18L*/ GateNegCtrlExpr
	| TOK_CTRL TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateNegCtrlExpr
	| TOK_CTRL TOK_ASSOCIATION_OP /*18L*/ GateGPhaseExpr
	| TOK_CTRL TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateGPhaseExpr
	| TOK_CTRL TOK_ASSOCIATION_OP /*18L*/ GateInvExpr
	| TOK_CTRL TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateInvExpr
	| TOK_CTRL TOK_ASSOCIATION_OP /*18L*/ GatePowExpr
	| TOK_CTRL TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GatePowExpr
	;

GateCtrlStmt :
	GateCtrlExpr TOK_SEMICOLON /*19L*/
	;

GateCtrlExprStmt :
	GateCtrlExpr TOK_SEMICOLON /*19L*/
	;

GateNegCtrlExpr :
	TOK_NEGCTRL TOK_ASSOCIATION_OP /*18L*/ GateEOp
	| TOK_NEGCTRL TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateEOp
	| TOK_NEGCTRL TOK_ASSOCIATION_OP /*18L*/ GateNegCtrlExpr
	| TOK_NEGCTRL TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateNegCtrlExpr
	| TOK_NEGCTRL TOK_ASSOCIATION_OP /*18L*/ GateGPhaseExpr
	| TOK_NEGCTRL TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateGPhaseExpr
	| TOK_NEGCTRL TOK_ASSOCIATION_OP /*18L*/ GateInvExpr
	| TOK_NEGCTRL TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateInvExpr
	| TOK_NEGCTRL TOK_ASSOCIATION_OP /*18L*/ GatePowExpr
	| TOK_NEGCTRL TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GatePowExpr
	;

GateNegCtrlStmt :
	GateNegCtrlExpr TOK_SEMICOLON /*19L*/
	;

GateNegCtrlExprStmt :
	GateNegCtrlExpr TOK_SEMICOLON /*19L*/
	;

GateInvExpr :
	TOK_INVERSE TOK_ASSOCIATION_OP /*18L*/ GateEOp
	| TOK_INVERSE TOK_ASSOCIATION_OP /*18L*/ GateCtrlExpr
	| TOK_INVERSE TOK_ASSOCIATION_OP /*18L*/ GateNegCtrlExpr
	| TOK_INVERSE TOK_ASSOCIATION_OP /*18L*/ GateGPhaseExpr
	| TOK_INVERSE TOK_ASSOCIATION_OP /*18L*/ GateInvExpr
	| TOK_INVERSE TOK_ASSOCIATION_OP /*18L*/ GatePowExpr
	;

GateInvStmt :
	GateInvExpr TOK_SEMICOLON /*19L*/
	;

GateInvExprStmt :
	GateInvExpr TOK_SEMICOLON /*19L*/
	;

GatePowExpr :
	TOK_POW TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateEOp
	| TOK_POW TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateEOp
	| TOK_POW TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateEOp
	| TOK_POW TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateEOp
	| TOK_POW TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateCtrlExpr
	| TOK_POW TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateCtrlExpr
	| TOK_POW TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateCtrlExpr
	| TOK_POW TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateNegCtrlExpr
	| TOK_POW TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateNegCtrlExpr
	| TOK_POW TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateNegCtrlExpr
	| TOK_POW TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateGPhaseExpr
	| TOK_POW TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateGPhaseExpr
	| TOK_POW TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateGPhaseExpr
	| TOK_POW TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateInvExpr
	| TOK_POW TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateInvExpr
	| TOK_POW TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GateInvExpr
	| TOK_POW TOK_LEFT_PAREN Integer TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GatePowExpr
	| TOK_POW TOK_LEFT_PAREN BinaryOpExpr TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GatePowExpr
	| TOK_POW TOK_LEFT_PAREN UnaryOp TOK_RIGHT_PAREN TOK_ASSOCIATION_OP /*18L*/ GatePowExpr
	;

GatePowStmt :
	GatePowExpr TOK_SEMICOLON /*19L*/
	;

GatePowExprStmt :
	GatePowExpr TOK_SEMICOLON /*19L*/
	;

GateGPhaseExpr :
	TOK_CTRL TOK_ASSOCIATION_OP /*18L*/ GPhaseExpr IdentifierList
	;

GateGPhaseStmt :
	GateGPhaseExpr TOK_SEMICOLON /*19L*/
	;

SwitchCaseStmt :
	TOK_CASE Expr ':' TOK_LEFT_CURLY SwitchScopedStmtList TOK_RIGHT_CURLY
	| TOK_CASE Expr ':' TOK_LEFT_CURLY SwitchScopedStmtList TOK_RIGHT_CURLY BreakStmt
	| TOK_CASE Expr ':' SwitchUnscopedStmtList
	| TOK_CASE Expr ':' SwitchUnscopedStmtList BreakStmt
	;

SwitchDefaultStmt :
	TOK_DEFAULT ':' TOK_LEFT_CURLY SwitchScopedStmtList TOK_RIGHT_CURLY
	| TOK_DEFAULT ':' TOK_LEFT_CURLY SwitchScopedStmtList TOK_RIGHT_CURLY BreakStmt
	| TOK_DEFAULT ':' SwitchUnscopedStmtList
	| TOK_DEFAULT ':' SwitchUnscopedStmtList BreakStmt
	;

FunctionCallStmtExpr :
	ParenFunctionCallExpr
	;

FunctionCallStmt :
	FunctionCallStmtExpr TOK_SEMICOLON /*19L*/
	;

FunctionCallExpr :
	ParenFunctionCallExpr
	;

ParenFunctionCallExpr :
	Identifier TOK_LEFT_PAREN ExprList TOK_RIGHT_PAREN
	;

ComplexInitializerExpr :
	BinaryOp TOK_IMAGINARY
	| BinaryOpSelfAssign TOK_IMAGINARY
	| BinaryOpPrePost TOK_IMAGINARY
	| UnaryOp TOK_IMAGINARY
	;

Delay :
	TOK_DELAY TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET
	| TOK_DELAY TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET IdentifierList
	| TOK_DELAY TOK_LEFT_BRACKET TimeUnit TOK_RIGHT_BRACKET
	| TOK_DELAY TOK_LEFT_BRACKET DurationOfDecl TOK_RIGHT_BRACKET
	| TOK_DELAY TOK_LEFT_BRACKET DurationOfDecl TOK_RIGHT_BRACKET IdentifierList
	| TOK_DELAY TOK_LEFT_BRACKET Identifier TOK_RIGHT_BRACKET IdentifierList
	| TOK_DELAY TOK_LEFT_BRACKET BinaryOp TOK_RIGHT_BRACKET
	| TOK_DELAY TOK_LEFT_BRACKET UnaryOp TOK_RIGHT_BRACKET
	| TOK_DELAY TOK_LEFT_PAREN Identifier TOK_RIGHT_PAREN Identifier
	;

DelayStmt :
	Delay TOK_SEMICOLON /*19L*/
	;

Stretch :
	TOK_STRETCH Identifier
	| TOK_STRETCH Identifier TOK_EQUAL_ASSIGN /*1R*/ Integer
	| TOK_STRETCH Identifier TOK_EQUAL_ASSIGN /*1R*/ Real
	| TOK_STRETCH Identifier TOK_EQUAL_ASSIGN /*1R*/ BinaryOpExpr
	| TOK_STRETCH Identifier TOK_EQUAL_ASSIGN /*1R*/ UnaryOp
	| TOK_STRETCH TOK_LEFT_BRACKET Integer TOK_RIGHT_BRACKET Identifier
	;

StretchStmt :
	Stretch TOK_SEMICOLON /*19L*/
	;

BoxStmt :
	TOK_BOX Identifier TOK_LEFT_CURLY BoxStmtList TOK_RIGHT_CURLY
	| TOK_BOXAS Identifier TOK_LEFT_CURLY BoxStmtList TOK_RIGHT_CURLY
	| TOK_BOXTO TimeUnit TOK_LEFT_CURLY BoxStmtList TOK_RIGHT_CURLY
	;

Newline :
	TOK_NEWLINE
	;

IncludeStmt :
	TOK_INCLUDE TOK_STRING_LITERAL
	| TOK_INCLUDE TOK_STRING_LITERAL TOK_SEMICOLON /*19L*/
	;

LineDirective :
	TOK_LINE ':' TOK_INTEGER_CONSTANT
	| TOK_LINE ':' TOK_INTEGER_CONSTANT TOK_SEMICOLON /*19L*/
	;

FileDirective :
	TOK_FILE ':' TOK_STRING_LITERAL
	| TOK_FILE ':' TOK_STRING_LITERAL TOK_SEMICOLON /*19L*/
	;

%%

O   [0-7]
D   [0-9]
NZ  [1-9]
L   [a-zA-Z_]
A   [a-zA-Z_0-9]
H   [a-fA-F0-9]
HP  (0[xX])
E   ([Ee][+-]?{D}+)
P   ([Pp][+-]?{D}+)
FS  (f|F|l|L)
IS  (((u|U)(l|L|ll|LL)?)|((l|L|ll|LL)(u|U)?))
CP  (u|U|L)
SP  (u8|u|U|L)
ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))
WS  [ \t\v\f]+

ASC     [\x00-\x7f]
ASCN    [\x00-\t\v-\x7f]
UC      [\x80-\xbf]
UC2     [\xc2-\xdf]
UC3     [\xe0-\xef]
UC4     [\xf0-\xf4]

UCANY    {ASC}|{UC2}{UC}|{UC3}{UC}{UC}|{UC4}{UC}{UC}{UC}
UCANYN   {ASCN}|{UC2}{UC}|{UC3}{UC}{UC}|{UC4}{UC}{UC}{UC}
UCONLY   {UC2}{UC}|{UC3}{UC}{UC}|{UC4}{UC}{UC}{UC}

CHARCONSTANT ('(([\\]['])|([^']))+')
STRINGLITERAL ["](([\\]["])|([^"]))*["]
INCLUDE [include][ ]{STRINGLITERAL}
PREPROC [#][ ][0-9]+[ ]{STRINGLITERAL}[ 0-9]*

%%

[ \t\v\f\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"%"	TOK_MOD_OP
"&"	'&'
"("	TOK_LEFT_PAREN
")"	TOK_RIGHT_PAREN
"*"	TOK_MUL_OP
"+"	TOK_ADD_OP
"-"	TOK_MINUS
"."	TOK_PERIOD
"/"	TOK_DIV_OP
":"	':'
";"	TOK_SEMICOLON
"<"	TOK_LT_OP
"="	TOK_EQUAL_ASSIGN
">"	TOK_GT_OP
//"@"	'@'
"["	TOK_LEFT_BRACKET
"]"	TOK_RIGHT_BRACKET
"^"	TOK_XOR_OP
"{"	TOK_LEFT_CURLY
"|"	'|'
"}"	TOK_RIGHT_CURLY
"~"	TOK_TILDE
"+="	TOK_ADD_ASSIGN
//"α"|"Α"	TOK_ALPHA
//"&"	TOK_AMPERSAND
"&="	TOK_AND_ASSIGN
"&&"	TOK_AND_OP
"angle"	TOK_ANGLE
@[a-zA-Z0-9]+	TOK_ANNOTATION
"acos"|"arccos"	TOK_ARCCOS
"asin"|"arcsin"	TOK_ARCSIN
"atan"|"arctan"	TOK_ARCTAN
"array"	TOK_ARRAY
"@"	TOK_ASSOCIATION_OP
"!"	TOK_BANG
"barrier"	TOK_BARRIER
//"β"|"Β"	TOK_BETA
"bit"|"cbit"	TOK_BIT
"bool"	TOK_BOOL
"false"|"true"	TOK_BOOLEAN_CONSTANT
("%"|"$")[0-9]+	TOK_BOUND_QUBIT
"box"	TOK_BOX
"boxas"	TOK_BOXAS
"boxto"	TOK_BOXTO
"break"	TOK_BREAK
"cal"	TOK_CAL
"case"	TOK_CASE
"CCX"	TOK_CCX
//"char"	TOK_CHAR
//"χ"|"Χ"	TOK_CHI
"cimag"	TOK_CIMAG
"CNOT"	TOK_CNOT
","	TOK_COMMA
"complex"	TOK_COMPLEX
"const"	TOK_CONST
"continue"	TOK_CONTINUE
"cos"	TOK_COS
"creal"	TOK_CREAL
"creg"	TOK_CREG
"ctrl"	TOK_CTRL
"CX"	TOK_CX
"--"	TOK_DEC_OP
"default"	TOK_DEFAULT
"defcal"	TOK_DEFCAL
"defcalgrammar"	TOK_DEFCAL_GRAMMAR
"delay"	TOK_DELAY
//"δ"|"Δ"	TOK_DELTA
//"dirty"	TOK_DIRTY
"/="	TOK_DIV_OP_ASSIGN
"do"	TOK_DO
"double"|"real"	TOK_DOUBLE
"duration"	TOK_DURATION
"durationof"	TOK_DURATIONOF
"..."	TOK_ELLIPSIS
"else"	TOK_ELSE
"else"[ \t\r\n]+"if"	TOK_ELSEIF
//TOK_END	TOK_END
//"enum"	TOK_ENUM
//"Ε"	TOK_EPSILON
"=="	TOK_EQ_OP
//TOK_ERROR	TOK_ERROR
//"η"|"Η"	TOK_ETA
//"euler"|"ε"	TOK_EULER
//TOK_EULER_NUMBER	TOK_EULER_NUMBER
"exp"	TOK_EXP
"extern"	TOK_EXTERN
"#"[ ]*"file"	TOK_FILE
//"fixed"	TOK_FIXED
"float"	TOK_FLOAT
"for"	TOK_FOR
"frame"	TOK_FRAME
[ ]+[.][ ]+frequency|".frequency"|[ ]+[.][ ]+freq|".freq"	TOK_FREQUENCY
"def"	TOK_FUNCTION_DEFINITION
//"__func__"	TOK_FUNC_NAME
//"γ"|"Γ"	TOK_GAMMA
"gate"	TOK_GATE
">="	TOK_GE_OP
//"goto"	TOK_GOTO
"gphase"	TOK_GPHASE
TOK_HADAMARD	TOK_HADAMARD
//TOK_HORIZONTAL_TAB	TOK_HORIZONTAL_TAB
"OPENQASM"	TOK_IBMQASM
"if"	TOK_IF
"im"	TOK_IMAGINARY
//"implements"	TOK_IMPLEMENTS
"in"	TOK_IN
"include"	TOK_INCLUDE
"++"	TOK_INC_OP
"input"	TOK_INPUT
"int"|"integer"	TOK_INT
"inv"	TOK_INVERSE
//"ι"|"Ι"	TOK_IOTA
//"κ"|"Κ"	TOK_KAPPA
//"kernel"	TOK_KERNEL
//"lambda"|"λ"|"Λ"	TOK_LAMBDA
//"<-"	TOK_LEFT_ARROW
//("["|"<:")	TOK_LEFT_BRACKET
//("{"|"<%")	TOK_LEFT_CURLY
"<<="	TOK_LEFT_SHIFT_ASSIGN
"<<"	TOK_LEFT_SHIFT_OP
//"length"	TOK_LENGTH
//"lengthof"	TOK_LENGTHOF
"let"	TOK_LET
"<="	TOK_LE_OP
"#"[ ]*"line"	TOK_LINE
"ln"	TOK_LN
//"long"	TOK_LONG
//TOK_LONG_DOUBLE	TOK_LONG_DOUBLE
"measure"	TOK_MEASURE
"%="	TOK_MOD_ASSIGN
//"μ"|"Μ"	TOK_MU
//TOK_MUL	TOK_MUL
"*="	TOK_MUL_ASSIGN

//TOK_NEG	TOK_NEG
"negctrl"	TOK_NEGCTRL
"newframe"	TOK_NEWFRAME
TOK_NEWLINE	TOK_NEWLINE
"!="	TOK_NE_OP
//"ν"|"Ν"	TOK_NU
//"ω"|"Ω"	TOK_OMEGA
//"ο"|"Ο"	TOK_OMICRON
"opaque"	TOK_OPAQUE
"|="	TOK_OR_ASSIGN
"||"|"|"	TOK_OR_OP
"output"	TOK_OUTPUT
[ ]+[.][ ]+phase|".phase"	TOK_PHASE
//"phi"|"φ"|"Φ"	TOK_PHI
//"pi"|"π"|"Π"	TOK_PI
"play"	TOK_PLAY
//TOK_PLUS	TOK_PLUS
"popcount"	TOK_POPCOUNT
"port"	TOK_PORT
"pow"	TOK_POW
//TOK_POW_OP	TOK_POW_OP
"pragma"	TOK_PRAGMA
//"ψ"|"Ψ"	TOK_PSI
//TOK_PTR_OP	TOK_PTR_OP
"qreg"	TOK_QREG
"qubit"	TOK_QUBIT
//TOK_QUBITS	TOK_QUBITS
//"?"	TOK_QUESTION
"reset"	TOK_RESET
"return"	TOK_RETURN
//"ρ"|"Ρ"	TOK_RHO
"->"	TOK_RIGHT_ARROW
//("]"|":>")	TOK_RIGHT_BRACKET
//("}"|"%>")	TOK_RIGHT_CURLY
">>="	TOK_RIGHT_SHIFT_ASSIGN
">>"	TOK_RIGHT_SHIFT_OP
"rotl"	TOK_ROTL
"rotr"	TOK_ROTR
//"short"	TOK_SHORT
//"σ"|"Σ"	TOK_SIGMA
//"signed"	TOK_SIGNED
"sin"	TOK_SIN
//"sizeof"	TOK_SIZEOF
"sqrt"	TOK_SQRT
TOK_START_OPENPULSE	TOK_START_OPENPULSE
TOK_START_OPENQASM	TOK_START_OPENQASM
"stretch"	TOK_STRETCH
//"stretchinf"	TOK_STRETCHINF
//"stretch"[0-9]+	TOK_STRETCH_N
//"struct"	TOK_STRUCT
"-="	TOK_SUB_ASSIGN
//"-"	TOK_SUB_OP
"switch"	TOK_SWITCH
"tan"	TOK_TAN
//"tau"|"τ"|"Τ"	TOK_TAU
//"theta"|"θ"|"Θ"	TOK_THETA
//"~"	TOK_TILDE
[ ]+[.][ ]+time|".time"	TOK_TIME
[0-9]+(ms|ns|us|μs|dt|s)	TOK_TIME_UNIT
//TOK_TYPEDEF_NAME	TOK_TYPEDEF_NAME
"U"	TOK_U
"uint"	TOK_UINT
("%"|"$")([a-zA-Z_]+|[a-zA-Z_][0-9]+)	TOK_UNBOUND_QUBIT
//"union"	TOK_UNION
//"unsigned"	TOK_UNSIGNED
//"υ"|"Υ"	TOK_UPSILON
//"verbatim"	TOK_VERBATIM
//TOK_VERTICAL_TAB	TOK_VERTICAL_TAB
//"void"	TOK_VOID
"waveform"	TOK_WAVEFORM
"while"	TOK_WHILE
//"ξ"|"Ξ"	TOK_XI
"^="	TOK_XOR_ASSIGN
//"^"	TOK_XOR_OP
//"ζ"|"Ζ"	TOK_ZETA
XELSEIF	XELSEIF
XIF	XIF

"-"?{HP}{H}+{IS}?	TOK_INTEGER_CONSTANT
{D}+	TOK_INTEGER_CONSTANT
"-"?{NZ}{D}*{IS}?	TOK_INTEGER_CONSTANT
"-"?"0"[bBoOxX]{O}*{IS}?	TOK_INTEGER_CONSTANT
"-"?{CP}?"'"([^'\\\n]|{ES})+"'"	TOK_INTEGER_CONSTANT
"-0"{O}*{IS}?	TOK_INTEGER_CONSTANT

"-"?{D}+{E}{FS}?	TOK_FP_CONSTANT
"-"?{D}*"."{D}+{E}?{FS}?	TOK_FP_CONSTANT
"-"{D}+"."{E}?{FS}?	TOK_FP_CONSTANT
"-"?{HP}{H}+{P}{FS}?	TOK_FP_CONSTANT
"-"?{HP}{H}*"."{H}+{P}{FS}?	TOK_FP_CONSTANT
"-"{HP}{H}+"."{P}{FS}?	TOK_FP_CONSTANT

({SP}?\"([^"\\\n]|{ES})*\"{WS}*)+	TOK_STRING_LITERAL

//Should be the last, order is important
{L}{A}*|{UCONLY}+([a-zA-Z_]+[0-9]+)?	TOK_IDENTIFIER
[a-zA-Z_]+[0-9]+{UCONLY}+	TOK_IDENTIFIER
[a-zA-Z0-9_]+{UCONLY}+[a-zA-Z0-9_]+	TOK_IDENTIFIER
{A}+{UCONLY}	TOK_IDENTIFIER
{UCONLY}+{A}+	TOK_IDENTIFIER
{UCONLY}+{A}+{UCONLY}+	TOK_IDENTIFIER
"%"[0-9a-zA-Z_]+	TOK_IDENTIFIER


%%
