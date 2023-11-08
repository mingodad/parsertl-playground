//From: https://github.com/ragnard/grammars-v4/blob/354466c48d16bcbc9daedcdc3ebcca3245aba3e2/capnproto/CapnProto.g4
//grammar CapnProto;

%token LOCATOR TEXT INTEGER FLOAT HEXADECIMAL FILE_ID BOOLEAN VOID NAME
%token IMPORT USING CONST ENUM STRUCT EXTENDS ANNOTATION INTERFACE UNION
//%fallback NAME IMPORT USING CONST ENUM STRUCT

%%

// parser rules

document :
	file_identifier using_import* namespace_? document_content* /*EOF*/	;

file_identifier :
	FILE_ID ';' ;

using_import :
	USING ( NAME '=' )? IMPORT TEXT ( '.' NAME )? ';' ;

namespace_ :
	'$' NAME ".namespace" '(' TEXT ')' ';' ;

document_content :
	struct_def | interface_def | function_def | annotation_def | const_def | enum_def ;

struct_def :
	STRUCT type_ annotation_reference? '{' struct_content* '}' ;

struct_content :
	field_def | enum_def | named_union_def
	| unnamed_union_def | interface_def | annotation_def
	| struct_def | group_def | const_def | inner_using ;

interface_def :
	INTERFACE type_ ( EXTENDS '(' type_ ')' )? '{' interface_content* '}' ;

interface_content :
	field_def | enum_def | named_union_def
	| unnamed_union_def | interface_def
	| struct_def | function_def ;

field_def :
	NAME LOCATOR ':' type_ ( '=' const_value )? ';' ;

type_ :
	NAME
	inner_type?
	( '.' type_ )? ;

inner_type :
	'(' type_ ( ',' type_ )* ')' ;

enum_def :
	ENUM NAME annotation_reference? '{' enum_content* '}' ;

annotation_reference :
	'$' type_  '(' TEXT ')' ;

enum_content :
	NAME LOCATOR annotation_reference? ';' ;

named_union_def :
	NAME LOCATOR? ":union" '{' union_content* '}' ;

unnamed_union_def :
	UNION '{' union_content* '}' ;

union_content :
	field_def | group_def | unnamed_union_def | named_union_def ;

group_def :
	NAME ":group" '{' group_content* '}' ;

group_content :
	field_def | unnamed_union_def | named_union_def ;

function_def :
	NAME LOCATOR? generic_type_parameters? ( function_parameters | type_ )
	( "->" ( function_parameters | type_ ) )?
	';' ;

generic_type_parameters :
	'['
		NAME ( ',' NAME )*
	']' ;

function_parameters :
	'('
		( NAME ':' type_ ( '=' const_value )?
			( ',' NAME ':' type_ ( '=' const_value )? )*
		)?
	')' ;

annotation_def :
	ANNOTATION type_ annotation_parameters? ':' type_ ';' ;

annotation_parameters :
	'(' STRUCT ')' ;

const_def :
	CONST NAME ':' type_ '=' const_value ';' ;

const_value :
	'-'? '.'? NAME ( '.' NAME )? | INTEGER | FLOAT
	| TEXT | BOOLEAN | HEXADECIMAL | VOID
	| literal_list | literal_union | literal_bytes ;

literal_union :
	'(' NAME '=' union_mapping ( ',' NAME '=' union_mapping )* ')' ;

literal_list :
	'[' const_value ( ',' const_value )* ']' ;

literal_bytes :
	"0x" TEXT ;

union_mapping :
	'(' NAME '=' const_value ')' | const_value ;

inner_using :
	USING NAME ( '.' NAME )*
	( '=' type_ )?
	';' ;

%%
// lexer rules

DIGIT  [0-9]

HEX_DIGIT  {DIGIT}|[A-Fa-f]

HEXADECIMAL	"-"?"0x"{HEX_DIGIT}+

%%

"="	'='
"->"	"->"
"-"	'-'
","	','
";"	';'
":"	':'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"$"	'$'
"0x"	"0x"
"annotation"	ANNOTATION
"const"	CONST
"enum"	ENUM
"extends"	EXTENDS
":group"	":group"
"import"	IMPORT
"interface"	INTERFACE
".namespace"	".namespace"
"struct"	STRUCT
":union"	":union"
"union"	UNION
"using"	USING

"@"{DIGIT}+"!"?	LOCATOR

\"[^"]*\"	TEXT

"-"?{DIGIT}+	INTEGER

"-"?{DIGIT}+("."{DIGIT}+)?([Ee]"-"?{DIGIT}+)?	FLOAT

{HEXADECIMAL}	HEXADECIMAL

"@"{HEXADECIMAL}	FILE_ID

"true"|"false"	BOOLEAN

"void"	VOID

[a-zA-Z][a-zA-Z0-9]*	NAME

"#".*	skip()

[ \t\r\n]	skip()

%%
