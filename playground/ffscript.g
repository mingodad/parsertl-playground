//From: https://github.com/ZQuestClassic/ZQuestClassic/blob/d7c9df43382a600bb93b8bce3edcfef5adc10d88/src/parser/ffscript.ypp
/* -*- mode: bison; tab-width: 4 -*-
 * Parser for the scripting language compiler. Intended for use with Flex
 * and Bison. Use this file to generate y.tab.cpp:
 * $ bison -b y -v -d ffscript.ypp
 */

/*Tokens*/
//%token ADDR
%token ALWAYS
%token AND
%token ANDASSIGN
%token APPXEQUAL
%token ARROW
%token ASSIGN
%token BITAND
%token BITANDASSIGN
%token BITNOT
%token BITNOTASSIGN
%token BITOR
%token BITORASSIGN
%token BITXOR
%token BITXORASSIGN
%token BREAK
%token CASE
%token CASESTRING
%token CASSERT
//%token CAST
%token COLON
%token COMMA
%token CONSTEXPR
%token CONTINUE
%token DECREMENT
%token DEFAULT
//%token DEFINE
%token DELETE
%token DIVIDE
%token DIVIDEASSIGN
%token DO
%token DOT
//%token DOUBLEADDR
//%token DOUBLEBANG
//%token DOUBLESTAR
%token ELSE
%token EMPTYBRACKETS
%token ENDLINE
%token ENUM
%token EQ
%token EXPECTERROR
%token EXPN
%token FOR
%token GE
%token GT
%token HANDLE
//%token HANDLETOHANDLE
%token HASH
%token IDENTIFIER
%token IF
%token IMPORT
%token IMPORTSTRING
%token IN
%token INCLUDE
%token INCLUDEIF
%token INCLUDEPATH
%token INCREMENT
%token INHERIT
%token INLINE
%token INTERNAL
//%token INVMOD
%token ISINCLUDED
%token LBRACE
%token LBRACKET
%token LE
%token LONGNUMBER
%token LOOP
%token LPAREN
%token LSHIFT
%token LSHIFTASSIGN
%token LT
%token MINUS
%token MINUSASSIGN
%token MODULO
%token MODULOASSIGN
%token NAMESPACE
%token NE
%token NEW
%token NEWLINE
%token NOT
%token NUMBER
%token OPTION
%token OPTIONVALUE
%token OR
%token ORASSIGN
//%token PERCENT
%token PLUS
%token PLUSASSIGN
%token QMARK
%token QUOTEDSTRING
%token RANGE
%token RANGE_L
%token RANGE_LR
%token RANGE_N
%token RANGE_R
%token RBRACE
%token RBRACKET
%token REPEAT
%token RETURN
%token RPAREN
%token RSHIFT
%token RSHIFTASSIGN
%token SCOPERES
%token SCRIPT
%token SEMICOLON
%token SINGLECHAR
%token STATIC
%token SWITCH
%token TIMES
%token TIMESASSIGN
%token TYPEDEF
%token UNLESS
%token UNTIL
%token UNTYPED
%token USING
%token WHILE
%token XOR
//%token ZASM
%token ZAUTO
%token ZBOOL
%token ZCHAR
%token ZCLASS
%token ZCONST
%token ZFALSE
%token ZFLOAT
%token ZLONG
%token ZRGB
%token ZTRUE
%token ZVOID

%left /*1*/ NEW
%left /*2*/ DELETE
%left /*3*/ INCREMENT DECREMENT
%left /*4*/ NOT BITNOT
%left /*5*/ EXPN
%left /*6*/ TIMES DIVIDE MODULO
%left /*7*/ PLUS MINUS
%left /*8*/ LSHIFT RSHIFT
%left /*9*/ LE LT GE GT EQ NE
%left /*10*/ BITAND BITXOR BITOR
%left /*11*/ AND OR XOR
%precedence /*12*/ RPAREN
%precedence /*13*/ ELSE

%start Init

%%

Init :
	Global_List
	;

Global_List :
	Global_List Global_Statement
	| Global_List Option
	| /*empty*/
	;

Global_Statement :
	Import
	| IncludePath
	| Namespace
	| DataTypeDef SEMICOLON
	| ScriptTypeDef SEMICOLON
	| Data SEMICOLON
	| Function
	| Script
	| Annotated_Script
	| Class
	| DataEnum SEMICOLON
	| Using SEMICOLON
	| AlwaysUsing SEMICOLON
	| Statement_Assert SEMICOLON
	| EXPECTERROR LPAREN Expression_Constant RPAREN /*12P*/ Global_Statement
	;

Namespace :
	NAMESPACE Scoperes_Identifier_List LBRACE RBRACE
	| NAMESPACE Scoperes_Identifier_List LBRACE Namespace_Block_List RBRACE
	;

Namespace_Block_List :
	Namespace_Block_List Namespace_Statement
	| Namespace_Block_List Option
	| Namespace_Statement
	| Option
	;

Namespace_Statement :
	Namespace
	| DataTypeDef SEMICOLON
	| ScriptTypeDef SEMICOLON
	| Data SEMICOLON
	| Function
	| Script
	| Annotated_Script
	| Class
	| DataEnum SEMICOLON
	| Using SEMICOLON
	| Statement_Assert SEMICOLON
	| EXPECTERROR LPAREN Expression_Constant RPAREN /*12P*/ Namespace_Statement
	;

Using :
	USING NAMESPACE Scoperes_Identifier_List
	;

AlwaysUsing :
	ALWAYS USING NAMESPACE Scoperes_Identifier_List
	;

Import :
	IMPORT QUOTEDSTRING //IMPORTSTRING
	| HASH INCLUDE IMPORTSTRING
	| HASH INCLUDEIF LPAREN Expression_Constant COMMA IMPORTSTRING RPAREN /*12P*/
	;

IncludePath :
	HASH INCLUDEPATH IMPORTSTRING
	;

Option :
	HASH OPTION IDENTIFIER Expression_Constant ENDLINE
	| HASH OPTION IDENTIFIER Expression_Constant NEWLINE
	| HASH OPTION IDENTIFIER INHERIT ENDLINE
	| HASH OPTION IDENTIFIER INHERIT NEWLINE
	| HASH OPTION IDENTIFIER DEFAULT ENDLINE
	| HASH OPTION IDENTIFIER DEFAULT NEWLINE
	| HASH OPTION DEFAULT Expression_Constant ENDLINE
	| HASH OPTION DEFAULT Expression_Constant NEWLINE
	| HASH OPTION DEFAULT INHERIT ENDLINE
	| HASH OPTION DEFAULT INHERIT NEWLINE
	| HASH OPTION DEFAULT DEFAULT ENDLINE
	| HASH OPTION DEFAULT DEFAULT NEWLINE
	;

Statement_Assert :
	CASSERT LPAREN Expression_Constant RPAREN /*12P*/
	| CASSERT LPAREN Expression_Constant COMMA QuotedString RPAREN /*12P*/
	;

DataTypeDef :
	StandardDataTypedef
	| EnumDataTypedef
	;

StandardDataTypedef :
	TYPEDEF DataType IDENTIFIER
	;

EnumDataTypedef :
	ENUM IDENTIFIER LBRACE Enum_Block RBRACE
	;

DataType :
	DataType EMPTYBRACKETS
	| DataType_Mods
	;

DataType_Mods :
	ZCONST DataType_Base
	| DataType_Base
	;

DataType_Base :
	ZAUTO
	| ZVOID
	| UNTYPED
	| ZBOOL
	| ZFLOAT
	| ZCHAR
	| ZLONG
	| ZRGB
	| Identifier_List
	;

ScriptTypeDef :
	SCRIPT TYPEDEF Script_Type IDENTIFIER
	;

Data :
	INTERNAL Data
	| DataType Data_List
	;

Data_List :
	Data_List COMMA Data_Element
	| Data_Element
	;

Data_Element :
	Data_Element_Array_List ASSIGN Expression
	| Data_Element_Array_List
	;

Data_Element_Array_List :
	Data_Element_Array_List Data_Element_Array_Element
	| Identifier
	;

Single_Data_req_assign :
	DataType Identifier ASSIGN Expression
	;

Data_Element_Array_Element :
	LBRACKET Data_Element_Array_Element_Size_List RBRACKET
	| EMPTYBRACKETS
	;

Data_Element_Array_Element_Size_List :
	Data_Element_Array_Element_Size_List COMMA Expression_Constant
	| Expression_Constant
	;

Function :
	CONSTEXPR Function
	| STATIC Function
	| INLINE Function
	| INTERNAL Function
	| DataType Function_Typeless
	;

Function_Typeless :
	Function_Heading Statement_Block
	| Function_Heading SEMICOLON
	| Function_Heading COLON DEFAULT Expression_Constant SEMICOLON
	;

Function_Heading :
	Identifier_List LPAREN Function_Parameters_List RPAREN /*12P*/
	| Identifier_List LT /*9L*/ FunctionTemplateList GT /*9L*/ LPAREN Function_Parameters_List RPAREN /*12P*/
	;

FunctionTemplateList :
	Identifier
	| FunctionTemplateList COMMA Identifier
	;

Function_Parameters_List :
	Function_Parameters_Element COMMA Function_Parameters_List
	| Function_Parameters_Element
	| Function_OptParams_List
	| Function_VarArg_Element
	| /*empty*/
	;

Function_Parameters_Element :
	DataType Identifier
	;

Function_OptParams_List :
	Function_Parameters_Element ASSIGN Expression_Constant COMMA Function_OptParams_List
	| Function_Parameters_Element ASSIGN Expression_Constant
	;

Function_VarArg_Element :
	RANGE Function_Parameters_Element
	;

Class_Ident :
	IDENTIFIER
	;

Class :
	ZCLASS Class_Ident Class_Block
	;

Class_Block :
	LBRACE Class_Block_List RBRACE
	| LBRACE RBRACE
	;

Class_Block_List :
	Class_Block_List Class_Block_Element
	| Class_Block_List Option
	| Class_Block_List Class_Constructor
	| Class_Block_List Class_Destructor
	| Class_Block_Element
	| Option
	| Class_Constructor
	| Class_Destructor
	;

Class_Constructor :
	INTERNAL Class_Constructor
	| Function_Typeless
	;

Class_Destructor :
	BITNOT /*4L*/ Function_Typeless
	;

Class_Data :
	Data
	;

Class_Block_Element :
	Class_Data SEMICOLON
	| Function
	| DataTypeDef SEMICOLON
	| DataEnum SEMICOLON
	| Using SEMICOLON
	| Statement_Assert SEMICOLON
	| EXPECTERROR LPAREN Expression_Constant RPAREN /*12P*/ Class_Block_Element
	;

Annotated_Script :
	Annotation_List Script
	;

Script :
	Script_Type SCRIPT IDENTIFIER Script_Block
	;

Script_Type :
	IDENTIFIER
	;

Script_Block :
	LBRACE Script_Block_List RBRACE
	| LBRACE RBRACE
	;

Script_Block_List :
	Script_Block_List Script_Block_Element
	| Script_Block_List Option
	| Script_Block_Element
	| Option
	;

Script_Block_Element :
	Data SEMICOLON
	| Function
	| DataTypeDef SEMICOLON
	| DataEnum SEMICOLON
	| Using SEMICOLON
	| Statement_Assert SEMICOLON
	| EXPECTERROR LPAREN Expression_Constant RPAREN /*12P*/ Script_Block_Element
	;

Annotation_List :
	Annotation_List COMMA Annotation
	| Annotation
	;

Annotation :
	HANDLE IDENTIFIER LPAREN QuotedString RPAREN /*12P*/
	| HANDLE IDENTIFIER LPAREN NUMBER RPAREN /*12P*/
	| HANDLE IDENTIFIER LPAREN LONGNUMBER RPAREN /*12P*/
	| HANDLE IDENTIFIER LPAREN MINUS /*7L*/ NUMBER RPAREN /*12P*/
	| HANDLE IDENTIFIER LPAREN MINUS /*7L*/ LONGNUMBER RPAREN /*12P*/
	| HANDLE IDENTIFIER LPAREN RPAREN /*12P*/
	;

Block_Statement :
	Statement
	;

Statement :
	Data SEMICOLON
	| DataTypeDef SEMICOLON
	| DataEnum SEMICOLON
	| Using SEMICOLON
	| Statement_Expression SEMICOLON
	| Statement_Block
	| Statement_If
	| Statement_Switch
	| Statement_For
	| Annotated_Loop
	| Statement_While
	| Statement_Do
	| Statement_Repeat
	| Statement_Return SEMICOLON
	| BREAK SEMICOLON
	| BREAK NUMBER SEMICOLON
	| CONTINUE SEMICOLON
	| CONTINUE NUMBER SEMICOLON
	| SEMICOLON
	| Statement_CompileError SEMICOLON
	| Statement_Assert SEMICOLON
	;

Statement_NoSemicolon :
	Data
	| DataTypeDef
	| DataEnum
	| Statement_Expression
	| Statement_Block
	| Statement_If
	| Statement_Switch
	| Statement_For
	| Annotated_Loop
	| Statement_While
	| Statement_Do
	| Statement_Return
	| BREAK
	| BREAK NUMBER
	| CONTINUE
	| CONTINUE NUMBER
	| /*empty*/
	| Statement_CompileError
	;

Statement_Block :
	LBRACE Statement_Block_List RBRACE
	| LBRACE RBRACE
	;

Statement_Block_List :
	Statement_Block_List Statement
	| Statement_Block_List Option
	| Statement
	| Option
	;

Statement_If :
	IF If_Body
	| UNLESS If_Body
	;

If_Body :
	LPAREN Single_Data_req_assign RPAREN /*12P*/ Block_Statement
	| LPAREN Single_Data_req_assign RPAREN /*12P*/ Block_Statement ELSE /*13P*/ Block_Statement
	| LPAREN Expression RPAREN /*12P*/ Block_Statement
	| LPAREN Expression RPAREN /*12P*/ Block_Statement ELSE /*13P*/ Block_Statement
	;

Statement_Switch :
	SWITCH LPAREN Expression RPAREN /*12P*/ LBRACE Statement_Switch_Body RBRACE
	;

Statement_Switch_Body :
	Statement_Switch_Body Statement_Switch_Cases Statement_Block_List
	| Statement_Switch_Cases Statement_Block_List
	;

Statement_Switch_Cases :
	Statement_Switch_Cases CASE Expression_Constant COLON
	| Statement_Switch_Cases DEFAULT COLON
	| Statement_Switch_Cases CASE Expression_Const_Range COLON
	| Statement_Switch_Cases CASE CASESTRING COLON
	| CASE Expression_Constant COLON
	| CASE Expression_Const_Range COLON
	| CASE CASESTRING COLON
	| DEFAULT COLON
	;

Statement_For :
	Statement_For_Standard
	| Statement_For_Each
	;

Statement_CommaList :
	Statement_CommaList COMMA Statement_NoSemicolon
	| Statement_NoSemicolon
	;

Statement_For_Standard :
	FOR LPAREN Statement_NoSemicolon SEMICOLON Expression SEMICOLON Statement_CommaList RPAREN /*12P*/ Block_Statement
	| FOR LPAREN Statement_NoSemicolon SEMICOLON Expression SEMICOLON Statement_CommaList RPAREN /*12P*/ Block_Statement ELSE /*13P*/ Block_Statement
	;

Statement_For_Each :
	FOR LPAREN Identifier Token_In Expression RPAREN /*12P*/ Block_Statement
	| FOR LPAREN Identifier Token_In Expression RPAREN /*12P*/ Block_Statement ELSE /*13P*/ Block_Statement
	;

Annotated_Loop :
	Annotation_List Statement_Loop
	| Statement_Loop
	;

Statement_Loop :
	Statement_Loop_Inf
	| Statement_Loop_Range
	;

Statement_Loop_Inf :
	LOOP LPAREN RPAREN /*12P*/ Block_Statement
	;

Statement_Loop_Range :
	Statement_Loop_Range_Base ELSE /*13P*/ Block_Statement
	| Statement_Loop_Range_Base
	;

Statement_Loop_Range_Base :
	LOOP LPAREN DataType IDENTIFIER Token_In Expression_Range COMMA Expression RPAREN /*12P*/ Block_Statement
	| LOOP LPAREN IDENTIFIER Token_In Expression_Range COMMA Expression RPAREN /*12P*/ Block_Statement
	| LOOP LPAREN Expression_Range COMMA Expression RPAREN /*12P*/ Block_Statement
	| LOOP LPAREN DataType IDENTIFIER Token_In Expression_Range RPAREN /*12P*/ Block_Statement
	| LOOP LPAREN IDENTIFIER Token_In Expression_Range RPAREN /*12P*/ Block_Statement
	| LOOP LPAREN Expression_Range RPAREN /*12P*/ Block_Statement
	;

Token_In :
	COLON
	| IN
	;

Statement_While :
	WHILE LPAREN Expression RPAREN /*12P*/ Block_Statement
	| WHILE LPAREN Expression RPAREN /*12P*/ Block_Statement ELSE /*13P*/ Block_Statement
	| UNTIL LPAREN Expression RPAREN /*12P*/ Block_Statement
	| UNTIL LPAREN Expression RPAREN /*12P*/ Block_Statement ELSE /*13P*/ Block_Statement
	;

Statement_Do :
	DO Block_Statement WHILE LPAREN Expression RPAREN /*12P*/
	| DO Block_Statement WHILE LPAREN Expression RPAREN /*12P*/ ELSE /*13P*/ Block_Statement
	| DO Block_Statement UNTIL LPAREN Expression RPAREN /*12P*/
	| DO Block_Statement UNTIL LPAREN Expression RPAREN /*12P*/ ELSE /*13P*/ Block_Statement
	;

Statement_Repeat :
	REPEAT LPAREN Expression_Constant RPAREN /*12P*/ Statement
	;

Statement_Return :
	RETURN Expression
	| RETURN
	;

Statement_CompileError :
	EXPECTERROR LPAREN Expression_Constant RPAREN /*12P*/ Statement_NoSemicolon
	;

DataEnum :
	ENUM LBRACE Enum_Block RBRACE
	| ENUM ASSIGN DataType LBRACE Enum_Block RBRACE
	;

Enum_Block :
	Enum_Block COMMA Data_Element
	| Data_Element
	;

ScopeRes :
	SCOPERES
	;

Identifier_List :
	Mixed_Identifier_List
	| idlist_scopres
	| idlist_dot
	| Ambigious_Iden_List
	;

Scoperes_Identifier_List :
	idlist_scopres
	| Ambigious_Iden_List
	;

Mixed_Identifier_List :
	Mixed_Identifier_List DOT Identifier
	| idlist_scopres DOT Identifier
	| Mixed_Identifier_List ScopeRes Identifier
	| idlist_dot ScopeRes Identifier
	;

idlist_scopres :
	idlist_scopres ScopeRes Identifier
	| Ambigious_Iden_List ScopeRes Identifier
	| ScopeRes Ambigious_Iden_List
	;

idlist_dot :
	idlist_dot DOT Identifier
	| Ambigious_Iden_List DOT Identifier
	;

Ambigious_Iden_List :
	Identifier
	;

Identifier :
	IDENTIFIER
	;

Func_Left :
	Expr_Arrow
	| Identifier_List
	;

Function_Call :
	NEW /*1L*/ Identifier_List LPAREN RPAREN /*12P*/
	| NEW /*1L*/ Identifier_List LPAREN Function_Call_Parameters RPAREN /*12P*/
	| Func_Left LPAREN RPAREN /*12P*/
	| Func_Left LPAREN Function_Call_Parameters RPAREN /*12P*/
	;

Function_Call_Parameters :
	Function_Call_Parameters COMMA Expression
	| Expression
	;

Expr_1 :
	Identifier_List
	| Literal
	| LPAREN Expression RPAREN /*12P*/
	;

Expr_2 :
	Expr_1
	| LT /*9L*/ DataType GT /*9L*/ Expr_2
	;

Expr_Arrow :
	Expr_3 ARROW IDENTIFIER
	;

Expr_3 :
	Expr_2
	| Expr_3 INCREMENT /*3L*/
	| Expr_3 DECREMENT /*3L*/
	| Function_Call
	| Expr_3 LBRACKET Expression RBRACKET
	| Expr_Arrow
	;

Expr_4 :
	Expr_3
	| INCREMENT /*3L*/ Expr_4
	| DECREMENT /*3L*/ Expr_4
	| MINUS /*7L*/ Expr_4
	| NOT /*4L*/ Expr_4
	| BITNOT /*4L*/ Expr_4
	;

Expr_5 :
	Expr_4
	| Expr_5 EXPN /*5L*/ Expr_4
	;

Expr_6 :
	Expr_5
	| Expr_6 TIMES /*6L*/ Expr_5
	| Expr_6 DIVIDE /*6L*/ Expr_5
	| Expr_6 MODULO /*6L*/ Expr_5
	;

Expr_7 :
	Expr_6
	| Expr_7 PLUS /*7L*/ Expr_6
	| Expr_7 MINUS /*7L*/ Expr_6
	;

Expr_8 :
	Expr_7
	| Expr_8 LSHIFT /*8L*/ Expr_7
	| Expr_8 RSHIFT /*8L*/ Expr_7
	;

Expr_9 :
	Expr_8
	| Expr_9 LT /*9L*/ Expr_8
	| Expr_9 LE /*9L*/ Expr_8
	| Expr_9 GT /*9L*/ Expr_8
	| Expr_9 GE /*9L*/ Expr_8
	;

Expr_10 :
	Expr_9
	| Expr_10 EQ /*9L*/ Expr_9
	| Expr_10 NE /*9L*/ Expr_9
	| Expr_10 APPXEQUAL Expr_9
	| Expr_10 XOR /*11L*/ Expr_9
	;

Expr_11 :
	Expr_10
	| Expr_11 BITAND /*10L*/ Expr_10
	;

Expr_12 :
	Expr_11
	| Expr_12 BITXOR /*10L*/ Expr_11
	;

Expr_13 :
	Expr_12
	| Expr_13 BITOR /*10L*/ Expr_12
	;

Expr_14 :
	Expr_13
	| Expr_14 AND /*11L*/ Expr_13
	;

Expr_15 :
	Expr_14
	| Expr_15 OR /*11L*/ Expr_14
	;

Expr_16 :
	Expr_15
	| Expr_15 QMARK Expr_16 COLON Expr_16
	;

Expr_17 :
	Expr_16
	| DELETE /*2L*/ Expr_17
	;

Expr_18 :
	Expr_17
	| Expr_17 ASSIGN Expr_18
	| Expr_17 PLUSASSIGN Expr_18
	| Expr_17 MINUSASSIGN Expr_18
	| Expr_17 TIMESASSIGN Expr_18
	| Expr_17 DIVIDEASSIGN Expr_18
	| Expr_17 MODULOASSIGN Expr_18
	| Expr_17 LSHIFTASSIGN Expr_18
	| Expr_17 RSHIFTASSIGN Expr_18
	| Expr_17 BITANDASSIGN Expr_18
	| Expr_17 BITNOTASSIGN Expr_18
	| Expr_17 BITXORASSIGN Expr_18
	| Expr_17 BITORASSIGN Expr_18
	| Expr_17 ANDASSIGN Expr_18
	| Expr_17 ORASSIGN Expr_18
	;

Expression :
	Expr_18
	;

Statement_Expression :
	Expression
	;

Expression_Constant :
	Expression
	;

Expression_Const_Range :
	Expression_Range
	;

Expression_Range :
	Expression RANGE Expression
	| Expression RANGE_LR Expression
	| Expression RANGE_L Expression
	| Expression RANGE_R Expression
	| Expression RANGE_N Expression
	| LBRACKET Expression COMMA Expression RBRACKET
	| LBRACKET Expression COMMA Expression RPAREN /*12P*/
	| LPAREN Expression COMMA Expression RBRACKET
	| LPAREN Expression COMMA Expression RPAREN /*12P*/
	;

Literal :
	NUMBER
	| LONGNUMBER
	| SINGLECHAR
	| Literal_String
	| Literal_Bool
	| Literal_Array
	| OPTIONVALUE LPAREN IDENTIFIER RPAREN /*12P*/
	| ISINCLUDED LPAREN IMPORTSTRING RPAREN /*12P*/
	;

QuotedString :
	QuotedString QUOTEDSTRING
	| QUOTEDSTRING
	;

Literal_String :
	QuotedString
	;

Literal_Bool :
	ZTRUE
	| ZFALSE
	;

Literal_Array :
	LT /*9L*/ DataType LBRACKET Expression_Constant RBRACKET GT /*9L*/ LBRACE Literal_Array_Body RBRACE
	| LT /*9L*/ DataType LBRACKET Expression_Constant RBRACKET GT /*9L*/ LBRACE RBRACE
	| LBRACE Literal_Array_Body RBRACE
	;

Literal_Array_Body :
	Literal_Array_Body COMMA Expression
	| Expression
	;

%%
/*
%x COMMENT
%x BLOCK_COMMENT
%x STRING
%x IMPORTING
%x IMPORTSTR
%s HASH
*/

%%

 /* Keywords */
script		SCRIPT
class		ZCLASS
for		FOR
loop		LOOP
if		IF
else		ELSE
switch		SWITCH
case		CASE //special_state = st_case;
default		DEFAULT
return		RETURN
import		IMPORT //BEGIN( IMPORTING //Handle the string following 'import' specially
true		ZTRUE
false		ZFALSE
while		WHILE
break		BREAK
continue	CONTINUE
const		ZCONST
do		DO
typedef		TYPEDEF

catch			EXPECTERROR
OPTION_VALUE	OPTIONVALUE
IS_INCLUDED		ISINCLUDED
enum			ENUM
namespace		NAMESPACE
using			USING
always			ALWAYS
//asm				ZASM
//zasm			ZASM
until			UNTIL
unless			UNLESS
repeat			REPEAT
inline			INLINE
internal		INTERNAL
static			STATIC
constexpr			CONSTEXPR
new			NEW
delete			DELETE
CONST_ASSERT	CASSERT

 /* Types */
auto		ZAUTO
void		ZVOID
untyped		UNTYPED
bool		ZBOOL
float		ZFLOAT
int		ZFLOAT
char32		ZCHAR
long		ZLONG
rgb			ZRGB
//"try"		TRY  //zconsole_error("%s","The 'try' keyword is reserved and may not be used as an identifier.");

 /* Syntax */
","		COMMA
"."		DOT
";"		SEMICOLON
"::"		SCOPERES
":"		COLON //if(special_state == st_case) special_state = st_none;
"in"	IN
"("		LPAREN
")"		RPAREN
"[]"		EMPTYBRACKETS
"["		LBRACKET
"]"		RBRACKET
"{"		LBRACE
"}"		RBRACE
"?"		QMARK //for ternary

"#".*\n		skip() //HASH //BEGIN( HASH //Handle the string following 'import' specially
INCLUDE	INCLUDE
INCLUDEIF	INCLUDEIF
INCLUDEPATH	INCLUDEPATH
INHERIT	INHERIT
OPTION	OPTION

 /* Operators (in order of operations) */
"->"		ARROW
"++"		INCREMENT
"--"		DECREMENT
"!"		NOT
not		NOT
"~"		BITNOT
compl		BITNOT
bitnot		BITNOT
"*"		TIMES
"/"		DIVIDE
"%"		MODULO
"+"		PLUS
"-"		MINUS
"<<"		LSHIFT
">>"		RSHIFT
"<"		LT
"<="		LE
">"		GT
">="		GE
"=="		EQ
"equals"	EQ
"!="		NE
not_eq		NE
"<>"		NE
not_equal	NE
"&"		BITAND
bitand		BITAND
"^"		BITXOR
bitxor		BITXOR
"|"		BITOR
bitor		BITOR
"&&"		AND
and		AND
"||"		OR
or		OR
"="		ASSIGN
":="		ASSIGN
"+="		PLUSASSIGN
"-="		MINUSASSIGN
"*="		TIMESASSIGN
"/="		DIVIDEASSIGN
"%="		MODULOASSIGN
"<<="		LSHIFTASSIGN
">>="		RSHIFTASSIGN
"&="		BITANDASSIGN
and_eq		BITANDASSIGN
and_equal	BITANDASSIGN
"^="		BITXORASSIGN
xor_eq		BITXORASSIGN
xor_equal	BITXORASSIGN
"|="		BITORASSIGN
or_eq		BITORASSIGN
or_equal	BITORASSIGN
"&&="		ANDASSIGN
"||="		ORASSIGN
"^^"		XOR
"xor"		XOR
"=..="		RANGE_LR
"=.."		RANGE_L
"..="		RANGE_R
".."		RANGE_N
"..."		RANGE
"~~"		APPXEQUAL
appx_eq		APPXEQUAL
appx_equal	APPXEQUAL
//"!!"		DOUBLEBANG
//"%%"		PERCENT
"~="		BITNOTASSIGN
"bitnot_eq"	BITNOTASSIGN
"bitnot_equal"	BITNOTASSIGN
//"!%"		INVMOD
//"$$"		DOUBLEADDR
//"**"		DOUBLESTAR
"@"		HANDLE
//"@@"		HANDLETOHANDLE
//"$"		ADDR
"^^^"		EXPN
 /*	cast	CAST	*/
 /*	static_cast		CAST	*/
 /* "*"+IDENTIFIER how do we segregate from multiply? */
 /* "&"+IDENTIFIER how do we segregate from bitand? */
 /* these would need to see if they are LH values. */
 /* https://stackoverflow.com/questions/23529298/how-to-make-bison-to-use-a-rule-if-two-rules-matches */
 /* "**" pointer/poiters */

 /* Line Comments */
"//".*		skip() /* hit end of file */
//"//".*\n	NEWLINE

 /* Block Comments */
"/*"(?s:.)*?"*/"	skip()

 /* Strings */
 \"(\\.|[^"\r\n\\])*\"	QUOTEDSTRING
 CASESTRING	CASESTRING
 IMPORTSTRING	IMPORTSTRING


 /* Identifier */
[_a-zA-Z][_a-zA-Z0-9]*	IDENTIFIER

 /* Numbers */
[0-9]*\.?[0-9]+ 	NUMBER //VALUE( NUMBER, ASTFloat(yytext, ASTFloat::TYPE_DECIMAL, yylloc) );
[0-9]+L 	LONGNUMBER //VALUE( LONGNUMBER, ASTFloat(yytext, ASTFloat::TYPE_L_DECIMAL, yylloc) );
0x[0-9a-fA-F]+	NUMBER //VALUE( NUMBER, ASTFloat(yytext, ASTFloat::TYPE_HEX, yylloc) );
0x[0-9a-fA-F]+L	LONGNUMBER //VALUE( LONGNUMBER, ASTFloat(yytext, ASTFloat::TYPE_L_HEX, yylloc) );
[0-1]+b	NUMBER //VALUE( NUMBER, ASTFloat(yytext, ASTFloat::TYPE_BINARY, yylloc) );
[0-1]+Lb	LONGNUMBER //VALUE( LONGNUMBER, ASTFloat(yytext, ASTFloat::TYPE_L_BINARY, yylloc) );
[0-1]+bL	LONGNUMBER //VALUE( LONGNUMBER, ASTFloat(yytext, ASTFloat::TYPE_L_BINARY, yylloc) );
0b[0-1]+	NUMBER //VALUE( NUMBER, ASTFloat(yytext, ASTFloat::TYPE_BINARY_2, yylloc) );
0b[0-1]+L	LONGNUMBER //VALUE( LONGNUMBER, ASTFloat(yytext, ASTFloat::TYPE_L_BINARY_2, yylloc) );
[0-7]+o	NUMBER //ALUE( NUMBER, ASTFloat(yytext, ASTFloat::TYPE_OCTAL, yylloc) );
[0-7]+oL	LONGNUMBER //VALUE( LONGNUMBER, ASTFloat(yytext, ASTFloat::TYPE_L_OCTAL, yylloc) );
[0-7]+Lo	LONGNUMBER //VALUE( LONGNUMBER, ASTFloat(yytext, ASTFloat::TYPE_L_OCTAL, yylloc) );
0o[0-7]+	NUMBER //VALUE( NUMBER, ASTFloat(yytext, ASTFloat::TYPE_OCTAL_2, yylloc) );
0o[0-7]+L	LONGNUMBER //VALUE( LONGNUMBER, ASTFloat(yytext, ASTFloat::TYPE_L_OCTAL_2, yylloc) );

 /* Char */
\'\\x[0-9a-fA-F][0-9a-fA-F]?\'	SINGLECHAR
\'(\\.|[^'\r\n\\])?\'	SINGLECHAR


 /* Whitespace */
[ \t\r]*\n	skip() //NEWLINE
[ \t\r]+	skip() //ADVANCE


%%
