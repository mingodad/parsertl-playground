//From: http://www.lubankit.org/luban.beta2.1.tar.gz
/*
			    Luban Build and Install Guide

                Copyright (C) 2005 by Xiaochuan(Peter) Huang

			    All rights reserved.

    Luban programming language package is free software; you can redistribute it and/or modify
    it under the terms of the "Luban License" which comes with this package.

    Luban is a scripting language with a component and composition model. It is simple and intuitive for
    scripting purpose, while its component model will help you manage and share your code when
    your luban code base grows.
*/

/*Tokens*/
%token ABSTRACT
%token ADD_ASN
%token AND_OP
%token AS
%token ASYNCH
%token BOOL
%token BOOLIT
%token BREAK
%token CANCEL
%token CHAR
%token CHARLITERAL
%token CLNCLN
%token CLOSURE
%token COMPOSITION
%token CONTINUE
%token DEC_OP
%token DIV_ASN
%token DOUBLE
%token ELSE
%token ENUM
%token EQ_OP
%token FINISH
%token FLOATER
%token FOR
%token FOREACH
%token GE_OP
%token HIDDEN
%token IF
%token IMPLEMENTS
%token IN
%token INC_OP
%token INPUT
%token INT
%token INTEGER
%token ISA
%token LBERROR
%token LBNULL
%token LE_OP
%token LOWER_THAN_ELSE
%token MAP
%token MOD_ASN
%token MUL_ASN
%token NAME
%token NAMESPACE
%token NE_OP
%token NOT_OP
%token OR_OP
%token OUT
//%token PNDPND
%token PROCESS
%token RANGE
%token READONLY
%token READWRITE
%token SET
%token STATIC
%token STATIONARY
%token STORE
%token STRING
%token STRLITERAL
%token STRUCT
%token SUB_ASN
%token SYNCH
%token TYPEDEF
%token TYPEINFO
%token TYPEOF
%token VECIT
%token VECITPAR
%token VECTOR
%token WAIT
%token WAITFOR
%token WHILE

%nonassoc /*1*/ LOWER_THAN_ELSE
%nonassoc /*2*/ ELSE

%start onesourceunit

%%

onesourceunit :
	namespacedec componentdeflist
	| prcstatementlist
	;

fullname :
	NAME CLNCLN NAME
	| fullname CLNCLN NAME
	;

namespacedec :
	NAMESPACE fullname ';'
	| NAMESPACE NAME ';'
	//| NAMESPACE error ';'
	;

componentdeflist :
	componentdef
	| componentdeflist componentdef
	;

componentdef :
	abstractstruct ';'
	| processstruct
	| processstruct ';'
	| compositionstruct
	| compositionstruct ';'
	| stationarystruct ';'
	| stationarystruct
	| typenamedef ';'
	//| error ';'
	;

stationarystruct :
	STATIONARY STRUCT NAME extendlist '(' stationarystitemlist ')'
	| STATIONARY STRUCT NAME extendlist '(' ')'
	;

stationarystitemlist :
	onestationarystructitem
	| stationarystitemlist onestationarystructitem
	;

onestationarystructitem :
	stationarystonetypeproperties ';'
	;

stationarystonetypeproperties :
	rwpermission onetypenames
	| onetypenames
	| STATIC rwpermission onetypenames
	| STATIC onetypenames
	;

typenamedef :
	TYPEDEF typeexpression NAME
	;

onetypenames :
	typeexpression namedvlist
	| namedvlist
	;

namedvlist :
	namedvitem
	| namedvlist ',' namedvitem
	;

namedvitem :
	NAME
	| NAME '=' conditionalexp
	;

castabletypes :
	DOUBLE
	| INT
	| STRING
	| BOOL
	| CHAR
	| VECTOR
	| MAP
	| SET
	| LBERROR
	;

basictypes :
	castabletypes
	| TYPEINFO
	| struct_declaration
	| type_name
	;

propertylist_dec :
	'(' propertylist ')'
	| '(' ')'
	;

struct_declaration :
	execmode_struct
	| STATIONARY STRUCT
	;

type_name :
	fullname
	| CLNCLN NAME
	;

abstractstruct :
	ABSTRACT execmode_struct NAME extendlist propertylist_dec
	;

execmode_struct :
	SYNCH STRUCT
	| ASYNCH STRUCT
	| STRUCT
	;

extendlist :
	IMPLEMENTS typenamelist
	| /*empty*/
	;

typenamelist :
	type_name
	| typenamelist ',' type_name
	;

propertylist :
	onepropertylistitem
	| propertylist onepropertylistitem
	;

onepropertylistitem :
	execattribute ':'
	| onetypeproperties ';'
	//| error ';'
	;

execattr_opt :
	execattribute
	| /*empty*/
	;

execattribute :
	INPUT
	| OUT
	| STORE
	| STATIC
	;

onetypeproperties :
	execattr_opt rwpermission onetypenames
	| execattr_opt onetypenames
	;

rwpermission :
	READONLY
	| HIDDEN
	| READWRITE
	;

processstruct :
	execmode_struct NAME extendlist propertylist_dec processstructdef
	;

processstructdef :
	AS PROCESS '{' prcstatementlist '}'
	| AS PROCESS '{' '}'
	//| AS PROCESS '{' error '}'
	;

compositionstruct :
	execmode_struct NAME extendlist propertylist_dec compstructdef
	;

compstructdef :
	AS COMPOSITION '{' compcelllist '}'
	//| AS COMPOSITION '{' error '}'
	;

prcstatementlist :
	prcstatement
	| prcstatementlist prcstatement
	;

stsep :
	';'
	| '&'
	;

prcstatement :
	dispatchable
	| typed_var_init ';'
	| IF '(' conditionalexp ')' prcstatement %prec LOWER_THAN_ELSE /*1N*/
	| IF '(' conditionalexp ')' prcstatement ELSE /*2N*/ prcstatement
	| WHILE '(' conditionalexp ')' prcstatement
	| forstatement
	| FOREACH '(' namelist IN expression ')' prcstatement
	| BREAK ';'
	| CONTINUE ';'
	| FINISH ';'
	| WAIT ';'
	| CANCEL ';'
	| WAITFOR variablelist ';'
	| prccollectoutput ';'
	| closure
	| compoundstatement
	| compoundstatementpar
	| ';'
	//| error ';'
	;

forstatement :
	FOR '(' expressionlist ';' conditionalexp ';' expressionlist ')' prcstatement
	| FOR '(' expressionlist ';' conditionalexp ';' ')' prcstatement
	| FOR '(' expressionlist ';' ';' expressionlist ')' prcstatement
	| FOR '(' expressionlist ';' ';' ')' prcstatement
	| FOR '(' ';' conditionalexp ';' expressionlist ')' prcstatement
	| FOR '(' ';' conditionalexp ';' ')' prcstatement
	| FOR '(' ';' ';' expressionlist ')' prcstatement
	| FOR '(' ';' ';' ')' prcstatement
	;

variablelist :
	variable
	| variablelist ',' variable
	;

prccollectoutput :
	OUT '=' var_exp '.' OUT
	;

dispatchable :
	expression stsep
	| prpbatchset stsep
	;

prpbatchset :
	var_exp '.' '(' namedarglist ')'
	;

closure :
	closure_prc
	| closure_comp
	;

closure_prc :
	CLOSURE execmode_struct NAME extendlist propertylist_dec processstructdef
	;

closure_comp :
	CLOSURE execmode_struct NAME extendlist propertylist_dec compstructdef
	;

typed_var_init :
	typeexpression var_init_list
	;

var_init_list :
	var_init_item
	| var_init_list ',' var_init_item
	;

var_init_item :
	NAME '=' expression
	| NAME
	;

compoundstatement :
	'{' prcstatementlist '}'
	//| '{' error '}'
	;

compoundstatementpar :
	'{' prcstatementlist '}' '&'
	;

expression :
	conditionalexp
	| var_exp assignop expression
	;

assignop :
	'='
	| MUL_ASN
	| DIV_ASN
	| MOD_ASN
	| ADD_ASN
	| SUB_ASN
	;

conditionalexp :
	or_exp
	| or_exp '?' expression ':' conditionalexp
	;

or_exp :
	and_exp
	| or_exp OR_OP and_exp
	;

and_exp :
	not_exp
	| and_exp AND_OP not_exp
	;

not_exp :
	equalityexp
	| NOT_OP equalityexp
	;

equalityexp :
	relexp
	| equalityexp EQ_OP relexp
	| equalityexp NE_OP relexp
	| equalityexp ISA relexp
	;

typeofexp :
	TYPEOF '(' expression ')'
	;

relexp :
	arithexp
	| relexp '>' arithexp
	| relexp '<' arithexp
	| relexp GE_OP arithexp
	| relexp LE_OP arithexp
	| typeofexp
	| typeexpression
	;

arithexp :
	arithexp '+' muldivexp
	| arithexp '-' muldivexp
	| muldivexp
	;

muldivexp :
	muldivexp '*' unaryexp
	| muldivexp '/' unaryexp
	| muldivexp '%' unaryexp
	| unaryexp
	;

unaryexp :
	postfixexp
	| INC_OP unaryexp
	| DEC_OP unaryexp
	| '+' unaryexp
	| '-' unaryexp
	;

postfixexp :
	postfixexp INC_OP
	| postfixexp DEC_OP
	| var_exp
	;

var_exp :
	atomexp
	| atomexp '(' namedarglist ')'
	| var_exp '.' NAME '(' ')'
	| var_exp '.' NAME '(' anonymousarglist ')'
	| var_exp '.' NAME
	| var_exp '[' expression ']'
	;

atomexp :
	'(' expression ')'
	| literal
	| vec_constru
	| map_constru
	| set_constru
	| variable
	| propertyref
	| type_name '(' namedarglist ')'
	| type_name '(' anonymousarglist ')'
	| type_name '(' ')'
	| castabletypes '(' anonymousarglist ')'
	| castabletypes '(' ')'
	;

variable :
	NAME
	| type_name '.' NAME
	;

propertyref :
	inpropertyref
	| outpropertyref
	| storepropertyref
	| staticpropertyref
	;

inpropertyref :
	INPUT '.' NAME
	;

outpropertyref :
	OUT '.' NAME
	;

storepropertyref :
	STORE '.' NAME
	;

staticpropertyref :
	STATIC '.' NAME
	;

literal :
	FLOATER
	| INTEGER
	| STRLITERAL
	| CHARLITERAL
	| BOOLIT
	| LBNULL
	;

vecop :
	'[' ']'
	| VECIT
	;

vec_constru :
	'[' expressionlist ']'
	| vecop
	;

expressionlist :
	expression
	| expressionlist ',' expression
	;

map_constru :
	'{' keyvaluelist '}'
	| '{' ':' '}'
	;

keyvaluelist :
	keyvaluepair
	| keyvaluelist ',' keyvaluepair
	;

keyvaluepair :
	expression ':' expression
	;

set_constru :
	'{' expressionlist '}'
	| '{' '}'
	;

namedarglist :
	onenamedarg
	| namedarglist ',' onenamedarg
	| '='
	| structvecop '='
	;

onenamedarg :
	NAME '=' conditionalexp
	| NAME structvecop '=' conditionalexp
	| INPUT '=' batchins
	| INPUT structvecop '=' batchins
	;

anonymousarglist :
	nonassignexplist
	;

nonassignexplist :
	conditionalexp
	| nonassignexplist ',' conditionalexp
	;

compcelllist :
	cell
	| compcelllist cell
	;

cell :
	NAME ':' expcelldef
	| NAME ':' compoundcelldef
	| ASYNCH NAME ':' compoundcelldef
	| outpropertyref ':' expcelldef
	| compcollectoutput
	;

compcollectoutput :
	OUT ':' type_name '(' namedarglist ')' '.' OUT stsep
	| OUT ':' NAME '.' OUT ';'
	| OUT ':' NAME '.' OUT
	;

structvecop :
	VECIT
	| VECITPAR
	;

batchins :
	type_name '.' INPUT
	| INPUT
	;

compoundcelldef :
	compoundstatement
	| compoundstatement stsep
	;

expcelldef :
	conditionalexp
	| conditionalexp stsep
	;

typeexplist :
	typeexpression
	| typeexplist ',' typeexpression
	;

typeexpression :
	'<' typeexplist '>'
	| RANGE '<' literal ',' literal '>'
	| ENUM '<' literallist '>'
	| basictypes
	;

namelist :
	NAME
	| namelist ',' NAME
	;

literallist :
	literal
	| literallist ',' literal
	;

%%

D                       [0-9]
L                       [a-zA-Z_]
E                       [Ee][+-]?{D}+

%%

"/*"(?s:.)*?"*/"	skip()
\/\/.*	skip()

"abstract"		ABSTRACT
"as"			AS
"asynch"		ASYNCH
"break"                 BREAK
"bool"                  BOOL
"cancel"                CANCEL
"char"                  CHAR
"closure"               CLOSURE
"composition"           COMPOSITION
"continue"              CONTINUE
"double"                DOUBLE
"else"                  ELSE
"enum"                  ENUM
"error"                 LBERROR
"finish"                FINISH
"false"                	BOOLIT
"for"                   FOR
"foreach"               FOREACH
"hidden"                HIDDEN
"if"                    IF
"implements"            IMPLEMENTS
"in"       	        IN
"input"       	        INPUT
"int"                   INT
"isa"           	ISA
"map"       	        MAP
"namespace"		NAMESPACE
"null"			LBNULL
"output"		OUT
"process"		PROCESS
"range"                 RANGE
"readonly"              READONLY
"readwrite"             READWRITE
"set"                	SET
"static"                STATIC
"stationary"            STATIONARY
"store"                	STORE
"string"                STRING
"struct"                STRUCT
"synch"                	SYNCH
"true"               	BOOLIT
"typedef"               TYPEDEF
"typeof"		TYPEOF
"typeinfo"		TYPEINFO
"vector"       	        VECTOR
"wait"			WAIT
"waitfor"		WAITFOR
"while"                 WHILE


"+="                    ADD_ASN
"-="                    SUB_ASN
"*="                    MUL_ASN
"/="                    DIV_ASN
"%="                    MOD_ASN
"++"                    INC_OP
"--"                    DEC_OP
"&&"                    AND_OP
"and"			AND_OP
"||"                    OR_OP
"or"                    OR_OP
"<="                    LE_OP
">="                    GE_OP
"=="                    EQ_OP
"!="                    NE_OP
"::"			CLNCLN
"[]"			VECIT
"[&]"			VECITPAR
";"                     ';'
"{"		        '{'
"}"                     '}'
","                     ','
":"                     ':'
"="                     '='
"("                     '('
")"                     ')'
"["                     '['
"]"                     ']'
"."                     '.'
"&"                     '&'
"-"                     '-'
"+"                     '+'
"*"                     '*'
"/"                     '/'
"%"                     '%'
"!"			NOT_OP
"not"			NOT_OP
"<"                     '<'
">"                     '>'
"?"                     '?'
//"##"                    PNDPND

{D}+			INTEGER
{D}*\.{D}+{E}?		FLOATER
{D}+\.{D}*{E}?		FLOATER

(_|{L})+(_|{L}|[0-9])*	NAME

\"(\\.|[^\\"])*\"     STRLITERAL
'(\\.|[^\\'])'       CHARLITERAL

[ \t\n\r]		skip() /* ignore white spaces and change of line */


%%
