//From: https://github.com/JetBrains/Grammar-Kit/blob/c465cf9b1a5e46d2d6faa2d367158fe48ed74784/grammars/Grammar.bnf

%token id
%token number
//%token parseGrammar
%token string

%token EXTERNAL_END
%token EXTERNAL_START
%token LEFT_BRACE
%token LEFT_BRACKET
%token LEFT_PAREN
%token OP_AND
%token OP_EQ
%token OP_IS
%token OP_NOT
%token OP_ONEMORE
%token OP_OPT
%token OP_OR
%token OP_ZEROMORE
%token RIGHT_BRACE
%token RIGHT_BRACKET
%token RIGHT_PAREN
%token SEMICOLON

%token TK_external
%token TK_fake
%token TK_inner
%token TK_left
%token TK_meta
%token TK_private
%token TK_upper

%fallback id TK_left

%token RULE_NAME

%%

grammar:
	  grammar_element
	;

grammar_element:
	  attrs
	| rule
	| grammar_element rule
	;

rule:
	  rule_start expression attrs_opt semi_opt
	;

semi_opt:
	  %empty
	| SEMICOLON
	;

attrs_opt:
	  %empty
	| attrs
	;

rule_start:
	  modifier_zom RULE_NAME OP_IS
	;

modifier_zom:
	  %empty
	| modifier_zom modifier
	;

modifier:
	  TK_private
	| TK_external
	| TK_meta
	| TK_inner
	| TK_left
	| TK_upper
	| TK_fake
	;

attrs:
	  LEFT_BRACE attr_zom RIGHT_BRACE
	;

attr_zom:
	  %empty
	| attr_zom attr
	;

attr:
	  attr_start attr_value semi_opt
	;

attr_start:
	  id attr_pattern OP_EQ
	| id OP_EQ
	;

attr_value:
	  attr_value_inner
	;

attr_value_inner:
	  reference_or_token
	| literal_expression
	| value_list
	;

attr_pattern:
	  LEFT_PAREN string_literal_expression RIGHT_PAREN
	;

value_list:
	  LEFT_BRACKET list_entry_zom RIGHT_BRACKET
	;

list_entry_zom:
	  %empty
	| list_entry_zom list_entry
	;

list_entry:
	  id list_entry_tail_opt semi_opt
	| string_literal_expression semi_opt
	;

list_entry_tail_opt:
	  %empty
	| list_entry_tail
	;

list_entry_tail:
	  OP_EQ string_literal_expression
	;

expression:
	  sequence choice_opt
	;

choice_opt:
	  %empty
	| choice
	;

sequence:
	  option_zom
	;

option_zom:
	  %empty
	| option_zom option
	;

option:
	  predicate
	| paren_opt_expression
	| simple quantified_opt
	;

quantified_opt:
	  %empty
	| quantified
	;

choice:
	  OP_OR sequence
	| choice OP_OR sequence
	;

quantified:
	  quantifier
	;

quantifier:
	  OP_OPT
	| OP_ONEMORE
	| OP_ZEROMORE
	;

predicate:
	  predicate_sign simple
	;

predicate_sign:
	  OP_AND
	| OP_NOT
	;

simple:
	  reference_or_token
	| literal_expression
	| external_expression
	| paren_expression
	;

external_expression:
	  EXTERNAL_START reference_or_token option_zom EXTERNAL_END
	;

reference_or_token:
	  id
	;

literal_expression:
	  string_literal_expression
	| number
	;

string_literal_expression:
	  string
	;

paren_expression:
	  LEFT_PAREN expression RIGHT_PAREN
	//| LEFT_BRACE alt_choice_element RIGHT_BRACE
	;

paren_opt_expression:
	  LEFT_BRACKET expression RIGHT_BRACKET
	;

//alt_choice_element:
//	  expression
//	;

%%

%x RULE_NAME

ID  [A-Za-z_][A-Za-z0-9_-]*
OP_IS   "::="

%%

[ \t\r\n]+  skip()
"//".*  skip()
"/*"(?s:.)*?"*/"    skip()

"!"	OP_NOT
"&"	OP_AND
"("	LEFT_PAREN
")"	RIGHT_PAREN
"*"	OP_ZEROMORE
"+"	OP_ONEMORE
";"	SEMICOLON
"<<"	EXTERNAL_START
"="	OP_EQ
">>"	EXTERNAL_END
"?"	OP_OPT
"["	LEFT_BRACKET
"]"	RIGHT_BRACKET
"external"	TK_external
"fake"	TK_fake
"inner"	TK_inner
"left"	TK_left
"meta"	TK_meta
"private"	TK_private
"upper"	TK_upper
"{"	LEFT_BRACE
"|"	OP_OR
"}"	RIGHT_BRACE

\d+	number
'(\\.|[^'\r\n\\])*'	string
\"(\\.|[^"\r\n\\])*\"	string
//parseGrammar	parseGrammar

{ID}\s*{OP_IS}<RULE_NAME>    reject()
<RULE_NAME>{
    {ID}    RULE_NAME
    {OP_IS}<INITIAL>    OP_IS
    \s+ skip()
}
{ID}	id

%%
