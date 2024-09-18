//From: https://github.com/zmajeed/ebnfparser/blob/f51f9b2e73c76a42a5afbf8917ec76150331b22a/src/ebnftobison/grammar/ebnftobison.bison.y
/*
MIT License

Copyright (c) 2024 Zartaj Majeed

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/*Tokens*/
%token BAR
%token COLON_EQUAL
%token COMMENT
%token ELLIPSIS
%token HEADER_LINE
%token LEFT_BRACE
%token LEFT_BRACKET
%token LITERAL
%token NONTERMINAL
%token NONTERMINAL_LHS
%token RIGHT_BRACE
%token RIGHT_BRACKET
//%token RULE_SEPARATOR
%token TOKEN
//%token WHITESPACE


%start ebnf

%%

ebnf :
	header rule postprocess
	| header rule rules postprocess
	;

rules :
	rule
	| rules rule
	;

rule :
	NONTERMINAL_LHS COLON_EQUAL production_combo
	;

production_combo :
	concatenation
	| alternative
	| COMMENT
	;

production :
	element
	| optional
	| repetition
	| group
	;

element :
	NONTERMINAL
	| TOKEN
	| LITERAL
	| NONTERMINAL COMMENT
	| TOKEN COMMENT
	;

concatenation :
	production
	| concatenation production
	;

alternative :
	production_combo BAR concatenation
	;

optional :
	LEFT_BRACKET production_combo RIGHT_BRACKET
	;

repetition :
	element ELLIPSIS
	| group ELLIPSIS
	| optional ELLIPSIS
	;

group :
	LEFT_BRACE production_combo RIGHT_BRACE
	;

header :
	%empty
	| header_lines
	;

header_lines :
	HEADER_LINE
	| header_lines HEADER_LINE
	;

postprocess :
	%empty
	;

%%

// flex start conditions ie states
%x RULES
%x RULE_LHS
//%x COMMENT

nt_ident [-A-Za-z0-9 _/]+
ident [A-Za-z0-9_]+
WS	[ \t\v\f\r\n]

%%

HEADER_LINE	HEADER_LINE
<*>{WS}+	skip()

/* first rule of grammar is assumed to start at beginning of line */
^"<"{nt_ident}">"<RULE_LHS> reject()

 /* everything above first rule is header */
. skip()

 /* accumlate and send header line by line */
//\n skip()

 /* rematch start of rule that was matched earlier */
<RULE_LHS>{
	"<"{nt_ident}">" NONTERMINAL_LHS
	/* match rule assignment operator */
	::=<RULES> COLON_EQUAL
}


 /* patterns for rules body of grammar */
<RULES>{

 /* start of rule marks end of previous rule */
 /* put matched start of rule back to match again after returning rule separator token */
  "<"{nt_ident}">"{WS}*::=<RULE_LHS> reject()

  "<"{nt_ident}">" NONTERMINAL
 /* assumes multiline string literals are not allowed */
  //(?x: ["] ( [^"\n] | \\["] | \\\\ )* ["] ) LITERAL
  ["]([^"\n]|\\["]|\\\\)*["]  LITERAL

 /* assumes typical identifier syntax for grammar token */
  {ident} TOKEN

 /* alternative operator */
  "|" BAR

 /* start of optional operator */
  "[" LEFT_BRACKET

 /* end of optional operator */
  "]" RIGHT_BRACKET

 /* start of group operator */
  "{" LEFT_BRACE

 /* end of group operator */
  "}" RIGHT_BRACE

 /* repetition operator */
  "..." ELLIPSIS

 /* start of comment to end of line */
  "!!".* COMMENT

 /* match newlines separately to correctly update line numbers */
  //\n skip()

 /* whitespace except newline, same as [ \t\v\f\r] but easier to understand */
  //([[:space:]]{-}[\n])+ skip()

}

 /* all input must be consumed in every state to prevent flex scanner jammed error */
//<*>. {throw EbnfToBison::syntax_error(loc, "bad input \""s + yytext + "\""s);}

%%
