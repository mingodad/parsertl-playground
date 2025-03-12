//From: https://github.com/swiftlang/swift/blob/ae0936f178b020c479fe6c0db396b30a7c6cc552/docs/archive/LangRefNew.rst?plain=1

%token anotation
%token CTK_get
%token CTK_infix
%token CTK_mutating
%token CTK_nonmutating
%token CTK_operator
%token CTK_override
%token CTK_postfix
%token CTK_prefix
%token CTK_set
%token TK_Self
%token TK_Type
%token TK___COLUMN__
%token TK___FILE__
%token TK___LINE__
%token TK_arrow
%token TK_as
%token TK_break
%token TK_case
%token TK_class
%token TK_colon
%token TK_comma
%token TK_continue
%token TK_default
%token TK_destructor
%token TK_do
%token TK_dot
%token TK_else
%token TK_enum
%token TK_eq
%token TK_extension
%token TK_for
%token TK_func
%token TK_if
%token TK_import
%token TK_in
%token TK_init
%token TK_is
%token TK_lbrack
%token TK_lcurly
%token TK_lp
%token TK_new
%token TK_protocol
%token TK_quest
%token TK_rbrack
%token TK_rcurly
%token TK_return
%token TK_rp
%token TK_self
%token TK_semi
%token TK_struct
%token TK_subscript
%token TK_super
%token TK_switch
%token TK_then
%token TK_type
%token TK_typealias
%token TK_var
%token TK_where
%token TK_while
%token dollarident
%token floating_literal
%token identifier
%token integer_literal
%token operator
%token string_literal

%%

input :
	%empty
	| tokens
	;

tokens :
	token
	| tokens token
	;

token :
    anotation
	| CTK_get
	| CTK_infix
	| CTK_mutating
	| CTK_nonmutating
	| CTK_operator
	| CTK_override
	| CTK_postfix
	| CTK_prefix
	| CTK_set
	| TK_Self
	| TK_Type
	| TK___COLUMN__
	| TK___FILE__
	| TK___LINE__
	| TK_arrow
	| TK_as
	| TK_break
	| TK_case
	| TK_class
	| TK_colon
	| TK_comma
	| TK_continue
	| TK_default
	| TK_destructor
	| TK_do
	| TK_dot
	| TK_else
	| TK_enum
	| TK_eq
	| TK_extension
	| TK_for
	| TK_func
	| TK_if
	| TK_import
	| TK_in
	| TK_init
	| TK_is
	| TK_lbrack
	| TK_lcurly
	| TK_lp
	| TK_new
	| TK_protocol
	| TK_quest
	| TK_rbrack
	| TK_rcurly
	| TK_return
	| TK_rp
	| TK_self
	| TK_semi
	| TK_struct
	| TK_subscript
	| TK_super
	| TK_switch
	| TK_then
	| TK_type
	| TK_typealias
	| TK_var
	| TK_where
	| TK_while
	| dollarident
	| floating_literal
	| identifier
	| integer_literal
	| operator
	| string_literal
	;

%%

ID	[A-Za-z_][A-Za-z0-9_]*

%%

//whitespace ::= ' '
//whitespace ::= '\n'
//whitespace ::= '\r'
//whitespace ::= '\t'
//whitespace ::= '\0'
//comment    ::= //.*[\n\r]
//comment    ::= /* .... */

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

//Reserved Punctuation Tokens
"("	TK_lp
")"	TK_rp
"{"	TK_lcurly
"}"	TK_rcurly
"["	TK_lbrack
"]"	TK_rbrack
"."	TK_dot
","	TK_comma
";"	TK_semi
":"	TK_colon
"="	TK_eq
"->"	TK_arrow
"?" TK_quest
//"&"	TK_amp // unary prefix operator

[/=\-+*%<>!&|^~]+	operator

////Operator Tokens
//<a name="operator">operator</a> ::= [/=-+*%<>!&|^~]+
//<a name="operator">operator</a> ::= \.+
//
//<a href="#reserved_punctuation">Reserved for punctuation</a>: '.', '=', '->', and unary prefix '&'
//<a href="#whitespace">Reserved for comments</a>: '//', '/*' and '*/'
//
//operator-binary ::= operator
//operator-prefix ::= operator
//operator-postfix ::= operator
//
//left-binder  ::= [ \r\n\t\(\[\{,;:]
//right-binder ::= [ \r\n\t\)\]\},;:]
//
//<a name="any-identifier">any-identifier</a> ::= identifier | operator

// Declarations and Type Keywords
"class"	TK_class
"destructor"	TK_destructor
"extension"	TK_extension
"import"	TK_import
"init"	TK_init
"func"	TK_func
"enum"	TK_enum
"protocol"	TK_protocol
"struct"	TK_struct
"subscript"	TK_subscript
"Type"	TK_Type
"typealias"	TK_typealias
"var"	TK_var
"where"	TK_where

// Statements
"break"	TK_break
"case"	TK_case
"continue"	TK_continue
"default"	TK_default
"do"	TK_do
"else"	TK_else
"if"	TK_if
"in"	TK_in
"for"	TK_for
"return"	TK_return
"switch"	TK_switch
"then"	TK_then
"while"	TK_while

// Expressions
"as"	TK_as
"is"	TK_is
"new"	TK_new
"super"	TK_super
"self"	TK_self
"Self"	TK_Self
"type"	TK_type
"__COLUMN__"	TK___COLUMN__
"__FILE__"	TK___FILE__
"__LINE__"	TK___LINE__

//Contextual Keywords
"get"	CTK_get
"infix"	CTK_infix
"mutating"	CTK_mutating
"nonmutating"	CTK_nonmutating
"operator"	CTK_operator
"override"	CTK_override
"postfix"	CTK_postfix
"prefix"	CTK_prefix
"set"	CTK_set

//Integer Literals
[0-9][0-9_]*	integer_literal
0x[0-9a-fA-F][0-9a-fA-F_]*	integer_literal
0o[0-7][0-7_]*	integer_literal
0b[01][01_]*	integer_literal

//Floating Point Literals
[0-9][0-9_]*\.[0-9][0-9_]*	floating_literal
[0-9][0-9_]*\.[0-9][0-9_]*[eE][+-]?[0-9][0-9_]*	floating_literal
[0-9][0-9_]*[eE][+-]?[0-9][0-9_]*	floating_literal
0x[0-9A-Fa-f][0-9A-Fa-f_]*(\.[0-9A-Fa-f][0-9A-Fa-f_]*)?[pP][+-]?[0-9][0-9_]*	floating_literal

////Character Literals
//character_literal ::= '[^'\\\n\r]|character_escape'
//character_escape  ::= [\]0 [\][\] | [\]t | [\]n | [\]r | [\]" | [\]'
//character_escape  ::= [\]x hex hex
//character_escape  ::= [\]u hex hex hex hex
//character_escape  ::= [\]U hex hex hex hex hex hex hex hex
//hex               ::= [0-9a-fA-F]

//String Literals
//FIXME: Forcing + to concatenate strings is somewhat gross, a proper protocol would be better.

//string_literal   ::= ["]([^"\\\n\r]|character_escape|escape_expr)*["]
//escape_expr      ::= [\]escape_expr_body
//escape_expr_body ::= [(]escape_expr_body[)]
//escape_expr_body ::= [^\n\r"()]

\"(\\.|[^"\r\n\\])*\"	string_literal

/////Identifier Tokens
///identifier ::= id-start id-continue*
///
///// An identifier can start with an ASCII letter or underscore...
///id-start ::= [A-Za-z_]
///
///// or a Unicode alphanumeric character in the Basic Multilingual Plane...
///// (excluding combining characters, which can't appear initially)
///id-start ::= [\u00A8\u00AA\u00AD\u00AF\u00B2-\u00B5\u00B7-00BA]
///id-start ::= [\u00BC-\u00BE\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF]
///id-start ::= [\u0100-\u02FF\u0370-\u167F\u1681-\u180D\u180F-\u1DBF]
///id-start ::= [\u1E00-\u1FFF]
///id-start ::= [\u200B-\u200D\u202A-\u202E\u203F-\u2040\u2054\u2060-\u206F]
///id-start ::= [\u2070-\u20CF\u2100-\u218F\u2460-\u24FF\u2776-\u2793]
///id-start ::= [\u2C00-\u2DFF\u2E80-\u2FFF]
///id-start ::= [\u3004-\u3007\u3021-\u302F\u3031-\u303F\u3040-\uD7FF]
///id-start ::= [\uF900-\uFD3D\uFD40-\uFDCF\uFDF0-\uFE1F\uFE30-FE44]
///id-start ::= [\uFE47-\uFFFD]
///
///// or a non-private-use, valid code point outside of the BMP.
///id-start ::= [\u10000-\u1FFFD\u20000-\u2FFFD\u30000-\u3FFFD\u40000-\u4FFFD]
///id-start ::= [\u50000-\u5FFFD\u60000-\u6FFFD\u70000-\u7FFFD\u80000-\u8FFFD]
///id-start ::= [\u90000-\u9FFFD\uA0000-\uAFFFD\uB0000-\uBFFFD\uC0000-\uCFFFD]
///id-start ::= [\uD0000-\uDFFFD\uE0000-\uEFFFD]
///
///// After the first code point, an identifier can contain ASCII digits...
///id-continue ::= [0-9]
///
///// and/or combining characters...
///id-continue ::= [\u0300-\u036F\u1DC0-\u1DFF\u20D0-\u20FF\uFE20-\uFE2F]
///
///// in addition to the starting character set.
///id-continue ::= id-start
///
///identifier-or-any ::= identifier
///identifier-or-any ::= '_'

/////Implementation Identifier Token
///dollarident ::= '$' id-continue+
/////Escaped Identifiers
///identifier ::= '`' id-start id-continue* '`'
"$"{ID}	dollarident
"`"{ID}"`"	identifier
{ID}	identifier
"@"{ID} anotation

%%