//From: https://github.com/moirai-lang/moirai-kt/blob/9177ca2984084c79494055d321db5abf8360c479/src/main/antlr/MoiraiParser.g4
//parser grammar MoiraiParser;
//options { tokenVocab=MoiraiLexer; }

%token ADD
%token AND
%token ARROW
%token ASSIGN
%token BOOL_FALSE
%token BOOL_TRUE
%token CASE
%token CHAR
%token COLON
%token COMMA
%token COST
%token DECIMAL
%token DEF
%token DIV
%token DOT
%token ELSE
%token EQ
%token FIN
%token FOR
%token GT
%token GTE
%token IDENTIFIER
%token IF
%token IMPORT
%token IN
%token INT
%token LAMBDA
%token LBRACK
%token LCURLY
%token LPAREN
%token LT
%token LTE
%token MATCH
%token MOD
%token MUL
%token MUTABLE
%token NEQ
%token NOT
%token OBJECT
%token OR
%token PLUGIN
%token RBRACK
%token RCURLY
%token RECORD
%token RPAREN
%token SCRIPT
%token SIGNATURE
%token STRING
//%token STRING_CHARS
//%token STRING_END
//%token STRING_INTERP_OPEN
//%token STRING_START
%token SUB
%token TO
%token TRANSIENT
%token VAL

%left OR
%left AND
%nonassoc NOT
%left LT LTE GT GTE EQ NEQ
%right ASSIGN
%left ADD SUB
%left MUL DIV MOD
%nonassoc UMINUS

%%

file:
	  script_header stat_oom
	;

stat_oom:
	  stat
	| stat_oom stat
	;

script_header:
	  transientScript_opt
	| scriptStat importStat_zom
	;

importStat_zom:
	  %empty
	| importStat_zom importStat
	;

transientScript_opt:
	  %empty
	| transientScript
	;

transientScript:
	  TRANSIENT SCRIPT importIdSeq
	;

scriptStat:
	  SCRIPT importIdSeq
	;

importStat:
	  IMPORT importIdSeq
	;

importIdSeq:
	  IDENTIFIER
	| importIdSeq DOT IDENTIFIER
	;

stat:
	  letStat
	| forStat
	| funDefStat
	| pluginFunDefStat
	| objectDefStat
	| recordDefStat
	| assignStat
	| expr
	;

assignStat:
	  expr ASSIGN expr
	;

block:
	  LCURLY stat_zom RCURLY
	;

stat_zom:
	  %empty
	| stat_zom stat
	;

letStat:
	  VAL IDENTIFIER ofType_opt ASSIGN expr	#ImmutableLet
	| MUTABLE IDENTIFIER ofType_opt ASSIGN expr	#MutableLet
	;

ofType_opt:
	  %empty
	| ofType
	;

forStat:
	  FOR LPAREN IDENTIFIER ofType_opt IN expr RPAREN block	#LongForStat
	| FOR LPAREN expr RPAREN block	#ShortForStat
	;

funDefStat:
	  DEF IDENTIFIER typeParams_opt LPAREN paramSeq_opt RPAREN restrictedOfType_opt block
	;

restrictedOfType_opt:
	  %empty
	| restrictedOfType
	;

paramSeq_opt:
	  %empty
	| paramSeq
	;

typeParams_opt:
	  %empty
	| typeParams
	;

typeParams:
	  LT typeParam COMMA_typeParam_oom GT
	;

COMMA_typeParam_oom:
	  %empty
	| COMMA_typeParam_oom COMMA typeParam
	;

typeParam:
	  IDENTIFIER COLON FIN	#FinTypeParam
	| IDENTIFIER	#IdentifierTypeParam
	;

paramDef:
	  IDENTIFIER ofType
	;

restrictedParamDef:
	  IDENTIFIER restrictedOfType
	;

paramSeq:
	  paramDef
	| paramSeq COMMA paramDef
	;

restrictedParamSeq:
	  restrictedParamDef
	| restrictedParamSeq COMMA restrictedParamDef
	;

objectDefStat:
	  OBJECT IDENTIFIER
	;

recordDefStat:
	  RECORD IDENTIFIER typeParams_opt LPAREN fieldSeq RPAREN
	;

fieldSeq:
	  fieldDef
	| fieldSeq COMMA fieldDef
	;

fieldDef:
	  VAL IDENTIFIER restrictedOfType	#ImmutableField
	| MUTABLE IDENTIFIER restrictedOfType	#MutableField
	;

expr:
	  LPAREN expr RPAREN	#ParenExpr
	| LCURLY stat_zom RCURLY	#BlockExpr
	| expr DOT IDENTIFIER restrictedTypeExprParams LPAREN exprSeq_opt RPAREN	#ParamDotApply
	| expr DOT IDENTIFIER LPAREN exprSeq_opt RPAREN	#DotApply
	| expr DOT IDENTIFIER	#DotExpr
	| IDENTIFIER restrictedTypeExprParams LPAREN exprSeq_opt RPAREN	#ParamApplyExpr
	| IDENTIFIER LPAREN exprSeq_opt RPAREN	#ApplyExpr
	| expr LBRACK expr RBRACK	#IndexExpr
	| matchExpr	#AnyMatch
	| ifExpr	#AnyIf
	| lambdaDef	#AnyLambda
	| NOT expr	#UnaryNot
	| SUB expr	%prec UMINUS #UnaryNegate
	| expr MUL expr	#InfixMul
	| expr DIV expr	#InfixDiv
	| expr MOD expr	#InfixMod
	| expr ADD expr	#InfixAdd
	| expr SUB expr	#InfixSub
	| expr GT expr	#InfixGT
	| expr GTE expr	#InfixGTE
	| expr LT expr	#InfixLT
	| expr LTE expr	#InfixLTE
	| expr EQ expr	#InfixEQ
	| expr NEQ expr	#InfixNEQ
	| expr AND expr	#InfixAnd
	| expr OR expr	#InfixOr
	| DECIMAL	#LiteralDecimal
	| INT	#LiteralInt
	| BOOL_TRUE	#LiteralTrue
	| BOOL_FALSE	#LiteralFalse
	| CHAR	#LiteralChar
	| string	#StringExpr
	| expr TO expr	#ToExpr
	| IDENTIFIER	#RefExpr
	;

exprSeq_opt:
	  %empty
	| exprSeq
	;

matchExpr:
	  MATCH LPAREN IDENTIFIER IN expr RPAREN LCURLY caseStats RCURLY	#LongMatchExpr
	| MATCH LPAREN expr RPAREN LCURLY caseStats RCURLY	#ShortMatchExpr
	;

caseStats:
	  caseStat
	| caseStats caseStat
	;

caseStat:
	  CASE IDENTIFIER LCURLY stat_zom RCURLY
	;

ifExpr:
	  IF LPAREN expr RPAREN block ELSE ifExpr	#IfElseIfExpr
	| IF LPAREN expr RPAREN block ELSE block	#IfElseExpr
	| IF LPAREN expr RPAREN block	#StandaloneIfExpr
	;

lambdaDef:
	  LAMBDA LPAREN restrictedParamSeq_opt RPAREN ARROW expr
	;

restrictedParamSeq_opt:
	  %empty
	| restrictedParamSeq
	;

string:
	  STRING
	;

exprSeq:
	  expr
	| exprSeq COMMA expr
	;

ofType:
	  COLON typeExpr
	;

typeExpr:
	  funTypeExpr	#FunType
	| IDENTIFIER restrictedTypeExprParams	#ParameterizedType
	| IDENTIFIER	#GroundType
	;

funTypeExpr:
	  LPAREN restrictedTypeExprSeq RPAREN ARROW restrictedTypeExpr	#MultiParamFunctionType
	| LPAREN RPAREN ARROW restrictedTypeExpr	#NoParamFunctionType
	| restrictedTypeExpr ARROW restrictedTypeExpr	#OneParamFunctionType
	;

restrictedOfType:
	  COLON restrictedTypeExpr
	;

restrictedTypeExpr:
	  IDENTIFIER restrictedTypeExprParams	#RestrictedParameterizedType
	| IDENTIFIER	#RestrictedGroundType
	;

restrictedTypeExprParams:
	  LT restrictedTypeExprOrCostExpr COMMA_restrictedTypeExprOrCostExpr_zom GT
	;

COMMA_restrictedTypeExprOrCostExpr_zom:
	  %empty
	| COMMA_restrictedTypeExprOrCostExpr_zom COMMA restrictedTypeExprOrCostExpr
	;

restrictedTypeExprOrCostExpr:
	  costExpr
	| restrictedTypeExpr
	;

restrictedTypeExprSeq:
	  restrictedTypeExpr
	| restrictedTypeExprSeq  COMMA restrictedTypeExpr
	;

pluginFunDefStat:
	  PLUGIN DEF IDENTIFIER typeParams_opt LCURLY SIGNATURE funTypeExpr COST costExpr RCURLY
	;

costExpr:
	  IDENTIFIER LPAREN costExprSeq_opt RPAREN	#CostApply
	| IDENTIFIER LPAREN string RPAREN	#CostNamed
	| INT	#CostMag
	| IDENTIFIER	#CostIdent
	;

costExprSeq_opt:
	  %empty
	| costExprSeq
	;

costExprSeq:
	  costExpr
	| costExprSeq COMMA costExpr
	;

%%

//%x STRING_COMPONENT

LETTER	[a-zA-Z]
UNDERSCORE	"_"
LETTER_OR_UNDERSCORE	{LETTER}|{UNDERSCORE}

HEX_DIGIT	[0-9a-fA-F]
NON_ZERO_DIGIT	[1-9]
DIGIT	"0"|{NON_ZERO_DIGIT}
DOT	"."

SIGNED_INTEGER	[+\-]?{DIGIT}+
FRACTION_PART	{DIGIT}*
INTEGER_PART	{DIGIT}+

EXPONENT_INDICATOR	[eE]
EXPONENT	{EXPONENT_INDICATOR}{SIGNED_INTEGER}?
SIGNIFICAND {INTEGER_PART}{DOT}{FRACTION_PART}?
NON_LEADING_ZERO_INT	{NON_ZERO_DIGIT}{DIGIT}*

LETTER_OR_UNDERSCORE_OR_DIGIT	{LETTER_OR_UNDERSCORE}|{DIGIT}

ESCAPE_SEQUENCE	"\\"[btnfr"'\\$]|"\\u"{HEX_DIGIT}{4}

%%

//lexer grammar MoiraiLexer;

[ \t\n\r]+	skip()

"+"	ADD
"-"	SUB
"*"	MUL
"/"	DIV
"%"	MOD
"!"	NOT
">"	GT
">="	GTE
"<"	LT
"<="	LTE
"=="	EQ
"!="	NEQ
"&&"	AND
"||"	OR

"("	LPAREN
")"	RPAREN
"{"	LCURLY //: '{' -> pushMode(DEFAULT_MODE);
"}"	RCURLY //: '}' -> popMode;
"["	LBRACK
"]"	RBRACK

"true"	BOOL_TRUE
"false"	BOOL_FALSE

"Fin"	FIN

"case"	CASE
"def"	DEF
"else"	ELSE
"for"	FOR
"if"	IF
"import"	IMPORT
"in"	IN
"lambda"	LAMBDA
"match"	MATCH
"mutable"	MUTABLE
"object"	OBJECT
"record"	RECORD
"script"	SCRIPT
"to"	TO
//"type"	TYPE
"transient"	TRANSIENT
"val"	VAL
//"variant"	VARIANT

"cost"	COST
"plugin"	PLUGIN
"signature"	SIGNATURE

"="	ASSIGN
{DOT}	DOT
":"	COLON
","	COMMA
"->"	ARROW
//"#"	POUND

"0"|{NON_LEADING_ZERO_INT}	INT

{SIGNIFICAND}{EXPONENT}?	DECIMAL

{LETTER_OR_UNDERSCORE}{LETTER_OR_UNDERSCORE_OR_DIGIT}*	IDENTIFIER

'([^"'\\\r\n$]|{ESCAPE_SEQUENCE})'	CHAR

\"([^"\\\r\n$]|{ESCAPE_SEQUENCE})*\"	STRING

/*
\"<>STRING_COMPONENT>	STRING_START

<STRING_COMPONENT>{
	\"<<>	STRING_END
	([^"\\\r\n$]|{ESCAPE_SEQUENCE})+	STRING_CHARS
	"${"<>DEFAULT_MODE>	STRING_INTERP_OPEN
}
*/

%%
