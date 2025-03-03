//From: https://github.com/vnmakarov/yaep/blob/7aba93e1b49b3f1db0e20ba7d4e4158e2a0a8bb9/src/sgramm.y
/*
   YAEP (Yet Another Earley Parser)

   Copyright (c) 1997-2018  Vladimir Makarov <vmakarov@gcc.gnu.org>

   Permission is hereby granted, free of charge, to any person obtaining a
   copy of this software and associated documentation files (the
   "Software"), to deal in the Software without restriction, including
   without limitation the rights to use, copy, modify, merge, publish,
   distribute, sublicense, and/or sell copies of the Software, and to
   permit persons to whom the Software is furnished to do so, subject to
   the following conditions:

   The above copyright notice and this permission notice shall be included
   in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/
//Yaep grammar

%token IDENT CHAR
%token NUMBER
%token TERM

%%

file :
	file terms ';'
	| file rule
	| terms ';'
	| rule
	;

terms :
	terms IDENT number
	| TERM
	;

number :
	| '=' NUMBER
	;

rule :
	IDENT ':' rhs ';'
	;

rhs :
	rhs '|' alt
	| alt
	;

alt :
	seq trans
	;

seq :
	seq IDENT
	| seq CHAR
	|
	;

trans :
	| '#'
	| '#' NUMBER
	| '#' '-'
	| '#' IDENT cost '(' numbers ')'
	| '#' IDENT cost
	;

numbers :
        | numbers NUMBER
        | numbers '-'
        ;

cost :
	| NUMBER
	;

%%

%%

[\n\r\t ]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

":"	':'
";"	';'
"="	'='
"|"	'|'
"#"	'#'
"-"	'-'
"("	'('
")"	')'

TERM	TERM

[0-9]+	NUMBER

'(\\.|[^'\n\r\\])+'	CHAR
\"(\\.|[^"\n\r\\])+\"	CHAR

[A-Za-z_][A-Za-z0-9_]*	IDENT

%%
