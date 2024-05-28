//From: https://github.com/ravynsoft/ravynos/blob/3e6a4985b937fa1dde45db33ba860243063a16a4/Frameworks/OpenGL/mesa/src/compiler/glsl/glcpp/glcpp-parse.y
/*
 * Copyright © 2010 Intel Corporation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice (including the next
 * paragraph) shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

/*Tokens*/
%token DEFINED
%token ELIF_EXPANDED
%token HASH_TOKEN
%token DEFINE_TOKEN
%token FUNC_IDENTIFIER
%token OBJ_IDENTIFIER
%token ELIF
%token ELSE
%token ENDIF
%token ERROR_TOKEN
%token IF
%token IFDEF
%token IFNDEF
%token LINE
%token PRAGMA
%token UNDEF
%token VERSION_TOKEN
%token GARBAGE
%token IDENTIFIER
%token IF_EXPANDED
%token INTEGER
%token INTEGER_STRING
%token LINE_EXPANDED
%token NEWLINE
%token OTHER
//%token PLACEHOLDER
%token SPACE
%token PLUS_PLUS
%token MINUS_MINUS
%token PATH
%token INCLUDE
%token PASTE
%token OR
%token AND
%token '|'
%token '^'
%token '&'
%token EQUAL
%token NOT_EQUAL
%token '<'
%token '>'
%token LESS_OR_EQUAL
%token GREATER_OR_EQUAL
%token LEFT_SHIFT
%token RIGHT_SHIFT
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token UNARY
%token '('
%token ')'
%token '!'
%token '~'
%token ','
%token '['
%token ']'
%token '{'
%token '}'
%token '.'
%token ';'
%token '='

%left /*1*/ OR
%left /*2*/ AND
%left /*3*/ '|'
%left /*4*/ '^'
%left /*5*/ '&'
%left /*6*/ EQUAL NOT_EQUAL
%left /*7*/ '<' '>' LESS_OR_EQUAL GREATER_OR_EQUAL
%left /*8*/ LEFT_SHIFT RIGHT_SHIFT
%left /*9*/ '+' '-'
%left /*10*/ '*' '/' '%'
%right /*11*/ UNARY

%start input

%%

input :
	/*empty*/
	| input line
	;

line :
	control_line
	| SPACE control_line
	| text_line
	| expanded_line
	;

expanded_line :
	IF_EXPANDED expression NEWLINE
	| ELIF_EXPANDED expression NEWLINE
	| LINE_EXPANDED integer_constant NEWLINE
	| LINE_EXPANDED integer_constant integer_constant NEWLINE
	| LINE_EXPANDED integer_constant PATH NEWLINE
	;

define :
	OBJ_IDENTIFIER replacement_list NEWLINE
	| FUNC_IDENTIFIER '(' ')' replacement_list NEWLINE
	| FUNC_IDENTIFIER '(' identifier_list ')' replacement_list NEWLINE
	;

control_line :
	control_line_success
	| control_line_error
	| HASH_TOKEN LINE pp_tokens NEWLINE
	;

control_line_success :
	HASH_TOKEN DEFINE_TOKEN define
	| HASH_TOKEN UNDEF IDENTIFIER NEWLINE
	| HASH_TOKEN INCLUDE NEWLINE
	| HASH_TOKEN IF pp_tokens NEWLINE
	| HASH_TOKEN IF NEWLINE
	| HASH_TOKEN IFDEF IDENTIFIER junk NEWLINE
	| HASH_TOKEN IFNDEF IDENTIFIER junk NEWLINE
	| HASH_TOKEN ELIF pp_tokens NEWLINE
	| HASH_TOKEN ELIF NEWLINE
	| HASH_TOKEN ELSE NEWLINE
	| HASH_TOKEN ENDIF NEWLINE
	| HASH_TOKEN VERSION_TOKEN version_constant NEWLINE
	| HASH_TOKEN VERSION_TOKEN version_constant IDENTIFIER NEWLINE
	| HASH_TOKEN NEWLINE
	| HASH_TOKEN PRAGMA NEWLINE
	;

control_line_error :
	HASH_TOKEN ERROR_TOKEN NEWLINE
	| HASH_TOKEN DEFINE_TOKEN NEWLINE
	| HASH_TOKEN GARBAGE pp_tokens NEWLINE
	;

integer_constant :
	INTEGER_STRING
	| INTEGER
	;

version_constant :
	INTEGER_STRING
	;

expression :
	integer_constant
	| IDENTIFIER
	| expression OR /*1L*/ expression
	| expression AND /*2L*/ expression
	| expression '|' /*3L*/ expression
	| expression '^' /*4L*/ expression
	| expression '&' /*5L*/ expression
	| expression NOT_EQUAL /*6L*/ expression
	| expression EQUAL /*6L*/ expression
	| expression GREATER_OR_EQUAL /*7L*/ expression
	| expression LESS_OR_EQUAL /*7L*/ expression
	| expression '>' /*7L*/ expression
	| expression '<' /*7L*/ expression
	| expression RIGHT_SHIFT /*8L*/ expression
	| expression LEFT_SHIFT /*8L*/ expression
	| expression '-' /*9L*/ expression
	| expression '+' /*9L*/ expression
	| expression '%' /*10L*/ expression
	| expression '/' /*10L*/ expression
	| expression '*' /*10L*/ expression
	| '!' expression %prec UNARY /*11R*/
	| '~' expression %prec UNARY /*11R*/
	| '-' /*9L*/ expression %prec UNARY /*11R*/
	| '+' /*9L*/ expression %prec UNARY /*11R*/
	| '(' expression ')'
	;

identifier_list :
	IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

text_line :
	NEWLINE
	| pp_tokens NEWLINE
	;

replacement_list :
	/*empty*/
	| pp_tokens
	;

junk :
	/*empty*/
	| pp_tokens
	;

pp_tokens :
	preprocessing_token
	| pp_tokens preprocessing_token
	;

preprocessing_token :
	IDENTIFIER
	| INTEGER_STRING
	| PATH
	| operator
	| DEFINED
	| OTHER
	| SPACE
	;

operator :
	'['
	| ']'
	| '('
	| ')'
	| '{'
	| '}'
	| '.'
	| '&' /*5L*/
	| '*' /*10L*/
	| '+' /*9L*/
	| '-' /*9L*/
	| '~'
	| '!'
	| '/' /*10L*/
	| '%' /*10L*/
	| LEFT_SHIFT /*8L*/
	| RIGHT_SHIFT /*8L*/
	| '<' /*7L*/
	| '>' /*7L*/
	| LESS_OR_EQUAL /*7L*/
	| GREATER_OR_EQUAL /*7L*/
	| EQUAL /*6L*/
	| NOT_EQUAL /*6L*/
	| '^' /*4L*/
	| '|' /*3L*/
	| AND /*2L*/
	| OR /*1L*/
	| ';'
	| ','
	| '='
	| PASTE
	| PLUS_PLUS
	| MINUS_MINUS
	;

%%

/* Note: When adding any start conditions to this list, you must also
	 * update the "Internal compiler error" catch-all rule near the end of
	 * this file. */

%x COMMENT DEFINE DEFINE2 DONE HASH NEWLINE_CATCHUP EPRAGMA

SPACE		[[:space:]]
NONSPACE	[^[:space:]]
HSPACE		[ \t\v\f]
HASH		#
NEWLINE		(\r\n|\n\r|\r|\n)
IDENTIFIER	[_a-zA-Z][_a-zA-Z0-9]*
PP_NUMBER	[.]?[0-9]([._a-zA-Z0-9]|[eEpP][-+])*
PUNCTUATION	[][(){}.&*~!/%<>^|;,=+-]

/* The OTHER class is simply a catch-all for things that the CPP
parser just doesn't care about. Since flex regular expressions that
match longer strings take priority over those matching shorter
strings, we have to be careful to avoid OTHER matching and hiding
something that CPP does care about. So we simply exclude all
characters that appear in any other expressions. */

OTHER		[^][_#[:space:]#a-zA-Z0-9(){}.&*~!/%<>^|;,=+-]

DIGITS			[0-9][0-9]*
DECIMAL_INTEGER		[1-9][0-9]*[uU]?
OCTAL_INTEGER		0[0-7]*[uU]?
HEXADECIMAL_INTEGER	0[xX][0-9a-fA-F]+[uU]?
PATH			["][^./ _A-Za-z0-9+*%[(){}|&~=!:;,?-]*["]

%%

	/* Single-line comments */
<INITIAL,DEFINE,HASH>"//"[^\r\n]* skip()

	/* Multi-line comments */
<INITIAL,DEFINE,HASH>"/*"<>COMMENT>
<COMMENT>[^*\r\n]+<.>
<COMMENT>[^*\r\n]*{NEWLINE}<.>
<COMMENT>"*"+[^*/\r\n]*<.>
//<COMMENT>"*"+[^*/\r\n]*{NEWLINE}<.>
<COMMENT>"*"+"/"<<>        skip()

{HASH}<HASH> 	HASH_TOKEN

	/* If the '#' is the first non-whitespace, non-comment token on this
	 * line, then it introduces a directive, switch to the <HASH> start
	 * condition.
	 *
	 * Otherwise, this is just punctuation, so return the HASH_TOKEN
         * token. */

<HASH>version{HSPACE}+<INITIAL> VERSION_TOKEN

	/* Swallow empty #pragma directives, (to avoid confusing the
	 * downstream compiler).
	 *
	 * Note: We use a simple regular expression for the lookahead
	 * here. Specifically, we cannot use the complete {NEWLINE} expression
	 * since it uses alternation and we've found that there's a flex bug
	 * where using alternation in the lookahead portion of a pattern
	 * triggers a buffer overrun. */
<HASH>pragma{HSPACE}*[\r\n]<EPRAGMA>	reject()
<EPRAGMA>{
	pragma	PRAGMA
	[^\r\n]+<.>
	[\r\n]<INITIAL>	reject()
}

	/* glcpp doesn't handle #extension, #version, or #pragma directives.
	 * Simply pass them through to the main compiler's lexer/parser. */
<HASH>(extension|pragma)[^\r\n]*<INITIAL> PRAGMA

<HASH>include{HSPACE}+["<][^./ _A-Za-z0-9+*%[(){}|&~=!:;,?-]+[">]<INITIAL> INCLUDE

<HASH>line{HSPACE}+<INITIAL> LINE

<HASH>{NEWLINE}<INITIAL> NEWLINE

	/* For the pre-processor directives, we return these tokens
	 * even when we are otherwise skipping. */
<HASH>ifdef<INITIAL>	IFDEF

<HASH>ifndef<INITIAL> 	IFNDEF

<HASH>if<INITIAL> 	IF

<HASH>elif<INITIAL> 	ELIF

<HASH>else<INITIAL> 	ELSE

<HASH>endif<INITIAL> 	ENDIF

<HASH>error[^\r\n]*<INITIAL> 	ERROR_TOKEN

	/* After we see a "#define" we enter the <DEFINE> start state
	 * for the lexer. Within <DEFINE> we are looking for the first
	 * identifier and specifically checking whether the identifier
	 * is followed by a '(' or not, (to lex either a
	 * FUNC_IDENTIFIER or an OBJ_IDENITIFIER token).
	 *
	 * While in the <DEFINE> state we also need to explicitly
	 * handle a few other things that may appear before the
	 * identifier:
	 *
	 * 	* Comments, (handled above with the main support for
	 * 	  comments).
	 *
	 *	* Whitespace (simply ignored)
	 *
	 *	* Anything else, (not an identifier, not a comment,
	 *	  and not whitespace). This will generate an error.
	 */
<HASH>define{HSPACE}*<DEFINE> 	DEFINE_TOKEN

<HASH>undef<INITIAL> 	UNDEF

<HASH>{HSPACE}+ 	skip()
	/* Nothing to do here. Importantly, don't leave the <HASH>
	 * start condition, since it's legal to have space between the
	 * '#' and the directive.. */

	/* This will catch any non-directive garbage after a HASH */
<HASH>{NONSPACE} 	GARBAGE

	/* An identifier immediately followed by '(' */
<DEFINE>{IDENTIFIER}"("<DEFINE2> 	reject()
<DEFINE2>{
	{IDENTIFIER}<INITIAL>	FUNC_IDENTIFIER
}

	/* An identifier not immediately followed by '(' */
<DEFINE>{IDENTIFIER}<INITIAL> 	OBJ_IDENTIFIER

	/* Whitespace */
<DEFINE>{HSPACE}+ skip()
	/* Just ignore it. Nothing to do here. */

	/* '/' not followed by '*', so not a comment. This is an error. */
//<DEFINE>[/][^*]{NONSPACE}*<INITIAL> 	INTEGER_STRING

	/* A character that can't start an identifier, comment, or
	 * space. This is an error. */
//<DEFINE>[^_a-zA-Z/[:space:]]{NONSPACE}*<INITIAL> INTEGER_STRING

{DECIMAL_INTEGER} 	INTEGER_STRING
{OCTAL_INTEGER} 	INTEGER_STRING
{HEXADECIMAL_INTEGER} 	INTEGER_STRING

"<<"  	LEFT_SHIFT
">>" 	RIGHT_SHIFT
"<=" 	LESS_OR_EQUAL
">=" 	GREATER_OR_EQUAL
"==" 	EQUAL
"!=" 	NOT_EQUAL
"&&" 	AND
"||" 	OR
"++" 	PLUS_PLUS
"--" 	MINUS_MINUS
"##" 	PASTE
"defined" DEFINED

"^"	'^'
"~"	'~'
"<"	'<'
"="	'='
">"	'>'
"|"	'|'
"-"	'-'
","	','
";"	';'
"!"	'!'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"*"	'*'
"&"	'&'
"%"	'%'
"+"	'+'

ELIF_EXPANDED	ELIF_EXPANDED
IF_EXPANDED	IF_EXPANDED
{DIGITS}	INTEGER
LINE_EXPANDED   LINE_EXPANDED
<*>"\\\n"	skip()

{IDENTIFIER} 	IDENTIFIER

{PP_NUMBER} 	OTHER

//{PUNCTUATION}

{OTHER}+ 	OTHER

{HSPACE} 	SPACE

{PATH} 	PATH

	/* We preserve all newlines, even between #if 0..#endif, so no
	skipping.. */
<*>{NEWLINE}<INITIAL> 	NEWLINE

//<INITIAL,COMMENT,DEFINE,HASH><<EOF>>

	/* This is a catch-all to avoid the annoying default flex action which
	 * matches any character and prints it. If any input ever matches this
	 * rule, then we have made a mistake above and need to fix one or more
	 * of the preceding patterns to match that input. */

//<*>.  glcpp_error(yylloc, yyextra, "Internal compiler error: Unexpected character: %s", yytext);

	/* We don't actually use the UNREACHABLE start condition. We
	only have this block here so that we can pretend to call some
	generated functions, (to avoid "defined but not used"
	warnings. */

%%
