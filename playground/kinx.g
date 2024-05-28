//From: https://github.com/Kray-G/kinx/blob/5f80f6e9f53c3bde8bf1532eadc99128531d09e4/src/kinx.y

/*Tokens*/
%token ADDEQ
%token ANDEQ
%token AS
%token BIGINT
%token BINEND
%token BREAK
%token CASE
%token CATCH
%token CLASS
%token CONST
%token CONTINUE
%token COROUTINE
%token DARROW
%token DBL
%token DEC
%token DEFAULT
%token DIVEQ
%token DO
%token DOTS2
%token DOTS3
%token ELSE
%token ENUM
%token EQEQ
%token FALLTHROUGH
%token FALSE
%token FCOMPOSL2R
%token FCOMPOSR2L
%token FINALLY
%token FOR
%token FUNCTION
%token GE
%token IF
%token IMPORT
%token IN
%token INC
%token INT
%token LAND
%token LANDEQ
%token LBBR
%token LE
%token LGE
%token LMBR
%token LOR
%token LOREQ
%token LUNDEF
%token LUNDEFEQ
%token MIXIN
%token MODEQ
%token MODULE
%token MULEQ
%token NAME
%token NAMESPACE
%token NATIVE
%token NEQ
%token NEW
%token NUL
%token OREQ
%token OTHERWISE
%token PIPEOPL2R
%token PIPEOPR2L
%token POW
%token PRIVATE
%token PROTECTED
%token PUBLIC
%token RBBR
%token REGEQ
%token REGNE
%token REGPF
%token RETURN
%token RMBR
%token SHL
%token SHLEQ
%token SHR
%token SHREQ
%token SRCFILE
%token STR
%token SUBEQ
%token SWITCH
%token SYSCLASS
%token SYSFUNC
%token SYSMODULE
%token SYSNS
%token SYSRET_NV
%token THROW
%token TRUE
%token TRY
%token TYPE
%token TYPEOF
%token USING
%token VAR
%token WHEN
%token WHILE
%token XOREQ
%token YIELD

%nonassoc /*1*/ IF_WITHOUT_ELSE
%nonassoc /*2*/ ELSE OTHERWISE
%nonassoc '=' SHLEQ SHREQ ADDEQ SUBEQ MULEQ DIVEQ MODEQ ANDEQ OREQ XOREQ LANDEQ LOREQ LUNDEFEQ
%precedence SHIFT_HERE
%right UMINUS

%start Program

%%

Program :
	ToplevelStatementList
	;

ToplevelStatementList :
	Statement
	| ToplevelStatementList Statement
	;

StatementList :
	Statement
	| StatementList Statement
	;

Statement :
	NonSemicolonStatement
	| SemicolonStatement
	;

NonSemicolonStatement :
	BlockStatement
	| NamespaceStatement
	| EnumStatement
	| IfStatement
	| TryCatchStatement
	| LabelStatement
	| LabelledStatement
	| IMPORT VAR NAME '=' String ';'
	| USING NameDoted ';'
	//| error RBBR
	;

NameDoted :
    NAME
    | NameDoted '.' NAME
    ;

SemicolonStatement :
	ReturnStatement
	| YieldStatement
	| ThrowStatement
	| MixinStatement
	| ExpressionStatement
	| DefinitionStatement
	| BreakStatement
	//| error ';'
	//| error LBBR
	//| error IF
	//| error DO
	//| error WHILE
	//| error FOR
	//| error TRY
	//| error SWITCH
	//| error CASE
	//| error ENUM
	//| error CLASS
	//| error FUNCTION
	//| error PRIVATE
	//| error PUBLIC
	;

LabelledStatement :
	WhileStatement
	| DoWhileStatement
	| SwitchCaseStatement
	| ForStatement
	;

BlockStatement :
	LBBR RBBR
	| LBBR StatementList RBBR
	;

NamespaceStatement :
	NAMESPACE NamespaceName LBBR RBBR
	| SYSNS NamespaceName LBBR RBBR
	| NAMESPACE NamespaceName LBBR StatementList RBBR
	| SYSNS NamespaceName LBBR StatementList RBBR
	;

NamespaceName :
	NAME
	;

EnumStatement :
	ENUM LBBR EnumList Comma_Opt RBBR
	;

EnumList :
	NAME
	| NAME '=' INT
	| NAME '=' '-' INT
	| EnumList ',' NAME
	| EnumList ',' NAME '=' INT
	| EnumList ',' NAME '=' '-' INT
	;

DefinitionStatement :
	VarDeclStatement
	| FunctionDeclStatement
	| ClassDeclStatement
	| ModuleDeclStatement
	;

LabelStatement :
	NAME ':' LabelledStatement
	| NAME ':' ':' LabelledStatement
	| NAME ':' ':' BlockStatement
	;

IfStatement :
	IF '(' AssignExpressionList ')' Statement %prec IF_WITHOUT_ELSE
	| IF '(' AssignExpressionList ')' Statement ELSE Statement
	;

WhileStatement :
	WHILE '(' AssignExpressionList ')' Statement
	;

DoWhileStatement :
	DO Statement WHILE '(' AssignExpressionList ')' ';'
	;

SwitchCaseStatement :
	SWITCH '(' AssignExpressionList ')' BlockStatement
	| CaseStatement
	;

CaseStatement :
	CASE AssignExpression ':'
	| DEFAULT ':'
	| WHEN AssignExpression ':'
	| ELSE ':'
	| OTHERWISE ':'
	;

ForStatement :
	FOR '(' VAR DeclAssignExpressionList ';' AssignExpressionList_Opt ';' AssignExpressionList_Opt ')' Statement
	| FOR '(' AssignExpressionList ';' AssignExpressionList_Opt ';' AssignExpressionList_Opt ')' Statement
	| FOR '(' ';' AssignExpressionList_Opt ';' AssignExpressionList_Opt ')' Statement
	| FOR '(' VarName IN AssignExpressionList ')' Statement
	| FOR '(' VAR VarName IN AssignExpressionList ')' Statement
	| FOR '(' ForInVariable IN AssignExpressionList ')' Statement
	| FOR '(' VAR ForInVariable IN AssignExpressionList ')' Statement
	;

ForInVariable :
	Array
	| Object
	;

TryCatchStatement :
	TRY BlockStatement CatchStatement_Opt FinallyStatement_Opt
	;

CatchStatement_Opt :
	/*empty*/
	| CATCH CatchVariable BlockStatement
	;

CatchVariable :
	/*empty*/
	| '(' NAME ')'
	;

FinallyStatement_Opt :
	/*empty*/
	| FINALLY BlockStatement
	;

BreakStatement :
	BREAK Modifier_Opt ';'
	| BREAK NAME Modifier_Opt ';'
	| CONTINUE Modifier_Opt ';'
	| CONTINUE NAME Modifier_Opt ';'
	| FALLTHROUGH ';'
	;

ReturnStatement :
	RETURN GetLineNumber AssignExpressionList_Opt Modifier_Opt ';'
	| SYSRET_NV ';'
	;

YieldStatement :
	YieldExpression Modifier_Opt ';'
	;

YieldExpression :
	YIELD AssignExpression
	| YIELD
	| AssignExpression '=' YIELD AssignExpression
	| AssignExpression '=' YIELD
	;

ThrowStatement :
	THROW AssignExpressionList_Opt Modifier_Opt ';'
	;

MixinStatement :
	MIXIN MixinModuleList ';'
	;

MixinModuleList :
	NAME
	| MixinModuleList ',' NAME
	;

ExpressionStatement :
	AssignExpression_Opt ';'
	;

AssignExpression_Opt :
	/*empty*/
	| AssignExpression Modifier_Opt
	;

AssignExpressionList_Opt :
	/*empty*/
	| AssignExpressionObjList
	;

Modifier_Opt :
	/*empty*/
	| Modifier
	;

Modifier :
	IF '(' AssignExpressionList ')'
	;

AssignExpression :
	CaseWhenExpression
	| AssignExpression '=' AssignRightHandSide
	| AssignExpression SHLEQ AssignRightHandSide
	| AssignExpression SHREQ AssignRightHandSide
	| AssignExpression ADDEQ AssignRightHandSide
	| AssignExpression SUBEQ AssignRightHandSide
	| AssignExpression MULEQ AssignRightHandSide
	| AssignExpression DIVEQ AssignRightHandSide
	| AssignExpression MODEQ AssignRightHandSide
	| AssignExpression ANDEQ AssignRightHandSide
	| AssignExpression OREQ AssignRightHandSide
	| AssignExpression XOREQ AssignRightHandSide
	| AssignExpression LANDEQ AssignRightHandSide
	| AssignExpression LOREQ AssignRightHandSide
	| AssignExpression LUNDEFEQ AssignRightHandSide
	;

AssignRightHandSide :
	CaseWhenExpression
	| ObjectSpecialSyntax
	;

ObjectSpecialSyntax :
	LBBR RBBR
	| ObjectSpecialSyntax PostIncDec
	| ObjectSpecialSyntax LMBR AssignExpression RMBR
	| ObjectSpecialSyntax '.' PropertyName
	| ObjectSpecialSyntax '.' TYPEOF
	| ObjectSpecialSyntax '(' CallArgumentList_Opts ')'
	| ObjectSpecialSyntax SimpleFuncCallFactor
	;

CaseWhenExpression :
	TernaryExpression
	| CASE AssignExpression WhenClauseList %prec IF_WITHOUT_ELSE
	| CASE AssignExpression WhenClauseList CaseElseClause
	;

WhenClauseList :
	WhenClause
	| WhenClauseList WhenClause
	;

WhenClause :
	WHEN WhenConditionRangeList ':' WhenClauseBody
	| WHEN WhenConditionRangeList WhenClauseBodyBlock
	| WHEN WhenConditionRangeList Modifier Colon_Opt WhenClauseBody
	;

WhenConditionRangeList :
	WhenConditionRange
	| WhenConditionRangeList '|' WhenConditionRange
	| WhenConditionRangeList LOR WhenConditionRange
	;

WhenConditionRange :
	WhenAnonymousFunctionDeclExpression
	| WhenPostfixExpression
	| '^' WhenPostfixExpression
	| Array
	| Object
	| SimpleFuncCallFactor
	| '.' PropertyName
	| '.' TYPEOF
	| WhenPostfixExpression DOTS2
	| WhenPostfixExpression DOTS2 WhenPostfixExpression
	| WhenPostfixExpression DOTS3
	| WhenPostfixExpression DOTS3 WhenPostfixExpression
	;

WhenAnonymousFunctionDeclExpression :
	FUNCTION '(' ArgumentList_Opts ')' FunctionType_Opt BlockStatement
	| SYSFUNC '(' ArgumentList_Opts ')' FunctionType_Opt BlockStatement
	| COROUTINE '(' ArgumentList_Opts ')' FunctionType_Opt BlockStatement
	| NativeKeyword '(' ArgumentList_Opts ')' NativeType_Opt BlockStatement
	| '&' '(' ArgumentList_Opts ')' FunctionType_Opt DARROW BlockStatement
	| '&' FunctionType_Opt BlockStatement
	;

WhenPostfixExpression :
	WhenCondition
	| WhenPostfixExpression PostIncDec
	| WhenPostfixExpression LMBR AssignExpression RMBR
	| WhenPostfixExpression '.' PropertyName
	| WhenPostfixExpression '.' TYPEOF
	| WhenPostfixExpression '(' CallArgumentList_Opts ')'
	;

WhenCondition :
	VarName
	| '(' AssignExpression ')'
	| INT
	| DBL
	| BIGINT
	| NUL
	| TRUE
	| FALSE
	//| '(' STR ')'
	| String
	| NEW Factor
	;

CaseElseClause :
	ELSE Colon_Opt WhenClauseBody
	| OTHERWISE Colon_Opt WhenClauseBody
	;

WhenClauseBody :
	WhenClauseBodyBlock
	| TernaryExpression
	;

WhenClauseBodyBlock :
	BlockStatement
	;

Colon_Opt :
	/*empty*/
	| ':'
	;

TernaryExpression :
	AnonymousFunctionDeclExpression
	| PipelineExpression
	| PipelineExpression '?' TernaryExpression ':' TernaryExpression
	;

PipelineExpression :
	FunctionCompositionExpression
	| PipelineExpression PIPEOPL2R FunctionCompositionExpression
	| PipelineExpression PIPEOPR2L FunctionCompositionExpression
	;

FunctionCompositionExpression :
	LogicalUndefExpression
	| FunctionCompositionExpression FCOMPOSL2R LogicalUndefExpression
	| FunctionCompositionExpression FCOMPOSR2L LogicalUndefExpression
	;

LogicalUndefExpression :
	LogicalOrExpression
	| LogicalUndefExpression LUNDEF LogicalOrExpression
	;

LogicalOrExpression :
	LogicalAndExpression
	| LogicalOrExpression LOR LogicalAndExpression
	;

LogicalAndExpression :
	BitOrExpression
	| LogicalAndExpression LAND BitOrExpression
	;

BitOrExpression :
	BitXorExpression
	| BitOrExpression '|' BitXorExpression
	;

BitXorExpression :
	BitAndExpression
	| BitXorExpression '^' BitAndExpression
	;

BitAndExpression :
	CompareEqualExpression
	| BitAndExpression '&' CompareEqualExpression
	;

CompareEqualExpression :
	CompareExpression
	| CompareEqualExpression EQEQ CompareExpression
	| CompareEqualExpression NEQ CompareExpression
	;

CompareExpression :
	ShiftExpression
	| CompareExpression '<' ShiftExpression
	| CompareExpression LE ShiftExpression
	| CompareExpression '>' ShiftExpression
	| CompareExpression GE ShiftExpression
	| CompareExpression LGE ShiftExpression
	;

ShiftExpression :
	Expression
	| ShiftExpression SHL Expression
	| ShiftExpression SHR Expression
	;

Expression :
	Term
	| Expression '+' Term
	| Expression '-' Term
	;

Term :
	Exponentiation
	| Term '*' Exponentiation
	| Term '/' Exponentiation
	| Term '%' Exponentiation
	;

Exponentiation :
	RegexMatch
	| Exponentiation POW RegexMatch
	;

RegexMatch :
	PrefixExpression
	| RegexMatch REGEQ PrefixExpression
	| RegexMatch REGNE PrefixExpression
	| PrefixExpression DOTS2 %prec IF_WITHOUT_ELSE
	| PrefixExpression DOTS2 PrefixExpression
	| PrefixExpression DOTS3 %prec IF_WITHOUT_ELSE
	| PrefixExpression DOTS3 PrefixExpression
	;

PrefixExpression :
	CastExpression
	| '~' PrefixExpression
	| '!' PrefixExpression
	| '+' PostfixExpression
	| '-' PostfixExpression
	| '*' PrefixExpression
	| INC PostfixExpression
	| DEC PostfixExpression
	;

CastExpression :
	PostfixExpression
	| PostfixExpression AS TypeName
	;

PostfixExpression :
	Factor
	| PostfixExpression PostIncDec
	| PostfixExpression LMBR AssignExpression RMBR
	| PostfixExpression '.' PropertyName
	| PostfixExpression '.' TYPEOF
	| PostfixExpression '(' CallArgumentList_Opts ')'
	| PostfixExpression SimpleFuncCallFactorOrBlock
	;

SimpleFuncCallFactorOrBlock :
	BlockStatement
	| SimpleFuncCallFactor
	;

SimpleFuncCallFactor :
	LBBR FunctionType_Opt DARROW AssignExpression RBBR
	| LBBR '&' '(' ArgumentList_Opts ')' FunctionType_Opt DARROW AssignExpression RBBR
	| LBBR '&' '(' ArgumentList_Opts ')' FunctionType_Opt StatementList RBBR
	;

PostIncDec :
	INC
	| DEC
	;

Factor :
	INT
	| DBL
	| BIGINT
	| NUL
	| TRUE
	| FALSE
	| SRCFILE
	| VarName
	| Binary
	| Array
	| Object
	| Regex
	| SimpleFuncCallFactor
	//| IMPORT '(' '(' STR ')' ')'
	| IMPORT '(' String ')'
	| '(' AssignExpression ')'
	| '(' ObjectSpecialSyntax ')'
	//| '(' STR ')'
	| String
	| NEW Factor
	| '.' PropertyName
	| '.' TYPEOF
	| '@' PropertyName
	| '@' TYPEOF
	;

String :
    STR
    | String STR
    ;

VarName :
	NAME
	| TYPE
	;

PropertyName :
	NAME
	| TYPE
	| IF
	| ELSE
	| OTHERWISE
	| WHILE
	| DO
	| FOR
	| IN
	| TRY
	| CATCH
	| FINALLY
	| BREAK
	| CONTINUE
	| SWITCH
	| CASE
	| WHEN
	| DEFAULT
	| NEW
	| VAR
	| CONST
	| NATIVE
	| FUNCTION
	| SYSFUNC
	| PUBLIC
	| PRIVATE
	| PROTECTED
	| CLASS
	| MODULE
	| RETURN
	| YIELD
	| THROW
	| NUL
	| TRUE
	| FALSE
	| IMPORT
	| USING
	| PIPEOPL2R
	| POW
	| SHL
	| SHR
	| EQEQ
	| NEQ
	| LE
	| '<'
	| GE
	| '>'
	| LGE
	| '+'
	| '-'
	| '*'
	| '/'
	| '%'
	| '&'
	| '|'
	| '^'
	| LMBR RMBR
	| '(' ')'
	;

Array :
	LMBR RMBR
	| LMBR ArrayItemList RMBR
	;

Binary :
	'<' '>'
	| '<' BinStart ArrayItemList BINEND
	;

BinStart :
	/*empty*/
	;

Object :
	LBBR KeyValueList Comma_Opt RBBR
	;

Comma_Opt :
	/*empty*/
	| ','
	;

ArrayItemList :
	ArrayItemListCore
	| CommaList ArrayItemListCore
	;

CommaList :
	','
	| CommaList ','
	;

ArrayItemListCore :
	AssignExpression
	| '^' AssignExpression
	| DOTS3 AssignRightHandSide
	| ArrayItemListCore ','
	| ArrayItemListCore ',' AssignExpression
	| ArrayItemListCore ',' '^' AssignExpression
	| ArrayItemListCore ',' DOTS3 AssignRightHandSide
	;

AssignExpressionList :
	AssignExpression
	| AssignExpressionList ',' AssignExpression
	;

AssignExpressionObjList :
	AssignExpression
	| LBBR RBBR
	| AssignExpressionObjList ',' AssignExpression
	| AssignExpressionObjList ',' LBBR RBBR
	;

KeyValueList :
	KeyValue
	| KeyValueList ',' KeyValue
	;

KeyValue :
	//'(' STR ')' ':' ValueOfKeyValue
	STR ':' ValueOfKeyValue
	| NAME ':' ValueOfKeyValue
	| KeySpecialName ':' ValueOfKeyValue
	| DOTS3 AssignRightHandSide
	| CastExpression
	;

ValueOfKeyValue :
	AssignExpression
	| '^' AssignExpression
	| ObjectSpecialSyntax
	;

KeySpecialName :
	IF
	| WHILE
	| DO
	| FOR
	| IN
	| TRY
	| CATCH
	| FINALLY
	| BREAK
	| CONTINUE
	| SWITCH
	| CASE
	| WHEN
	| NEW
	| VAR
	| CONST
	| NATIVE
	| FUNCTION
	| SYSFUNC
	| PUBLIC
	| PRIVATE
	| PROTECTED
	| CLASS
	| MODULE
	| RETURN
	| YIELD
	| THROW
	| NUL
	| TRUE
	| FALSE
	| IMPORT
	| USING
	| TYPE
	| TYPEOF
	;

ClassFunctionSpecialName :
	IF
	| ELSE
	| OTHERWISE
	| WHILE
	| DO
	| FOR
	| IN
	| TRY
	| CATCH
	| FINALLY
	| BREAK
	| CONTINUE
	| SWITCH
	| CASE
	| WHEN
	| NEW
	| VAR
	| CONST
	| FUNCTION
	| SYSFUNC
	| PUBLIC
	| PRIVATE
	| PROTECTED
	| CLASS
	| MODULE
	| RETURN
	| YIELD
	| THROW
	| NUL
	| TRUE
	| FALSE
	| IMPORT
	| USING
	| TYPE
	| TYPEOF
	| POW
	| SHL
	| SHR
	| EQEQ
	| NEQ
	| LE
	| '<'
	| GE
	| '>'
	| LGE
	| '+'
	| '-'
	| '*'
	| '/'
	| '%'
	| '&'
	| '|'
	| '^'
	| LMBR RMBR
	| '(' ')'
	;

Regex :
	'/' RegexStart RegexString
	| DIVEQ RegexStart RegexString
	| REGPF RegexString
	;

RegexStart :
	/*empty*/
	;

RegexString :
	//'(' STR ')'
	String
	;

VarDeclStatement :
	VAR DeclAssignExpressionList ';'
	| CONST DeclAssignExpressionList ';'
	;

DeclAssignExpressionList :
	DeclAssignExpression
	| DeclAssignExpressionList ',' DeclAssignExpression
	;

DeclAssignExpression :
	VarName
	| VarName ':' TypeName ReturnType_Opt
	| VarName '=' DeclAssignRightHandSide
	| VarName ':' TypeName ReturnType_Opt '=' DeclAssignRightHandSide
	| Array '=' DeclAssignRightHandSide
	| Object '=' DeclAssignRightHandSide
	;

DeclAssignRightHandSide :
	AssignRightHandSide
	| DeclAssignRightHandSide '=' AssignRightHandSide
	;

FunctionDeclStatement :
	NormalFunctionDeclStatement
	| ClassFunctionDeclStatement
	;

NormalFunctionDeclStatement :
	FUNCTION NAME '(' ArgumentList_Opts ')' FunctionType_Opt BlockStatement
	| SYSFUNC NAME '(' ArgumentList_Opts ')' FunctionType_Opt BlockStatement
	| NativeKeyword NAME '(' ArgumentList_Opts ')' NativeType_Opt BlockStatement
	;

NativeKeyword :
	NATIVE
	;

FunctionType_Opt :
	/*empty*/
	| ':' TypeName
	;

NativeType_Opt :
	/*empty*/
	| ':' TypeName
	;

AnonymousFunctionDeclExpression :
	FUNCTION '(' ArgumentList_Opts ')' FunctionType_Opt BlockStatement
	| SYSFUNC '(' ArgumentList_Opts ')' FunctionType_Opt BlockStatement
	| COROUTINE '(' ArgumentList_Opts ')' FunctionType_Opt BlockStatement
	| NativeKeyword '(' ArgumentList_Opts ')' NativeType_Opt BlockStatement
	| '&' '(' ArgumentList_Opts ')' FunctionType_Opt DARROW AssignExpression %prec SHIFT_HERE
	| '&' '(' ArgumentList_Opts ')' FunctionType_Opt DARROW BlockStatement
	| '&' FunctionType_Opt BlockStatement
	;

ClassFunctionDeclStatement :
	PUBLIC ClassFunctionName '(' ArgumentList_Opts ')' FunctionType_Opt BlockStatement
	| PRIVATE ClassFunctionName '(' ArgumentList_Opts ')' FunctionType_Opt BlockStatement
	| PROTECTED ClassFunctionName '(' ArgumentList_Opts ')' FunctionType_Opt BlockStatement
	;

ClassFunctionName :
	NAME
	| ClassFunctionSpecialName
	;

ClassDeclStatement :
	CLASS NAME ClassArgumentList_Opts Inherit_Opt BlockStatement
	| SYSCLASS NAME ClassArgumentList_Opts Inherit_Opt BlockStatement
	;

ModuleDeclStatement :
	MODULE NAME BlockStatement
	| SYSMODULE NAME BlockStatement
	;

Inherit_Opt :
	/*empty*/
	| ':' GetLineNumber InheritFactor ClassCallArgumentList_Opts
	;

InheritFactor :
	Factor
	| InheritFactor LMBR AssignExpression RMBR
	| InheritFactor '.' PropertyName
	| InheritFactor '.' TYPEOF
	;

ClassArgumentList_Opts :
	/*empty*/
	| '(' ArgumentList_Opts ')'
	;

ArgumentList_Opts :
	/*empty*/
	| ArgumentList Comma_Opt
	;

ArgumentList :
	Argument
	| ArgumentList ',' Argument
	;

Argument :
	VarName
	| VarName ':' TypeName ReturnType_Opt
	| Array
	| Object
	| DOTS3 VarName
	;

TypeName :
	TYPE ArrayLevel
	| NATIVE
	| NAME ArrayLevel
	;

ArrayLevel :
	/*empty*/
	| ArrayLevel LMBR RMBR
	;

ReturnType_Opt :
	/*empty*/
	| '(' TypeName ')'
	;

ClassCallArgumentList_Opts :
	/*empty*/
	| '(' CallArgumentList_Opts ')'
	;

CallArgumentList_Opts :
	/*empty*/
	| CallArgumentList Comma_Opt
	;

CallArgumentList :
	CallArgument
	| DOTS3 AssignRightHandSide
	| CallArgumentList ',' CallArgument
	| CallArgumentList ',' DOTS3 AssignRightHandSide
	;

CallArgument :
	AssignExpression
	| ObjectSpecialSyntax
	//| String
	;

GetLineNumber :
	/*empty*/
	;

%%

%x  MLSTR

%%

[ \t\r\n]	skip()
"#".*	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"^"	'^'
"~"	'~'
"<"	'<'
"="	'='
">"	'>'
"|"	'|'
"-"	'-'
","	','
";"	';'
":"	':'
"!"	'!'
"?"	'?'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"@"	'@'
"*"	'*'
"&"	'&'
"%"	'%'
"+"	'+'

"+="	ADDEQ
"&="	ANDEQ
"???>"	BINEND
"=>"	DARROW
"--"	DEC
"/="	DIVEQ
".."	DOTS2
"..."	DOTS3
"=="	EQEQ
"+>"	FCOMPOSL2R
"<+"	FCOMPOSR2L
">="	GE
"++"	INC
"&&"	LAND
"&&="	LANDEQ
"{"	LBBR
"<="	LE
"<=>"	LGE
"["	LMBR
"||"	LOR
"||="	LOREQ
"??"	LUNDEF
"??="	LUNDEFEQ
"%="	MODEQ
"*="	MULEQ
"!="	NEQ
"|="	OREQ
"|>"	PIPEOPL2R
"<|"	PIPEOPR2L
"**"	POW
"}"	RBBR
"=~"	REGEQ
"!~"	REGNE
"%m"	REGPF
"]"	RMBR
"<<"	SHL
"<<="	SHLEQ
">>"	SHR
">>="	SHREQ
"-="	SUBEQ
"^="	XOREQ

"as"	AS
"break"	BREAK
"case"	CASE
"catch"	CATCH
"class"	CLASS
"_class"	SYSCLASS
"const"	CONST
"continue"	CONTINUE
"_coroutine"	COROUTINE
"default"	DEFAULT
"do"	DO
"else"	ELSE
"enum"	ENUM
"false"	FALSE
"falthrough"	FALLTHROUGH
"__FILE__"	SRCFILE
"finally"	FINALLY
"for"	FOR
"function"	FUNCTION
"_function"	SYSFUNC
"if"	IF
"_import"	IMPORT
"import"	IMPORT
"in"	IN
"isArray"	TYPEOF
"isBigInteger"	TYPEOF
"isBinary"	TYPEOF
"isDefined"	TYPEOF
"isDouble"	TYPEOF
"isFunction"	TYPEOF
"isInteger"	TYPEOF
"isNull"	TYPEOF
"isNumber"	TYPEOF
"isObject"	TYPEOF
"isString"	TYPEOF
"isUndefined"	TYPEOF
"mixin"	MIXIN
"module"	MODULE
"_module"	SYSMODULE
"namespace"	NAMESPACE
"_namespace"	SYSNS
"native"	NATIVE
"new"	NEW
"null"	NUL
"otherwise"	OTHERWISE
"private"	PRIVATE
"protected"	PROTECTED
"public"	PUBLIC
"_ret_nv"	SYSRET_NV
"return"	RETURN
"switch"	SWITCH
"throw"	THROW
"true"	TRUE
"try"	TRY
"undefined"	NUL
"using"	USING
"var"	VAR
"when"	WHEN
"while"	WHILE
"yield"	YIELD

"ary"	TYPE
"bin"	TYPE
"big"	TYPE
"dbl"	TYPE
"int"	TYPE
"obj"	TYPE
"str"	TYPE

"0"[xX][A-Fa-f0-9]+	INT
[0-9]+	INT
[0-9]+[Bb]	BIGINT
[0-9]+"."[0-9]+	DBL
\"(\\.|[^"\n\r\\])*\"	STR
'(\\.|[^'\n\r\\])*'	STR
"%{"<>MLSTR>
<MLSTR> {
    "%{"<>MLSTR>
    "{"<>MLSTR>
    "}"<<>	STR
    [^}]<.>
}

[A-Za-z_$][A-Za-z0-9_$]*	NAME

%%
