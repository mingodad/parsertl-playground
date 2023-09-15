//From: https://github.com/sillydan1/expr/blob/main/src/expr-lang/expr.y
/* MIT License
 *
 * Copyright (c) 2022 Asger Gitz-Johansen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

 /*
 Replaced right recursion by left recursion on rule statements.
 */

/*Tokens*/
%token MINUS
%token PLUS
%token STAR
%token SLASH
%token PERCENT
%token HAT
%token AND
%token OR
%token XOR
%token IMPLIES
%token GT
%token GE
%token EE
%token NE
%token LE
%token LT
%token NOT
%token LPAREN
%token RPAREN
%token ASSIGN
%token TERM
%token IDENTIFIER
%token ACCESS_MOD
%token TYPE
%token NUMBER
%token FLOAT
%token BOOL
%token STRING
%token CLOCK

%left /*1*/ XOR
%left /*2*/ OR
%left /*3*/ AND
%left /*4*/ GT GE EE NE LE LT
%left /*5*/ MINUS PLUS STAR SLASH PERCENT HAT
%left /*6*/ IMPLIES
%precedence /*7*/ NOT LPAREN

%start unit

%%

unit :
	statements
	| exp
	;

statements :
	statement
	| statements statement
	;

statement :
	IDENTIFIER ASSIGN exp
	| TYPE IDENTIFIER ASSIGN exp
	| ACCESS_MOD IDENTIFIER ASSIGN exp
	| ACCESS_MOD TYPE IDENTIFIER ASSIGN exp
	| statement TERM
	;

exp :
	lit
	| bin_op
	| mono_op
	;

bin_op :
	exp PLUS /*5L*/ exp
	| exp MINUS /*5L*/ exp
	| exp STAR /*5L*/ exp
	| exp SLASH /*5L*/ exp
	| exp PERCENT /*5L*/ exp
	| exp HAT /*5L*/ exp
	| exp GT /*4L*/ exp
	| exp GE /*4L*/ exp
	| exp EE /*4L*/ exp
	| exp NE /*4L*/ exp
	| exp LE /*4L*/ exp
	| exp LT /*4L*/ exp
	| exp OR /*2L*/ exp
	| exp XOR /*1L*/ exp
	| exp IMPLIES /*6L*/ exp
	| exp AND /*3L*/ exp
	;

mono_op :
	NOT /*7P*/ exp
	| LPAREN /*7P*/ exp RPAREN
	;

lit :
	NUMBER
	| MINUS /*5L*/ NUMBER
	| FLOAT
	| MINUS /*5L*/ FLOAT
	| STRING
	| BOOL
	| CLOCK
	| IDENTIFIER
	;

%%

id     [a-z_A-Z]([.\(\)a-zA-Z_0-9]*[a-zA-Z_0-9]+)?
int    [0-9]+[Ll]?
clk    [0-9]+(_ms)
flt    [0-9]+[.][0-9]+[fd]?
bool   [Ff]alse|[Tt]rue
str    \"(\\.|[^\\"])*\"
blank  [ \t\r]
accmod [Pp](ublic|rivate|rotected)
type   int|long|float|double|string|bool|clock|timer|var|auto

%%

{blank}+   skip()
\n+        skip()

"-"        MINUS
"+"        PLUS
"*"        STAR
"/"        SLASH
"%"        PERCENT
"^"        HAT
"&&"       AND
"||"       OR
"^^"       XOR
"=>"       IMPLIES
">"        GT
">="       GE
"=="       EE
"!="       NE
"<="       LE
"<"        LT
"!"        NOT
"("        LPAREN
")"        RPAREN
":="       ASSIGN
";"        TERM
{type}     TYPE

{int}      NUMBER
{flt}      FLOAT
{clk}      CLOCK
{bool}     BOOL
{str}      STRING
{accmod}   ACCESS_MOD
{id}       IDENTIFIER

//<<EOF>>    YYEOF;
//.          throw expr::parser::syntax_error(*loc, "invalid character: " + std::string(YYText()));

%%
