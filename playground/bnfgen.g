/*
 * Copyright (c) 2014, 2021 Daniil Baturin
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

%token IDENTIFIER
%token STRING
%token NUMBER
%token DEF
%token OR
//%token EOF
%token SEMI
%token LBRACE
%token RBRACE
%token COMMA

%start  grammar

%%

/* Usual BNF with minor additions.
   Terminals are in single or double quotes. Nonterminals are in angle brackets.
   Left-hand and right-hand sides are separated by "::=".
   Rules are separated by a semicolon to handle multiline rules
   in an LR(1)-friendly manner.

   Rule part may have a "weight",
   that affects how often they are selected.

   There are also deterministic repetition rules, written as regex-like ranges.

   As in:
     <start> ::= 10 <nonterminal> "terminal" | "terminal"{1,3} ;
     <nonterminal> ::= "nonterminal";
 */

option_SEMI_ :
	/*empty*/
	| SEMI
	;

nonterminal :
	IDENTIFIER
	;

terminal :
	STRING
	;

repeat_range :
	LBRACE range_exact RBRACE
	| LBRACE range_min COMMA range_max RBRACE
	;

range_exact :
    NUMBER
    ;

range_min :
    NUMBER
    ;

range_max :
    NUMBER
    ;

symbol :
	terminal
	| nonterminal
	| symbol repeat_range
	;

rule_rhs_symbols :
	symbol
	| rule_rhs_symbols symbol
	;

rule_rhs_part :
	weigh_randon_sel rule_rhs_symbols
	| rule_rhs_symbols
	;

weigh_randon_sel :
    NUMBER
    ;

rule_rhs :
	rule_rhs_part
	| rule_rhs OR rule_rhs_part
	;

rule :
	nonterminal DEF rule_rhs
	;

rules :
	/*empty*/
	| rule
	| rules SEMI rule
	;

grammar :
	rules option_SEMI_ //EOF
	;

%%

%%

[ \t\n\r]+	skip()
"::="	DEF
"|"	OR
"<"[a-zA-Z_][a-zA-Z0-9_ ]*">"	IDENTIFIER
";"	SEMI
"{"	LBRACE
"}"	RBRACE
","	COMMA
[0-9]+	NUMBER
'("\\".|[^'\n\r\\])*'	STRING
\"("\\".|[^"\n\r\\])*\"	STRING
"#".*	skip()

%%
