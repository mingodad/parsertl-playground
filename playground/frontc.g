//From: https://github.com/BinaryAnalysisPlatform/FrontC/blob/c95d785d9e440827d65a904544495194ad8a40a9/frontc/cparser.mly
/*
 *	$Id$
 *	Copyright (c) 2003, Hugues Cassé <hugues.casse@laposte.net>
 *
 *	Library entry point..
 */

/* Old history.
 *
 *	1.0	2.18.99	Hugues Cassé	First release.
 *	2.0	3.22.99	Hugues Cassé	Full ANSI C and GCC attributes supported.
 *								Cprint improved.
 *  2.1 2.18.04 Hugues Cassé	A lot of improvement: improved parse
 *								arguments allowing preprocessing and any
 *								channel, converison to XML, support for
 *								unknown types in typedef.
*/
/**
 * FrontC is an OCAML library providing facilities for parsing source file
 * in C language.
 *
 * Although it is designed for parsing ANSI C, it provides also support for
 * old K&R C style and for some GCC extensions.
 *
 * It provides also a limited degraded mode allowing to parse file although
 * all type information is not available and preprocessor directives are still
 * in the source.
 *
 * @author Hugues Cassé <hugues.casse\@laposte.net>
*/

/* !!TODO!!
   Add option support:
   - Support unknown types.
   - Support for GC specifics (attributes, __builtin_va_list).
   - Replace the input handler by a structure.
*/
/* FrontC -- lexical analyzer
 **
 ** Project: FrontC
 ** File: frontc.mll
 ** Version: 4.1
 ** Author: Hugues Cassé et al
*/

%token AND
%token AND_AND
%token AND_EQ
%token ARROW
%token ASM
%token ATTRIBUTE
%token AUTO
%token BOOL
%token BREAK
%token BUILTIN_TYPE
%token CASE
%token CHAR
%token CIRC
%token CIRC_EQ
%token COLON
%token COMMA
%token COMPLEX
%token CONST
%token CONTINUE
%token CST_CHAR
%token CST_FLOAT
%token CST_INT
%token CST_STRING
%token DEFAULT
%token DO
%token DOT
%token DOUBLE
%token ELLIPSIS
%token ELSE
%token ENUM
//%token EOF
%token EQ
%token EQ_EQ
%token EXCLAM
%token EXCLAM_EQ
%token EXTENSION
%token EXTERN
%token FLOAT
%token FOR
%token GNU_ATTRS
%token GOTO
%token IDENT
%token IF
%token INF
%token INF_EQ
%token INF_INF
%token INF_INF_EQ
%token INLINE
%token INT
%token LBRACE
%token LBRACKET
%token LONG
%token LPAREN
%token MINUS
%token MINUS_EQ
%token MINUS_MINUS
%token NAMED_TYPE
%token PERCENT
%token PERCENT_EQ
%token PIPE
%token PIPE_EQ
%token PIPE_PIPE
%token PLUS
%token PLUS_EQ
%token PLUS_PLUS
%token QUEST
%token RBRACE
%token RBRACKET
%token REGISTER
%token RESTRICT
%token RETURN
%token RPAREN
%token SEMICOLON
%token SHORT
%token SIGNED
%token SIZEOF
%token SLASH
%token SLASH_EQ
%token STAR
%token STAR_EQ
%token STATIC
%token STRUCT
%token SUP
%token SUP_EQ
%token SUP_SUP
%token SUP_SUP_EQ
%token SWITCH
%token TILDE
%token TYPEDEF
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token WHILE

%nonassoc IF
%nonassoc ELSE
%right AND_EQ CIRC_EQ EQ INF_INF_EQ MINUS_EQ PERCENT_EQ PIPE_EQ PLUS_EQ SLASH_EQ STAR_EQ SUP_SUP_EQ
%right COLON QUEST
%left PIPE_PIPE
%left AND_AND
%left PIPE
%left CIRC
%left AND
%left EQ_EQ EXCLAM_EQ
%left INF INF_EQ SUP SUP_EQ
%left INF_INF SUP_SUP
%left MINUS PLUS
%left CONST PERCENT RESTRICT SLASH STAR VOLATILE
%right ADDROF CAST EXCLAM MINUS_MINUS PLUS_PLUS RPAREN TILDE
%left LBRACKET
%left ARROW DOT LPAREN SIZEOF

%start file
//%start interpret

%%

option_IDENT_ :
	/*empty*/
	| IDENT
	;

option_VOLATILE_ :
	/*empty*/
	| VOLATILE
	;

//interpret :
//	file
//	;

file :
	globals
	;

globals :
	/*empty*/
	| globals global
	//list_global_ //EOF
	//| error
	;

typedef :
	TYPEDEF typedef_type typedef_defs
	| gcc_attribute TYPEDEF typedef_type typedef_defs
	;

global :
	global_type global_defs SEMICOLON
	| global_type global_proto body
	| global_type global_proto basic_asm opt_gcc_attributes SEMICOLON
	| global_type old_proto old_pardefs body
	| global_type SEMICOLON
	| typedef SEMICOLON
	;

global_type :
	global_mod_list_zom global_qual
	| global_mod_list_zom comp_type global_mod_list_zom
	| global_mod_list_zom NAMED_TYPE global_mod_list_zom
	| global_mod_list_zom
	;

global_mod_list_zom :
	/*empty*/
	| global_mod global_mod_list_zom
	;

global_mod :
	STATIC
	| CONST
	| VOLATILE
	| EXTERN
	| gcc_attribute
	;

global_qual :
	qual_type
	| global_qual qual_type
	| global_qual global_mod
	;

global_defs :
	global_def
	| global_defs COMMA global_def
	;

global_def :
	global_dec opt_gcc_attributes
	| global_dec opt_gcc_attributes EQ init_expression
	;

global_dec :
	IDENT
	| LPAREN global_dec RPAREN
	| STAR global_dec
	| STAR CONST global_dec
	| STAR VOLATILE global_dec
	| STAR RESTRICT global_dec
	| STAR gcc_attributes global_dec
	| global_dec LBRACKET comma_expression RBRACKET
	| global_dec LBRACKET RBRACKET
	| global_dec LPAREN parameters RPAREN
	| LPAREN global_dec RPAREN LPAREN parameters RPAREN
	| global_dec LPAREN old_parameters RPAREN
	| LPAREN global_dec RPAREN LPAREN old_parameters RPAREN
	;

global_proto :
	global_dec opt_gcc_attributes
	;

old_proto :
	global_dec opt_gcc_attributes
	;

old_parameters :
	old_pardecs
	| old_pardecs ELLIPSIS
	;

old_pardecs :
	IDENT
	| old_pardecs COMMA IDENT
	| old_pardecs COMMA NAMED_TYPE
	;

old_pardefs :
	old_pardef
	| old_pardefs old_pardef
	;

old_pardef :
	old_type old_defs SEMICOLON
	;

old_type :
	old_mods_opt NAMED_TYPE old_mods_opt
	| old_mods_opt comp_type old_mods_opt
	| old_mods_opt old_qual
	;

old_mods_opt :
	/*empty*/
	| CONST
	| REGISTER
	;

old_qual :
	qual_type
	| old_qual qual_type
	| old_qual CONST
	| old_qual REGISTER
	;

old_defs :
	old_def
	| old_defs COMMA old_def
	;

old_def :
	old_dec
	;

old_dec :
	IDENT
	| STAR old_dec
	| STAR CONST old_dec
	| STAR VOLATILE old_dec
	| old_dec LBRACKET comma_expression RBRACKET
	| old_dec LBRACKET RBRACKET
	| old_dec LPAREN parameters RPAREN
	| LPAREN old_dec RPAREN LPAREN parameters RPAREN
	| LPAREN old_dec RPAREN
	;

local :
	local_type local_defs SEMICOLON
	;

local_type :
	local_mod_list_opt local_qual
	| local_mod_list_opt comp_type local_mod_list_opt
	| local_mod_list_opt NAMED_TYPE local_mod_list_opt
	;

local_mod_list_opt :
	/*empty*/
	| local_mod_list
	;

local_mod_list :
	local_mod
	| local_mod_list local_mod
	;

local_mod :
	STATIC
	| AUTO
	| CONST
	| VOLATILE
	| REGISTER
	| EXTERN
	| gcc_attribute
	;

local_qual :
	qual_type
	| local_qual qual_type
	| local_qual local_mod
	;

local_defs :
	local_def
	| local_defs COMMA local_def
	;

local_def :
	local_dec opt_gcc_attributes
	| local_dec opt_gcc_attributes EQ init_expression
	;

local_dec :
	IDENT
	| NAMED_TYPE
	| STAR local_dec
	| STAR RESTRICT local_dec
	| STAR CONST local_dec
	| STAR VOLATILE local_dec
	| STAR gcc_attributes local_dec
	| local_dec LBRACKET comma_expression RBRACKET
	| local_dec LBRACKET RBRACKET
	| local_dec LPAREN parameters RPAREN
	| LPAREN local_dec RPAREN LPAREN parameters RPAREN
	| LPAREN local_dec RPAREN
	;

typedef_type :
	typedef_sub
	| CONST typedef_sub
	| VOLATILE typedef_sub
	;

typedef_sub :
	NAMED_TYPE
	| comp_type
	| typedef_qual
	| IDENT
	| NAMED_TYPE CONST
	| NAMED_TYPE VOLATILE
	| comp_type CONST
	| comp_type VOLATILE
	| IDENT CONST
	| IDENT VOLATILE
	;

typedef_qual :
	qual_type
	| typedef_qual qual_type
	| typedef_qual CONST
	| typedef_qual VOLATILE
	;

typedef_defs :
	typedef_def
	| typedef_defs COMMA typedef_def
	;

typedef_def :
	typedef_dec opt_gcc_attributes
	;

typedef_dec :
	IDENT
	| NAMED_TYPE
	| STAR typedef_dec
	| STAR RESTRICT typedef_dec
	| STAR CONST typedef_dec
	| STAR VOLATILE typedef_dec
	| STAR gcc_attributes typedef_dec
	| typedef_dec LBRACKET comma_expression RBRACKET
	| typedef_dec LBRACKET RBRACKET
	| typedef_dec LPAREN parameters RPAREN
	| LPAREN typedef_dec RPAREN LPAREN parameters RPAREN
	| LPAREN typedef_dec RPAREN
	;

field_list :
	/*empty*/
	| field_list field
	;

field :
	field_type field_defs opt_gcc_attributes SEMICOLON
	| field_mod_list_opt struct_type field_mod_list_opt field_defs SEMICOLON
	| field_mod_list_opt struct_type field_mod_list_opt SEMICOLON
	| field_mod_list_opt union_type field_mod_list_opt field_defs SEMICOLON
	| field_mod_list_opt union_type field_mod_list_opt SEMICOLON
	;

field_type :
	field_mod_list_opt field_qual
	| field_mod_list_opt enum_type field_mod_list_opt
	| field_mod_list_opt NAMED_TYPE field_mod_list_opt
	;

field_mod_list_opt :
	/*empty*/
	| field_mod_list
	;

field_mod_list :
	field_mod
	| field_mod_list field_mod
	;

field_mod :
	CONST
	| VOLATILE
	| gcc_attribute
	;

field_qual :
	qual_type
	| field_qual qual_type
	| field_qual field_mod
	;

field_defs :
	field_def
	| field_defs COMMA field_def
	;

field_def :
	field_dec
	;

field_dec :
	IDENT
	| NAMED_TYPE
	| STAR field_dec
	| STAR RESTRICT field_dec
	| STAR CONST field_dec
	| STAR VOLATILE field_dec
	| STAR gcc_attributes field_dec
	| field_dec LBRACKET comma_expression RBRACKET
	| field_dec LBRACKET RBRACKET
	| field_dec LPAREN parameters RPAREN
	| LPAREN field_dec RPAREN LPAREN parameters RPAREN
	| LPAREN field_dec RPAREN
	| option_IDENT_ COLON expression
	;

parameters :
	/*empty*/
	| param_list
	| param_list COMMA ELLIPSIS
	;

param_list :
	param_list COMMA param
	| param
	;

param :
	param_type param_def
	;

param_type :
	param_mods_opt NAMED_TYPE param_mods_opt
	| param_mods_opt comp_type param_mods_opt
	| param_mods_opt param_qual
	;

param_mods_opt :
	/*empty*/
	| param_mods
	;

param_mods :
	param_mod
	| param_mods param_mod
	;

param_mod :
	CONST
	| REGISTER
	| VOLATILE
	| gcc_attribute
	;

param_qual :
	qual_type
	| param_qual qual_type
	| param_qual CONST
	| param_qual REGISTER
	| param_qual VOLATILE
	| param_qual gcc_attribute
	;

param_def :
	param_dec
	;

param_dec :
	/*empty*/
	| IDENT
	| NAMED_TYPE
	| STAR param_dec
	| STAR RESTRICT param_dec
	| STAR CONST param_dec
	| STAR VOLATILE param_dec
	| STAR gcc_attributes param_dec
	| param_dec LBRACKET global_mod_list_zom comma_expression RBRACKET
	| param_dec LBRACKET global_mod_list_zom RBRACKET
	| LPAREN param_dec RPAREN LPAREN parameters RPAREN
	| LPAREN param_dec RPAREN
	;

only_type :
	only_type_type only_def
	;

only_type_type :
	only_mod_list_opt only_qual
	| only_mod_list_opt comp_type only_mod_list_opt
	| only_mod_list_opt NAMED_TYPE only_mod_list_opt
	;

only_mod_list_opt :
	/*empty*/
	| only_mod_list
	;

only_qual :
	qual_type
	| only_qual qual_type
	| only_qual only_mod
	;

only_mod_list :
	only_mod
	| only_mod_list only_mod
	;

only_mod :
	CONST
	| VOLATILE
	| gcc_attribute
	;

only_def :
	only_dec
	;

only_dec :
	/*empty*/
	| STAR only_dec
	| STAR RESTRICT only_dec
	| STAR CONST only_dec
	| STAR VOLATILE only_dec
	| STAR gcc_attributes only_dec
	| only_dec LBRACKET comma_expression RBRACKET
	| only_dec LBRACKET RBRACKET
	| LPAREN only_dec RPAREN LPAREN parameters RPAREN
	| LPAREN only_dec RPAREN
	;

qual_type :
	VOID
	| BOOL
	| CHAR
	| INT
	| FLOAT
	| DOUBLE
	| BUILTIN_TYPE
	| COMPLEX
	| LONG
	| SHORT
	| SIGNED
	| UNSIGNED
	;

comp_type :
	struct_type
	| union_type
	| enum_type
	;

struct_type :
	STRUCT type_name
	| STRUCT LBRACE field_list RBRACE
	| STRUCT type_name LBRACE field_list RBRACE
	;

union_type :
	UNION type_name
	| UNION LBRACE field_list RBRACE
	| UNION type_name LBRACE field_list RBRACE
	;

enum_type :
	ENUM type_name
	| ENUM LBRACE enum_list RBRACE
	| ENUM LBRACE enum_list COMMA RBRACE
	| ENUM type_name LBRACE enum_list RBRACE
	;

type_name :
	IDENT
	| NAMED_TYPE
	;

enum_list :
	enum_name
	| enum_list COMMA enum_name
	;

enum_name :
	IDENT
	| IDENT EQ expression
	;

init_expression :
	LBRACE compound_comma_expression RBRACE
	| expression
	;

compound_expression :
	LBRACE compound_comma_expression RBRACE
	| expression
	| DOT type_name EQ expression
	;

compound_comma_expression :
	compound_expression
	| compound_comma_expression COMMA compound_expression
	| compound_comma_expression COMMA
	;

opt_expression :
	/*empty*/
	| comma_expression
	;

comma_expression :
	expression
	| comma_expression COMMA expression
	;

expression :
	LPAREN EXTENSION expression RPAREN
	| constant
	| IDENT
	| SIZEOF expression
	| SIZEOF LPAREN only_type RPAREN
	| PLUS expression
	| MINUS expression
	| STAR expression
	| AND expression %prec ADDROF
	| EXCLAM expression
	| TILDE expression
	| PLUS_PLUS expression %prec CAST
	| expression PLUS_PLUS
	| MINUS_MINUS expression %prec CAST
	| expression MINUS_MINUS
	| expression ARROW IDENT
	| expression ARROW NAMED_TYPE
	| expression DOT IDENT
	| expression DOT NAMED_TYPE
	| LPAREN body RPAREN
	| LPAREN comma_expression RPAREN
	| LPAREN only_type RPAREN expression %prec CAST
	| expression LPAREN opt_expression RPAREN
	| expression LBRACKET comma_expression RBRACKET
	| expression QUEST expression COLON expression
	| expression PLUS expression
	| expression MINUS expression
	| expression STAR expression
	| expression SLASH expression
	| expression PERCENT expression
	| expression AND_AND expression
	| expression PIPE_PIPE expression
	| expression AND expression
	| expression PIPE expression
	| expression CIRC expression
	| expression EQ_EQ expression
	| expression EXCLAM_EQ expression
	| expression INF expression
	| expression SUP expression
	| expression INF_EQ expression
	| expression SUP_EQ expression
	| expression INF_INF expression
	| expression SUP_SUP expression
	| expression EQ expression
	| expression PLUS_EQ expression
	| expression MINUS_EQ expression
	| expression STAR_EQ expression
	| expression SLASH_EQ expression
	| expression PERCENT_EQ expression
	| expression AND_EQ expression
	| expression PIPE_EQ expression
	| expression CIRC_EQ expression
	| expression INF_INF_EQ expression
	| expression SUP_SUP_EQ expression
	;

constant :
	CST_INT
	| CST_FLOAT
	| CST_CHAR
	| string_list
	;

string_list :
	CST_STRING
	| string_list CST_STRING
	;

body_begin :
	LBRACE
	;

body_middle :
	opt_locals opt_stats
	;

body :
	body_begin body_middle RBRACE
	;

opt_locals :
	/*empty*/
	| locals
	;

locals :
	local
	| locals local
	;

opt_stats :
	/*empty*/
	| stats
	;

stats :
	statement
	| stats statement
	;

statement :
	SEMICOLON
	| comma_expression SEMICOLON
	| body
	| IF LPAREN comma_expression RPAREN statement %prec IF
	| IF LPAREN comma_expression RPAREN statement ELSE statement
	| SWITCH LPAREN comma_expression RPAREN statement
	| WHILE LPAREN comma_expression RPAREN statement
	| DO statement WHILE LPAREN comma_expression RPAREN SEMICOLON
	| FOR LPAREN opt_expression SEMICOLON opt_expression SEMICOLON opt_expression RPAREN statement
	| IDENT COLON statement
	| CASE expression COLON statement
	| DEFAULT COLON statement
	| RETURN SEMICOLON
	| RETURN expression SEMICOLON
	| BREAK SEMICOLON
	| CONTINUE SEMICOLON
	| GOTO IDENT SEMICOLON
	| ASM LPAREN CST_STRING RPAREN SEMICOLON
	| ASM LPAREN CST_STRING gnu_asm_io gnu_asm_io opt_gnu_asm_mods RPAREN SEMICOLON
	;

basic_asm :
	ASM option_VOLATILE_ opt_gcc_attributes LPAREN string_list RPAREN
	;

gnu_asm_io :
	COLON gnu_asm_args
	;

gnu_asm_args :
	gnu_asm_arg
	| gnu_asm_args COMMA gnu_asm_arg
	;


gnu_asm_arg :
	CST_STRING LPAREN expression RPAREN
	| LBRACKET IDENT RBRACKET CST_STRING LPAREN expression RPAREN
	;

opt_gnu_asm_mods :
	/*empty*/
	| COLON gnu_asm_mods
	;

gnu_asm_mods :
	CST_STRING
	| gnu_asm_mods COMMA CST_STRING
	;

opt_gcc_attributes :
	/*empty*/
	| gcc_attributes
	;

gcc_attributes :
	gcc_attribute
	| gcc_attributes gcc_attribute
	;

gcc_attribute :
	ATTRIBUTE LPAREN LPAREN opt_gnu_args RPAREN RPAREN
	| EXTENSION
	| INLINE
	;

opt_gnu_args :
	/*empty*/
	| gnu_args
	;

gnu_args :
	gnu_arg
	| gnu_args COMMA gnu_arg
	;


gnu_arg :
	gnu_id
	| local_type
	| constant
	| gnu_id LPAREN opt_gnu_args RPAREN
	;

gnu_id :
	IDENT
	| GNU_ATTRS
	;

%%

decdigit	[0-9]
octdigit	[0-7]
hexdigit	[0-9a-fA-F]
letter	[a-zA-Z]

usuffix	[uU]
lsuffix	[lL]
intsuffix	({lsuffix}|{usuffix}|({usuffix}{lsuffix})|({lsuffix}{usuffix}))?
floatsuffix	[fFlL]

intnum	{decdigit}+{intsuffix}?
octnum	"0"{octdigit}+{intsuffix}?
hexnum	"0"[xX]{hexdigit}+{intsuffix}?

exponent	[eE][+-]?{decdigit}+
fraction	"."{decdigit}+
floatraw	({intnum}?{fraction})|({intnum}{exponent})|({intnum}?{fraction}{exponent})|({intnum}".")
floatnum	{floatraw}{floatsuffix}?
imaginary	{floatraw}"iF"

ident	({letter}|"_")({letter}|{decdigit}|"_")*
blank	[ \t\n\r]
escape	"\\".
hex_escape	"\\"[xX]{hexdigit}{hexdigit}
oct_escape	"\\"{octdigit}{octdigit}{octdigit}

%%

{blank}+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"auto"	AUTO
"const"|"__const"	CONST
"static"	STATIC
"extern"	EXTERN
"long"	LONG
"_Complex"	COMPLEX
"__float128"	BUILTIN_TYPE
"__float80"	BUILTIN_TYPE
"__ibm128"	BUILTIN_TYPE
"_Float16"	BUILTIN_TYPE
"_Float32"	BUILTIN_TYPE
"_Float32x"	BUILTIN_TYPE
"_Float64"	BUILTIN_TYPE
"_Float64x"	BUILTIN_TYPE
"_Float80"	BUILTIN_TYPE
"_Float128"	BUILTIN_TYPE
"_Float128x"	BUILTIN_TYPE
"_Ibm128"	BUILTIN_TYPE
"short"	SHORT
"register"	REGISTER
"signed"	SIGNED
"unsigned"	UNSIGNED
"volatile"	VOLATILE
"inline"	INLINE
"__restrict"	RESTRICT
"restrict"	RESTRICT
"char"	CHAR
"_Bool"	BOOL
"int"	INT
"float"	FLOAT
"double"	DOUBLE
"void"	VOID
"enum"	ENUM
"struct"	STRUCT
"typedef"	TYPEDEF
"union"	UNION
"break"	BREAK
"continue"	CONTINUE
"goto"	GOTO
"return"	RETURN
"switch"	SWITCH
"case"	CASE
"default"	DEFAULT
"while"	WHILE
"do"	DO
"for"	FOR
"if"	IF
"else"	ELSE
"asm"|"__asm__"	ASM
"sizeof"  SIZEOF

/*** Specific GNU ***/
"__attribute__"	ATTRIBUTE
"__extension__"	EXTENSION
"__inline"	INLINE
GNU_ATTRS	GNU_ATTRS

"..."	ELLIPSIS
"+="	PLUS_EQ
"-="	MINUS_EQ
"*="	STAR_EQ
"/="	SLASH_EQ
"%="	PERCENT_EQ
"|="	PIPE_EQ
"&="	AND_EQ
"^="	CIRC_EQ
"<<="	INF_INF_EQ
">>="	SUP_SUP_EQ
"<<"	INF_INF
">>"	SUP_SUP
"=="	EQ_EQ
"!="	EXCLAM_EQ
"<="	INF_EQ
">="	SUP_EQ
"=" 	EQ
"<" 	INF
">" 	SUP
"++"	PLUS_PLUS
"--"	MINUS_MINUS
"->"	ARROW
"+" 	PLUS
"-" 	MINUS
"*" 	STAR
"/" 	SLASH
"%" 	PERCENT
"!" 	EXCLAM
"&&"	AND_AND
"||"	PIPE_PIPE
"&" 	AND
"|" 	PIPE
"^" 	CIRC
"?" 	QUEST
":" 	COLON
"~" 	TILDE

"{" 	LBRACE
"}" 	RBRACE
"[" 	LBRACKET
"]" 	RBRACKET
"(" 	LPAREN
")" 	RPAREN
";" 	SEMICOLON
"," 	COMMA
"." 	DOT

'(\\.|[^'\r\n\\])'   CST_CHAR
\"(\\.|[^"\r\n\\])*\"    CST_STRING
{floatnum}  CST_FLOAT
{imaginary} CST_FLOAT
{hexnum}   CST_INT
{octnum}   CST_INT
{intnum}   CST_INT

NAMED_TYPE	NAMED_TYPE
{ident}	IDENT

%%
