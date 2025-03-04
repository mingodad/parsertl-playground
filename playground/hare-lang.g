%token floating_constant
%token string_constant
%token integer_constant rune_constant
%token name

%left "||"
%left "^^"
%left "&&"
%left "==" "!="
%left '<' '>' "<=" ">="
%left '|'
%left '^'
%left '&'
%left "<<" ">>"
%left '+' '-'
%left '*' '/' '%'
%left ':' "as" "is"
%left UMINUS

%%

sub_unit:
	imports
	| declarations
	| imports declarations
	;

type:
	  const_opt exclam_opt _storage_class
	;

exclam_opt:
	  %empty
	| '!'
	;

const_opt:
	  %empty
	| "const"
	;

_storage_class:
	  _scalar_type
	| struct_union_type
	| tuple_type
	| tagged_union_type
	| slice_array_type
	| function_type
	| alias_type
	| unwrapped_alias
	| _string_type
	;

_scalar_type:
	  _integer_type
	| _floating_type
	| pointer_type
	| "rune"
	| "bool"
	| "valist"
	| "void"
	| "opaque"
	| "never"
	;

_integer_type:
	  "i8"
	| "i16"
	| "i32"
	| "i64"
	| "u8"
	| "u16"
	| "u32"
	| "u64"
	| "int"
	| "uint"
	| "size"
	| "uintptr"
	;

_floating_type:
	  "f32"
	| "f64"
	;

pointer_type:
	  '*' type
	| "nullable" '*' type
	;

struct_union_type:
	  "struct" at_packed_opt '{' _struct_union_fields '}'
	| "union" '{' _struct_union_fields '}'
	;

at_packed_opt:
	  %empty
	| "@packed"
	;

_struct_union_fields:
	  struct_union_field comma_struct_union_field_kinds_zom comma_opt
	;

comma_opt:
	  %empty
	| ','
	;

comma_struct_union_field_kinds_zom:
	  %empty
	| comma_struct_union_field_kinds_zom ',' struct_union_field
	;

struct_union_field:
	  offset_specifier_opt struct_union_field_kinds
	;

struct_union_field_kinds:
	  name ':' type
	| struct_union_type
	| identifier
	;

offset_specifier_opt:
	  %empty
	| offset_specifier
	;

offset_specifier:
	  "@offset" '(' expression ')'
	;

tuple_type:
	  '(' type comma_type_oom comma_opt ')'
	;

comma_type_oom:
	  comma_type
	| comma_type_oom comma_type
	;

comma_type:
	  ',' type
	;

tagged_union_type:
	  '(' type pipe_type_oom pipe_opt ')'
	;

pipe_opt:
	  %empty
	| '|'
	;

pipe_type_oom:
	  pipe_type
	| pipe_type_oom pipe_type
	;

pipe_type:
	  '|' type
	;

slice_array_type:
	  '[' ']' type
	| '[' expression ']' type
	| '[' '*' ']' type
	| '[' '_' ']' type
	;

_string_type:
	  "str"
	;

function_type:
	  "fn" _prototype
	;

_prototype:
	  '(' prototype_params_opt ')' type
	;

prototype_params_opt:
	  %empty
	| parameter comma_parameter_zom comma_opt_elipsis_opt comma_opt
	;

comma_opt_elipsis_opt:
	  %empty
	| comma_opt "..."
	;

comma_parameter_zom:
	  %empty
	| comma_parameter_zom ',' parameter
	;

parameter:
	  name ':' type
	| '_' ':' type
	;

alias_type:
	  identifier
	;

unwrapped_alias:
	  "..." identifier
	;

constant:
	  integer_constant
	| floating_constant
	| rune_constant
	| string_constant
	| "true"
	| "false"
	| "null"
	| "void"
	;

array_literal:
	  '[' array_dimension_opt ']'
	;

array_dimension_opt:
	  %empty
	| expression comma_expression_zom elipsis_opt comma_opt
	;

elipsis_opt:
	  %empty
	| "..."
	;

comma_expression_zom:
	  %empty
	| comma_expression_zom comma_expression
	;

comma_expression:
	  ',' expression
	;

struct_literal:
	  struct_or_id '{' field_value_list_opt '}'
	;

field_value_list_opt:
	  %empty
	| field_value comma_field_value_zom comma_opt
	;

comma_field_value_zom:
	  %empty
	| comma_field_value_zom ',' field_value
	;

struct_or_id:
	  "struct"
	| identifier
	;

field_value:
	  name '=' expression
	| name ':' type '=' expression
	| struct_literal
	| "..."
	;

tuple_literal:
	  '(' expression comma_expression_oom comma_opt ')'
	;

comma_expression_oom:
	  comma_expression
	| comma_expression_oom comma_expression
	;

_plain_expression:
	  identifier
	| constant
	| array_literal
	| struct_literal
	| tuple_literal
	;

nested_expression:
	  _plain_expression
	| '(' expression ')'
	;

allocation_expression:
	  "alloc" '(' expression ')'
	| "alloc" '(' expression "..." ')'
	| "alloc" '(' expression ',' expression ')'
	| "free" '(' expression ')'
	;

assertion_expression:
	  static_opt assert_kinds
	;

assert_kinds:
	  "assert" '(' expression ')'
	| "assert" '(' expression ',' string_constant ')'
	| "abort" '(' string_constant_opt ')'
	;

string_constant_opt:
	  %empty
	| string_constant
	;

static_opt:
	  %empty
	| "static"
	;

call_expression:
	  postfix_expression '(' argument_list_opt ')'
	;

argument_list_opt:
	  %empty
	| argument_list
	;

argument_list:
	  expression
	| expression "..."
	| argument_list ',' expression
	| argument_list ',' expression "..."
	;

measurement_expression:
	  align_expression
	| size_expression
	| length_expression
	| offset_expression
	;

align_expression:
	  "align" '(' type ')'
	;

size_expression:
	  "size" '(' type ')'
	;

length_expression:
	  "len" '(' expression ')'
	;

offset_expression:
	  "offset" '(' field_access_expression ')'
	;

field_access_expression:
	  postfix_expression '.' name
	| postfix_expression '.' integer_constant
	;

indexing_expression:
	  postfix_expression '[' expression ']'
	;

slicing_expression:
	  postfix_expression '[' expression_opt ".." expression_opt ']'
	;

expression_opt:
	  %empty
	| expression
	;

slice_mutation_expression:
	  append_expression
	| insert_expression
	| delete_expression
	;

append_expression:
	  static_opt append_kinds
	;

append_kinds:
	  "append" '(' expression ',' expression ')'
	| "append" '(' expression ',' expression "..." ')'
	| "append" '(' expression ',' expression ',' expression ')'
	;

insert_expression:
	  static_opt "insert" '(' indexing_expression ',' expression insert_last_param ')'
	;

insert_last_param:
	  elipsis_opt
	| ',' expression
	;

delete_expression:
	  static_opt delete_kinds
	;

delete_kinds:
	  "delete" '(' slicing_expression ')'
	| "delete" '(' indexing_expression ')'
	;

error_propagation:
	  postfix_expression error_propagation_kinds
	;

error_propagation_kinds:
	  '?'
	| '!'
	;

postfix_expression:
	  nested_expression
	| call_expression
	| field_access_expression
	| indexing_expression
	| slicing_expression
	| error_propagation
	;

variadic_expression:
	  "vastart" '(' ')'
	| "vaarg" '(' expression ')'
	| "vaend" '(' expression ')'
	;

builtin_expression:
	  allocation_expression
	| assertion_expression
	| measurement_expression
	| slice_mutation_expression
	| variadic_expression
	;

unary_expression:
	  unary_ops expression %prec UMINUS
	;

unary_ops:
	  '+'
	| '-'
	| '~'
	| '!'
	| '*'
	| '&'
	;

cast_expression:
	  expression ':' type
	| expression "as" assertion_target
	| expression "is" assertion_target
	;

assertion_target:
	  type
	| "null"
	;

multiplicative_expression:
	  expression multiplicative_ops expression
	;

multiplicative_ops:
	  '*'
	| '/'
	| '%'
	;

additive_expression:
	  expression additive_ops expression
	;

additive_ops:
	  '+'
	| '-'
	;

shift_expression:
	  expression shift_ops expression
	;

shift_ops:
	  "<<"
	| ">>"
	;

and_expression:
	  expression '&' expression
	;

exclusive_or_expression:
	  expression '^' expression
	;

inclusive_or_expression:
	  expression '|' expression
	;

comparison_expression:
	  expression comparison_ops expression
	;

comparison_ops:
	  '<'
	| '>'
	| "<="
	| ">="
	;

equality_expression:
	  expression equality_ops expression
	;

equality_ops:
	  "=="
	| "!="
	;

logical_and_expression:
	  expression "&&" expression
	;

logical_xor_expression:
	  expression "^^" expression
	;

logical_or_expression:
	  expression "||" expression
	;

if_expression:
	  "if" conditional_branch
	| "if" conditional_branch "else" expression
	;

conditional_branch:
	  '(' expression ')' expression
	;

for_loop:
	  label_opt "for" '(' for_predicate ')' expression
	;

label_opt:
	  %empty
	| label
	;

for_predicate:
	  expression
	| binding_list ';' expression
	| expression ';' expression
	| binding_list ';' expression ';' expression
	;

switch_expression:
	  "switch" '(' expression ')' '{' switch_cases '}'
	;

switch_cases:
	  switch_case
	| switch_cases switch_case
	;

switch_case:
	  "case" case_options "=>" expression_list
	| "case" "=>" expression_list
	;

case_options:
	  expression
	| case_options ',' expression
	;

match_expression:
	  "match" '(' expression ')' '{' match_cases '}'
	;

match_cases:
	  match_case
	| match_cases match_case
	;

match_case:
	  "case" "let" name ':' type "=>" expression_list
	| "case" "let" '(' binding_names ')' ':' type "=>" expression_list
	| "case" type "=>" expression_list
	| "case" "=>" expression_list
	;

assignment:
	  expression assignment_op expression
	| '(' binding_names ')' '=' expression
	;

assignment_op:
	  '='
	| "+="
	| "-="
	| "*="
	| "/="
	| "%="
	| "<<="
	| ">>="
	| "&="
	| "|="
	| "^="
	| "&&="
	| "||="
	| "^^="
	;

binding_list:
	  static_opt "let" bindings
	| static_opt "const" bindings
	| "def" binding
	;

bindings:
	  binding
	| bindings ',' binding
	;

binding:
	  name '=' expression
	| name ':' type '=' expression
	| '(' binding_names ')' '=' expression
	| '(' binding_names ')' ':' type '=' expression
	;

binding_names:
	  name ',' name
	| binding_names ',' name
	;

defer_expression:
	  "defer" expression
	;

expression_list:
	  expression ';'
	| binding_list ';'
	| defer_expression ';'
	| expression_list expression ';'
	| expression_list binding_list ';'
	| expression_list defer_expression ';'
	;

compound_expression:
	  label_opt '{' expression_list '}'
	;

label:
	  ':' name
	;

control_expression:
	  "break" label_opt
	| "continue" label_opt
	| "return" expression_opt
	| "yield" expression_opt
	| "yield" label comma_expression_opt
	;

comma_expression_opt:
	  %empty
	| comma_expression
	;

expression:
	  assignment
	| logical_or_expression
	| logical_xor_expression
	| logical_and_expression
	| equality_expression
	| comparison_expression
	| inclusive_or_expression
	| exclusive_or_expression
	| and_expression
	| shift_expression
	| additive_expression
	| multiplicative_expression
	| cast_expression
	| unary_expression
	| postfix_expression
	| builtin_expression
	| compound_expression
	| match_expression
	| switch_expression
	| if_expression
	| for_loop
	| control_expression
	;

declarations:
	  export_opt_declaration
	| declarations export_opt_declaration
	;

export_opt_declaration:
	  export_opt declaration ';'
	;

export_opt:
	  %empty
	| "export"
	;

declaration:
	  global_declaration
	| constant_declaration
	| type_declaration
	| function_declaration
	;

global_declaration:
	  "let" global_bindings
	| "const" global_bindings
	;

global_bindings:
	  global_binding
	| global_bindings ',' global_binding
	;

global_binding:
	  decl_attr_opt at_threadlocal_opt identifier global_binding_tail
	;

global_binding_tail:
	  '=' expression
	| ':' type assign_expression_opt
	;

assign_expression_opt:
	  %empty
	| '=' expression
	;

at_threadlocal_opt:
	  %empty
	| "@threadlocal"
	;

decl_attr_opt:
	  %empty
	| decl_attr
	;

decl_attr:
	  "@symbol" '(' string_constant ')'
	;

constant_declaration:
	  "def" constant_bindings
	;

constant_bindings:
	  constant_binding
	| constant_bindings '.' constant_binding
	;

constant_binding:
	  identifier colon_type_opt '=' expression
	;

colon_type_opt:
	  %empty
	| ':' type
	;

type_declaration:
	  "type" type_bindings
	;

type_bindings:
	  type_binding
	| type_bindings ',' type_binding
	;

type_binding:
	  identifier '=' type
	| identifier '=' enum_type
	;

enum_type:
	  "enum" enum_storage_opt '{' enum_values '}'
	;

enum_storage_opt:
	  %empty
	| enum_storage
	;

enum_values:
	  enum_value
	| enum_values ',' enum_value
	;

enum_value:
	  name
	| name '=' expression
	;

enum_storage:
	  _integer_type
	| "rune"
	;

function_declaration:
	  fndec_attrs_opt "fn" identifier _prototype assign_expression_opt
	;

fndec_attrs_opt:
	  %empty
	| fndec_attrs
	;

fndec_attrs:
	  fndec_attr
	| fndec_attrs fndec_attr
	;

fndec_attr:
	  "@fini"
	| "@init"
	| "@test"
	| decl_attr
	;

imports:
	  use_statement
	| imports use_statement
	;

use_statement:
	  "use" identifier ';'
	| "use" name '=' identifier ';'
	| "use" identifier "::" '{' member_list '}' ';'
	| "use" identifier "::" '*' ';'
	;

member_list:
	  member
	| member_list ',' member
	;

member:
	  name
	| name '=' name
	;

identifier:
	  name
	| identifier "::" name
	;

%%

name [a-zA-Z_][a-zA-Z0-9_]*

%%

[\n\r\t ]+	skip()
"//".*	skip()

"!"	'!'
"!="	"!="
"%"	'%'
"%="	"%="
"&"	'&'
"&&"	"&&"
"&&="	"&&="
"&="	"&="
"("	'('
")"	')'
"*"	'*'
"*="	"*="
"+"	'+'
"+="	"+="
","	','
"-"	'-'
"-="	"-="
"."	'.'
".."	".."
"..."	"..."
"/"	'/'
"/="	"/="
":"	':'
"::"	"::"
";"	';'
"<"	'<'
"<<"	"<<"
"<<="	"<<="
"<="	"<="
"="	'='
"=="	"=="
"=>"	"=>"
">"	'>'
">="	">="
">>"	">>"
">>="	">>="
"?"	'?'
"@fini"	"@fini"
"@init"	"@init"
"@offset"	"@offset"
"@packed"	"@packed"
"@symbol"	"@symbol"
"@test"	"@test"
"@threadlocal"	"@threadlocal"
"["	'['
"]"	']'
"^"	'^'
"^="	"^="
"^^"	"^^"
"^^="	"^^="
"{"	'{'
"|"	'|'
"|="	"|="
"||"	"||"
"||="	"||="
"}"	'}'
"~"	'~'

//keywords
"_"	'_'
"abort"	"abort"
"align"	"align"
"alloc"	"alloc"
"append"	"append"
"as"	"as"
"assert"	"assert"
"bool"	"bool"
"break"	"break"
"case"	"case"
"const"	"const"
"continue"	"continue"
"def"	"def"
"defer"	"defer"
"delete"	"delete"
"else"	"else"
"enum"	"enum"
"export"	"export"
"f32"	"f32"
"f64"	"f64"
"false"	"false"
"fn"	"fn"
"for"	"for"
"free"	"free"
"i16"	"i16"
"i32"	"i32"
"i64"	"i64"
"i8"	"i8"
"if"	"if"
"insert"	"insert"
"int"	"int"
"is"	"is"
"len"	"len"
"let"	"let"
"match"	"match"
"never"	"never"
"nullable"	"nullable"
"null"	"null"
"offset"	"offset"
"opaque"	"opaque"
"return"	"return"
"rune"	"rune"
"size"	"size"
"static"	"static"
"str"	"str"
"struct"	"struct"
"switch"	"switch"
"true"	"true"
"type"	"type"
"u16"	"u16"
"u32"	"u32"
"u64"	"u64"
"u8"	"u8"
"uintptr"	"uintptr"
"uint"	"uint"
"union"	"union"
"use"	"use"
"vaarg"	"vaarg"
"vaend"	"vaend"
"valist"	"valist"
"vastart"	"vastart"
"void"	"void"
"yield"	"yield"

"0x"[0-9a-fA-F]+(\.[0-9a-fA-F]+)?[pP][+-]?[0-9]+("f32"|"f64")?	floating_constant
[0-9]+\.[0-9]+([eE][+-]?[0-9]+)?	floating_constant
[0-9]+([eE][+-]?[0-9]+)?("f32"|"f64")	floating_constant


"0x"[0-9A-Fa-f]+	integer_constant
"0o"[0-8]+	integer_constant
"0b"[01]+	integer_constant
[0-9]+([iuz]|"i8"|"i16"|"i32"|"i64"|"u8"|"u16"|"u32"|"u64")?	integer_constant

'(\\.|[^'\r\n\\])'	rune_constant

//rune_constant :
//	 "'" (escape_sequence
//	| !(%prec 1(/[^\\']/))) !("'")
//	;
//
//escape_sequence :
//	 !(/\\[0abfnrtv\\'"]/
//	| /\\x[0-9A-Fa-f]{2}/
//	| /\\u[0-9A-Fa-f]{4}/
//	| /\\U[0-9A-Fa-f]{8}/)
//	;

"`"[^`]+"`"	string_constant
\"(\\.|[^"\r\n\\])*\"	string_constant
//	| ('"' (escape_sequence
//	| !(%prec 1(/[^\\"]+/)))* !('"'))
//	;

{name}	name

%%
