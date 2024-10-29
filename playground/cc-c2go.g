//From: https://github.com/andybalholm/c2go/blob/fbdc16ef23ebfced4119220a5e159b155d8cf37c/cc/cc.y
// Copyright 2013 The Go Authors.  All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// This grammar is derived from the C grammar in the 'ansitize'
// program, which carried this notice:
//
// Copyright (c) 2006 Russ Cox,
// 	Massachusetts Institute of Technology
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the
// Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall
// be included in all copies or substantial portions of the
// Software.
//
// The software is provided "as is", without warranty of any
// kind, express or implied, including but not limited to the
// warranties of merchantability, fitness for a particular
// purpose and noninfringement.  In no event shall the authors
// or copyright holders be liable for any claim, damages or
// other liability, whether in an action of contract, tort or
// otherwise, arising from, out of or in connection with the
// software or the use or other dealings in the software.

%token tokAuto
%token tokBreak
%token tokCase
%token tokChar
%token tokConst
%token tokContinue
%token tokDefault
%token tokDo
%token tokDotDotDot
%token tokDouble
%token tokEnum
//%token tokError
%token tokExtern
%token tokFloat
%token tokFor
%token tokGoto
%token tokIf
%token tokInline
%token tokInt
%token tokLitChar
%token tokLong
%token tokName
%token tokNumber
%token tokOffsetof
%token tokRegister
%token tokReturn
%token tokShort
%token tokSigned
%token tokStatic
%token tokStruct
%token tokSwitch
%token tokTypeName
%token tokTypedef
%token tokUnion
%token tokUnsigned
%token tokVaArg
%token tokVoid
%token tokVolatile
%token tokWhile
%token tokString
%token tokDefine

// fake operators to resolve if/else ambiguity
%left	tokShift
%left	tokElse
%left	tokTypeName
%left	'{'
%left	tokName

// real operators - usual c precedence
%left	','
%right	'=' tokAddEq tokSubEq tokMulEq tokDivEq tokModEq tokLshEq tokRshEq tokAndEq tokXorEq tokOrEq
%right	'?' ':'
%left	tokOrOr
%left	tokAndAnd
%left	'|'
%left	'^'
%left	'&'
%left	tokEqEq
%left	tokNotEq
%left	'<' '>' tokLtEq tokGtEq
%left	tokLsh tokRsh
%left	'+' '-'
%left	'*' '/' '%'
%right	tokCast
%left	'!' '~' tokSizeof tokUnary
%right	'.' '[' ']' '(' ')' tokDec tokInc tokArrow
%left	tokString

//%token	startExpr startProg tokEOF

%%

//top:
//	startProg prog tokEOF
//	| startExpr cexpr tokEOF
//	;

prog:
    %empty
	| prog xdecl
	;

cexpr:
	expr_list
	;

expr:
	tokName
	| tokNumber
	| tokLitChar
	| string_list
	| expr '+' expr
	| expr '-' expr
	| expr '*' expr
	| expr '/' expr
	| expr '%' expr
	| expr tokLsh expr
	| expr tokRsh expr
	| expr '<' expr
	| expr '>' expr
	| expr tokLtEq expr
	| expr tokGtEq expr
	| expr tokEqEq expr
	| expr tokNotEq expr
	| expr '&' expr
	| expr '^' expr
	| expr '|' expr
	| expr tokAndAnd expr
	| expr tokOrOr expr
	| expr '?' cexpr ':' expr
	| expr '=' expr
	| expr tokAddEq expr
	| expr tokSubEq expr
	| expr tokMulEq expr
	| expr tokDivEq expr
	| expr tokModEq expr
	| expr tokLshEq expr
	| expr tokRshEq expr
	| expr tokAndEq expr
	| expr tokXorEq expr
	| expr tokOrEq expr
	| '*' expr	%prec tokUnary
	| '&' expr	%prec tokUnary
	| '+' expr	%prec tokUnary
	| '-' expr	%prec tokUnary
	| '!' expr
	| '~' expr
	| tokInc expr
	| tokDec expr
	| tokSizeof expr	%prec tokSizeof
	| tokSizeof '(' abtype ')'	%prec tokSizeof
	| tokOffsetof '(' abtype ',' expr ')'	%prec tokSizeof
	| '(' abtype ')' expr	%prec tokCast
	| '(' abtype ')' braced_init_list	%prec tokCast
	| '(' cexpr ')'
	| expr '(' expr_list_opt ')'
	| expr '[' cexpr ']'
	| expr tokInc
	| expr tokDec
	| tokVaArg '(' expr ',' abtype ')'
	;

block1:
	| block1 decl
	| block1 lstmt
	;

block:
	'{' block1 '}'
	;

label:
	tokCase expr ':'
	| tokDefault ':'
	| tokName ':'
	;

lstmt:
	label_list_opt stmt
	;

stmt:
	';'
	| block
	| cexpr ';'
	| tokBreak ';'
	| tokContinue ';'
	| tokDo lstmt tokWhile '(' cexpr ')' ';'
	| tokFor '(' cexpr_opt ';' cexpr_opt ';' cexpr_opt ')' lstmt
	| tokFor '(' decl cexpr_opt ';' cexpr_opt ')' lstmt
	| tokGoto tag ';'
	| tokIf '(' cexpr ')' lstmt	%prec tokShift
	| tokIf '(' cexpr ')' lstmt tokElse lstmt
	| tokReturn cexpr_opt ';'
	| tokSwitch '(' cexpr ')' lstmt
	| tokWhile '(' cexpr ')' lstmt
	;

// Abstract declarator - abdec1 includes the slot where the name would go
abdecor:
	%empty
	| '*' qname_list_opt abdecor
	| abdec1
	;

abdec1:
	abdec1 '(' fnarg_list_opt ')'
	| abdecor '[' expr_opt ']'
	| '(' abdecor ')'
	;

// Concrete declarator
decor:
	tag
	| '*' qname_list_opt decor
	| '(' decor ')'
	| decor '(' fnarg_list_opt ')'
	| decor '[' expr_opt ']'
	;

// Function argument
fnarg:
	tokName
	| type abdecor
	| type decor
	| tokDotDotDot
	;

// Initialized declarator
idecor:
	decor
	| decor '=' init
	;

// Class words
cname:
	tokAuto
	| tokStatic
	| tokExtern
	| tokTypedef
	| tokRegister
	| tokInline
	;

// Qualifier words
qname:
	tokConst
	| tokVolatile
	;

// Type words
tname:
	tokChar
	| tokShort
	| tokInt
	| tokLong
	| tokSigned
	| tokUnsigned
	| tokFloat
	| tokDouble
	| tokVoid
	;

cqname:
	cname
	| qname
	;

cqtname:
	cqname
	| tname
	;

// Type specifier but not a tname
typespec:
	tokTypeName
	;

// Types annotated with class info.
//	typeclass:
//		cqname* typespec cqname*
//	|	cqname* tname cqtname*
//	|	cqname+
// except LALR(1) can't handle that.
typeclass:
	cqname_list %prec tokShift
	| cqname_list typespec cqname_list_opt
	| cqname_list tname cqtname_list_opt
	| typespec cqname_list_opt
	| tname cqtname_list_opt
	;

// Types without class info (check for class in higher level)
type:
	typeclass
	;

abtype:
	type abdecor
	;

// Declaration (finally)
decl:
	typeclass idecor_list_opt ';'
	;

topdecl:
	typeclass idecor_list_opt ';'
	;

define:
	tokDefine tokName expr
	;

xdecl:
	topdecl
	| fndef
	| tokExtern tokString '{' prog '}'
	| define
	;

fndef:
	typeclass decor decl_list_opt block
	;

tag:
	tokName
	| tokTypeName
	;

// struct/union
structunion:
	tokStruct
	| tokUnion
	;

sudecor:
	decor
	| tag_opt ':' expr
	;

sudecl:
	type sudecor_list_opt ';'
	;

typespec:
	structunion tag
	| structunion tag_opt '{' sudecl_list '}'
	;

initprefix:
	'.' tag
	;

expr:
	expr tokArrow tag
	| expr '.' tag
	;

// enum
typespec:
	tokEnum tag
	| tokEnum tag_opt '{' edecl_list comma_opt '}'
	;

edecl:
	tokName eqexpr_opt
	;

eqexpr:
	'=' expr
	;

// initializers
init:
	expr
	| braced_init_list
	;

braced_init_list:
	'{' '}'
	| '{' binit_list binit '}'
	| '{' binit_list binit ',' '}'
	;

binit_list:
	%empty
	| binit_list binit ','
	;

binit:
	init
	| initprefix_list eq_opt init
	;

initprefix:
	'[' expr ']'
	;

eq_opt:
	%empty
	| '='
	;

comma_opt:
	%empty
	| ','
	;

// Special notations - should be created implicitly
// if we ever finish the yacc replacement.

initprefix_list:
	initprefix
	| initprefix_list initprefix
	;

tag_opt:
	%empty
	| tag
	;

cexpr_opt:
	%empty
	| cexpr
	;

expr_opt:
	%empty
	| expr
	;

expr_list:
	expr
	| expr_list ',' expr
	;

expr_list_opt:
	%empty
	| expr_list
	;

decl_list_opt:
	%empty
	| decl_list_opt decl
	;

label_list_opt:
	%empty
	| label_list_opt label
	;

fnarg_list:
	fnarg
	| fnarg_list ',' fnarg
	;

fnarg_list_opt:
	%empty
	| fnarg_list
	;

idecor_list:
	idecor
	| idecor_list ',' idecor
	;

idecor_list_opt:
	%empty
	| idecor_list
	;

qname_list:
	qname
	| qname_list qname
	;

qname_list_opt:
	%empty
	| qname_list
	;

cqname_list:
	cqname
	| cqname_list cqname
	;

cqname_list_opt:
	%empty
	| cqname_list
	;

cqtname_list:
	cqtname
	| cqtname_list cqtname
	;

cqtname_list_opt:
	%empty
	| cqtname_list
	;

sudecor_list:
	sudecor
	| sudecor_list ',' sudecor
	;

sudecor_list_opt:
	%empty
	| sudecor_list
	;

sudecl_list:
	sudecl
	| sudecl_list sudecl
	;

eqexpr_opt:
	%empty
	| eqexpr
	;

edecl_list:
	edecl
	| edecl_list ',' edecl
	;

string_list:
	tokString
	| string_list tokString
	;

%%

%%

[ \t\r\n\f\v]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

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
"?"	'?'
"["	'['
"]"	']'
"^"	'^'
"{"	'{'
"|"	'|'
"}"	'}'
"~"	'~'

//startExpr	startExpr
//startProg	startProg
"+="	tokAddEq
"&&"	tokAndAnd
"&="	tokAndEq
"->"	tokArrow
"auto"	tokAuto
"break"	tokBreak
"case"	tokCase
"char"	tokChar
"const"	tokConst
"continue"	tokContinue
"--"	tokDec
"default"	tokDefault
"#define"	tokDefine
"/="	tokDivEq
"do"	tokDo
"..."	tokDotDotDot
"double"	tokDouble
//tokEOF	tokEOF
"else"	tokElse
"enum"	tokEnum
"=="	tokEqEq
//tokError	tokError
"extern"	tokExtern
"float"	tokFloat
"for"	tokFor
"goto"	tokGoto
">="	tokGtEq
"if"	tokIf
"++"	tokInc
"inline"	tokInline
"int"	tokInt
"long"	tokLong
"<<"	tokLsh
"<<="	tokLshEq
"<="	tokLtEq
"%="	tokModEq
"*="	tokMulEq
"!="	tokNotEq
"offsetof"	tokOffsetof
"|="	tokOrEq
"||"	tokOrOr
"register"	tokRegister
"return"	tokReturn
">>"	tokRsh
">>="	tokRshEq
"short"	tokShort
"signed"	tokSigned
"sizeof"	tokSizeof
"static"	tokStatic
"struct"	tokStruct
"-="	tokSubEq
"switch"	tokSwitch
"typedef"	tokTypedef
"union"	tokUnion
"unsigned"	tokUnsigned
"va_list"	tokVaArg
"void"	tokVoid
"volatile"	tokVolatile
"while"	tokWhile
"^="	tokXorEq

'(\\.|[^'\r\n\\])'	tokLitChar
\"(\\.|[^"\r\n\\])*\"	tokString
[0-9]+("."[0-9]+)?	tokNumber
tokTypeName	tokTypeName
[A-Za-z_][A-Za-z0-9_]*	tokName

%%
