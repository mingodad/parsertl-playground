//From: https://github.com/ltcmelo/uaiso/blob/master/D/D.y
/******************************************************************************
 * Copyright (c) 2014-2016 Leandro T. C. Melo (ltcmelo@gmail.com)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
 * USA
 *****************************************************************************/

/*--------------------------*/
/*--- The UaiSo! Project ---*/
/*--------------------------*/

%x BCOMMENT NBCOMMENT DQSTRING QCHAR ESCSEQ JOINBRACE
%x NOT_IN_HACK_ST NOT_IS_HACK_ST FLOAT_LIT1_ST	FLOAT_LIT2_ST

/*Tokens*/
%token ABSTRACT
%token ALIAS
%token ALIGN
%token ALIGNAS
%token ALIGNOF
%token AMPER_AMPER
%token AMPER_CARET
%token AMPER_CARET_EQ
%token AMPER_EQ
%token AND
%token ARROW_DASH
%token AS
%token ASM
%token ASSERT
%token AUTO
%token BEGIN_BUILTIN_TYPES
%token BEGIN_CHAR_LIT
%token BEGIN_COMMENT
%token BEGIN_KEYWORD
%token BEGIN_LIT
%token BEGIN_MULTICHAR_OPRTR
%token BEGIN_NUM_LIT
%token BEGIN_STR_LIT
%token BODY
%token BOOL
%token BREAK
%token BYTE
%token CARET_CARET
%token CARET_CARET_EQ
%token CARET_EQ
%token CASE
%token CAST
%token CATCH
%token CENT
%token CHAN
%token CHAR
%token CHAR_LIT
%token CHAR_UTF16
%token CHAR_UTF16_LIT
%token CHAR_UTF32
%token CHAR_UTF32_LIT
%token CLASS
%token COLON_COLON
%token COLON_EQ
%token COMMENT
%token COMPLETION
%token COMPLEX_FLOAT32
%token COMPLEX_FLOAT64
%token COMPLEX_REAL
%token CONST
%token CONSTEXPR
%token CONST_CAST
%token CONTINUE
%token DASH_ARROW
%token DASH_ARROW_STAR
%token DATA
%token DEBUG
%token DECLTYPE
%token DEDENT
%token DEF
%token DEFAULT
%token DEFER
%token DELEGATE
%token DELETE
%token DEPRECATED
%token DERIVING
%token DISABLE
%token DO
%token DOT_DOT
%token DOT_DOT_DOT
%token DOT_STAR
%token DOXY_COMMENT
%token DYNAMIC_CAST
%token ELIF
%token ELSE
%token END_ASCII
%token END_BUILTIN_TYPES
%token END_CHAR_LIT
%token END_COMMENT
%token END_KEYWORD
%token END_LIT
%token END_MULTICHAR_OPRTR
%token END_NUM_LIT
%token END_STR_LIT
%token ENUM
%token EOP
%token EQ_ARROW
%token EQ_EQ
%token EXCEPT
%token EXCLAM_EQ
%token EXCLAM_GR
%token EXCLAM_GR_EQ
%token EXCLAM_LS
%token EXCLAM_LS_EQ
%token EXCLAM_LS_GR
%token EXCLAM_LS_GR_EQ
%token EXEC
%token EXPLICIT
%token EXPORT
%token EXTERN
%token FALLTHROUGH
%token FALSE_VALUE
%token FINAL
%token FINALLY
%token FLOAT32
%token FLOAT64
%token FLOAT_LIT
%token FOR
%token FOREACH
%token FOREACH_REVERSE
%token FOREIGN
%token FRIEND
%token FROM
%token FUNC
%token FUNCTION
%token GLOBAL
%token GO
%token GOTO
%token GR_EQ
%token GR_GR
%token GR_GR_EQ
%token GR_GR_GR
%token GR_GR_GR_EQ
%token IDENT
%token IDENT_QUAL
%token IF
%token IMAG_FLOAT32
%token IMAG_FLOAT64
%token IMAG_REAL
%token IMMUTABLE
%token IMPORT
%token IN
%token INDENT
%token INFIX
%token INFIXL
%token INFIXR
%token INLINE
%token INOUT
%token INSTANCE
%token INT
%token INT16
%token INT32
%token INT64
%token INT8
%token INTERFACE
%token INT_LIT
%token INVALID
%token INVARIANT
%token IN_LBRACE_HACK
%token IS
%token JOKER
%token LAMBDA
%token LAZY
%token LET
%token LS_EQ
%token LS_GR
%token LS_GR_EQ
%token LS_LS
%token LS_LS_EQ
%token MACRO
%token MAP
%token MINUS_EQ
%token MINUS_MINUS
%token MIXIN
%token MODULE
%token MULTILINE_COMMENT
%token MULTILINE_DOXY_COMMENT
%token MUTABLE
%token NAMESPACE
%token NESTING_COMMENT
%token NEW
%token NEWLINE
%token NEWTYPE
%token NOEXCEPT
%token NOGC
%token NONLOCAL
%token NOT
%token NOTHROW
%token NOT_IN_HACK
%token NOT_IS_HACK
%token NULL_VALUE
%token OF
%token OPRTR
%token OR
%token OUT
%token OVERRIDE
%token PACKAGE
%token PASS
%token PERCENT_EQ
%token PIPE_EQ
%token PIPE_PIPE
%token PLUS_EQ
%token PLUS_PLUS
%token POUND_POUND
%token PRAGMA
%token PRINT
%token PRIVATE
%token PROPERTY
%token PROPER_IDENT
%token PROPER_IDENT_QUAL
%token PROTECTED
%token PUBLIC
%token PUNC_IDENT
%token PUNC_IDENT_QUAL
%token PURE
%token RAISE
%token RANGE
%token RAW_STR_LIT
%token RAW_UTF16_STR_LIT
%token RAW_UTF32_STR_LIT
%token RAW_UTF8_STR_LIT
%token REAL
%token REF
%token REGISTER
%token REINTERPRET_CAST
%token RETURN
%token RUNE
%token SAFE
%token SCOPE
%token SELECT
%token SHARED
%token SIZEOF
%token SLASH_EQ
%token SLASH_SLASH
%token SLASH_SLASH_EQ
%token SPECIAL_IDENT
%token SPECIAL_IDENT_QUAL
%token STAR_EQ
%token STAR_STAR
%token STAR_STAR_EQ
%token STATIC
%token STATIC_ASSERT
%token STATIC_CAST
%token STRUCT
%token STR_LIT
%token STR_UTF16_LIT
%token STR_UTF32_LIT
%token STR_UTF8_LIT
%token SUPER
%token SWITCH
%token SYNCHRONIZED
%token SYSTEM
%token TEMPLATE
%token THEN
%token THIS
%token THREAD_LOCAL
%token THROW
%token TILDE_EQ
%token TRUE_VALUE
%token TRUSTED
%token TRY
%token TYPE
%token TYPEDEF
%token TYPEID
%token TYPENAME
%token TYPEOF
%token UBYTE
%token UCENT
%token UINT
%token UINT16
%token UINT32
%token UINT64
%token UINT8
%token UNION
%token UNITTEST
%token USING
%token VAR
%token VERSION
%token VIRTUAL
%token VOID
%token VOLATILE
%token WHERE
%token WHILE
%token WITH
%token YIELD
%token __ATTRIBUTE__
%token __DATE__MACRO
%token __EOF__MACRO
%token __FILE__MACRO
%token __FUNCTION__MACRO
%token __GSHARED
%token __LINE__MACRO
%token __MODULE__MACRO
%token __PARAMETERS
%token __PRETTY_FUNCTION__MACRO
%token __THREAD
%token __TIMESTAMP__MACRO
%token __TIME__MACRO
%token __TRAITS
%token __VECTOR
%token __VENDOR__MACRO
%token __VERSION__MACRO
%token PREFER_SHIFT
%token ','
%token '|'
%token '^'
%token '&'
%token '<'
%token '>'
%token '+'
%token '-'
%token '~'
%token '*'
%token '/'
%token '%'
%token '['
%token '('
%token '.'
%token ';'
%token '='
%token '?'
%token ':'
%token '!'
%token ')'
%token ']'
%token '$'
%token '{'
%token '}'
%token '@'

%nonassoc /*1*/ EOP
%nonassoc /*2*/ PREFER_SHIFT
%left /*3*/ ','
%left /*4*/ PIPE_PIPE
%left /*5*/ AMPER_AMPER
%left /*6*/ '|'
%left /*7*/ '^'
%left /*8*/ '&'
%left /*9*/ EQ_EQ EXCLAM_EQ EXCLAM_GR EXCLAM_GR_EQ EXCLAM_LS EXCLAM_LS_EQ EXCLAM_LS_GR EXCLAM_LS_GR_EQ GR_EQ IN IS LS_EQ LS_GR LS_GR_EQ NOT_IN_HACK NOT_IS_HACK '<' '>'
%left /*10*/ GR_GR GR_GR_GR LS_LS
%left /*11*/ '+' '-' '~'
%left /*12*/ '*' '/' '%'
%left /*13*/ CARET_CARET
%nonassoc /*14*/ DOT_DOT_DOT ELSE '[' '(' '.'

%start Top

%%

Top :
	Program
	//| error /*1N*/ Program
	;

Program :
	Decls
	| Decls EOP /*1N*/
	| MODULE NestedIdent ';' Decls
	| MODULE NestedIdent ';' Decls EOP /*1N*/
	;

Expr :
	AssignExpr
	| AssignExpr ',' /*3L*/ Expr
	;

AssignExpr :
	TerExpr
	| TerExpr '=' AssignExpr
	| TerExpr PLUS_EQ AssignExpr
	| TerExpr MINUS_EQ AssignExpr
	| TerExpr STAR_EQ AssignExpr
	| TerExpr SLASH_EQ AssignExpr
	| TerExpr PERCENT_EQ AssignExpr
	| TerExpr PIPE_EQ AssignExpr
	| TerExpr CARET_EQ AssignExpr
	| TerExpr CARET_CARET_EQ AssignExpr
	| TerExpr AMPER_EQ AssignExpr
	| TerExpr LS_LS_EQ AssignExpr
	| TerExpr GR_GR_EQ AssignExpr
	| TerExpr GR_GR_GR_EQ AssignExpr
	| TerExpr TILDE_EQ AssignExpr
	;

TerExpr :
	BinExpr
	| BinExpr '?' Expr ':' TerExpr
	;

BinExpr :
	UnaryExpr
	| BinExpr PIPE_PIPE /*4L*/ BinExpr
	| BinExpr AMPER_AMPER /*5L*/ BinExpr
	| BinExpr '|' /*6L*/ BinExpr
	| BinExpr '^' /*7L*/ BinExpr
	| BinExpr '&' /*8L*/ BinExpr
	| BinExpr EQ_EQ /*9L*/ BinExpr
	| BinExpr EXCLAM_EQ /*9L*/ BinExpr
	| BinExpr '<' /*9L*/ BinExpr
	| BinExpr '>' /*9L*/ BinExpr
	| BinExpr LS_EQ /*9L*/ BinExpr
	| BinExpr GR_EQ /*9L*/ BinExpr
	| BinExpr LS_GR /*9L*/ BinExpr
	| BinExpr LS_GR_EQ /*9L*/ BinExpr
	| BinExpr EXCLAM_LS_GR /*9L*/ BinExpr
	| BinExpr EXCLAM_LS_GR_EQ /*9L*/ BinExpr
	| BinExpr EXCLAM_LS /*9L*/ BinExpr
	| BinExpr EXCLAM_LS_EQ /*9L*/ BinExpr
	| BinExpr EXCLAM_GR /*9L*/ BinExpr
	| BinExpr EXCLAM_GR_EQ /*9L*/ BinExpr
	| BinExpr IS /*9L*/ BinExpr
	| BinExpr NOT_IS_HACK /*9L*/ BinExpr
	| BinExpr IN /*9L*/ BinExpr
	| BinExpr NOT_IN_HACK /*9L*/ BinExpr
	| BinExpr LS_LS /*10L*/ BinExpr
	| BinExpr GR_GR /*10L*/ BinExpr
	| BinExpr GR_GR_GR /*10L*/ BinExpr
	| BinExpr '+' /*11L*/ BinExpr
	| BinExpr '-' /*11L*/ BinExpr
	| BinExpr '~' /*11L*/ BinExpr
	| BinExpr '*' /*12L*/ BinExpr
	| BinExpr '/' /*12L*/ BinExpr
	| BinExpr '%' /*12L*/ BinExpr
	| BinExpr CARET_CARET /*13L*/ BinExpr
	;

UnaryExpr :
	'&' /*8L*/ UnaryExpr
	| '*' /*12L*/ UnaryExpr
	| '-' /*11L*/ UnaryExpr
	| '+' /*11L*/ UnaryExpr
	| '!' UnaryExpr
	| '~' /*11L*/ UnaryExpr
	| PLUS_PLUS UnaryExpr
	| MINUS_MINUS UnaryExpr
	| DELETE UnaryExpr
	| CAST '(' /*14N*/ Type ')' UnaryExpr
	| CAST '(' /*14N*/ ')' UnaryExpr
	| '(' /*14N*/ Type ')' '.' /*14N*/ NestedIdentOrTemplateInst
	| PostfixExpr
	;

PostfixExpr :
	PriExpr
	| PostfixExpr PLUS_PLUS
	| PostfixExpr MINUS_MINUS
	| PostfixExpr '.' /*14N*/ IdentOrTemplateInst
	| PostfixExpr '.' /*14N*/ NewExpr
	| PostfixExpr '(' /*14N*/ ')'
	| PostfixExpr '(' /*14N*/ ExprList ')'
	//| PostfixExpr '(' /*14N*/ ExprList error /*1N*/ PostfixExprSync
	| PostfixExpr '(' /*14N*/ ExprList EOP /*1N*/
	| PostfixExpr '[' /*14N*/ AssignExpr ']'
	//| PostfixExpr '[' /*14N*/ AssignExpr error /*1N*/ PostfixExprSync
	| PostfixExpr '[' /*14N*/ AssignExpr EOP /*1N*/
	| PostfixExpr '[' /*14N*/ ']'
	| PostfixExpr '[' /*14N*/ AssignExpr DOT_DOT AssignExpr ']'
	//| PostfixExpr '[' /*14N*/ AssignExpr DOT_DOT AssignExpr error /*1N*/ PostfixExprSync
	| PostfixExpr '[' /*14N*/ AssignExpr DOT_DOT AssignExpr EOP /*1N*/
	;

//PostfixExprSync :
//	']'
//	| ')'
//	| EOP /*1N*/
//	;

PriExpr :
	IdentOrTemplateInst
	| '.' /*14N*/ IdentOrTemplateInst
	| ThisExpr
	| SuperExpr
	| NewExpr
	| TypeidExpr
	| AssertExpr
	| MixinExpr
	| TypeQueryExpr
	| BuiltinType '.' /*14N*/ Ident
	| '$'
	| PointerLit
	| BoolLit
	| NumLit
	| StringLit
	| CharLit
	| ArrayLit
	| Lambda
	| '(' /*14N*/ Expr ')'
	;

ThisExpr :
	THIS
	;

SuperExpr :
	SUPER
	;

NewExpr :
	NEW Type %prec PREFER_SHIFT /*2N*/
	| NEW Type '(' /*14N*/ ')'
	| NEW Type '(' /*14N*/ ExprList ')'
	| NEW '(' /*14N*/ ')' Type %prec PREFER_SHIFT /*2N*/
	| NEW '(' /*14N*/ ExprList ')' Type %prec PREFER_SHIFT /*2N*/
	| NEW '(' /*14N*/ ExprList ',' /*3L*/ ')' Type %prec PREFER_SHIFT /*2N*/
	| NEW '(' /*14N*/ ')' Type '(' /*14N*/ ')'
	| NEW '(' /*14N*/ ExprList ')' Type '(' /*14N*/ ')'
	| NEW '(' /*14N*/ ExprList ',' /*3L*/ ')' Type '(' /*14N*/ ')'
	| NEW '(' /*14N*/ ')' Type '(' /*14N*/ ExprList ')'
	| NEW '(' /*14N*/ ExprList ')' Type '(' /*14N*/ ExprList ')'
	| NEW '(' /*14N*/ ExprList ',' /*3L*/ ')' Type '(' /*14N*/ ExprList ')'
	;

TypeidExpr :
	TYPEID '(' /*14N*/ NonExprType ')'
	| TYPEID '(' /*14N*/ Expr ')'
	;

AssertExpr :
	ASSERT '(' /*14N*/ AssignExpr ')'
	| ASSERT '(' /*14N*/ AssignExpr ',' /*3L*/ AssignExpr ')'
	;

MixinExpr :
	MIXIN '(' /*14N*/ AssignExpr ')'
	;

TypeQueryExpr :
	IS /*9L*/ '(' /*14N*/ Type ')'
	| IS /*9L*/ '(' /*14N*/ Type ':' IntrospectSpecialization ')'
	| IS /*9L*/ '(' /*14N*/ Type EQ_EQ /*9L*/ IntrospectSpecialization ')'
	| IS /*9L*/ '(' /*14N*/ Type Ident ')'
	| IS /*9L*/ '(' /*14N*/ Type Ident ':' IntrospectSpecialization ')'
	| IS /*9L*/ '(' /*14N*/ Type Ident EQ_EQ /*9L*/ IntrospectSpecialization ')'
	;

IntrospectSpecialization :
	Type
	| STRUCT
	| UNION
	| CLASS
	| INTERFACE
	| ENUM
	| FUNCTION
	| DELEGATE
	| SUPER
	| CONST
	| IMMUTABLE
	| INOUT
	| SHARED
	| RETURN
	;

ExprList :
	AssignExpr
	| ExprList ',' /*3L*/ AssignExpr
	;

Type :
	FullType
	| Attrs FullType
	| TypeQual '(' /*14N*/ Type ')'
	| Attrs TypeQual '(' /*14N*/ Type ')'
	| Type Composer
	| Type Signature
	;

UnqualType :
	FullType
	| UnqualType Composer
	;

NonExprType :
	UnnamedType
	| TypeQuals FullType
	| NonExprType Composer
	;

Composer :
	'[' /*14N*/ ']'
	| '[' /*14N*/ NonExprType ']'
	| '[' /*14N*/ AssignExpr ']'
	| '[' /*14N*/ AssignExpr DOT_DOT AssignExpr ']'
	| '*' /*12L*/
	;

Signature :
	FUNCTION ParamClauseDecl
	| FUNCTION ParamClauseDecl FuncAttrs
	| DELEGATE ParamClauseDecl
	| DELEGATE ParamClauseDecl FuncAttrs
	;

FullType :
	UnnamedType
	| NestedIdentOrTemplateInst %prec PREFER_SHIFT /*2N*/
	| '.' /*14N*/ NestedIdentOrTemplateInst
	;

UnnamedType :
	BuiltinType
	| TypeofExprType %prec PREFER_SHIFT /*2N*/
	| TypeofExprType '.' /*14N*/ NestedIdentOrTemplateInst
	;

TypeofExprType :
	TYPEOF '(' /*14N*/ Expr ')'
	| TYPEOF '(' /*14N*/ RETURN ')' %prec PREFER_SHIFT /*2N*/
	;

BuiltinType :
	BOOL
	| BYTE
	| UBYTE
	| INT16
	| UINT16
	| INT
	| UINT
	| INT64
	| UINT64
	| CHAR
	| CHAR_UTF16
	| CHAR_UTF32
	| FLOAT32
	| FLOAT64
	| REAL
	| IMAG_FLOAT32
	| IMAG_FLOAT64
	| IMAG_REAL
	| COMPLEX_FLOAT32
	| COMPLEX_FLOAT64
	| COMPLEX_REAL
	| VOID
	;

Decl :
	BasicDecl
	| TemplateDecl
	| CtorDecl
	| DtorDecl
	| Postblit
	| VersionDecl
	| DebugDecl
	| StaticAssert
	| UnitTestDecl
	| AliasThis
	| SelectiveDecl
	| InvariantDecl
	| '{' Decls '}'
	| Attrs '{' Decls '}'
	| Attrs ':' Decl
	;

BasicDecl :
	VarGroupDecl
	| FuncDecl
	| AliasDecl
	| EnumDecl
	| RecordDecl
	| AttrRecordDecl
	| ImportGroupDecl
	;

VarGroupDecl :
	Type VarDeclList ';'
	//| Type error /*1N*/
	| Type VarDeclList EOP /*1N*/
	//| Type VarDeclList error /*1N*/ VarGroupDeclSync
	| Attrs VarDeclList ';'
	| Attrs VarDeclList EOP /*1N*/
	//| Attrs VarDeclList error /*1N*/ VarGroupDeclSync
	;

//VarGroupDeclSync :
//	';'
//	| EOP /*1N*/
//	;

VarDeclList :
	VarDecl
	| VarDeclList ',' /*3L*/ VarDecl
	;

VarDecl :
	Ident
	| Ident '=' Init
	| Ident RestrictTemplateParamClause '=' Init
	;

FuncDecl :
	Type Ident UnifiedParamClauseDecl FuncEnd
	| Type Ident UnifiedParamClauseDecl Constraint FuncEnd
	| Type Ident UnifiedParamClauseDecl FuncAttrs FuncEnd
	| Type Ident UnifiedParamClauseDecl FuncAttrs Constraint FuncEnd
	| Attrs Ident UnifiedParamClauseDecl FuncEnd
	| Attrs Ident UnifiedParamClauseDecl Constraint FuncEnd
	| Attrs Ident UnifiedParamClauseDecl FuncAttrs FuncEnd
	| Attrs Ident UnifiedParamClauseDecl FuncAttrs Constraint FuncEnd
	;

CtorDecl :
	THIS UnifiedParamClauseDecl FuncEnd
	| THIS UnifiedParamClauseDecl FuncAttrs FuncEnd
	| THIS UnifiedParamClauseDecl FuncAttrs Constraint FuncEnd
	| Attrs THIS UnifiedParamClauseDecl FuncEnd
	| Attrs THIS UnifiedParamClauseDecl FuncAttrs FuncEnd
	| Attrs THIS UnifiedParamClauseDecl FuncAttrs Constraint FuncEnd
	;

DtorDecl :
	'~' /*11L*/ THIS '(' /*14N*/ ')' FuncEnd
	| '~' /*11L*/ THIS '(' /*14N*/ ')' FuncAttrs FuncEnd
	| Attrs '~' /*11L*/ THIS '(' /*14N*/ ')' FuncEnd
	| Attrs '~' /*11L*/ THIS '(' /*14N*/ ')' FuncAttrs FuncEnd
	;

Postblit :
	THIS '(' /*14N*/ THIS ')' FuncEnd
	| THIS '(' /*14N*/ THIS ')' FuncAttrs FuncEnd
	;

UnifiedParamClauseDecl :
	'(' /*14N*/ ')'
	| '(' /*14N*/ ParamGroupDeclList ')'
	| '(' /*14N*/ ParamGroupDeclList ',' /*3L*/ ')'
	| '(' /*14N*/ ParamGroupDeclList ',' /*3L*/ DOT_DOT_DOT /*14N*/ ')'
	| '(' /*14N*/ DOT_DOT_DOT /*14N*/ ')'
	| '(' /*14N*/ RestrictTemplateParamList ')' '(' /*14N*/ ')'
	| '(' /*14N*/ RestrictTemplateParamList ')' '(' /*14N*/ ParamGroupDeclList ')'
	| '(' /*14N*/ RestrictTemplateParamList ')' '(' /*14N*/ ParamGroupDeclList ',' /*3L*/ ')'
	| '(' /*14N*/ RestrictTemplateParamList ')' '(' /*14N*/ ParamGroupDeclList ',' /*3L*/ DOT_DOT_DOT /*14N*/ ')'
	| '(' /*14N*/ RestrictTemplateParamList ')' '(' /*14N*/ DOT_DOT_DOT /*14N*/ ')'
	| '(' /*14N*/ RestrictTemplateParamList ',' /*3L*/ ')' '(' /*14N*/ ')'
	| '(' /*14N*/ RestrictTemplateParamList ',' /*3L*/ ')' '(' /*14N*/ ParamGroupDeclList ')'
	| '(' /*14N*/ RestrictTemplateParamList ',' /*3L*/ ')' '(' /*14N*/ ParamGroupDeclList ',' /*3L*/ ')'
	| '(' /*14N*/ RestrictTemplateParamList ',' /*3L*/ ')' '(' /*14N*/ ParamGroupDeclList ',' /*3L*/ DOT_DOT_DOT /*14N*/ ')'
	| '(' /*14N*/ RestrictTemplateParamList ',' /*3L*/ ')' '(' /*14N*/ DOT_DOT_DOT /*14N*/ ')'
	;

ParamClauseDecl :
	'(' /*14N*/ ')'
	| '(' /*14N*/ ParamGroupDeclList ')'
	| '(' /*14N*/ ParamGroupDeclList ',' /*3L*/ ')'
	| '(' /*14N*/ ParamGroupDeclList ',' /*3L*/ DOT_DOT_DOT /*14N*/ ')'
	| '(' /*14N*/ DOT_DOT_DOT /*14N*/ ')'
	;

ParamGroupDeclList :
	ParamGroupDecl
	| ParamGroupDeclList ',' /*3L*/ ParamGroupDecl
	;

ParamGroupDecl :
	Type
	| Type DOT_DOT_DOT /*14N*/
	| Type Ident
	| Type Ident DOT_DOT_DOT /*14N*/
	| Type Ident '=' AssignExpr
	;

Decls :
	Decl
	| Decls Decl
	//| Decls error /*1N*/ DeclsSync
	;

//DeclsSync :
//	';'
//	;

RestrictTemplateParamClause :
	'(' /*14N*/ RestrictTemplateParamList ')'
	| '(' /*14N*/ RestrictTemplateParamList ',' /*3L*/ ')'
	;

RestrictTemplateParamList :
	RestrictTemplateParam
	| RestrictTemplateParamList ',' /*3L*/ RestrictTemplateParam
	;

RestrictTemplateParam :
	TemplateTypeParam
	| TemplateAliasParam
	| TemplateTupleParam
	;

TemplateParamClause :
	'(' /*14N*/ ')'
	| '(' /*14N*/ TemplateParamList ')'
	| '(' /*14N*/ TemplateParamList ',' /*3L*/ ')'
	;

TemplateParamList :
	TemplateParam
	| TemplateParamList ',' /*3L*/ TemplateParam
	;

TemplateParam :
	TemplateTypeParam
	| TemplateTupleParam
	| TemplateValueParam
	| TemplateAliasParam
	| TemplateThisParam
	;

TemplateTypeParam :
	Ident
	| Ident ':' Type
	| Ident ':' Type '=' Type
	| Ident '=' Type
	;

TemplateTupleParam :
	Ident DOT_DOT_DOT /*14N*/
	;

TemplateValueParam :
	UnqualType Ident
	| UnqualType Ident '=' AssignExpr
	| UnqualType Ident '=' SpecialKeyword
	| UnqualType Ident ':' TerExpr
	| UnqualType Ident ':' TerExpr '=' AssignExpr
	| UnqualType Ident ':' TerExpr '=' SpecialKeyword
	;

TemplateAliasParam :
	ALIAS Ident
	| ALIAS Type Ident
	;

TemplateThisParam :
	THIS TemplateTypeParam
	;

FuncAttrs :
	FuncAttr
	| FuncAttrs FuncAttr
	;

FuncAttr :
	FuncQual
	| TypeQual
	;

FuncQual :
	NOTHROW
	| PURE
	| Annot
	;

Constraint :
	IF '(' /*14N*/ Expr ')'
	;

Init :
	VOID
	| NonNullLit
	;

NonNullLit :
	AssignExpr
	| StructInit
	;

ArrayInit :
	'[' /*14N*/ ']'
	| '[' /*14N*/ ArrayMemberInits ']'
	| '[' /*14N*/ ArrayMemberInits ',' /*3L*/ ']'
	;

ArrayMemberInits :
	ArrayMemberInit
	| ArrayMemberInits ',' /*3L*/ ArrayMemberInit
	;

ArrayMemberInit :
	NonNullLit
	| AssignExpr ':' NonNullLit
	;

StructInit :
	'{' '}'
	| '{' StructMemberInits '}'
	| '{' StructMemberInits ',' /*3L*/ '}'
	;

StructMemberInits :
	StructMemberInit
	| StructMemberInits ',' /*3L*/ StructMemberInit
	;

StructMemberInit :
	NonNullLit
	| Ident ':' NonNullLit
	;

Attrs :
	Attr
	| Attrs Attr
	;

Attr :
	StorageClass
	| AccessSpec
	| FuncQual
	| LinkageAttr
	| AlignAttr
	| TypeQual
	| ABSTRACT
	| FINAL
	| OVERRIDE
	| AUTO
	| __GSHARED
	| IN /*9L*/
	| OUT
	| LAZY
	;

StorageClass :
	DEPRECATED
	| STATIC
	| EXTERN
	| REF
	| SCOPE
	;

AccessSpec :
	PRIVATE
	| PACKAGE
	| PROTECTED
	| PUBLIC
	| EXPORT
	;

Annot :
	'@' PROPERTY
	| '@' SAFE
	| '@' TRUSTED
	| '@' SYSTEM
	| '@' DISABLE
	| '@' NOGC
	;

LinkageAttr :
	EXTERN '(' /*14N*/ IdentList ')'
	| EXTERN '(' /*14N*/ Ident PLUS_PLUS ',' /*3L*/ IdentList ')'
	;

TypeQuals :
	TypeQual
	| TypeQuals TypeQual
	;

TypeQual :
	CONST
	| IMMUTABLE
	| INOUT
	| SHARED
	;

AlignAttr :
	ALIGN
	| ALIGN '(' /*14N*/ NumLit ')'
	;

StaticAssert :
	STATIC ASSERT '(' /*14N*/ AssignExpr ')' ';'
	| STATIC ASSERT '(' /*14N*/ AssignExpr ',' /*3L*/ AssignExpr ')' ';'
	;

VersionDecl :
	VERSION '=' Ident ';'
	| VERSION '=' NumLit ';'
	;

DebugDecl :
	DEBUG '=' Ident ';'
	| DEBUG '=' NumLit ';'
	;

UnitTestDecl :
	UNITTEST BlockStmt
	;

InvariantDecl :
	INVARIANT BlockStmt
	| INVARIANT '(' /*14N*/ ')' BlockStmt
	;

SelectiveDecl :
	ConditionDecl Decl %prec PREFER_SHIFT /*2N*/
	| ConditionDecl Decl ELSE /*14N*/ Decl
	;

ConditionDecl :
	VersionCond
	| DebugCond
	| StaticIf
	;

VersionCond :
	VERSION '(' /*14N*/ NumLit ')'
	| VERSION '(' /*14N*/ Ident ')'
	| VERSION '(' /*14N*/ UNITTEST ')'
	| VERSION '(' /*14N*/ ASSERT ')'
	;

DebugCond :
	DEBUG %prec PREFER_SHIFT /*2N*/
	| DEBUG '(' /*14N*/ NumLit ')'
	| DEBUG '(' /*14N*/ Ident ')'
	;

StaticIf :
	STATIC IF '(' /*14N*/ AssignExpr ')'
	;

AliasThis :
	ALIAS Ident THIS ';'
	;

AliasDecl :
	ALIAS AliasBindDeclList ';'
	| ALIAS Type Ident ';'
	;

AliasBindDeclList :
	AliasBindDecl
	| AliasBindDeclList ',' /*3L*/ AliasBindDecl
	;

AliasBindDecl :
	Ident '=' Type
	;

EnumDecl :
	ENUM EnumEnd
	| ENUM Ident EnumEnd
	| ENUM Ident ':' Type EnumEnd
	| ENUM ':' Type EnumEnd
	| ENUM Ident '=' AssignExpr ';'
	| ENUM Type Ident '=' AssignExpr ';'
	| ENUM Type Ident RestrictTemplateParamClause '=' AssignExpr ';'
	;

EnumEnd :
	';'
	| EnumBody
	;

EnumBody :
	'{' EnumMemberDeclList '}'
	| '{' EnumMemberDeclList ',' /*3L*/ '}'
	;

EnumMemberDeclList :
	EnumMemberDecl
	| EnumMemberDeclList ',' /*3L*/ EnumMemberDecl
	;

EnumMemberDecl :
	Ident
	| Ident '=' AssignExpr
	| Type Ident '=' AssignExpr
	;

AttrRecordDecl :
	Attrs RecordDecl
	| SYNCHRONIZED RecordDecl
	;

RecordDecl :
	RecordKey Ident ';'
	| RecordKey Ident RecordType
	| RecordKey Ident ':' BaseRecordList RecordType
	| RecordKey RecordType
	| RecordTemplateDecl
	;

RecordTemplateDecl :
	RecordKey Ident TemplateParamClause RecordType
	| RecordKey Ident TemplateParamClause Constraint RecordType
	| RecordKey Ident TemplateParamClause Constraint ':' BaseRecordList RecordType
	| RecordKey Ident TemplateParamClause ':' BaseRecordList RecordType
	| RecordKey Ident TemplateParamClause ':' BaseRecordList Constraint RecordType
	;

TemplateDecl :
	TEMPLATE Ident TemplateParamClause '{' '}'
	| TEMPLATE Ident TemplateParamClause '{' Decls '}'
	| TEMPLATE Ident TemplateParamClause Constraint '{' Decls '}'
	;

RecordKey :
	UNION
	| STRUCT
	| CLASS
	| INTERFACE
	;

BaseRecordList :
	BaseRecordDecl
	| BaseRecordList ',' /*3L*/ BaseRecordDecl
	;

BaseRecordDecl :
	NestedIdentOrTemplateInst
	;

RecordType :
	'{' '}'
	| '{' Decls '}'
	| '{' Decls EOP /*1N*/
	//| '{' Decls error /*1N*/ BlockStmtSync
	;

ImportGroupDecl :
	IMPORT ImportList ';'
	| STATIC IMPORT ImportList ';'
	| PUBLIC IMPORT ImportList ';'
	;

ImportDecl :
	NestedIdent
	| Ident '=' NestedIdent
	| Ident '=' NestedIdent ':' ImportSelectionDeclList %prec PREFER_SHIFT /*2N*/
	| NestedIdent ':' ImportSelectionDeclList %prec PREFER_SHIFT /*2N*/
	;

ImportSelectionDecl :
	NestedIdent
	| Ident '=' NestedIdent
	;

ImportSelectionDeclList :
	ImportSelectionDecl
	| ImportSelectionDeclList ',' /*3L*/ ImportSelectionDecl
	;

ImportList :
	ImportDecl
	| ImportList ',' /*3L*/ ImportDecl
	;

Stmt :
	BlockStmt
	| ExprStmt
	| BasicDecl
	| PlainStmt
	| CaseClauseStmt
	;

PlainStmt :
	LabeledStmt
	| IfStmt
	| WhileStmt
	| DoStmt
	| ForStmt
	| ForeachStmt
	| ContinueStmt
	| BreakStmt
	| ReturnStmt
	| WithStmt
	| GotoStmt
	| SynchronizedStmt
	| TryStmt
	| ThrowStmt
	| DeferredStmt
	| StaticAssert
	| CondStmt
	| SwitchStmt
	//| ';'
	;

StmtList :
	Stmt
	| StmtList Stmt
	;

BlockStmt :
	'{' '}'
	//| '{' error /*1N*/ BlockStmtSync
	| '{' StmtList '}'
	| '{' StmtList EOP /*1N*/
	//| '{' StmtList error /*1N*/ BlockStmtSync
	;

//BlockStmtSync :
//	'}'
//	| EOP /*1N*/
//	;

FuncEnd :
	';'
	| FuncBody
	;

FuncBody :
	BlockStmt
	| IN_LBRACE_HACK '}' BODY BlockStmt
	| IN_LBRACE_HACK StmtList '}' BODY BlockStmt
	| IN_LBRACE_HACK '}' FuncOutStmt BODY BlockStmt
	| IN_LBRACE_HACK StmtList '}' FuncOutStmt BODY BlockStmt
	| FuncOutStmt BODY BlockStmt
	;

FuncOutStmt :
	OUT BlockStmt
	| OUT '(' /*14N*/ Ident ')' BlockStmt
	;

LabeledStmt :
	Ident ':' Stmt
	;

ExprStmt :
	Expr ';'
	| Expr EOP /*1N*/
	//| Expr error /*1N*/ ExprStmtSync
	;

//ExprStmtSync :
//	';'
//	| EOP /*1N*/
//	;

IfStmt :
	IF '(' /*14N*/ Expr ')' Stmt %prec PREFER_SHIFT /*2N*/
	| IF '(' /*14N*/ Expr ')' Stmt ELSE /*14N*/ Stmt
	;

WhileStmt :
	WHILE '(' /*14N*/ Expr ')' Stmt
	;

DoStmt :
	DO Stmt WHILE '(' /*14N*/ Expr ')'
	;

ForStmt :
	FOR '(' /*14N*/ Stmt ';' ')' Stmt
	| FOR '(' /*14N*/ Stmt Expr ';' ')' Stmt
	| FOR '(' /*14N*/ Stmt Expr ';' Expr ')' Stmt
	| FOR '(' /*14N*/ Stmt ';' Expr ')' Stmt
	| FOR '(' /*14N*/ ';' ';' ')' Stmt
	| FOR '(' /*14N*/ ';' Expr ';' ')' Stmt
	| FOR '(' /*14N*/ ';' Expr ';' Expr ')' Stmt
	| FOR '(' /*14N*/ ';' ';' Expr ')' Stmt
	;

ForeachStmt :
	FOREACH '(' /*14N*/ ForeachDecl Expr ')' Stmt
	| FOREACH '(' /*14N*/ ForeachDecl Expr DOT_DOT Expr ')' Stmt
	| FOREACH_REVERSE '(' /*14N*/ ForeachDecl Expr ')' Stmt
	| FOREACH_REVERSE '(' /*14N*/ ForeachDecl Expr DOT_DOT Expr ')' Stmt
	;

ForeachDecl :
	VarGroupDecl
	| IdentList ';'
	;

ContinueStmt :
	CONTINUE ';'
	| CONTINUE Ident ';'
	;

BreakStmt :
	BREAK ';'
	| BREAK Ident ';'
	;

ReturnStmt :
	RETURN ';'
	| RETURN Expr ';'
	;

GotoStmt :
	GOTO Ident ';'
	| GOTO DEFAULT ';'
	| GOTO CASE ';'
	| GOTO CASE Expr ';'
	;

WithStmt :
	WITH '(' /*14N*/ Expr ')' Stmt
	;

SynchronizedStmt :
	SYNCHRONIZED '{' StmtList '}'
	| SYNCHRONIZED PlainStmt
	| SYNCHRONIZED '(' /*14N*/ Expr ')' '{' StmtList '}'
	| SYNCHRONIZED '(' /*14N*/ Expr ')' PlainStmt
	;

TryStmt :
	TRY BlockStmt CatchClauseStmts
	| TRY BlockStmt LastCatchClauseStmt
	| TRY BlockStmt CatchClauseStmts LastCatchClauseStmt
	| TRY BlockStmt CatchClauseStmts LastCatchClauseStmt FinallyClauseStmt
	| TRY BlockStmt LastCatchClauseStmt FinallyClauseStmt
	| TRY BlockStmt FinallyClauseStmt
	;

CatchClauseStmts :
	CatchClauseStmt
	| CatchClauseStmts CatchClauseStmt
	;

CatchClauseStmt :
	CATCH '(' /*14N*/ ParamGroupDecl ')' BlockStmt
	;

LastCatchClauseStmt :
	CATCH BlockStmt
	;

FinallyClauseStmt :
	FINALLY BlockStmt
	;

ThrowStmt :
	THROW Expr ';'
	;

DeferredStmt :
	SCOPE '(' /*14N*/ Ident ')' Stmt
	;

CondStmt :
	ConditionDecl Stmt %prec PREFER_SHIFT /*2N*/
	| ConditionDecl Stmt ELSE /*14N*/ Stmt
	;

SwitchStmt :
	SWITCH '(' /*14N*/ Expr ')' BlockStmt
	;

CaseClauseStmt :
	CASE ExprList ':' Stmt
	| DEFAULT ':' Stmt
	;

Ident :
	IDENT
	| COMPLETION
	;

TemplateInst :
	Ident '!' '(' /*14N*/ ')'
	| Ident '!' '(' /*14N*/ TemplateArgList ')'
	| Ident '!' '(' /*14N*/ TemplateArgList ',' /*3L*/ ')'
	| Ident '!' TemplateSingleArg
	;

IdentOrTemplateInst :
	Ident %prec PREFER_SHIFT /*2N*/
	| TemplateInst
	;

NestedIdent :
	Ident
	| NestedIdent '.' /*14N*/ Ident
	;

NestedIdentOrTemplateInst :
	IdentOrTemplateInst
	| NestedIdentOrTemplateInst '.' /*14N*/ IdentOrTemplateInst
	;

IdentList :
	Ident
	| IdentList ',' /*3L*/ Ident
	;

CharLit :
	CHAR_LIT
	;

StringLit :
	STR_LIT
	;

NumLit :
	INT_LIT
	| FLOAT_LIT
	;

BoolLit :
	TRUE_VALUE
	| FALSE_VALUE
	;

PointerLit :
	NULL_VALUE
	;

ArrayLit :
	ArrayInit
	;

Lambda :
	FuncKey FuncBody
	| FuncKey Type FuncBody
	| FuncKey Type ParamClauseDecl FuncBody
	| FuncKey ParamClauseDecl FuncBody
	| ParamClauseDecl FuncBody
	;

FuncKey :
	FUNCTION
	| DELEGATE
	;

SpecialKeyword :
	__FILE__MACRO
	| __MODULE__MACRO
	| __LINE__MACRO
	| __FUNCTION__MACRO
	| __PRETTY_FUNCTION__MACRO
	| __TIME__MACRO
	| __DATE__MACRO
	| __TIMESTAMP__MACRO
	| __VERSION__MACRO
	| __VENDOR__MACRO
	;

TemplateArgList :
	TemplateArg
	| TemplateArgList ',' /*3L*/ TemplateArg
	;

TemplateArg :
	NonExprType
	| AssignExpr
	;

TemplateSingleArg :
	Ident
	| BuiltinType
	| CharLit
	| StringLit
	| NumLit
	| BoolLit
	| PointerLit
	| ThisExpr
	| SpecialKeyword
	;

%%

%%

"<" 	'<'
">" 	'>'
"=" 	'='
"/" 	'/'
"." 	'.'
"&" 	'&'
"|"	'|'
"-" 	'-'
"+" 	'+'
"!" 	'!'
"(" 	'('
")" 	')'
"[" 	'['
"]" 	']'
"{" 	'{'
"}" 	'}'
"?" 	'?'
"," 	','
";" 	';'
":" 	':'
"$" 	'$'
"%" 	'%'
"*" 	'*'
"^" 	'^'
"~" 	'~'
"@" 	'@'
//"#"	'#'

"=="	EQ_EQ
"!="	EXCLAM_EQ

"<="	LS_EQ
">="	GR_EQ
"<>"	LS_GR
"<>="	LS_GR_EQ
"!<>"	EXCLAM_LS_GR
"!<>="	EXCLAM_LS_GR_EQ
"!<"	EXCLAM_LS
"!<="	EXCLAM_LS_EQ
"!>"	EXCLAM_GR
"!>="	EXCLAM_GR_EQ

"+="	PLUS_EQ
"-="	MINUS_EQ
"*="	STAR_EQ
"/="	SLASH_EQ
"%="	PERCENT_EQ
"^="	CARET_EQ
"^^="	CARET_CARET_EQ
"&="	AMPER_EQ
"|="	PIPE_EQ
"<<="	LS_LS_EQ
">>="	GR_GR_EQ
">>>="	GR_GR_GR_EQ
"~="	TILDE_EQ

"&&"	AMPER_AMPER
"||"	PIPE_PIPE

"++"	PLUS_PLUS
"--"	MINUS_MINUS

"<<"	LS_LS
">>"	GR_GR
">>>"	GR_GR_GR

"^^"	CARET_CARET
"=>"	EQ_ARROW
".."	DOT_DOT
"..."	DOT_DOT_DOT

    /*--- Keywords ---*/

"alias"	ALIAS
"assert"	ASSERT
"body"	BODY
"break"	BREAK
"case"	CASE
"cast"	CAST
"catch"	CATCH
"class"	CLASS
"continue"	CONTINUE
"debug"	DEBUG
"default"	DEFAULT
"delegate"	DELEGATE
"delete"	DELETE
"do"	DO
"else"	ELSE
"enum"	ENUM
"finally"	FINALLY
"for"	FOR
"foreach"	FOREACH
"foreach_reverse"	FOREACH_REVERSE
"function"	FUNCTION
"goto"	GOTO
"if"	IF
"import"	IMPORT
"in"<JOINBRACE>
/* Avoid shift/reduce conflict. Read known issues. */
"!"[ \t]*"in"[ \t\(]<NOT_IN_HACK_ST>	reject()
<NOT_IN_HACK_ST>"!"[ \t]*"in"<INITIAL>NOT_IN_HACK
"interface"	INTERFACE
"invariant"	INVARIANT
"is"	IS
/* Avoid shift/reduce conflict. Read known issues. */
"!"[ \t]*"is"[ \t\(]<NOT_IS_HACK_ST>	reject()
<NOT_IS_HACK_ST>"!"[ \t]*"is"<INITIAL>NOT_IS_HACK
"macro"	MACRO
"mixin"	MIXIN
"module"	MODULE
"new"	NEW
"pragma"	PRAGMA
"property"	PROPERTY
"return"	RETURN
"struct"	STRUCT
"super"	SUPER
"switch"	SWITCH
"synchronized"	SYNCHRONIZED
"template"	TEMPLATE
"throw"	THROW
"try"	TRY
"typedef"	TYPEDEF
"typeid"	TYPEID
"typeof"	TYPEOF
"union"	UNION
"unittest"	UNITTEST
"version"	VERSION
"while"	WHILE
"with"	WITH
"__FILE__"	__FILE__MACRO
"__MODULE__"	__MODULE__MACRO
"__LINE__"	__LINE__MACRO
"__FUNCTION__"	__FUNCTION__MACRO
"__PRETTY_FUNCTION__"	__PRETTY_FUNCTION__MACRO
"__EOF__"	__EOF__MACRO
"__TIME__"	__TIME__MACRO
"__DATE__"	__DATE__MACRO
"__TIMESTAMP__"	__TIMESTAMP__MACRO
"__VERSION__"	__VERSION__MACRO
"__VENDOR__"	__VENDOR__MACRO
"__gshared"	__GSHARED
"__traits"	__TRAITS
"__vector"	__VECTOR
"__parameters"	__PARAMETERS

    /*--- Attributes ---*/

"abstract"	ABSTRACT
"align"	ALIGN
"asm"	ASM
"auto"	AUTO
"const"	CONST
"deprecated"	DEPRECATED
"disable"	DISABLE
"export"	EXPORT
"extern"	EXTERN
"final"	FINAL
"immutable"	IMMUTABLE
"inout"	INOUT
"lazy"	LAZY
"nogc"	NOGC
"nothrow"	NOTHROW
"out"	OUT
"override"	OVERRIDE
"package"	PACKAGE
"private"	PRIVATE
"protected"	PROTECTED
"pure"	PURE
"public"	PUBLIC
"ref"	REF
"safe"	SAFE
"scope"	SCOPE
"shared"	SHARED
"static"	STATIC
"system"	SYSTEM
"trusted"	TRUSTED
"volatile"	VOLATILE

    /*--- Builtin types ---*/

"bool"	BOOL
"byte"	BYTE
"cdouble"	COMPLEX_FLOAT64
"cent"	CENT
"cfloat"	COMPLEX_FLOAT32
"char"	CHAR
"creal"	COMPLEX_REAL
"dchar"	CHAR_UTF32
"double"	FLOAT64
"float"	FLOAT32
"ifloat"	IMAG_FLOAT32
"int"	INT
"ireal"	IMAG_REAL
"idouble"	IMAG_FLOAT64
"long"	INT64
"real"	REAL
"this"	THIS
"short"	INT16
"ubyte"	UBYTE
"ucent"	UCENT
"uint"	UINT
"ulong"	UINT64
"ushort"	UINT16
"wchar"	CHAR_UTF16
"void"	VOID

    /*--- Hacks ---*/

<JOINBRACE>[ \t\n]	skip()
<JOINBRACE>.<.>
<JOINBRACE>"{"<INITIAL> IN_LBRACE_HACK

    /*--- Comments ---*/

"//"[^\n]*\n skip()
"/*"<BCOMMENT>
"/+"<NBCOMMENT>
<BCOMMENT>"*/"<INITIAL>	skip()
<BCOMMENT>.<.>
<BCOMMENT>"\n"<.>
<NBCOMMENT>"+/"<INITIAL>	skip()
<NBCOMMENT>.<.>
<NBCOMMENT>"\n"<.>

    /*--- Literals ---*/

"true"	TRUE_VALUE
"false"	FALSE_VALUE
"null"	NULL_VALUE
"\""<DQSTRING>
<DQSTRING>"\\"<>ESCSEQ>
<DQSTRING>"\n"<.>
<DQSTRING>"\""<INITIAL>	STR_LIT
<DQSTRING>.<.>
"\'"<QCHAR>
<QCHAR>"\\"<>ESCSEQ>
<QCHAR>"\n"<.>
<QCHAR>"\'"<INITIAL>	 CHAR_LIT
<QCHAR>.<.>
<ESCSEQ>.<<>
[0-9][0-9_]*[uUlL]{0,2}?	INT_LIT
0[bB][0-1_]*[uUlL]{0,2}?	INT_LIT
0[xX][0-9a-fA-F_]*[uUlL]{0,2}?	INT_LIT
([0-9]+[0-9_]*\.)[^\.0-9_]{1}<FLOAT_LIT1_ST>	reject()
<FLOAT_LIT1_ST>([0-9]+[0-9_]*\.)<INITIAL>	FLOAT_LIT
([0-9]+[0-9_]*\.?[0-9_]+)((E|e)(\+|\-)?[0-9_]+)?([fFLi]{0,2})?	FLOAT_LIT
([0-9]+[0-9_]*)(E|e)(\+|\-)?[0-9_]+([fFLi]{0,2})?	FLOAT_LIT
(\.[0-9]+[0-9_]*)((E|e)(\+|\-)?[0-9_]+)?([fFLi]{0,2})?	FLOAT_LIT
0[xX]([0-9a-fA-F]+[0-9a-fA-F]*\.)[^\.0-9_]{1}<FLOAT_LIT2_ST>	reject()
<FLOAT_LIT2_ST>0[xX]([0-9a-fA-F]+[0-9a-fA-F]*\.)<INITIAL>	FLOAT_LIT
0[xX]([0-9a-fA-F]+[0-9a-fA-F]*\.?[0-9a-fA-F_]+)((P|p)(\+|\-)?[0-9_]+)?([fFLi]{0,2})?	FLOAT_LIT
0[xX]([0-9a-fA-F]+[0-9a-fA-F]*)(P|p)(\+|\-)?[0-9_]+([fFLi]{0,2})?	FLOAT_LIT
0[xX](\.[0-9a-fA-F]+[0-9a-fA-F]*)((P|p)(\+|\-)?[0-9_]+)?([fFLi]{0,2})?	FLOAT_LIT

    /*--- Identifier ---*/

[a-zA-Z_]([a-zA-Z0-9_])*	IDENT

    /*--- New line ---*/

"\n" skip()

    /*--- Whitespace ---*/

[ \t\r\f]	skip()

    /*--- EOF/EOP ---*/
/*
<INITIAL><<EOF>> { BEGIN WAITING; return EOP; }
<WAITING>\n      { FINISH_OR_POSTPONE; }
<WAITING>.       { FINISH_OR_POSTPONE; }
<WAITING><<EOF>> { FINISH_OR_POSTPONE; }
*/

%%