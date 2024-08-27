//From: https://github.com/gobo-eiffel/gobo/blob/cff52cc187a38d53318d14cd146aeca316bf664b/library/parse/example/eiffel_parser/eiffel_parser.y
/*
note

	description:

		"Eiffel parsers"

	copyright: "Copyright (c) 1999-2018, Eric Bezault and others"
	license: "MIT License"
*/

/*Tokens*/
%token E_CHARACTER
%token E_INTEGER
%token E_REAL
%token E_IDENTIFIER
%token E_STRING
%token E_BIT
%token E_FREEOP
%token E_BITTYPE
%token E_BANGBANG
%token E_ARROW
%token E_DOTDOT
%token E_LARRAY
%token E_RARRAY
%token E_ASSIGN
%token E_REVERSE
%token E_ALIAS
%token E_ALL
%token E_AS
%token E_CHECK
%token E_CLASS
%token E_CREATION
%token E_DEBUG
%token E_DEFERRED
%token E_DO
%token E_ELSE
%token E_ELSEIF
%token E_END
%token E_ENSURE
%token E_EXPANDED
%token E_EXPORT
%token E_EXTERNAL
%token E_FALSE
%token E_FEATURE
%token E_FROM
%token E_FROZEN
%token E_IF
%token E_INDEXING
%token E_INFIX
%token E_INHERIT
%token E_INSPECT
%token E_INVARIANT
%token E_IS
%token E_LIKE
%token E_LOCAL
%token E_LOOP
%token E_NOTE
%token E_OBSOLETE
%token E_ONCE
%token E_PREFIX
%token E_REDEFINE
%token E_RENAME
%token E_REQUIRE
%token E_RESCUE
%token E_RETRY
%token E_SELECT
%token E_SEPARATE
%token E_STRIP
%token E_THEN
%token E_TRUE
%token E_UNDEFINE
%token E_UNIQUE
%token E_UNTIL
%token E_VARIANT
%token E_WHEN
%token E_CURRENT
%token E_RESULT
%token E_PRECURSOR
%token E_CREATE
//%token E_CHARERR
//%token E_INTERR
//%token E_REALERR
//%token E_STRERR
//%token E_UNKNOWN
//%token E_NOMEMORY
%token E_STRPLUS
%token E_STRMINUS
%token E_STRSTAR
%token E_STRSLASH
%token E_STRDIV
%token E_STRMOD
%token E_STRPOWER
%token E_STRLT
%token E_STRLE
%token E_STRGT
%token E_STRGE
%token E_STRAND
%token E_STROR
%token E_STRXOR
%token E_STRANDTHEN
%token E_STRORELSE
%token E_STRIMPLIES
%token E_STRFREEOP
%token E_STRNOT
%token E_IMPLIES
%token E_OR
%token E_XOR
%token E_AND
%token '='
%token E_NE
%token '<'
%token '>'
%token E_LE
%token E_GE
%token '+'
%token '-'
%token '*'
%token '/'
%token E_DIV
%token E_MOD
%token '^'
%token E_NOT
%token E_OLD
%token ';'
%token ':'
%token ','
%token '['
%token ']'
%token '{'
%token '}'
%token '('
%token ')'
%token '!'
%token '.'
%token '$'
%token '?'
%token '~'

%left /*1*/ E_IMPLIES
%left /*2*/ E_OR E_XOR
%left /*3*/ E_AND
%left /*4*/ '=' E_NE '<' '>' E_LE E_GE
%left /*5*/ '+' '-'
%left /*6*/ '*' '/' E_DIV E_MOD
%right /*7*/ '^'
%left /*8*/ E_FREEOP
%right /*9*/ E_NOT E_OLD

%start Class_declarations

%%

Class_declarations :
	/*empty*/
	| Class_declarations Class_declaration
	;

Class_declaration :
	Indexing_opt Class_header Formal_generics_opt Obsolete_opt Creators_opt Features_opt Invariant_opt E_END
	| Indexing_opt Class_header Formal_generics_opt Obsolete_opt Inheritance_to_end
	;

Creators_features_invariant_opt :
	Creators_opt Features_opt Invariant_opt
	;

Indexing_opt :
	/*empty*/
	| E_INDEXING Index_list
	| E_NOTE Index_list
	;

Index_list :
	/*empty*/
	| Index_list_with_no_terminator
	| Index_list_with_no_terminator S
	;

Index_list_with_no_terminator :
	Index_clause
	| Index_list_with_no_terminator Index_clause
	| Index_list_with_no_terminator ';' Index_clause
	| Index_list_with_no_terminator ';' S Index_clause
	;

Index_clause :
	Index_terms
	| Identifier ':' Index_terms
	;

Index_terms :
	Index_value
	| Index_terms ',' Index_value
	;

Index_value :
	Identifier
	| Manifest_constant
	;

S :
	';'
	| S ';'
	;

Class_header :
	Header_mark_opt E_CLASS Identifier
	;

Header_mark_opt :
	/*empty*/
	| E_DEFERRED
	| E_EXPANDED
	| E_SEPARATE
	;

Formal_generics_opt :
	/*empty*/
	| '[' Formal_generic_list ']'
	;

Formal_generic_list :
	/*empty*/
	| Identifier Constraint_opt
	| Formal_generic_list ',' Identifier Constraint_opt
	;

Constraint_opt :
	/*empty*/
	| E_ARROW Class_type
	| E_ARROW Class_type Creation_constraint
	;

Creation_constraint :
	E_CREATE Procedure_list E_END
	;

Obsolete_opt :
	/*empty*/
	| E_OBSOLETE E_STRING
	;

Inheritance_to_end :
	E_INHERIT Parent_list_to_end
	;

Parent_list_to_end :
	Creators_features_invariant_opt E_END
	| Parents Feature_adaptation_opt Creators_features_invariant_opt E_END
	| Parents E_END Creators_features_invariant_opt E_END
	| Parents E_END
	| Parents Feature_adaptation_opt ';' Creators_features_invariant_opt E_END
	| Parents E_END ';' Creators_features_invariant_opt E_END
	;

Parents :
	Class_type
	| Parents Feature_adaptation_opt Class_type
	| Parents Feature_adaptation_opt ';' Class_type
	| Parents E_END Class_type
	| Parents E_END ';' Class_type
	;

Feature_adaptation_opt :
	/*empty*/
	| Feature_adaptation
	;

Feature_adaptation :
	Feature_adaptation1
	| Feature_adaptation2
	| Feature_adaptation3
	| Feature_adaptation4
	| Feature_adaptation5
	;

Feature_adaptation1 :
	Rename New_exports_opt Undefine_opt Redefine_opt Select_opt E_END
	;

Feature_adaptation2 :
	New_exports Undefine_opt Redefine_opt Select_opt E_END
	;

Feature_adaptation3 :
	Undefine Redefine_opt Select_opt E_END
	;

Feature_adaptation4 :
	Redefine Select_opt E_END
	;

Feature_adaptation5 :
	Select E_END
	;

Rename :
	E_RENAME Rename_list
	| E_RENAME
	;

Rename_list :
	Feature_name E_AS Feature_name
	| Rename_list ',' Feature_name E_AS Feature_name
	;

New_exports :
	E_EXPORT New_export_list
	;

New_exports_opt :
	/*empty*/
	| New_exports
	;

New_export_list :
	/*empty*/
	| New_export_list_with_no_terminator
	| New_export_list_with_no_terminator ';'
	;

New_export_list_with_no_terminator :
	New_export_item
	| New_export_list_with_no_terminator New_export_item
	| New_export_list_with_no_terminator ';' New_export_item
	;

New_export_item :
	Clients Feature_set
	;

Feature_set :
	Feature_list
	| E_ALL
	;

Feature_list :
	/*empty*/
	| Feature_name
	| Feature_list ',' Feature_name
	;

Clients :
	'{' Class_list '}'
	;

Clients_opt :
	/*empty*/
	| Clients
	;

Class_list :
	/*empty*/
	| Identifier
	| Class_list ',' Identifier
	;

Redefine :
	E_REDEFINE Feature_list
	;

Redefine_opt :
	/*empty*/
	| Redefine
	;

Undefine :
	E_UNDEFINE Feature_list
	;

Undefine_opt :
	/*empty*/
	| Undefine
	;

Select :
	E_SELECT Feature_list
	;

Select_opt :
	/*empty*/
	| Select
	;

Creators_opt :
	/*empty*/
	| Creators
	;

Creators :
	Creation_clause
	| Creators Creation_clause
	;

Creation_clause :
	E_CREATION Clients_opt Procedure_list
	| E_CREATE Clients_opt Procedure_list
	;

Procedure_list :
	/*empty*/
	| Identifier
	| Procedure_list ',' Identifier
	;

Features_opt :
	/*empty*/
	| Features
	;

Features :
	Feature_clause
	| Features Feature_clause
	;

Feature_clause :
	E_FEATURE Clients_opt Feature_declaration_list
	;

Feature_declaration_list :
	/*empty*/
	| Feature_declaration_list_with_no_terminator
	| Feature_declaration_list_with_no_terminator ';'
	;

Feature_declaration_list_with_no_terminator :
	Feature_declaration
	| Feature_declaration_list_with_no_terminator Feature_declaration
	| Feature_declaration_list_with_no_terminator ';' Feature_declaration
	;

Feature_declaration :
	New_feature_list Declaration_body
	;

Declaration_body :
	Formal_arguments_opt Type_mark_opt Constant_or_routine_opt
	;

Constant_or_routine_opt :
	/*empty*/
	| E_IS Routine
	| Routine
	| '=' /*4L*/ Manifest_constant
	| E_IS Manifest_constant
	| '=' /*4L*/ E_UNIQUE
	| E_IS E_UNIQUE
	;

New_feature_list :
	New_feature
	| New_feature_list ',' New_feature
	;

New_feature :
	Feature_name
	| E_FROZEN Feature_name
	;

Feature_name :
	Identifier
	| E_PREFIX Prefix_operator
	| E_INFIX Infix_operator
	;

Prefix_operator :
	E_STRNOT
	| E_STRPLUS
	| E_STRMINUS
	| E_STRFREEOP
	;

Infix_operator :
	E_STRPLUS
	| E_STRMINUS
	| E_STRSTAR
	| E_STRSLASH
	| E_STRDIV
	| E_STRMOD
	| E_STRPOWER
	| E_STRLT
	| E_STRLE
	| E_STRGT
	| E_STRGE
	| E_STRAND
	| E_STRANDTHEN
	| E_STROR
	| E_STRORELSE
	| E_STRIMPLIES
	| E_STRXOR
	| E_STRFREEOP
	;

Formal_arguments_opt :
	/*empty*/
	| '(' Entity_declaration_list ')'
	;

Entity_declaration_list :
	/*empty*/
	| Entity_declaration_list_with_no_terminator
	| Entity_declaration_list_with_no_terminator ';'
	;

Entity_declaration_list_with_no_terminator :
	Entity_declaration_group
	| Entity_declaration_list_with_no_terminator Entity_declaration_group
	| Entity_declaration_list_with_no_terminator ';' Entity_declaration_group
	;

Entity_declaration_group :
	Identifier_list ':' Type
	;

Identifier_list :
	Identifier
	| Identifier_list ',' Identifier
	;

Type_mark_opt :
	/*empty*/
	| ':' Type
	;

Routine :
	Obsolete_opt Precondition_opt Local_declarations_opt Routine_body Postcondition_opt Rescue_opt E_END
	;

Routine_body :
	E_DEFERRED
	| E_DO Compound
	| E_ONCE Compound
	| E_EXTERNAL E_STRING External_name_opt
	;

External_name_opt :
	/*empty*/
	| E_ALIAS E_STRING
	;

Local_declarations_opt :
	/*empty*/
	| E_LOCAL Entity_declaration_list
	;

Precondition_opt :
	/*empty*/
	| E_REQUIRE Assertion
	| E_REQUIRE E_ELSE Assertion
	;

Postcondition_opt :
	/*empty*/
	| E_ENSURE Assertion
	| E_ENSURE E_THEN Assertion
	;

Invariant_opt :
	/*empty*/
	| E_INVARIANT Assertion
	;

Assertion :
	/*empty*/
	| Assertion_with_no_terminator
	| Assertion_with_no_terminator ';'
	;

Assertion_with_no_terminator :
	Assertion_clause
	| Assertion_with_no_terminator Assertion_clause
	| Assertion_with_no_terminator ';' Assertion_clause
	;

Assertion_clause :
	Expression
	| Identifier ':'
	;

Rescue_opt :
	/*empty*/
	| E_RESCUE Compound
	;

Type :
	Class_type
	| E_EXPANDED Class_type
	| E_SEPARATE Class_type
	| E_LIKE E_CURRENT
	| E_LIKE Identifier
	| E_BITTYPE Integer_constant
	| E_BITTYPE Identifier
	;

Class_type :
	Class_name Actual_generics_opt
	;

Class_name :
	E_IDENTIFIER
	;

Actual_generics_opt :
	/*empty*/
	| '[' Type_list ']'
	;

Type_list :
	/*empty*/
	| Type
	| Type_list ',' Type
	;

Compound :
	/*empty*/
	| Instructions
	;

Instructions :
	Instruction
	| Instructions Instruction
	;

Instruction :
	Creation_instruction
	| Call
	| Assignment
	| Conditional
	| Multi_branch
	| Loop
	| Debug
	| Check
	| E_RETRY
	| ';'
	| Create_instruction
	;

Creation_instruction :
	'!' Type '!' Writable Creation_call_opt
	| E_BANGBANG Writable Creation_call_opt
	;

Creation_call_opt :
	/*empty*/
	| '.' Identifier Actuals_opt
	;

Create_instruction :
	E_CREATE '{' Type '}' Writable Creation_call_opt
	| E_CREATE Writable Creation_call_opt
	;

Create_expression :
	E_CREATE '{' Type '}' Creation_call_opt
	;

Assignment :
	Writable Assign_op Expression
	;

Assign_op :
	E_ASSIGN
	| E_REVERSE
	;

Conditional :
	E_IF Expression E_THEN Compound Elseif_list Else_part E_END
	;

Else_part :
	/*empty*/
	| E_ELSE Compound
	;

Elseif_list :
	/*empty*/
	| E_ELSEIF Expression E_THEN Compound
	| Elseif_list E_ELSEIF Expression E_THEN Compound
	;

Multi_branch :
	E_INSPECT Expression When_list Else_part E_END
	;

When_list :
	/*empty*/
	| E_WHEN Choices E_THEN Compound
	| When_list E_WHEN Choices E_THEN Compound
	;

Choices :
	/*empty*/
	| Choice
	| Choices ',' Choice
	;

Choice :
	Choice_constant
	| Choice_constant E_DOTDOT Choice_constant
	;

Choice_constant :
	Integer_constant
	| E_CHARACTER
	| Identifier
	;

Loop :
	E_FROM Compound Invariant_opt Variant_opt E_UNTIL Expression E_LOOP Compound E_END
	;

Variant_opt :
	/*empty*/
	| E_VARIANT
	| E_VARIANT Expression
	| E_VARIANT Identifier ':' Expression
	;

Debug :
	E_DEBUG Debug_keys_opt Compound E_END
	;

Debug_keys_opt :
	/*empty*/
	| '(' Debug_key_list ')'
	;

Debug_key_list :
	/*empty*/
	| E_STRING
	| Debug_key_list ',' E_STRING
	;

Check :
	E_CHECK Assertion E_END
	;

Call :
	Call_chain
	| E_RESULT '.' Call_chain
	| E_CURRENT '.' Call_chain
	| '(' Expression ')' '.' Call_chain
	| E_PRECURSOR Actuals_opt
	| E_PRECURSOR Actuals_opt '.' Call_chain
	| '{' Type '}' E_PRECURSOR Actuals_opt
	| '{' Type '}' E_PRECURSOR Actuals_opt '.' Call_chain
	| E_PRECURSOR '{' Type '}' Actuals_opt
	| E_PRECURSOR '{' Type '}' Actuals_opt '.' Call_chain
	;

Call_chain :
	Identifier Actuals_opt
	| Call_chain '.' Identifier Actuals_opt
	;

Actuals_opt :
	/*empty*/
	| '(' Actual_list ')'
	;

Actual_list :
	/*empty*/
	| Actual
	| Actual_list ',' Actual
	;

Actual :
	Expression
	| '$' Address_mark
	;

Address_mark :
	Feature_name
	| E_CURRENT
	| E_RESULT
	| '(' Expression ')'
	;

Writable :
	Identifier
	| E_RESULT
	;

Expression :
	Call
	| E_RESULT
	| E_CURRENT
	| '(' Expression ')'
	| Boolean_constant
	| E_CHARACTER
	| E_INTEGER
	| E_REAL
	| E_STRING
	| E_BIT
	| E_LARRAY Expression_list E_RARRAY
	| '+' /*5L*/ Expression %prec E_NOT /*9R*/
	| '-' /*5L*/ Expression %prec E_NOT /*9R*/
	| E_NOT /*9R*/ Expression
	| E_FREEOP /*8L*/ Expression %prec E_NOT /*9R*/
	| Expression E_FREEOP /*8L*/ Expression
	| Expression '+' /*5L*/ Expression
	| Expression '-' /*5L*/ Expression
	| Expression '*' /*6L*/ Expression
	| Expression '/' /*6L*/ Expression
	| Expression '^' /*7R*/ Expression
	| Expression E_DIV /*6L*/ Expression
	| Expression E_MOD /*6L*/ Expression
	| Expression '=' /*4L*/ Expression
	| Expression E_NE /*4L*/ Expression
	| Expression '<' /*4L*/ Expression
	| Expression '>' /*4L*/ Expression
	| Expression E_LE /*4L*/ Expression
	| Expression E_GE /*4L*/ Expression
	| Expression E_AND /*3L*/ Expression
	| Expression E_OR /*2L*/ Expression
	| Expression E_XOR /*2L*/ Expression
	| Expression E_AND /*3L*/ E_THEN Expression %prec E_AND /*3L*/
	| Expression E_OR /*2L*/ E_ELSE Expression %prec E_OR /*2L*/
	| Expression E_IMPLIES /*1L*/ Expression
	| E_OLD /*9R*/ Expression
	| E_STRIP '(' Attribute_list ')'
	| Create_expression
	| Agent_expression
	| '[' Expression_list ']'
	;

Agent_expression :
	Identifier Agent_unqualified
	| E_CURRENT Agent_unqualified
	| E_RESULT Agent_unqualified
	| '(' Expression ')' Agent_unqualified
	| '{' Type '}' Agent_unqualified
	| '?' Agent_unqualified
	| Agent_unqualified
	;

Agent_unqualified :
	'~' Feature_name Agent_actuals_opt
	;

Agent_actuals_opt :
	/*empty*/
	| '(' Agent_actual_list ')'
	;

Agent_actual_list :
	/*empty*/
	| Agent_actual
	| Agent_actual_list ',' Agent_actual
	;

Agent_actual :
	Actual
	| '{' Type '}'
	| '?'
	;

Attribute_list :
	/*empty*/
	| Identifier
	| Attribute_list ',' Identifier
	;

Expression_list :
	/*empty*/
	| Expression
	| Expression_list ',' Expression
	;

Manifest_constant :
	Boolean_constant
	| E_CHARACTER
	| Integer_constant
	| Real_constant
	| E_STRING
	| E_BIT
	;

Boolean_constant :
	E_TRUE
	| E_FALSE
	;

Integer_constant :
	E_INTEGER
	| '-' /*5L*/ E_INTEGER
	| '+' /*5L*/ E_INTEGER
	;

Real_constant :
	E_REAL
	| '-' /*5L*/ E_REAL
	| '+' /*5L*/ E_REAL
	;

Identifier :
	E_IDENTIFIER
	| E_BITTYPE
	;

%%

//%option caseless
%x IN_STR REAL_DOT REAL_DOT2

%%

//----------/** Separators **/----------------------------------------------------

[ \t\r]+	skip()		// Ignore separators
\n+		skip()


//----------/** Eiffel comments **/-----------------------------------------------

"--".*	skip()			//-- Ignore comments
//"--".*\n[ \t\r]*	eif_lineno := eif_lineno + 1


//----------/** Eiffel symbols **/------------------------------------------------

"~" '~'
"-"		'-'			// Minus_code
"+"		'+'			// Plus_code
"*"		'*'			// Star_code
"/"		'/'			// Slash_code
"^"		'^'			// Caret_code
"="		'='			// Equal_code
">"		'>'			// Greater_than_code
"<"		'<'			// Less_than_code
"."		'.'			// Dot_code
";"		';'			// Semicolon_code
","		','			// Comma_code
":"		':'			// Colon_code
"!"		'!'			// Exclamation_code
"("		'('			// Left_parenthesis_code
")"		')'			// Right_parenthesis_code
"{"		'{'			// Left_brace_code
"}"		'}'			// Right_brace_code
"["		'['			// Left_bracket_code
"]"		']'			// Right_bracket_code
"$"		'$'			// Dollar_code
"?"		'?'			// Question_mark_code

"//"				 E_DIV
"\\\\"				 E_MOD
"/="				 E_NE
">="				 E_GE
"<="				 E_LE
"!!"				 E_BANGBANG
"->"				 E_ARROW
".."				 E_DOTDOT
"<<"				 E_LARRAY
">>"				 E_RARRAY
":="				 E_ASSIGN
"?="				 E_REVERSE


//----------/** Reserved words **/------------------------------------------------

[aA][lL][iI][aA][sS]					 E_ALIAS
[aA][lL][lL]							 E_ALL
[aA][nN][dD]							 E_AND
[aA][sS]								 E_AS
[bB][iI][tT]							 E_BITTYPE
[cC][hH][eE][cC][kK]					 E_CHECK
[cC][lL][aA][sS][sS]					 E_CLASS
[cC][rR][eE][aA][tT][eE]			E_CREATE // E_IDENTIFIER
[cC][rR][eE][aA][tT][iI][oO][nN]		 E_CREATION
[cC][uU][rR][rR][eE][nN][tT]			 E_CURRENT
[dD][eE][bB][uU][gG]					 E_DEBUG
[dD][eE][fF][eE][rR][rR][eE][dD]		 E_DEFERRED
[dD][oO]								 E_DO
[eE][lL][sS][eE]						 E_ELSE
[eE][lL][sS][eE][iI][fF]				 E_ELSEIF
[eE][nN][dD]							 E_END
[eE][nN][sS][uU][rR][eE]				 E_ENSURE
[eE][xX][pP][aA][nN][dD][eE][dD]		 E_EXPANDED
[eE][xX][pP][oO][rR][tT]				 E_EXPORT
[eE][xX][tT][eE][rR][nN][aA][lL]		 E_EXTERNAL
[fF][aA][lL][sS][eE]					 E_FALSE
[fF][eE][aA][tT][uU][rR][eE]			 E_FEATURE
[fF][rR][oO][mM]						 E_FROM
[fF][rR][oO][zZ][eE][nN]				 E_FROZEN
[iI][fF]								 E_IF
[iI][mM][pP][lL][iI][eE][sS]			 E_IMPLIES
[iI][nN][dD][eE][xX][iI][nN][gG]		 E_INDEXING
[iI][nN][fF][iI][xX]				E_INFIX
[iI][nN][hH][eE][rR][iI][tT]			 E_INHERIT
[iI][nN][sS][pP][eE][cC][tT]			 E_INSPECT
[iI][nN][vV][aA][rR][iI][aA][nN][tT]	 E_INVARIANT
[iI][sS]								 E_IS
[lL][iI][kK][eE]						 E_LIKE
[lL][oO][cC][aA][lL]					 E_LOCAL
[lL][oO][oO][pP]						 E_LOOP
[nN][oO][tT]							 E_NOT
[nN][oO][tT][eE]						 E_NOTE
[oO][bB][sS][oO][lL][eE][tT][eE]		 E_OBSOLETE
[oO][lL][dD]							 E_OLD
[oO][nN][cC][eE]						 E_ONCE
[oO][rR]								 E_OR
[pP][rR][eE][cC][uU][rR][sS][oO][rR]	 E_PRECURSOR
[pP][rR][eE][fF][iI][xX]			E_PREFIX
[rR][eE][dD][eE][fF][iI][nN][eE]		 E_REDEFINE
[rR][eE][nN][aA][mM][eE]				 E_RENAME
[rR][eE][qQ][uU][iI][rR][eE]			 E_REQUIRE
[rR][eE][sS][cC][uU][eE]				 E_RESCUE
[rR][eE][sS][uU][lL][tT]				 E_RESULT
[rR][eE][tT][rR][yY]					 E_RETRY
[sS][eE][lL][eE][cC][tT]				 E_SELECT
[sS][eE][pP][aA][rR][aA][tT][eE]		 E_SEPARATE
[sS][tT][rR][iI][pP]					 E_STRIP
[tT][hH][eE][nN]						 E_THEN
[tT][rR][uU][eE]						 E_TRUE
[uU][nN][dD][eE][fF][iI][nN][eE]		 E_UNDEFINE
[uU][nN][iI][qQ][uU][eE]				 E_UNIQUE
[uU][nN][tT][iI][lL]					 E_UNTIL
[vV][aA][rR][iI][aA][nN][tT]			 E_VARIANT
[wW][hH][eE][nN]						 E_WHEN
[xX][oO][rR]							 E_XOR


//----------/** Eiffel identifiers **/--------------------------------------------

[a-zA-Z][a-zA-Z0-9_]*	E_IDENTIFIER


//----------/** Eiffel free operators **/-----------------------------------------

[@#|&][^%" \t\r\n]*	E_FREEOP

		//-- Note: Accepts non-printable characters as well,
		//-- provided that they are not break characters.


//----------/** Eiffel characters **/---------------------------------------------

\'[^%\n']\'			E_CHARACTER
	//-- The following line is not correct Eiffel but
	//-- it appears in some Halstenbach Eiffel libraries.
\'\'\'				E_CHARACTER
\'%A\'				E_CHARACTER
\'%B\'				E_CHARACTER
\'%C\'				E_CHARACTER
\'%D\'				E_CHARACTER
\'%F\'				E_CHARACTER
\'%H\'				E_CHARACTER
\'%L\'				E_CHARACTER
\'%N\'				E_CHARACTER
\'%Q\'				E_CHARACTER
\'%R\'				E_CHARACTER
\'%S\'				E_CHARACTER
\'%T\'				E_CHARACTER
\'%U\'				E_CHARACTER
\'%V\'				E_CHARACTER
"'%%'"				E_CHARACTER
\'%\'\'				E_CHARACTER
\'%\"\'				E_CHARACTER
\'%\(\'				E_CHARACTER
\'%\)\'				E_CHARACTER
\'%<\'				E_CHARACTER
\'%>\'				E_CHARACTER
\'%\/[0-9]+\/\'		E_CHARACTER
	//-- The following line is not correct Eiffel but
	//-- it appears in some Visual Eiffel libraries.
\'%.\'				E_CHARACTER

//\'.{1,2}			E_CHARERR
//\'%\/[0-9]+(\/)?	E_CHARERR	//-- Catch-all rules (no backing up)


//----------/** Eiffel strings **/------------------------------------------------

\"\+\"								E_STRPLUS
\"-\"								E_STRMINUS
\"\*\"								E_STRSTAR
\"\/\"								E_STRSLASH
\"\/\/\"							E_STRDIV
\"\\\\\"							E_STRMOD
\"\^\"								E_STRPOWER
\"<\"								E_STRLT
\"<=\"								E_STRLE
\">\"								E_STRGT
\">=\"								E_STRGE
\"[nN][oO][tT]\"					E_STRNOT
\"[aA][nN][dD]\"					E_STRAND
\"[oO][rR]\"						E_STROR
\"[xX][oO][rR]\"					E_STRXOR
\"[aA][nN][dD]\ [tT][hH][eE][nN]\"	E_STRANDTHEN
\"[oO][rR]\ [eE][lL][sS][eE]\"		E_STRORELSE
\"[iI][mM][pP][lL][iI][eE][sS]\"	E_STRIMPLIES
\"[@#|&][^%" \t\r\n]*\"		E_STRING // E_STRFREEOP
\"[^%\n"]*\" E_STRING
\"[^%\n"]*<IN_STR>
<IN_STR>[^%\n"]+<.>
<IN_STR>%A<.>
<IN_STR>%B<.>
<IN_STR>%C<.>
<IN_STR>%D<.>
<IN_STR>%F<.>
<IN_STR>%H<.>
<IN_STR>%L<.>
<IN_STR>%N<.>
<IN_STR>%Q<.>
<IN_STR>%R<.>
<IN_STR>%S<.>
<IN_STR>%T<.>
<IN_STR>%U<.>
<IN_STR>%V<.>
<IN_STR>"%%"<.>
<IN_STR>%\'<.>
<IN_STR>%\"<.>
<IN_STR>%\(<.>
<IN_STR>%\)<.>
<IN_STR>%<<.>
<IN_STR>%><.>
//<IN_STR>%\/[0-9]+\/<INITIAL>	E_STRERR
//-- The following line should be:
//--		<IN_STR>%\n[ \t\r]*%	eif_lineno := eif_lineno + 1
//-- but some Eiffel classes in Halstenbach libraries
//-- have a space after the % character!
<IN_STR>%[ \t\r]*\n[ \t\r]*%<.>
<IN_STR>[^%\n"]*\"<INITIAL>		E_STRING
	//-- The following line is not correct Eiffel
	//-- but is used in Visual Eiffel.
<IN_STR>%.<.>

//<IN_STR>.|\n<INITIAL>				E_STRERR
//<IN_STR>%[ \t\r]*\n[ \t\r]*<INITIAL>	E_STRERR
//<IN_STR>%\/([0-9]+(\/)?)?<INITIAL>	E_STRERR
//<IN_STR><<EOF>><INITIAL>		//-- Catch-all rules (no backing up)


//----------/** Eiffel bits **/---------------------------------------------------

[0-1]+[bB]			 E_BIT


//----------/** Eiffel integers **/-----------------------------------------------

[0-9]+				E_INTEGER
[0-9]{1,3}(_[0-9]{3})+	E_INTEGER
//[0-9_]+				E_INTERR	//-- Catch-all rule (no backing up)


//---------/** Eiffel reals **/---------------------------------------------------

[0-9]+\.[^.0-9]<REAL_DOT>	reject()
<REAL_DOT>{
	[0-9]+\.<INITIAL> E_REAL
}
[0-9]+\.[0-9]*[eE][+-]?[0-9]+		E_REAL
[0-9]*\.[0-9]+([eE][+-]?[0-9]+)?	E_REAL
[0-9]{1,3}(_[0-9]{3})+\.[^.0-9]<REAL_DOT2> reject()
<REAL_DOT2>{
	[0-9]{1,3}(_[0-9]{3})+\.	E_REAL
}
[0-9]{1,3}(_[0-9]{3})*\.([0-9]{1,3}(_[0-9]{3})*)?[eE][+-]?[0-9]{1,3}(_[0-9]{3})*	E_REAL
([0-9]{1,3}(_[0-9]{3})*)?\.[0-9]{1,3}(_[0-9]{3})*([eE][+-]?[0-9]{1,3}(_[0-9]{3})*)?	E_REAL

		//-- The first and fourth expressions use a trailing context
		//-- to make sure that an integer followed by two dots is
		//-- not recognized as a real followed by a dot.

//--------------------------------------------------------------------------------

//<<EOF>>			terminate
//.				last_token := text_item (1).code

//--------------------------------------------------------------------------------

%%
