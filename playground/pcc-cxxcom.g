/*	$Id: cgram.y,v 1.11 2016/10/11 13:48:24 ragge Exp $	*/

/*
 * Copyright (c) 2003 Anders Magnusson (ragge@ludd.luth.se).
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * Copyright(C) Caldera International Inc. 2001-2002. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * Redistributions of source code and documentation must retain the above
 * copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * All advertising materials mentioning features or use of this software
 * must display the following acknowledgement:
 * 	This product includes software developed or owned by Caldera
 *	International, Inc.
 * Neither the name of Caldera International, Inc. nor the names of other
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * USE OF THE SOFTWARE PROVIDED FOR UNDER THIS LICENSE BY CALDERA
 * INTERNATIONAL, INC. AND CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL CALDERA INTERNATIONAL, INC. BE LIABLE
 * FOR ANY DIRECT, INDIRECT INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OFLIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * Comments for this grammar file. Ragge 021123
 *
 * ANSI support required rewrite of the function header and declaration
 * rules almost totally.
 *
 * The lex/yacc shared keywords are now split from the keywords used
 * in the rest of the compiler, to simplify use of other frontends.
 */

/*
 * At last count, there were 5 shift/reduce and no reduce/reduce conflicts
 * Four are accounted for;
 * One is "dangling else"
 * Two is in attribute parsing
 * One is in ({ }) parsing
 */

/*Tokens*/
%token C_STRING
%token C_ICON
%token C_FCON
%token C_NAME
%token C_TYPENAME
%token C_ANDAND
%token C_OROR
%token C_GOTO
%token C_RETURN
%token C_TYPE
%token C_CLASS
%token C_ASOP
%token C_RELOP
%token C_EQUOP
%token C_DIVOP
%token C_SHIFTOP
%token C_INCOP
%token C_UNOP
%token C_STROP
%token C_STRUCT
%token C_IF
%token C_ELSE
%token C_SWITCH
%token C_BREAK
%token C_CONTINUE
%token C_WHILE
%token C_DO
%token C_FOR
%token C_DEFAULT
%token C_CASE
%token C_SIZEOF
%token C_ALIGNOF
%token C_ENUM
%token C_ELLIPSIS
%token C_QUALIFIER
%token C_FUNSPEC
%token C_ASM
%token NOMATCH
%token C_TYPEOF
%token C_ATTRIBUTE
%token PCC_OFFSETOF
%token GCC_DESIG
%token CXX_NAMESPACE
%token CXX_DUALCC
%token CXX_TEMPLATE
%token CXX_USING
%token CXX_TYPENAME
%token CXX_CASTS
//%token CXX_THROW
%token CXX_MORENM
%token CXX_NEW
%token CXX_DELETE
//%token CXX_CLASS
%token ','
%token '='
%token '?'
%token ':'
%token '|'
%token '^'
%token '&'
%token '+'
%token '-'
%token '*'
%token '['
%token '('
%token ';'
%token ')'
%token '}'
%token '{'
%token ']'

%left /*1*/ ','
%right /*2*/ C_ASOP '='
%right /*3*/ '?' ':'
%left /*4*/ C_OROR
%left /*5*/ C_ANDAND
%left /*6*/ '|'
%left /*7*/ '^'
%left /*8*/ '&'
%left /*9*/ C_EQUOP
%left /*10*/ C_RELOP
%left /*11*/ C_SHIFTOP
%left /*12*/ '+' '-'
%left /*13*/ C_DIVOP '*'
%right /*14*/ C_UNOP
%right /*15*/ C_INCOP C_SIZEOF
%left /*16*/ C_STROP '[' '('

%start edf

%%

edf :
	ext_def_list
	| /*empty*/
	;

ext_def_list :
	ext_def_list external_def
	| external_def
	;

external_def :
	funtype kr_args compoundstmt
	| declaration
	| namespace
	| extlink
	| blockdcl
	| ';'
	//| error
	;

funtype :
	declarator
	| declaration_specifiers declarator
	;

kr_args :
	/*empty*/
	| arg_dcl_list
	;

blockdcl :
	simple_decl
	| asmstatement
	| ns_alias
	| using_x
	;

using_x :
	CXX_USING tnopt ccopt nested_name_sp ';'
	| CXX_USING CXX_NAMESPACE ccopt nested_name_sp ';'
	;

tnopt :
	CXX_TYPENAME
	| /*empty*/
	;

ns_alias :
	CXX_NAMESPACE C_NAME '=' /*2R*/ qual_ns_sp ';'
	;

qual_ns_sp :
	ccopt nested_name_sp
	;

nested_name_sp :
	nmtnm
	| nmtnm CXX_DUALCC nested_name_sp
	| nmtnm CXX_DUALCC CXX_TEMPLATE nested_name_sp
	;

nmtnm :
	C_NAME
	| C_TYPENAME
	;

ccopt :
	CXX_DUALCC
	| /*empty*/
	;

simple_decl :
	')' NOMATCH
	;

namespace :
	CXX_NAMESPACE nsname attr_var nsbeg ns_body '}'
	;

nsname :
	C_NAME
	| /*empty*/
	;

ns_body :
	ext_def_list
	| /*empty*/
	;

nsbeg :
	'{'
	;

extlink :
	C_CLASS C_STRING eb '{' ext_def_list '}'
	| C_CLASS C_STRING eb '{' '}'
	| C_CLASS C_STRING eb declaration
	;

eb :
	/*empty*/
	;

declaration_specifiers :
	merge_attribs
	;

merge_attribs :
	type_sq
	| type_sq merge_attribs
	| cf_spec
	| cf_spec merge_attribs
	;

type_sq :
	C_TYPE
	| C_TYPENAME
	| struct_dcl
	| enum_dcl
	| C_QUALIFIER
	| attribute_specifier
	| typeof
	;

cf_spec :
	C_CLASS
	| C_FUNSPEC
	;

typeof :
	C_TYPEOF '(' /*16L*/ e ')'
	| C_TYPEOF '(' /*16L*/ cast_type ')'
	;

new_ma :
	new_type_sq
	| new_type_sq new_ma
	| cf_spec
	| cf_spec new_ma
	;

new_ds :
	new_ma
	;

new_type_sq :
	C_TYPE
	| C_TYPENAME
	| struct_dcl
	| enum_dcl
	| C_QUALIFIER
	;

attribute_specifier :
	C_ATTRIBUTE '(' /*16L*/ '(' /*16L*/ attribute_list ')' ')'
	;

attribute_list :
	attribute
	| attribute ',' /*1L*/ attribute_list
	;

attribute :
	/*empty*/
	| C_NAME
	| C_NAME '(' /*16L*/ elist ')'
	;

declarator :
	'*' /*13L*/ declarator
	| '*' /*13L*/ type_qualifier_list declarator
	| nmrec C_NAME
	| C_NAME
	| '(' /*16L*/ attr_spec_list declarator ')'
	| '(' /*16L*/ declarator ')'
	| declarator '[' /*16L*/ e ']'
	| declarator '[' /*16L*/ C_CLASS e ']'
	| declarator '[' /*16L*/ ']'
	| declarator '[' /*16L*/ '*' /*13L*/ ']'
	| declarator '(' /*16L*/ parameter_type_list ')'
	| declarator '(' /*16L*/ identifier_list ')'
	| declarator '(' /*16L*/ ')'
	;

type_qualifier_list :
	C_QUALIFIER
	| type_qualifier_list C_QUALIFIER
	| attribute_specifier
	| type_qualifier_list attribute_specifier
	;

identifier_list :
	C_NAME
	| identifier_list ',' /*1L*/ C_NAME
	;

parameter_type_list :
	parameter_list
	| parameter_list ',' /*1L*/ C_ELLIPSIS
	;

parameter_list :
	parameter_declaration
	| parameter_declaration '&' /*8L*/
	| parameter_list ',' /*1L*/ parameter_declaration
	;

parameter_declaration :
	declaration_specifiers declarator attr_var
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

abstract_declarator :
	'*' /*13L*/
	| '*' /*13L*/ type_qualifier_list
	| '*' /*13L*/ abstract_declarator
	| '*' /*13L*/ type_qualifier_list abstract_declarator
	| '(' /*16L*/ abstract_declarator ')'
	| '[' /*16L*/ ']' attr_var
	| '[' /*16L*/ e ']' attr_var
	| abstract_declarator '[' /*16L*/ ']' attr_var
	| abstract_declarator '[' /*16L*/ e ']' attr_var
	| '(' /*16L*/ ')'
	| '(' /*16L*/ ib2 parameter_type_list ')'
	| abstract_declarator '(' /*16L*/ ')'
	| abstract_declarator '(' /*16L*/ ib2 parameter_type_list ')'
	;

ib2 :
	/*empty*/
	;

arg_dcl_list :
	arg_declaration
	| arg_dcl_list arg_declaration
	;

arg_declaration :
	declaration_specifiers arg_param_list ';'
	;

arg_param_list :
	declarator attr_var
	| arg_param_list ',' /*1L*/ declarator attr_var
	;

block_item_list :
	block_item
	| block_item_list block_item
	;

block_item :
	declaration
	| statement
	;

declaration :
	declaration_specifiers ';'
	| declaration_specifiers init_declarator_list ';'
	;

init_declarator_list :
	init_declarator
	| init_declarator_list ',' /*1L*/ attr_var init_declarator
	;

enum_dcl :
	enum_head '{' moe_list optcomma '}'
	| C_ENUM C_NAME
	;

enum_head :
	C_ENUM
	| C_ENUM C_NAME
	;

moe_list :
	moe
	| moe_list ',' /*1L*/ moe
	;

moe :
	C_NAME
	| C_TYPENAME
	| C_NAME '=' /*2R*/ e
	| C_TYPENAME '=' /*2R*/ e
	;

struct_dcl :
	str_head '{' struct_dcl_list '}'
	| C_STRUCT attr_var C_NAME
	| C_STRUCT attr_var nmrec C_NAME
	| str_head '{' '}'
	;

attr_var :
	/*empty*/
	| attr_spec_list
	;

attr_spec_list :
	attribute_specifier
	| attr_spec_list attribute_specifier
	;

str_head :
	C_STRUCT attr_var
	| C_STRUCT attr_var C_NAME
	;

struct_dcl_list :
	struct_declaration
	| struct_dcl_list struct_declaration
	;

struct_declaration :
	declaration_specifiers struct_declarator_list optsemi
	| C_NAME ':' /*3R*/
	;

optsemi :
	';'
	| optsemi ';'
	;

specifier_qualifier_list :
	merge_specifiers
	;

merge_specifiers :
	type_sq merge_specifiers
	| type_sq
	;

struct_declarator_list :
	struct_declarator
	| struct_declarator_list ',' /*1L*/ struct_declarator
	;

struct_declarator :
	declarator attr_var
	| ':' /*3R*/ e
	| declarator ':' /*3R*/ e
	| declarator ':' /*3R*/ e attr_spec_list
	| /*empty*/
	;

xnfdeclarator :
	declarator attr_var
	| declarator C_ASM '(' /*16L*/ string ')'
	;

init_declarator :
	declarator attr_var
	| declarator C_ASM '(' /*16L*/ string ')' attr_var
	| xnfdeclarator '=' /*2R*/ e
	| xnfdeclarator '=' /*2R*/ begbr init_list optcomma '}'
	| xnfdeclarator '=' /*2R*/ begbr '}'
	| xnfdeclarator '=' /*2R*/ addrlbl
	;

begbr :
	'{'
	;

initializer :
	e %prec ',' /*1L*/
	| addrlbl
	| ibrace init_list optcomma '}'
	| ibrace '}'
	;

init_list :
	designation initializer
	| init_list ',' /*1L*/ designation initializer
	;

designation :
	designator_list '=' /*2R*/
	| GCC_DESIG
	| '[' /*16L*/ e C_ELLIPSIS e ']' '=' /*2R*/
	| /*empty*/
	;

designator_list :
	designator
	| designator_list designator
	;

designator :
	'[' /*16L*/ e ']'
	| C_STROP /*16L*/ C_TYPENAME
	| C_STROP /*16L*/ C_NAME
	;

optcomma :
	/*empty*/
	| ',' /*1L*/
	;

ibrace :
	'{'
	;

compoundstmt :
	begin block_item_list '}'
	| begin '}'
	;

begin :
	'{'
	;

statement :
	e ';'
	| compoundstmt
	| ifprefix statement
	| ifelprefix statement
	| whprefix statement
	| doprefix statement C_WHILE '(' /*16L*/ e ')' ';'
	| forprefix .e ')' statement
	| switchpart statement
	| C_BREAK ';'
	| C_CONTINUE ';'
	| C_RETURN ';'
	| C_RETURN e ';'
	| C_GOTO C_NAME ';'
	| C_GOTO '*' /*13L*/ e ';'
	| asmstatement ';'
	| ';'
	//| error ';'
	//| error '}'
	| label statement
	;

asmstatement :
	C_ASM mvol '(' /*16L*/ string ')'
	| C_ASM mvol '(' /*16L*/ string xasm ')'
	;

mvol :
	/*empty*/
	| C_QUALIFIER
	;

xasm :
	':' /*3R*/ oplist
	| ':' /*3R*/ oplist ':' /*3R*/ oplist
	| ':' /*3R*/ oplist ':' /*3R*/ oplist ':' /*3R*/ cnstr
	;

oplist :
	/*empty*/
	| oper
	;

oper :
	string '(' /*16L*/ e ')'
	| oper ',' /*1L*/ string '(' /*16L*/ e ')'
	;

cnstr :
	string
	| cnstr ',' /*1L*/ string
	;

label :
	C_NAME ':' /*3R*/ attr_var
	| C_TYPENAME ':' /*3R*/ attr_var
	| C_CASE e ':' /*3R*/
	| C_CASE e C_ELLIPSIS e ':' /*3R*/
	| C_DEFAULT ':' /*3R*/
	;

doprefix :
	C_DO
	;

ifprefix :
	C_IF '(' /*16L*/ e ')'
	;

ifelprefix :
	ifprefix statement C_ELSE
	;

whprefix :
	C_WHILE '(' /*16L*/ e ')'
	;

forprefix :
	C_FOR '(' /*16L*/ .e ';' .e ';'
	| C_FOR '(' /*16L*/ declaration .e ';'
	;

switchpart :
	C_SWITCH '(' /*16L*/ e ')'
	;

.e :
	e
	| /*empty*/
	;

elist :
	/*empty*/
	| e %prec ',' /*1L*/
	| elist ',' /*1L*/ e
	| elist ',' /*1L*/ cast_type
	;

e :
	e ',' /*1L*/ e
	| e '=' /*2R*/ e
	| e C_ASOP /*2R*/ e
	| e '?' /*3R*/ e ':' /*3R*/ e
	| e '?' /*3R*/ ':' /*3R*/ e
	| e C_OROR /*4L*/ e
	| e C_ANDAND /*5L*/ e
	| e '|' /*6L*/ e
	| e '^' /*7L*/ e
	| e '&' /*8L*/ e
	| e C_EQUOP /*9L*/ e
	| e C_RELOP /*10L*/ e
	| e C_SHIFTOP /*11L*/ e
	| e '+' /*12L*/ e
	| e '-' /*12L*/ e
	| e C_DIVOP /*13L*/ e
	| e '*' /*13L*/ e
	| e '=' /*2R*/ addrlbl
	| term
	;

xbegin :
	begin
	;

addrlbl :
	C_ANDAND /*5L*/ C_NAME
	;

term :
	term C_INCOP /*15R*/
	| '*' /*13L*/ term
	| '&' /*8L*/ term
	| '-' /*12L*/ term
	| '+' /*12L*/ term
	| CXX_CASTS C_RELOP /*10L*/ cast_type C_RELOP /*10L*/ '(' /*16L*/ e ')'
	| C_UNOP /*14R*/ term
	| C_INCOP /*15R*/ term
	| C_SIZEOF /*15R*/ xa term
	| '(' /*16L*/ cast_type ')' term %prec C_INCOP /*15R*/
	| C_SIZEOF /*15R*/ xa '(' /*16L*/ cast_type ')' %prec C_SIZEOF /*15R*/
	| C_ALIGNOF xa '(' /*16L*/ cast_type ')'
	| '(' /*16L*/ cast_type ')' clbrace init_list optcomma '}'
	| '(' /*16L*/ cast_type ')' clbrace '}'
	| term '[' /*16L*/ e ']'
	| C_NAME '(' /*16L*/ elist ')'
	| term '(' /*16L*/ elist ')'
	| term C_STROP /*16L*/ C_NAME
	| term C_STROP /*16L*/ C_TYPENAME
	| C_NAME %prec C_SIZEOF /*15R*/
	| nmrec C_NAME %prec C_SIZEOF /*15R*/
	| PCC_OFFSETOF '(' /*16L*/ cast_type ',' /*1L*/ term ')'
	| C_ICON
	| C_FCON
	| string
	| '(' /*16L*/ e ')'
	| '(' /*16L*/ xbegin block_item_list e ';' '}' ')'
	| '(' /*16L*/ xbegin block_item_list '}' ')'
	| CXX_NEW new_ds
	| CXX_NEW '(' /*16L*/ cast_type ')'
	| CXX_DELETE term %prec '-' /*12L*/
	| CXX_DELETE '[' /*16L*/ ']' term %prec '-' /*12L*/
	;

nmrec :
	CXX_MORENM
	| CXX_MORENM nmrec
	;

xa :
	/*empty*/
	;

clbrace :
	'{'
	;

string :
	C_STRING
	| string C_STRING
	;

cast_type :
	specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

%%

D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
P			[Pp][+-]?{D}+
FS			(f|F|l|L)?i?
IS			(u|U|l|L)*
UL			({L}|\\u{H}{H}{H}{H}|\\U{H}{H}{H}{H}{H}{H}{H}{H})

%%

"__func__"		C_STRING

"asm"			C_ASM
"auto"			C_CLASS
"_Bool"			C_TYPE
"break"			C_BREAK
"case"			C_CASE
"char"			C_TYPE
"class"			C_STRUCT
"_Complex"		C_TYPE
"const"			C_QUALIFIER
"const_cast"		CXX_CASTS
"continue"		C_CONTINUE
"default"		C_DEFAULT
"delete"		CXX_DELETE
"do"			C_DO
"double"		C_TYPE
"dynamic_cast"		CXX_CASTS
"else"			C_ELSE
"enum"			C_ENUM
"extern"		C_CLASS
"float"			C_TYPE
"for"			C_FOR
"goto"			C_GOTO
"if"			C_IF
"_Imaginary"		C_TYPE
"inline"		C_FUNSPEC
"int"			C_TYPE
"long"			C_TYPE
"namespace"		CXX_NAMESPACE
"new"			CXX_NEW
"register"		C_CLASS
"reinterpret_cast"	CXX_CASTS
"restrict"		skip()
"return"		C_RETURN
"short"			C_TYPE
"signed"		C_TYPE
"sizeof"		C_SIZEOF
"static"		C_CLASS
"static_cast"		CXX_CASTS
"struct"		C_STRUCT
"switch"		C_SWITCH
"template"		CXX_TEMPLATE
"typedef"		C_CLASS
"typename"		CXX_TYPENAME
"union"			C_STRUCT
"unsigned"		C_TYPE
"using"			CXX_USING
"void"			C_TYPE
"volatile"		C_QUALIFIER
"while"			C_WHILE

C_ALIGNOF	C_ALIGNOF
NOMATCH	NOMATCH
C_TYPEOF	C_TYPEOF
C_ATTRIBUTE	C_ATTRIBUTE
PCC_OFFSETOF	PCC_OFFSETOF
GCC_DESIG	GCC_DESIG
CXX_MORENM	CXX_MORENM

C_TYPENAME	C_TYPENAME
{UL}({UL}|{D})*		C_NAME
0[xX]{H}+{IS}?		C_ICON
0{D}+{IS}?		C_ICON
{D}+{IS}?		C_ICON
L'(\\.|[^\\'])*'	C_ICON
'(\\.|[^\\'])*'		C_ICON

{D}+{E}{FS}?		C_FCON
{D}*"."{D}+({E})?{FS}?	C_FCON
{D}+"."{D}*({E})?{FS}?	C_FCON
0[xX]{H}*"."{H}+{P}{FS}? C_FCON
0[xX]{H}+"."{P}{FS}?	C_FCON
0[xX]{H}+{P}{FS}?	C_FCON

L?\"(\\.|[^\\"])*\"	C_STRING

"..."			C_ELLIPSIS
">>="			C_ASOP
"<<="			C_ASOP
"+="			C_ASOP
"-="			C_ASOP
"*="			C_ASOP
"/="			C_ASOP
"%="			C_ASOP
"&="			C_ASOP
"^="			C_ASOP
"|="			C_ASOP
">>"			C_SHIFTOP
"<<"			C_SHIFTOP
"++"			C_INCOP
"--"			C_INCOP
"->"			C_STROP
"&&"			C_ANDAND
"||"			C_OROR
"<="			C_RELOP
">="			C_RELOP
"=="			C_EQUOP
"!="			C_EQUOP
"::"			CXX_DUALCC
";"			';'
("{"|"<%")		'{'
("}"|"%>")		'}'
","			','
":"			':'
"="			'='
"("			'('
")"			')'
("["|"<:")		'['
("]"|":>")		']'
"."			C_STROP
"&"			'&'
"!"			C_UNOP
"~"			C_UNOP
"-"			'-'
"+"			'+'
"*"			'*'
"/"			C_DIVOP
"%"			C_DIVOP
"<"			C_RELOP
">"			C_RELOP
"^"			'^'
"|"			'|'
"?"			'?'
^#pragma[ \t].*		skip()
^#ident[ \t].*		skip()
^#line[ \t].*		skip()
^#.*			skip()

[ \t\v\f]		skip()
"\n"			skip()
//.			{ /* ignore bad characters */ }

%%
