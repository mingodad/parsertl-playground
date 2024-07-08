//From: https://github.com/cforall/cforall/blob/ca1443045c528563ffa66d324b32e980f32ef020/src/Parser/parser.yy
//
// Cforall Version 1.0.0 Copyright (C) 2015 University of Waterloo
//
// The contents of this file are covered under the licence agreement in the
// file "LICENCE" distributed with Cforall.
//
// parser.yy --
//
// Author           : Peter A. Buhr
// Created On       : Sat Sep  1 20:22:55 2001
// Last Modified By : Peter A. Buhr
// Last Modified On : Thu Jun 27 14:45:57 2024
// Update Count     : 6705
//

// This grammar is based on the ANSI99/11 C grammar, specifically parts of EXPRESSION and STATEMENTS, and on the C
// grammar by James A. Roskind, specifically parts of DECLARATIONS and EXTERNAL DEFINITIONS.  While parts have been
// copied, important changes have been made in all sections; these changes are sufficient to constitute a new grammar.
// In particular, this grammar attempts to be more syntactically precise, i.e., it parses less incorrect language syntax
// that must be subsequently rejected by semantic checks.  Nevertheless, there are still several semantic checks
// required and many are noted in the grammar. Finally, the grammar is extended with GCC and CFA language extensions.

// Acknowledgments to Richard Bilson, Glen Ditchfield, and Rodolfo Gabriel Esteves who all helped when I got stuck with
// the grammar.

// The root language for this grammar is ANSI99/11 C. All of ANSI99/11 is parsed, except for:
//
//   designation with '=' (use ':' instead)
//
// This incompatibility is discussed in detail before the "designation" grammar rule.  Most of the syntactic extensions
// from ANSI90 to ANSI11 C are marked with the comment "C99/C11".

// This grammar also has two levels of extensions. The first extensions cover most of the GCC C extensions. All of the
// syntactic extensions for GCC C are marked with the comment "GCC". The second extensions are for Cforall (CFA), which
// fixes several of C's outstanding problems and extends C with many modern language concepts. All of the syntactic
// extensions for CFA C are marked with the comment "CFA".

/*Tokens*/
%token TYPEDEF
%token EXTERN
%token STATIC
%token AUTO
%token REGISTER
%token THREADLOCALGCC
%token THREADLOCALC11
%token INLINE
%token FORTRAN
%token NORETURN
%token CONST
%token VOLATILE
%token RESTRICT
%token ATOMIC
%token FORALL
%token MUTEX
%token VIRTUAL
%token VTABLE
%token COERCE
%token VOID
%token CHAR
%token SHORT
%token INT
%token LONG
%token FLOAT
%token DOUBLE
%token SIGNED
%token UNSIGNED
%token BOOL
%token COMPLEX
%token IMAGINARY
%token INT128
%token UINT128
%token uuFLOAT80
%token uuFLOAT128
%token uFLOAT16
%token uFLOAT32
%token uFLOAT32X
%token uFLOAT64
%token uFLOAT64X
%token uFLOAT128
%token DECIMAL32
%token DECIMAL64
%token DECIMAL128
%token ZERO_T
%token ONE_T
%token SIZEOF
%token TYPEOF
%token VA_LIST
%token VA_ARG
%token AUTO_TYPE
%token COUNTOF
%token OFFSETOF
%token BASETYPEOF
%token TYPEID
%token ENUM
%token STRUCT
%token UNION
%token EXCEPTION
%token GENERATOR
%token COROUTINE
%token MONITOR
%token THREAD
%token OTYPE
%token FTYPE
%token DTYPE
%token TTYPE
%token TRAIT
%token LABEL
%token SUSPEND
%token ATTRIBUTE
%token EXTENSION
%token IF
%token ELSE
%token SWITCH
%token CASE
%token DEFAULT
%token DO
%token WHILE
%token FOR
%token BREAK
%token CONTINUE
%token GOTO
%token RETURN
%token CHOOSE
%token FALLTHRU
%token FALLTHROUGH
%token WITH
%token WHEN
%token WAITFOR
%token WAITUNTIL
%token CORUN
%token COFOR
%token DISABLE
%token ENABLE
%token TRY
%token THROW
%token THROWRESUME
//%token AT
%token ASM
//%token ALIGNAS
%token ALIGNOF
%token GENERIC
%token STATICASSERT
%token IDENTIFIER
%token TYPEDIMname
%token TYPEDEFname
%token TYPEGENname
%token TIMEOUT
%token WAND
%token WOR
%token CATCH
%token RECOVER
%token CATCHRESUME
%token FIXUP
%token FINALLY
%token INTEGERconstant
%token CHARACTERconstant
%token STRINGliteral
%token DIRECTIVE
%token FLOATING_DECIMALconstant
%token FLOATING_FRACTIONconstant
%token FLOATINGconstant
%token ARROW
%token ICR
%token DECR
%token LS
%token RS
%token LE
%token GE
%token EQ
%token NE
%token ANDAND
%token OROR
%token ATTR
%token ELLIPSIS
%token EXPassign
%token MULTassign
%token DIVassign
%token MODassign
%token PLUSassign
%token MINUSassign
%token LSassign
%token RSassign
%token ANDassign
%token ERassign
%token ORassign
%token ErangeUp
%token ErangeUpEq
%token ErangeDown
%token ErangeDownEq
%token ATassign

%precedence /*1*/ THEN
%precedence /*2*/ ANDAND
%precedence /*3*/ WAND
%precedence /*4*/ OROR
%precedence /*5*/ WOR
%precedence /*6*/ TIMEOUT
%precedence /*7*/ CATCH
%precedence /*8*/ RECOVER
%precedence /*9*/ CATCHRESUME
%precedence /*10*/ FIXUP
%precedence /*11*/ FINALLY
%precedence /*12*/ ELSE
%precedence /*13*/ TYPEGENname
%precedence /*14*/ '}'
%precedence /*15*/ '('

%start translation_unit

%%

push :
	/*empty*/
	;

pop :
	/*empty*/
	;

constant :
	INTEGERconstant
	| FLOATING_DECIMALconstant
	| FLOATING_FRACTIONconstant
	| FLOATINGconstant
	| CHARACTERconstant
	;

quasi_keyword :
	TIMEOUT /*6P*/
	| WAND /*3P*/
	| WOR /*5P*/
	| CATCH /*7P*/
	| RECOVER /*8P*/
	| CATCHRESUME /*9P*/
	| FIXUP /*10P*/
	| FINALLY /*11P*/
	;

identifier :
	IDENTIFIER
	| quasi_keyword
	;

identifier_at :
	identifier
	| '@'
	;

identifier_or_type_name :
	identifier
	| TYPEDEFname
	| TYPEGENname /*13P*/
	;

string_literal :
	string_literal_list
	;

string_literal_list :
	STRINGliteral
	| string_literal_list STRINGliteral
	;

primary_expression :
	IDENTIFIER
	| quasi_keyword
	| TYPEDIMname
	| tuple
	| '(' /*15P*/ comma_expression ')'
	| '(' /*15P*/ compound_statement ')'
	| type_name '.' identifier
	| type_name '.' '[' field_name_list ']'
	| GENERIC '(' /*15P*/ assignment_expression ',' generic_assoc_list ')'
	| IDENTIFIER IDENTIFIER
	| IDENTIFIER type_qualifier
	| IDENTIFIER storage_class
	| IDENTIFIER basic_type_name
	| IDENTIFIER TYPEDEFname
	| IDENTIFIER TYPEGENname /*13P*/
	;

generic_assoc_list :
	generic_association
	| generic_assoc_list ',' generic_association
	;

generic_association :
	type_no_function ':' assignment_expression
	| DEFAULT ':' assignment_expression
	;

postfix_expression :
	primary_expression
	| postfix_expression '[' assignment_expression ',' tuple_expression_list ']'
	| postfix_expression '[' assignment_expression ']'
	| constant '[' assignment_expression ']'
	| string_literal '[' assignment_expression ']'
	| postfix_expression '{' argument_expression_list_opt '}' /*14P*/
	| postfix_expression '(' /*15P*/ argument_expression_list_opt ')'
	| VA_ARG '(' /*15P*/ primary_expression ',' declaration_specifier_nobody abstract_parameter_declarator_opt ')'
	| postfix_expression '`' identifier
	| constant '`' identifier
	| string_literal '`' identifier
	| postfix_expression '.' identifier_or_type_name
	| postfix_expression '.' INTEGERconstant
	| postfix_expression FLOATING_FRACTIONconstant
	| postfix_expression '.' '[' field_name_list ']'
	| postfix_expression '.' aggregate_control
	| postfix_expression ARROW identifier
	| postfix_expression ARROW INTEGERconstant
	| postfix_expression ARROW '[' field_name_list ']'
	| postfix_expression ICR
	| postfix_expression DECR
	| '(' /*15P*/ type_no_function ')' '{' initializer_list_opt comma_opt '}' /*14P*/
	| '(' /*15P*/ type_no_function ')' '@' '{' initializer_list_opt comma_opt '}' /*14P*/
	| '^' primary_expression '{' argument_expression_list_opt '}' /*14P*/
	;

argument_expression_list_opt :
	/*empty*/
	| argument_expression_list
	;

argument_expression_list :
	argument_expression
	| argument_expression_list_opt ',' argument_expression
	;

argument_expression :
	'@'
	| assignment_expression
	;

field_name_list :
	field
	| field_name_list ',' field
	;

field :
	field_name
	| FLOATING_DECIMALconstant field
	| FLOATING_DECIMALconstant '[' field_name_list ']'
	| field_name '.' field
	| field_name '.' '[' field_name_list ']'
	| field_name ARROW field
	| field_name ARROW '[' field_name_list ']'
	;

field_name :
	INTEGERconstant fraction_constants_opt
	| FLOATINGconstant fraction_constants_opt
	| identifier_at fraction_constants_opt
	;

fraction_constants_opt :
	/*empty*/
	| fraction_constants_opt FLOATING_FRACTIONconstant
	;

unary_expression :
	postfix_expression
	| constant
	| string_literal
	| EXTENSION cast_expression
	| ptrref_operator cast_expression
	| unary_operator cast_expression
	| ICR unary_expression
	| DECR unary_expression
	| SIZEOF unary_expression
	| SIZEOF '(' /*15P*/ type_no_function ')'
	| ALIGNOF unary_expression
	| ALIGNOF '(' /*15P*/ type_no_function ')'
	| SIZEOF '(' /*15P*/ cfa_abstract_function ')'
	| ALIGNOF '(' /*15P*/ cfa_abstract_function ')'
	| OFFSETOF '(' /*15P*/ type_no_function ',' identifier ')'
	| TYPEID '(' /*15P*/ type ')'
	| COUNTOF '(' /*15P*/ type_no_function ')'
	| COUNTOF unary_expression
	;

ptrref_operator :
	'*'
	| '&'
	| ANDAND /*2P*/
	;

unary_operator :
	'+'
	| '-'
	| '!'
	| '~'
	;

cast_expression :
	unary_expression
	| '(' /*15P*/ type_no_function ')' cast_expression
	| '(' /*15P*/ aggregate_control '&' ')' cast_expression
	| '(' /*15P*/ aggregate_control '*' ')' cast_expression
	| '(' /*15P*/ VIRTUAL ')' cast_expression
	| '(' /*15P*/ VIRTUAL type_no_function ')' cast_expression
	| '(' /*15P*/ RETURN type_no_function ')' cast_expression
	| '(' /*15P*/ COERCE type_no_function ')' cast_expression
	| '(' /*15P*/ qualifier_cast_list ')' cast_expression
	;

qualifier_cast_list :
	cast_modifier type_qualifier_name
	| cast_modifier MUTEX
	| qualifier_cast_list cast_modifier type_qualifier_name
	| qualifier_cast_list cast_modifier MUTEX
	;

cast_modifier :
	'-'
	| '+'
	;

exponential_expression :
	cast_expression
	| exponential_expression '\\' cast_expression
	;

multiplicative_expression :
	exponential_expression
	| multiplicative_expression '*' exponential_expression
	| multiplicative_expression '/' exponential_expression
	| multiplicative_expression '%' exponential_expression
	;

additive_expression :
	multiplicative_expression
	| additive_expression '+' multiplicative_expression
	| additive_expression '-' multiplicative_expression
	;

shift_expression :
	additive_expression
	| shift_expression LS additive_expression
	| shift_expression RS additive_expression
	;

relational_expression :
	shift_expression
	| relational_expression '<' shift_expression
	| relational_expression '>' shift_expression
	| relational_expression LE shift_expression
	| relational_expression GE shift_expression
	;

equality_expression :
	relational_expression
	| equality_expression EQ relational_expression
	| equality_expression NE relational_expression
	;

AND_expression :
	equality_expression
	| AND_expression '&' equality_expression
	;

exclusive_OR_expression :
	AND_expression
	| exclusive_OR_expression '^' AND_expression
	;

inclusive_OR_expression :
	exclusive_OR_expression
	| inclusive_OR_expression '|' exclusive_OR_expression
	;

logical_AND_expression :
	inclusive_OR_expression
	| logical_AND_expression ANDAND /*2P*/ inclusive_OR_expression
	;

logical_OR_expression :
	logical_AND_expression
	| logical_OR_expression OROR /*4P*/ logical_AND_expression
	;

conditional_expression :
	logical_OR_expression
	| logical_OR_expression '?' comma_expression ':' conditional_expression
	| logical_OR_expression '?' ':' conditional_expression
	;

constant_expression :
	conditional_expression
	;

assignment_expression :
	conditional_expression
	| unary_expression assignment_operator assignment_expression
	| unary_expression '=' '{' initializer_list_opt comma_opt '}' /*14P*/
	;

assignment_expression_opt :
	/*empty*/
	| assignment_expression
	;

assignment_operator :
	simple_assignment_operator
	| compound_assignment_operator
	;

simple_assignment_operator :
	'='
	| ATassign
	;

compound_assignment_operator :
	EXPassign
	| MULTassign
	| DIVassign
	| MODassign
	| PLUSassign
	| MINUSassign
	| LSassign
	| RSassign
	| ANDassign
	| ERassign
	| ORassign
	;

tuple :
	'[' ',' tuple_expression_list ']'
	| '[' push assignment_expression pop ',' tuple_expression_list ']'
	;

tuple_expression_list :
	assignment_expression
	| '@'
	| tuple_expression_list ',' assignment_expression
	| tuple_expression_list ',' '@'
	;

comma_expression :
	assignment_expression
	| comma_expression ',' assignment_expression
	;

comma_expression_opt :
	/*empty*/
	| comma_expression
	;

statement :
	labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	| with_statement
	| mutex_statement
	| waitfor_statement
	| waituntil_statement
	| corun_statement
	| cofor_statement
	| exception_statement
	| enable_disable_statement
	| asm_statement
	| DIRECTIVE
	;

labeled_statement :
	identifier_or_type_name ':' attribute_list_opt statement
	//| identifier_or_type_name ':' attribute_list_opt error
	;

compound_statement :
	'{' '}' /*14P*/
	| '{' push local_label_declaration_opt statement_decl_list pop '}' /*14P*/
	;

statement_decl_list :
	statement_decl
	| statement_decl_list statement_decl
	;

statement_decl :
	declaration
	| EXTENSION declaration
	| function_definition
	| EXTENSION function_definition
	| statement
	;

statement_list_nodecl :
	statement
	| statement_list_nodecl statement
	//| statement_list_nodecl error
	;

expression_statement :
	comma_expression_opt ';'
	;

selection_statement :
	IF '(' /*15P*/ conditional_declaration ')' statement %prec THEN /*1P*/
	| IF '(' /*15P*/ conditional_declaration ')' statement ELSE /*12P*/ statement
	| SWITCH '(' /*15P*/ comma_expression ')' case_clause
	| SWITCH '(' /*15P*/ comma_expression ')' '{' push declaration_list_opt switch_clause_list_opt pop '}' /*14P*/
	//| SWITCH '(' /*15P*/ comma_expression ')' '{' error '}' /*14P*/
	| CHOOSE '(' /*15P*/ comma_expression ')' case_clause
	| CHOOSE '(' /*15P*/ comma_expression ')' '{' push declaration_list_opt switch_clause_list_opt pop '}' /*14P*/
	//| CHOOSE '(' /*15P*/ comma_expression ')' '{' error '}' /*14P*/
	;

conditional_declaration :
	comma_expression
	| c_declaration
	| cfa_declaration
	| declaration comma_expression
	;

case_value :
	constant_expression
	| constant_expression ELLIPSIS constant_expression
	| subrange
	;

case_value_list :
	case_value
	| case_value_list ',' case_value
	;

case_label :
	//CASE error
	CASE case_value_list ':'
	//| CASE case_value_list error
	| DEFAULT ':'
	//| DEFAULT error
	;

case_label_list :
	case_label
	| case_label_list case_label
	;

case_clause :
	case_label_list statement
	;

switch_clause_list_opt :
	/*empty*/
	| switch_clause_list
	;

switch_clause_list :
	case_label_list statement_list_nodecl
	| switch_clause_list case_label_list statement_list_nodecl
	;

iteration_statement :
	WHILE '(' /*15P*/ ')' statement %prec THEN /*1P*/
	| WHILE '(' /*15P*/ ')' statement ELSE /*12P*/ statement
	| WHILE '(' /*15P*/ conditional_declaration ')' statement %prec THEN /*1P*/
	| WHILE '(' /*15P*/ conditional_declaration ')' statement ELSE /*12P*/ statement
	| DO statement WHILE '(' /*15P*/ ')' ';'
	| DO statement WHILE '(' /*15P*/ ')' ELSE /*12P*/ statement
	| DO statement WHILE '(' /*15P*/ comma_expression ')' ';'
	| DO statement WHILE '(' /*15P*/ comma_expression ')' ELSE /*12P*/ statement
	| FOR '(' /*15P*/ ')' statement %prec THEN /*1P*/
	| FOR '(' /*15P*/ ')' statement ELSE /*12P*/ statement
	| FOR '(' /*15P*/ for_control_expression_list ')' statement %prec THEN /*1P*/
	| FOR '(' /*15P*/ for_control_expression_list ')' statement ELSE /*12P*/ statement
	;

for_control_expression_list :
	for_control_expression
	| for_control_expression_list ':' for_control_expression
	;

for_control_expression :
	';' comma_expression_opt ';' comma_expression_opt
	| comma_expression ';' comma_expression_opt ';' comma_expression_opt
	| declaration comma_expression_opt ';' comma_expression_opt
	| '@' ';' comma_expression
	| '@' ';' comma_expression ';' comma_expression
	| comma_expression
	| downupdowneq comma_expression
	| comma_expression updowneq comma_expression
	| '@' updowneq comma_expression
	| comma_expression updowneq '@'
	| comma_expression updowneq comma_expression '~' comma_expression
	| '@' updowneq comma_expression '~' comma_expression
	| comma_expression updowneq '@' '~' comma_expression
	| comma_expression updowneq comma_expression '~' '@'
	| '@' updowneq '@'
	| '@' updowneq comma_expression '~' '@'
	| comma_expression updowneq '@' '~' '@'
	| '@' updowneq '@' '~' '@'
	| comma_expression ';' comma_expression
	| comma_expression ';' downupdowneq comma_expression
	| comma_expression ';' comma_expression updowneq comma_expression
	| comma_expression ';' '@' updowneq comma_expression
	| comma_expression ';' comma_expression updowneq '@'
	| comma_expression ';' '@' updowneq '@'
	| comma_expression ';' comma_expression updowneq comma_expression '~' comma_expression
	| comma_expression ';' '@' updowneq comma_expression '~' comma_expression
	| comma_expression ';' comma_expression updowneq '@' '~' comma_expression
	| comma_expression ';' comma_expression updowneq comma_expression '~' '@'
	| comma_expression ';' '@' updowneq comma_expression '~' '@'
	| comma_expression ';' comma_expression updowneq '@' '~' '@'
	| comma_expression ';' '@' updowneq '@' '~' '@'
	| declaration comma_expression
	| declaration downupdowneq comma_expression
	| declaration comma_expression updowneq comma_expression
	| declaration '@' updowneq comma_expression
	| declaration comma_expression updowneq '@'
	| declaration comma_expression updowneq comma_expression '~' comma_expression
	| declaration '@' updowneq comma_expression '~' comma_expression
	| declaration comma_expression updowneq '@' '~' comma_expression
	| declaration comma_expression updowneq comma_expression '~' '@'
	| declaration '@' updowneq comma_expression '~' '@'
	| declaration comma_expression updowneq '@' '~' '@'
	| declaration '@' updowneq '@' '~' '@'
	| comma_expression ';' type_type_specifier
	| comma_expression ';' downupdowneq enum_key
	;

enum_key :
	type_name
	| ENUM identifier
	| ENUM type_name
	;

downupdowneq :
	ErangeUp
	| ErangeDown
	| ErangeUpEq
	| ErangeDownEq
	;

updown :
	'~'
	| ErangeUp
	| ErangeDown
	;

updowneq :
	updown
	| ErangeUpEq
	| ErangeDownEq
	;

jump_statement :
	GOTO identifier_or_type_name ';'
	| GOTO '*' comma_expression ';'
	| fall_through_name ';'
	| fall_through_name identifier_or_type_name ';'
	| fall_through_name DEFAULT ';'
	| CONTINUE ';'
	| CONTINUE identifier_or_type_name ';'
	| BREAK ';'
	| BREAK identifier_or_type_name ';'
	| RETURN comma_expression_opt ';'
	| RETURN '{' initializer_list_opt comma_opt '}' /*14P*/ ';'
	| SUSPEND ';'
	| SUSPEND compound_statement
	| SUSPEND COROUTINE ';'
	| SUSPEND COROUTINE compound_statement
	| SUSPEND GENERATOR ';'
	| SUSPEND GENERATOR compound_statement
	| THROW assignment_expression_opt ';'
	| THROWRESUME assignment_expression_opt ';'
	| THROWRESUME assignment_expression_opt '@' assignment_expression ';'
	;

fall_through_name :
	FALLTHRU
	| FALLTHROUGH
	;

with_statement :
	WITH '(' /*15P*/ type_list ')' statement
	;

mutex_statement :
	MUTEX '(' /*15P*/ argument_expression_list_opt ')' statement
	;

when_clause :
	WHEN '(' /*15P*/ comma_expression ')'
	;

when_clause_opt :
	/*empty*/
	| when_clause
	;

cast_expression_list :
	cast_expression
	| cast_expression_list ',' cast_expression
	;

timeout :
	TIMEOUT /*6P*/ '(' /*15P*/ comma_expression ')'
	;

wor :
	OROR /*4P*/
	| WOR /*5P*/
	;

waitfor :
	WAITFOR '(' /*15P*/ cast_expression ')'
	| WAITFOR '(' /*15P*/ cast_expression_list ':' argument_expression_list_opt ')'
	;

wor_waitfor_clause :
	when_clause_opt waitfor statement %prec THEN /*1P*/
	| wor_waitfor_clause wor when_clause_opt waitfor statement
	| wor_waitfor_clause wor when_clause_opt ELSE /*12P*/ statement
	| wor_waitfor_clause wor when_clause_opt timeout statement %prec THEN /*1P*/
	| wor_waitfor_clause wor when_clause_opt timeout statement wor ELSE /*12P*/ statement
	| wor_waitfor_clause wor when_clause_opt timeout statement wor when_clause ELSE /*12P*/ statement
	;

waitfor_statement :
	wor_waitfor_clause %prec THEN /*1P*/
	;

wand :
	ANDAND /*2P*/
	| WAND /*3P*/
	;

waituntil :
	WAITUNTIL '(' /*15P*/ comma_expression ')'
	;

waituntil_clause :
	when_clause_opt waituntil statement
	| '(' /*15P*/ wor_waituntil_clause ')'
	;

wand_waituntil_clause :
	waituntil_clause %prec THEN /*1P*/
	| waituntil_clause wand wand_waituntil_clause
	;

wor_waituntil_clause :
	wand_waituntil_clause
	| wor_waituntil_clause wor wand_waituntil_clause
	| wor_waituntil_clause wor when_clause_opt ELSE /*12P*/ statement
	;

waituntil_statement :
	wor_waituntil_clause %prec THEN /*1P*/
	;

corun_statement :
	CORUN statement
	;

cofor_statement :
	COFOR '(' /*15P*/ for_control_expression_list ')' statement
	;

exception_statement :
	TRY compound_statement handler_clause %prec THEN /*1P*/
	| TRY compound_statement finally_clause
	| TRY compound_statement handler_clause finally_clause
	;

handler_clause :
	handler_key '(' /*15P*/ push exception_declaration pop handler_predicate_opt ')' compound_statement
	| handler_clause handler_key '(' /*15P*/ push exception_declaration pop handler_predicate_opt ')' compound_statement
	;

handler_predicate_opt :
	/*empty*/
	| ';' conditional_expression
	;

handler_key :
	CATCH /*7P*/
	| RECOVER /*8P*/
	| CATCHRESUME /*9P*/
	| FIXUP /*10P*/
	;

finally_clause :
	FINALLY /*11P*/ compound_statement
	;

exception_declaration :
	type_specifier_nobody
	| type_specifier_nobody declarator
	| type_specifier_nobody variable_abstract_declarator
	| cfa_abstract_declarator_tuple identifier
	| cfa_abstract_declarator_tuple
	;

enable_disable_statement :
	enable_disable_key identifier_list compound_statement
	;

enable_disable_key :
	ENABLE
	| DISABLE
	;

asm_statement :
	ASM asm_volatile_opt '(' /*15P*/ string_literal ')' ';'
	| ASM asm_volatile_opt '(' /*15P*/ string_literal ':' asm_operands_opt ')' ';'
	| ASM asm_volatile_opt '(' /*15P*/ string_literal ':' asm_operands_opt ':' asm_operands_opt ')' ';'
	| ASM asm_volatile_opt '(' /*15P*/ string_literal ':' asm_operands_opt ':' asm_operands_opt ':' asm_clobbers_list_opt ')' ';'
	| ASM asm_volatile_opt GOTO '(' /*15P*/ string_literal ':' ':' asm_operands_opt ':' asm_clobbers_list_opt ':' label_list ')' ';'
	;

asm_volatile_opt :
	/*empty*/
	| VOLATILE
	;

asm_operands_opt :
	/*empty*/
	| asm_operands_list
	;

asm_operands_list :
	asm_operand
	| asm_operands_list ',' asm_operand
	;

asm_operand :
	string_literal '(' /*15P*/ constant_expression ')'
	| '[' IDENTIFIER ']' string_literal '(' /*15P*/ constant_expression ')'
	;

asm_clobbers_list_opt :
	/*empty*/
	| string_literal
	| asm_clobbers_list_opt ',' string_literal
	;

label_list :
	identifier
	| label_list ',' identifier
	;

declaration_list_opt :
	/*empty*/
	| declaration_list
	;

declaration_list :
	declaration
	| declaration_list declaration
	;

KR_parameter_list_opt :
	/*empty*/
	| KR_parameter_list
	;

KR_parameter_list :
	c_declaration ';'
	| KR_parameter_list c_declaration ';'
	;

local_label_declaration_opt :
	/*empty*/
	| local_label_declaration_list
	;

local_label_declaration_list :
	LABEL local_label_list ';'
	| local_label_declaration_list LABEL local_label_list ';'
	;

local_label_list :
	identifier_or_type_name
	| local_label_list ',' identifier_or_type_name
	;

declaration :
	c_declaration ';'
	| cfa_declaration ';'
	| static_assert
	;

static_assert :
	STATICASSERT '(' /*15P*/ constant_expression ',' string_literal ')' ';'
	| STATICASSERT '(' /*15P*/ constant_expression ')' ';'
	;

cfa_declaration :
	cfa_variable_declaration
	| cfa_typedef_declaration
	| cfa_function_declaration
	| type_declaring_list
	| trait_specifier
	;

cfa_variable_declaration :
	cfa_variable_specifier initializer_opt
	| declaration_qualifier_list cfa_variable_specifier initializer_opt
	| cfa_variable_declaration pop ',' push identifier_or_type_name initializer_opt
	;

cfa_variable_specifier :
	cfa_abstract_declarator_no_tuple identifier_or_type_name asm_name_opt
	| cfa_abstract_tuple identifier_or_type_name asm_name_opt
	| type_qualifier_list cfa_abstract_tuple identifier_or_type_name asm_name_opt
	| cfa_function_return asm_name_opt
	| type_qualifier_list cfa_function_return asm_name_opt
	;

cfa_function_declaration :
	cfa_function_specifier
	| type_qualifier_list cfa_function_specifier
	| declaration_qualifier_list cfa_function_specifier
	| declaration_qualifier_list type_qualifier_list cfa_function_specifier
	| cfa_function_declaration ',' identifier_or_type_name '(' /*15P*/ push cfa_parameter_list_ellipsis_opt pop ')'
	;

cfa_function_specifier :
	'[' ']' identifier '(' /*15P*/ push cfa_parameter_list_ellipsis_opt pop ')' attribute_list_opt
	| '[' ']' TYPEDEFname '(' /*15P*/ push cfa_parameter_list_ellipsis_opt pop ')' attribute_list_opt
	| cfa_abstract_tuple identifier_or_type_name '(' /*15P*/ push cfa_parameter_list_ellipsis_opt pop ')' attribute_list_opt
	| cfa_function_return identifier_or_type_name '(' /*15P*/ push cfa_parameter_list_ellipsis_opt pop ')' attribute_list_opt
	;

cfa_function_return :
	'[' push cfa_parameter_list pop ']'
	| '[' push cfa_parameter_list ',' cfa_abstract_parameter_list pop ']'
	;

cfa_typedef_declaration :
	TYPEDEF cfa_variable_specifier
	| TYPEDEF cfa_function_specifier
	| cfa_typedef_declaration ',' identifier
	;

typedef_declaration :
	TYPEDEF type_specifier declarator
	| typedef_declaration ',' declarator
	| type_qualifier_list TYPEDEF type_specifier declarator
	| type_specifier TYPEDEF declarator
	| type_specifier TYPEDEF type_qualifier_list declarator
	;

typedef_expression :
	TYPEDEF identifier '=' assignment_expression
	| typedef_expression ',' identifier '=' assignment_expression
	;

c_declaration :
	declaration_specifier declaring_list
	| typedef_declaration
	| typedef_expression
	| sue_declaration_specifier
	;

declaring_list :
	variable_declarator asm_name_opt initializer_opt
	| variable_type_redeclarator asm_name_opt initializer_opt
	| general_function_declarator asm_name_opt
	| general_function_declarator asm_name_opt '=' VOID
	| declaring_list ',' attribute_list_opt declarator asm_name_opt initializer_opt
	;

general_function_declarator :
	function_type_redeclarator
	| function_declarator
	;

declaration_specifier :
	basic_declaration_specifier
	| type_declaration_specifier
	| sue_declaration_specifier
	| sue_declaration_specifier invalid_types
	;

invalid_types :
	aggregate_key
	| basic_type_name
	| indirect_type
	;

declaration_specifier_nobody :
	basic_declaration_specifier
	| sue_declaration_specifier_nobody
	| type_declaration_specifier
	;

type_specifier :
	basic_type_specifier
	| sue_type_specifier
	| type_type_specifier
	;

type_specifier_nobody :
	basic_type_specifier
	| sue_type_specifier_nobody
	| type_type_specifier
	;

type_qualifier_list_opt :
	/*empty*/
	| type_qualifier_list
	;

type_qualifier_list :
	type_qualifier
	| type_qualifier_list type_qualifier
	;

type_qualifier :
	type_qualifier_name
	| attribute
	;

type_qualifier_name :
	CONST
	| RESTRICT
	| VOLATILE
	| ATOMIC
	| forall
	;

forall :
	FORALL '(' /*15P*/ type_parameter_list ')'
	;

declaration_qualifier_list :
	storage_class_list
	| type_qualifier_list storage_class_list
	| declaration_qualifier_list type_qualifier_list storage_class_list
	;

storage_class_list :
	storage_class
	| storage_class_list storage_class
	;

storage_class :
	EXTERN
	| STATIC
	| AUTO
	| REGISTER
	| THREADLOCALGCC
	| THREADLOCALC11
	| INLINE
	| FORTRAN
	| NORETURN
	;

basic_type_name :
	basic_type_name_type
	;

basic_type_name_type :
	VOID
	| BOOL
	| CHAR
	| INT
	| INT128
	| UINT128
	| FLOAT
	| DOUBLE
	| uuFLOAT80
	| uuFLOAT128
	| uFLOAT16
	| uFLOAT32
	| uFLOAT32X
	| uFLOAT64
	| uFLOAT64X
	| uFLOAT128
	| DECIMAL32
	| DECIMAL64
	| DECIMAL128
	| COMPLEX
	| IMAGINARY
	| SIGNED
	| UNSIGNED
	| SHORT
	| LONG
	| VA_LIST
	| AUTO_TYPE
	| vtable
	;

vtable_opt :
	/*empty*/
	| vtable
	;

vtable :
	VTABLE '(' /*15P*/ type_name ')' default_opt
	;

default_opt :
	/*empty*/
	| DEFAULT
	;

basic_declaration_specifier :
	basic_type_specifier
	| declaration_qualifier_list basic_type_specifier
	| basic_declaration_specifier storage_class
	| basic_declaration_specifier storage_class type_qualifier_list
	| basic_declaration_specifier storage_class basic_type_specifier
	;

basic_type_specifier :
	direct_type
	| type_qualifier_list_opt indirect_type type_qualifier_list_opt
	;

direct_type :
	basic_type_name
	| type_qualifier_list basic_type_name
	| direct_type type_qualifier
	| direct_type basic_type_name
	;

indirect_type :
	TYPEOF '(' /*15P*/ type ')'
	| TYPEOF '(' /*15P*/ comma_expression ')'
	| BASETYPEOF '(' /*15P*/ type ')'
	| BASETYPEOF '(' /*15P*/ comma_expression ')'
	| ZERO_T
	| ONE_T
	;

sue_declaration_specifier :
	sue_type_specifier
	| declaration_qualifier_list sue_type_specifier
	| sue_declaration_specifier storage_class
	| sue_declaration_specifier storage_class type_qualifier_list
	;

sue_type_specifier :
	elaborated_type
	| type_qualifier_list elaborated_type
	| sue_type_specifier type_qualifier
	;

sue_declaration_specifier_nobody :
	sue_type_specifier_nobody
	| declaration_qualifier_list sue_type_specifier_nobody
	| sue_declaration_specifier_nobody storage_class
	| sue_declaration_specifier_nobody storage_class type_qualifier_list
	;

sue_type_specifier_nobody :
	elaborated_type_nobody
	| type_qualifier_list elaborated_type_nobody
	| sue_type_specifier_nobody type_qualifier
	;

type_declaration_specifier :
	type_type_specifier
	| declaration_qualifier_list type_type_specifier
	| type_declaration_specifier storage_class
	| type_declaration_specifier storage_class type_qualifier_list
	;

type_type_specifier :
	type_name
	| type_qualifier_list type_name
	| type_type_specifier type_qualifier
	;

type_name :
	TYPEDEFname
	| '.' TYPEDEFname
	| type_name '.' TYPEDEFname
	| typegen_name
	| '.' typegen_name
	| type_name '.' typegen_name
	;

typegen_name :
	TYPEGENname /*13P*/
	| TYPEGENname /*13P*/ '(' /*15P*/ ')'
	| TYPEGENname /*13P*/ '(' /*15P*/ type_list ')'
	;

elaborated_type :
	aggregate_type
	| enum_type
	;

elaborated_type_nobody :
	aggregate_type_nobody
	| enum_type_nobody
	;

aggregate_type :
	aggregate_key attribute_list_opt '{' field_declaration_list_opt '}' /*14P*/ type_parameters_opt
	| aggregate_key attribute_list_opt identifier '{' field_declaration_list_opt '}' /*14P*/ type_parameters_opt
	| aggregate_key attribute_list_opt TYPEDEFname '{' field_declaration_list_opt '}' /*14P*/ type_parameters_opt
	| aggregate_key attribute_list_opt TYPEGENname /*13P*/ '{' field_declaration_list_opt '}' /*14P*/ type_parameters_opt
	| aggregate_type_nobody
	;

type_parameters_opt :
	%prec '}' /*14P*/ /*empty*/
	| '(' /*15P*/ type_list ')'
	;

aggregate_type_nobody :
	aggregate_key attribute_list_opt identifier
	| aggregate_key attribute_list_opt type_name
	;

aggregate_key :
	aggregate_data
	| aggregate_control
	;

aggregate_data :
	STRUCT vtable_opt
	| UNION
	| EXCEPTION
	;

aggregate_control :
	MONITOR
	| MUTEX STRUCT
	| GENERATOR
	| MUTEX GENERATOR
	| COROUTINE
	| MUTEX COROUTINE
	| THREAD
	| MUTEX THREAD
	;

field_declaration_list_opt :
	/*empty*/
	| field_declaration_list_opt field_declaration
	;

field_declaration :
	type_specifier field_declaring_list_opt ';'
	| type_specifier field_declaring_list_opt '}' /*14P*/
	| EXTENSION type_specifier field_declaring_list_opt ';'
	| STATIC type_specifier field_declaring_list_opt ';'
	| INLINE type_specifier field_abstract_list_opt ';'
	| INLINE aggregate_control ';'
	| typedef_declaration ';'
	| cfa_field_declaring_list ';'
	| EXTENSION cfa_field_declaring_list ';'
	| INLINE cfa_field_abstract_list ';'
	| cfa_typedef_declaration ';'
	| static_assert
	;

field_declaring_list_opt :
	/*empty*/
	| field_declarator
	| field_declaring_list_opt ',' attribute_list_opt field_declarator
	;

field_declarator :
	bit_subrange_size
	| variable_declarator bit_subrange_size_opt
	| variable_type_redeclarator bit_subrange_size_opt
	| function_type_redeclarator bit_subrange_size_opt
	;

field_abstract_list_opt :
	/*empty*/
	| field_abstract
	| field_abstract_list_opt ',' attribute_list_opt field_abstract
	;

field_abstract :
	variable_abstract_declarator
	;

cfa_field_declaring_list :
	cfa_abstract_declarator_tuple identifier_or_type_name
	| cfa_field_declaring_list ',' identifier_or_type_name
	;

cfa_field_abstract_list :
	cfa_abstract_declarator_tuple
	| cfa_field_abstract_list ','
	;

bit_subrange_size_opt :
	/*empty*/
	| bit_subrange_size
	;

bit_subrange_size :
	':' assignment_expression
	;

enum_type :
	ENUM attribute_list_opt hide_opt '{' enumerator_list comma_opt '}' /*14P*/
	| ENUM enumerator_type attribute_list_opt hide_opt '{' enumerator_list comma_opt '}' /*14P*/
	| ENUM attribute_list_opt identifier hide_opt '{' enumerator_list comma_opt '}' /*14P*/
	| ENUM attribute_list_opt typedef_name hide_opt '{' enumerator_list comma_opt '}' /*14P*/
	| ENUM enumerator_type attribute_list_opt identifier attribute_list_opt hide_opt '{' enumerator_list comma_opt '}' /*14P*/
	| ENUM enumerator_type attribute_list_opt typedef_name attribute_list_opt hide_opt '{' enumerator_list comma_opt '}' /*14P*/
	| enum_type_nobody
	;

enumerator_type :
	'(' /*15P*/ ')'
	| '(' /*15P*/ cfa_abstract_parameter_declaration ')'
	;

hide_opt :
	/*empty*/
	| '!'
	;

enum_type_nobody :
	ENUM attribute_list_opt identifier
	| ENUM attribute_list_opt type_name
	;

enumerator_list :
	visible_hide_opt identifier_or_type_name enumerator_value_opt
	| INLINE type_name
	| enumerator_list ',' visible_hide_opt identifier_or_type_name enumerator_value_opt
	| enumerator_list ',' INLINE type_name
	;

visible_hide_opt :
	hide_opt
	| '^'
	;

enumerator_value_opt :
	/*empty*/
	| '=' constant_expression
	| '=' '{' initializer_list_opt comma_opt '}' /*14P*/
	;

parameter_list_ellipsis_opt :
	/*empty*/
	| ELLIPSIS
	| parameter_list
	| parameter_list ',' ELLIPSIS
	;

parameter_list :
	parameter_declaration
	| abstract_parameter_declaration
	| parameter_list ',' parameter_declaration
	| parameter_list ',' abstract_parameter_declaration
	;

cfa_parameter_list_ellipsis_opt :
	/*empty*/
	| ELLIPSIS
	| cfa_parameter_list
	| cfa_abstract_parameter_list
	| cfa_parameter_list ',' cfa_abstract_parameter_list
	| cfa_parameter_list ',' ELLIPSIS
	| cfa_abstract_parameter_list ',' ELLIPSIS
	;

cfa_parameter_list :
	cfa_parameter_declaration
	| cfa_abstract_parameter_list ',' cfa_parameter_declaration
	| cfa_parameter_list ',' cfa_parameter_declaration
	| cfa_parameter_list ',' cfa_abstract_parameter_list ',' cfa_parameter_declaration
	;

cfa_abstract_parameter_list :
	cfa_abstract_parameter_declaration
	| cfa_abstract_parameter_list ',' cfa_abstract_parameter_declaration
	;

parameter_declaration :
	declaration_specifier_nobody identifier_parameter_declarator default_initializer_opt
	| declaration_specifier_nobody type_parameter_redeclarator default_initializer_opt
	;

abstract_parameter_declaration :
	declaration_specifier_nobody default_initializer_opt
	| declaration_specifier_nobody abstract_parameter_declarator default_initializer_opt
	;

cfa_parameter_declaration :
	parameter_declaration
	| cfa_identifier_parameter_declarator_no_tuple identifier_or_type_name default_initializer_opt
	| cfa_abstract_tuple identifier_or_type_name default_initializer_opt
	| type_qualifier_list cfa_abstract_tuple identifier_or_type_name default_initializer_opt
	| cfa_function_specifier
	;

cfa_abstract_parameter_declaration :
	abstract_parameter_declaration
	| cfa_identifier_parameter_declarator_no_tuple
	| cfa_abstract_tuple
	| type_qualifier_list cfa_abstract_tuple
	| cfa_abstract_function
	;

identifier_list :
	identifier
	| identifier_list ',' identifier
	;

type_no_function :
	cfa_abstract_declarator_tuple
	| type_specifier
	| type_specifier abstract_declarator
	;

type :
	type_no_function
	| cfa_abstract_function
	;

initializer_opt :
	/*empty*/
	| simple_assignment_operator initializer
	| '=' VOID
	| '{' initializer_list_opt comma_opt '}' /*14P*/
	;

initializer :
	assignment_expression
	| '{' initializer_list_opt comma_opt '}' /*14P*/
	;

initializer_list_opt :
	/*empty*/
	| initializer
	| designation initializer
	| initializer_list_opt ',' initializer
	| initializer_list_opt ',' designation initializer
	;

designation :
	designator_list ':'
	| identifier_at ':'
	;

designator_list :
	designator
	| designator_list designator
	;

designator :
	'.' identifier_at
	| '[' push assignment_expression pop ']'
	| '[' push subrange pop ']'
	| '[' push constant_expression ELLIPSIS constant_expression pop ']'
	| '.' '[' push field_name_list pop ']'
	;

type_parameter_list :
	type_parameter
	| type_parameter_list ',' type_parameter
	;

type_initializer_opt :
	/*empty*/
	| '=' type
	;

type_parameter :
	type_class identifier_or_type_name type_initializer_opt assertion_list_opt
	| identifier_or_type_name new_type_class type_initializer_opt assertion_list_opt
	| '[' identifier_or_type_name ']'
	| assertion_list
	| ENUM '(' /*15P*/ identifier_or_type_name ')' identifier_or_type_name new_type_class type_initializer_opt assertion_list_opt
	;

new_type_class :
	/*empty*/
	| '&'
	| '*'
	| ELLIPSIS
	;

type_class :
	OTYPE
	| DTYPE
	| FTYPE
	| TTYPE
	;

assertion_list_opt :
	/*empty*/
	| assertion_list
	;

assertion_list :
	assertion
	| assertion_list assertion
	;

assertion :
	'|' identifier_or_type_name '(' /*15P*/ type_list ')'
	| '|' '{' push trait_declaration_list pop '}' /*14P*/
	;

type_list :
	type
	| assignment_expression
	| type_list ',' type
	| type_list ',' assignment_expression
	;

type_declaring_list :
	OTYPE type_declarator
	| storage_class_list OTYPE type_declarator
	| type_declaring_list ',' type_declarator
	;

type_declarator :
	type_declarator_name assertion_list_opt
	| type_declarator_name assertion_list_opt '=' type
	;

type_declarator_name :
	identifier_or_type_name
	| identifier_or_type_name '(' /*15P*/ type_parameter_list ')'
	;

trait_specifier :
	TRAIT identifier_or_type_name '(' /*15P*/ type_parameter_list ')' '{' '}' /*14P*/
	| forall TRAIT identifier_or_type_name '{' '}' /*14P*/
	| TRAIT identifier_or_type_name '(' /*15P*/ type_parameter_list ')' '{' push trait_declaration_list pop '}' /*14P*/
	| forall TRAIT identifier_or_type_name '{' push trait_declaration_list pop '}' /*14P*/
	;

trait_declaration_list :
	trait_declaration
	| trait_declaration_list pop push trait_declaration
	;

trait_declaration :
	cfa_trait_declaring_list ';'
	| trait_declaring_list ';'
	;

cfa_trait_declaring_list :
	cfa_variable_specifier
	| cfa_function_specifier
	| cfa_trait_declaring_list pop ',' push identifier_or_type_name
	;

trait_declaring_list :
	type_specifier declarator
	| trait_declaring_list pop ',' push declarator
	;

translation_unit :
	/*empty*/
	| external_definition_list
	;

external_definition_list :
	push external_definition pop
	| external_definition_list push external_definition pop
	;

external_definition_list_opt :
	/*empty*/
	| external_definition_list
	;

up :
	/*empty*/
	;

down :
	/*empty*/
	;

external_definition :
	DIRECTIVE
	| declaration
	| IDENTIFIER IDENTIFIER
	| IDENTIFIER type_qualifier
	| IDENTIFIER storage_class
	| IDENTIFIER basic_type_name
	| IDENTIFIER TYPEDEFname
	| IDENTIFIER TYPEGENname /*13P*/
	| external_function_definition
	| EXTENSION external_definition
	| ASM '(' /*15P*/ string_literal ')' ';'
	| EXTERN STRINGliteral up external_definition down
	| EXTERN STRINGliteral '{' up external_definition_list_opt down '}' /*14P*/
	| type_qualifier_list '{' up external_definition_list_opt down '}' /*14P*/
	| declaration_qualifier_list '{' up external_definition_list_opt down '}' /*14P*/
	| declaration_qualifier_list type_qualifier_list '{' up external_definition_list_opt down '}' /*14P*/
	;

external_function_definition :
	function_definition
	| function_declarator compound_statement
	| KR_function_declarator KR_parameter_list_opt compound_statement
	;

with_clause_opt :
	/*empty*/
	| WITH '(' /*15P*/ type_list ')' attribute_list_opt
	;

function_definition :
	cfa_function_declaration with_clause_opt compound_statement
	| declaration_specifier function_declarator with_clause_opt compound_statement
	| declaration_specifier function_type_redeclarator with_clause_opt compound_statement
	| type_qualifier_list function_declarator with_clause_opt compound_statement
	| declaration_qualifier_list function_declarator with_clause_opt compound_statement
	| declaration_qualifier_list type_qualifier_list function_declarator with_clause_opt compound_statement
	| declaration_specifier KR_function_declarator KR_parameter_list_opt with_clause_opt compound_statement
	| type_qualifier_list KR_function_declarator KR_parameter_list_opt with_clause_opt compound_statement
	| declaration_qualifier_list KR_function_declarator KR_parameter_list_opt with_clause_opt compound_statement
	| declaration_qualifier_list type_qualifier_list KR_function_declarator KR_parameter_list_opt with_clause_opt compound_statement
	;

declarator :
	variable_declarator
	| variable_type_redeclarator
	| function_declarator
	| function_type_redeclarator
	;

subrange :
	constant_expression '~' constant_expression
	;

asm_name_opt :
	/*empty*/
	| ASM '(' /*15P*/ string_literal ')' attribute_list_opt
	;

attribute_list_opt :
	/*empty*/
	| attribute_list
	;

attribute_list :
	attribute
	| attribute_list attribute
	;

attribute :
	ATTRIBUTE '(' /*15P*/ '(' /*15P*/ attribute_name_list ')' ')'
	| ATTRIBUTE '(' /*15P*/ attribute_name_list ')'
	| ATTR '(' /*15P*/ attribute_name_list ')'
	;

attribute_name_list :
	attribute_name
	| attribute_name_list ',' attribute_name
	;

attribute_name :
	/*empty*/
	| attr_name
	| attr_name '(' /*15P*/ argument_expression_list_opt ')'
	;

attr_name :
	identifier_or_type_name
	| FALLTHROUGH
	| CONST
	;

paren_identifier :
	identifier_at
	| '(' /*15P*/ paren_identifier ')'
	;

variable_declarator :
	paren_identifier attribute_list_opt
	| variable_ptr
	| variable_array attribute_list_opt
	| variable_function attribute_list_opt
	;

variable_ptr :
	ptrref_operator variable_declarator
	| ptrref_operator type_qualifier_list variable_declarator
	| '(' /*15P*/ variable_ptr ')' attribute_list_opt
	| '(' /*15P*/ attribute_list variable_ptr ')' attribute_list_opt
	;

variable_array :
	paren_identifier array_dimension
	| '(' /*15P*/ variable_ptr ')' array_dimension
	| '(' /*15P*/ attribute_list variable_ptr ')' array_dimension
	| '(' /*15P*/ variable_array ')' multi_array_dimension
	| '(' /*15P*/ attribute_list variable_array ')' multi_array_dimension
	| '(' /*15P*/ variable_array ')'
	| '(' /*15P*/ attribute_list variable_array ')'
	;

variable_function :
	'(' /*15P*/ variable_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ attribute_list variable_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ variable_function ')'
	| '(' /*15P*/ attribute_list variable_function ')'
	;

function_declarator :
	function_no_ptr attribute_list_opt
	| function_ptr
	| function_array attribute_list_opt
	;

function_no_ptr :
	paren_identifier '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ function_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ attribute_list function_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ function_no_ptr ')'
	| '(' /*15P*/ attribute_list function_no_ptr ')'
	;

function_ptr :
	ptrref_operator function_declarator
	| ptrref_operator type_qualifier_list function_declarator
	| '(' /*15P*/ function_ptr ')' attribute_list_opt
	| '(' /*15P*/ attribute_list function_ptr ')' attribute_list_opt
	;

function_array :
	'(' /*15P*/ function_ptr ')' array_dimension
	| '(' /*15P*/ attribute_list function_ptr ')' array_dimension
	| '(' /*15P*/ function_array ')' multi_array_dimension
	| '(' /*15P*/ attribute_list function_array ')' multi_array_dimension
	| '(' /*15P*/ function_array ')'
	| '(' /*15P*/ attribute_list function_array ')'
	;

KR_function_declarator :
	KR_function_no_ptr
	| KR_function_ptr
	| KR_function_array
	;

KR_function_no_ptr :
	paren_identifier '(' /*15P*/ identifier_list ')'
	| '(' /*15P*/ KR_function_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ attribute_list KR_function_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ KR_function_no_ptr ')'
	| '(' /*15P*/ attribute_list KR_function_no_ptr ')'
	;

KR_function_ptr :
	ptrref_operator KR_function_declarator
	| ptrref_operator type_qualifier_list KR_function_declarator
	| '(' /*15P*/ KR_function_ptr ')'
	| '(' /*15P*/ attribute_list KR_function_ptr ')'
	;

KR_function_array :
	'(' /*15P*/ KR_function_ptr ')' array_dimension
	| '(' /*15P*/ attribute_list KR_function_ptr ')' array_dimension
	| '(' /*15P*/ KR_function_array ')' multi_array_dimension
	| '(' /*15P*/ attribute_list KR_function_array ')' multi_array_dimension
	| '(' /*15P*/ KR_function_array ')'
	| '(' /*15P*/ attribute_list KR_function_array ')'
	;

paren_type :
	typedef_name
	| '(' /*15P*/ paren_type ')'
	;

variable_type_redeclarator :
	paren_type attribute_list_opt
	| variable_type_ptr
	| variable_type_array attribute_list_opt
	| variable_type_function attribute_list_opt
	;

variable_type_ptr :
	ptrref_operator variable_type_redeclarator
	| ptrref_operator type_qualifier_list variable_type_redeclarator
	| '(' /*15P*/ variable_type_ptr ')' attribute_list_opt
	| '(' /*15P*/ attribute_list variable_type_ptr ')' attribute_list_opt
	;

variable_type_array :
	paren_type array_dimension
	| '(' /*15P*/ variable_type_ptr ')' array_dimension
	| '(' /*15P*/ attribute_list variable_type_ptr ')' array_dimension
	| '(' /*15P*/ variable_type_array ')' multi_array_dimension
	| '(' /*15P*/ attribute_list variable_type_array ')' multi_array_dimension
	| '(' /*15P*/ variable_type_array ')'
	| '(' /*15P*/ attribute_list variable_type_array ')'
	;

variable_type_function :
	'(' /*15P*/ variable_type_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ attribute_list variable_type_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ variable_type_function ')'
	| '(' /*15P*/ attribute_list variable_type_function ')'
	;

function_type_redeclarator :
	function_type_no_ptr attribute_list_opt
	| function_type_ptr
	| function_type_array attribute_list_opt
	;

function_type_no_ptr :
	paren_type '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ function_type_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ attribute_list function_type_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ function_type_no_ptr ')'
	| '(' /*15P*/ attribute_list function_type_no_ptr ')'
	;

function_type_ptr :
	ptrref_operator function_type_redeclarator
	| ptrref_operator type_qualifier_list function_type_redeclarator
	| '(' /*15P*/ function_type_ptr ')' attribute_list_opt
	| '(' /*15P*/ attribute_list function_type_ptr ')' attribute_list_opt
	;

function_type_array :
	'(' /*15P*/ function_type_ptr ')' array_dimension
	| '(' /*15P*/ attribute_list function_type_ptr ')' array_dimension
	| '(' /*15P*/ function_type_array ')' multi_array_dimension
	| '(' /*15P*/ attribute_list function_type_array ')' multi_array_dimension
	| '(' /*15P*/ function_type_array ')'
	| '(' /*15P*/ attribute_list function_type_array ')'
	;

identifier_parameter_declarator :
	paren_identifier attribute_list_opt
	| '&' MUTEX paren_identifier attribute_list_opt
	| identifier_parameter_ptr
	| identifier_parameter_array attribute_list_opt
	| identifier_parameter_function attribute_list_opt
	;

identifier_parameter_ptr :
	ptrref_operator identifier_parameter_declarator
	| ptrref_operator type_qualifier_list identifier_parameter_declarator
	| '(' /*15P*/ identifier_parameter_ptr ')' attribute_list_opt
	;

identifier_parameter_array :
	paren_identifier array_parameter_dimension
	| '(' /*15P*/ identifier_parameter_ptr ')' array_dimension
	| '(' /*15P*/ identifier_parameter_array ')' multi_array_dimension
	| '(' /*15P*/ identifier_parameter_array ')'
	;

identifier_parameter_function :
	paren_identifier '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ identifier_parameter_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ identifier_parameter_function ')'
	;

type_parameter_redeclarator :
	typedef_name attribute_list_opt
	| '&' MUTEX typedef_name attribute_list_opt
	| type_parameter_ptr
	| type_parameter_array attribute_list_opt
	| type_parameter_function attribute_list_opt
	;

typedef_name :
	TYPEDEFname
	| TYPEGENname /*13P*/
	;

type_parameter_ptr :
	ptrref_operator type_parameter_redeclarator
	| ptrref_operator type_qualifier_list type_parameter_redeclarator
	| '(' /*15P*/ type_parameter_ptr ')' attribute_list_opt
	;

type_parameter_array :
	typedef_name array_parameter_dimension
	| '(' /*15P*/ type_parameter_ptr ')' array_parameter_dimension
	;

type_parameter_function :
	typedef_name '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ type_parameter_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	;

abstract_declarator :
	abstract_ptr
	| abstract_array attribute_list_opt
	| abstract_function attribute_list_opt
	;

abstract_ptr :
	ptrref_operator
	| ptrref_operator type_qualifier_list
	| ptrref_operator abstract_declarator
	| ptrref_operator type_qualifier_list abstract_declarator
	| '(' /*15P*/ abstract_ptr ')' attribute_list_opt
	;

abstract_array :
	array_dimension
	| '(' /*15P*/ abstract_ptr ')' array_dimension
	| '(' /*15P*/ abstract_array ')' multi_array_dimension
	| '(' /*15P*/ abstract_array ')'
	;

abstract_function :
	'(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ abstract_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ abstract_function ')'
	;

array_dimension :
	'[' ']'
	| '[' ']' multi_array_dimension
	| '[' push assignment_expression pop ',' comma_expression ']'
	| '[' push array_type_list pop ']'
	| multi_array_dimension
	;

array_type_list :
	basic_type_name
	| type_name
	| assignment_expression upupeq assignment_expression
	| array_type_list ',' basic_type_name
	| array_type_list ',' type_name
	| array_type_list ',' assignment_expression upupeq assignment_expression
	;

upupeq :
	'~'
	| ErangeUpEq
	;

multi_array_dimension :
	'[' push assignment_expression pop ']'
	| '[' push '*' pop ']'
	| multi_array_dimension '[' push assignment_expression pop ']'
	| multi_array_dimension '[' push '*' pop ']'
	;

abstract_parameter_declarator_opt :
	/*empty*/
	| abstract_parameter_declarator
	;

abstract_parameter_declarator :
	abstract_parameter_ptr
	| '&' MUTEX attribute_list_opt
	| abstract_parameter_array attribute_list_opt
	| abstract_parameter_function attribute_list_opt
	;

abstract_parameter_ptr :
	ptrref_operator
	| ptrref_operator type_qualifier_list
	| ptrref_operator abstract_parameter_declarator
	| ptrref_operator type_qualifier_list abstract_parameter_declarator
	| '(' /*15P*/ abstract_parameter_ptr ')' attribute_list_opt
	;

abstract_parameter_array :
	array_parameter_dimension
	| '(' /*15P*/ abstract_parameter_ptr ')' array_parameter_dimension
	| '(' /*15P*/ abstract_parameter_array ')' multi_array_dimension
	| '(' /*15P*/ abstract_parameter_array ')'
	;

abstract_parameter_function :
	'(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ abstract_parameter_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ abstract_parameter_function ')'
	;

array_parameter_dimension :
	array_parameter_1st_dimension
	| array_parameter_1st_dimension multi_array_dimension
	| multi_array_dimension
	;

array_parameter_1st_dimension :
	'[' ']'
	| '[' push type_qualifier_list '*' pop ']'
	| '[' push type_qualifier_list pop ']'
	| '[' push type_qualifier_list assignment_expression pop ']'
	| '[' push STATIC type_qualifier_list_opt assignment_expression pop ']'
	| '[' push type_qualifier_list STATIC assignment_expression pop ']'
	;

variable_abstract_declarator :
	variable_abstract_ptr
	| variable_abstract_array attribute_list_opt
	| variable_abstract_function attribute_list_opt
	;

variable_abstract_ptr :
	ptrref_operator
	| ptrref_operator type_qualifier_list
	| ptrref_operator variable_abstract_declarator
	| ptrref_operator type_qualifier_list variable_abstract_declarator
	| '(' /*15P*/ variable_abstract_ptr ')' attribute_list_opt
	;

variable_abstract_array :
	array_dimension
	| '(' /*15P*/ variable_abstract_ptr ')' array_dimension
	| '(' /*15P*/ variable_abstract_array ')' multi_array_dimension
	| '(' /*15P*/ variable_abstract_array ')'
	;

variable_abstract_function :
	'(' /*15P*/ variable_abstract_ptr ')' '(' /*15P*/ parameter_list_ellipsis_opt ')'
	| '(' /*15P*/ variable_abstract_function ')'
	;

cfa_identifier_parameter_declarator_tuple :
	cfa_identifier_parameter_declarator_no_tuple
	| cfa_abstract_tuple
	| type_qualifier_list cfa_abstract_tuple
	;

cfa_identifier_parameter_declarator_no_tuple :
	cfa_identifier_parameter_ptr
	| cfa_identifier_parameter_array
	;

cfa_identifier_parameter_ptr :
	ptrref_operator type_specifier_nobody
	| type_qualifier_list ptrref_operator type_specifier_nobody
	| ptrref_operator cfa_abstract_function
	| type_qualifier_list ptrref_operator cfa_abstract_function
	| ptrref_operator cfa_identifier_parameter_declarator_tuple
	| type_qualifier_list ptrref_operator cfa_identifier_parameter_declarator_tuple
	;

cfa_identifier_parameter_array :
	'[' ']' type_specifier_nobody
	| cfa_array_parameter_1st_dimension type_specifier_nobody
	| '[' ']' multi_array_dimension type_specifier_nobody
	| cfa_array_parameter_1st_dimension multi_array_dimension type_specifier_nobody
	| multi_array_dimension type_specifier_nobody
	| '[' ']' cfa_identifier_parameter_ptr
	| cfa_array_parameter_1st_dimension cfa_identifier_parameter_ptr
	| '[' ']' multi_array_dimension cfa_identifier_parameter_ptr
	| cfa_array_parameter_1st_dimension multi_array_dimension cfa_identifier_parameter_ptr
	| multi_array_dimension cfa_identifier_parameter_ptr
	;

cfa_array_parameter_1st_dimension :
	'[' push type_qualifier_list '*' pop ']'
	| '[' push type_qualifier_list assignment_expression pop ']'
	| '[' push declaration_qualifier_list assignment_expression pop ']'
	| '[' push declaration_qualifier_list type_qualifier_list assignment_expression pop ']'
	;

cfa_abstract_declarator_tuple :
	cfa_abstract_tuple
	| type_qualifier_list cfa_abstract_tuple
	| cfa_abstract_declarator_no_tuple
	;

cfa_abstract_declarator_no_tuple :
	cfa_abstract_ptr
	| cfa_abstract_array
	;

cfa_abstract_ptr :
	ptrref_operator type_specifier
	| type_qualifier_list ptrref_operator type_specifier
	| ptrref_operator cfa_abstract_function
	| type_qualifier_list ptrref_operator cfa_abstract_function
	| ptrref_operator cfa_abstract_declarator_tuple
	| type_qualifier_list ptrref_operator cfa_abstract_declarator_tuple
	;

cfa_abstract_array :
	'[' ']' type_specifier
	| '[' ']' multi_array_dimension type_specifier
	| multi_array_dimension type_specifier
	| '[' ']' cfa_abstract_ptr
	| '[' ']' multi_array_dimension cfa_abstract_ptr
	| multi_array_dimension cfa_abstract_ptr
	;

cfa_abstract_tuple :
	'[' push cfa_abstract_parameter_list pop ']'
	| '[' push type_specifier_nobody ELLIPSIS pop ']'
	| '[' push type_specifier_nobody ELLIPSIS constant_expression pop ']'
	;

cfa_abstract_function :
	'[' ']' '(' /*15P*/ cfa_parameter_list_ellipsis_opt ')'
	| cfa_abstract_tuple '(' /*15P*/ push cfa_parameter_list_ellipsis_opt pop ')'
	| cfa_function_return '(' /*15P*/ push cfa_parameter_list_ellipsis_opt pop ')'
	;

comma_opt :
	/*empty*/
	| ','
	;

default_initializer_opt :
	/*empty*/
	| '=' assignment_expression
	;

%%

//%x COMMENT
//%x BKQUOTE
%x QUOTE
%x STRING

binary [0-1]
octal [0-7]
nonzero [1-9]
decimal [0-9]
hex [0-9a-fA-F]

// numeric constants, CFA: '_' in constant
hex_quad {hex}("_"?{hex}){3}
size_opt (8|16|32|64|128)?

universal_char "\\"((u"_"?{hex_quad})|(U"_"?{hex_quad}{2}))

// identifier, GCC: $ in identifier
identifier ([a-zA-Z_$]|{universal_char})([0-9a-zA-Z_$]|{universal_char})*

// CFA: explicit l8/l16/l32/l64/l128, char 'hh', short 'h', int 'n'
length ("ll"|"LL"|[lL]{size_opt})|("hh"|"HH"|[hHnN])

// CFA: size_t 'z', pointer 'p', which define a sign and length
integer_suffix_opt ("_"?(([uU]({length}?[iI]?)|([iI]{length}))|([iI]({length}?[uU]?)|([uU]{length}))|({length}([iI]?[uU]?)|([uU][iI]))|[zZ]|[pP]))?

octal_digits ({octal})|({octal}({octal}|"_")*{octal})
octal_prefix "0""_"?
octal_constant (("0")|({octal_prefix}{octal_digits})){integer_suffix_opt}

nonzero_digits ({nonzero})|({nonzero}({decimal}|"_")*{decimal})
decimal_constant {nonzero_digits}{integer_suffix_opt}

binary_digits ({binary})|({binary}({binary}|"_")*{binary})
binary_prefix "0"[bB]"_"?
binary_constant {binary_prefix}{binary_digits}{integer_suffix_opt}

hex_digits ({hex})|({hex}({hex}|"_")*{hex})
hex_prefix "0"[xX]"_"?
hex_constant {hex_prefix}{hex_digits}{integer_suffix_opt}

// GCC: floating D (double), imaginary iI, and decimal floating DF, DD, DL
decimal_digits ({decimal})|({decimal}({decimal}|"_")*{decimal})
exponent "_"?[eE]"_"?[+-]?{decimal_digits}
floating_size 16|32|32x|64|64x|80|128|128x
floating_length ([fFdDlLwWqQ]|[fF]{floating_size})
floating_suffix ({floating_length}?[iI]?)|([iI]{floating_length})
decimal_floating_suffix [dD][fFdDlL]
floating_suffix_opt ("_"?({floating_suffix}|{decimal_floating_suffix}))?
floating_decimal {decimal_digits}"."{exponent}?{floating_suffix_opt}
floating_fraction "."{decimal_digits}{exponent}?{floating_suffix_opt}
floating_constant ({decimal_digits}{exponent}{floating_suffix_opt})|({decimal_digits}{floating_fraction})

binary_exponent "_"?[pP]"_"?[+-]?{decimal_digits}
hex_floating_suffix_opt ("_"?({floating_suffix}))?
hex_floating_fraction ({hex_digits}?"."{hex_digits})|({hex_digits}".")
hex_floating_constant {hex_prefix}(({hex_floating_fraction}{binary_exponent})|({hex_digits}{binary_exponent})){hex_floating_suffix_opt}

// character escape sequence, GCC: \e => esc character
simple_escape "\\"[abefnrtv'"?\\]

// ' stop editor highlighting
octal_escape "\\"{octal}("_"?{octal}){0,2}
hex_escape "\\""x""_"?{hex_digits}
escape_seq {simple_escape}|{octal_escape}|{hex_escape}|{universal_char}
cwide_prefix "L"|"U"|"u"
swide_prefix {cwide_prefix}|"u8"

// display/white-space characters
h_tab [\011]
form_feed [\014]
v_tab [\013]
c_return [\015]
h_white [ ]|{h_tab}

// overloadable operators
op_unary_only "~"|"!"
op_unary_binary "+"|"-"|"*"
op_unary_pre_post "++"|"--"
op_unary {op_unary_only}|{op_unary_binary}|{op_unary_pre_post}

op_binary_only "/"|"%"|"\\"|"^"|"&"|"|"|"<"|">"|"="|"=="|"!="|"<<"|">>"|"<="|">="|"+="|"-="|"*="|"/="|"%="|"\\="|"&="|"|="|"^="|"<<="|">>="
op_binary_over {op_unary_binary}|{op_binary_only}
// op_binary_not_over "?"|"->"|"."|"&&"|"||"|"@="
// operator {op_unary_pre_post}|{op_binary_over}|{op_binary_not_over}

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

				/* preprocessor-style directives */
^{h_white}*"#"[^\n]*"\n" DIRECTIVE

				/* punctuation */
"@"			'@'
"`"			'`'
"["			'['
"]"			']'
"("			'('
")"			')'
"{"			'{'
"}"			'}'
","			','						// also operator
":"			':'
";"			';'
"."			'.'						// also operator
"@@"			ATTR				// CFA, attribute shorthand
"..."			ELLIPSIS

				/* alternative C99 brackets, "<:" & "<:<:" handled by preprocessor */
"<:"			'['
":>"			']'
"<%"			'{'
"%>"			'}'

				/* operators */
"!"			'!'
"+"			'+'
"-"			'-'
"*"			'*'
"\\"			'\\'	        					// CFA, exponentiation
"/"			'/'
"%"			'%'
"^"			'^'
"~"			'~'
"&"			'&'
"|"			'|'
"<"			'<'
">"			'>'
"="			'='
"?"			'?'

"++"			ICR
"--"			DECR
"=="			EQ
"!="			NE
"<<"			LS
">>"			RS
"<="			LE
">="			GE
"&&"			ANDAND
"||"			OROR
"->"			ARROW
"+="			PLUSassign
"-="			MINUSassign
"\\="			EXPassign			// CFA, exponentiation
"*="			MULTassign
"/="			DIVassign
"%="			MODassign
"&="			ANDassign
"|="			ORassign
"^="			ERassign
"<<="			LSassign
">>="			RSassign

"@="			ATassign			// CFA
"+~"			ErangeUp			// CFA
"~="			ErangeUpEq			// CFA
"+~="			ErangeUpEq			// CFA
"-~"			ErangeDown			// CFA
"-~="			ErangeDownEq		// CFA

				/* keywords */
//alignas			ALIGNAS			// CFA
//_Alignas		ALIGNAS			// C11
alignof			ALIGNOF			// CFA
_Alignof		ALIGNOF			// C11
__alignof		ALIGNOF			// GCC
__alignof__		ALIGNOF			// GCC
and				WAND				// CFA
asm				ASM
__asm			ASM				// GCC
__asm__			ASM				// GCC
_Atomic			ATOMIC				// C11
__attribute		ATTRIBUTE			// GCC
__attribute__	ATTRIBUTE			// GCC
auto			AUTO
__auto_type		AUTO_TYPE
basetypeof		BASETYPEOF			// CFA
_Bool			BOOL				// C99
break			BREAK
case			CASE
catch			CATCH				// CFA
catchResume		CATCHRESUME		// CFA
char			CHAR
choose			CHOOSE				// CFA
coerce			COERCE				// CFA
corun			CORUN				// CFA
cofor			COFOR				// CFA
_Complex		COMPLEX			// C99
__complex		COMPLEX			// GCC
__complex__		COMPLEX			// GCC
const			CONST
__const			CONST				// GCC
__const__		CONST				// GCC
continue		CONTINUE
coroutine		COROUTINE			// CFA
_Decimal32		DECIMAL32			// GCC
_Decimal64		DECIMAL64			// GCC
_Decimal128		DECIMAL128			// GCC
default			DEFAULT
disable			DISABLE			// CFA
do				DO
double			DOUBLE
dtype			DTYPE				// CFA
else			ELSE
enable			ENABLE				// CFA
enum			ENUM
exception		EXCEPTION			// CFA
__extension__	EXTENSION			// GCC
extern			EXTERN
fallthrough		FALLTHROUGH		// CFA
fallthru		FALLTHRU			// CFA
finally			FINALLY			// CFA
fixup			FIXUP				// CFA
float			FLOAT
__float80		uuFLOAT80			// GCC
float80			uuFLOAT80			// GCC
__float128		uuFLOAT128			// GCC
float128		uuFLOAT128			// GCC
_Float16		uFLOAT16					// GCC
_Float32		uFLOAT32					// GCC
_Float32x		uFLOAT32X					// GCC
_Float64		uFLOAT64					// GCC
_Float64x		uFLOAT64X					// GCC
_Float128		uFLOAT128					// GCC
_Float128x		uFLOAT128					// GCC
for				FOR
forall			FORALL				// CFA
fortran			FORTRAN
ftype			FTYPE				// CFA
generator		GENERATOR			// CFA
_Generic		GENERIC			// C11
goto			GOTO
if				IF
_Imaginary		IMAGINARY			// C99
__imag			IMAGINARY			// GCC
__imag__		IMAGINARY			// GCC
inline			INLINE				// C99
__inline		INLINE				// GCC
__inline__		INLINE				// GCC
int				INT
int128			INT128				// CFA
__int128		INT128				// GCC
__int128_t		INT128				// GCC
__label__		LABEL				// GCC
long			LONG
monitor			MONITOR			// CFA
mutex			MUTEX				// CFA
_Noreturn		NORETURN			// C11
__builtin_offsetof OFFSETOF		// GCC
one_t			ONE_T				// CFA
or				WOR				// CFA
otype			OTYPE				// CFA
recover			RECOVER			// CFA
register		REGISTER
report			THROWRESUME		// CFA
restrict		RESTRICT			// C99
__restrict		RESTRICT			// GCC
__restrict__	RESTRICT			// GCC
return			RETURN
 /* resume			RESUME				// CFA */
short			SHORT
signed			SIGNED
__signed		SIGNED				// GCC
__signed__		SIGNED				// GCC
sizeof			SIZEOF
countof			COUNTOF			// GCC
static			STATIC
_Static_assert	STATICASSERT		// C11
static_assert	STATICASSERT		// C23
struct			STRUCT
suspend			SUSPEND			// CFA
switch			SWITCH
thread			THREAD				// C11
__thread		THREADLOCALGCC		// GCC
_Thread_local	THREADLOCALC11		// C11
thread_local	THREADLOCALC11		// C23
throw			THROW				// CFA
throwResume		THROWRESUME		// CFA
timeout			TIMEOUT			// CFA
trait			TRAIT				// CFA
try				TRY				// CFA
ttype			TTYPE				// CFA
typedef			TYPEDEF
typeof			TYPEOF				// GCC
__typeof		TYPEOF				// GCC
__typeof__		TYPEOF				// GCC
typeid			TYPEID				// GCC
union			UNION
__uint128_t		UINT128			// GCC
unsigned		UNSIGNED
__builtin_va_arg VA_ARG			// GCC
__builtin_va_list VA_LIST			// GCC
virtual			VIRTUAL			// CFA
void			VOID
volatile		VOLATILE
__volatile		VOLATILE			// GCC
__volatile__	VOLATILE			// GCC
vtable			VTABLE				// CFA
waitfor			WAITFOR			// CFA
waituntil		WAITUNTIL			// CFA
when			WHEN				// CFA
while			WHILE
with			WITH				// CFA
zero_t			ZERO_T				// CFA

				/* numeric constants */
{binary_constant} INTEGERconstant
{octal_constant} INTEGERconstant
{decimal_constant} INTEGERconstant
{hex_constant}	INTEGERconstant
{floating_decimal}	FLOATING_DECIMALconstant // must appear before floating_constant
{floating_fraction}	FLOATING_FRACTIONconstant // must appear before floating_constant
{floating_constant}	FLOATINGconstant
{hex_floating_constant}	FLOATINGconstant

				/* character constant, allows empty value */
({cwide_prefix}[_]?)?[']<QUOTE>
<QUOTE>[^'\\\n]+<.>
<QUOTE>['\n]<INITIAL>	CHARACTERconstant
				/* ' stop editor highlighting */

				/* string constant */
({swide_prefix}[_]?)?["]<STRING>
<STRING>[^"\\\n]+<.>
<STRING>["\n]<INITIAL>	STRINGliteral
				/* " stop editor highlighting */

				/* common character/string constant */
<QUOTE,STRING>{escape_seq}<.>
<QUOTE,STRING>"\\"{h_white}*"\n"<.>						// continuation (ALSO HANDLED BY CPP)
<QUOTE,STRING>"\\"<.> // unknown escape character

				/* CFA, operator identifier */
{op_unary}"?"	IDENTIFIER				// unary
"?"({op_unary_pre_post}|"()"|"[?]"|"{}") IDENTIFIER
"^?{}"			IDENTIFIER
"?`"{identifier} IDENTIFIER										// postfix operator
	//RETURN_LOCN( typedefTable.isKind( *yylval.tok.str ) );

"?"{op_binary_over}"?"	IDENTIFIER		// binary
	/*
	  This rule handles ambiguous cases with operator identifiers, e.g., "int *?*?()", where the string "*?*?"  can be
	  lexed as "*?"/"*?" or "*"/"?*?". Since it is common practise to put a unary operator juxtaposed to an identifier,
	  e.g., "*i", users will be annoyed if they cannot do this with respect to operator identifiers. Therefore, there is
	  a lexical look-ahead for the second case, with backtracking to return the leading unary operator and then
	  reparsing the trailing operator identifier.  Otherwise a space is needed between the unary operator and operator
	  identifier to disambiguate this common case.

	  A similar issue occurs with the dereference, *?(...), and routine-call, ?()(...) identifiers.  The ambiguity
	  occurs when the deference operator has no parameters, *?() and *?()(...), requiring arbitrary whitespace
	  look-ahead for the routine-call parameter-list to disambiguate.  However, the dereference operator must have a
	  parameter/argument to dereference *?(...).  Hence, always interpreting the string *?() as * ?() does not preclude
	  any meaningful program.

	  The remaining cases are with the increment/decrement operators and conditional expression:

	  i++? ...(...);
	  i?++ ...(...);

	  requiring arbitrary whitespace look-ahead for the operator parameter-list, even though that interpretation is an
      incorrect expression (juxtaposed identifiers).  Therefore, it is necessary to disambiguate these cases with a
      space:

	  i++ ? i : 0;
	  i? ++i : 0;
	*/
//{op_unary}"?"({op_unary_pre_post}|"()"|"[?]"|{op_binary_over}"?") {
//	// 1 or 2 character unary operator ?
//	int i = yytext[1] == '?' ? 1 : 2;
//	yyless( i );		// put back characters up to first '?'
//	if ( i > 1 ) {
//		NAMEDOP_RETURN( yytext[0] == '+' ? ICR : DECR );
//	} else {
//		ASCIIOP_RETURN();
//	} // if
//}


{identifier}	IDENTIFIER
"``"{identifier}	IDENTIFIER

%%
