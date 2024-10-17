//From: https://github.com/bitkeeper-scm/tcl/blob/67374d1d4b20652a780eb29ce95d25ce1ea081f9/generic/Lgrammar.y
/*
 * Copyright (c) 2006-2008 BitMover, Inc.
 */

/*
 * We need a GLR parser because of a shift/reduce conflict introduced
 * by hash-element types.  This production is the culprit:
 *
 * array_or_hash_type: '{' scalar_type_specifier '}'
 *
 * This introduced a shift/reduce conflict on '{' due to '{' being in
 * the FOLLOW set of scalar_type_specifier because '{' can follow
 * type_specifier in function_decl.  For example, after you
 * have seen
 *
 *    struct s
 *
 * and '{' is the next token, the parser can't tell whether to shift
 * and proceed to parse a struct_specifier that declares a struct:
 *
 *    struct s { int x,y; }
 *
 * or whether to reduce and proceed in to a array_or_hash_type:
 *
 *    struct s { int } f() {}
 *
 * To make this grammar LALR(1) seemed difficult.  The grammar seems
 * to want to be LALR(3) perhaps(?).  The best we could do was to extend
 * the language by pushing the array_or_hash_type syntax down into
 * scalar_type_specifier and struct_specifier.  This would allow
 * inputs that should be syntax errors, so extra checking would have
 * been needed to detect these cases.
 *
 * The GLR parser has no problem with this type of conflict and keeps
 * the grammar nice.
 *
 * Note that the %expect 1 below is for this conflict.  Although the
 * GLR parser handles it, it is still reported as a conflict.
 */

%token T_ATTRIBUTE T_CLASS T_CONSTRUCTOR
%token T_DESTRUCTOR T_DOTDOT T_ELLIPSIS T_EXPAND T_EXTERN T_FLOAT
%token T_INSTANCE T_INT T_LHTML_EXPR_END T_LEFT_INTERPOL_RE
%token T_PATTERN T_POLY T_PRIVATE T_PUBLIC T_RE T_RE_MODIFIER
%token T_RIGHT_INTERPOL T_RIGHT_INTERPOL_RE T_STRUCT
%token T_SUBST T_TYPEDEF T_ARGUSED T_OPTIONAL T_MUSTBETYPE T_VOID
//%token T_CASE T_DEFAULT

//%token END YYerror YYUNDEF T_ARROW T_COLON T_LPAREN T_RBRACKET T_RPAREN

%left LOWEST
%nonassoc T_ID T_IF T_LEFT_INTERPOL T_RETURN T_STR_LITERAL T_UNLESS
%nonassoc T_FLOAT_LITERAL T_INT_LITERAL T_STR_BACKTICK T_TYPE T_WHILE
%nonassoc T_BREAK T_CONTINUE T_DEFINED T_DO T_FOR T_FOREACH T_STRING
%nonassoc T_GOTO T_TRY T_SPLIT T_START_BACKTICK T_WIDGET T_PRAGMA T_SWITCH
%nonassoc T_HTML T_LHTML_EXPR_START
%left T_COMMA ','
%nonassoc T_ELSE ';'
%right T_EQBITAND T_EQBITOR T_EQBITXOR T_EQDOT T_EQLSHIFT T_EQMINUS T_EQPERC T_EQPLUS T_EQRSHIFT T_EQSTAR T_EQSLASH T_EQUALS
%right T_QUESTION
%left T_OROR
%left T_ANDAND
%left T_BITOR
%left T_BITXOR
%left T_BITAND
%left T_BANGTWID T_EQ T_EQTWID T_EQUALEQUAL T_NE T_NOTEQUAL
%left T_GE T_GREATER T_GREATEREQ T_GT T_LE T_LESSTHAN T_LESSTHANEQ T_LT
%left T_LSHIFT T_RSHIFT
%left T_MINUS T_PLUS T_STRCAT
%left T_PERC T_SLASH T_STAR
%right T_BANG T_BITNOT PREFIX_INCDEC UPLUS UMINUS ADDRESS
%left '.' '{' '[' T_MINUSMINUS T_PLUSPLUS "->" '}'
%left HIGHEST

%start start

%%

start:
	  /*END
	|*/ toplevel_code
	;

toplevel_code:
	  toplevel_code class_decl
	| toplevel_code function_decl
	| toplevel_code struct_specifier ';'
	| toplevel_code T_TYPEDEF type_specifier declarator ';'
	| toplevel_code declaration
	| toplevel_code stmt
	| %empty
	;

class_decl:
	  T_CLASS id '{' class_decl_tail
	| T_CLASS T_TYPE '{' class_decl_tail
	| T_CLASS id ';'
	| T_CLASS T_TYPE ';'
	;

class_decl_tail:
	  class_code '}'
	;

class_code:
	  class_code T_INSTANCE '{' declaration_list '}' opt_semi
	| class_code T_INSTANCE '{' '}' opt_semi
	| class_code declaration
	| class_code struct_specifier ';'
	| class_code T_TYPEDEF type_specifier declarator ';'
	| class_code function_decl
	| class_code T_CONSTRUCTOR fundecl_tail
	| class_code T_DESTRUCTOR fundecl_tail
	| class_code pragma
	| %empty
	;

opt_semi:
	  ';'
	| %empty
	;

function_decl:
	  type_specifier fundecl_tail
	| decl_qualifier type_specifier fundecl_tail
	;

fundecl_tail:
	  id fundecl_tail1
	| T_PATTERN fundecl_tail1
	;

fundecl_tail1:
	  '(' parameter_list ')' opt_attribute compound_stmt
	| '(' parameter_list ')' opt_attribute ';'
	;

stmt:
	  T_ID ':' stmt
	| T_ID ':' %prec LOWEST
	| unlabeled_stmt
	| pragma
	| T_HTML
	| T_LHTML_EXPR_START expr T_LHTML_EXPR_END
	;

pragma_expr_list:
	  id
	| id T_EQUALS id
	| id T_EQUALS T_INT_LITERAL
	| pragma_expr_list ',' id
	| pragma_expr_list ',' id T_EQUALS id
	| pragma_expr_list ',' id T_EQUALS T_INT_LITERAL
	;

pragma:
	  T_PRAGMA pragma_expr_list
	;

opt_attribute:
	  T_ATTRIBUTE '(' argument_expr_list ')'
	| %empty
	;

unlabeled_stmt:
	  single_stmt
	| compound_stmt
	;

single_stmt:
	  selection_stmt
	| iteration_stmt
	| switch_stmt
	| foreach_stmt
	| expr ';'
	| T_BREAK ';'
	| T_CONTINUE ';'
	| T_RETURN ';'
	| T_RETURN expr ';'
	| T_GOTO T_ID ';'
	| T_TRY compound_stmt T_ID '(' expr ')' compound_stmt
	| T_TRY compound_stmt T_ID compound_stmt
	| ';'
	;

selection_stmt:
	  T_IF '(' expr ')' compound_stmt optional_else
	| T_IF '(' expr ')' single_stmt
	| T_UNLESS '(' expr ')' compound_stmt optional_else
	| T_UNLESS '(' expr ')' single_stmt
	;

switch_stmt:
	  T_SWITCH '(' expr ')' '{' switch_cases '}'
	;

switch_cases:
	  switch_cases switch_case
	| %empty
	;

switch_case:
	  "case" re_start_case case_expr ':' opt_stmt_list
	| "default' ':" opt_stmt_list
	;

case_expr:
	  regexp_literal_mod
	| expr
	;

optional_else:
	  T_ELSE compound_stmt
	| T_ELSE selection_stmt
	| %empty
	;

iteration_stmt:
	  T_WHILE '(' expr ')' stmt
	| T_DO stmt T_WHILE '(' expr ')' ';'
	| T_FOR '(' expression_stmt expression_stmt ')' stmt
	| T_FOR '(' expression_stmt expression_stmt expr ')' stmt
	;

foreach_stmt:
	  T_FOREACH '(' id "=>" id id expr ')' stmt
	| T_FOREACH '(' id_list id expr ')' stmt
	;

expression_stmt:
	  ';'
	| expr ';'
	;

opt_stmt_list:
	  stmt_list
	| %empty
	;

stmt_list:
	  stmt
	| stmt_list stmt
	;

parameter_list:
	  parameter_decl_list
	| %empty
	;

parameter_decl_list:
	  parameter_decl
	| parameter_decl_list ',' parameter_decl
	;

parameter_decl:
	  parameter_attrs type_specifier opt_declarator
	| parameter_attrs T_ELLIPSIS id
	;

parameter_attrs:
	  parameter_attrs T_ARGUSED
	| parameter_attrs T_OPTIONAL
	| parameter_attrs T_MUSTBETYPE
	| %empty
	;

argument_expr_list:
	  expr %prec T_COMMA
	| option_arg
	| option_arg expr %prec T_COMMA
	| argument_expr_list ',' expr
	| argument_expr_list ',' option_arg
	| argument_expr_list ',' option_arg expr %prec T_COMMA
	;

option_arg:
	  T_ID ':'
	| "default' ':"
	;

expr:
	  '(' expr ')'
	| '(' type_specifier ')' expr %prec PREFIX_INCDEC
	| '(' T_EXPAND ')' expr %prec PREFIX_INCDEC
	| T_BANG expr
	| T_BITNOT expr
	| T_BITAND expr %prec ADDRESS
	| T_MINUS expr %prec UMINUS
	| T_PLUS expr %prec UPLUS
	| T_PLUSPLUS expr %prec PREFIX_INCDEC
	| T_MINUSMINUS expr %prec PREFIX_INCDEC
	| expr T_PLUSPLUS
	| expr T_MINUSMINUS
	| expr T_EQTWID regexp_literal_mod
	| expr T_BANGTWID regexp_literal_mod
	| expr T_EQTWID regexp_literal subst_literal
	| expr T_EQTWID regexp_literal subst_literal T_RE_MODIFIER
	| expr T_STAR expr
	| expr T_SLASH expr
	| expr T_PERC expr
	| expr T_PLUS expr
	| expr T_MINUS expr
	| expr T_EQ expr
	| expr T_NE expr
	| expr T_LT expr
	| expr T_LE expr
	| expr T_GT expr
	| expr T_GE expr
	| expr T_EQUALEQUAL expr
	| T_EQ '(' expr ',' expr ')'
	| expr T_NOTEQUAL expr
	| expr T_GREATER expr
	| expr T_GREATEREQ expr
	| expr T_LESSTHAN expr
	| expr T_LESSTHANEQ expr
	| expr T_ANDAND expr
	| expr T_OROR expr
	| expr T_LSHIFT expr
	| expr T_RSHIFT expr
	| expr T_BITOR expr
	| expr T_BITAND expr
	| expr T_BITXOR expr
	| id
	| string_literal
	| cmdsubst_literal
	| T_INT_LITERAL
	| T_FLOAT_LITERAL
	| id '(' argument_expr_list ')'
	| id '(' ')'
	| T_STRING '(' argument_expr_list ')'
	| T_SPLIT '(' re_start_split regexp_literal_mod ',' argument_expr_list ')'
	| T_SPLIT '(' re_start_split argument_expr_list ')'
	| dotted_id '(' argument_expr_list ')'
	| dotted_id '(' ')'
	| expr T_EQUALS expr
	| expr T_EQPLUS expr
	| expr T_EQMINUS expr
	| expr T_EQSTAR expr
	| expr T_EQSLASH expr
	| expr T_EQPERC expr
	| expr T_EQBITAND expr
	| expr T_EQBITOR expr
	| expr T_EQBITXOR expr
	| expr T_EQLSHIFT expr
	| expr T_EQRSHIFT expr
	| expr T_EQDOT expr
	| T_DEFINED '(' expr ')'
	| expr '[' expr ']'
	| expr '{' expr '}'
	| expr T_STRCAT expr
	| expr '.' T_ID
	| expr "->" T_ID
	| T_TYPE '.' T_ID
	| T_TYPE "->" T_ID
	| expr ',' expr
	| expr '[' expr T_DOTDOT expr ']'
	| '{' enter_scope list '}'
	| '{' '}'
	| expr T_QUESTION expr ':' expr %prec T_QUESTION
	| T_LESSTHAN expr T_GREATER
	| T_LESSTHAN T_GREATER
	;

re_start_split:
	  %empty
	;

re_start_case:
	  %empty
	;

id:
	  T_ID
	;

id_list:
	  id
	| id ',' id_list
	;

compound_stmt:
	  '{' enter_scope '}'
	| '{' enter_scope stmt_list '}'
	| '{' enter_scope declaration_list '}'
	| '{' enter_scope declaration_list stmt_list '}'
	;

enter_scope:
	  %empty %prec HIGHEST
	;

declaration_list:
	  declaration
	| declaration_list declaration
	;

declaration:
	  declaration2 ';'
	| decl_qualifier declaration2 ';'
	;

decl_qualifier:
	  T_PRIVATE
	| T_PUBLIC
	| T_EXTERN
	;

declaration2:
	  type_specifier init_declarator_list
	;

init_declarator_list:
	  init_declarator
	| init_declarator_list ',' init_declarator
	;

declarator_list:
	  declarator
	| declarator_list ',' declarator
	;

init_declarator:
	  declarator
	| declarator T_EQUALS expr
	;

opt_declarator:
	  declarator
	| %empty
	;

declarator:
	  id array_or_hash_type
	| T_TYPE array_or_hash_type
	| T_BITAND id array_or_hash_type
	| T_BITAND id '(' parameter_list ')'
	;

array_or_hash_type:
	  %empty
	| '[' expr ']' array_or_hash_type
	| '[' ']' array_or_hash_type
	| '{' scalar_type_specifier '}' array_or_hash_type
	;

type_specifier:
	  scalar_type_specifier array_or_hash_type
	| struct_specifier array_or_hash_type
	;

scalar_type_specifier:
	  T_STRING
	| T_INT
	| T_FLOAT
	| T_POLY
	| T_WIDGET
	| T_VOID
	| T_TYPE
	;

struct_specifier:
	  T_STRUCT T_ID '{' struct_decl_list '}'
	| T_STRUCT '{' struct_decl_list '}'
	| T_STRUCT T_ID
	;

struct_decl_list:
	  struct_decl
	| struct_decl_list struct_decl
	;

struct_decl:
	  struct_declarator_list ';'
	;

struct_declarator_list:
	  type_specifier declarator_list
	;

list:
	  list_element
	| list ',' list_element
	| list ','
	;

list_element:
	  expr %prec HIGHEST
	| expr "=>" expr %prec HIGHEST
	;

string_literal:
	  T_STR_LITERAL
	| interpolated_expr T_STR_LITERAL
	| here_doc_backtick T_STR_LITERAL
	;

here_doc_backtick:
	  T_START_BACKTICK T_STR_BACKTICK
	| here_doc_backtick T_START_BACKTICK T_STR_BACKTICK
	;

cmdsubst_literal:
	  T_STR_BACKTICK
	| interpolated_expr T_STR_BACKTICK
	;

regexp_literal:
	  T_RE
	| interpolated_expr_re T_RE
	;

regexp_literal_mod:
	  regexp_literal
	| regexp_literal T_RE_MODIFIER
	;

subst_literal:
	  T_SUBST
	| interpolated_expr_re T_SUBST
	;

interpolated_expr:
	  T_LEFT_INTERPOL expr T_RIGHT_INTERPOL
	| interpolated_expr T_LEFT_INTERPOL expr T_RIGHT_INTERPOL
	;

interpolated_expr_re:
	  T_LEFT_INTERPOL_RE expr T_RIGHT_INTERPOL_RE
	| interpolated_expr_re T_LEFT_INTERPOL_RE expr T_RIGHT_INTERPOL_RE
	;

dotted_id:
	  '.'
	| dotted_id_1
	;

dotted_id_1:
	  '.' T_ID
	| dotted_id_1 '.' T_ID
	;

%%

%x glob_re subst_re subst_re2 re_modifier

ID	([a-zA-Z_]|::)([0-9a-zA-Z_]|::)*
HEX	[a-fA-F0-9]

re_body	(\\.|[^/\r\n\\])

dq_str  \"(\\.|[^"\r\n\\])*\"
sq_str  '(\\.|[^'\r\n\\])*'

str {dq_str}|{sq_str}

ws  [ \t\r\n]

%%

"("	'('
")"	')'
","	','
"->"	"->"
"."	'.'
":"	':'
";"	';'
"=>"	"=>"
"["	'['
"]"	']'
"case"	"case"
"default' ':"	"default' ':"
"try"	T_TRY
"{"	'{'
"}"	'}'
//END	END
"&&"	T_ANDAND
"_argused"	T_ARGUSED
"_attribute"	T_ATTRIBUTE
"!"	T_BANG
"&"	T_BITAND
"~"	T_BITNOT
"|"	T_BITOR
"^"	T_BITXOR
"break"	T_BREAK
"class"	T_CLASS
"constructor"	T_CONSTRUCTOR
"continue"	T_CONTINUE
"defined"	T_DEFINED
"destructor"	T_DESTRUCTOR
"do"	T_DO
".."	T_DOTDOT
"..."	T_ELLIPSIS
"else"	T_ELSE
"eq"	T_EQ
"&="	T_EQBITAND
"|="	T_EQBITOR
"^="	T_EQBITXOR
".="	T_EQDOT
"<<="	T_EQLSHIFT
"-="	T_EQMINUS
"%="	T_EQPERC
"+="	T_EQPLUS
">>="	T_EQRSHIFT
"/="	T_EQSLASH
"*="	T_EQSTAR
"=="	T_EQUALEQUAL
"="	T_EQUALS
"expand"	T_EXPAND
"extern"	T_EXTERN
"float"	T_FLOAT
"for"	T_FOR
"foreach"	T_FOREACH
"ge"	T_GE
"goto"	T_GOTO
">"	T_GREATER
">="	T_GREATEREQ
"gt"	T_GT
T_HTML	T_HTML
"if"	T_IF
"instance"	T_INSTANCE
"int"	T_INT
"le"	T_LE
T_LEFT_INTERPOL	T_LEFT_INTERPOL
T_LEFT_INTERPOL_RE	T_LEFT_INTERPOL_RE
"<"	T_LESSTHAN
"<="	T_LESSTHANEQ
T_LHTML_EXPR_END	T_LHTML_EXPR_END
T_LHTML_EXPR_START	T_LHTML_EXPR_START
"<<"	T_LSHIFT
"lt"	T_LT
"-"	T_MINUS
"--"	T_MINUSMINUS
"_mustbetype"	T_MUSTBETYPE
"ne"	T_NE
"!="	T_NOTEQUAL
"_optional"	T_OPTIONAL
"||"	T_OROR
"%"	T_PERC
"+"	T_PLUS
"++"	T_PLUSPLUS
"poly"	T_POLY
"private"	T_PRIVATE
"public"	T_PUBLIC
"?"	T_QUESTION
"return"	T_RETURN
T_RIGHT_INTERPOL	T_RIGHT_INTERPOL
T_RIGHT_INTERPOL_RE	T_RIGHT_INTERPOL_RE
">>"	T_RSHIFT
"/"	T_SLASH
"split"	T_SPLIT
"*"	T_STAR
T_START_BACKTICK	T_START_BACKTICK
[ \t\n\r]+"."[ \t\n\r]+	T_STRCAT
"string"	T_STRING
"struct"	T_STRUCT
"switch"	T_SWITCH
"typedef"	T_TYPEDEF
"unless"	T_UNLESS
"void"	T_VOID
"while"	T_WHILE
"widget"	T_WIDGET

^#line[ \t]+[0-9]+\n	skip()
^#line[ \t]+[0-9]+[ \t]+\"[^\"\n]*\"\n	skip()
^#include[ \t]*\"[^\"\n]+\"	skip()
^#include[ \t]*<[^>\n]+>	skip()
^#pragma[ \t]+	T_PRAGMA

[!=]~[ \t\r\n]*"m"?"/"<glob_re>	reject()
<glob_re>{
	"=~"	T_EQTWID
	"!~"	T_BANGTWID
	"m"<.>
	[ \t\r\n]+	skip()
	"/"{re_body}+"/"<re_modifier>	T_RE
}

[!=]~[ \t\r\n]*"s/"<subst_re>	reject()
<subst_re>{
	"=~"	T_EQTWID
	"!~"	T_BANGTWID
	"s"<.>
	[ \t\r\n]+	skip()
	"/"{re_body}+"/"<subst_re2>	T_RE
}

<subst_re2>{
	{re_body}*"/"<re_modifier>	T_SUBST
}

<re_modifier>{
	[iglt]+<INITIAL>	T_RE_MODIFIER
	.|\n<INITIAL>	reject()
}

"`"(\\.|[^`\r\n\\])*"`"	T_STR_BACKTICK
{str}({ws}+{str})*	T_STR_LITERAL
[0-9]+|0o[0-7]+|0x[0-9a-fA-F]+	T_INT_LITERAL
[0-9]+"."[0-9]+	T_FLOAT_LITERAL

([A-Z]|::)([0-9a-zA-Z]|::)*_\*	T_PATTERN
"FILE"|"Data"	T_TYPE //cheating here right now
{ID}|"$"[0-9]+	T_ID

{ws}+	skip()
^"#!".*  skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

%%
