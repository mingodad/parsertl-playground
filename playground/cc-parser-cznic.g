//From: https://gitlab.com/cznic/cc/-/blob/master/parser.yy?ref_type=heads
// Copyright 2016 The CC Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Based on [0], 6.10. Substantial portions of expression AST size
// optimizations are from [2], license of which follows.

// ----------------------------------------------------------------------------

// Copyright 2013 The Go Authors.  All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// This grammar is derived from the C grammar in the 'ansitize'
// program, which carried this notice:
//
// Copyright (c) 2006 Russ Cox,
// 	Massachusetts Institute of Technology
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the
// Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall
// be included in all copies or substantial portions of the
// Software.
//
// The software is provided "as is", without warranty of any
// kind, express or implied, including but not limited to the
// warranties of merchantability, fitness for a particular
// purpose and noninfringement.  In no event shall the authors
// or copyright holders be liable for any claim, damages or
// other liability, whether in an action of contract, tort or
// otherwise, arising from, out of or in connection with the
// software or the use or other dealings in the software.

/*Tokens*/
%token ADDASSIGN
%token ALIGNOF
%token ANDAND
%token ANDASSIGN
%token ARROW
%token ASM
%token AUTO
%token BOOL
%token BREAK
%token CASE
%token CHAR
%token CHARCONST
%token COMPLEX
%token CONST
%token CONSTANT_EXPRESSION
%token CONTINUE
%token DDD
%token DEC
%token DEFAULT
%token DIVASSIGN
%token DO
%token DOUBLE
%token ELSE
%token ENUM
%token EQ
%token EXTERN
%token FLOAT
%token FLOATCONST
%token FOR
%token GEQ
%token GOTO
%token IDENTIFIER
%token IDENTIFIER_LPAREN
//%token IDENTIFIER_NONREPL
%token IF
%token INC
%token INLINE
%token INT
%token INTCONST
%token LEQ
%token LONG
%token LONGCHARCONST
%token LONGSTRINGLITERAL
%token LSH
%token LSHASSIGN
%token MODASSIGN
%token MULASSIGN
%token NEQ
%token NORETURN
%token ORASSIGN
%token OROR
%token PPDEFINE
%token PPELIF
%token PPELSE
%token PPENDIF
%token PPERROR
%token PPHASH_NL
//%token PPHEADER_NAME
%token PPIF
%token PPIFDEF
%token PPIFNDEF
%token PPINCLUDE
%token PPINCLUDE_NEXT
%token PPLINE
%token PPNONDIRECTIVE
//%token PPNUMBER
%token PPOTHER
//%token PPPASTE
%token PPPRAGMA
%token PPUNDEF
%token PREPROCESSING_FILE
%token REGISTER
%token RESTRICT
%token RETURN
%token RSH
%token RSHASSIGN
%token SHORT
%token SIGNED
%token SIZEOF
%token STATIC
%token STATIC_ASSERT
%token STRINGLITERAL
%token STRUCT
%token SUBASSIGN
%token SWITCH
//%token TRANSLATION_UNIT
%token TYPEDEF
%token TYPEDEFNAME
%token TYPEOF
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token WHILE
%token XORASSIGN

%precedence /*1*/ NOSEMI
%precedence /*2*/ ';'
%precedence /*3*/ NOELSE
%precedence /*4*/ ELSE
%right /*5*/ ADDASSIGN ANDASSIGN DIVASSIGN LSHASSIGN MODASSIGN MULASSIGN ORASSIGN RSHASSIGN SUBASSIGN XORASSIGN '='
%right /*6*/ ':' '?'
%left /*7*/ OROR
%left /*8*/ ANDAND
%left /*9*/ '|'
%left /*10*/ '^'
%left /*11*/ '&'
%left /*12*/ EQ NEQ
%left /*13*/ GEQ LEQ '<' '>'
%left /*14*/ LSH RSH
%left /*15*/ '+' '-'
%left /*16*/ '%' '*' '/'
%precedence /*17*/ CAST
%left /*18*/ SIZEOF '!' '~' UNARY
%right /*19*/ ARROW DEC INC '(' '.' '['

%start Start

%%

Start :
	PREPROCESSING_FILE PreprocessingFile
	| CONSTANT_EXPRESSION ConstantExpression
	| /*TRANSLATION_UNIT*/ TranslationUnit
	;

EnumerationConstant :
	IDENTIFIER
	;

ArgumentExpressionList :
	Expression
	| ArgumentExpressionList ',' Expression
	;

ArgumentExpressionListOpt :
	/*empty*/
	| ArgumentExpressionList
	;

Expression :
	IDENTIFIER %prec NOSEMI /*1P*/
	| CHARCONST
	| FLOATCONST
	| INTCONST
	| LONGCHARCONST
	| LONGSTRINGLITERAL
	| STRINGLITERAL
	| '(' /*19R*/ ExpressionList ')'
	| Expression '[' /*19R*/ ExpressionList ']'
	| Expression '(' /*19R*/ ArgumentExpressionListOpt ')'
	| Expression '.' /*19R*/ IDENTIFIER
	| Expression ARROW /*19R*/ IDENTIFIER
	| Expression INC /*19R*/
	| Expression DEC /*19R*/
	| '(' /*19R*/ TypeName ')' '{' InitializerList CommaOpt '}'
	| INC /*19R*/ Expression
	| DEC /*19R*/ Expression
	| '&' /*11L*/ Expression %prec UNARY /*18L*/
	| '*' /*16L*/ Expression %prec UNARY /*18L*/
	| '+' /*15L*/ Expression %prec UNARY /*18L*/
	| '-' /*15L*/ Expression %prec UNARY /*18L*/
	| '~' /*18L*/ Expression
	| '!' /*18L*/ Expression
	| SIZEOF /*18L*/ Expression
	| SIZEOF /*18L*/ '(' /*19R*/ TypeName ')' %prec SIZEOF /*18L*/
	| '(' /*19R*/ TypeName ')' Expression %prec CAST /*17P*/
	| Expression '*' /*16L*/ Expression
	| Expression '/' /*16L*/ Expression
	| Expression '%' /*16L*/ Expression
	| Expression '+' /*15L*/ Expression
	| Expression '-' /*15L*/ Expression
	| Expression LSH /*14L*/ Expression
	| Expression RSH /*14L*/ Expression
	| Expression '<' /*13L*/ Expression
	| Expression '>' /*13L*/ Expression
	| Expression LEQ /*13L*/ Expression
	| Expression GEQ /*13L*/ Expression
	| Expression EQ /*12L*/ Expression
	| Expression NEQ /*12L*/ Expression
	| Expression '&' /*11L*/ Expression
	| Expression '^' /*10L*/ Expression
	| Expression '|' /*9L*/ Expression
	| Expression ANDAND /*8L*/ Expression
	| Expression OROR /*7L*/ Expression
	| Expression '?' /*6R*/ ExpressionList ':' /*6R*/ Expression
	| Expression '=' /*5R*/ Expression
	| Expression MULASSIGN /*5R*/ Expression
	| Expression DIVASSIGN /*5R*/ Expression
	| Expression MODASSIGN /*5R*/ Expression
	| Expression ADDASSIGN /*5R*/ Expression
	| Expression SUBASSIGN /*5R*/ Expression
	| Expression LSHASSIGN /*5R*/ Expression
	| Expression RSHASSIGN /*5R*/ Expression
	| Expression ANDASSIGN /*5R*/ Expression
	| Expression XORASSIGN /*5R*/ Expression
	| Expression ORASSIGN /*5R*/ Expression
	| ALIGNOF '(' /*19R*/ TypeName ')'
	| '(' /*19R*/ CompoundStatement ')'
	| ANDAND /*8L*/ IDENTIFIER
	| Expression '?' /*6R*/ ':' /*6R*/ Expression
	;

ExpressionOpt :
	/*empty*/
	| Expression
	;

ExpressionList :
	Expression
	| ExpressionList ',' Expression
	;

ExpressionListOpt :
	/*empty*/
	| ExpressionList
	;

ConstantExpression :
	Expression
	;

Declaration :
	DeclarationSpecifiers InitDeclaratorListOpt ';' /*2P*/
	| StaticAssertDeclaration
	;

DeclarationSpecifiers :
	StorageClassSpecifier DeclarationSpecifiersOpt
	| TypeSpecifier DeclarationSpecifiersOpt
	| TypeQualifier DeclarationSpecifiersOpt
	| FunctionSpecifier DeclarationSpecifiersOpt
	;

DeclarationSpecifiersOpt :
	/*empty*/
	| DeclarationSpecifiers
	;

InitDeclaratorList :
	InitDeclarator
	| InitDeclaratorList ',' InitDeclarator
	;

InitDeclaratorListOpt :
	/*empty*/
	| InitDeclaratorList
	;

InitDeclarator :
	Declarator
	| Declarator '=' /*5R*/ Initializer
	;

StorageClassSpecifier :
	TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	;

TypeSpecifier :
	VOID
	| CHAR
	| SHORT
	| INT
	| LONG
	| FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| BOOL
	| COMPLEX
	| StructOrUnionSpecifier
	| EnumSpecifier
	| TYPEDEFNAME
	| TYPEOF '(' /*19R*/ Expression ')'
	| TYPEOF '(' /*19R*/ TypeName ')'
	;

StructOrUnionSpecifier :
	StructOrUnion IdentifierOpt '{' StructDeclarationList '}'
	| StructOrUnion IDENTIFIER
	| StructOrUnion IdentifierOpt '{' '}'
	;

StructOrUnion :
	STRUCT
	| UNION
	;

StructDeclarationList :
	StructDeclaration
	| StructDeclarationList StructDeclaration
	;

StructDeclaration :
	SpecifierQualifierList StructDeclaratorList ';' /*2P*/
	| SpecifierQualifierList ';' /*2P*/
	| StaticAssertDeclaration
	;

SpecifierQualifierList :
	TypeSpecifier SpecifierQualifierListOpt
	| TypeQualifier SpecifierQualifierListOpt
	;

SpecifierQualifierListOpt :
	/*empty*/
	| SpecifierQualifierList
	;

StructDeclaratorList :
	StructDeclarator
	| StructDeclaratorList ',' StructDeclarator
	;

StructDeclarator :
	Declarator
	| DeclaratorOpt ':' /*6R*/ ConstantExpression
	;

CommaOpt :
	/*empty*/
	| ','
	;

EnumSpecifier :
	ENUM IdentifierOpt '{' EnumeratorList CommaOpt '}'
	| ENUM IDENTIFIER
	;

EnumeratorList :
	Enumerator
	| EnumeratorList ',' Enumerator
	;

Enumerator :
	EnumerationConstant
	| EnumerationConstant '=' /*5R*/ ConstantExpression
	;

TypeQualifier :
	CONST
	| RESTRICT
	| VOLATILE
	;

FunctionSpecifier :
	INLINE
	| NORETURN
	;

Declarator :
	PointerOpt DirectDeclarator
	;

DeclaratorOpt :
	/*empty*/
	| Declarator
	;

DirectDeclarator :
	IDENTIFIER
	| '(' /*19R*/ Declarator ')'
	| DirectDeclarator '[' /*19R*/ TypeQualifierListOpt ExpressionOpt ']'
	| DirectDeclarator '[' /*19R*/ STATIC TypeQualifierListOpt Expression ']'
	| DirectDeclarator '[' /*19R*/ TypeQualifierList STATIC Expression ']'
	| DirectDeclarator '[' /*19R*/ TypeQualifierListOpt '*' /*16L*/ ']'
	| DirectDeclarator '(' /*19R*/ ParameterTypeList ')'
	| DirectDeclarator '(' /*19R*/ IdentifierListOpt ')'
	;

Pointer :
	'*' /*16L*/ TypeQualifierListOpt
	| '*' /*16L*/ TypeQualifierListOpt Pointer
	;

PointerOpt :
	/*empty*/
	| Pointer
	;

TypeQualifierList :
	TypeQualifier
	| TypeQualifierList TypeQualifier
	;

TypeQualifierListOpt :
	/*empty*/
	| TypeQualifierList
	;

ParameterTypeList :
	ParameterList
	| ParameterList ',' DDD
	;

ParameterTypeListOpt :
	/*empty*/
	| ParameterTypeList
	;

ParameterList :
	ParameterDeclaration
	| ParameterList ',' ParameterDeclaration
	;

ParameterDeclaration :
	DeclarationSpecifiers Declarator
	| DeclarationSpecifiers AbstractDeclaratorOpt
	;

IdentifierList :
	IDENTIFIER
	| IdentifierList ',' IDENTIFIER
	;

IdentifierListOpt :
	/*empty*/
	| IdentifierList
	;

IdentifierOpt :
	/*empty*/
	| IDENTIFIER
	;

TypeName :
	SpecifierQualifierList AbstractDeclaratorOpt
	;

AbstractDeclarator :
	Pointer
	| PointerOpt DirectAbstractDeclarator
	;

AbstractDeclaratorOpt :
	/*empty*/
	| AbstractDeclarator
	;

DirectAbstractDeclarator :
	'(' /*19R*/ AbstractDeclarator ')'
	| DirectAbstractDeclaratorOpt '[' /*19R*/ ExpressionOpt ']'
	| DirectAbstractDeclaratorOpt '[' /*19R*/ TypeQualifierList ExpressionOpt ']'
	| DirectAbstractDeclaratorOpt '[' /*19R*/ STATIC TypeQualifierListOpt Expression ']'
	| DirectAbstractDeclaratorOpt '[' /*19R*/ TypeQualifierList STATIC Expression ']'
	| DirectAbstractDeclaratorOpt '[' /*19R*/ '*' /*16L*/ ']'
	| '(' /*19R*/ ParameterTypeListOpt ')'
	| DirectAbstractDeclarator '(' /*19R*/ ParameterTypeListOpt ')'
	;

DirectAbstractDeclaratorOpt :
	/*empty*/
	| DirectAbstractDeclarator
	;

Initializer :
	Expression
	| '{' InitializerList CommaOpt '}'
	| IDENTIFIER ':' /*6R*/ Initializer
	;

InitializerList :
	DesignationOpt Initializer
	| InitializerList ',' DesignationOpt Initializer
	| /*empty*/
	;

Designation :
	DesignatorList '=' /*5R*/
	;

DesignationOpt :
	/*empty*/
	| Designation
	;

DesignatorList :
	Designator
	| DesignatorList Designator
	;

Designator :
	'[' /*19R*/ ConstantExpression ']'
	| '.' /*19R*/ IDENTIFIER
	;

Statement :
	LabeledStatement
	| CompoundStatement
	| ExpressionStatement
	| SelectionStatement
	| IterationStatement
	| JumpStatement
	| AssemblerStatement
	;

LabeledStatement :
	IDENTIFIER ':' /*6R*/ Statement
	| CASE ConstantExpression ':' /*6R*/ Statement
	| DEFAULT ':' /*6R*/ Statement
	;

CompoundStatement :
	'{' BlockItemListOpt '}'
	;

BlockItemList :
	BlockItem
	| BlockItemList BlockItem
	;

BlockItemListOpt :
	/*empty*/
	| BlockItemList
	;

BlockItem :
	Declaration
	| Statement
	;

ExpressionStatement :
	ExpressionListOpt ';' /*2P*/
	;

SelectionStatement :
	IF '(' /*19R*/ ExpressionList ')' Statement %prec NOELSE /*3P*/
	| IF '(' /*19R*/ ExpressionList ')' Statement ELSE /*4P*/ Statement
	| SWITCH '(' /*19R*/ ExpressionList ')' Statement
	;

IterationStatement :
	WHILE '(' /*19R*/ ExpressionList ')' Statement
	| DO Statement WHILE '(' /*19R*/ ExpressionList ')' ';' /*2P*/
	| FOR '(' /*19R*/ ExpressionListOpt ';' /*2P*/ ExpressionListOpt ';' /*2P*/ ExpressionListOpt ')' Statement
	| FOR '(' /*19R*/ Declaration ExpressionListOpt ';' /*2P*/ ExpressionListOpt ')' Statement
	;

JumpStatement :
	GOTO IDENTIFIER ';' /*2P*/
	| CONTINUE ';' /*2P*/
	| BREAK ';' /*2P*/
	| RETURN ExpressionListOpt ';' /*2P*/
	| GOTO Expression ';' /*2P*/
	;

TranslationUnit :
	ExternalDeclaration
	| TranslationUnit ExternalDeclaration
	;

ExternalDeclaration :
	FunctionDefinition
	| Declaration
	| BasicAssemblerStatement ';' /*2P*/
	| ';' /*2P*/
	;

FunctionDefinition :
	DeclarationSpecifiers Declarator DeclarationListOpt FunctionBody
	| Declarator DeclarationListOpt FunctionBody
	;

FunctionBody :
	CompoundStatement
	| AssemblerStatement ';' /*2P*/
	;

DeclarationList :
	Declaration
	| DeclarationList Declaration
	;

DeclarationListOpt :
	/*empty*/
	| DeclarationList
	;

AssemblerInstructions :
	STRINGLITERAL
	| AssemblerInstructions STRINGLITERAL
	;

BasicAssemblerStatement :
	ASM VolatileOpt '(' /*19R*/ AssemblerInstructions ')'
	;

VolatileOpt :
	/*empty*/
	| VOLATILE
	;

AssemblerOperand :
	AssemblerSymbolicNameOpt STRINGLITERAL '(' /*19R*/ Expression ')'
	;

AssemblerOperands :
	AssemblerOperand
	| AssemblerOperands ',' AssemblerOperand
	;

AssemblerSymbolicNameOpt :
	/*empty*/
	| '[' /*19R*/ IDENTIFIER ']'
	;

Clobbers :
	STRINGLITERAL
	| Clobbers ',' STRINGLITERAL
	;

AssemblerStatement :
	BasicAssemblerStatement
	| ASM VolatileOpt '(' /*19R*/ AssemblerInstructions ':' /*6R*/ AssemblerOperands ')'
	| ASM VolatileOpt '(' /*19R*/ AssemblerInstructions ':' /*6R*/ AssemblerOperands ':' /*6R*/ AssemblerOperands ')'
	| ASM VolatileOpt '(' /*19R*/ AssemblerInstructions ':' /*6R*/ AssemblerOperands ':' /*6R*/ AssemblerOperands ':' /*6R*/ Clobbers ')'
	| ASM VolatileOpt GOTO '(' /*19R*/ AssemblerInstructions ':' /*6R*/ ':' /*6R*/ AssemblerOperands ':' /*6R*/ Clobbers ':' /*6R*/ IdentifierList ')'
	| ASM VolatileOpt '(' /*19R*/ AssemblerInstructions ':' /*6R*/ ')'
	| ASM VolatileOpt '(' /*19R*/ AssemblerInstructions ':' /*6R*/ ':' /*6R*/ AssemblerOperands ')'
	;

StaticAssertDeclaration :
	STATIC_ASSERT '(' /*19R*/ ConstantExpression ',' STRINGLITERAL ')' ';' /*2P*/
	;

PreprocessingFile :
	GroupList
	;

GroupList :
	GroupPart
	| GroupList GroupPart
	;

GroupListOpt :
	/*empty*/
	| GroupList
	;

GroupPart :
	ControlLine
	| IfSection
	| PPNONDIRECTIVE PPTokenList '\n'
	| TextLine
	;

IfSection :
	IfGroup ElifGroupListOpt ElseGroupOpt EndifLine
	;

IfGroup :
	PPIF PPTokenList '\n' GroupListOpt
	| PPIFDEF IDENTIFIER '\n' GroupListOpt
	| PPIFNDEF IDENTIFIER '\n' GroupListOpt
	;

ElifGroupList :
	ElifGroup
	| ElifGroupList ElifGroup
	;

ElifGroupListOpt :
	/*empty*/
	| ElifGroupList
	;

ElifGroup :
	PPELIF PPTokenList '\n' GroupListOpt
	;

ElseGroup :
	PPELSE '\n' GroupListOpt
	;

ElseGroupOpt :
	/*empty*/
	| ElseGroup
	;

EndifLine :
	PPENDIF
	;

ControlLine :
	PPDEFINE IDENTIFIER ReplacementList
	| PPDEFINE IDENTIFIER_LPAREN DDD ')' ReplacementList
	| PPDEFINE IDENTIFIER_LPAREN IdentifierList ',' DDD ')' ReplacementList
	| PPDEFINE IDENTIFIER_LPAREN IdentifierListOpt ')' ReplacementList
	| PPERROR PPTokenListOpt
	| PPHASH_NL
	| PPINCLUDE PPTokenList '\n'
	| PPLINE PPTokenList '\n'
	| PPPRAGMA PPTokenListOpt
	| PPUNDEF IDENTIFIER '\n'
	| PPDEFINE IDENTIFIER_LPAREN IdentifierList DDD ')' ReplacementList
	| PPDEFINE '\n'
	| PPUNDEF IDENTIFIER PPTokenList '\n'
	| PPINCLUDE_NEXT PPTokenList '\n'
	;

TextLine :
	PPTokenListOpt
	;

ReplacementList :
	PPTokenListOpt
	;

PPTokenList :
	PPTokens
	;

PPTokenListOpt :
	'\n'
	| PPTokenList '\n'
	;

PPTokens :
	PPOTHER
	| PPTokens PPOTHER
	;

%%

%x DEFINE DIRECTIVE

sign                            [-+]
digit                           [0-9]
nonzero-digit                   [1-9]
nondigit                        [_a-zA-Z]
ucn-digit                       \x83
ucn-nondigit                    \x84
eof                             \x80
q-char                          [^\n\x22\x80]
q-char-sequence                 {q-char}+
digit-sequence                  {digit}+
binary-exponent-part            [pP]{sign}?{digit-sequence}
simple-sequence                 \\['\x22?\\abfnrtv]
octal-digit                     [0-7]
octal-escape-sequence           \\{octal-digit}{octal-digit}?{octal-digit}?
hexadecimal-digit               [0-9a-fA-F]
hexadecimal-digit-sequence      {hexadecimal-digit}+
hexadecimal-escape-sequence     \\x{hexadecimal-digit}+
hex-quad                        {hexadecimal-digit}{hexadecimal-digit}{hexadecimal-digit}{hexadecimal-digit}
universal-character-name        \\u{hex-quad}|\\U{hex-quad}{hex-quad}
escape-sequence                 {simple-sequence}|{octal-escape-sequence}|{hexadecimal-escape-sequence}|{universal-character-name}
c-char                          [^'\n\x80\\]|{escape-sequence}
c-char-sequence                 {c-char}+
character-constant              '{c-char-sequence}'
comment-close                   ([^*\x80]|\*+[^*/\x80])*\*+\/
decimal-constant                {nonzero-digit}{digit}*
fractional-constant             {digit-sequence}?\.{digit-sequence}|{digit-sequence}\.
exponent-part                   [eE]{sign}?{digit-sequence}
floating-suffix                 i?[flFL]?|[flFL]?i?
decimal-floating-constant       ({fractional-constant}{exponent-part}?|{digit-sequence}{exponent-part}){floating-suffix}?
hexadecimal-prefix              0[xX]
hexadecimal-constant            {hexadecimal-prefix}{hexadecimal-digit}+
hexadecimal-fractional-constant {hexadecimal-digit-sequence}?\.{hexadecimal-digit-sequence}|{hexadecimal-digit-sequence}\.
hexadecimal-floating-constant   {hexadecimal-prefix}({hexadecimal-fractional-constant}|{hexadecimal-digit-sequence}){binary-exponent-part}{floating-suffix}?
floating-constant               {decimal-floating-constant}|{hexadecimal-floating-constant}
h-char                          [^>\n\x80]
h-char-sequence                 {h-char}+
header-name                     <{h-char-sequence}>|\x22{q-char-sequence}\x22
identifier-nondigit             {nondigit}|{universal-character-name}|{ucn-nondigit}
identifier                      {identifier-nondigit}({identifier-nondigit}|{digit}|{ucn-digit}|"$")*
long-long-suffix                ll|LL
long-suffix                     [lL]
unsigned-suffix                 [uU]
integer-suffix                  {unsigned-suffix}({long-suffix}?|{long-long-suffix})|{long-suffix}{unsigned-suffix}?|{long-long-suffix}{unsigned-suffix}?
octal-constant                  0{octal-digit}*
integer-constant                ({decimal-constant}|{octal-constant}|{hexadecimal-constant}){integer-suffix}?
pp-number                       ({digit}|\.{digit})({digit}|{identifier-nondigit}|[eEpP]{sign}|\.)*
s-char                          [^\x22\n\x80\\]|{escape-sequence}
s-char-sequence                 {s-char}+
string-literal                  \x22{s-char-sequence}?\x22

%%

[ \t\f\v\r\n]+			skip()

"//".*			skip()

"/*"(?s:.)*?"*/"	skip()

"!"	'!'
"%"	'%'
"&"	'&'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"-"	'-'
"."	'.'
"/"	'/'
":"	':'
";"	';'
"<"	'<'
"="	'='
">"	'>'
"?"	'?'
<DIRECTIVE>"\n"	'\n'
"^"	'^'
"|"	'|'
"~"	'~'

"!="                            NEQ
//"%:"                            '#'
"%="                            MODASSIGN
"}"|"%>"                            '}'
"&&"                            ANDAND
"&="                            ANDASSIGN
"*="                            MULASSIGN
"++"                            INC
"+="                            ADDASSIGN
"--"                            DEC
"-="                            SUBASSIGN
"->"                            ARROW
"..."                           DDD
"/="                            DIVASSIGN
"]"|":>"                            ']'
"{"|"<%"                            '{'
"["|"<:"                            '['
"<<"                            LSH
"<<="                           LSHASSIGN
"<="                            LEQ
"=="                            EQ
">="                            GEQ
">>"                            RSH
">>="                           RSHASSIGN
"^="                            XORASSIGN
"|="                            ORASSIGN
"||"                            OROR

//"##"|"#%:"|"%:#"|"%:%:"       PPPASTE

/*
<DIRECTIVE>"define"             l.pop(); return PPDEFINE
<DIRECTIVE>"elif"               l.pop(); return PPELIF
<DIRECTIVE>"else"               l.pop(); return PPELSE
<DIRECTIVE>"endif"              l.pop(); return PPENDIF
<DIRECTIVE>"error"              l.pop(); return PPERROR
<DIRECTIVE>"if"                 l.pop(); return PPIF
<DIRECTIVE>"ifdef"              l.pop(); return PPIFDEF
<DIRECTIVE>"ifndef"             l.pop(); return PPIFNDEF
<DIRECTIVE>"include"            l.pop(); return PPINCLUDE
<DIRECTIVE>"include_next"       l.pop(); return PPINCLUDE_NEXT
<DIRECTIVE>"line"               l.pop(); return PPLINE
<DIRECTIVE>"pragma"             l.pop(); return PPPRAGMA
<DIRECTIVE>"undef"              l.pop(); return PPUNDEF

<HEADER>{header-name}           l.sc = scINITIAL
                                return PPHEADER_NAME
*/
"+="	ADDASSIGN
"_Alignof"	ALIGNOF
"&&"	ANDAND
"&="	ANDASSIGN
"->"	ARROW
"asm"	ASM
"auto"	AUTO
"_Bool"	BOOL
"break"	BREAK
"case"	CASE
"char"	CHAR
"_Complex"	COMPLEX
"const"	CONST
CONSTANT_EXPRESSION	CONSTANT_EXPRESSION
"continue"	CONTINUE
"..."	DDD
"--"	DEC
"default"	DEFAULT
"/="	DIVASSIGN
"do"	DO
"double"	DOUBLE
"else"	ELSE
"enum"	ENUM
"=="	EQ
"extern"	EXTERN
"float"	FLOAT
"for"	FOR
">="	GEQ
"goto"	GOTO
//IDENTIFIER_NONREPL	IDENTIFIER_NONREPL
"if"	IF
"++"	INC
"inline"	INLINE
"int"	INT
"<="	LEQ
"long"	LONG
"<<"	LSH
"<<="	LSHASSIGN
"%="	MODASSIGN
"*="	MULASSIGN
"!="	NEQ
"_Noreturn"	NORETURN
"|="	ORASSIGN
"||"	OROR
"#define"	PPDEFINE
"#elif"	PPELIF
"#else"	PPELSE
"#endif"	PPENDIF
"#error"	PPERROR
"#"	PPHASH_NL
//PPHEADER_NAME	PPHEADER_NAME
"#if"	PPIF
"#ifdef"	PPIFDEF
"#ifndef"	PPIFNDEF
"#include"	PPINCLUDE
"#include_next"	PPINCLUDE_NEXT
"#line"	PPLINE
"#foo"	PPNONDIRECTIVE
"ppother"	PPOTHER
//"##"	PPPASTE
"#pragma"	PPPRAGMA
"#undef"	PPUNDEF
PREPROCESSING_FILE	PREPROCESSING_FILE
"register"	REGISTER
"restrict"	RESTRICT
"return"	RETURN
">>"	RSH
">>="	RSHASSIGN
"short"	SHORT
"signed"	SIGNED
"sizeof"	SIZEOF
"static"	STATIC
"_Static_assert"	STATIC_ASSERT
"struct"	STRUCT
"-="	SUBASSIGN
"switch"	SWITCH
//TRANSLATION_UNIT	TRANSLATION_UNIT
"typedef"	TYPEDEF
"typedefname"	TYPEDEFNAME
"typeof"	TYPEOF
"union"	UNION
"unsigned"	UNSIGNED
"void"	VOID
"volatile"	VOLATILE
"while"	WHILE
"^="	XORASSIGN


L{character-constant}           LONGCHARCONST
L{string-literal}               LONGSTRINGLITERAL
{character-constant}            CHARCONST
{identifier}                    IDENTIFIER
<DEFINE>{identifier}"("         IDENTIFIER_LPAREN
{integer-constant}              INTCONST
{floating-constant}             FLOATCONST
//{pp-number}                     PPNUMBER
{string-literal}                STRINGLITERAL


%%
