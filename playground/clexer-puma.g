//From: https://www.aspectc.org/Home.php
// This file is part of PUMA.
// Copyright (C) 1999-2003  The PUMA developer team.
//
// This program is free software;  you can redistribute it and/or
// modify it under the terms of the GNU General Public License as
// published by the Free Software Foundation; either version 2 of
// the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public
// License along with this program; if not, write to the Free
// Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
// MA  02111-1307  USA


%token COMPILER_DIRECTIVE

// different kinds of keywords; selected depending on the standard to be supported
// C89 keywords
%token TOK_ASM
%token TOK_AUTO
%token TOK_BREAK
%token TOK_CASE
%token TOK_CHAR
%token TOK_CONST
%token TOK_CONTINUE
%token TOK_DEFAULT
%token TOK_DO
%token TOK_DOUBLE
%token TOK_ELSE
%token TOK_ENUM
%token TOK_EXTERN
%token TOK_FLOAT
%token TOK_FOR
%token TOK_GOTO
%token TOK_IF
%token TOK_INLINE
%token TOK_INT
%token TOK_LONG
%token TOK_REGISTER
%token TOK_RETURN
%token TOK_SHORT
%token TOK_SIGNED
%token TOK_SIZEOF
%token TOK_STATIC
%token TOK_STRUCT
%token TOK_SWITCH
%token TOK_TYPEDEF
%token TOK_UNION
%token TOK_UNSIGNED
%token TOK_VOID
%token TOK_VOLATILE
%token TOK_WHILE

// C99 keywords
%token TOK_C_BOOL
%token TOK_RESTRICT

%token TOK_WSPACE
%token TOK_CCSINGLE
%token TOK_CCOMMENT
%token TOK_PRE_DEFINE
%token TOK_PRE_ASSERT
%token TOK_PRE_UNASSERT
%token TOK_PRE_IF
%token TOK_PRE_ELIF
%token TOK_PRE_WARNING
%token TOK_PRE_ERROR
%token TOK_PRE_INCLUDE
%token TOK_PRE_INCLUDE_NEXT
%token TOK_PRE_IFDEF
%token TOK_PRE_IFNDEF
%token TOK_PRE_ELSE
%token TOK_PRE_ENDIF
%token TOK_PRE_UNDEF
%token TOK_PRE_INCLUDE
%token TOK_MO_HASH
%token TOK_MO_HASHHASH
%token TOK_AT
%token TOK_ZERO_VAL
%token TOK_INT_VAL
%token TOK_FLT_VAL
%token TOK_STRING_VAL
%token TOK_CHAR_VAL
%token TOK_COMMA
%token TOK_ASSIGN
%token TOK_QUESTION
%token TOK_OR
%token TOK_ROOF
%token TOK_AND
%token TOK_PLUS
%token TOK_MINUS
%token TOK_MUL
%token TOK_DIV
%token TOK_MODULO
%token TOK_LESS
%token TOK_GREATER
%token TOK_OPEN_ROUND
%token TOK_CLOSE_ROUND
%token TOK_OPEN_SQUARE
%token TOK_CLOSE_SQUARE
%token TOK_OPEN_CURLY
%token TOK_CLOSE_CURLY
%token TOK_SEMI_COLON
%token TOK_COLON
%token TOK_NOT
%token TOK_TILDE
%token TOK_DOT
%token TOK_MUL_EQ
%token TOK_DIV_EQ
%token TOK_MOD_EQ
%token TOK_ADD_EQ
%token TOK_SUB_EQ
%token TOK_LSH_EQ
%token TOK_RSH_EQ
%token TOK_AND_EQ
%token TOK_XOR_EQ
%token TOK_IOR_EQ
%token TOK_OR_OR
%token TOK_AND_AND
%token TOK_EQL
%token TOK_NEQ
%token TOK_LEQ
%token TOK_GEQ
%token TOK_LSH
%token TOK_RSH
%token TOK_DOT_STAR
%token TOK_PTS_STAR
%token TOK_INCR
%token TOK_DECR
%token TOK_PTS
%token TOK_COLON_COLON
%token TOK_ELLIPSIS
%token TOK_ID

/*
//C++ keywords
%token TOK_BOOL_VAL

%token TOK_BOOL
%token TOK_CATCH
%token TOK_CLASS
%token TOK_CONST_CAST
%token TOK_DELETE
%token TOK_DYN_CAST
%token TOK_EXPLICIT
%token TOK_EXPORT
%token TOK_FRIEND
%token TOK_MUTABLE
%token TOK_NAMESPACE
%token TOK_NEW
%token TOK_OPERATOR
%token TOK_PRIVATE
%token TOK_PROTECTED
%token TOK_PUBLIC
%token TOK_REINT_CAST
%token TOK_STAT_CAST
%token TOK_TEMPLATE
%token TOK_THIS
%token TOK_THROW
%token TOK_TRY
%token TOK_TYPEID
%token TOK_TYPENAME
%token TOK_USING
%token TOK_VIRTUAL
%token TOK_WCHAR_T
%token TOK_AND_AND_ISO_646
%token TOK_AND_EQ_ISO_646
%token TOK_AND_ISO_646
%token TOK_OR_ISO_646
%token TOK_TILDE_ISO_646
%token TOK_NOT_ISO_646
%token TOK_NEQ_ISO_646
%token TOK_OR_OR_ISO_646
%token TOK_IOR_EQ_ISO_646
%token TOK_ROOF_ISO_646
%token TOK_XOR_EQ_ISO_646
*/

%%

//Lexer only !
//Select "Debug mode: Input lexer"

%%

//%x NLEOL

// macros
Dec	\d
Hex	[0-9a-fA-F]
U	[uU]
L	[lL]
Exp	[Ee]
F	[fF]

// this ugly DirPrefix expression allows something like this: "# /*abc*/ include <stdio.h>"
DirPrefix	([ \t]|(\/\*([^*]|\*+[^/*])*\*+\/))*#([ \t]|(\/\*([^*]|\*+[^/*])*\*+\/))*

// Identifiers
UniversalChar	"\\"(u{Hex}{4}|U{Hex}{8})
Alpha	[a-zA-Z_\$]|{UniversalChar}

%%

/*
\\n\\<NLEOL>     reject()
<NLEOL> {
    \\n TOK_ID
    \\<INITIAL>  skip()
}
*/
[ \t]+[\n\r\f\v]*	TOK_WSPACE
[\n\r\f\v]+	TOK_WSPACE

// ------------
// preprocessor
// ------------

// a single line comment
\/\/[^\n\r\f\v]*	TOK_CCSINGLE

// a multi-line comment
\/\*(.|\n)*?\*\/	TOK_CCOMMENT


^{DirPrefix}"define"	TOK_PRE_DEFINE
^{DirPrefix}"assert"	TOK_PRE_ASSERT
^{DirPrefix}"unassert"	TOK_PRE_UNASSERT
^{DirPrefix}"if"	TOK_PRE_IF
^{DirPrefix}"elif"	TOK_PRE_ELIF
^{DirPrefix}"warning"	TOK_PRE_WARNING
^{DirPrefix}"error"	TOK_PRE_ERROR
^{DirPrefix}"include"	TOK_PRE_INCLUDE
^{DirPrefix}"include_next"	TOK_PRE_INCLUDE_NEXT
^{DirPrefix}"ifdef"	TOK_PRE_IFDEF
^{DirPrefix}"ifndef"	TOK_PRE_IFNDEF
^{DirPrefix}"else"	TOK_PRE_ELSE
^{DirPrefix}"endif"	TOK_PRE_ENDIF
^{DirPrefix}"undef"	TOK_PRE_UNDEF

// Win specific preprocessor directives
^{DirPrefix}"import"	TOK_PRE_INCLUDE

// compiler directives
^{DirPrefix}"pragma"	COMPILER_DIRECTIVE
^{DirPrefix}"line"	COMPILER_DIRECTIVE
^{DirPrefix}"ident"	COMPILER_DIRECTIVE
^{DirPrefix}	COMPILER_DIRECTIVE

// preprocessor macro operations
"#"	TOK_MO_HASH
"##"	TOK_MO_HASHHASH

// ----------
// core rules
// ----------

// nonreserved tokens:
"@"	TOK_AT

// an integer constant:
"0"	TOK_ZERO_VAL
({Dec}+|("0"[xX]?{Hex}+))({U}|{L}|{L}{U}|{U}{L}|{L}{L}|{U}{L}{L}|{L}{U}{L}|{L}{L}{U})?	TOK_INT_VAL

// a floating point constant:
{Dec}+(\.{Dec}*)?({Exp}([\+\-])?{Dec}+)?({L}|{F})?	TOK_FLT_VAL
\.{Dec}+({Exp}([\+\-])?{Dec}+)?({L}|{F})?	TOK_FLT_VAL

// a hex floating point constant:
"0"[xX]{Hex}+(\.{Hex}*)?[pP]([\+\-])?{Dec}+({L}|{F})?	TOK_FLT_VAL
"0"[xX]\.{Hex}+[pP]([\+\-])?{Dec}+({L}|{F})?	TOK_FLT_VAL

// a string or character constant:
"L"?\"([^\\"]|\\.)*\"	TOK_STRING_VAL
"L"?'([^\\']|\\.)*'	TOK_CHAR_VAL

// operators
","	TOK_COMMA
"="	TOK_ASSIGN
"?"	TOK_QUESTION
"|"	TOK_OR
"^"	TOK_ROOF
"&"	TOK_AND
"+"	TOK_PLUS
"-"	TOK_MINUS
"*"	TOK_MUL
"/"	TOK_DIV
"%"	TOK_MODULO
"<"	TOK_LESS
">"	TOK_GREATER
"("	TOK_OPEN_ROUND
")"	TOK_CLOSE_ROUND
"["	TOK_OPEN_SQUARE
"]"	TOK_CLOSE_SQUARE
"{"	TOK_OPEN_CURLY
"}"	TOK_CLOSE_CURLY
";"	TOK_SEMI_COLON
":"	TOK_COLON
"!"	TOK_NOT
"~"	TOK_TILDE
"."	TOK_DOT

"*="	TOK_MUL_EQ
"/="	TOK_DIV_EQ
"%="	TOK_MOD_EQ
"+="	TOK_ADD_EQ
"-="	TOK_SUB_EQ
"<<="	TOK_LSH_EQ
">>="	TOK_RSH_EQ
"&="	TOK_AND_EQ
"^="	TOK_XOR_EQ
"|="	TOK_IOR_EQ
"||"	TOK_OR_OR
"&&"	TOK_AND_AND
"=="	TOK_EQL
"!="	TOK_NEQ
"<="	TOK_LEQ
">="	TOK_GEQ
"<<"	TOK_LSH
">>"	TOK_RSH
".*"	TOK_DOT_STAR
"->*"	TOK_PTS_STAR
"++"	TOK_INCR
"--"	TOK_DECR
"->"	TOK_PTS
"::"	TOK_COLON_COLON
"..."	TOK_ELLIPSIS

// Keywords
// different kinds of keywords; selected depending on the standard to be supported
// C89 keywords
"asm"	 TOK_ASM
"auto"	 TOK_AUTO
"break"	 TOK_BREAK
"case"	 TOK_CASE
"char"	 TOK_CHAR
"const"	 TOK_CONST
"continue"	 TOK_CONTINUE
"default"	 TOK_DEFAULT
"do"	 TOK_DO
"double"	 TOK_DOUBLE
"else"	 TOK_ELSE
"enum"	 TOK_ENUM
"extern"	 TOK_EXTERN
"float"	 TOK_FLOAT
"for"	 TOK_FOR
"goto"	 TOK_GOTO
"if"	 TOK_IF
"inline"	 TOK_INLINE
"int"	 TOK_INT
"long"	 TOK_LONG
"register"	 TOK_REGISTER
"return"	 TOK_RETURN
"short"	 TOK_SHORT
"signed"	 TOK_SIGNED
"sizeof"	 TOK_SIZEOF
"static"	 TOK_STATIC
"struct"	 TOK_STRUCT
"switch"	 TOK_SWITCH
"typedef"	 TOK_TYPEDEF
"union"	 TOK_UNION
"unsigned"	 TOK_UNSIGNED
"void"	 TOK_VOID
"volatile"	 TOK_VOLATILE
"while"	 TOK_WHILE

// C99 keywords
"_Bool"	 TOK_C_BOOL
"restrict"	 TOK_RESTRICT

/*
// C++ boolean constants
"true"	TOK_BOOL_VAL
"false"	TOK_BOOL_VAL

// C++ keywords
"bool"	TOK_BOOL
"catch"	TOK_CATCH
"class"	TOK_CLASS
"const_cast"	TOK_CONST_CAST
"delete"	TOK_DELETE
"dynamic_cast"	TOK_DYN_CAST
"explicit"	TOK_EXPLICIT
"export"	TOK_EXPORT
"friend"	TOK_FRIEND
"mutable"	TOK_MUTABLE
"namespace"	TOK_NAMESPACE
"new"	TOK_NEW
"operator"	TOK_OPERATOR
"private"	TOK_PRIVATE
"protected"	TOK_PROTECTED
"public"	TOK_PUBLIC
"reinterpret_cast"	TOK_REINT_CAST
"static_cast"	TOK_STAT_CAST
"template"	TOK_TEMPLATE
"this"	TOK_THIS
"throw"	TOK_THROW
"try"	TOK_TRY
"typeid"	TOK_TYPEID
"typename"	TOK_TYPENAME
"using"	TOK_USING
"virtual"	TOK_VIRTUAL
"wchar_t"	TOK_WCHAR_T

// C++ alternative representation of operators (ISO 646)
"and"	TOK_AND_AND_ISO_646
"and_eq"	TOK_AND_EQ_ISO_646
"bitand"	TOK_AND_ISO_646
"bitor"	TOK_OR_ISO_646
"compl"	TOK_TILDE_ISO_646
"not"	TOK_NOT_ISO_646
"not_eq"	TOK_NEQ_ISO_646
"or"	TOK_OR_OR_ISO_646
"or_eq"	TOK_IOR_EQ_ISO_646
"xor"	TOK_ROOF_ISO_646
"xor_eq"	TOK_XOR_EQ_ISO_646
*/

{Alpha}({Alpha}|\d)*	TOK_ID

%%
