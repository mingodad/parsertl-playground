//Fom: https://github.com/moonbitlang/moonbit-compiler/raw/refs/heads/main/src/parsing_parser.mly

%token AMPER
%token AMPERAMPER
%token AS
%token AUGMENTED_ASSIGNMENT
%token BAR
%token BARBAR
%token BREAK
%token BYTE
%token BYTES
%token CARET
%token CATCH
%token CHAR
%token COLON
%token COLONCOLON
%token COMMA
//%token COMMENT
%token CONST
%token CONTINUE
%token DERIVE
%token DOTDOT
%token DOT_INT
%token DOT_LIDENT
%token DOT_UIDENT
%token ELLIPSIS
%token ELSE
%token ENUM
//%token EOF
%token EQUAL
%token EXCLAMATION
%token EXTERN
%token FALSE
%token FAT_ARROW
%token FLOAT
%token FN
%token FOR
%token GUARD
%token IF
%token IMPL
//%token IMPORT
%token IN
%token INFIX1
%token INFIX2
%token INFIX3
%token INFIX4
%token INT
%token INTERP
%token LABEL
%token LBRACE
%token LBRACKET
%token LET
%token LIDENT
%token LOOP
%token LPAREN
%token MATCH
%token MINUS
%token MULTILINE_INTERP
%token MULTILINE_STRING
%token MUTABLE
//%token NEWLINE
%token PACKAGE_NAME
%token PIPE
%token PLUS
%token POST_LABEL
%token PRIV
%token PUB
%token QUESTION
%token RAISE
%token RANGE_EXCLUSIVE
%token RANGE_INCLUSIVE
%token RBRACE
%token RBRACKET
%token READONLY
%token RETURN
%token RPAREN
%token SEMI
%token STRING
%token STRUCT
%token TEST
%token THIN_ARROW
//%token THROW
%token TRAIT
%token TRUE
%token TRY
%token TYPE
%token TYPEALIAS
%token UIDENT
%token UNDERSCORE
%token WHILE
%token WITH

%right BARBAR
%right AMPERAMPER
%nonassoc RANGE_EXCLUSIVE RANGE_INCLUSIVE
%left BAR
%left CARET
%left AMPER
%nonassoc prec_field
%nonassoc LPAREN
%left INFIX1
%left INFIX2
%left MINUS PLUS
%left INFIX3
%left INFIX4
%nonassoc prec_type
%nonassoc prec_apply_non_ident_fn
%nonassoc EXCLAMATION
%nonassoc QUESTION

//%start expression
%start structure

%%

fn_label :
	LABEL
	;

parameter :
	LIDENT
	| LIDENT COLON type_
	| fn_label
	| fn_label COLON type_
	| fn_label EQUAL expr
	| fn_label COLON type_ EQUAL expr
	| fn_label QUESTION
	| fn_label QUESTION COLON type_
	| POST_LABEL
	| POST_LABEL COLON type_
	| POST_LABEL EQUAL expr
	| POST_LABEL COLON type_ EQUAL expr
	| LIDENT QUESTION
	| LIDENT QUESTION COLON type_
	;

type_parameters :
	LBRACKET non_empty_list_commas_id_tvar_binder__ RBRACKET
	;

optional_type_parameters :
	option_type_parameters_
	;

optional_type_parameters_no_constraints :
	option_delimited_LBRACKET_non_empty_list_commas_id_type_decl_binder___RBRACKET__
	;

optional_type_arguments :
	option_delimited_LBRACKET_non_empty_list_commas_type___RBRACKET__
	;

fun_binder :
	qual_ident_ty COLONCOLON LIDENT
	| LIDENT
	;

fun_header :
	FN fun_binder EXCLAMATION optional_type_parameters option_parameters_ option___anonymous_0_
	| FN fun_binder optional_type_parameters option_parameters_ option___anonymous_0_
	| PUB FN fun_binder EXCLAMATION optional_type_parameters option_parameters_ option___anonymous_0_
	| PUB FN fun_binder optional_type_parameters option_parameters_ option___anonymous_0_
	;

local_type_decl :
	STRUCT luident LBRACE RBRACE
	| STRUCT luident LBRACE non_empty_list_semis_record_decl_field_ RBRACE
	| ENUM luident LBRACE RBRACE
	| ENUM luident LBRACE non_empty_list_semis_enum_constructor_ RBRACE
	;

extern_fun_header :
	EXTERN STRING FN fun_binder EXCLAMATION optional_type_parameters option_parameters_ option___anonymous_1_
	| EXTERN STRING FN fun_binder optional_type_parameters option_parameters_ option___anonymous_1_
	| PUB EXTERN STRING FN fun_binder EXCLAMATION optional_type_parameters option_parameters_ option___anonymous_1_
	| PUB EXTERN STRING FN fun_binder optional_type_parameters option_parameters_ option___anonymous_1_
	;

//expression :
//	expr //EOF
//	;

val_header :
	LET LIDENT
	| LET LIDENT COLON type_
	| PUB LET LIDENT
	| PUB LET LIDENT COLON type_
	| CONST UIDENT
	| CONST UIDENT COLON type_
	| PUB CONST UIDENT
	| PUB CONST UIDENT COLON type_
	;

structure :
	%empty //EOF
	| non_empty_list_semis_structure_item_ //EOF
	;

structure_item :
	type_header deriving_directive_list
	| type_header type_ deriving_directive_list
	| type_header_bang option_type__ deriving_directive_list
	| type_header_bang LBRACE RBRACE deriving_directive_list
	| type_header_bang LBRACE non_empty_list_semis_enum_constructor_ RBRACE deriving_directive_list
	| type_alias_header EQUAL type_ deriving_directive_list
	| struct_header LBRACE RBRACE deriving_directive_list
	| struct_header LBRACE non_empty_list_semis_record_decl_field_ RBRACE deriving_directive_list
	| enum_header LBRACE RBRACE deriving_directive_list
	| enum_header LBRACE non_empty_list_semis_enum_constructor_ RBRACE deriving_directive_list
	| val_header EQUAL expr
	| fun_header EQUAL STRING STRING
	| fun_header EQUAL STRING
	| fun_header EQUAL non_empty_list_MULTILINE_STRING_
	| extern_fun_header EQUAL STRING
	| extern_fun_header EQUAL non_empty_list_MULTILINE_STRING_
	| fun_header LBRACE RBRACE
	| fun_header LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| fun_header LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| fun_header LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| fun_header LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| fun_header LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| TRAIT luident option___anonymous_2_ LBRACE RBRACE
	| TRAIT luident option___anonymous_2_ LBRACE non_empty_list_semis_trait_method_decl_ RBRACE
	| PRIV TRAIT luident option___anonymous_2_ LBRACE RBRACE
	| PRIV TRAIT luident option___anonymous_2_ LBRACE non_empty_list_semis_trait_method_decl_ RBRACE
	| PUB pub_attr TRAIT luident option___anonymous_2_ LBRACE RBRACE
	| PUB pub_attr TRAIT luident option___anonymous_2_ LBRACE non_empty_list_semis_trait_method_decl_ RBRACE
	| TEST option_loced_string_ option_parameters_ LBRACE RBRACE
	| TEST option_loced_string_ option_parameters_ LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| TEST option_loced_string_ option_parameters_ LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| TEST option_loced_string_ option_parameters_ LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| TEST option_loced_string_ option_parameters_ LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| TEST option_loced_string_ option_parameters_ LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty FOR type_ WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ RBRACE
	| PUB IMPL optional_type_parameters qual_ident_ty WITH LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN THIN_ARROW return_type LBRACE non_empty_list_semis_local_type_decl_ non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	;

pub_attr :
	| LPAREN READONLY RPAREN
	| LPAREN LIDENT RPAREN
	;

type_header :
	TYPE luident optional_type_parameters_no_constraints
	| PRIV TYPE luident optional_type_parameters_no_constraints
	| PUB pub_attr TYPE luident optional_type_parameters_no_constraints
	;

type_header_bang :
	TYPE EXCLAMATION luident
	| PRIV TYPE EXCLAMATION luident
	| PUB pub_attr TYPE EXCLAMATION luident
	;

type_alias_header :
	TYPEALIAS luident optional_type_parameters_no_constraints
	| PRIV TYPEALIAS luident optional_type_parameters_no_constraints
	| PUB pub_attr TYPEALIAS luident optional_type_parameters_no_constraints
	;

struct_header :
	STRUCT luident optional_type_parameters_no_constraints
	| PRIV STRUCT luident optional_type_parameters_no_constraints
	| PUB pub_attr STRUCT luident optional_type_parameters_no_constraints
	;

enum_header :
	ENUM luident optional_type_parameters_no_constraints
	| PRIV ENUM luident optional_type_parameters_no_constraints
	| PUB pub_attr ENUM luident optional_type_parameters_no_constraints
	;

deriving_directive :
	qual_ident_ty
	| qual_ident_ty LPAREN RPAREN
	| qual_ident_ty LPAREN non_empty_list_commas_argument_ RPAREN
	;

deriving_directive_list :
	| DERIVE LPAREN RPAREN
	| DERIVE LPAREN non_empty_list_commas_deriving_directive_ RPAREN
	;

trait_method_decl :
	LIDENT EXCLAMATION optional_type_parameters LPAREN RPAREN option___anonymous_5_
	| LIDENT EXCLAMATION optional_type_parameters LPAREN non_empty_list_commas_trait_method_param_ RPAREN option___anonymous_5_
	| LIDENT optional_type_parameters LPAREN RPAREN option___anonymous_5_
	| LIDENT optional_type_parameters LPAREN non_empty_list_commas_trait_method_param_ RPAREN option___anonymous_5_
	;

trait_method_param :
	type_
	| LABEL COLON type_
	| POST_LABEL COLON type_
	;

luident :
	LIDENT
	| UIDENT
	;

qual_ident :
	LIDENT
	| PACKAGE_NAME DOT_LIDENT
	;

qual_ident_simple_expr :
	LIDENT %prec prec_apply_non_ident_fn
	| PACKAGE_NAME DOT_LIDENT
	;

qual_ident_ty :
	luident
	| PACKAGE_NAME DOT_LIDENT
	| PACKAGE_NAME DOT_UIDENT
	;

statement :
	LET pattern EQUAL expr
	| LET pattern COLON type_ EQUAL expr
	| LET MUTABLE LIDENT EQUAL expr
	| LET MUTABLE LIDENT COLON type_ EQUAL expr
	| FN LIDENT EXCLAMATION LPAREN RPAREN option___anonymous_6_ LBRACE RBRACE
	| FN LIDENT EXCLAMATION LPAREN RPAREN option___anonymous_6_ LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| FN LIDENT EXCLAMATION LPAREN RPAREN option___anonymous_6_ LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| FN LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN option___anonymous_6_ LBRACE RBRACE
	| FN LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN option___anonymous_6_ LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| FN LIDENT EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN option___anonymous_6_ LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| FN LIDENT LPAREN RPAREN option___anonymous_6_ LBRACE RBRACE
	| FN LIDENT LPAREN RPAREN option___anonymous_6_ LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| FN LIDENT LPAREN RPAREN option___anonymous_6_ LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| FN LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN option___anonymous_6_ LBRACE RBRACE
	| FN LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN option___anonymous_6_ LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| FN LIDENT LPAREN non_empty_list_commas_parameter_ RPAREN option___anonymous_6_ LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| FN LIDENT EXCLAMATION LBRACE RBRACE
	| FN LIDENT EXCLAMATION LBRACE non_empty_list_semis___anonymous_7_ RBRACE
	| FN LIDENT LBRACE RBRACE
	| FN LIDENT LBRACE non_empty_list_semis___anonymous_7_ RBRACE
	| guard_statement
	| BREAK
	| BREAK expr
	| CONTINUE
	| CONTINUE non_empty_list_commas_no_trailing_expr_
	| RETURN option_expr_
	| RAISE expr
	| ELLIPSIS
	| qual_ident AUGMENTED_ASSIGNMENT expr
	| simple_expr DOT_LIDENT AUGMENTED_ASSIGNMENT expr
	| simple_expr DOT_INT AUGMENTED_ASSIGNMENT expr
	| simple_expr LBRACKET expr RBRACKET AUGMENTED_ASSIGNMENT expr
	| qual_ident EQUAL expr
	| simple_expr DOT_LIDENT EQUAL expr
	| simple_expr DOT_INT EQUAL expr
	| simple_expr LBRACKET expr RBRACKET EQUAL expr
	| expr
	;

guard_statement :
	GUARD infix_expr
	| GUARD infix_expr ELSE LBRACE RBRACE
	| GUARD infix_expr ELSE LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| GUARD infix_expr ELSE LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| GUARD LET pattern EQUAL infix_expr
	| GUARD LET pattern EQUAL infix_expr ELSE LBRACE single_pattern_cases RBRACE
	;

while_expr :
	WHILE infix_expr LBRACE RBRACE optional_else
	| WHILE infix_expr LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE optional_else
	| WHILE infix_expr LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE optional_else
	;

single_pattern_cases :
	| non_empty_list_semis___anonymous_8_
	;

try_expr :
	TRY expr CATCH LBRACE single_pattern_cases RBRACE
	| TRY expr LBRACE single_pattern_cases RBRACE
	| TRY expr CATCH EXCLAMATION LBRACE single_pattern_cases RBRACE
	| TRY expr CATCH LBRACE single_pattern_cases RBRACE ELSE LBRACE single_pattern_cases RBRACE
	| TRY expr LBRACE single_pattern_cases RBRACE ELSE LBRACE single_pattern_cases RBRACE
	| TRY expr CATCH EXCLAMATION LBRACE single_pattern_cases RBRACE ELSE LBRACE single_pattern_cases RBRACE
	;

if_expr :
	IF infix_expr LBRACE RBRACE ELSE LBRACE RBRACE
	| IF infix_expr LBRACE RBRACE ELSE LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IF infix_expr LBRACE RBRACE ELSE LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IF infix_expr LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE ELSE LBRACE RBRACE
	| IF infix_expr LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE ELSE LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IF infix_expr LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE ELSE LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IF infix_expr LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE ELSE LBRACE RBRACE
	| IF infix_expr LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE ELSE LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IF infix_expr LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE ELSE LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| IF infix_expr LBRACE RBRACE ELSE if_expr
	| IF infix_expr LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE ELSE if_expr
	| IF infix_expr LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE ELSE if_expr
	| IF infix_expr LBRACE RBRACE
	| IF infix_expr LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| IF infix_expr LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	;

match_expr :
	MATCH infix_expr LBRACE non_empty_list_semis___anonymous_9_ RBRACE
	| MATCH infix_expr LBRACE RBRACE
	;

loop_expr :
	LOOP non_empty_list_commas_no_trailing_expr_ LBRACE RBRACE
	| LOOP non_empty_list_commas_no_trailing_expr_ LBRACE non_empty_list_semis___anonymous_10_ RBRACE
	;

for_binders :
	| non_empty_list_commas_no_trailing___anonymous_11_
	;

optional_else :
	ELSE LBRACE RBRACE
	| ELSE LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| ELSE LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	|
	;

for_expr :
	FOR for_binders SEMI option_infix_expr_ SEMI LBRACE RBRACE optional_else
	| FOR for_binders SEMI option_infix_expr_ SEMI LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE optional_else
	| FOR for_binders SEMI option_infix_expr_ SEMI LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE optional_else
	| FOR for_binders SEMI option_infix_expr_ SEMI non_empty_list_commas_no_trailing___anonymous_12_ LBRACE RBRACE optional_else
	| FOR for_binders SEMI option_infix_expr_ SEMI non_empty_list_commas_no_trailing___anonymous_12_ LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE optional_else
	| FOR for_binders SEMI option_infix_expr_ SEMI non_empty_list_commas_no_trailing___anonymous_12_ LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE optional_else
	| FOR for_binders LBRACE RBRACE optional_else
	| FOR for_binders LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE optional_else
	| FOR for_binders LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE optional_else
	;

foreach_expr :
	FOR non_empty_list_commas_foreach_binder_ IN expr LBRACE RBRACE optional_else
	| FOR non_empty_list_commas_foreach_binder_ IN expr LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE optional_else
	| FOR non_empty_list_commas_foreach_binder_ IN expr LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE optional_else
	;

foreach_binder :
	LIDENT
	| UNDERSCORE
	;

expr :
	loop_expr
	| for_expr
	| foreach_expr
	| while_expr
	| try_expr
	| if_expr
	| match_expr
	| pipe_expr
	;

pipe_expr :
	pipe_expr PIPE infix_expr
	| infix_expr
	;

infix_expr :
	infix_expr INFIX4 infix_expr
	| infix_expr INFIX3 infix_expr
	| infix_expr INFIX2 infix_expr
	| infix_expr INFIX1 infix_expr
	| infix_expr PLUS infix_expr
	| infix_expr MINUS infix_expr
	| infix_expr AMPER infix_expr
	| infix_expr CARET infix_expr
	| infix_expr BAR infix_expr
	| infix_expr AMPERAMPER infix_expr
	| infix_expr BARBAR infix_expr
	| infix_expr RANGE_EXCLUSIVE infix_expr
	| infix_expr RANGE_INCLUSIVE infix_expr
	| postfix_expr
	;

postfix_expr :
	prefix_expr AS qual_ident_ty
	| prefix_expr
	;

prefix_expr :
	PLUS prefix_expr
	| MINUS prefix_expr
	| simple_expr
	;

simple_expr :
	LBRACE record_defn RBRACE
	| qual_ident_ty COLONCOLON LBRACE RBRACE
	| qual_ident_ty COLONCOLON LBRACE non_empty_list_commas_with_trailing_info_record_defn_single_ RBRACE
	| LBRACE DOTDOT expr RBRACE
	| qual_ident_ty COLONCOLON LBRACE DOTDOT expr RBRACE
	| LBRACE DOTDOT expr COMMA RBRACE
	| LBRACE DOTDOT expr COMMA non_empty_list_commas_record_defn_single_ RBRACE
	| qual_ident_ty COLONCOLON LBRACE DOTDOT expr COMMA RBRACE
	| qual_ident_ty COLONCOLON LBRACE DOTDOT expr COMMA non_empty_list_commas_record_defn_single_ RBRACE
	| LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| LBRACE RBRACE
	| LBRACE non_empty_list_commas_map_expr_elem_ RBRACE
	| FN EXCLAMATION LPAREN RPAREN option___anonymous_15_ LBRACE RBRACE
	| FN EXCLAMATION LPAREN RPAREN option___anonymous_15_ LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| FN EXCLAMATION LPAREN RPAREN option___anonymous_15_ LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| FN EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN option___anonymous_15_ LBRACE RBRACE
	| FN EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN option___anonymous_15_ LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| FN EXCLAMATION LPAREN non_empty_list_commas_parameter_ RPAREN option___anonymous_15_ LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| FN LPAREN RPAREN option___anonymous_15_ LBRACE RBRACE
	| FN LPAREN RPAREN option___anonymous_15_ LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| FN LPAREN RPAREN option___anonymous_15_ LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| FN LPAREN non_empty_list_commas_parameter_ RPAREN option___anonymous_15_ LBRACE RBRACE
	| FN LPAREN non_empty_list_commas_parameter_ RPAREN option___anonymous_15_ LBRACE non_empty_list_semi_rev_aux_statement_ RBRACE
	| FN LPAREN non_empty_list_commas_parameter_ RPAREN option___anonymous_15_ LBRACE non_empty_list_semi_rev_aux_statement_ SEMI RBRACE
	| FN EXCLAMATION LBRACE RBRACE
	| FN EXCLAMATION LBRACE non_empty_list_semis___anonymous_16_ RBRACE
	| FN LBRACE RBRACE
	| FN LBRACE non_empty_list_semis___anonymous_16_ RBRACE
	| TRUE
	| FALSE
	| BYTE
	| BYTES
	| CHAR
	| INT
	| FLOAT
	| STRING
	| non_empty_list_multiline_string_
	| INTERP
	| UNDERSCORE
	| qual_ident_simple_expr
	| UIDENT
	| PACKAGE_NAME DOT_UIDENT
	| qual_ident_ty COLONCOLON UIDENT
	| LIDENT QUESTION LPAREN RPAREN
	| LIDENT QUESTION LPAREN non_empty_list_commas_argument_ RPAREN
	| simple_expr LPAREN RPAREN
	| simple_expr LPAREN non_empty_list_commas_argument_ RPAREN
	| simple_expr EXCLAMATION LPAREN RPAREN
	| simple_expr EXCLAMATION LPAREN non_empty_list_commas_argument_ RPAREN
	| simple_expr QUESTION LPAREN RPAREN
	| simple_expr QUESTION LPAREN non_empty_list_commas_argument_ RPAREN
	| simple_expr LBRACKET expr RBRACKET
	| simple_expr LBRACKET COLON RBRACKET
	| simple_expr LBRACKET COLON expr RBRACKET
	| simple_expr LBRACKET expr COLON RBRACKET
	| simple_expr LBRACKET expr COLON expr RBRACKET
	| simple_expr DOT_LIDENT LPAREN RPAREN
	| simple_expr DOT_LIDENT LPAREN non_empty_list_commas_argument_ RPAREN
	| simple_expr DOT_LIDENT EXCLAMATION LPAREN RPAREN
	| simple_expr DOT_LIDENT EXCLAMATION LPAREN non_empty_list_commas_argument_ RPAREN
	| simple_expr DOT_LIDENT QUESTION LPAREN RPAREN
	| simple_expr DOT_LIDENT QUESTION LPAREN non_empty_list_commas_argument_ RPAREN
	| simple_expr DOTDOT LIDENT LPAREN RPAREN
	| simple_expr DOTDOT LIDENT LPAREN non_empty_list_commas_argument_ RPAREN
	| simple_expr DOTDOT LIDENT EXCLAMATION LPAREN RPAREN
	| simple_expr DOTDOT LIDENT EXCLAMATION LPAREN non_empty_list_commas_argument_ RPAREN
	| simple_expr DOTDOT LIDENT QUESTION LPAREN RPAREN
	| simple_expr DOTDOT LIDENT QUESTION LPAREN non_empty_list_commas_argument_ RPAREN
	| simple_expr DOT_LIDENT %prec prec_field
	| simple_expr DOT_INT %prec prec_field
	| qual_ident_ty COLONCOLON LIDENT
	| LPAREN RPAREN
	| LPAREN non_empty_list_commas_expr_ RPAREN
	| LPAREN expr COLON type_ RPAREN
	| LBRACKET RBRACKET
	| LBRACKET non_empty_list_commas_spreadable_elem_ RBRACKET
	;

argument :
	LIDENT QUESTION EQUAL expr
	| LIDENT EQUAL expr
	| fn_label QUESTION
	| fn_label
	| expr
	| POST_LABEL
	| LIDENT QUESTION
	;

pattern :
	pattern AS LIDENT
	| or_pattern
	;

or_pattern :
	range_pattern BAR or_pattern
	| range_pattern
	;

range_pattern :
	simple_pattern RANGE_EXCLUSIVE simple_pattern
	| simple_pattern RANGE_INCLUSIVE simple_pattern
	| simple_pattern
	;

simple_pattern :
	TRUE
	| FALSE
	| CHAR
	| INT
	| FLOAT
	| MINUS INT
	| MINUS FLOAT
	| STRING
	| UNDERSCORE
	| LIDENT
	| UIDENT option___anonymous_17_
	| PACKAGE_NAME DOT_UIDENT option___anonymous_17_
	| qual_ident_ty COLONCOLON UIDENT option___anonymous_17_
	| LPAREN pattern RPAREN
	| LPAREN pattern COMMA non_empty_list_commas_pattern_ RPAREN
	| LPAREN pattern COLON type_ RPAREN
	| LBRACKET array_sub_patterns RBRACKET
	| LBRACE RBRACE
	| LBRACE non_empty_fields_pat RBRACE
	| LBRACE non_empty_map_elems_pat RBRACE
	;

array_sub_patterns :
	| DOTDOT option___anonymous_18_
	| DOTDOT option___anonymous_18_ COMMA
	| non_empty_list_commas_pattern_
	| DOTDOT option___anonymous_18_ COMMA non_empty_list_commas_pattern_
	| non_empty_list_commas_with_tail_pattern_ DOTDOT option___anonymous_18_
	| non_empty_list_commas_with_tail_pattern_ DOTDOT option___anonymous_18_ COMMA
	| non_empty_list_commas_with_tail_pattern_ DOTDOT option___anonymous_18_ COMMA non_empty_list_commas_pattern_
	;

return_type :
	type_ %prec prec_type
	| type_ EXCLAMATION
	| type_ EXCLAMATION type_
	;

type_ :
	type_ QUESTION
	| LPAREN type_ COMMA non_empty_list_commas_type__ RPAREN
	| LPAREN type_ COMMA non_empty_list_commas_type__ RPAREN THIN_ARROW return_type
	| LPAREN RPAREN THIN_ARROW return_type
	| LPAREN type_ RPAREN option___anonymous_19_
	| qual_ident_ty optional_type_arguments
	| UNDERSCORE
	;

record_decl_field :
	option_MUTABLE_ LIDENT COLON type_
	| PRIV option_MUTABLE_ LIDENT COLON type_
	| PUB pub_attr option_MUTABLE_ LIDENT COLON type_
	;

constructor_param :
	option_MUTABLE_ type_
	| option_MUTABLE_ LABEL COLON type_
	| option_MUTABLE_ POST_LABEL COLON type_
	;

enum_constructor :
	UIDENT option___anonymous_20_
	;

record_defn :
	LIDENT COMMA
	| LIDENT COMMA non_empty_list_commas_with_trailing_info_record_defn_single_
	| LIDENT COLON expr option_COMMA_
	| LIDENT COLON expr COMMA non_empty_list_commas_with_trailing_info_record_defn_single_
	;

record_defn_single :
	LIDENT COLON expr
	| LIDENT
	;

non_empty_fields_pat :
	non_empty_list_commas_fields_pat_single_
	| non_empty_list_commas_with_tail_fields_pat_single_ DOTDOT
	| non_empty_list_commas_with_tail_fields_pat_single_ DOTDOT COMMA
	;

fields_pat_single :
	LIDENT COLON pattern
	| LIDENT
	;

non_empty_map_elems_pat :
	non_empty_list_commas_map_elem_pat_
	;

constr_pat_arguments :
	constr_pat_argument
	| constr_pat_argument COMMA
	| DOTDOT
	| DOTDOT COMMA
	| constr_pat_argument COMMA constr_pat_arguments
	;

constr_pat_argument :
	LIDENT EQUAL pattern
	| fn_label
	| POST_LABEL
	| pattern
	;

option_COMMA_ :
	| COMMA
	;

option_MUTABLE_ :
	| MUTABLE
	;

option___anonymous_0_ :
	| THIN_ARROW return_type
	;

option___anonymous_1_ :
	| THIN_ARROW return_type
	;

option___anonymous_15_ :
	| THIN_ARROW return_type
	;

option___anonymous_17_ :
	| LPAREN constr_pat_arguments RPAREN
	;

option___anonymous_18_ :
	| AS LIDENT
	;

option___anonymous_19_ :
	| THIN_ARROW return_type
	;

option___anonymous_2_ :
	| COLON separated_nonempty_list_PLUS_tvar_constraint_
	;

option___anonymous_20_ :
	| LPAREN non_empty_list_commas_constructor_param_ RPAREN
	;

option___anonymous_5_ :
	| THIN_ARROW return_type
	;

option___anonymous_6_ :
	| THIN_ARROW return_type
	;

option_delimited_LBRACKET_non_empty_list_commas_id_type_decl_binder___RBRACKET__ :
	| LBRACKET non_empty_list_commas_id_type_decl_binder__ RBRACKET
	;

option_delimited_LBRACKET_non_empty_list_commas_type___RBRACKET__ :
	| LBRACKET non_empty_list_commas_type__ RBRACKET
	;

option_expr_ :
	| expr
	;

option_infix_expr_ :
	| infix_expr
	;

option_loced_string_ :
	| STRING
	;

option_parameters_ :
	| LPAREN RPAREN
	| LPAREN non_empty_list_commas_parameter_ RPAREN
	;

option_type__ :
	| type_
	;

option_type_parameters_ :
	| type_parameters
	;

separated_nonempty_list_PLUS_tvar_constraint_ :
	qual_ident_ty
	| UIDENT QUESTION
	| qual_ident_ty PLUS separated_nonempty_list_PLUS_tvar_constraint_
	| UIDENT QUESTION PLUS separated_nonempty_list_PLUS_tvar_constraint_
	;

non_empty_list_rev_MULTILINE_STRING_ :
	MULTILINE_STRING
	| non_empty_list_rev_MULTILINE_STRING_ MULTILINE_STRING
	;

non_empty_list_rev_multiline_string_ :
	MULTILINE_STRING
	| MULTILINE_INTERP
	| non_empty_list_rev_multiline_string_ MULTILINE_STRING
	| non_empty_list_rev_multiline_string_ MULTILINE_INTERP
	;

non_empty_list_MULTILINE_STRING_ :
	non_empty_list_rev_MULTILINE_STRING_
	;

non_empty_list_multiline_string_ :
	non_empty_list_rev_multiline_string_
	;

non_empty_list_commas_rev___anonymous_11_ :
	LIDENT EQUAL expr
	| non_empty_list_commas_rev___anonymous_11_ COMMA LIDENT EQUAL expr
	;

non_empty_list_commas_rev___anonymous_12_ :
	LIDENT EQUAL expr
	| non_empty_list_commas_rev___anonymous_12_ COMMA LIDENT EQUAL expr
	;

non_empty_list_commas_rev_argument_ :
	argument
	| non_empty_list_commas_rev_argument_ COMMA argument
	;

non_empty_list_commas_rev_constructor_param_ :
	constructor_param
	| non_empty_list_commas_rev_constructor_param_ COMMA constructor_param
	;

non_empty_list_commas_rev_deriving_directive_ :
	deriving_directive
	| non_empty_list_commas_rev_deriving_directive_ COMMA deriving_directive
	;

non_empty_list_commas_rev_expr_ :
	expr
	| non_empty_list_commas_rev_expr_ COMMA expr
	;

non_empty_list_commas_rev_fields_pat_single_ :
	fields_pat_single
	| non_empty_list_commas_rev_fields_pat_single_ COMMA fields_pat_single
	;

non_empty_list_commas_rev_foreach_binder_ :
	foreach_binder
	| non_empty_list_commas_rev_foreach_binder_ COMMA foreach_binder
	;

non_empty_list_commas_rev_id_tvar_binder__ :
	luident
	| luident COLON separated_nonempty_list_PLUS_tvar_constraint_
	| non_empty_list_commas_rev_id_tvar_binder__ COMMA luident
	| non_empty_list_commas_rev_id_tvar_binder__ COMMA luident COLON separated_nonempty_list_PLUS_tvar_constraint_
	;

non_empty_list_commas_rev_id_type_decl_binder__ :
	luident
	| UNDERSCORE
	| non_empty_list_commas_rev_id_type_decl_binder__ COMMA luident
	| non_empty_list_commas_rev_id_type_decl_binder__ COMMA UNDERSCORE
	;

non_empty_list_commas_rev_map_elem_pat_ :
	TRUE COLON pattern
	| TRUE QUESTION COLON pattern
	| FALSE COLON pattern
	| FALSE QUESTION COLON pattern
	| BYTE COLON pattern
	| BYTE QUESTION COLON pattern
	| BYTES COLON pattern
	| BYTES QUESTION COLON pattern
	| CHAR COLON pattern
	| CHAR QUESTION COLON pattern
	| INT COLON pattern
	| INT QUESTION COLON pattern
	| FLOAT COLON pattern
	| FLOAT QUESTION COLON pattern
	| STRING COLON pattern
	| STRING QUESTION COLON pattern
	| MINUS INT COLON pattern
	| MINUS INT QUESTION COLON pattern
	| MINUS FLOAT COLON pattern
	| MINUS FLOAT QUESTION COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA TRUE COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA TRUE QUESTION COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA FALSE COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA FALSE QUESTION COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA BYTE COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA BYTE QUESTION COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA BYTES COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA BYTES QUESTION COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA CHAR COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA CHAR QUESTION COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA INT COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA INT QUESTION COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA FLOAT COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA FLOAT QUESTION COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA STRING COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA STRING QUESTION COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA MINUS INT COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA MINUS INT QUESTION COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA MINUS FLOAT COLON pattern
	| non_empty_list_commas_rev_map_elem_pat_ COMMA MINUS FLOAT QUESTION COLON pattern
	;

non_empty_list_commas_rev_map_expr_elem_ :
	TRUE COLON expr
	| FALSE COLON expr
	| BYTE COLON expr
	| BYTES COLON expr
	| CHAR COLON expr
	| INT COLON expr
	| FLOAT COLON expr
	| STRING COLON expr
	| MINUS INT COLON expr
	| MINUS FLOAT COLON expr
	| non_empty_list_commas_rev_map_expr_elem_ COMMA TRUE COLON expr
	| non_empty_list_commas_rev_map_expr_elem_ COMMA FALSE COLON expr
	| non_empty_list_commas_rev_map_expr_elem_ COMMA BYTE COLON expr
	| non_empty_list_commas_rev_map_expr_elem_ COMMA BYTES COLON expr
	| non_empty_list_commas_rev_map_expr_elem_ COMMA CHAR COLON expr
	| non_empty_list_commas_rev_map_expr_elem_ COMMA INT COLON expr
	| non_empty_list_commas_rev_map_expr_elem_ COMMA FLOAT COLON expr
	| non_empty_list_commas_rev_map_expr_elem_ COMMA STRING COLON expr
	| non_empty_list_commas_rev_map_expr_elem_ COMMA MINUS INT COLON expr
	| non_empty_list_commas_rev_map_expr_elem_ COMMA MINUS FLOAT COLON expr
	;

non_empty_list_commas_rev_parameter_ :
	parameter
	| non_empty_list_commas_rev_parameter_ COMMA parameter
	;

non_empty_list_commas_rev_pattern_ :
	pattern
	| non_empty_list_commas_rev_pattern_ COMMA pattern
	;

non_empty_list_commas_rev_record_defn_single_ :
	record_defn_single
	| non_empty_list_commas_rev_record_defn_single_ COMMA record_defn_single
	;

non_empty_list_commas_rev_spreadable_elem_ :
	expr
	| DOTDOT expr
	| non_empty_list_commas_rev_spreadable_elem_ COMMA expr
	| non_empty_list_commas_rev_spreadable_elem_ COMMA DOTDOT expr
	;

non_empty_list_commas_rev_trait_method_param_ :
	trait_method_param
	| non_empty_list_commas_rev_trait_method_param_ COMMA trait_method_param
	;

non_empty_list_commas_rev_type__ :
	type_
	| non_empty_list_commas_rev_type__ COMMA type_
	;

non_empty_list_commas_no_trailing___anonymous_11_ :
	non_empty_list_commas_rev___anonymous_11_
	;

non_empty_list_commas_no_trailing___anonymous_12_ :
	non_empty_list_commas_rev___anonymous_12_
	;

non_empty_list_commas_no_trailing_expr_ :
	non_empty_list_commas_rev_expr_
	;

non_empty_list_commas_argument_ :
	non_empty_list_commas_rev_argument_
	| non_empty_list_commas_rev_argument_ COMMA
	;

non_empty_list_commas_constructor_param_ :
	non_empty_list_commas_rev_constructor_param_
	| non_empty_list_commas_rev_constructor_param_ COMMA
	;

non_empty_list_commas_deriving_directive_ :
	non_empty_list_commas_rev_deriving_directive_
	| non_empty_list_commas_rev_deriving_directive_ COMMA
	;

non_empty_list_commas_expr_ :
	non_empty_list_commas_rev_expr_
	| non_empty_list_commas_rev_expr_ COMMA
	;

non_empty_list_commas_fields_pat_single_ :
	non_empty_list_commas_rev_fields_pat_single_
	| non_empty_list_commas_rev_fields_pat_single_ COMMA
	;

non_empty_list_commas_foreach_binder_ :
	non_empty_list_commas_rev_foreach_binder_
	| non_empty_list_commas_rev_foreach_binder_ COMMA
	;

non_empty_list_commas_id_tvar_binder__ :
	non_empty_list_commas_rev_id_tvar_binder__
	| non_empty_list_commas_rev_id_tvar_binder__ COMMA
	;

non_empty_list_commas_id_type_decl_binder__ :
	non_empty_list_commas_rev_id_type_decl_binder__
	| non_empty_list_commas_rev_id_type_decl_binder__ COMMA
	;

non_empty_list_commas_map_elem_pat_ :
	non_empty_list_commas_rev_map_elem_pat_
	| non_empty_list_commas_rev_map_elem_pat_ COMMA
	;

non_empty_list_commas_map_expr_elem_ :
	non_empty_list_commas_rev_map_expr_elem_
	| non_empty_list_commas_rev_map_expr_elem_ COMMA
	;

non_empty_list_commas_parameter_ :
	non_empty_list_commas_rev_parameter_
	| non_empty_list_commas_rev_parameter_ COMMA
	;

non_empty_list_commas_pattern_ :
	non_empty_list_commas_rev_pattern_
	| non_empty_list_commas_rev_pattern_ COMMA
	;

non_empty_list_commas_record_defn_single_ :
	non_empty_list_commas_rev_record_defn_single_
	| non_empty_list_commas_rev_record_defn_single_ COMMA
	;

non_empty_list_commas_spreadable_elem_ :
	non_empty_list_commas_rev_spreadable_elem_
	| non_empty_list_commas_rev_spreadable_elem_ COMMA
	;

non_empty_list_commas_trait_method_param_ :
	non_empty_list_commas_rev_trait_method_param_
	| non_empty_list_commas_rev_trait_method_param_ COMMA
	;

non_empty_list_commas_type__ :
	non_empty_list_commas_rev_type__
	| non_empty_list_commas_rev_type__ COMMA
	;

non_empty_list_commas_with_tail_fields_pat_single_ :
	non_empty_list_commas_rev_fields_pat_single_ COMMA
	;

non_empty_list_commas_with_tail_pattern_ :
	non_empty_list_commas_rev_pattern_ COMMA
	;

non_empty_list_commas_with_trailing_info_record_defn_single_ :
	non_empty_list_commas_rev_record_defn_single_
	| non_empty_list_commas_rev_record_defn_single_ COMMA
	;

non_empty_list_semi_rev_aux___anonymous_10_ :
	non_empty_list_commas_pattern_ FAT_ARROW BREAK
	| non_empty_list_commas_pattern_ FAT_ARROW BREAK expr
	| non_empty_list_commas_pattern_ FAT_ARROW CONTINUE
	| non_empty_list_commas_pattern_ FAT_ARROW CONTINUE non_empty_list_commas_no_trailing_expr_
	| non_empty_list_commas_pattern_ FAT_ARROW RETURN option_expr_
	| non_empty_list_commas_pattern_ FAT_ARROW RAISE expr
	| non_empty_list_commas_pattern_ FAT_ARROW ELLIPSIS
	| non_empty_list_commas_pattern_ FAT_ARROW qual_ident AUGMENTED_ASSIGNMENT expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_LIDENT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_INT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr LBRACKET expr RBRACKET AUGMENTED_ASSIGNMENT expr
	| non_empty_list_commas_pattern_ FAT_ARROW qual_ident EQUAL expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_LIDENT EQUAL expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_INT EQUAL expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr LBRACKET expr RBRACKET EQUAL expr
	| non_empty_list_commas_pattern_ FAT_ARROW expr
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW BREAK
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW BREAK expr
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW CONTINUE
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW CONTINUE non_empty_list_commas_no_trailing_expr_
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW RETURN option_expr_
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW RAISE expr
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW ELLIPSIS
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW qual_ident AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_LIDENT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_INT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr LBRACKET expr RBRACKET AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW qual_ident EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_LIDENT EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_INT EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr LBRACKET expr RBRACKET EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI non_empty_list_commas_pattern_ FAT_ARROW expr
	;

non_empty_list_semi_rev_aux___anonymous_16_ :
	non_empty_list_commas_pattern_ FAT_ARROW BREAK
	| non_empty_list_commas_pattern_ FAT_ARROW BREAK expr
	| non_empty_list_commas_pattern_ FAT_ARROW CONTINUE
	| non_empty_list_commas_pattern_ FAT_ARROW CONTINUE non_empty_list_commas_no_trailing_expr_
	| non_empty_list_commas_pattern_ FAT_ARROW RETURN option_expr_
	| non_empty_list_commas_pattern_ FAT_ARROW RAISE expr
	| non_empty_list_commas_pattern_ FAT_ARROW ELLIPSIS
	| non_empty_list_commas_pattern_ FAT_ARROW qual_ident AUGMENTED_ASSIGNMENT expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_LIDENT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_INT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr LBRACKET expr RBRACKET AUGMENTED_ASSIGNMENT expr
	| non_empty_list_commas_pattern_ FAT_ARROW qual_ident EQUAL expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_LIDENT EQUAL expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_INT EQUAL expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr LBRACKET expr RBRACKET EQUAL expr
	| non_empty_list_commas_pattern_ FAT_ARROW expr
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW BREAK
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW BREAK expr
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW CONTINUE
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW CONTINUE non_empty_list_commas_no_trailing_expr_
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW RETURN option_expr_
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW RAISE expr
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW ELLIPSIS
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW qual_ident AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_LIDENT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_INT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr LBRACKET expr RBRACKET AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW qual_ident EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_LIDENT EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_INT EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr LBRACKET expr RBRACKET EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI non_empty_list_commas_pattern_ FAT_ARROW expr
	;

non_empty_list_semi_rev_aux___anonymous_7_ :
	non_empty_list_commas_pattern_ FAT_ARROW BREAK
	| non_empty_list_commas_pattern_ FAT_ARROW BREAK expr
	| non_empty_list_commas_pattern_ FAT_ARROW CONTINUE
	| non_empty_list_commas_pattern_ FAT_ARROW CONTINUE non_empty_list_commas_no_trailing_expr_
	| non_empty_list_commas_pattern_ FAT_ARROW RETURN option_expr_
	| non_empty_list_commas_pattern_ FAT_ARROW RAISE expr
	| non_empty_list_commas_pattern_ FAT_ARROW ELLIPSIS
	| non_empty_list_commas_pattern_ FAT_ARROW qual_ident AUGMENTED_ASSIGNMENT expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_LIDENT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_INT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr LBRACKET expr RBRACKET AUGMENTED_ASSIGNMENT expr
	| non_empty_list_commas_pattern_ FAT_ARROW qual_ident EQUAL expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_LIDENT EQUAL expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_INT EQUAL expr
	| non_empty_list_commas_pattern_ FAT_ARROW simple_expr LBRACKET expr RBRACKET EQUAL expr
	| non_empty_list_commas_pattern_ FAT_ARROW expr
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW BREAK
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW BREAK expr
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW CONTINUE
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW CONTINUE non_empty_list_commas_no_trailing_expr_
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW RETURN option_expr_
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW RAISE expr
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW ELLIPSIS
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW qual_ident AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_LIDENT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_INT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr LBRACKET expr RBRACKET AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW qual_ident EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_LIDENT EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr DOT_INT EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW simple_expr LBRACKET expr RBRACKET EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI non_empty_list_commas_pattern_ FAT_ARROW expr
	;

non_empty_list_semi_rev_aux___anonymous_8_ :
	pattern FAT_ARROW BREAK
	| pattern FAT_ARROW BREAK expr
	| pattern FAT_ARROW CONTINUE
	| pattern FAT_ARROW CONTINUE non_empty_list_commas_no_trailing_expr_
	| pattern FAT_ARROW RETURN option_expr_
	| pattern FAT_ARROW RAISE expr
	| pattern FAT_ARROW ELLIPSIS
	| pattern FAT_ARROW qual_ident AUGMENTED_ASSIGNMENT expr
	| pattern FAT_ARROW simple_expr DOT_LIDENT AUGMENTED_ASSIGNMENT expr
	| pattern FAT_ARROW simple_expr DOT_INT AUGMENTED_ASSIGNMENT expr
	| pattern FAT_ARROW simple_expr LBRACKET expr RBRACKET AUGMENTED_ASSIGNMENT expr
	| pattern FAT_ARROW qual_ident EQUAL expr
	| pattern FAT_ARROW simple_expr DOT_LIDENT EQUAL expr
	| pattern FAT_ARROW simple_expr DOT_INT EQUAL expr
	| pattern FAT_ARROW simple_expr LBRACKET expr RBRACKET EQUAL expr
	| pattern FAT_ARROW expr
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW BREAK
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW BREAK expr
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW CONTINUE
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW CONTINUE non_empty_list_commas_no_trailing_expr_
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW RETURN option_expr_
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW RAISE expr
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW ELLIPSIS
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW qual_ident AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW simple_expr DOT_LIDENT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW simple_expr DOT_INT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW simple_expr LBRACKET expr RBRACKET AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW qual_ident EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW simple_expr DOT_LIDENT EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW simple_expr DOT_INT EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW simple_expr LBRACKET expr RBRACKET EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI pattern FAT_ARROW expr
	;

non_empty_list_semi_rev_aux___anonymous_9_ :
	pattern FAT_ARROW BREAK
	| pattern FAT_ARROW BREAK expr
	| pattern FAT_ARROW CONTINUE
	| pattern FAT_ARROW CONTINUE non_empty_list_commas_no_trailing_expr_
	| pattern FAT_ARROW RETURN option_expr_
	| pattern FAT_ARROW RAISE expr
	| pattern FAT_ARROW ELLIPSIS
	| pattern FAT_ARROW qual_ident AUGMENTED_ASSIGNMENT expr
	| pattern FAT_ARROW simple_expr DOT_LIDENT AUGMENTED_ASSIGNMENT expr
	| pattern FAT_ARROW simple_expr DOT_INT AUGMENTED_ASSIGNMENT expr
	| pattern FAT_ARROW simple_expr LBRACKET expr RBRACKET AUGMENTED_ASSIGNMENT expr
	| pattern FAT_ARROW qual_ident EQUAL expr
	| pattern FAT_ARROW simple_expr DOT_LIDENT EQUAL expr
	| pattern FAT_ARROW simple_expr DOT_INT EQUAL expr
	| pattern FAT_ARROW simple_expr LBRACKET expr RBRACKET EQUAL expr
	| pattern FAT_ARROW expr
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW BREAK
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW BREAK expr
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW CONTINUE
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW CONTINUE non_empty_list_commas_no_trailing_expr_
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW RETURN option_expr_
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW RAISE expr
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW ELLIPSIS
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW qual_ident AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW simple_expr DOT_LIDENT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW simple_expr DOT_INT AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW simple_expr LBRACKET expr RBRACKET AUGMENTED_ASSIGNMENT expr
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW qual_ident EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW simple_expr DOT_LIDENT EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW simple_expr DOT_INT EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW simple_expr LBRACKET expr RBRACKET EQUAL expr
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI pattern FAT_ARROW expr
	;

non_empty_list_semi_rev_aux_enum_constructor_ :
	enum_constructor
	| non_empty_list_semi_rev_aux_enum_constructor_ SEMI enum_constructor
	;

non_empty_list_semi_rev_aux_local_type_decl_ :
	local_type_decl
	| non_empty_list_semi_rev_aux_local_type_decl_ SEMI local_type_decl
	;

non_empty_list_semi_rev_aux_record_decl_field_ :
	record_decl_field
	| non_empty_list_semi_rev_aux_record_decl_field_ SEMI record_decl_field
	;

non_empty_list_semi_rev_aux_statement_ :
	statement
	| non_empty_list_semi_rev_aux_statement_ SEMI statement
	;

non_empty_list_semi_rev_aux_structure_item_ :
	structure_item
	| non_empty_list_semi_rev_aux_structure_item_ SEMI structure_item
	;

non_empty_list_semi_rev_aux_trait_method_decl_ :
	trait_method_decl
	| non_empty_list_semi_rev_aux_trait_method_decl_ SEMI trait_method_decl
	;

non_empty_list_semis___anonymous_10_ :
	non_empty_list_semi_rev_aux___anonymous_10_
	| non_empty_list_semi_rev_aux___anonymous_10_ SEMI
	;

non_empty_list_semis___anonymous_16_ :
	non_empty_list_semi_rev_aux___anonymous_16_
	| non_empty_list_semi_rev_aux___anonymous_16_ SEMI
	;

non_empty_list_semis___anonymous_7_ :
	non_empty_list_semi_rev_aux___anonymous_7_
	| non_empty_list_semi_rev_aux___anonymous_7_ SEMI
	;

non_empty_list_semis___anonymous_8_ :
	non_empty_list_semi_rev_aux___anonymous_8_
	| non_empty_list_semi_rev_aux___anonymous_8_ SEMI
	;

non_empty_list_semis___anonymous_9_ :
	non_empty_list_semi_rev_aux___anonymous_9_
	| non_empty_list_semi_rev_aux___anonymous_9_ SEMI
	;

non_empty_list_semis_enum_constructor_ :
	non_empty_list_semi_rev_aux_enum_constructor_
	| non_empty_list_semi_rev_aux_enum_constructor_ SEMI
	;

non_empty_list_semis_local_type_decl_ :
	non_empty_list_semi_rev_aux_local_type_decl_
	| non_empty_list_semi_rev_aux_local_type_decl_ SEMI
	;

non_empty_list_semis_record_decl_field_ :
	non_empty_list_semi_rev_aux_record_decl_field_
	| non_empty_list_semi_rev_aux_record_decl_field_ SEMI
	;

non_empty_list_semis_structure_item_ :
	non_empty_list_semi_rev_aux_structure_item_
	| non_empty_list_semi_rev_aux_structure_item_ SEMI
	;

non_empty_list_semis_trait_method_decl_ :
	non_empty_list_semi_rev_aux_trait_method_decl_
	| non_empty_list_semi_rev_aux_trait_method_decl_ SEMI
	;

%%

%%

[ \t\r\n]+	skip()
"//".*  skip()

"pub"	PUB
"priv"	PRIV
"readonly"	READONLY
//"import"	IMPORT
"extern"	EXTERN
"break"	BREAK
"continue"	CONTINUE
"struct"	STRUCT
"enum"	ENUM
"trait"	TRAIT
"derive"	DERIVE
"impl"	IMPL
"with"	WITH
"raise"	RAISE
//"throw"	THROW
"try"	TRY
"catch"	CATCH
//"except"	EXCEPT
"typealias"	TYPEALIAS
"="	EQUAL

"("	LPAREN
")"	RPAREN

","	COMMA
"-"	MINUS
"?"	QUESTION
"!"	EXCLAMATION

"::"	COLONCOLON
":"	COLON

"["	LBRACKET
"+"	PLUS
"]"	RBRACKET

"_"	UNDERSCORE
"|"	BAR

"{"	LBRACE
"}"	RBRACE

"&&"	AMPERAMPER
"&"	AMPER
"^"	CARET
"||"	BARBAR

/* Keywords */

"as"	AS
"|>"	PIPE
"else"	ELSE
"fn"	FN
"if"	IF
"let"	LET
"const"	CONST
"match"	MATCH
"mut"	MUTABLE
"type"	TYPE
"=>"	FAT_ARROW
"->"	THIN_ARROW
"while"	WHILE
"return"	RETURN
".."	DOTDOT
"..="	RANGE_INCLUSIVE
"..<"	RANGE_EXCLUSIVE
"..."	ELLIPSIS
"test"	TEST
"loop"	LOOP
"guard"	GUARD

"for"	FOR
"in"	IN

"false"	FALSE
"true"	TRUE
";"	SEMI

AUGMENTED_ASSIGNMENT	AUGMENTED_ASSIGNMENT
BYTE	BYTE
BYTES	BYTES
CHAR	CHAR
DOT_INT	DOT_INT
DOT_LIDENT	DOT_LIDENT
DOT_UIDENT	DOT_UIDENT
">"|"<"|"=="|"!="|"<="|">="	INFIX1
"<<"|">>"	INFIX2
"*"|"/"|"%"	INFIX3
INFIX4	INFIX4
INTERP	INTERP
LABEL	LABEL
MULTILINE_INTERP	MULTILINE_INTERP
MULTILINE_STRING	MULTILINE_STRING
PACKAGE_NAME	PACKAGE_NAME
POST_LABEL	POST_LABEL

[0-9]+	INT
[0-9]+"."[0-9]+	FLOAT

\"(\\.|[^"\r\n\\])*\"	STRING
//"#".*   STRING

UIDENT  UIDENT
[A-Za-z_][A-Za-z0-9_]*	LIDENT

%%
