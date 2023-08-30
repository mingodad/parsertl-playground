//From: https://github.com/lfortran/lfortran/blob/main/src/lfortran/parser/parser.yy

/*Tokens*/
%token END_OF_FILE
%token TK_NEWLINE
%token TK_NAME
%token TK_DEF_OP
%token TK_INTEGER
%token TK_LABEL
%token TK_REAL
%token TK_BOZ_CONSTANT
%token TK_PLUS
%token TK_MINUS
%token TK_STAR
%token TK_SLASH
%token TK_COLON
%token TK_SEMICOLON
%token TK_COMMA
%token TK_EQUAL
//%token TK_LPAREN
//%token TK_RPAREN
%token TK_LBRACKET
//%token TK_RBRACKET
//%token TK_RBRACKET_OLD
%token TK_PERCENT
//%token TK_VBAR
%token TK_STRING
%token TK_COMMENT
%token TK_EOLCOMMENT
%token TK_DBL_DOT
%token TK_DBL_COLON
%token TK_POW
%token TK_CONCAT
%token TK_ARROW
%token TK_EQ
%token TK_NE
%token TK_LT
%token TK_LE
%token TK_GT
%token TK_GE
%token TK_NOT
%token TK_AND
%token TK_OR
%token TK_XOR
%token TK_EQV
%token TK_NEQV
%token TK_TRUE
%token TK_FALSE
%token TK_FORMAT
%token KW_ABSTRACT
%token KW_ALL
%token KW_ALLOCATABLE
%token KW_ALLOCATE
%token KW_ASSIGN
%token KW_ASSIGNMENT
%token KW_ASSOCIATE
%token KW_ASYNCHRONOUS
%token KW_BACKSPACE
%token KW_BIND
%token KW_BLOCK
%token KW_CALL
%token KW_CASE
%token KW_CHANGE
%token KW_CHANGE_TEAM
%token KW_CHARACTER
%token KW_CLASS
%token KW_CLOSE
%token KW_CODIMENSION
%token KW_COMMON
%token KW_COMPLEX
%token KW_CONCURRENT
%token KW_CONTAINS
%token KW_CONTIGUOUS
%token KW_CONTINUE
%token KW_CRITICAL
%token KW_CYCLE
%token KW_DATA
%token KW_DEALLOCATE
%token KW_DEFAULT
%token KW_DEFERRED
%token KW_DIMENSION
%token KW_DO
%token KW_DOWHILE
%token KW_DOUBLE
%token KW_DOUBLE_PRECISION
%token KW_DOUBLE_COMPLEX
%token KW_ELEMENTAL
%token KW_ELSE
%token KW_ELSEIF
%token KW_ELSEWHERE
%token KW_END
%token KW_END_PROGRAM
%token KW_ENDPROGRAM
%token KW_END_MODULE
%token KW_ENDMODULE
%token KW_END_SUBMODULE
%token KW_ENDSUBMODULE
%token KW_END_BLOCK
%token KW_ENDBLOCK
%token KW_END_BLOCK_DATA
%token KW_ENDBLOCKDATA
%token KW_END_SUBROUTINE
%token KW_ENDSUBROUTINE
%token KW_END_FUNCTION
%token KW_ENDFUNCTION
%token KW_END_PROCEDURE
%token KW_ENDPROCEDURE
%token KW_END_ENUM
%token KW_ENDENUM
%token KW_END_SELECT
%token KW_ENDSELECT
%token KW_END_IF
%token KW_ENDIF
%token KW_END_INTERFACE
%token KW_ENDINTERFACE
%token KW_END_TYPE
%token KW_ENDTYPE
%token KW_END_ASSOCIATE
%token KW_ENDASSOCIATE
%token KW_END_FORALL
%token KW_ENDFORALL
%token KW_END_DO
%token KW_ENDDO
%token KW_END_WHERE
%token KW_ENDWHERE
%token KW_END_CRITICAL
%token KW_ENDCRITICAL
%token KW_END_FILE
%token KW_ENDFILE
%token KW_END_TEAM
%token KW_ENDTEAM
%token KW_ENTRY
%token KW_ENUM
%token KW_ENUMERATOR
%token KW_EQUIVALENCE
%token KW_ERRMSG
%token KW_ERROR
%token KW_EVENT
%token KW_EXIT
%token KW_EXTENDS
%token KW_EXTERNAL
%token KW_FILE
%token KW_FINAL
%token KW_FLUSH
%token KW_FORALL
%token KW_FORMATTED
%token KW_FORM
%token KW_FORM_TEAM
%token KW_FUNCTION
%token KW_GENERIC
%token KW_GO
%token KW_GOTO
%token KW_IF
%token KW_IMAGES
%token KW_IMPLICIT
%token KW_IMPORT
%token KW_IMPURE
%token KW_IN
%token KW_INCLUDE
%token KW_INOUT
%token KW_IN_OUT
%token KW_INQUIRE
%token KW_INSTANTIATE
%token KW_INTEGER
%token KW_INTENT
%token KW_INTERFACE
%token KW_INTRINSIC
%token KW_IS
%token KW_KIND
%token KW_LEN
%token KW_LOCAL
%token KW_LOCAL_INIT
%token KW_LOGICAL
%token KW_MEMORY
%token KW_MODULE
%token KW_MOLD
//%token KW_NAME
%token KW_NAMELIST
%token KW_NEW_INDEX
%token KW_NOPASS
%token KW_NON_INTRINSIC
%token KW_NON_OVERRIDABLE
%token KW_NON_RECURSIVE
%token KW_NONE
%token KW_NULLIFY
%token KW_ONLY
%token KW_OPEN
%token KW_OPERATOR
%token KW_OPTIONAL
%token KW_OUT
%token KW_PARAMETER
%token KW_PASS
%token KW_POINTER
%token KW_POST
%token KW_PRECISION
%token KW_PRINT
%token KW_PRIVATE
%token KW_PROCEDURE
%token KW_PROGRAM
%token KW_PROTECTED
%token KW_PUBLIC
%token KW_PURE
%token KW_QUIET
%token KW_RANK
%token KW_READ
%token KW_REAL
%token KW_RECURSIVE
%token KW_REDUCE
%token KW_RESULT
%token KW_RETURN
%token KW_REWIND
%token KW_SAVE
%token KW_SELECT
%token KW_SELECT_CASE
%token KW_SELECT_RANK
%token KW_SELECT_TYPE
%token KW_SEQUENCE
%token KW_SHARED
%token KW_SOURCE
%token KW_STAT
%token KW_STOP
%token KW_SUBMODULE
%token KW_SUBROUTINE
%token KW_SYNC
%token KW_SYNC_ALL
%token KW_SYNC_IMAGES
%token KW_SYNC_MEMORY
%token KW_SYNC_TEAM
%token KW_TARGET
%token KW_TEAM
%token KW_TEAM_NUMBER
%token KW_REQUIREMENT
%token KW_REQUIRES
%token KW_TEMPLATE
%token KW_THEN
%token KW_TO
%token KW_TYPE
%token KW_UNFORMATTED
%token KW_USE
%token KW_VALUE
%token KW_VOLATILE
%token KW_WAIT
%token KW_WHERE
%token KW_WHILE
%token KW_WRITE
%token UMINUS

%left /*1*/ TK_DEF_OP
%left /*2*/ TK_EQV TK_NEQV
%left /*3*/ TK_OR TK_XOR
%left /*4*/ TK_AND
%precedence /*5*/ TK_NOT
%left /*6*/ TK_EQ TK_NE TK_LT TK_LE TK_GT TK_GE
%left /*7*/ TK_CONCAT
%left /*8*/ TK_PLUS TK_MINUS
%left /*9*/ TK_STAR TK_SLASH
%precedence /*10*/ UMINUS
%right /*11*/ TK_POW

%start units

%%

units :
	END_OF_FILE
	| units script_unit
	| script_unit
	| sep
	;

script_unit :
	module
	| submodule
	| block_data
	| program
	| subroutine
	| procedure
	| function
	| use_statement
	| implicit_statement
	| var_decl
	| statement
	| expr sep
	| KW_END_PROGRAM sep
	;

module :
	KW_MODULE id sep use_statement_star implicit_statement_star decl_star contains_block_opt end_module sep
	;

submodule :
	KW_SUBMODULE "(" id ")" id sep use_statement_star implicit_statement_star decl_star contains_block_opt end_submodule sep
	| KW_SUBMODULE "(" id TK_COLON id ")" id sep use_statement_star implicit_statement_star decl_star contains_block_opt end_submodule sep
	;

block_data :
	KW_BLOCK KW_DATA sep use_statement_star implicit_statement_star decl_statements end_blockdata sep
	| KW_BLOCK KW_DATA id sep use_statement_star implicit_statement_star decl_statements end_blockdata sep
	;

interface_decl :
	interface_stmt sep interface_body endinterface sep
	;

interface_stmt :
	KW_INTERFACE
	| KW_INTERFACE id
	| KW_INTERFACE KW_ASSIGNMENT "(" TK_EQUAL ")"
	| KW_INTERFACE KW_OPERATOR "(" operator_type ")"
	| KW_INTERFACE KW_OPERATOR "(" "/)"
	| KW_INTERFACE KW_OPERATOR "(" TK_DEF_OP /*1L*/ ")"
	| KW_ABSTRACT KW_INTERFACE
	| KW_INTERFACE KW_WRITE "(" id ")"
	| KW_INTERFACE KW_READ "(" id ")"
	;

endinterface :
	endinterface0
	| endinterface0 id
	| endinterface0 KW_ASSIGNMENT "(" TK_EQUAL ")"
	| endinterface0 KW_OPERATOR "(" operator_type ")"
	| endinterface0 KW_OPERATOR "(" "/)"
	| endinterface0 KW_OPERATOR "(" TK_DEF_OP /*1L*/ ")"
	;

endinterface0 :
	KW_END_INTERFACE
	| KW_ENDINTERFACE
	;

interface_body :
	interface_body interface_item
	| /*empty*/
	;

interface_item :
	fn_mod_plus KW_PROCEDURE id_list sep
	| fn_mod_plus KW_PROCEDURE TK_DBL_COLON id_list sep
	| KW_PROCEDURE id_list sep
	| KW_PROCEDURE TK_DBL_COLON id_list sep
	| subroutine
	| function
	;

enum_decl :
	KW_ENUM enum_var_modifiers sep var_decl_star endenum sep
	;

endenum :
	KW_END_ENUM
	| KW_ENDENUM
	;

enum_var_modifiers :
	/*empty*/
	| var_modifier_list
	;

derived_type_decl :
	KW_TYPE TK_COMMA KW_DEFERRED TK_DBL_COLON id sep
	| KW_TYPE var_modifiers id sep var_decl_star derived_type_contains_opt end_type sep
	| KW_TYPE var_modifiers id "(" id_list ")" sep var_decl_star derived_type_contains_opt end_type sep
	;

template_decl :
	KW_TEMPLATE id "(" id_list ")" sep temp_decl_star contains_block_opt KW_END KW_TEMPLATE sep
	;

requirement_decl :
	KW_REQUIREMENT id "(" id_list ")" sep temp_decl_star sub_or_func_star KW_END KW_REQUIREMENT sep
	;

requires_decl :
	KW_REQUIRES id "(" id_list ")" sep
	;

instantiate :
	KW_INSTANTIATE id "(" use_symbol_list ")" sep
	| KW_INSTANTIATE id "(" use_symbol_list ")" TK_COMMA KW_ONLY TK_COLON use_symbol_list sep
	;

end_type :
	KW_END_TYPE id_opt
	| KW_ENDTYPE id_opt
	;

derived_type_contains_opt :
	KW_CONTAINS sep procedure_list
	| KW_CONTAINS sep
	| /*empty*/
	;

procedure_list :
	procedure_list procedure_decl
	| procedure_decl
	;

procedure_decl :
	KW_PROCEDURE proc_modifiers use_symbol_list sep
	| KW_PROCEDURE "(" id ")" proc_modifiers use_symbol_list sep
	| KW_GENERIC access_spec_list KW_OPERATOR "(" operator_type ")" TK_ARROW id_list sep
	| KW_GENERIC access_spec_list KW_OPERATOR "(" "/)" TK_ARROW id_list sep
	| KW_GENERIC access_spec_list KW_OPERATOR "(" TK_DEF_OP /*1L*/ ")" TK_ARROW id_list sep
	| KW_GENERIC access_spec_list KW_ASSIGNMENT "(" TK_EQUAL ")" TK_ARROW id_list sep
	| KW_GENERIC access_spec_list id TK_ARROW id_list sep
	| KW_GENERIC access_spec_list KW_WRITE "(" id ")" TK_ARROW id_list sep
	| KW_GENERIC access_spec_list KW_READ "(" id ")" TK_ARROW id_list sep
	| KW_FINAL TK_DBL_COLON id sep
	| KW_PRIVATE sep
	;

access_spec_list :
	TK_DBL_COLON
	| access_spec TK_DBL_COLON
	;

access_spec :
	TK_COMMA KW_PRIVATE
	| TK_COMMA KW_PUBLIC
	;

operator_type :
	TK_PLUS /*8L*/
	| TK_MINUS /*8L*/
	| TK_STAR /*9L*/
	| TK_SLASH /*9L*/
	| TK_POW /*11R*/
	| TK_EQ /*6L*/
	| TK_NE /*6L*/
	| TK_GT /*6L*/
	| TK_GE /*6L*/
	| TK_LT /*6L*/
	| TK_LE /*6L*/
	| TK_CONCAT /*7L*/
	| TK_NOT /*5P*/
	| TK_AND /*4L*/
	| TK_OR /*3L*/
	| TK_XOR /*3L*/
	| TK_EQV /*2L*/
	| TK_NEQV /*2L*/
	;

proc_modifiers :
	/*empty*/
	| TK_DBL_COLON
	| proc_modifier_list TK_DBL_COLON
	;

proc_modifier_list :
	proc_modifier_list TK_COMMA proc_modifier
	| TK_COMMA proc_modifier
	;

proc_modifier :
	KW_PRIVATE
	| KW_PUBLIC
	| KW_PASS
	| KW_PASS "(" id ")"
	| KW_NOPASS
	| KW_DEFERRED
	| KW_NON_OVERRIDABLE
	;

program :
	KW_PROGRAM id sep use_statement_star implicit_statement_star decl_statements contains_block_opt end_program sep
	;

end_program :
	KW_END_PROGRAM id_opt
	| KW_ENDPROGRAM id_opt
	| KW_END
	;

end_module :
	KW_END_MODULE id_opt
	| KW_ENDMODULE id_opt
	| KW_END
	;

end_submodule :
	KW_END_SUBMODULE id_opt
	| KW_ENDSUBMODULE id_opt
	| KW_END
	;

end_blockdata :
	KW_END_BLOCK_DATA id_opt
	| KW_ENDBLOCKDATA id_opt
	| KW_END
	;

end_subroutine :
	KW_END_SUBROUTINE id_opt
	| KW_ENDSUBROUTINE id_opt
	| KW_END
	;

end_procedure :
	KW_END_PROCEDURE id_opt
	| KW_ENDPROCEDURE id_opt
	| KW_END
	;

end_function :
	KW_END_FUNCTION id_opt
	| KW_ENDFUNCTION id_opt
	| KW_END
	;

end_associate :
	KW_END_ASSOCIATE
	| KW_ENDASSOCIATE
	;

end_block :
	KW_END_BLOCK
	| KW_ENDBLOCK
	;

end_select :
	KW_END_SELECT
	| KW_ENDSELECT
	;

end_critical :
	KW_END_CRITICAL
	| KW_ENDCRITICAL
	;

end_team :
	KW_END_TEAM
	| KW_ENDTEAM
	;

subroutine :
	KW_SUBROUTINE id sub_args bind_opt sep use_statement_star import_statement_star implicit_statement_star decl_statements contains_block_opt end_subroutine sep
	| fn_mod_plus KW_SUBROUTINE id sub_args bind_opt sep use_statement_star import_statement_star implicit_statement_star decl_statements contains_block_opt end_subroutine sep
	;

procedure :
	fn_mod_plus KW_PROCEDURE id sub_args sep use_statement_star import_statement_star implicit_statement_star decl_statements contains_block_opt end_procedure sep
	;

function :
	KW_FUNCTION id "(" id_list_opt ")" sep use_statement_star import_statement_star implicit_statement_star decl_statements contains_block_opt end_function sep
	| KW_FUNCTION id "(" id_list_opt ")" bind result_opt sep use_statement_star import_statement_star implicit_statement_star decl_statements contains_block_opt end_function sep
	| KW_FUNCTION id "(" id_list_opt ")" result bind_opt sep use_statement_star import_statement_star implicit_statement_star decl_statements contains_block_opt end_function sep
	| fn_mod_plus KW_FUNCTION id "(" id_list_opt ")" sep use_statement_star import_statement_star implicit_statement_star decl_statements contains_block_opt end_function sep
	| fn_mod_plus KW_FUNCTION id "(" id_list_opt ")" bind result_opt sep use_statement_star import_statement_star implicit_statement_star decl_statements contains_block_opt end_function sep
	| fn_mod_plus KW_FUNCTION id "(" id_list_opt ")" result bind_opt sep use_statement_star import_statement_star implicit_statement_star decl_statements contains_block_opt end_function sep
	;

fn_mod_plus :
	fn_mod_plus fn_mod
	| fn_mod
	;

fn_mod :
	var_type
	| KW_ELEMENTAL
	| KW_IMPURE
	| KW_MODULE
	| KW_PURE
	| KW_RECURSIVE
	;

temp_decl_star :
	temp_decl_star temp_decl
	| /*empty*/
	;

temp_decl :
	var_decl
	| interface_decl
	| derived_type_decl
	| requires_decl
	| instantiate
	;

decl_star :
	decl_star decl
	| /*empty*/
	;

decl :
	var_decl
	| interface_decl
	| derived_type_decl
	| template_decl
	| requirement_decl
	| enum_decl
	;

contains_block_opt :
	KW_CONTAINS sep sub_or_func_plus
	| KW_CONTAINS sep
	| /*empty*/
	;

sub_or_func_star :
	sub_or_func_plus
	| /*empty*/
	;

sub_or_func_plus :
	sub_or_func_plus sub_or_func
	| sub_or_func
	;

sub_or_func :
	subroutine
	| function
	| procedure
	;

sub_args :
	"(" id_or_star_list ")"
	| /*empty*/
	;

id_or_star_list :
	id_or_star_list TK_COMMA id_or_star
	| id_or_star
	| /*empty*/
	;

id_or_star :
	id
	| TK_STAR /*9L*/
	;

bind_opt :
	bind
	| /*empty*/
	;

bind :
	KW_BIND "(" write_arg_list ")"
	;

result_opt :
	result
	| /*empty*/
	;

result :
	KW_RESULT "(" id ")"
	;

implicit_statement_star :
	implicit_statement_star implicit_statement
	| /*empty*/
	;

implicit_statement :
	KW_IMPLICIT KW_NONE sep
	| KW_IMPLICIT KW_NONE "(" implicit_none_spec_list ")" sep
	| KW_IMPLICIT KW_INTEGER "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_INTEGER TK_STAR /*9L*/ TK_INTEGER "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_INTEGER "(" TK_INTEGER ")" "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_INTEGER "(" letter_spec_list ")" "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_CHARACTER "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_CHARACTER TK_STAR /*9L*/ TK_INTEGER "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_CHARACTER "(" TK_INTEGER ")" "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_CHARACTER "(" letter_spec_list ")" "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_REAL "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_REAL TK_STAR /*9L*/ TK_INTEGER "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_REAL "(" TK_INTEGER ")" "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_REAL "(" letter_spec_list ")" "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_COMPLEX "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_COMPLEX TK_STAR /*9L*/ TK_INTEGER "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_COMPLEX "(" TK_INTEGER ")" "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_COMPLEX "(" letter_spec_list ")" "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_LOGICAL "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_LOGICAL TK_STAR /*9L*/ TK_INTEGER "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_LOGICAL "(" TK_INTEGER ")" "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_LOGICAL "(" letter_spec_list ")" "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_DOUBLE KW_PRECISION "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_TYPE "(" id ")" "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_PROCEDURE "(" id ")" "(" letter_spec_list ")" sep
	| KW_IMPLICIT KW_CLASS "(" id ")" "(" letter_spec_list ")" sep
	;

implicit_none_spec_list :
	implicit_none_spec_list TK_COMMA implicit_none_spec
	| implicit_none_spec
	;

implicit_none_spec :
	KW_EXTERNAL
	| KW_TYPE
	;

letter_spec_list :
	letter_spec_list TK_COMMA letter_spec
	| letter_spec
	;

letter_spec :
	id
	| id TK_MINUS /*8L*/ id
	;

use_statement_star :
	use_statement_star use_statement
	| /*empty*/
	;

use_statement :
	use_statement1 sep
	;

use_statement1 :
	KW_USE use_modifiers id
	| KW_USE use_modifiers id TK_COMMA KW_ONLY TK_COLON use_symbol_list
	| KW_USE use_modifiers id TK_COMMA KW_ONLY TK_COLON
	| KW_USE use_modifiers id TK_COMMA use_symbol_list
	;

import_statement_star :
	import_statement_star import_statement
	| /*empty*/
	;

import_statement :
	KW_IMPORT sep
	| KW_IMPORT id_list sep
	| KW_IMPORT TK_DBL_COLON id_list sep
	| KW_IMPORT TK_COMMA KW_ONLY TK_COLON id_list sep
	| KW_IMPORT TK_COMMA KW_NONE sep
	| KW_IMPORT TK_COMMA KW_ALL sep
	;

use_symbol_list :
	use_symbol_list TK_COMMA use_symbol
	| use_symbol
	;

use_symbol :
	id
	| id TK_ARROW id
	| KW_ASSIGNMENT "(" TK_EQUAL ")"
	| KW_OPERATOR "(" operator_type ")"
	| KW_OPERATOR "(" "/)"
	| KW_OPERATOR "(" TK_DEF_OP /*1L*/ ")"
	| KW_OPERATOR "(" TK_DEF_OP /*1L*/ ")" TK_ARROW KW_OPERATOR "(" TK_DEF_OP /*1L*/ ")"
	| KW_WRITE "(" id ")"
	| KW_READ "(" id ")"
	;

use_modifiers :
	/*empty*/
	| TK_DBL_COLON
	| use_modifier_list TK_DBL_COLON
	;

use_modifier_list :
	use_modifier_list TK_COMMA use_modifier
	| TK_COMMA use_modifier
	;

use_modifier :
	KW_INTRINSIC
	| KW_NON_INTRINSIC
	;

var_decl_star :
	var_decl_star var_decl
	| /*empty*/
	;

var_decl :
	var_type var_modifiers var_sym_decl_list sep
	| var_modifier sep
	| var_modifier var_sym_decl_list sep
	| var_modifier TK_DBL_COLON var_sym_decl_list sep
	| KW_PARAMETER "(" named_constant_def_list ")" sep
	| KW_NAMELIST TK_SLASH /*9L*/ id TK_SLASH /*9L*/ id_list sep
	| KW_COMMON common_block_list sep
	| KW_EQUIVALENCE equivalence_set_list sep
	;

equivalence_set_list :
	equivalence_set_list TK_COMMA equivalence_set
	| equivalence_set
	;

equivalence_set :
	"(" expr_list ")"
	;

named_constant_def_list :
	named_constant_def_list TK_COMMA named_constant_def
	| named_constant_def
	;

named_constant_def :
	id TK_EQUAL expr
	;

common_block_list :
	common_block_list TK_COMMA common_block
	| common_block
	;

common_block :
	TK_SLASH /*9L*/ id TK_SLASH /*9L*/ expr
	| expr
	;

data_set_list :
	data_set_list TK_COMMA data_set
	| data_set
	;

data_set :
	data_object_list TK_SLASH /*9L*/ data_stmt_value_list TK_SLASH /*9L*/
	;

data_object_list :
	data_object_list TK_COMMA data_object
	| data_object
	;

data_object :
	id
	| struct_member_star id
	| id "(" fnarray_arg_list_opt ")"
	| "(" data_object_list TK_COMMA id TK_EQUAL expr TK_COMMA expr ")"
	| "(" data_object_list TK_COMMA integer_type id TK_EQUAL expr TK_COMMA expr ")"
	| "(" data_object_list TK_COMMA id TK_EQUAL expr TK_COMMA expr TK_COMMA expr ")"
	| "(" data_object_list TK_COMMA integer_type id TK_EQUAL expr TK_COMMA expr TK_COMMA expr ")"
	;

data_stmt_value_list :
	data_stmt_value_list TK_COMMA data_stmt_constant
	| data_stmt_value_list TK_COMMA data_stmt_repeat TK_STAR /*9L*/ data_stmt_constant
	| data_stmt_constant
	| data_stmt_repeat TK_STAR /*9L*/ data_stmt_constant
	;

data_stmt_repeat :
	id
	| TK_INTEGER
	| TK_REAL
	| TK_STRING
	| TK_BOZ_CONSTANT
	| TK_TRUE
	| TK_FALSE
	;

data_stmt_constant :
	id
	| TK_INTEGER
	| TK_REAL
	| TK_STRING
	| TK_BOZ_CONSTANT
	| TK_TRUE
	| TK_FALSE
	| TK_MINUS /*8L*/ expr %prec UMINUS /*10P*/
	;

integer_type :
	KW_INTEGER "(" kind_arg_list ")" TK_DBL_COLON
	;

kind_arg_list :
	kind_arg_list TK_COMMA kind_arg2
	| kind_arg2
	;

kind_arg2 :
	expr
	| TK_STAR /*9L*/
	| TK_COLON
	| id_skw TK_EQUAL expr
	| id_skw TK_EQUAL TK_STAR /*9L*/
	| id_skw TK_EQUAL TK_COLON
	;

var_modifiers :
	/*empty*/
	| TK_DBL_COLON
	| var_modifier_list TK_DBL_COLON
	;

var_modifier_list :
	var_modifier_list TK_COMMA var_modifier
	| TK_COMMA var_modifier
	;

var_modifier :
	KW_PARAMETER
	| KW_DIMENSION "(" array_comp_decl_list ")"
	| KW_DIMENSION
	| KW_CODIMENSION TK_LBRACKET coarray_comp_decl_list "]"
	| KW_ALLOCATABLE
	| KW_ASYNCHRONOUS
	| KW_POINTER
	| KW_TARGET
	| KW_OPTIONAL
	| KW_PROTECTED
	| KW_SAVE
	| KW_SEQUENCE
	| KW_CONTIGUOUS
	| KW_NOPASS
	| KW_PRIVATE
	| KW_PUBLIC
	| KW_ABSTRACT
	| KW_ENUMERATOR
	| KW_EXTERNAL
	| KW_INTENT "(" KW_IN ")"
	| KW_INTENT "(" KW_OUT ")"
	| KW_INTENT "(" inout ")"
	| KW_INTRINSIC
	| KW_VALUE
	| KW_VOLATILE
	| KW_EXTENDS "(" id ")"
	| bind
	| KW_KIND
	| KW_LEN
	;

var_type :
	KW_INTEGER
	| KW_INTEGER "(" kind_arg_list ")"
	| KW_INTEGER TK_STAR /*9L*/ TK_INTEGER
	| KW_CHARACTER
	| KW_CHARACTER "(" kind_arg_list ")"
	| KW_CHARACTER TK_STAR /*9L*/ TK_INTEGER
	| KW_CHARACTER TK_STAR /*9L*/ "(" TK_STAR /*9L*/ ")"
	| KW_REAL
	| KW_REAL "(" kind_arg_list ")"
	| KW_REAL TK_STAR /*9L*/ TK_INTEGER
	| KW_COMPLEX
	| KW_COMPLEX "(" kind_arg_list ")"
	| KW_COMPLEX TK_STAR /*9L*/ TK_INTEGER
	| KW_LOGICAL
	| KW_LOGICAL "(" kind_arg_list ")"
	| KW_LOGICAL TK_STAR /*9L*/ TK_INTEGER
	| KW_DOUBLE KW_PRECISION
	| KW_DOUBLE_PRECISION
	| KW_DOUBLE KW_COMPLEX
	| KW_DOUBLE_COMPLEX
	| KW_TYPE "(" id ")"
	| KW_TYPE "(" KW_INTEGER "(" kind_arg_list ")" ")"
	| KW_TYPE "(" KW_REAL "(" kind_arg_list ")" ")"
	| KW_TYPE "(" KW_COMPLEX "(" kind_arg_list ")" ")"
	| KW_TYPE "(" KW_LOGICAL "(" kind_arg_list ")" ")"
	| KW_TYPE "(" KW_CHARACTER "(" kind_arg_list ")" ")"
	| KW_TYPE "(" TK_STAR /*9L*/ ")"
	| KW_PROCEDURE "(" id ")"
	| KW_CLASS "(" id ")"
	| KW_CLASS "(" TK_STAR /*9L*/ ")"
	;

var_sym_decl_list :
	var_sym_decl_list TK_COMMA var_sym_decl
	| var_sym_decl
	;

var_sym_decl :
	id
	| TK_SLASH /*9L*/ id TK_SLASH /*9L*/
	| id TK_EQUAL expr
	| id TK_ARROW expr
	| id TK_STAR /*9L*/ expr
	| id TK_STAR /*9L*/ "(" TK_STAR /*9L*/ ")"
	| id "(" array_comp_decl_list ")"
	| id "(" array_comp_decl_list ")" TK_STAR /*9L*/ TK_INTEGER
	| id "(" array_comp_decl_list ")" TK_EQUAL expr
	| id "(" array_comp_decl_list ")" TK_ARROW expr
	| id TK_LBRACKET coarray_comp_decl_list "]"
	| id "(" array_comp_decl_list ")" TK_LBRACKET coarray_comp_decl_list "]"
	| decl_spec
	;

decl_spec :
	KW_OPERATOR "(" operator_type ")"
	| KW_OPERATOR "(" "/)"
	| KW_OPERATOR "(" TK_DEF_OP /*1L*/ ")"
	| KW_ASSIGNMENT "(" TK_EQUAL ")"
	;

array_comp_decl_list :
	array_comp_decl_list TK_COMMA array_comp_decl
	| array_comp_decl
	;

array_comp_decl :
	expr
	| expr TK_COLON expr
	| expr TK_COLON
	| TK_COLON expr
	| TK_COLON
	| TK_STAR /*9L*/
	| expr TK_COLON TK_STAR /*9L*/
	| TK_DBL_DOT
	;

coarray_comp_decl_list :
	coarray_comp_decl_list TK_COMMA coarray_comp_decl
	| coarray_comp_decl
	;

coarray_comp_decl :
	expr
	| expr TK_COLON expr
	| expr TK_COLON
	| TK_COLON expr
	| TK_COLON
	| TK_STAR /*9L*/
	| expr TK_COLON TK_STAR /*9L*/
	;

statements :
	statements statement
	| /*empty*/
	;

sep :
	sep sep_one
	| sep_one
	;

sep_one :
	TK_NEWLINE
	| TK_COMMENT
	| TK_EOLCOMMENT
	| TK_SEMICOLON
	;

decl_statements :
	decl_statements decl_statement
	| /*empty*/
	;

decl_statement :
	var_decl
	| interface_decl
	| derived_type_decl
	| template_decl
	| enum_decl
	| statement
	| instantiate
	;

statement :
	statement1 sep
	| TK_LABEL statement1 sep
	;

statement1 :
	single_line_statement
	| multi_line_statement
	;

single_line_statement :
	allocate_statement
	| assign_statement
	| assignment_statement
	| associate_statement
	| close_statement
	| continue_statement
	| cycle_statement
	| deallocate_statement
	| entry_statement
	| error_stop_statement
	| event_post_statement
	| event_wait_statement
	| exit_statement
	| flush_statement
	| forall_statement_single
	| format_statement
	| data_statement
	| form_team_statement
	| goto_statement
	| if_statement_single
	| include_statement
	| inquire_statement
	| nullify_statement
	| open_statement
	| print_statement
	| read_statement
	| return_statement
	| rewind_statement
	| backspace_statement
	| endfile_statement
	| stop_statement
	| subroutine_call
	| sync_all_statement
	| sync_images_statement
	| sync_memory_statement
	| sync_team_statement
	| where_statement_single
	| write_statement
	;

multi_line_statement :
	multi_line_statement0
	| id TK_COLON multi_line_statement0 id
	;

multi_line_statement0 :
	associate_block
	| block_statement
	| change_team_statement
	| critical_statement
	| do_statement
	| forall_statement
	| if_statement
	| select_statement
	| select_type_statement
	| select_rank_statement
	| where_statement
	| while_statement
	;

assign_statement :
	KW_ASSIGN TK_INTEGER KW_TO id
	;

assignment_statement :
	expr TK_EQUAL expr
	;

goto_statement :
	goto TK_INTEGER
	| goto "(" expr_list ")" expr
	| goto "(" expr_list ")" TK_COMMA expr
	| goto id
	| goto id "(" expr_list ")"
	| goto id TK_COMMA "(" expr_list ")"
	;

goto :
	KW_GO KW_TO
	| KW_GOTO
	;

associate_statement :
	expr TK_ARROW expr
	;

associate_block :
	KW_ASSOCIATE "(" var_sym_decl_list ")" sep statements end_associate
	;

block_statement :
	KW_BLOCK sep use_statement_star import_statement_star decl_statements end_block
	;

allocate_statement :
	KW_ALLOCATE "(" fnarray_arg_list_opt ")"
	;

deallocate_statement :
	KW_DEALLOCATE "(" fnarray_arg_list_opt ")"
	;

subroutine_call :
	KW_CALL id "(" fnarray_arg_list_opt ")"
	| KW_CALL struct_member_star id "(" fnarray_arg_list_opt ")"
	| KW_CALL id
	| KW_CALL struct_member_star id
	;

print_statement :
	KW_PRINT format
	| KW_PRINT format TK_COMMA
	| KW_PRINT format TK_COMMA expr_list
	;

format :
	expr
	| TK_STAR /*9L*/
	;

open_statement :
	KW_OPEN "(" write_arg_list ")"
	;

close_statement :
	KW_CLOSE "(" write_arg_list ")"
	;

write_arg_list :
	write_arg_list TK_COMMA write_arg2
	| write_arg2
	;

write_arg2 :
	write_arg
	| id TK_EQUAL write_arg
	;

write_arg :
	expr
	| TK_STAR /*9L*/
	;

write_statement :
	KW_WRITE "(" write_arg_list ")" expr_list
	| KW_WRITE "(" write_arg_list ")" TK_COMMA expr_list
	| KW_WRITE "(" write_arg_list ")"
	;

read_statement :
	KW_READ "(" write_arg_list ")" expr_list
	| KW_READ "(" write_arg_list ")" TK_COMMA expr_list
	| KW_READ "(" write_arg_list ")"
	| KW_READ TK_INTEGER TK_COMMA expr_list
	| KW_READ TK_STAR /*9L*/ TK_COMMA expr_list
	| KW_READ TK_INTEGER
	;

nullify_statement :
	KW_NULLIFY "(" write_arg_list ")"
	;

include_statement :
	KW_INCLUDE TK_STRING
	;

inquire_statement :
	KW_INQUIRE "(" write_arg_list ")" expr_list
	| KW_INQUIRE "(" write_arg_list ")"
	;

rewind_statement :
	KW_REWIND "(" write_arg_list ")"
	| KW_REWIND id
	| KW_REWIND TK_INTEGER
	| KW_REWIND id "(" fnarray_arg_list_opt ")"
	;

backspace_statement :
	KW_BACKSPACE "(" write_arg_list ")"
	| KW_BACKSPACE id
	| KW_BACKSPACE TK_INTEGER
	| KW_BACKSPACE id "(" fnarray_arg_list_opt ")"
	;

flush_statement :
	KW_FLUSH "(" write_arg_list ")"
	| KW_FLUSH TK_INTEGER
	;

endfile_statement :
	end_file "(" write_arg_list ")"
	| end_file id
	| end_file TK_INTEGER
	;

end_file :
	KW_END_FILE
	| KW_ENDFILE
	;

if_statement :
	if_block endif
	;

if_statement_single :
	KW_IF "(" expr ")" single_line_statement
	| KW_IF "(" expr ")" TK_INTEGER TK_COMMA TK_INTEGER TK_COMMA TK_INTEGER
	;

if_block :
	KW_IF "(" expr ")" KW_THEN id_opt sep statements
	| KW_IF "(" expr ")" KW_THEN id_opt sep statements KW_ELSE id_opt sep statements
	| KW_IF "(" expr ")" KW_THEN id_opt sep statements KW_ELSE if_block
	| KW_IF "(" expr ")" KW_THEN id_opt sep statements elseif_block
	;

elseif_block :
	KW_ELSEIF "(" expr ")" KW_THEN id_opt sep statements
	| KW_ELSEIF "(" expr ")" KW_THEN id_opt sep statements KW_ELSE id_opt sep statements
	| KW_ELSEIF "(" expr ")" KW_THEN id_opt sep statements KW_ELSE if_block
	| KW_ELSEIF "(" expr ")" KW_THEN id_opt sep statements elseif_block
	;

where_statement :
	where_block endwhere
	;

where_statement_single :
	KW_WHERE "(" expr ")" assignment_statement
	;

where_block :
	KW_WHERE "(" expr ")" sep statements elsewhere_block
	| KW_WHERE "(" expr ")" sep statements KW_ELSEWHERE sep statements
	| KW_WHERE "(" expr ")" sep statements KW_ELSE KW_WHERE sep statements
	| KW_WHERE "(" expr ")" sep statements
	;

elsewhere_block :
	KW_ELSEWHERE "(" expr ")" sep statements elsewhere_block
	| KW_ELSE KW_WHERE "(" expr ")" sep statements elsewhere_block
	| KW_ELSEWHERE "(" expr ")" sep statements KW_ELSEWHERE sep statements
	| KW_ELSEWHERE "(" expr ")" sep statements KW_ELSE KW_WHERE sep statements
	| KW_ELSE KW_WHERE "(" expr ")" sep statements KW_ELSEWHERE sep statements
	| KW_ELSE KW_WHERE "(" expr ")" sep statements KW_ELSE KW_WHERE sep statements
	| KW_ELSEWHERE "(" expr ")" sep statements
	| KW_ELSE KW_WHERE "(" expr ")" sep statements
	;

select_statement :
	KW_SELECT KW_CASE "(" expr ")" sep case_statements end_select
	| KW_SELECT_CASE "(" expr ")" sep case_statements end_select
	;

case_statements :
	case_statements case_statement
	| /*empty*/
	;

case_statement :
	KW_CASE "(" case_conditions ")" sep statements
	| KW_CASE KW_DEFAULT sep statements
	;

case_conditions :
	case_conditions TK_COMMA case_condition
	| case_condition
	;

case_condition :
	expr
	| expr TK_COLON
	| TK_COLON expr
	| expr TK_COLON expr
	;

select_rank_statement :
	select_rank "(" expr ")" sep select_rank_case_stmts end_select
	| select_rank "(" id TK_ARROW expr ")" sep select_rank_case_stmts end_select
	;

select_rank :
	KW_SELECT KW_RANK
	| KW_SELECT_RANK
	;

select_rank_case_stmts :
	select_rank_case_stmts select_rank_case_stmt
	| /*empty*/
	;

select_rank_case_stmt :
	KW_RANK "(" expr ")" id_opt sep statements
	| KW_RANK "(" TK_STAR /*9L*/ ")" id_opt sep statements
	| KW_RANK KW_DEFAULT id_opt sep statements
	;

select_type_statement :
	select_type "(" expr ")" sep select_type_body_statements end_select
	| select_type "(" id TK_ARROW expr ")" sep select_type_body_statements end_select
	;

select_type :
	KW_SELECT KW_TYPE
	| KW_SELECT_TYPE
	;

select_type_body_statements :
	select_type_body_statements select_type_body_statement
	| /*empty*/
	;

select_type_body_statement :
	KW_TYPE KW_IS "(" TK_NAME ")" sep statements
	| KW_TYPE KW_IS "(" var_type ")" sep statements
	| KW_CLASS KW_IS "(" id ")" sep statements
	| KW_CLASS KW_DEFAULT sep statements
	;

while_statement :
	KW_DO comma_opt KW_WHILE "(" expr ")" sep statements enddo
	| KW_DOWHILE "(" expr ")" sep statements enddo
	;

do_statement :
	KW_DO sep statements enddo
	| KW_DO comma_opt id TK_EQUAL expr TK_COMMA expr sep statements enddo
	| KW_DO comma_opt id TK_EQUAL expr TK_COMMA expr TK_COMMA expr sep statements enddo
	| KW_DO TK_INTEGER comma_opt id TK_EQUAL expr TK_COMMA expr sep statements enddo
	| KW_DO TK_INTEGER comma_opt id TK_EQUAL expr TK_COMMA expr TK_COMMA expr sep statements enddo
	| KW_DO comma_opt KW_CONCURRENT "(" concurrent_control_list ")" concurrent_locality_star sep statements enddo
	| KW_DO comma_opt KW_CONCURRENT "(" concurrent_control_list TK_COMMA expr ")" concurrent_locality_star sep statements enddo
	;

concurrent_control_list :
	concurrent_control_list TK_COMMA concurrent_control
	| concurrent_control
	;

concurrent_control :
	id TK_EQUAL expr TK_COLON expr
	| id TK_EQUAL expr TK_COLON expr TK_COLON expr
	;

concurrent_locality_star :
	concurrent_locality_star concurrent_locality
	| /*empty*/
	;

concurrent_locality :
	KW_LOCAL "(" id_list ")"
	| KW_LOCAL_INIT "(" id_list ")"
	| KW_SHARED "(" id_list ")"
	| KW_DEFAULT "(" KW_NONE ")"
	| KW_REDUCE "(" reduce_op TK_COLON id_list ")"
	;

comma_opt :
	TK_COMMA
	| /*empty*/
	;

forall_statement :
	KW_FORALL "(" concurrent_control_list ")" concurrent_locality_star sep statements endforall
	| KW_FORALL "(" concurrent_control_list TK_COMMA expr ")" concurrent_locality_star sep statements endforall
	;

forall_statement_single :
	KW_FORALL "(" concurrent_control_list ")" assignment_statement
	| KW_FORALL "(" concurrent_control_list TK_COMMA expr ")" assignment_statement
	;

format_statement :
	TK_FORMAT
	;

data_statement :
	KW_DATA data_set_list
	;

form_team_statement :
	form_team "(" expr TK_COMMA id ")"
	| form_team "(" expr TK_COMMA id sync_stat_list ")"
	;

form_team :
	KW_FORM KW_TEAM
	| KW_FORM_TEAM
	;

reduce_op :
	TK_PLUS /*8L*/
	| TK_STAR /*9L*/
	| id
	;

inout :
	KW_IN_OUT
	| KW_INOUT
	;

enddo :
	KW_END_DO
	| TK_LABEL KW_END_DO
	| KW_ENDDO
	| TK_LABEL KW_ENDDO
	;

endforall :
	KW_END_FORALL
	| KW_ENDFORALL
	;

endif :
	KW_END_IF
	| KW_ENDIF
	;

endwhere :
	KW_END_WHERE
	| KW_ENDWHERE
	;

exit_statement :
	KW_EXIT
	| KW_EXIT id
	;

return_statement :
	KW_RETURN
	| KW_RETURN expr
	;

cycle_statement :
	KW_CYCLE
	| KW_CYCLE id
	;

continue_statement :
	KW_CONTINUE
	;

entry_statement :
	KW_ENTRY id sub_args
	| KW_ENTRY id sub_args bind result_opt
	| KW_ENTRY id sub_args result bind_opt
	;

stop_statement :
	KW_STOP
	| KW_STOP expr
	| KW_STOP TK_COMMA KW_QUIET TK_EQUAL expr
	| KW_STOP expr TK_COMMA KW_QUIET TK_EQUAL expr
	;

error_stop_statement :
	KW_ERROR KW_STOP
	| KW_ERROR KW_STOP expr
	| KW_ERROR KW_STOP TK_COMMA KW_QUIET TK_EQUAL expr
	| KW_ERROR KW_STOP expr TK_COMMA KW_QUIET TK_EQUAL expr
	;

event_post_statement :
	KW_EVENT KW_POST "(" expr ")"
	| KW_EVENT KW_POST "(" expr TK_COMMA event_post_stat_list ")"
	;

event_wait_statement :
	KW_EVENT KW_WAIT "(" expr ")"
	| KW_EVENT KW_WAIT "(" expr TK_COMMA event_wait_spec_list ")"
	;

sync_all_statement :
	sync_all
	| sync_all "(" ")"
	| sync_all "(" sync_stat_list ")"
	;

sync_all :
	KW_SYNC KW_ALL
	| KW_SYNC_ALL
	;

sync_images_statement :
	sync_images "(" TK_STAR /*9L*/ ")"
	| sync_images "(" expr ")"
	| sync_images "(" TK_STAR /*9L*/ sync_stat_list ")"
	| sync_images "(" expr sync_stat_list ")"
	;

sync_images :
	KW_SYNC KW_IMAGES
	| KW_SYNC_IMAGES
	;

sync_memory_statement :
	sync_memory
	| sync_memory "(" ")"
	| sync_memory "(" sync_stat_list ")"
	;

sync_memory :
	KW_SYNC KW_MEMORY
	| KW_SYNC_MEMORY
	;

sync_team_statement :
	sync_team "(" expr ")"
	| sync_team "(" expr sync_stat_list ")"
	;

sync_team :
	KW_SYNC KW_TEAM
	| KW_SYNC_TEAM
	;

event_wait_spec_list :
	event_wait_spec_list TK_COMMA sync_stat
	| event_wait_spec
	| /*empty*/
	;

event_wait_spec :
	id TK_EQUAL expr
	;

event_post_stat_list :
	sync_stat
	;

sync_stat_list :
	sync_stat_list TK_COMMA sync_stat
	| TK_COMMA sync_stat
	| sync_stat
	;

sync_stat :
	KW_STAT TK_EQUAL id
	| KW_ERRMSG TK_EQUAL id
	| KW_NEW_INDEX TK_EQUAL expr
	;

critical_statement :
	KW_CRITICAL sep statements end_critical
	| KW_CRITICAL "(" ")" sep statements end_critical
	| KW_CRITICAL "(" sync_stat_list ")" sep statements end_critical
	;

change_team_statement :
	change_team "(" expr coarray_association_list ")" sep statements end_team
	| change_team "(" expr coarray_association_list ")" sep statements end_team "(" sync_stat_list ")"
	| change_team "(" expr coarray_association_list sync_stat_list ")" sep statements end_team
	| change_team "(" expr coarray_association_list sync_stat_list ")" sep statements end_team "(" sync_stat_list ")"
	;

coarray_association_list :
	coarray_association_list TK_COMMA coarray_association
	| coarray_association
	| /*empty*/
	;

coarray_association :
	id TK_LBRACKET coarray_arg_list "]" TK_ARROW expr
	;

change_team :
	KW_CHANGE KW_TEAM
	| KW_CHANGE_TEAM
	;

expr_list_opt :
	expr_list
	| /*empty*/
	;

expr_list :
	expr_list TK_COMMA expr
	| expr
	;

rbracket :
	"]"
	| "/)"
	;

expr :
	id
	| struct_member_star id
	| id "(" fnarray_arg_list_opt ")"
	| TK_STRING "(" fnarray_arg_list_opt ")"
	| struct_member_star id "(" fnarray_arg_list_opt ")"
	| id "(" fnarray_arg_list_opt ")" "(" fnarray_arg_list_opt ")"
	| struct_member_star id "(" fnarray_arg_list_opt ")" "(" fnarray_arg_list_opt ")"
	| id TK_LBRACKET coarray_arg_list "]"
	| struct_member_star id TK_LBRACKET coarray_arg_list "]"
	| id "(" fnarray_arg_list_opt ")" TK_LBRACKET coarray_arg_list "]"
	| struct_member_star id "(" fnarray_arg_list_opt ")" TK_LBRACKET coarray_arg_list "]"
	| TK_LBRACKET expr_list_opt rbracket
	| TK_LBRACKET var_type TK_DBL_COLON expr_list_opt rbracket
	| TK_LBRACKET id TK_DBL_COLON expr_list_opt rbracket
	| TK_INTEGER
	| TK_REAL
	| TK_STRING
	| TK_BOZ_CONSTANT
	| TK_TRUE
	| TK_FALSE
	| "(" expr ")"
	| "(" expr TK_COMMA expr ")"
	| "(" expr TK_COMMA id TK_EQUAL expr TK_COMMA expr ")"
	| "(" expr TK_COMMA expr TK_COMMA id TK_EQUAL expr TK_COMMA expr ")"
	| "(" expr TK_COMMA expr TK_COMMA expr_list TK_COMMA id TK_EQUAL expr TK_COMMA expr ")"
	| "(" expr TK_COMMA id TK_EQUAL expr TK_COMMA expr TK_COMMA expr ")"
	| "(" expr TK_COMMA expr TK_COMMA id TK_EQUAL expr TK_COMMA expr TK_COMMA expr ")"
	| "(" expr TK_COMMA expr TK_COMMA expr_list TK_COMMA id TK_EQUAL expr TK_COMMA expr TK_COMMA expr ")"
	| TK_DEF_OP /*1L*/ expr
	| expr TK_PLUS /*8L*/ expr
	| expr TK_MINUS /*8L*/ expr
	| expr TK_STAR /*9L*/ expr
	| expr TK_SLASH /*9L*/ expr
	| TK_MINUS /*8L*/ expr %prec UMINUS /*10P*/
	| TK_PLUS /*8L*/ expr %prec UMINUS /*10P*/
	| expr TK_POW /*11R*/ expr
	| expr TK_CONCAT /*7L*/ expr
	| expr TK_EQ /*6L*/ expr
	| expr TK_NE /*6L*/ expr
	| expr TK_LT /*6L*/ expr
	| expr TK_LE /*6L*/ expr
	| expr TK_GT /*6L*/ expr
	| expr TK_GE /*6L*/ expr
	| TK_NOT /*5P*/ expr
	| expr TK_AND /*4L*/ expr
	| expr TK_OR /*3L*/ expr
	| expr TK_XOR /*3L*/ expr
	| expr TK_EQV /*2L*/ expr
	| expr TK_NEQV /*2L*/ expr
	| expr TK_DEF_OP /*1L*/ expr
	;

struct_member_star :
	struct_member_star struct_member
	| struct_member
	;

struct_member :
	id TK_PERCENT
	| id "(" fnarray_arg_list_opt ")" TK_PERCENT
	;

fnarray_arg_list_opt :
	fnarray_arg_list_opt TK_COMMA fnarray_arg
	| fnarray_arg
	| /*empty*/
	;

fnarray_arg :
	expr
	| TK_COLON
	| expr TK_COLON
	| TK_COLON expr
	| expr TK_COLON expr
	| TK_DBL_COLON expr
	| TK_COLON TK_COLON expr
	| expr TK_DBL_COLON expr
	| expr TK_COLON TK_COLON expr
	| TK_COLON expr TK_COLON expr
	| expr TK_COLON expr TK_COLON expr
	| id TK_EQUAL expr
	| TK_STAR /*9L*/ TK_INTEGER
	;

coarray_arg_list :
	coarray_arg_list TK_COMMA coarray_arg
	| coarray_arg
	;

coarray_arg :
	expr
	| TK_COLON
	| expr TK_COLON
	| TK_COLON expr
	| expr TK_COLON expr
	| TK_DBL_COLON expr
	| TK_COLON TK_COLON expr
	| expr TK_DBL_COLON expr
	| expr TK_COLON TK_COLON expr
	| TK_COLON expr TK_COLON expr
	| expr TK_COLON expr TK_COLON expr
	| id TK_EQUAL expr
	| TK_STAR /*9L*/
	;

id_list_opt :
	id_list
	| /*empty*/
	;

id_list :
	id_list TK_COMMA id
	| id
	;

id_opt :
	id
	| /*empty*/
	;

id :
	TK_NAME
	| soft_keywords
	;

id_skw :
	id
	| soft_keywords
	;

soft_keywords :
    KW_LEN
    //| KW_NAME
    ;

/*
keywords :
	| KW_ABSTRACT
	| KW_ALL
	| KW_ALLOCATABLE
	| KW_ALLOCATE
	| KW_ASSIGN
	| KW_ASSIGNMENT
	| KW_ASSOCIATE
	| KW_ASYNCHRONOUS
	| KW_BACKSPACE
	| KW_BIND
	| KW_BLOCK
	| KW_CALL
	| KW_CASE
	| KW_CHANGE
	| KW_CHARACTER
	| KW_CLASS
	| KW_CLOSE
	| KW_CODIMENSION
	| KW_COMMON
	| KW_COMPLEX
	| KW_CONCURRENT
	| KW_CONTAINS
	| KW_CONTIGUOUS
	| KW_CONTINUE
	| KW_CRITICAL
	| KW_CYCLE
	| KW_DATA
	| KW_DEALLOCATE
	| KW_DEFAULT
	| KW_DEFERRED
	| KW_DIMENSION
	| KW_DO
	| KW_DOWHILE
	| KW_DOUBLE
	| KW_DOUBLE_PRECISION
	| KW_DOUBLE_COMPLEX
	| KW_ELEMENTAL
	| KW_ELSE
	| KW_ELSEIF
	| KW_ELSEWHERE
	| KW_END
	| KW_ENDDO
	| KW_ENDIF
	| KW_ENDINTERFACE
	| KW_ENDTYPE
	| KW_ENDPROGRAM
	| KW_ENDMODULE
	| KW_ENDSUBMODULE
	| KW_ENDBLOCK
	| KW_ENDBLOCKDATA
	| KW_ENDSUBROUTINE
	| KW_ENDFUNCTION
	| KW_ENDPROCEDURE
	| KW_ENDENUM
	| KW_ENDSELECT
	| KW_ENDASSOCIATE
	| KW_ENDFORALL
	| KW_ENDWHERE
	| KW_ENDCRITICAL
	| KW_ENDFILE
	| KW_ENTRY
	| KW_ENUM
	| KW_ENUMERATOR
	| KW_EQUIVALENCE
	| KW_ERRMSG
	| KW_ERROR
	| KW_EVENT
	| KW_EXIT
	| KW_EXTENDS
	| KW_EXTERNAL
	| KW_FILE
	| KW_FINAL
	| KW_FLUSH
	| KW_FORALL
	| KW_FORMATTED
	| KW_FORM
	| KW_FORM_TEAM
	| KW_FUNCTION
	| KW_GENERIC
	| KW_GO
	| KW_GOTO
	| KW_IF
	| KW_IMAGES
	| KW_IMPLICIT
	| KW_IMPORT
	| KW_IMPURE
	| KW_IN
	| KW_INCLUDE
	| KW_INOUT
	| KW_INQUIRE
	| KW_INSTANTIATE
	| KW_INTEGER
	| KW_INTENT
	| KW_INTERFACE
	| KW_INTRINSIC
	| KW_IS
	| KW_KIND
	| KW_LEN
	| KW_LOCAL
	| KW_LOCAL_INIT
	| KW_LOGICAL
	| KW_MEMORY
	| KW_MODULE
	| KW_MOLD
	| KW_NAME
	| KW_NAMELIST
	| KW_NEW_INDEX
	| KW_NOPASS
	| KW_NON_INTRINSIC
	| KW_NON_OVERRIDABLE
	| KW_NON_RECURSIVE
	| KW_NONE
	| KW_NULLIFY
	| KW_ONLY
	| KW_OPEN
	| KW_OPERATOR
	| KW_OPTIONAL
	| KW_OUT
	| KW_PARAMETER
	| KW_PASS
	| KW_POINTER
	| KW_POST
	| KW_PRECISION
	| KW_PRINT
	| KW_PRIVATE
	| KW_PROCEDURE
	| KW_PROGRAM
	| KW_PROTECTED
	| KW_PUBLIC
	| KW_PURE
	| KW_QUIET
	| KW_RANK
	| KW_READ
	| KW_REAL
	| KW_RECURSIVE
	| KW_REDUCE
	| KW_REQUIREMENT
	| KW_REQUIRES
	| KW_RESULT
	| KW_RETURN
	| KW_REWIND
	| KW_SAVE
	| KW_SELECT
	| KW_SELECT_CASE
	| KW_SELECT_RANK
	| KW_SELECT_TYPE
	| KW_SEQUENCE
	| KW_SHARED
	| KW_SOURCE
	| KW_STAT
	| KW_STOP
	| KW_SUBMODULE
	| KW_SUBROUTINE
	| KW_SYNC
	| KW_TARGET
	| KW_TEAM
	| KW_TEAM_NUMBER
	| KW_TEMPLATE
	| KW_THEN
	| KW_TO
	| KW_TYPE
	| KW_UNFORMATTED
	| KW_USE
	| KW_VALUE
	| KW_VOLATILE
	| KW_WAIT
	| KW_WHERE
	| KW_WHILE
	| KW_WRITE
	;
*/
%%

end   \x00
whitespace   [ \t\v\r]+
newline   \n
digit   [0-9]
char    [a-zA-Z_]
name   {char}({char}|{digit})*
defop   "."[a-zA-Z]+"."
kind   {digit}+|{name}
significand   ({digit}+"."{digit}*)|("."{digit}+)
exp   [edED][-+]?{digit}+
integer   {digit}+("_"{kind})?
real   (({significand}{exp}?)|({digit}+{exp}))("_"{kind})?
string1   ({kind}"_")?\"(\"\"|[^\"\x00])*\"
string2   ({kind}"_")?"'"("''"|[^'\x00])*"'"
comment   "!"[^\n\x00]*
ws_comment   {whitespace}?{comment}?{newline}

%%

{end}	END_OF_FILE
{whitespace}	skip()

// Keywords
"abstract"   KW_ABSTRACT
"all"   KW_ALL
"allocatable"   KW_ALLOCATABLE
"allocate"   KW_ALLOCATE
"assign"   KW_ASSIGN
"assignment"   KW_ASSIGNMENT
"associate"   KW_ASSOCIATE
"asynchronous"   KW_ASYNCHRONOUS
"backspace"   KW_BACKSPACE
"bind"   KW_BIND
"block"   KW_BLOCK
"call"   KW_CALL
"case"   KW_CASE
"change"   KW_CHANGE
"changeteam"   KW_CHANGE_TEAM
"character"   KW_CHARACTER
"class"   KW_CLASS
"close"   KW_CLOSE
"codimension"   KW_CODIMENSION
"common"   KW_COMMON
"complex"   KW_COMPLEX
"concurrent"   KW_CONCURRENT
"contains"   KW_CONTAINS
"contiguous"   KW_CONTIGUOUS
"continue"   KW_CONTINUE
"critical"   KW_CRITICAL
"cycle"   KW_CYCLE
"data"   KW_DATA
"deallocate"   KW_DEALLOCATE
"default"   KW_DEFAULT
"deferred"   KW_DEFERRED
"dimension"   KW_DIMENSION
/*
"do" / ({whitespace}{digit}+) {
	// This is a label do statement, we have to match the
	// corresponding continue base "end do".
	uint64_t n = parse_int(cur);
	enddo_label_stack.push_back(n);
	KW_DO
}
*/
"do"   KW_DO
"dowhile"   KW_DOWHILE
"double"   KW_DOUBLE
"doubleprecision"   KW_DOUBLE_PRECISION
"doublecomplex"   KW_DOUBLE_COMPLEX
"elemental"   KW_ELEMENTAL
"else"   KW_ELSE
"elseif"   KW_ELSEIF
"elsewhere"   KW_ELSEWHERE

"end"   KW_END

"end"{whitespace}"program"   KW_END_PROGRAM
"endprogram"   KW_ENDPROGRAM

"end"{whitespace}"module"   KW_END_MODULE
"endmodule"   KW_ENDMODULE

"end"{whitespace}"submodule"   KW_END_SUBMODULE
"endsubmodule"   KW_ENDSUBMODULE

"end"{whitespace}"block"   KW_END_BLOCK
"endblock"   KW_ENDBLOCK

"end"{whitespace}"block"{whitespace}"data"   KW_END_BLOCK_DATA
"endblock"{whitespace}"data"   KW_END_BLOCK_DATA
"end"{whitespace}"blockdata"   KW_END_BLOCK_DATA
"endblockdata"   KW_ENDBLOCKDATA

"end"{whitespace}"subroutine"   KW_END_SUBROUTINE
"endsubroutine"   KW_ENDSUBROUTINE

"end"{whitespace}"function"   KW_END_FUNCTION
"endfunction"   KW_ENDFUNCTION

"end"{whitespace}"procedure"   KW_END_PROCEDURE
"endprocedure"   KW_ENDPROCEDURE

"end"{whitespace}"enum"   KW_END_ENUM
"endenum"   KW_ENDENUM

"end"{whitespace}"select"   KW_END_SELECT
"endselect"   KW_ENDSELECT

"end"{whitespace}"associate"   KW_END_ASSOCIATE
"endassociate"   KW_ENDASSOCIATE

"end"{whitespace}"critical"   KW_END_CRITICAL
"endcritical"   KW_ENDCRITICAL

"end"{whitespace}"team"   KW_END_TEAM
"endteam"   KW_ENDTEAM

"end"{whitespace}"forall"   KW_END_FORALL
"endforall"   KW_ENDFORALL

"end"{whitespace}"if"   KW_END_IF
"endif"   KW_ENDIF

"end"{whitespace}"interface"   KW_END_INTERFACE
"endinterface"   KW_ENDINTERFACE

"end"{whitespace}"type"   KW_END_TYPE
"endtype"   KW_ENDTYPE

"end"{whitespace}"do"  KW_END_DO
/*{
	if (enddo_newline_process) {
	    KW_CONTINUE)
	} else {
	    KW_END_DO)
	}
}*/
"enddo"  KW_ENDDO
/*{
	if (enddo_newline_process) {
	    KW_CONTINUE)
	} else {
	    KW_ENDDO)
	}
}*/

"end"{whitespace}"where"   KW_END_WHERE
"endwhere"   KW_ENDWHERE

"end file"   KW_END_FILE
"endfile"   KW_ENDFILE

"entry"   KW_ENTRY
"enum"   KW_ENUM
"enumerator"   KW_ENUMERATOR
"equivalence"   KW_EQUIVALENCE
"errmsg"   KW_ERRMSG
"error"   KW_ERROR
"event"   KW_EVENT
"exit"   KW_EXIT
"extends"   KW_EXTENDS
"external"   KW_EXTERNAL
"file"   KW_FILE
"final"   KW_FINAL
"flush"   KW_FLUSH
"forall"   KW_FORALL
"format"  TK_FORMAT
/*{
	if (last_token == yytokentype::TK_LABEL) {
	    unsigned char *start;
	    lex_format(cur, loc, start);
	    yylval.string.p = (char*) start;
	    yylval.string.n = cur-start-1;
	    RET(TK_FORMAT)
	} else {
	    token(yylval.string);
	    RET(TK_NAME)
	}
}*/
"formatted"   KW_FORMATTED
"form"   KW_FORM
"formteam"   KW_FORM_TEAM
"function"   KW_FUNCTION
"generic"   KW_GENERIC
"go"   KW_GO
"goto"   KW_GOTO
"if"   KW_IF
"images"   KW_IMAGES
"implicit"   KW_IMPLICIT
"import"   KW_IMPORT
"impure"   KW_IMPURE
"in"   KW_IN
"include"   KW_INCLUDE
"inout"   KW_INOUT
"in"{whitespace}"out"   KW_IN_OUT
"inquire"   KW_INQUIRE
"instantiate"   KW_INSTANTIATE
"integer"   KW_INTEGER
"intent"   KW_INTENT
"interface"   KW_INTERFACE
"intrinsic"   KW_INTRINSIC
"is"   KW_IS
"kind"   KW_KIND
"len"   KW_LEN
"local"   KW_LOCAL
"local_init"   KW_LOCAL_INIT
"logical"   KW_LOGICAL
"memory"   KW_MEMORY
"module"   KW_MODULE
"mold"   KW_MOLD
//"name"   KW_NAME
"namelist"   KW_NAMELIST
"new_index"   KW_NEW_INDEX
"nopass"   KW_NOPASS
"non_intrinsic"   KW_NON_INTRINSIC
"non_overridable"   KW_NON_OVERRIDABLE
"non_recursive"   KW_NON_RECURSIVE
"none"   KW_NONE
"nullify"   KW_NULLIFY
"only"   KW_ONLY
"open"   KW_OPEN
"operator"   KW_OPERATOR
"optional"   KW_OPTIONAL
"out"   KW_OUT
"parameter"   KW_PARAMETER
"pass"   KW_PASS
"pointer"   KW_POINTER
"post"   KW_POST
"precision"   KW_PRECISION
"print"   KW_PRINT
"private"   KW_PRIVATE
"procedure"   KW_PROCEDURE
"program"   KW_PROGRAM
"protected"   KW_PROTECTED
"public"   KW_PUBLIC
"pure"   KW_PURE
"quiet"   KW_QUIET
"rank"   KW_RANK
"read"   KW_READ
"real" KW_REAL
"recursive"   KW_RECURSIVE
"reduce"   KW_REDUCE
"requirement"   KW_REQUIREMENT
"requires"   KW_REQUIRES
"result"   KW_RESULT
"return"   KW_RETURN
"rewind"   KW_REWIND
"save"   KW_SAVE
"select"   KW_SELECT
"selectcase"   KW_SELECT_CASE
"selectrank"   KW_SELECT_RANK
"selecttype"   KW_SELECT_TYPE
"sequence"   KW_SEQUENCE
"shared"   KW_SHARED
"source"   KW_SOURCE
"stat"   KW_STAT
"stop"   KW_STOP
"submodule"   KW_SUBMODULE
"subroutine"   KW_SUBROUTINE
"sync"   KW_SYNC
"syncall"   KW_SYNC_ALL
"syncimages"   KW_SYNC_IMAGES
"syncmemory"   KW_SYNC_MEMORY
"syncteam"   KW_SYNC_TEAM
"target"   KW_TARGET
"team"   KW_TEAM
"team_number"   KW_TEAM_NUMBER
"template"   KW_TEMPLATE
"then"   KW_THEN
"to"   KW_TO
"type"   KW_TYPE
"unformatted"   KW_UNFORMATTED
"use"   KW_USE
"value"   KW_VALUE
"volatile"   KW_VOLATILE
"wait"   KW_WAIT
"where"   KW_WHERE
"while"   KW_WHILE
"write"   KW_WRITE

// Tokens
{newline}  TK_NEWLINE
/*{
	if (enddo_newline_process) {
	    enddo_newline_process = false;
	    enddo_state = 1;
	    return yytokentype::TK_NEWLINE;
	} else {
	    enddo_newline_process = false;
	    enddo_insert_count = 0;
	    token_loc(loc); line_num++; cur_line=cur;
	    last_token = yytokentype::TK_NEWLINE;
	    return yytokentype::TK_NEWLINE;
	}
}*/

// Single character symbols
"("  "(" //TK_LPAREN
//"(" / "/=" TK_LPAREN // To parse "operator(/=)" correctly
//"(" / "/)" TK_LPAREN // To parse "operator(/)" correctly
// To parse "operator(/ )" correctly
//"(" / "/" whitespace ")" TK_LPAREN
// To parse "operator(// )" correctly
//"(" / "//" whitespace ")" TK_LPAREN
//"(" / "//)" TK_LPAREN // To parse "operator(//)" correctly
")"  ")" //TK_RPAREN
"["  TK_LBRACKET
"(/"  TK_LBRACKET
"]"  "]" //TK_RBRACKET
"/)"  "/)" //TK_RBRACKET_OLD
"+"  TK_PLUS
"-"  TK_MINUS
"="  TK_EQUAL
":"  TK_COLON
";"  TK_SEMICOLON
"/"  TK_SLASH
"%"  TK_PERCENT
","  TK_COMMA
"*"  TK_STAR
//"|"  TK_VBAR

// Multiple character symbols
".." TK_DBL_DOT
"::"  TK_DBL_COLON
"**"  TK_POW
"//"  TK_CONCAT
"=>"  TK_ARROW

// Relational operators
"=="   TK_EQ
".eq." TK_EQ

"/="   TK_NE
".ne." TK_NE

"<"    TK_LT
".lt." TK_LT

"<="   TK_LE
".le." TK_LE

">"    TK_GT
".gt." TK_GT

">="   TK_GE
".ge." TK_GE


// Logical operators
".not."  TK_NOT
".and."  TK_AND
".or."   TK_OR
".xor."  TK_XOR
".eqv."  TK_EQV
".neqv." TK_NEQV

// True/False

".true."("_"{kind})? TK_TRUE
".false."("_"{kind})? TK_FALSE

// This is needed to ensure that 2.op.3 gets tokenized as
// TK_INTEGER(2), TK_DEFOP(.op.), TK_INTEGER(3), and not
// TK_REAL(2.), TK_NAME(op), TK_REAL(.3). The `.op.` can be a
// built-in or custom defined operator, such as: `.eq.`, `.not.`,
// or `.custom.`.
/*
integer / defop {
	lex_int_large(al, tok, cur,
	    yylval.int_suffix.int_n,
	    yylval.int_suffix.int_kind);
	RET(TK_INTEGER)
}
*/

{real} TK_REAL
{integer}{whitespace}{name}{newline}	TK_LABEL
/*
integer / (whitespace name) {
	if (last_token == yytokentype::TK_NEWLINE) {
	    uint64_t u;
	    if (lex_int(tok, cur, u, yylval.int_suffix.int_kind)) {
		    yylval.n = u;
		    if (enddo_label_stack[enddo_label_stack.size()-1] == u) {
			while (enddo_label_stack[enddo_label_stack.size()-1] == u) {
			    enddo_label_stack.pop_back();
			    enddo_insert_count++;
			}
			enddo_newline_process = true;
		    } else {
			enddo_newline_process = false;
		    }
		    RET(TK_LABEL)
	    } else {
		token_loc(loc);
		std::string t = token();
		throw LFortran::parser_local::TokenizerError("Integer '" + t + "' too large",
		    loc);
	    }
	} else {
	    lex_int_large(al, tok, cur,
		yylval.int_suffix.int_n,
		yylval.int_suffix.int_kind);
	    RET(TK_INTEGER)
	}
}
*/
{integer} TK_INTEGER

[bB]["][01]+["]  TK_BOZ_CONSTANT
[bB]['][01]+[']  TK_BOZ_CONSTANT
[oO]["][0-7]+["]  TK_BOZ_CONSTANT
[oO]['][0-7]+[']  TK_BOZ_CONSTANT
[zZ]["][0-9a-fA-F]+["]  TK_BOZ_CONSTANT
[zZ]['][0-9a-fA-F]+[']  TK_BOZ_CONSTANT

"&"{ws_comment}+{whitespace}?"&"? skip()

{comment}{newline}  TK_COMMENT
{comment}  TK_EOLCOMMENT
/*{
	line_num++; cur_line=cur;
	token(yylval.string);
	yylval.string.n--;
	token_loc(loc);
	if (last_token == yytokentype::TK_NEWLINE) {
	    return yytokentype::TK_COMMENT;
	} else {
	    last_token=yytokentype::TK_NEWLINE;
	    return yytokentype::TK_EOLCOMMENT;
	}
}*/

// Macros are ignored for now:
"#"[^\n\x00]*{newline} skip()

{string1} TK_STRING
{string2} TK_STRING

{defop} TK_DEF_OP
{name} TK_NAME

%%

