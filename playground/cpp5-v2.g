//From: https://blog.robertelder.org/jim-roskind-grammar/

%token AUTO
%token DOUBLE
%token INT
%token STRUCT
%token BREAK
%token ELSE
%token LONG
%token SWITCH
%token CASE
%token ENUM
%token REGISTER
%token TYPEDEF
%token CHAR
%token EXTERN
%token RETURN
%token UNION
%token CONST
%token FLOAT
%token SHORT
%token UNSIGNED
%token CONTINUE
%token FOR
%token SIGNED
%token VOID
%token DEFAULT
%token GOTO
%token SIZEOF
%token VOLATILE
%token DO
%token IF
%token STATIC
%token WHILE
%token NEW
%token DELETE
%token THIS
%token OPERATOR
%token CLASS
%token PUBLIC
%token PROTECTED
%token PRIVATE
%token VIRTUAL
%token FRIEND
%token INLINE
%token OVERLOAD
%token IDENTIFIER
%token STRINGliteral
%token FLOATINGconstant
%token INTEGERconstant
%token CHARACTERconstant
%token OCTALconstant
%token HEXconstant
%token TYPEDEFname
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
%token ELLIPSIS
%token CLCL
%token DOTstar
%token ARROWstar
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
%token '('
%token ')'
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token '^'
%token '&'
%token '|'
%token '~'
%token '!'
%token '<'
%token '>'
%token '.'
%token '['
%token ']'
%token ','
%token '?'
%token ':'
%token '='
%token ';'
%token '{'
%token '}'


%start translation_unit

%%

constant :
	 INTEGERconstant
	| FLOATINGconstant
	| OCTALconstant
	| HEXconstant
	| CHARACTERconstant
	;
string_literal_list :
	 STRINGliteral
	| string_literal_list STRINGliteral
	;
paren_identifier_declarator :
	 scope_opt_identifier
	| scope_opt_complex_name
	| '(' paren_identifier_declarator ')'
	;
primary_expression :
	 global_opt_scope_opt_identifier
	| global_opt_scope_opt_complex_name
	| THIS
	| constant
	| string_literal_list
	| '(' comma_expression ')'
	;
non_elaborating_type_specifier :
	 sue_type_specifier
	| basic_type_specifier
	| typedef_type_specifier
	| basic_type_name
	| TYPEDEFname
	| global_or_scoped_typedefname
	;
operator_function_name :
	 OPERATOR any_operator
	| OPERATOR type_qualifier_list operator_function_ptr_opt
	| OPERATOR non_elaborating_type_specifier operator_function_ptr_opt
	;
operator_function_ptr_opt :
	 /*empty*/
	| unary_modifier operator_function_ptr_opt
	| asterisk_or_ampersand operator_function_ptr_opt
	;
any_operator :
	 '+'
	| '-'
	| '*'
	| '/'
	| '%'
	| '^'
	| '&'
	| '|'
	| '~'
	| '!'
	| '<'
	| '>'
	| LS
	| RS
	| ANDAND
	| OROR
	| ARROW
	| ARROWstar
	| '.'
	| DOTstar
	| ICR
	| DECR
	| LE
	| GE
	| EQ
	| NE
	| assignment_operator
	| '(' ')'
	| '[' ']'
	| NEW
	| DELETE
	| ','
	;
type_qualifier_list_opt :
	 /*empty*/
	| type_qualifier_list
	;
postfix_expression :
	 primary_expression
	| postfix_expression '[' comma_expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
	;
postfix_expression :
	 postfix_expression '.' member_name
	;
postfix_expression :
	 postfix_expression ARROW member_name
	| postfix_expression ICR
	| postfix_expression DECR
	| TYPEDEFname '(' ')'
	| global_or_scoped_typedefname '(' ')'
	| TYPEDEFname '(' argument_expression_list ')'
	| global_or_scoped_typedefname '(' argument_expression_list ')'
	| basic_type_name '(' assignment_expression ')'
	;
member_name :
	 scope_opt_identifier
	| scope_opt_complex_name
	| basic_type_name CLCL '~' basic_type_name
	| declaration_qualifier_list CLCL '~' declaration_qualifier_list
	| type_qualifier_list CLCL '~' type_qualifier_list
	;
argument_expression_list :
	 assignment_expression
	| argument_expression_list ',' assignment_expression
	;
unary_expression :
	 postfix_expression
	| ICR unary_expression
	| DECR unary_expression
	| asterisk_or_ampersand cast_expression
	| '-' cast_expression
	| '+' cast_expression
	| '~' cast_expression
	| '!' cast_expression
	| SIZEOF unary_expression
	| SIZEOF '(' type_name ')'
	| allocation_expression
	;
allocation_expression :
	 global_opt_scope_opt_operator_new '(' type_name ')' operator_new_initializer_opt
	| global_opt_scope_opt_operator_new '(' argument_expression_list ')' '(' type_name ')' operator_new_initializer_opt
	| global_opt_scope_opt_operator_new operator_new_type
	| global_opt_scope_opt_operator_new '(' argument_expression_list ')' operator_new_type
	;
global_opt_scope_opt_operator_new :
	 NEW
	| global_or_scope NEW
	;
operator_new_type :
	 type_qualifier_list operator_new_declarator_opt operator_new_initializer_opt
	| non_elaborating_type_specifier operator_new_declarator_opt operator_new_initializer_opt
	;
operator_new_declarator_opt :
	 /*empty*/
	| operator_new_array_declarator
	| asterisk_or_ampersand operator_new_declarator_opt
	| unary_modifier operator_new_declarator_opt
	;
operator_new_array_declarator :
	 '[' ']'
	| '[' comma_expression ']'
	| operator_new_array_declarator '[' comma_expression ']'
	;
operator_new_initializer_opt :
	 /*empty*/
	| '(' ')'
	| '(' argument_expression_list ')'
	;
cast_expression :
	 unary_expression
	| '(' type_name ')' cast_expression
	;
deallocation_expression :
	 cast_expression
	| global_opt_scope_opt_delete deallocation_expression
	| global_opt_scope_opt_delete '[' comma_expression ']' deallocation_expression
	| global_opt_scope_opt_delete '[' ']' deallocation_expression
	;
global_opt_scope_opt_delete :
	 DELETE
	| global_or_scope DELETE
	;
point_member_expression :
	 deallocation_expression
	| point_member_expression DOTstar deallocation_expression
	| point_member_expression ARROWstar deallocation_expression
	;
multiplicative_expression :
	 point_member_expression
	| multiplicative_expression '*' point_member_expression
	| multiplicative_expression '/' point_member_expression
	| multiplicative_expression '%' point_member_expression
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
	| logical_AND_expression ANDAND inclusive_OR_expression
	;
logical_OR_expression :
	 logical_AND_expression
	| logical_OR_expression OROR logical_AND_expression
	;
conditional_expression :
	 logical_OR_expression
	| logical_OR_expression '?' comma_expression ':' conditional_expression
	;
assignment_expression :
	 conditional_expression
	| unary_expression assignment_operator assignment_expression
	;
assignment_operator :
	 '='
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
comma_expression :
	 assignment_expression
	| comma_expression ',' assignment_expression
	;
constant_expression :
	 conditional_expression
	;
comma_expression_opt :
	 /*empty*/
	| comma_expression
	;
declaration :
	 declaring_list ';'
	| default_declaring_list ';'
	| sue_declaration_specifier ';'
	| sue_type_specifier ';'
	| sue_type_specifier_elaboration ';'
	;
default_declaring_list :
	 declaration_qualifier_list identifier_declarator initializer_opt
	;
default_declaring_list :
	 type_qualifier_list identifier_declarator initializer_opt
	;
default_declaring_list :
	 default_declaring_list ',' identifier_declarator initializer_opt
	| declaration_qualifier_list constructed_identifier_declarator
	| type_qualifier_list constructed_identifier_declarator
	| default_declaring_list ',' constructed_identifier_declarator
	;
declaring_list :
	 declaration_specifier declarator initializer_opt
	;
declaring_list :
	 type_specifier declarator initializer_opt
	;
declaring_list :
	 basic_type_name declarator initializer_opt
	;
declaring_list :
	 TYPEDEFname declarator initializer_opt
	;
declaring_list :
	 global_or_scoped_typedefname declarator initializer_opt
	;
declaring_list :
	 declaring_list ',' declarator initializer_opt
	| declaration_specifier constructed_declarator
	| type_specifier constructed_declarator
	| basic_type_name constructed_declarator
	| TYPEDEFname constructed_declarator
	| global_or_scoped_typedefname constructed_declarator
	| declaring_list ',' constructed_declarator
	;
constructed_declarator :
	 nonunary_constructed_identifier_declarator
	| constructed_paren_typedef_declarator
	| simple_paren_typedef_declarator '(' argument_expression_list ')'
	| simple_paren_typedef_declarator postfixing_abstract_declarator '(' argument_expression_list ')'
	| constructed_parameter_typedef_declarator
	| asterisk_or_ampersand constructed_declarator
	| unary_modifier constructed_declarator
	;
constructed_paren_typedef_declarator :
	 '(' paren_typedef_declarator ')' '(' argument_expression_list ')'
	| '(' paren_typedef_declarator ')' postfixing_abstract_declarator '(' argument_expression_list ')'
	| '(' simple_paren_typedef_declarator postfixing_abstract_declarator ')' '(' argument_expression_list ')'
	| '(' TYPEDEFname postfixing_abstract_declarator ')' '(' argument_expression_list ')'
	;
constructed_parameter_typedef_declarator :
	 TYPEDEFname '(' argument_expression_list ')'
	| TYPEDEFname postfixing_abstract_declarator '(' argument_expression_list ')'
	| '(' clean_typedef_declarator ')' '(' argument_expression_list ')'
	| '(' clean_typedef_declarator ')' postfixing_abstract_declarator '(' argument_expression_list ')'
	;
constructed_identifier_declarator :
	 nonunary_constructed_identifier_declarator
	| asterisk_or_ampersand constructed_identifier_declarator
	| unary_modifier constructed_identifier_declarator
	;
nonunary_constructed_identifier_declarator :
	 paren_identifier_declarator '(' argument_expression_list ')'
	| paren_identifier_declarator postfixing_abstract_declarator '(' argument_expression_list ')'
	| '(' unary_identifier_declarator ')' '(' argument_expression_list ')'
	| '(' unary_identifier_declarator ')' postfixing_abstract_declarator '(' argument_expression_list ')'
	;
declaration_specifier :
	 basic_declaration_specifier
	| sue_declaration_specifier
	| typedef_declaration_specifier
	;
type_specifier :
	 basic_type_specifier
	| sue_type_specifier
	| sue_type_specifier_elaboration
	| typedef_type_specifier
	;
declaration_qualifier_list :
	 storage_class
	| type_qualifier_list storage_class
	| declaration_qualifier_list declaration_qualifier
	;
type_qualifier_list :
	 type_qualifier
	| type_qualifier_list type_qualifier
	;
declaration_qualifier :
	 storage_class
	| type_qualifier
	;
type_qualifier :
	 CONST
	| VOLATILE
	;
basic_declaration_specifier :
	 declaration_qualifier_list basic_type_name
	| basic_type_specifier storage_class
	| basic_type_name storage_class
	| basic_declaration_specifier declaration_qualifier
	| basic_declaration_specifier basic_type_name
	;
basic_type_specifier :
	 type_qualifier_list basic_type_name
	| basic_type_name basic_type_name
	| basic_type_name type_qualifier
	| basic_type_specifier type_qualifier
	| basic_type_specifier basic_type_name
	;
sue_declaration_specifier :
	 declaration_qualifier_list elaborated_type_name
	| declaration_qualifier_list elaborated_type_name_elaboration
	| sue_type_specifier storage_class
	| sue_type_specifier_elaboration storage_class
	| sue_declaration_specifier declaration_qualifier
	;
sue_type_specifier_elaboration :
	 elaborated_type_name_elaboration
	| type_qualifier_list elaborated_type_name_elaboration
	| sue_type_specifier_elaboration type_qualifier
	;
sue_type_specifier :
	 elaborated_type_name
	| type_qualifier_list elaborated_type_name
	| sue_type_specifier type_qualifier
	;
typedef_declaration_specifier :
	 declaration_qualifier_list TYPEDEFname
	| declaration_qualifier_list global_or_scoped_typedefname
	| typedef_type_specifier storage_class
	| TYPEDEFname storage_class
	| global_or_scoped_typedefname storage_class
	| typedef_declaration_specifier declaration_qualifier
	;
typedef_type_specifier :
	 type_qualifier_list TYPEDEFname
	| type_qualifier_list global_or_scoped_typedefname
	| TYPEDEFname type_qualifier
	| global_or_scoped_typedefname type_qualifier
	| typedef_type_specifier type_qualifier
	;
storage_class :
	 EXTERN
	| TYPEDEF
	| STATIC
	| AUTO
	| REGISTER
	| FRIEND
	| OVERLOAD
	| INLINE
	| VIRTUAL
	;
basic_type_name :
	 INT
	| CHAR
	| SHORT
	| LONG
	| FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| VOID
	;
elaborated_type_name_elaboration :
	 aggregate_name_elaboration
	| enum_name_elaboration
	;
elaborated_type_name :
	 aggregate_name
	| enum_name
	;
aggregate_name_elaboration :
	 aggregate_name derivation_opt '{' member_declaration_list_opt '}'
	| aggregate_key derivation_opt '{' member_declaration_list_opt '}'
	;
aggregate_name :
	 aggregate_key tag_name
	| global_scope scope aggregate_key tag_name
	| global_scope aggregate_key tag_name
	| scope aggregate_key tag_name
	;
derivation_opt :
	 /*empty*/
	| ':' derivation_list
	;
derivation_list :
	 parent_class
	| derivation_list ',' parent_class
	;
parent_class :
	 global_opt_scope_opt_typedefname
	| VIRTUAL access_specifier_opt global_opt_scope_opt_typedefname
	| access_specifier virtual_opt global_opt_scope_opt_typedefname
	;
virtual_opt :
	 /*empty*/
	| VIRTUAL
	;
access_specifier_opt :
	 /*empty*/
	| access_specifier
	;
access_specifier :
	 PUBLIC
	| PRIVATE
	| PROTECTED
	;
aggregate_key :
	 STRUCT
	| UNION
	| CLASS
	;
member_declaration_list_opt :
	 /*empty*/
	| member_declaration_list_opt member_declaration
	;
member_declaration :
	 member_declaring_list ';'
	| member_default_declaring_list ';'
	| access_specifier ':'
	| new_function_definition
	| constructor_function_in_class
	| sue_type_specifier ';'
	| sue_type_specifier_elaboration ';'
	| identifier_declarator ';'
	| typedef_declaration_specifier ';'
	| sue_declaration_specifier ';'
	;
member_default_declaring_list :
	 type_qualifier_list identifier_declarator member_pure_opt
	| declaration_qualifier_list identifier_declarator member_pure_opt
	| member_default_declaring_list ',' identifier_declarator member_pure_opt
	| type_qualifier_list bit_field_identifier_declarator
	| declaration_qualifier_list bit_field_identifier_declarator
	| member_default_declaring_list ',' bit_field_identifier_declarator
	;
member_declaring_list :
	 type_specifier declarator member_pure_opt
	| basic_type_name declarator member_pure_opt
	| global_or_scoped_typedefname declarator member_pure_opt
	| member_conflict_declaring_item
	| member_declaring_list ',' declarator member_pure_opt
	| type_specifier bit_field_declarator
	| basic_type_name bit_field_declarator
	| TYPEDEFname bit_field_declarator
	| global_or_scoped_typedefname bit_field_declarator
	| declaration_specifier bit_field_declarator
	| member_declaring_list ',' bit_field_declarator
	;
member_conflict_declaring_item :
	 TYPEDEFname identifier_declarator member_pure_opt
	| TYPEDEFname parameter_typedef_declarator member_pure_opt
	| TYPEDEFname simple_paren_typedef_declarator member_pure_opt
	| declaration_specifier identifier_declarator member_pure_opt
	| declaration_specifier parameter_typedef_declarator member_pure_opt
	| declaration_specifier simple_paren_typedef_declarator member_pure_opt
	| member_conflict_paren_declaring_item
	;
member_conflict_paren_declaring_item :
	 TYPEDEFname asterisk_or_ampersand '(' simple_paren_typedef_declarator ')' member_pure_opt
	| TYPEDEFname unary_modifier '(' simple_paren_typedef_declarator ')' member_pure_opt
	| TYPEDEFname asterisk_or_ampersand '(' TYPEDEFname ')' member_pure_opt
	| TYPEDEFname unary_modifier '(' TYPEDEFname ')' member_pure_opt
	| TYPEDEFname asterisk_or_ampersand paren_typedef_declarator member_pure_opt
	| TYPEDEFname unary_modifier paren_typedef_declarator member_pure_opt
	| declaration_specifier asterisk_or_ampersand '(' simple_paren_typedef_declarator ')' member_pure_opt
	| declaration_specifier unary_modifier '(' simple_paren_typedef_declarator ')' member_pure_opt
	| declaration_specifier asterisk_or_ampersand '(' TYPEDEFname ')' member_pure_opt
	| declaration_specifier unary_modifier '(' TYPEDEFname ')' member_pure_opt
	| declaration_specifier asterisk_or_ampersand paren_typedef_declarator member_pure_opt
	| declaration_specifier unary_modifier paren_typedef_declarator member_pure_opt
	| member_conflict_paren_postfix_declaring_item
	;
member_conflict_paren_postfix_declaring_item :
	 TYPEDEFname '(' paren_typedef_declarator ')' member_pure_opt
	| TYPEDEFname '(' simple_paren_typedef_declarator postfixing_abstract_declarator ')' member_pure_opt
	| TYPEDEFname '(' TYPEDEFname postfixing_abstract_declarator ')' member_pure_opt
	| TYPEDEFname '(' paren_typedef_declarator ')' postfixing_abstract_declarator member_pure_opt
	| declaration_specifier '(' paren_typedef_declarator ')' member_pure_opt
	| declaration_specifier '(' simple_paren_typedef_declarator postfixing_abstract_declarator ')' member_pure_opt
	| declaration_specifier '(' TYPEDEFname postfixing_abstract_declarator ')' member_pure_opt
	| declaration_specifier '(' paren_typedef_declarator ')' postfixing_abstract_declarator member_pure_opt
	;
member_pure_opt :
	 /*empty*/
	| '=' OCTALconstant
	;
bit_field_declarator :
	 bit_field_identifier_declarator
	;
bit_field_declarator :
	 TYPEDEFname ':' constant_expression
	;
bit_field_identifier_declarator :
	 ':' constant_expression
	;
bit_field_identifier_declarator :
	 identifier_declarator ':' constant_expression
	;
enum_name_elaboration :
	 global_opt_scope_opt_enum_key '{' enumerator_list '}'
	| enum_name '{' enumerator_list '}'
	;
enum_name :
	 global_opt_scope_opt_enum_key tag_name
	;
global_opt_scope_opt_enum_key :
	 ENUM
	| global_or_scope ENUM
	;
enumerator_list :
	 enumerator_list_no_trailing_comma
	| enumerator_list_no_trailing_comma ','
	;
enumerator_list_no_trailing_comma :
	 enumerator_name enumerator_value_opt
	| enumerator_list_no_trailing_comma ',' enumerator_name enumerator_value_opt
	;
enumerator_name :
	 IDENTIFIER
	| TYPEDEFname
	;
enumerator_value_opt :
	 /*empty*/
	| '=' constant_expression
	;
parameter_type_list :
	 '(' ')' type_qualifier_list_opt
	| '(' type_name ')' type_qualifier_list_opt
	| '(' type_name initializer ')' type_qualifier_list_opt
	| '(' named_parameter_type_list ')' type_qualifier_list_opt
	;
old_parameter_type_list :
	 '(' ')'
	| '(' type_name ')'
	| '(' type_name initializer ')'
	| '(' named_parameter_type_list ')'
	;
named_parameter_type_list :
	 parameter_list
	| parameter_list comma_opt_ellipsis
	| type_name comma_opt_ellipsis
	| type_name initializer comma_opt_ellipsis
	| ELLIPSIS
	;
comma_opt_ellipsis :
	 ELLIPSIS
	| ',' ELLIPSIS
	;
parameter_list :
	 non_casting_parameter_declaration
	| non_casting_parameter_declaration initializer
	| type_name ',' parameter_declaration
	| type_name initializer ',' parameter_declaration
	| parameter_list ',' parameter_declaration
	;
parameter_declaration :
	 type_name
	| type_name initializer
	| non_casting_parameter_declaration
	| non_casting_parameter_declaration initializer
	;
non_casting_parameter_declaration :
	 declaration_specifier
	| declaration_specifier abstract_declarator
	| declaration_specifier identifier_declarator
	| declaration_specifier parameter_typedef_declarator
	| declaration_qualifier_list
	| declaration_qualifier_list abstract_declarator
	| declaration_qualifier_list identifier_declarator
	| type_specifier identifier_declarator
	| type_specifier parameter_typedef_declarator
	| basic_type_name identifier_declarator
	| basic_type_name parameter_typedef_declarator
	| TYPEDEFname identifier_declarator
	| TYPEDEFname parameter_typedef_declarator
	| global_or_scoped_typedefname identifier_declarator
	| global_or_scoped_typedefname parameter_typedef_declarator
	| type_qualifier_list identifier_declarator
	;
type_name :
	 type_specifier
	| basic_type_name
	| TYPEDEFname
	| global_or_scoped_typedefname
	| type_qualifier_list
	| type_specifier abstract_declarator
	| basic_type_name abstract_declarator
	| TYPEDEFname abstract_declarator
	| global_or_scoped_typedefname abstract_declarator
	| type_qualifier_list abstract_declarator
	;
initializer_opt :
	 /*empty*/
	| initializer
	;
initializer :
	 '=' initializer_group
	;
initializer_group :
	 '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	| assignment_expression
	;
initializer_list :
	 initializer_group
	| initializer_list ',' initializer_group
	;
statement :
	 labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	| declaration
	;
labeled_statement :
	 label ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;
compound_statement :
	 '{' statement_list_opt '}'
	;
declaration_list :
	 declaration
	| declaration_list declaration
	;
statement_list_opt :
	 /*empty*/
	| statement_list_opt statement
	;
expression_statement :
	 comma_expression_opt ';'
	;
selection_statement :
	 IF '(' comma_expression ')' statement
	| IF '(' comma_expression ')' statement ELSE statement
	| SWITCH '(' comma_expression ')' statement
	;
iteration_statement :
	 WHILE '(' comma_expression_opt ')' statement
	| DO statement WHILE '(' comma_expression ')' ';'
	| FOR '(' comma_expression_opt ';' comma_expression_opt ';' comma_expression_opt ')' statement
	| FOR '(' declaration comma_expression_opt ';' comma_expression_opt ')' statement
	;
jump_statement :
	 GOTO label ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN comma_expression_opt ';'
	;
label :
	 IDENTIFIER
	| TYPEDEFname
	;
translation_unit :
	 /*empty*/
	| translation_unit external_definition
	;
external_definition :
	 function_declaration
	| function_definition
	| declaration
	| linkage_specifier function_declaration
	| linkage_specifier function_definition
	| linkage_specifier declaration
	| linkage_specifier '{' translation_unit '}'
	;
linkage_specifier :
	 EXTERN STRINGliteral
	;
function_declaration :
	 identifier_declarator ';'
	| constructor_function_declaration ';'
	;
function_definition :
	 new_function_definition
	| old_function_definition
	| constructor_function_definition
	;
new_function_definition :
	 identifier_declarator compound_statement
	| declaration_specifier declarator compound_statement
	| type_specifier declarator compound_statement
	| basic_type_name declarator compound_statement
	| TYPEDEFname declarator compound_statement
	| global_or_scoped_typedefname declarator compound_statement
	| declaration_qualifier_list identifier_declarator compound_statement
	| type_qualifier_list identifier_declarator compound_statement
	;
old_function_definition :
	 old_function_declarator old_function_body
	;
old_function_definition :
	 declaration_specifier old_function_declarator old_function_body
	;
old_function_definition :
	 type_specifier old_function_declarator old_function_body
	;
old_function_definition :
	 basic_type_name old_function_declarator old_function_body
	;
old_function_definition :
	 TYPEDEFname old_function_declarator old_function_body
	;
old_function_definition :
	 global_or_scoped_typedefname old_function_declarator old_function_body
	;
old_function_definition :
	 declaration_qualifier_list old_function_declarator old_function_body
	;
old_function_definition :
	 type_qualifier_list old_function_declarator old_function_body
	;
old_function_body :
	 declaration_list compound_statement
	| compound_statement
	;
constructor_function_definition :
	 global_or_scoped_typedefname parameter_type_list constructor_init_list_opt compound_statement
	| declaration_specifier parameter_type_list constructor_init_list_opt compound_statement
	;
constructor_function_declaration :
	 global_or_scoped_typedefname parameter_type_list
	| declaration_specifier parameter_type_list
	;
constructor_function_in_class :
	 declaration_specifier constructor_parameter_list_and_body
	| TYPEDEFname constructor_parameter_list_and_body
	;
constructor_parameter_list_and_body :
	 '(' ')' type_qualifier_list_opt ';'
	| '(' type_name initializer ')' type_qualifier_list_opt ';'
	| '(' named_parameter_type_list ')' type_qualifier_list_opt ';'
	| '(' ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| '(' type_name initializer ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| '(' named_parameter_type_list ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| constructor_conflicting_parameter_list_and_body
	;
constructor_conflicting_parameter_list_and_body :
	 '(' type_specifier ')' type_qualifier_list_opt ';'
	| '(' basic_type_name ')' type_qualifier_list_opt ';'
	| '(' TYPEDEFname ')' type_qualifier_list_opt ';'
	| '(' global_or_scoped_typedefname ')' type_qualifier_list_opt ';'
	| '(' type_qualifier_list ')' type_qualifier_list_opt ';'
	| '(' type_specifier abstract_declarator ')' type_qualifier_list_opt ';'
	| '(' basic_type_name abstract_declarator ')' type_qualifier_list_opt ';'
	| '(' global_or_scoped_typedefname abstract_declarator ')' type_qualifier_list_opt ';'
	| '(' type_qualifier_list abstract_declarator ')' type_qualifier_list_opt ';'
	| '(' type_specifier ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| '(' basic_type_name ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| '(' TYPEDEFname ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| '(' global_or_scoped_typedefname ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| '(' type_qualifier_list ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| '(' type_specifier abstract_declarator ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| '(' basic_type_name abstract_declarator ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| '(' global_or_scoped_typedefname abstract_declarator ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| '(' type_qualifier_list abstract_declarator ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| constructor_conflicting_typedef_declarator
	;
constructor_conflicting_typedef_declarator :
	 '(' TYPEDEFname unary_abstract_declarator ')' type_qualifier_list_opt ';'
	| '(' TYPEDEFname unary_abstract_declarator ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| '(' TYPEDEFname postfix_abstract_declarator ')' type_qualifier_list_opt ';'
	| '(' TYPEDEFname postfix_abstract_declarator ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	| '(' TYPEDEFname postfixing_abstract_declarator ')' type_qualifier_list_opt ';'
	| '(' TYPEDEFname postfixing_abstract_declarator ')' type_qualifier_list_opt constructor_init_list_opt compound_statement
	;
constructor_init_list_opt :
	 /*empty*/
	| constructor_init_list
	;
constructor_init_list :
	 ':' constructor_init
	| constructor_init_list ',' constructor_init
	;
constructor_init :
	 IDENTIFIER '(' argument_expression_list ')'
	| IDENTIFIER '(' ')'
	| TYPEDEFname '(' argument_expression_list ')'
	| TYPEDEFname '(' ')'
	| global_or_scoped_typedefname '(' argument_expression_list ')'
	| global_or_scoped_typedefname '(' ')'
	| '(' argument_expression_list ')'
	| '(' ')'
	;
declarator :
	 identifier_declarator
	| typedef_declarator
	;
typedef_declarator :
	 paren_typedef_declarator
	| simple_paren_typedef_declarator
	| parameter_typedef_declarator
	;
parameter_typedef_declarator :
	 TYPEDEFname
	| TYPEDEFname postfixing_abstract_declarator
	| clean_typedef_declarator
	;
clean_typedef_declarator :
	 clean_postfix_typedef_declarator
	| asterisk_or_ampersand parameter_typedef_declarator
	| unary_modifier parameter_typedef_declarator
	;
clean_postfix_typedef_declarator :
	 '(' clean_typedef_declarator ')'
	| '(' clean_typedef_declarator ')' postfixing_abstract_declarator
	;
paren_typedef_declarator :
	 postfix_paren_typedef_declarator
	| asterisk_or_ampersand '(' simple_paren_typedef_declarator ')'
	| unary_modifier '(' simple_paren_typedef_declarator ')'
	| asterisk_or_ampersand '(' TYPEDEFname ')'
	| unary_modifier '(' TYPEDEFname ')'
	| asterisk_or_ampersand paren_typedef_declarator
	| unary_modifier paren_typedef_declarator
	;
postfix_paren_typedef_declarator :
	 '(' paren_typedef_declarator ')'
	| '(' simple_paren_typedef_declarator postfixing_abstract_declarator ')'
	| '(' TYPEDEFname postfixing_abstract_declarator ')'
	| '(' paren_typedef_declarator ')' postfixing_abstract_declarator
	;
simple_paren_typedef_declarator :
	 '(' TYPEDEFname ')'
	| '(' simple_paren_typedef_declarator ')'
	;
identifier_declarator :
	 unary_identifier_declarator
	| paren_identifier_declarator
	;
unary_identifier_declarator :
	 postfix_identifier_declarator
	| asterisk_or_ampersand identifier_declarator
	| unary_modifier identifier_declarator
	;
postfix_identifier_declarator :
	 paren_identifier_declarator postfixing_abstract_declarator
	| '(' unary_identifier_declarator ')'
	| '(' unary_identifier_declarator ')' postfixing_abstract_declarator
	;
old_function_declarator :
	 postfix_old_function_declarator
	| asterisk_or_ampersand old_function_declarator
	| unary_modifier old_function_declarator
	;
postfix_old_function_declarator :
	 paren_identifier_declarator '(' argument_expression_list ')'
	| '(' old_function_declarator ')'
	| '(' old_function_declarator ')' old_postfixing_abstract_declarator
	;
old_postfixing_abstract_declarator :
	 array_abstract_declarator
	| old_parameter_type_list
	;
abstract_declarator :
	 unary_abstract_declarator
	| postfix_abstract_declarator
	| postfixing_abstract_declarator
	;
postfixing_abstract_declarator :
	 array_abstract_declarator
	| parameter_type_list
	;
array_abstract_declarator :
	 '[' ']'
	| '[' constant_expression ']'
	| array_abstract_declarator '[' constant_expression ']'
	;
unary_abstract_declarator :
	 asterisk_or_ampersand
	| unary_modifier
	| asterisk_or_ampersand abstract_declarator
	| unary_modifier abstract_declarator
	;
postfix_abstract_declarator :
	 '(' unary_abstract_declarator ')'
	| '(' postfix_abstract_declarator ')'
	| '(' postfixing_abstract_declarator ')'
	| '(' unary_abstract_declarator ')' postfixing_abstract_declarator
	;
asterisk_or_ampersand :
	 '*'
	| '&'
	;
unary_modifier :
	 scope '*' type_qualifier_list_opt
	| asterisk_or_ampersand type_qualifier_list
	;
scoping_name :
	 tag_name
	| aggregate_key tag_name
	;
scope :
	 scoping_name CLCL
	| scope scoping_name CLCL
	;
tag_name :
	 IDENTIFIER
	| TYPEDEFname
	;
global_scope :
	 CLCL
	;
global_or_scope :
	 global_scope
	| scope
	| global_scope scope
	;
scope_opt_identifier :
	 IDENTIFIER
	| scope IDENTIFIER
	;
scope_opt_complex_name :
	 complex_name
	| scope complex_name
	;
complex_name :
	 '~' TYPEDEFname
	| operator_function_name
	;
global_opt_scope_opt_identifier :
	 global_scope scope_opt_identifier
	| scope_opt_identifier
	;
global_opt_scope_opt_complex_name :
	 global_scope scope_opt_complex_name
	| scope_opt_complex_name
	;
scoped_typedefname :
	 scope TYPEDEFname
	;
global_or_scoped_typedefname :
	 scoped_typedefname
	| global_scope scoped_typedefname
	| global_scope TYPEDEFname
	;
global_opt_scope_opt_typedefname :
	 TYPEDEFname
	| global_or_scoped_typedefname
	;

%%

identifier [a-zA-Z_][0-9a-zA-Z_]*

exponent_part [eE][-+]?[0-9]+
fractional_constant ([0-9]*"."[0-9]+)|([0-9]+".")
floating_constant (({fractional_constant}{exponent_part}?)|([0-9]+{exponent_part}))[FfLl]?

integer_suffix_opt ([uU]?[lL]?)|([lL][uU])
decimal_constant [1-9][0-9]*{integer_suffix_opt}
octal_constant "0"[0-7]*{integer_suffix_opt}
hex_constant "0"[xX][0-9a-fA-F]+{integer_suffix_opt}

simple_escape [abfnrtv'"?\\]
octal_escape  [0-7]{1,3}
hex_escape "x"[0-9a-fA-F]+

escape_sequence [\\]({simple_escape}|{octal_escape}|{hex_escape})
c_char [^'\\\n]|{escape_sequence}
s_char [^"\\\n]|{escape_sequence}


h_tab [\011]
form_feed [\014]
v_tab [\013]
c_return [\015]

horizontal_white [ ]|{h_tab}

%%

{horizontal_white}+     skip()

({v_tab}|{c_return}|{form_feed})+   skip()


({horizontal_white}|{v_tab}|{c_return}|{form_feed})*"\n"   skip()

auto                AUTO
break               BREAK
case                CASE
char                CHAR
const               CONST
continue            CONTINUE
default             DEFAULT
/*define             PP_DEFINE*/
/*defined            PP_OPDEFINED*/
do                  DO
double              DOUBLE
/*elif                PP_ELIF*/
else              ELSE
/*endif              PP_ENDIF*/
enum                ENUM
/*error              PP_ERROR*/
extern              EXTERN
float               FLOAT
for                 FOR
goto                GOTO
if                IF
/*ifdef              PP_IFDEF*/
/*ifndef             PP_IFNDEF*/
/*include            PP_INCLUDE*/
int                 INT
/*line               PP_LINE*/
long                LONG
/*pragma             PP_PRAGMA*/
register            REGISTER
return              RETURN
short               SHORT
signed              SIGNED
sizeof              SIZEOF
static              STATIC
struct              STRUCT
switch              SWITCH
typedef             TYPEDEF
/*undef              PP_UNDEF*/
union               UNION
unsigned            UNSIGNED
void                VOID
volatile            VOLATILE
while               WHILE


class               CLASS
delete              DELETE
friend              FRIEND
inline              INLINE
new                 NEW
operator            OPERATOR
overload            OVERLOAD
protected           PROTECTED
private             PRIVATE
public              PUBLIC
this                THIS
virtual             VIRTUAL

{identifier}          IDENTIFIER

{decimal_constant}  INTEGERconstant
{octal_constant}    OCTALconstant
{hex_constant}      HEXconstant
{floating_constant} FLOATINGconstant


"L"?[']{c_char}+[']     CHARACTERconstant


"L"?["]{s_char}*["]     STRINGliteral




"("                  '(' /*LP*/
")"                  ')' /*RP*/
","                  ',' /*COMMA*/
/*"#"                  '#'*/
/*"##"                 POUNDPOUND*/

"{"                  '{' /*LC*/
"}"                  '}' /*RC*/
"["                  '[' /*LB*/
"]"                  ']' /*RB*/
"."                  '.' /*DOT*/
"&"                  '&' /*AND*/
"*"                  '*' /*STAR*/
"+"                  '+' /*PLUS*/
"-"                  '-' /*MINUS*/
"~"                  '~' /*NEGATE*/
"!"                  '!' /*NOT*/
"/"                  '/' /*DIV*/
"%"                  '%' /*MOD*/
"<"                  '<' /*LT*/
">"                  '>' /*GT*/
"^"                  '^' /*XOR*/
"|"                  '|' /*PIPE*/
"?"                  '?' /*QUESTION*/
":"                  ':' /*COLON*/
";"                  ';' /*SEMICOLON*/
"="                  '=' /*ASSIGN*/

".*"                 DOTstar
"::"                 CLCL
"->"                 ARROW
"->*"                ARROWstar
"++"                 ICR
"--"                 DECR
"<<"                 LS
">>"                 RS
"<="                 LE
">="                 GE
"=="                 EQ
"!="                 NE
"&&"                 ANDAND
"||"                 OROR
"*="                 MULTassign
"/="                 DIVassign
"%="                 MODassign
"+="                 PLUSassign
"-="                 MINUSassign
"<<="                LSassign
">>="                RSassign
"&="                 ANDassign
"^="                 ERassign
"|="                 ORassign
"..."                ELLIPSIS

%%
