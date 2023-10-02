//From: https://github.com/google/rune/blob/3a465c113e81c23fb8ce02aa7a21bc1d4cee6ade/parse/deparse.y
//  Copyright 2021 Google LLC.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

%x comment

/*Tokens*/
%token IDENT
%token STRING
%token INTEGER
%token RANDUINT
%token INTTYPE
%token UINTTYPE
%token BOOL
%token FLOAT
%token KWADDEQUALS
%token KWADDTRUNC
%token KWADDTRUNCEQUALS
%token KWAND
%token KWANDEQUALS
%token KWAPPENDCODE
%token KWARRAYOF
%token KWARROW
%token KWIMPLIES
%token KWAS
%token KWASSERT
%token KWBITANDEQUALS
%token KWBITOREQUALS
%token KWBITXOREQUALS
%token KWBOOL
%token KWCASCADE
%token KWCASTTRUNC
%token KWCLASS
%token KWDEBUG
%token KWDEFAULT
%token KWDIVEQUALS
%token KWDO
%token KWDOTDOTDOT
%token KWELSE
%token KWENUM
%token KWEQUAL
%token KWEXP
%token KWEXPEQUALS
%token KWEXPORT
%token KWEXPORTLIB
%token KWRPC
%token KWEXTERN
%token KWF32
%token KWF64
%token KWFINAL
%token KWFOR
%token KWFUNC
%token KWGE
%token KWTRANSFORM
%token KWTRANSFORMER
%token KWIF
%token KWIMPORT
%token KWIMPORTLIB
%token KWIMPORTRPC
%token KWIN
%token KWISNULL
%token KWITERATOR
%token KWLE
%token KWMOD
%token KWMODEQUALS
%token KWMULEQUALS
%token KWMULTRUNC
%token KWMULTRUNCEQUALS
%token KWNOTEQUAL
%token KWNULL
%token KWOPERATOR
%token KWOR
%token KWOREQUALS
%token KWPREPENDCODE
%token KWPRINT
%token KWPRINTLN
%token KWREF
%token KWRELATION
%token KWRETURN
%token KWREVEAL
%token KWROTL
%token KWROTLEQUALS
%token KWROTR
%token KWROTREQUALS
%token KWSECRET
%token KWSHL
%token KWSHLEQUALS
%token KWSHR
%token KWSHREQUALS
%token KWSIGNED
%token KWSTRING
%token KWSTRUCT
%token KWSUBEQUALS
%token KWSUBTRUNC
%token KWSUBTRUNCEQUALS
%token KWSWITCH
%token KWTRY
%token KWEXCEPT
%token KWRAISE
%token KWRAISES
%token KWPANIC
%token KWTYPEOF
%token KWTYPESWITCH
%token KWUNITTEST
%token KWUNREF
%token KWUNSIGNED
%token KWUSE
%token KWVAR
%token KWWHILE
%token KWWIDTHOF
%token KWXOR
%token KWXOREQUALS
%token KWYIELD
%token '!'
%token '%'
%token '&'
%token '('
%token ')'
%token '*'
%token '+'
%token ','
%token '-'
%token '.'
%token '/'
%token ':'
%token ';'
%token '<'
%token '='
%token '>'
%token '?'
%token '^'
%token '['
%token ']'
%token '{'
%token '|'
%token '}'
%token '~'
%token '\n'


%start goal

%%

goal :
	initialize optNewlines runeFile
	;

initialize :
	/*empty*/
	;

runeFile :
	statements
	;

statements :
	/*empty*/
	| statements statement
	;

statement :
	appendCode
	| assertStatement
	| assignmentStatement
	| callStatement
	| class
	| debugStatement
	| enum
	| externFunction
	| finalFunction
	| foreachStatement
	| forStatement
	| function
	| transformStatement
	| transformer
	| ifStatement
	| import
	| prependCode
	| printlnStatement
	| printStatement
	| refStatement
	| relationStatement
	| returnStatement
	| struct
	| switchStatement
	| typeswitchStatement
	| tryExceptStatements
	| exceptStatement
	| raiseStatement
	| panicStatement
	| unitTest
	| unrefStatement
	| whileStatement
	| yield
	;

import :
	KWIMPORT pathExpressionWithAlias newlines
	| KWIMPORTLIB pathExpressionWithAlias newlines
	| KWIMPORTRPC pathExpressionWithAlias newlines
	| KWUSE IDENT newlines
	;

class :
	classHeader '(' oneOrMoreParameters ')' optRaises block
	| exportClassHeader '(' oneOrMoreParameters ')' optRaises block
	;

classHeader :
	KWCLASS IDENT optWidth
	;

optWidth :
	/*empty*/
	| ':' UINTTYPE
	;

exportClassHeader :
	KWEXPORT KWCLASS IDENT optWidth
	| KWEXPORTLIB KWCLASS IDENT optWidth
	| KWRPC KWCLASS IDENT optWidth
	;

struct :
	structHeader '{' newlines structMembers '}' newlines
	| exportStructHeader block
	;

structHeader :
	KWSTRUCT IDENT
	;

structMembers :
	/*empty*/
	| structMembers structMember newlines
	;

structMember :
	IDENT optTypeExpression optInitializer
	;

optInitializer :
	/*empty*/
	| '=' expression
	;

exportStructHeader :
	KWEXPORT KWSTRUCT IDENT
	| KWEXPORTLIB KWSTRUCT IDENT
	;

appendCode :
	appendCodeHeader block
	;

appendCodeHeader :
	KWAPPENDCODE pathExpression
	| KWAPPENDCODE
	;

prependCode :
	prependCodeHeader block
	;

prependCodeHeader :
	KWPREPENDCODE pathExpression
	| KWPREPENDCODE
	;

block :
	'{' newlines statements '}' optNewlines
	;

function :
	functionHeader '(' parameters ')' optFuncTypeExpression optRaises block
	| exportFunctionHeader '(' parameters ')' optFuncTypeExpression optRaises block
	| rpcHeader '(' parameters ')' optFuncTypeExpression optRaises block
	;

functionHeader :
	KWFUNC IDENT
	| KWITERATOR IDENT
	| KWOPERATOR operator
	;

operator :
	'+'
	| '-'
	| '*'
	| '/'
	| '%'
	| KWAND
	| KWOR
	| KWXOR
	| '&'
	| '|'
	| '^'
	| KWEXP
	| KWSHL
	| KWSHR
	| KWROTL
	| KWROTR
	| KWADDTRUNC
	| KWSUBTRUNC
	| KWMULTRUNC
	| '~'
	| '<'
	| KWLE
	| '>'
	| KWGE
	| KWEQUAL
	| KWNOTEQUAL
	| '!'
	| '[' ']'
	| '<' '>'
	| KWIN
	;

exportFunctionHeader :
	KWEXPORT KWFUNC IDENT
	| KWEXPORT KWITERATOR IDENT
	| KWEXPORTLIB KWFUNC IDENT
	;

parameters :
	/*empty*/
	| oneOrMoreParameters
	;

oneOrMoreParameters :
	parameter
	| oneOrMoreParameters ',' optNewlines parameter
	;

parameter :
	optVar IDENT optTypeExpression
	| optVar '<' IDENT '>' optTypeExpression
	| initializedParameter
	;

optVar :
	/*empty*/
	| KWVAR
	;

initializedParameter :
	optVar IDENT optTypeExpression '=' expression
	;

externFunction :
	KWEXTERN STRING functionHeader '(' parameters ')' optFuncTypeExpression newlines
	| rpcHeader '(' parameters ')' optFuncTypeExpression newlines
	;

rpcHeader :
	KWRPC IDENT
	;

ifStatement :
	ifPart elseIfParts optElsePart
	;

ifPart :
	ifStatementHeader expression block
	;

ifStatementHeader :
	KWIF
	;

elseIfParts :
	/*empty*/
	| elseIfParts elseIfPart
	;

elseIfPart :
	elseIfStatementHeader expression block
	;

elseIfStatementHeader :
	KWELSE KWIF
	;

optElsePart :
	/*empty*/
	| elsePart
	;

elsePart :
	elseStatementHeader block
	;

elseStatementHeader :
	KWELSE
	;

switchStatement :
	switchStatementHeader expression switchBlock
	;

typeswitchStatement :
	typeswitchStatementHeader expression typeswitchBlock
	;

switchStatementHeader :
	KWSWITCH
	;

typeswitchStatementHeader :
	KWTYPESWITCH
	;

switchBlock :
	'{' newlines switchCases optDefaultCase '}' optNewlines
	;

typeswitchBlock :
	'{' newlines typeswitchCases optDefaultCase '}' optNewlines
	;

exceptBlock :
	'{' newlines exceptCases optDefaultCase '}' optNewlines
	;

switchCases :
	/*empty*/
	| switchCases switchCase
	;

typeswitchCases :
	/*empty*/
	| typeswitchCases typeswitchCase
	;

exceptCases :
	/*empty*/
	| exceptCases exceptCase
	;

switchCase :
	switchCaseHeaders KWIMPLIES block
	| switchCaseHeaders KWIMPLIES statement
	;

typeswitchCase :
	typeswitchCaseHeaders KWIMPLIES block
	| typeswitchCaseHeaders KWIMPLIES statement
	;

exceptCase :
	exceptCaseHeaders KWIMPLIES block
	| exceptCaseHeaders KWIMPLIES statement
	;

switchCaseHeaders :
	expression
	| switchCaseHeaders ',' optNewlines expression
	;

typeswitchCaseHeaders :
	typeExpression
	| typeswitchCaseHeaders ',' optNewlines typeExpression
	;

exceptCaseHeaders :
	pathExpression
	| exceptCaseHeaders ',' optNewlines pathExpression
	;

optDefaultCase :
	/*empty*/
	| defaultCaseHeader KWIMPLIES block
	| defaultCaseHeader KWIMPLIES statement
	;

defaultCaseHeader :
	KWDEFAULT
	;

whileStatement :
	optDoStatement whileStatementHeader expression newlines
	| optDoStatement whileStatementHeader expression block
	;

whileStatementHeader :
	KWWHILE
	;

optDoStatement :
	/*empty*/
	| doStatement
	;

doStatement :
	doStatementHeader block
	;

doStatementHeader :
	KWDO
	;

forStatement :
	forStatementHeader assignmentExpression ',' optNewlines expression ',' optNewlines assignmentExpression block
	;

forStatementHeader :
	KWFOR
	;

assignmentStatement :
	assignmentExpression newlines
	;

assignmentExpression :
	writableExpression optTypeExpression assignmentOp expression
	;

assignmentOp :
	'='
	| KWADDEQUALS
	| KWSUBEQUALS
	| KWMULEQUALS
	| KWDIVEQUALS
	| KWMODEQUALS
	| KWBITANDEQUALS
	| KWBITOREQUALS
	| KWBITXOREQUALS
	| KWANDEQUALS
	| KWOREQUALS
	| KWXOREQUALS
	| KWEXPEQUALS
	| KWSHLEQUALS
	| KWSHREQUALS
	| KWROTLEQUALS
	| KWROTREQUALS
	| KWADDTRUNCEQUALS
	| KWSUBTRUNCEQUALS
	| KWMULTRUNCEQUALS
	;

optTypeExpression :
	/*empty*/
	| ':' typeExpression
	;

typeExpression :
	typeRangeExpression
	| typeExpression '|' typeRangeExpression
	;

typeRangeExpression :
	compoundTypeExpression
	| typeLiteral KWDOTDOTDOT typeLiteral
	;

compoundTypeExpression :
	basicTypeExpression
	| '[' typeRangeExpressionList ']'
	| '(' typeRangeExpressionList ')'
	| '(' ')'
	;

typeRangeExpressionList :
	typeRangeExpression
	| typeRangeExpressionList ',' typeRangeExpression
	;

basicTypeExpression :
	typePathExpression
	| KWTYPEOF '(' expression ')'
	| KWUNSIGNED '(' expression ')'
	| KWSIGNED '(' expression ')'
	| typeLiteral
	| typePathExpression '?'
	| KWSECRET '(' typeRangeExpression ')'
	;

typePathExpression :
	pathExpression
	| pathExpression '<' oneOrMoreTypeExpressions '>'
	;

oneOrMoreTypeExpressions :
	typeExpression
	| oneOrMoreTypeExpressions ',' typeExpression
	;

optFuncTypeExpression :
	/*empty*/
	| KWARROW typeExpression
	;

accessExpression :
	writableExpression
	| callExpression
	| tokenExpression
	| STRING
	| accessExpression '[' expression ':' expression ']'
	| accessExpression '!'
	| '[' oneOrMoreExpressions ']'
	| '(' expression ')'
	| tupleExpression
	| KWSECRET '(' expression ')'
	| KWREVEAL '(' expression ')'
	| KWARRAYOF '(' typeExpression ')'
	| KWTYPEOF '(' expression ')'
	| KWNULL '(' callParameterList ')'
	| '&' pathExpression '(' expressionList ')'
	;

writableExpression :
	IDENT
	| accessExpression '.' IDENT
	| accessExpression '[' expression ']'
	;

tokenExpression :
	INTEGER
	| FLOAT
	| RANDUINT
	| BOOL
	| typeLiteral
	| returnsTokenExpression
	;

callExpression :
	accessExpression '(' callParameterList ')'
	;

callStatement :
	accessExpression '(' callParameterList ')' newlines
	;

optCallParameterList :
	/*empty*/
	| '(' oneOrMoreCallParameters ')'
	;

callParameterList :
	/*empty*/
	| oneOrMoreCallParameters optComma
	;

oneOrMoreCallParameters :
	callParameter
	| oneOrMoreCallParameters ',' optNewlines callParameter
	;

callParameter :
	expression
	| IDENT '=' expression
	;

optComma :
	/*empty*/
	| ','
	;

printStatement :
	KWPRINT expressionList newlines
	;

printlnStatement :
	KWPRINTLN expressionList newlines
	;

tryExceptStatements :
	tryStatement exceptStatement
	;

tryStatement :
	tryHeader block
	;

tryHeader :
	KWTRY
	;

exceptStatement :
	exceptHeader IDENT exceptBlock
	;

exceptHeader :
	KWEXCEPT
	;

raiseStatement :
	KWRAISE raiseExpressionList newlines
	;

raiseExpressionList :
	pathExpression
	| raiseExpressionList ',' optNewlines expression
	;

panicStatement :
	KWPANIC expressionList newlines
	;

assertStatement :
	KWASSERT expressionList newlines
	;

returnStatement :
	KWRETURN newlines
	| KWRETURN expression newlines
	;

transformer :
	transformerHeader '(' parameters ')' block
	;

transformerHeader :
	KWTRANSFORMER IDENT
	;

transformStatement :
	KWTRANSFORM pathExpression '(' expressionList ')' newlines
	;

relationStatement :
	KWRELATION pathExpression typePathExpression optLabel typePathExpression optLabel optCascade optCallParameterList newlines
	;

optLabel :
	/*empty*/
	| ':' STRING
	;

optCascade :
	/*empty*/
	| KWCASCADE
	;

yield :
	KWYIELD expression newlines
	;

unitTest :
	namedUnitTestHeader block
	| unnamedUnitTestHeader block
	;

namedUnitTestHeader :
	KWUNITTEST IDENT
	;

unnamedUnitTestHeader :
	KWUNITTEST
	;

debugStatement :
	debugHeader block
	;

debugHeader :
	KWDEBUG
	;

enum :
	enumHeader '{' newlines entries '}' newlines
	;

enumHeader :
	KWENUM IDENT
	;

entries :
	/*empty*/
	| entries entry
	;

entry :
	IDENT newlines
	| IDENT '=' INTEGER newlines
	;

foreachStatement :
	forStatementHeader IDENT KWIN expression block
	;

finalFunction :
	finalHeader '(' parameter ')' optRaises block
	;

finalHeader :
	KWFINAL
	;

optRaises :
	/*empty*/
	| KWRAISES oneOrMorePathExpressions
	;

oneOrMorePathExpressions :
	pathExpression
	| oneOrMorePathExpressions ',' optNewlines pathExpression
	;

refStatement :
	KWREF expression newlines
	;

unrefStatement :
	KWUNREF expression newlines
	;

expressionList :
	/*empty*/
	| oneOrMoreExpressions
	;

oneOrMoreExpressions :
	expression
	| oneOrMoreExpressions ',' optNewlines expression
	;

twoOrMoreExpressions :
	expression ',' optNewlines expression
	| twoOrMoreExpressions ',' optNewlines expression
	;

expression :
	dotDotDotExpression
	;

dotDotDotExpression :
	selectExpression KWDOTDOTDOT selectExpression
	| selectExpression
	;

selectExpression :
	orExpression
	| orExpression '?' optNewlines orExpression ':' optNewlines orExpression
	;

orExpression :
	xorExpression
	| orExpression KWOR optNewlines xorExpression
	;

xorExpression :
	andExpression
	| xorExpression KWXOR optNewlines andExpression
	;

andExpression :
	inExpression
	| andExpression KWAND optNewlines inExpression
	;

inExpression :
	modExpression
	| modExpression KWIN optNewlines modExpression
	;

modExpression :
	relationExpression
	| relationExpression KWMOD optNewlines bitorExpression
	;

relationExpression :
	bitorExpression
	| bitorExpression '<' optNewlines bitorExpression
	| bitorExpression KWLE optNewlines bitorExpression
	| bitorExpression '>' optNewlines bitorExpression
	| bitorExpression KWGE optNewlines bitorExpression
	| bitorExpression KWEQUAL optNewlines bitorExpression
	| bitorExpression KWNOTEQUAL optNewlines bitorExpression
	;

bitorExpression :
	bitxorExpression
	| bitorExpression '|' optNewlines bitxorExpression
	;

bitxorExpression :
	bitandExpression
	| bitxorExpression '^' optNewlines bitandExpression
	;

bitandExpression :
	shiftExpression
	| bitandExpression '&' optNewlines shiftExpression
	;

shiftExpression :
	addExpression
	| addExpression KWSHL optNewlines addExpression
	| addExpression KWSHR optNewlines addExpression
	| addExpression KWROTL optNewlines addExpression
	| addExpression KWROTR optNewlines addExpression
	;

addExpression :
	mulExpression
	| addExpression '+' optNewlines mulExpression
	| addExpression '-' optNewlines mulExpression
	| KWSUBTRUNC mulExpression
	| addExpression KWADDTRUNC optNewlines mulExpression
	| addExpression KWSUBTRUNC optNewlines mulExpression
	;

mulExpression :
	prefixExpression
	| mulExpression '*' optNewlines prefixExpression
	| mulExpression '/' optNewlines prefixExpression
	| mulExpression '%' optNewlines prefixExpression
	| mulExpression KWMULTRUNC optNewlines prefixExpression
	;

prefixExpression :
	exponentiateExpression
	| '!' prefixExpression
	| '~' prefixExpression
	| '-' prefixExpression
	| '<' typeExpression '>' prefixExpression
	| KWCASTTRUNC typeExpression '>' prefixExpression
	;

exponentiateExpression :
	accessExpression
	| accessExpression KWEXP optNewlines exponentiateExpression
	;

returnsTokenExpression :
	KWUNSIGNED '(' optNewlines expression ')'
	| KWSIGNED '(' optNewlines expression ')'
	| KWWIDTHOF '(' optNewlines expression ')'
	| KWISNULL '(' optNewlines expression ')'
	;

typeLiteral :
	UINTTYPE
	| INTTYPE
	| KWSTRING
	| KWBOOL
	| KWF32
	| KWF64
	;

pathExpression :
	IDENT
	| pathExpression '.' IDENT
	;

pathExpressionWithAlias :
	pathExpression
	| pathExpression KWAS IDENT
	;

tupleExpression :
	'(' twoOrMoreExpressions optComma ')'
	| '(' expression ',' ')'
	| '(' ')'
	;

optNewlines :
	/*empty*/
	| optNewlines '\n'
	;

newlines :
	'\n'
	| ';'
	| newlines '\n'
	| newlines ';'
	;

%%

%%

[ \t]*"//".*\n?       skip()
\n  '\n'

"/*"<>comment>
<comment>"/*"<>comment>
<comment>"*/"<<>	skip()
<comment>.|"\n"<.>
"("                     '('
")"                     ')'
"["                     '['
"]"                     ']'

"!"	'!'
"%"	'%'
"&"	'&'
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
"^"	'^'
"{"	'{'
"|"	'|'
"}"	'}'
"~"	'~'

[ \t]+                 skip()
"appendcode"           KWAPPENDCODE
"arrayof"              KWARRAYOF
"as"                   KWAS
"assert"               KWASSERT
"bool"                 KWBOOL
"cascade"              KWCASCADE
"class"                KWCLASS
"debug"                KWDEBUG
"default"              KWDEFAULT
"do"                   KWDO
"else"                 KWELSE
"enum"                 KWENUM
"export"               KWEXPORT
"exportlib"            KWEXPORTLIB
"rpc"                  KWRPC
"extern"               KWEXTERN
"false"                 BOOL
"final"                KWFINAL
"for"                  KWFOR
"func"                 KWFUNC
"transform"            KWTRANSFORM
"transformer"          KWTRANSFORMER
"if"                   KWIF
"import"               KWIMPORT
"importlib"            KWIMPORTLIB
"importrpc"            KWIMPORTRPC
"in"                   KWIN
"isnull"               KWISNULL
"iterator"             KWITERATOR
"mod"                  KWMOD
"null"                 KWNULL
"operator"             KWOPERATOR
"prependcode"          KWPREPENDCODE
"print"                KWPRINT
"println"              KWPRINTLN
"ref"                  KWREF
"relation"             KWRELATION
"return"               KWRETURN
"reveal"               KWREVEAL
"secret"               KWSECRET
"signed"               KWSIGNED
"string"               KWSTRING
("struct"|"message")   KWSTRUCT
"switch"               KWSWITCH
"typeswitch"           KWTYPESWITCH
"try"                  KWTRY
"except"               KWEXCEPT
"raise"                KWRAISE
"raises"                KWRAISES
"panic"                KWPANIC
"true"                  BOOL
"typeof"               KWTYPEOF
"unittest"             KWUNITTEST
"unref"                KWUNREF
"unsigned"             KWUNSIGNED
"use"                  KWUSE
"var"                  KWVAR
"while"                KWWHILE
"widthof"              KWWIDTHOF
"yield"                KWYIELD

"+="                   KWADDEQUALS
"!+="                  KWADDTRUNCEQUALS
"!+"                   KWADDTRUNC
"&&="                  KWANDEQUALS
"&="                   KWBITANDEQUALS
"&&"                   KWAND
"->"                   KWARROW
"=>"                   KWIMPLIES
"!<"                   KWCASTTRUNC
"/="                   KWDIVEQUALS
"..."                  KWDOTDOTDOT
"=="                   KWEQUAL
"**"                   KWEXP
"**="                  KWEXPEQUALS
">="                   KWGE
"<="                   KWLE
"%="                   KWMODEQUALS
"*="                   KWMULEQUALS
"!*="                  KWMULTRUNCEQUALS
"!*"                   KWMULTRUNC
"!="                   KWNOTEQUAL
"|="                   KWBITOREQUALS
"||="                  KWOREQUALS
"||"                   KWOR
"<<<="                 KWROTLEQUALS
"<<<"                  KWROTL
">>>="                 KWROTREQUALS
">>>"                  KWROTR
"<<="                  KWSHLEQUALS
"<<"                   KWSHL
">>="                  KWSHREQUALS
">>"                   KWSHR
"-="                   KWSUBEQUALS
"!-="                  KWSUBTRUNCEQUALS
"!-"                   KWSUBTRUNC
"^="                   KWBITXOREQUALS
"^^="                  KWXOREQUALS
"^^"                   KWXOR
"f32"                  KWF32
"f64"                  KWF64

"'\\a'"   INTEGER
"'\\b'"   INTEGER
"'\\e'"   INTEGER
"'\\f'"   INTEGER
"'\\n'"   INTEGER
"'\\r'"   INTEGER
"'\\t'"   INTEGER
"'\\v'"   INTEGER
"'\\0'"   INTEGER
"'\\''"   INTEGER
"'\\\\'"   INTEGER
"'"\\x[0-9a-fA-F][0-9a-fA-F]"'"  INTEGER

[0-9]+"e"("-")?[0-9]+"f32" FLOAT
[0-9]+"."("e"("-")?[0-9]+)?"f32"  FLOAT
[0-9]*"."[0-9]+("e"("-")?[0-9]+)?"f32"  FLOAT
[0-9]+"e"("-")?[0-9]+("f64")?  FLOAT
[0-9]+"."("e"("-")?[0-9]+)?("f64")?  FLOAT
[0-9]*"."[0-9]+("e"("-")?[0-9]+)?("f64")?  FLOAT
"'"[ -~]"'"             INTEGER
[0-9]+(("u"|"i")[0-9]+)?  INTEGER
"0x"[0-9a-fA-F]+(("u"|"i")[0-9]+)?  INTEGER
"rand"[0-9]+            RANDUINT
"u"[0-9]+               UINTTYPE
"i"[0-9]+               INTTYPE
([_a-zA-Z$]|[\xc0-\xff][\x80-\xbf]*)([a-zA-Z0-9_$]|[\xc0-\xff][\x80-\xbf]*)*  IDENT
\\[^ \t\n]+             IDENT
\"([^"]|\\.)*\"         STRING
//.

%%
