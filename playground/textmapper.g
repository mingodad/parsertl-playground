//From: https://github.com/inspirer/textmapper/blob/01184f907850c5ce59064117f2cb4a5c18c9575f/parsers/tm/textmapper.tm
//for fn in `find textmapper -name '*.tm'`; do echo $fn:1:1; ./parsertl-playground textmapper3.g $fn; done
/*Tokens*/
%token OR
%token AND
%token OROR
%token ANDAND
//%token INVALID_TOKEN
%token SCON
%token ICON
%token TEMPLATES
//%token WHITESPACE
//%token COMMENT
//%token MULTILINECOMMENT
%token REM
//%token COLONCOLON
%token ASSIGN
%token ASSIGNASSIGN
%token EXCLASSIGN
%token SEMICOLON
%token DOT
%token COMMA
%token COLON
%token LBRACK
%token RBRACK
%token LPAREN
%token LPARENQUESTASSIGN
%token MINUSGT
%token RPAREN
%token RBRACE
%token LT
%token GT
%token MULT
%token PLUS
%token PLUSASSIGN
%token QUEST
%token EXCL
%token TILDE
%token DOLLAR
//%token AT
%token DIV
%token LBRACE
%token ERROR
%token ID
%token QUOTED_ID
%token AS
%token FALSE
%token IMPORT
%token SEPARATOR
%token SET
%token TRUE
%token ASSERT
%token BRACKETS
%token CLASS
%token EMPTY
%token EXPECT
%token EXPECTMINUSRR
%token EXPLICIT
%token EXTEND
%token FLAG
%token GENERATE
%token GLOBAL
%token INJECT
%token INLINE
%token INPUT
%token INTERFACE
%token LALR
%token LANGUAGE
%token LAYOUT
%token LEFT
//%token LEXER
%token LEXER_SECTION
%token LOOKAHEAD
%token NOMINUSEOI
%token NONASSOC
%token NONEMPTY
%token PARAM
//%token PARSER
%token PARSER_SECTION
%token PREC
%token RIGHT
%token CHAR_S
%token SHIFT
%token SPACE
%token CHAR_X
%token CODE
%token REGEXP
//%token YY_PARSE_file
//%token YY_PARSE_nonterm

%left /*1*/ OR
%left /*2*/ AND
%left /*3*/ OROR
%left /*4*/ ANDAND

%start YY_PARSE_file

%%

YY_PARSE_file :
	file
	| file TEMPLATES
	;
/*
YY_PARSE_nonterm :
	nonterm //YYEOF
	;
*/
identifier :
	ID
	| identifier_soft_Keywords
	;

identifier_soft_Keywords :
	BRACKETS
	| INLINE
	| PREC
	| SHIFT
	| INPUT
	| LEFT
	| RIGHT
	| NONASSOC
	| GENERATE
	| ASSERT
	| EMPTY
	| NONEMPTY
	| GLOBAL
	| EXPLICIT
	| LOOKAHEAD
	| PARAM
	| FLAG
	| NOMINUSEOI
	| CHAR_S
	| CHAR_X
	| EXPECT
	| EXPECTMINUSRR
	| CLASS
	| INTERFACE
	| SPACE
	| EXTEND
	| INJECT
	| LAYOUT
	| LANGUAGE
	| LALR
	//| LEXER
	//| PARSER
	;

identifier_Keywords :
	identifier
	| TRUE
	| FALSE
	| SEPARATOR
	| AS
	| IMPORT
	| SET
	;

identifier_Str :
	identifier
	| QUOTED_ID
	| SCON
	;

integer_literal :
	ICON
	;

string_literal :
	SCON
	;

boolean_literal :
	TRUE
	| FALSE
	;

literal :
	string_literal
	| integer_literal
	| boolean_literal
	;

pattern :
	REGEXP
	;

command :
	CODE
	;

syntax_problem :
	ERROR
	;

file :
	header import__optlist option_optlist syntax_problem lexer_section parser_section
	| header import__optlist option_optlist syntax_problem lexer_section
	| header import__optlist option_optlist syntax_problem parser_section
	| header import__optlist option_optlist syntax_problem
	| header import__optlist option_optlist lexer_section parser_section
	| header import__optlist option_optlist lexer_section
	| header import__optlist option_optlist parser_section
	| header import__optlist option_optlist
	;

import__optlist :
	import__optlist import_
	| %empty
	;

option_optlist :
	option_optlist option
	| %empty
	;

header :
	LANGUAGE identifier_Keywords LPAREN identifier_Keywords RPAREN SEMICOLON
	| LANGUAGE identifier_Keywords SEMICOLON
	;

lexer_section :
	//COLONCOLON /*.recoveryScope*/ LEXER lexer_parts
	LEXER_SECTION lexer_parts
	;

parser_section :
	//COLONCOLON .recoveryScope PARSER (LALR LPAREN lookahead=integer_literal RPAREN)? grammar_parts ;
	PARSER_SECTION grammar_parts
	| PARSER_SECTION LALR LPAREN integer_literal RPAREN grammar_parts
	;

import_ :
	IMPORT identifier string_literal SEMICOLON
	| IMPORT string_literal SEMICOLON
	;

option :
	identifier ASSIGN expression
	;

symref :
	identifier_Str
	;

symref_Args :
	identifier_Str args
	| identifier_Str
	;

rawType :
	CODE
	;

lexer_parts :
	lexer_part
	| lexer_parts lexer_part_OrSyntaxError
	;

lexer_part :
	named_pattern
	| lexeme
	| lexer_directive
	| start_conditions_scope
	;

lexer_part_OrSyntaxError :
	named_pattern
	| lexeme
	| lexer_directive
	| start_conditions_scope
	| syntax_problem
	;

named_pattern :
	identifier ASSIGN pattern
	;

start_conditions_scope :
	start_conditions LBRACE /*.recoveryScope*/ lexer_parts RBRACE
	;

start_conditions :
	LT MULT GT
	| LT stateref_list_Comma_separated GT
	;

stateref_list_Comma_separated :
	stateref_list_Comma_separated COMMA stateref
	| stateref
	;

lexeme :
	start_conditions identifier_Str lexeme_id rawTypeopt COLON pattern integer_literal lexeme_attrs command
	| start_conditions identifier_Str lexeme_id rawTypeopt COLON pattern integer_literal lexeme_attrs
	| start_conditions identifier_Str lexeme_id rawTypeopt COLON pattern integer_literal command
	| start_conditions identifier_Str lexeme_id rawTypeopt COLON pattern integer_literal
	| start_conditions identifier_Str lexeme_id rawTypeopt COLON pattern lexeme_attrs command
	| start_conditions identifier_Str lexeme_id rawTypeopt COLON pattern lexeme_attrs
	| start_conditions identifier_Str lexeme_id rawTypeopt COLON pattern command
	| start_conditions identifier_Str lexeme_id rawTypeopt COLON pattern
	| start_conditions identifier_Str lexeme_id rawTypeopt COLON lexeme_attrs
	| start_conditions identifier_Str lexeme_id rawTypeopt COLON
	| start_conditions identifier_Str rawTypeopt COLON pattern integer_literal lexeme_attrs command
	| start_conditions identifier_Str rawTypeopt COLON pattern integer_literal lexeme_attrs
	| start_conditions identifier_Str rawTypeopt COLON pattern integer_literal command
	| start_conditions identifier_Str rawTypeopt COLON pattern integer_literal
	| start_conditions identifier_Str rawTypeopt COLON pattern lexeme_attrs command
	| start_conditions identifier_Str rawTypeopt COLON pattern lexeme_attrs
	| start_conditions identifier_Str rawTypeopt COLON pattern command
	| start_conditions identifier_Str rawTypeopt COLON pattern
	| start_conditions identifier_Str rawTypeopt COLON lexeme_attrs
	| start_conditions identifier_Str rawTypeopt COLON
	| identifier_Str lexeme_id rawTypeopt COLON pattern integer_literal lexeme_attrs command
	| identifier_Str lexeme_id rawTypeopt COLON pattern integer_literal lexeme_attrs
	| identifier_Str lexeme_id rawTypeopt COLON pattern integer_literal command
	| identifier_Str lexeme_id rawTypeopt COLON pattern integer_literal
	| identifier_Str lexeme_id rawTypeopt COLON pattern lexeme_attrs command
	| identifier_Str lexeme_id rawTypeopt COLON pattern lexeme_attrs
	| identifier_Str lexeme_id rawTypeopt COLON pattern command
	| identifier_Str lexeme_id rawTypeopt COLON pattern
	| identifier_Str lexeme_id rawTypeopt COLON lexeme_attrs
	| identifier_Str lexeme_id rawTypeopt COLON
	| identifier_Str rawTypeopt COLON pattern integer_literal lexeme_attrs command
	| identifier_Str rawTypeopt COLON pattern integer_literal lexeme_attrs
	| identifier_Str rawTypeopt COLON pattern integer_literal command
	| identifier_Str rawTypeopt COLON pattern integer_literal
	| identifier_Str rawTypeopt COLON pattern lexeme_attrs command
	| identifier_Str rawTypeopt COLON pattern lexeme_attrs
	| identifier_Str rawTypeopt COLON pattern command
	| identifier_Str rawTypeopt COLON pattern
	| identifier_Str rawTypeopt COLON lexeme_attrs
	| identifier_Str rawTypeopt COLON
	;

lexeme_id :
	LPAREN identifier_Keywords RPAREN
	;

lexeme_attrs :
	LPAREN lexeme_attribute RPAREN
	;

lexeme_attribute :
	CLASS
	| SPACE
	;

lexer_directive :
	REM BRACKETS symref symref SEMICOLON
	| REM CHAR_S lexer_state_list_Comma_separated SEMICOLON
	| REM CHAR_X lexer_state_list_Comma_separated SEMICOLON
	;

lexer_state_list_Comma_separated :
	lexer_state_list_Comma_separated COMMA lexer_state
	| lexer_state
	;

stateref :
	identifier
	;

lexer_state :
	identifier
	;

grammar_parts :
	grammar_part
	| grammar_parts grammar_part_OrSyntaxError
	;

grammar_part :
	nonterm
	| template_param
	| directive
	;

grammar_part_OrSyntaxError :
	nonterm
	| template_param
	| directive
	| syntax_problem
	;

nonterm :
	identifier nonterm_params nonterm_alias rawType reportClause COLON rules SEMICOLON
	| identifier nonterm_params nonterm_alias rawType COLON rules SEMICOLON
	| identifier nonterm_params nonterm_alias reportClause COLON rules SEMICOLON
	| identifier nonterm_params nonterm_alias COLON rules SEMICOLON
	| identifier nonterm_params rawType reportClause COLON rules SEMICOLON
	| identifier nonterm_params rawType COLON rules SEMICOLON
	| identifier nonterm_params reportClause COLON rules SEMICOLON
	| identifier nonterm_params COLON rules SEMICOLON
	| identifier nonterm_alias rawType reportClause COLON rules SEMICOLON
	| identifier nonterm_alias rawType COLON rules SEMICOLON
	| identifier nonterm_alias reportClause COLON rules SEMICOLON
	| identifier nonterm_alias COLON rules SEMICOLON
	| identifier rawType reportClause COLON rules SEMICOLON
	| identifier rawType COLON rules SEMICOLON
	| identifier reportClause COLON rules SEMICOLON
	| identifier COLON rules SEMICOLON
	| EXTEND identifier nonterm_alias reportClause COLON rules SEMICOLON
	| EXTEND identifier nonterm_alias COLON rules SEMICOLON
	| EXTEND identifier reportClause COLON rules SEMICOLON
	| EXTEND identifier COLON rules SEMICOLON
	| INLINE identifier nonterm_params nonterm_alias reportClause COLON rules SEMICOLON
	| INLINE identifier nonterm_params nonterm_alias COLON rules SEMICOLON
	| INLINE identifier nonterm_params reportClause COLON rules SEMICOLON
	| INLINE identifier nonterm_params COLON rules SEMICOLON
	| INLINE identifier nonterm_alias reportClause COLON rules SEMICOLON
	| INLINE identifier nonterm_alias COLON rules SEMICOLON
	| INLINE identifier reportClause COLON rules SEMICOLON
	| INLINE identifier COLON rules SEMICOLON
	;

nonterm_alias :
	LBRACK identifier_Keywords RBRACK
	;

assoc :
	LEFT
	| RIGHT
	| NONASSOC
	;

param_modifier :
	LOOKAHEAD
	;

template_param :
	REM param_modifier param_type identifier ASSIGN param_value SEMICOLON
	| REM param_modifier param_type identifier SEMICOLON
	| REM param_type identifier ASSIGN param_value SEMICOLON
	| REM param_type identifier SEMICOLON
	;

directive :
	REM assoc references SEMICOLON
	| REM INPUT inputref_list_Comma_separated SEMICOLON
	| REM INTERFACE identifier_list_Comma_separated SEMICOLON
	| REM ASSERT EMPTY rhsSet SEMICOLON
	| REM ASSERT NONEMPTY rhsSet SEMICOLON
	| REM GENERATE identifier ASSIGN rhsSet SEMICOLON
	| REM EXPECT integer_literal SEMICOLON
	| REM EXPECTMINUSRR integer_literal SEMICOLON
	| REM INJECT symref reportClause SEMICOLON
	;

identifier_list_Comma_separated :
	identifier_list_Comma_separated COMMA identifier
	| identifier
	;

inputref_list_Comma_separated :
	inputref_list_Comma_separated COMMA inputref
	| inputref
	;

inputref :
	symref NOMINUSEOI
	| symref
	;

references :
	symref
	| references symref
	;

rules :
	rule0
	| rules OR /*1L*/ rule0
	;

rule0 :
	predicate rhsParts reportClause
	| predicate rhsParts
	| predicate reportClause
	| predicate
	| rhsParts reportClause
	| rhsParts
	| reportClause
	| %empty
	| syntax_problem
	;

predicate :
	LBRACK predicate_expression RBRACK
	;

reportClause :
	MINUSGT identifier DIV identifier_list_Comma_separated reportAs
	| MINUSGT identifier DIV identifier_list_Comma_separated
	| MINUSGT identifier reportAs
	| MINUSGT identifier
	;

reportAs :
	AS identifier
	;

rhsParts :
	rhsPart
	| rhsParts rhsPart_OrSyntaxError
	;

rhsPart :
	rhsAssignment
	| command
	| rhsStateMarker
	| rhsLookahead
	| REM EMPTY
	| REM PREC symref
	;

rhsPart_OrSyntaxError :
	rhsAssignment
	| command
	| rhsStateMarker
	| rhsLookahead
	| REM EMPTY
	| REM PREC symref
	| syntax_problem
	;

lookahead_predicate_list_And_separated :
	lookahead_predicate_list_And_separated AND /*2L*/ lookahead_predicate
	| lookahead_predicate
	;

rhsLookahead :
	LPARENQUESTASSIGN lookahead_predicate_list_And_separated RPAREN
	;

lookahead_predicate :
	EXCL symref
	| symref
	;

rhsStateMarker :
	DOT identifier
	;

rhsAssignment :
	rhsOptional
	| identifier ASSIGN rhsOptional
	| identifier PLUSASSIGN rhsOptional
	;

rhsOptional :
	rhsCast
	| rhsCast QUEST
	;

rhsCast :
	rhsAlias
	| rhsAlias AS symref_Args
	;

rhsAlias :
	rhsPrimary
	| rhsPrimary LBRACK identifier_Keywords RBRACK
	;

listSeparator :
	SEPARATOR references
	;

rhsPrimary :
	symref_Args
	| LPAREN /*.recoveryScope*/ rules RPAREN
	| LPAREN /*.recoveryScope*/ rhsParts listSeparator RPAREN PLUS
	| LPAREN /*.recoveryScope*/ rhsParts listSeparator RPAREN MULT
	| rhsPrimary PLUS
	| rhsPrimary MULT
	| DOLLAR LPAREN /*.recoveryScope*/ rules RPAREN
	| rhsSet
	;

rhsSet :
	SET LPAREN /*.recoveryScope*/ setExpression RPAREN
	;

setPrimary :
	identifier symref_Args
	| symref_Args
	| LPAREN setExpression RPAREN
	| TILDE setPrimary
	;

setExpression :
	setPrimary
	| setExpression OR /*1L*/ setExpression
	| setExpression AND /*2L*/ setExpression
	;

nonterm_param_list_Comma_separated :
	nonterm_param_list_Comma_separated COMMA nonterm_param
	| nonterm_param
	;

nonterm_params :
	LT nonterm_param_list_Comma_separated GT
	;

nonterm_param :
	param_ref
	| identifier identifier ASSIGN param_value
	| identifier identifier
	;

param_ref :
	identifier
	;

args :
	LT argument_list_Comma_separatedopt GT
	;

argument_list_Comma_separated :
	argument_list_Comma_separated COMMA argument
	| argument
	;

argument_list_Comma_separatedopt :
	argument_list_Comma_separated
	| %empty
	;

argument :
	param_ref COLON param_value
	| param_ref
	| PLUS param_ref
	| TILDE param_ref
	;

param_type :
	FLAG
	| PARAM
	;

param_value :
	literal
	| param_ref
	;

predicate_primary :
	param_ref
	| EXCL param_ref
	| param_ref ASSIGNASSIGN literal
	| param_ref EXCLASSIGN literal
	;

predicate_expression :
	predicate_primary
	| predicate_expression ANDAND /*4L*/ predicate_expression
	| predicate_expression OROR /*3L*/ predicate_expression
	;

expression :
	literal
	| LBRACK expression_list_Comma_separated COMMA RBRACK
	| LBRACK expression_list_Comma_separated RBRACK
	| LBRACK COMMA RBRACK
	| LBRACK RBRACK
	| syntax_problem
	;

expression_list_Comma_separated :
	expression_list_Comma_separated COMMA expression
	| expression
	;

rawTypeopt :
	rawType
	| %empty
	;

%%

/*%s initial afterID afterColonOrEq afterGT*/
%x afterGT afterID CODE_ST

/*Macros*/

reClass	\[([^\n\r\]\\]|\\.)*\]
reFirst	[^\n\r\*\[\\\/]|\\.|{reClass}
reChar	{reFirst}|\*

SPACES	[ \t\r\n]+
COMMENT	#[^\r\n]*
C_STYLE_COMMENT [/][*](?s:.)*?[*][/]

ID  [a-zA-Z_]([a-zA-Z_\-0-9]*[a-zA-Z_0-9])?|'(\\.|[^'\n\r\\])*'

%%
/*Lexer*/

{SPACES} skip()
{COMMENT}	skip()
{C_STYLE_COMMENT}	skip()

"|"	OR
"&"	AND
"||"	OROR
"&&"	ANDAND
"brackets"	BRACKETS
"inline"	INLINE
"prec"	PREC
"shift"	SHIFT
"input"	INPUT
"left"	LEFT
"right"	RIGHT
"nonassoc"	NONASSOC
"generate"	GENERATE
"assert"	ASSERT
"empty"	EMPTY
"nonempty"	NONEMPTY
"global"	GLOBAL
"explicit"	EXPLICIT
"lookahead"	LOOKAHEAD
"param"	PARAM
"flag"	FLAG
"no-eoi"	NOMINUSEOI
"s"	CHAR_S
"x"	CHAR_X
"expect"	EXPECT
"expect-rr"	EXPECTMINUSRR
"class"	CLASS
"interface"	INTERFACE
"space"	SPACE
"extend"	EXTEND
"inject"	INJECT
"layout"	LAYOUT
"language"	LANGUAGE
"lalr"	LALR
/*"lexer"	LEXER*/
"::"[ \t]*"lexer"   LEXER_SECTION
/*"parser"	PARSER*/
"::"[ \t]*"parser"   PARSER_SECTION
"true"	TRUE
"false"	FALSE
"separator"	SEPARATOR
"as"	AS
"import"	IMPORT
"set"	SET
"("	LPAREN
")"	RPAREN
";"	SEMICOLON
/*"::"	COLONCOLON*/
"="	ASSIGN
"}"	RBRACE
"<"	LT
"*"	MULT
">"<afterGT>	GT
","	COMMA
":"	COLON
"%"	REM
"["	LBRACK
"]"	RBRACK
"->"	MINUSGT
"(?="	LPARENQUESTASSIGN
"!"	EXCL
"."	DOT
"+="	PLUSASSIGN
"?"	QUEST
"+"	PLUS
"$"	DOLLAR
"~"	TILDE
//"@"	AT
"=="	ASSIGNASSIGN
"!="	EXCLASSIGN

"xerror"	ERROR /*TODO fix bug with 'error' as reserved keyword*/

<afterGT>[ \t]+"{"\n<INITIAL> LBRACE /* only accept a '{' folllowed by '\n' */
<afterGT>\n|.<INITIAL> reject()

<afterID>"/"<INITIAL> DIV
<afterID>"/*"<INITIAL> reject()
<afterID>\n|.<INITIAL> reject()

/* Order matter if identifier comes before keywords they are classified as identifier */
{ID}<afterID>	ID
-?[0-9]+	ICON
\"(\\.|[^\"\n\r\\])+\"	SCON
'(\\.|[^\'\n\r\\])+''	QUOTED_ID
\/(\\.|[^/\n])+\/	REGEXP
/*\{(?s:[^}])+\}	CODE*/
<INITIAL,CODE_ST>"{"<>CODE_ST>
<CODE_ST>(?s:[^}])<.>
<CODE_ST>"}"<<> CODE

\%\%(?s:.)+ TEMPLATES

//.	INVALID_TOKEN

%%
