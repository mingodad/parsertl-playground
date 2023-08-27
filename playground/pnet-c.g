/*
 * c_grammar.y - Input file for yacc that defines the syntax of the C language.
 *
 * Copyright (C) 2002  Southern Storm Software, Pty Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

 %token ILLEGAL_CHARACTER

/*Tokens*/
%token IDENTIFIER
%token INTEGER_CONSTANT
%token FLOAT_CONSTANT
%token IMAG_CONSTANT
%token STRING_LITERAL
%token WSTRING_LITERAL
%token CS_STRING_LITERAL
%token TYPE_NAME
%token NAMESPACE_NAME
%token PTR_OP
%token INC_OP
%token DEC_OP
%token LEFT_OP
%token RIGHT_OP
%token LE_OP
%token GE_OP
%token EQ_OP
%token NE_OP
%token AND_OP
%token OR_OP
%token MUL_ASSIGN_OP
%token DIV_ASSIGN_OP
%token MOD_ASSIGN_OP
%token ADD_ASSIGN_OP
%token SUB_ASSIGN_OP
%token LEFT_ASSIGN_OP
%token RIGHT_ASSIGN_OP
%token AND_ASSIGN_OP
%token XOR_ASSIGN_OP
%token OR_ASSIGN_OP
%token COLON_COLON_OP
%token K_ASM
%token K_AUTO
%token K_BREAK
%token K_CASE
%token K_CHAR
%token K_CONST
%token K_CONTINUE
%token K_DEFAULT
%token K_DO
%token K_DOUBLE
%token K_ELSE
%token K_ENUM
%token K_EXTERN
%token K_FLOAT
%token K_FOR
%token K_GOTO
%token K_IF
%token K_INLINE
%token K_INT
%token K_LONG
%token K_REGISTER
%token K_RETURN
%token K_SHORT
%token K_SIGNED
%token K_SIZEOF
%token K_STATIC
%token K_STRUCT
%token K_SWITCH
%token K_TYPEDEF
%token K_TYPEOF
%token K_UNION
%token K_UNSIGNED
%token K_VOID
%token K_VOLATILE
%token K_WHILE
%token K_ELIPSIS
%token K_VA_LIST
%token K_VA_START
%token K_VA_ARG
%token K_VA_END
%token K_SETJMP
%token K_ALLOCA
%token K_ATTRIBUTE
%token K_BOOL
%token K_WCHAR
%token K_FUNCTION
%token K_FUNC
%token K_INT64
%token K_UINT
%token K_TRY
%token K_CATCH
%token K_FINALLY
%token K_THROW
%token K_CHECKED
%token K_UNCHECKED
%token K_NULL
%token K_TRUE
%token K_FALSE
%token K_LOCK
%token K_USING
%token K_NAMESPACE
%token K_NEW
%token K_DELETE
%token K_CS_TYPEOF
%token K_BOX
%token K_DECLSPEC
%token K_GC
%token K_NOGC
%token '('
%token ')'
%token '['
%token ']'
%token '.'
%token ','
%token '-'
%token '+'
%token '~'
%token '!'
%token '&'
%token '*'
%token '/'
%token '%'
%token '<'
%token '>'
%token '^'
%token '|'
%token '?'
%token ':'
%token '='
%token ';'
%token '{'
%token '}'


%start File

%%

AnyIdentifier :
	IDENTIFIER
	| TYPE_NAME
	| NAMESPACE_NAME
	;

Identifier :
	IDENTIFIER
	;

PrimaryExpression :
	Identifier
	| INTEGER_CONSTANT
	| FLOAT_CONSTANT
	| IMAG_CONSTANT
	| StringLiteral
	| WStringLiteral
	| CSharpStringLiteral
	| K_FUNC
	| K_NULL
	| K_TRUE
	| K_FALSE
	| '(' Expression ')'
	| '(' CompoundStatement ')'
	//| '(' error ')'
	;

StringLiteral :
	STRING_LITERAL
	| K_FUNCTION
	| StringLiteral STRING_LITERAL
	| StringLiteral K_FUNCTION
	;

WStringLiteral :
	WSTRING_LITERAL
	| WStringLiteral WSTRING_LITERAL
	;

CSharpStringLiteral :
	CS_STRING_LITERAL
	| CSharpStringLiteral CS_STRING_LITERAL
	;

PostfixExpression :
	PrimaryExpression
	| PostfixExpression '[' Expression ']'
	| PostfixExpression '(' ')'
	| PostfixExpression '(' ArgumentExpressionList ')'
	| PostfixExpression '.' AnyIdentifier
	| TYPE_NAME COLON_COLON_OP AnyIdentifier
	| NamespaceQualifiedType COLON_COLON_OP AnyIdentifier
	| PostfixExpression COLON_COLON_OP AnyIdentifier
	| PostfixExpression PTR_OP AnyIdentifier
	| PostfixExpression INC_OP
	| PostfixExpression DEC_OP
	| K_VA_ARG '(' UnaryExpression ',' TypeName ')'
	| K_VA_START '(' UnaryExpression ',' Identifier ')'
	| K_VA_START '(' UnaryExpression ')'
	| K_VA_END '(' UnaryExpression ')'
	| K_SETJMP '(' UnaryExpression ')'
	| K_ALLOCA '(' AssignmentExpression ')'
	;

ArgumentExpressionList :
	AssignmentExpression
	| ArgumentExpressionList ',' AssignmentExpression
	;

UnaryExpression :
	PostfixExpression
	| INC_OP UnaryExpression
	| DEC_OP UnaryExpression
	| '-' CastExpression
	| '+' CastExpression
	| '~' CastExpression
	| '!' CastExpression
	| '&' CastExpression
	| '*' CastExpression
	| K_SIZEOF UnaryExpression
	| K_SIZEOF '(' TypeName ')'
	| AND_OP IDENTIFIER
	| K_CHECKED '(' Expression ')'
	| K_UNCHECKED '(' Expression ')'
	| K_CS_TYPEOF UnaryExpression
	| K_CS_TYPEOF '(' TypeName ')'
	| K_BOX '(' Expression ')'
	| NewExpression
	| DeleteExpression
	;

CastExpression :
	UnaryExpression
	| '(' TypeName ')' CastExpression
	;

NewExpression :
	New TypeId '(' ')'
	| New TypeId '(' ArgumentExpressionList ')'
	| K_GC New TypeId '(' ')'
	| K_GC New TypeId '(' ArgumentExpressionList ')'
	| K_NOGC New TypeId '(' ')'
	| K_NOGC New TypeId '(' ArgumentExpressionList ')'
	| New TypeId '[' Expression ']'
	| K_GC New TypeId '[' Expression ']'
	| K_NOGC New TypeId '[' Expression ']'
	;

DeleteExpression :
	Delete CastExpression
	| Delete '[' ']' CastExpression
	| Delete '[' Expression ']' CastExpression
	;

New :
	K_NEW
	| COLON_COLON_OP K_NEW
	;

Delete :
	K_DELETE
	| COLON_COLON_OP Delete
	;

MultiplicativeExpression :
	CastExpression
	| MultiplicativeExpression '*' CastExpression
	| MultiplicativeExpression '/' CastExpression
	| MultiplicativeExpression '%' CastExpression
	;

AdditiveExpression :
	MultiplicativeExpression
	| AdditiveExpression '+' MultiplicativeExpression
	| AdditiveExpression '-' MultiplicativeExpression
	;

ShiftExpression :
	AdditiveExpression
	| ShiftExpression LEFT_OP AdditiveExpression
	| ShiftExpression RIGHT_OP AdditiveExpression
	;

RelationalExpression :
	ShiftExpression
	| RelationalExpression '<' ShiftExpression
	| RelationalExpression '>' ShiftExpression
	| RelationalExpression LE_OP ShiftExpression
	| RelationalExpression GE_OP ShiftExpression
	;

EqualityExpression :
	RelationalExpression
	| EqualityExpression EQ_OP RelationalExpression
	| EqualityExpression NE_OP RelationalExpression
	;

AndExpression :
	EqualityExpression
	| AndExpression '&' EqualityExpression
	;

XorExpression :
	AndExpression
	| XorExpression '^' AndExpression
	;

OrExpression :
	XorExpression
	| OrExpression '|' XorExpression
	;

LogicalAndExpression :
	OrExpression
	| LogicalAndExpression AND_OP OrExpression
	;

LogicalOrExpression :
	LogicalAndExpression
	| LogicalOrExpression OR_OP LogicalAndExpression
	;

ConditionalExpression :
	LogicalOrExpression
	| LogicalOrExpression '?' Expression ':' AssignmentExpression
	;

AssignmentExpression :
	ConditionalExpression
	| LogicalOrExpression '=' AssignmentExpression
	| LogicalOrExpression MUL_ASSIGN_OP AssignmentExpression
	| LogicalOrExpression DIV_ASSIGN_OP AssignmentExpression
	| LogicalOrExpression MOD_ASSIGN_OP AssignmentExpression
	| LogicalOrExpression ADD_ASSIGN_OP AssignmentExpression
	| LogicalOrExpression SUB_ASSIGN_OP AssignmentExpression
	| LogicalOrExpression LEFT_ASSIGN_OP AssignmentExpression
	| LogicalOrExpression RIGHT_ASSIGN_OP AssignmentExpression
	| LogicalOrExpression AND_ASSIGN_OP AssignmentExpression
	| LogicalOrExpression XOR_ASSIGN_OP AssignmentExpression
	| LogicalOrExpression OR_ASSIGN_OP AssignmentExpression
	;

Expression :
	AssignmentExpression
	| Expression ',' AssignmentExpression
	;

ConstantExpression :
	ConditionalExpression
	;

Declaration :
	DeclarationSpecifiers ';'
	| DeclarationSpecifiers InitDeclaratorList ';'
	;

DeclarationSpecifiers :
	StorageClassSpecifier
	| StorageClassSpecifier DeclarationSpecifiers
	| TypeSpecifier
	| TypeSpecifier DeclarationSpecifiers
	;

InitDeclaratorList :
	InitDeclarator
	| InitDeclaratorList ',' InitDeclarator
	;

InitDeclarator :
	Declarator
	| Declarator '=' Initializer
	;

StorageClassSpecifier :
	K_TYPEDEF
	| K_EXTERN
	| K_STATIC
	| K_AUTO
	| K_REGISTER
	| K_INLINE
	| K_DECLSPEC '(' DeclSpecArg ')'
	;

TypeSpecifier :
	K_CHAR
	| K_SHORT
	| K_INT
	| K_LONG
	| K_INT64
	| K_UINT
	| K_SIGNED
	| K_UNSIGNED
	| K_FLOAT
	| K_DOUBLE
	| K_CONST
	| K_VOLATILE
	| K_BOX
	| K_VOID
	| K_BOOL
	| K_WCHAR
	| K_VA_LIST
	| StructOrUnionSpecifier
	| EnumSpecifier
	| K_TYPEOF '(' Expression ')'
	| K_TYPEOF '(' TypeName ')'
	| TYPE_NAME
	| NamespaceQualifiedType
	;

DeclSpecArg :
	/*empty*/
	| AnyIdentifier
	| AnyIdentifier '(' StringLiteral ')'
	;

StructOrUnionSpecifier :
	StructOrUnion AnyIdentifier '{' StructDeclarationList '}'
	| StructOrUnion '{' StructDeclarationList '}'
	| StructOrUnion AnyIdentifier
	;

StructOrUnion :
	K_STRUCT
	| K_UNION
	;

StructDeclarationList :
	/*empty*/
	| StructDeclarationList2
	;

StructDeclarationList2 :
	StructDeclaration
	| StructDeclarationList2 StructDeclaration
	;

StructDeclaration :
	TypeSpecifierList StructDeclaratorList ';'
	;

StructDeclaratorList :
	StructDeclarator
	| StructDeclaratorList ',' StructDeclarator
	;

StructDeclarator :
	Declarator
	| ':' ConstantExpression
	| Declarator ':' ConstantExpression
	| TYPE_NAME
	| TYPE_NAME ':' ConstantExpression
	;

EnumSpecifier :
	K_ENUM '{' EnumeratorList '}'
	| K_ENUM AnyIdentifier '{' EnumeratorList '}'
	| K_ENUM AnyIdentifier
	;

EnumeratorList :
	EnumeratorListNoComma
	| EnumeratorListNoComma ','
	//| error
	;

EnumeratorListNoComma :
	Enumerator
	| EnumeratorListNoComma ',' Enumerator
	;

Enumerator :
	IDENTIFIER
	| IDENTIFIER '=' ConstantExpression
	;

QualifiedIdentifier :
	AnyIdentifier
	| QualifiedIdentifier '.' AnyIdentifier
	;

Declarator :
	Declarator2
	| Pointer Declarator2
	;

Declarator2 :
	IDENTIFIER
	| IDENTIFIER Attributes
	| '(' Declarator ')'
	| Declarator2 GCSpecifier '[' ']'
	| Declarator2 GCSpecifier '[' ']' Attributes
	| Declarator2 GCSpecifier '[' ConstantExpression ']'
	| Declarator2 GCSpecifier '[' ConstantExpression ']' Attributes
	| Declarator2 '(' ')'
	| Declarator2 '(' ')' Attributes
	| Declarator2 '(' ParameterTypeList ')'
	| Declarator2 '(' ParameterTypeList ')' Attributes
	| Declarator2 '(' ParameterIdentifierList ')'
	| Declarator2 '(' ParameterIdentifierList ')' Attributes
	;

GCSpecifier :
	/*empty*/
	| K_GC
	| K_NOGC
	;

Attributes :
	K_ATTRIBUTE '(' '(' AttributeList ')' ')'
	;

AttributeList :
	Attribute
	| AttributeList ',' Attribute
	;

Attribute :
	AnyIdentifier
	| AnyIdentifier '(' AttributeArgs ')'
	| K_CONST
	;

ConstantAttributeExpression :
	ConditionalExpression
	;

AttributeArgs :
	ConstantAttributeExpression
	| AttributeArgs ',' ConstantAttributeExpression
	;

Pointer :
	'*'
	| '*' TypeQualifierList
	| '*' Pointer
	| '*' TypeQualifierList Pointer
	| '&'
	| '&' TypeQualifierList
	| '&' Pointer
	| '&' TypeQualifierList Pointer
	;

TypeQualifier :
	K_CONST
	| K_VOLATILE
	;

TypeQualifierList :
	TypeQualifier
	| TypeQualifierList TypeQualifier
	;

TypeSpecifierList :
	TypeSpecifier
	| TypeSpecifierList TypeSpecifier
	;

TypeId :
	TypeSpecifierList
	;

ParameterIdentifierList :
	IdentifierList
	| IdentifierList ',' K_ELIPSIS
	;

IdentifierList :
	IDENTIFIER
	| IdentifierList ',' IDENTIFIER
	;

ParameterTypeList :
	ParameterList
	| ParameterList ',' K_ELIPSIS
	;

ParameterList :
	ParameterDeclaration
	| ParameterList ',' ParameterDeclaration
	;

ParameterDeclaration :
	TypeSpecifierList Declarator
	| K_REGISTER TypeSpecifierList Declarator
	| TypeName
	| K_REGISTER TypeName
	;

TypeName :
	TypeSpecifierList
	| TypeSpecifierList AbstractDeclarator
	;

AbstractDeclarator :
	Pointer
	| AbstractDeclarator2
	| Pointer AbstractDeclarator2
	;

AbstractDeclarator2 :
	'(' AbstractDeclarator ')'
	| GCSpecifier '[' ']'
	| GCSpecifier '[' ']' Attributes
	| GCSpecifier '[' ConstantExpression ']'
	| GCSpecifier '[' ConstantExpression ']' Attributes
	| AbstractDeclarator2 GCSpecifier '[' ']'
	| AbstractDeclarator2 GCSpecifier '[' ']' Attributes
	| AbstractDeclarator2 GCSpecifier '[' ConstantExpression ']'
	| AbstractDeclarator2 GCSpecifier '[' ConstantExpression ']' Attributes
	| '(' ')'
	| '(' ')' Attributes
	| '(' ParameterTypeList ')'
	| '(' ParameterTypeList ')' Attributes
	| AbstractDeclarator2 '(' ')'
	| AbstractDeclarator2 '(' ')' Attributes
	| AbstractDeclarator2 '(' ParameterTypeList ')'
	| AbstractDeclarator2 '(' ParameterTypeList ')' Attributes
	;

Initializer :
	AssignmentExpression
	| '{' InitializerList '}'
	| '{' InitializerList ',' '}'
	;

InitializerList :
	Initializer
	| InitializerList ',' Initializer
	;

Statement :
	Statement2
	;

Statement2 :
	LabeledStatement
	| CompoundStatement
	| ExpressionStatement
	| SelectionStatement
	| IterationStatement
	| JumpStatement
	| AsmStatement
	| CSharpStatement
	//| error ';'
	;

LabeledStatement :
	IDENTIFIER ':' Statement
	| K_CASE ConstantExpression ':' Statement
	| K_DEFAULT ':' Statement
	;

CompoundStatement :
	'{' OptDeclarationList OptStatementList '}'
	;

OptDeclarationList :
	DeclarationList
	| /*empty*/
	;

DeclarationList :
	Declaration
	| DeclarationList Declaration
	;

OptStatementList :
	StatementList
	| /*empty*/
	;

StatementList :
	Statement
	| StatementList Statement
	;

ExpressionStatement :
	';'
	| Expression ';'
	;

BoolExpression :
	Expression
	;

SelectionStatement :
	K_IF '(' BoolExpression ')' Statement
	| K_IF '(' BoolExpression ')' Statement K_ELSE Statement
	| K_SWITCH '(' Expression ')' Statement
	;

IterationStatement :
	K_WHILE '(' BoolExpression ')' Statement
	| K_DO Statement K_WHILE '(' BoolExpression ')' ';'
	| K_FOR '(' ';' ';' ')' Statement
	| K_FOR '(' ';' ';' Expression ')' Statement
	| K_FOR '(' ';' BoolExpression ';' ')' Statement
	| K_FOR '(' ';' BoolExpression ';' Expression ')' Statement
	| K_FOR '(' Expression ';' ';' ')' Statement
	| K_FOR '(' Expression ';' ';' Expression ')' Statement
	| K_FOR '(' Expression ';' BoolExpression ';' ')' Statement
	| K_FOR '(' Expression ';' BoolExpression ';' Expression ')' Statement
	;

JumpStatement :
	K_GOTO IDENTIFIER ';'
	| K_GOTO '*' Expression ';'
	| K_CONTINUE ';'
	| K_BREAK ';'
	| K_RETURN ';'
	| K_RETURN Expression ';'
	;

AsmStatement :
	K_ASM '(' StringLiteral ':' ':' ')'
	| K_ASM '(' StringLiteral COLON_COLON_OP ')'
	| K_ASM K_VOLATILE '(' StringLiteral ':' ':' ')'
	| K_ASM K_VOLATILE '(' StringLiteral COLON_COLON_OP ')'
	;

CSharpStatement :
	TryStatement
	| ThrowStatement
	| CheckedStatement
	| LockStatement
	;

TryStatement :
	K_TRY CompoundStatement CatchClauses
	| K_TRY CompoundStatement FinallyClause
	| K_TRY CompoundStatement CatchClauses FinallyClause
	;

CatchClauses :
	SpecificCatchClauses OptGeneralCatchClause
	| OptSpecificCatchClauses GeneralCatchClause
	;

OptSpecificCatchClauses :
	/*empty*/
	| SpecificCatchClauses
	;

SpecificCatchClauses :
	SpecificCatchClause
	| SpecificCatchClauses SpecificCatchClause
	;

SpecificCatchClause :
	K_CATCH CatchNameInfo CompoundStatement
	;

CatchNameInfo :
	/*empty*/
	| '(' TypeName Identifier ')'
	| '(' TypeName ')'
	//| '(' error ')'
	;

OptGeneralCatchClause :
	/*empty*/
	| GeneralCatchClause
	;

GeneralCatchClause :
	K_CATCH CompoundStatement
	;

FinallyClause :
	K_FINALLY CompoundStatement
	;

ThrowStatement :
	K_THROW ';'
	| K_THROW Expression ';'
	;

CheckedStatement :
	K_CHECKED CompoundStatement
	| K_UNCHECKED CompoundStatement
	;

LockStatement :
	K_LOCK '(' Expression ')' Statement
	;

File :
	File2
	| /*empty*/
	;

File2 :
	ExternalDefinition
	| File2 ExternalDefinition
	;

ExternalDefinition :
	FunctionDefinition
	| Declaration
	| UsingDeclaration
	//| error ';'
	//| error '}'
	| ';'
	;

FunctionDefinition :
	Declarator OptParamDeclarationList '{' FunctionBody '}'
	| DeclarationSpecifiers Declarator OptParamDeclarationList '{' FunctionBody '}'
	;

OptParamDeclarationList :
	ParamDeclarationList
	| /*empty*/
	;

ParamDeclarationList :
	ParamDeclaration
	| ParamDeclarationList ParamDeclaration
	;

ParamDeclaration :
	DeclarationSpecifiers ParamDeclaratorList ';'
	;

ParamDeclaratorList :
	ParamDeclarator
	| ParamDeclaratorList ',' ParamDeclarator
	;

ParamDeclarator :
	Declarator
	;

FunctionBody :
	OptDeclarationList OptStatementList
	;

UsingDeclaration :
	K_USING K_NAMESPACE TypeOrNamespaceDesignator ';'
	| K_USING TypeOrNamespaceDesignator ';'
	| K_USING '[' QualifiedIdentifier ']' TypeOrNamespaceDesignator ';'
	;

TypeOrNamespaceDesignator :
	AnyIdentifier
	| TypeOrNamespaceDesignator COLON_COLON_OP AnyIdentifier
	;

NamespaceQualifiedType :
	NAMESPACE_NAME COLON_COLON_OP NamespaceQualifiedRest
	;

NamespaceQualifiedRest :
	TYPE_NAME
	| NAMESPACE_NAME COLON_COLON_OP NamespaceQualifiedRest
	;

%%

DIGIT			[0-9]
IDALPHA			[a-zA-Z_$]
HEX				[a-fA-F0-9]
EXPONENT		[Ee][+-]?{DIGIT}+
IEXPONENT		[Ii][+-]?{DIGIT}+
FTYPE			(f|F|l|L)
ITYPE			(u|U|l|L)*
WHITE			[ \t\v\r\f]

%%

^{WHITE}*"#"{WHITE}+{DIGIT}+{WHITE}+["](\\.|[^\\"])*["].*\n	  skip()
^{WHITE}*"#line"{WHITE}+{DIGIT}+{WHITE}+["](\\.|[^\\"])*["].*\n skip()
^{WHITE}*"#pragma"[^\n]*\n		 skip() /* Ignore pragma directives */
^{WHITE}*"#ident"[^\n]*\n		skip() /* Ignore ident directives */
^{WHITE}*"#using"[^\n]*\n		skip()
^{WHITE}*"#"{IDALPHA}({DIGIT}|{IDALPHA})*[^\n]*\n	skip()

"++"					INC_OP
"--"					DEC_OP
"<<"					LEFT_OP
">>"					RIGHT_OP
"<="					LE_OP
">="					GE_OP
"=="					EQ_OP
"!="					NE_OP
"&&"					AND_OP
"||"					OR_OP
"*="					MUL_ASSIGN_OP
"/="					DIV_ASSIGN_OP
"%="					MOD_ASSIGN_OP
"+="					ADD_ASSIGN_OP
"-="					SUB_ASSIGN_OP
"<<="					LEFT_ASSIGN_OP
">>="					RIGHT_ASSIGN_OP
"&="					AND_ASSIGN_OP
"^="					XOR_ASSIGN_OP
"|="					OR_ASSIGN_OP
"->"					PTR_OP
"::"					COLON_COLON_OP

"asm"					K_ASM
"__asm__"				K_ASM
"auto"					K_AUTO
"break"					K_BREAK
"case"					K_CASE
"char"					K_CHAR
"const"					K_CONST
"__const__"				K_CONST
"continue"				K_CONTINUE
"default"				K_DEFAULT
"do"					K_DO
"double"				K_DOUBLE
"else"					K_ELSE
"enum"					K_ENUM
"extern"				K_EXTERN
"float"					K_FLOAT
"for"					K_FOR
"goto"					K_GOTO
"if"					K_IF
"inline"				K_INLINE
"__inline__"			K_INLINE
"int"					K_INT
"long"					K_LONG
"register"				K_REGISTER
"return"				K_RETURN
"short"					K_SHORT
"signed"				K_SIGNED
"__signed__"			K_SIGNED
"sizeof"				K_SIZEOF
"static"				K_STATIC
"struct"				K_STRUCT
"switch"				K_SWITCH
"typedef"				K_TYPEDEF
"typeof"				K_TYPEOF
"__typeof__"			K_TYPEOF
"union"					K_UNION
"unsigned"				K_UNSIGNED
"void"					K_VOID
"volatile"				K_VOLATILE
"__volatile__"			K_VOLATILE
"while"					K_WHILE

"..."					K_ELIPSIS
"__builtin_va_list"		K_VA_LIST
"__builtin_va_start"	K_VA_START
"__builtin_va_arg"		K_VA_ARG
"__builtin_va_end"		K_VA_END
"__builtin_setjmp"		K_SETJMP
"__builtin_alloca"		K_ALLOCA
"__attribute__"			K_ATTRIBUTE

"_Bool"					K_BOOL
"__wchar__"				K_WCHAR
"__unsigned_int__"		K_UINT

"__FUNCTION__"			K_FUNCTION
"__PRETTY_FUNCTION__"	K_FUNCTION
"__func__"				K_FUNC

"__try__"				K_TRY /* Counterparts to C# keywords */
"__catch__"				K_CATCH
"__finally__"			K_FINALLY
"__throw__"				K_THROW
"__checked__"			K_CHECKED
"__unchecked__"			K_UNCHECKED
"__null__"				K_NULL
"__true__"				K_TRUE
"__false__"				K_FALSE
"__lock__"				K_LOCK
"__using__"				K_USING
"__namespace__"			K_NAMESPACE
"__new__"				K_NEW
"__delete__"			K_DELETE

"__typeof"				K_CS_TYPEOF /* Managed C++ compat */
"__int64"				K_INT64
"__finally"				K_FINALLY
"__box"					K_BOX
"__declspec"			K_DECLSPEC
"__gc"					K_GC
"__nogc"				K_NOGC

\"(\\.|[^\\"])*\"				STRING_LITERAL

L\"(\\.|[^\\"])*\"				WSTRING_LITERAL

l\"(\\.|[^\\"])*\"				WSTRING_LITERAL

S\"(\\.|[^\\"])*\"				CS_STRING_LITERAL

s\"(\\.|[^\\"])*\"				CS_STRING_LITERAL

'(\\.|[^\\'])+'					INTEGER_CONSTANT

L'(\\.|[^\\'])+'				INTEGER_CONSTANT

l'(\\.|[^\\'])+'				INTEGER_CONSTANT

TYPE_NAME	TYPE_NAME
NAMESPACE_NAME	NAMESPACE_NAME
			/* Use the scope to determine if this is a typedef'ed name */
/*
			yylval.name = ILInternString(yytext, strlen(yytext)).string;
			if(CScopeIsTypedef(yylval.name))
			{
				RETURNTOK(TYPE_NAME);
			}
			else if(CScopeIsNamespace(yylval.name))
			{
				RETURNTOK(NAMESPACE_NAME);
			}
			else
			{
				RETURNTOK(IDENTIFIER);
			}
*/
{IDALPHA}({DIGIT}|{IDALPHA})*	IDENTIFIER

{DIGIT}+{EXPONENT}{FTYPE}?		FLOAT_CONSTANT
{DIGIT}*"."{DIGIT}+({EXPONENT})?{FTYPE}?	FLOAT_CONSTANT
{DIGIT}+"."{DIGIT}*({EXPONENT})?{FTYPE}?	FLOAT_CONSTANT

{DIGIT}+{IEXPONENT}{FTYPE}?		IMAG_CONSTANT
{DIGIT}*"."{DIGIT}+{IEXPONENT}{FTYPE}?	IMAG_CONSTANT
{DIGIT}+"."{DIGIT}*{IEXPONENT}{FTYPE}?	IMAG_CONSTANT

0[xX]{HEX}+{ITYPE}?				INTEGER_CONSTANT
0[0-7]*{ITYPE}?					INTEGER_CONSTANT
{DIGIT}+{ITYPE}?				INTEGER_CONSTANT

{WHITE}+						skip()

\n								skip()

"("	'('
")"	')'
"["	'['
"]"	']'
"."	'.'
","	','
"-"	'-'
"+"	'+'
"~"	'~'
"!"	'!'
"&"	'&'
"*"	'*'
"/"	'/'
"%"	'%'
"<"	'<'
">"	'>'
"^"	'^'
"|"	'|'
"?"	'?'
":"	':'
"="	'='
";"	';'
"{"	'{'
"}"	'}'

.								ILLEGAL_CHARACTER

%%
