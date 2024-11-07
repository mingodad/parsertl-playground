//From: https://github.com/kitlang/kit/blob/2769a7a8e51fe4466c50439d1a1ebdad0fb79710/src/Kit/Parser/Parser.y

%token assign_op
%token custom_op
%token identifier
%token inline_c
%token macro_identifier
%token str
%token upper_identifier
%token bool char int float

%%

Statements
	: Statements_
	;
Statements_
	:
	| Statements_ Statement
	| Statements_ TypeDefinition DefinitionBody
	| Statements_ TraitDefinition DefinitionBody
	| Statements_ TraitImplementation DefinitionBody
	;

Statement
	: "import" ModulePath ';'
	| "import" ModulePath ".*" ';'
	| "import" ModulePath ".**" ';'
	| "include" str "=>" str ';'
	| "include" str ';'
	| "using" UsingClause ';'
	| MetaMods "typedef" upper_identifier '=' TypeSpec ';'
	| MetaMods "default" TypeSpec "as" TypeSpec ';'
	| "rules" upper_identifier '{' ShortRules '}'
	| VarDefinition
	| FunctionDefinition
	| "extend" TypePath '{' DefStatements '}'
	| "macro" FunctionDefinitionBase
	| TypePath '(' CallArgs ')' ';'
	;

TypeDefinition
	: MetaMods "enum" upper_identifier TypeParams
	| MetaMods "struct" upper_identifier TypeParams
	| MetaMods "union" upper_identifier TypeParams
	| MetaMods "abstract" upper_identifier TypeParams TypeAnnotation
	;

TraitDefinition
	: MetaMods "trait" upper_identifier TypeParams AssocTypeDeclarations
	;

TraitImplementation
	: "implement" TypeParams TypeSpec AssocTypes "for" TypeSpec
	;

//  dummy rule to avoid larger rewrites "for" "commented out" functionality
//NotYetSupported : ;

AssocTypes
	:
	| '(' CommaDelimitedTypes ')'
	;

AssocTypeDeclarations
	:
	| '(' TypeParams_ ')'
	;

TopLevelExpr
	: StandaloneExpr
	| ConstOrVar Identifier TypeAnnotation OptionalStandaloneDefault
	| "return" TopLevelExpr
	| "return" ';'
  // | defer TopLevelExpr
	| "continue" ';'
	| "break" ';'
	| "yield" Expr ';'
	| "tokens" str
	;

StandaloneExpr
	: ExprBlock
	| "using" UsingClauses StandaloneExpr
	| IfStatement
	| "static" IfStatement
	| "for" Identifier "in" Expr ExprBlock
	| "while" Expr ExprBlock
	| "do" ExprBlock "while" Expr ';'
	| "match" Expr '{' MatchCases DefaultMatchCase '}'
	| Expr ';'
	;

IfStatement
	: "if" BinopTermOr ExprBlock
	| "if" BinopTermOr ExprBlock "else" StandaloneExpr
	;

UsingClauses
	: UsingClause
	| UsingClauses ',' UsingClause
	;

UsingClause
	: "rules" TypePath
	| "implicit" Expr
	;

FunctionDefinition
	: MetaMods "function" FunctionDefinitionBase
	;

FunctionDefinitionBase
	: identifier TypeParams '(' VarArgs ')' TypeAnnotation OptionalBody
	;

MatchCases
	:
	| MatchCases MatchCase
	;

MatchCase
	: Expr "=>" TopLevelExpr
	;

DefaultMatchCase
	:
	| "default" "=>" TopLevelExpr
	;

ExprBlock
	: '{' MacroIdentifier '}'
	| '{' TopLevelExprs '}'
	;

TopLevelExprs
	:
	| TopLevelExprs TopLevelExpr
	;

ModulePath
	: identifier
	| ModulePath '.' identifier
	;

CallArgs
	:
	| Expr
	| CallArgs ',' Expr
	;

MetaArg
	: Term
	| UpperOrLowerIdentifier
	;

MetaArgs
	: MetaArg
	| MetaArgs ',' MetaArg
	;

Metadata
	: "#[" identifier '(' MetaArgs ')' ']'
	| "#[" identifier ']'
	| "#[" ReservedIdentifier ']'
	;

ReservedIdentifier
	: "static"
	;

MetaMods
	:
	| MetaMods Metadata
	| MetaMods "public"
	| MetaMods "private"
	| MetaMods "inline"
	| MetaMods "static"
	;

TypeAnnotation
	:
	| ':' TypeSpec
	;

TypeSpec
	: TypePath TypeSpecParams
	| '&' TypeSpec
	| "function" FunctionTypeSpec
	| '(' TypeSpec ',' CommaDelimitedTypes ')'
	| Term
	| "Self"
	| '_'
	;

FunctionTypeSpec
	: '(' ')' "->" TypeSpec
	| '(' CommaDelimitedTypes ',' identifier "..." ')' "->" TypeSpec
	| '(' CommaDelimitedTypes ')' "->" TypeSpec
	;

CommaDelimitedTypes
	: TypeSpec
	| CommaDelimitedTypes ',' TypeSpec
	;

OptionalBody
	: ';'
	| "using" UsingClauses ExprBlock
	| ExprBlock
	;

OptionalRuleBody
	: ';'
	| "=>" StandaloneExpr
	;

TypeParams
	:
	| '[' TypeParams_ ']'
	;

TypeParams_
	: TypeParam
	| TypeParams_ ',' TypeParam
	;

TypeParam
	: TypeParam '=' TypeSpec
	| upper_identifier TypeConstraints
	| macro_identifier
	;

TypeSpecParams
	:
	| '[' TypeSpecParams_ ']'
	;

TypeSpecParams_
	: TypeSpec
	| TypeSpecParams_ ',' TypeSpec
	;

TypeConstraints
	:
	| ':' TypeSpec
	| "::" TypeConstraints_
	;

TypeConstraints_
	: TypeSpec
	| TypeConstraints_ '|' TypeSpec
	;

UpperOrLowerIdentifier
	: identifier
	| upper_identifier
	;

TypePath
	: TypePath '.' UpperOrLowerIdentifier
	| UpperOrLowerIdentifier
	;

ConstOrVar
	: "var"
	| "const"
	;

VarDefinition
	: MetaMods ConstOrVar UpperOrLowerIdentifier TypeAnnotation OptionalDefault ';'
	;

VarDefinitions
	:
	| VarDefinitions VarDefinition
	;

VarBlock
	: MetaMods '{' VarDefinitions '}'
	;

OptionalStandaloneDefault
	: ';'
	| '=' "undefined" ';'
	| '=' StandaloneExpr
	;

OptionalDefault
	:
	| '=' "undefined"
	| '=' Expr
	;

EnumVariant
	: MetaMods upper_identifier ';'
  // | MetaMods upper_identifier '=' Expr ';'
	| MetaMods upper_identifier '(' Args ')' ';'
	;

VarArgs
	: Args ',' identifier "..."
	| Args
	;

Args
	:
	| ArgSpec
	| Args ',' ArgSpec
	;

ArgSpec
	: identifier TypeAnnotation OptionalDefault
	;

DefinitionBody
	: ';'
	| '{' DefStatements '}'
	;

DefStatements
	:
	| DefStatements RewriteRule
	| DefStatements RuleBlock
	| DefStatements FunctionDefinition
	| DefStatements VarDefinition
	| DefStatements VarBlock
	| DefStatements EnumVariant
	;

RewriteExpr
	: Expr
	| StandaloneExpr
	;

RewriteRule
	: "rule" '(' RewriteExpr ')' OptionalRuleBody
	;

RuleBlock
	: "rules" '{' ShortRules '}'
	;

ShortRules
	:
	| ShortRules ShortRule
	;

ShortRule
	: '(' RewriteExpr ')' OptionalRuleBody
	;

Expr
	: RangeLiteral
	;

RangeLiteral
	: BinopTermAssign "..." BinopTermAssign
	| BinopTermAssign
	;

BinopTermAssign
	: ArrayAccessCallFieldExpr '=' BinopTermAssign
	| BinopTermCons
	| BinopTermCons '=' BinopTermAssign
	| BinopTermCons assign_op BinopTermAssign
	;

BinopTermCons
	: BinopTermTernary
	| BinopTermTernary "::" BinopTermCons
	;

//  TokenExpr
//    : token LexMacroTokenAny
  // | BinopTermTernary
  // ;

BinopTermTernary
	: "if" BinopTermTernary "then" BinopTermTernary "else" BinopTermTernary
	| BinopTermOr
	;

BinopTermOr
	: BinopTermAnd
	| BinopTermOr "||" BinopTermAnd
	;

BinopTermAnd
	: BinopTermEq
	| BinopTermAnd "&&" BinopTermEq
	;

BinopTermEq
	: BinopTermCompare
	| BinopTermEq "==" BinopTermCompare
	| BinopTermEq "!=" BinopTermCompare
	;

BinopTermCompare
	: BinopTermBitOr
	| BinopTermCompare '>' BinopTermBitOr
	| BinopTermCompare '<' BinopTermBitOr
	| BinopTermCompare ">=" BinopTermBitOr
	| BinopTermCompare "<=" BinopTermBitOr
	;

BinopTermBitOr
	: BinopTermBitXor
	| BinopTermBitOr '|' BinopTermBitXor
	;

BinopTermBitXor
	: BinopTermBitAnd
	| BinopTermBitXor '^' BinopTermBitAnd
	;

BinopTermBitAnd
	: BinopTermShift
	| BinopTermBitAnd '&' BinopTermShift
	;

BinopTermShift
	: BinopTermAdd
	| BinopTermShift "<<" BinopTermAdd
	| BinopTermShift ">>" BinopTermAdd
	;

BinopTermAdd
	: BinopTermMul
	| BinopTermAdd '+' BinopTermMul
	| BinopTermAdd '-' BinopTermMul
	;

BinopTermMul
	: BinopTermCustom
	| BinopTermMul '*' BinopTermCustom
	| BinopTermMul '/' BinopTermCustom
	| BinopTermMul '%' BinopTermCustom
	;

BinopTermCustom
	: CastExpr
	| BinopTermCustom custom_op CastExpr
	;

CastExpr
	: CastExpr "as" TypeSpec
	| Unop
	;

Unop
	: "++" VecExpr
	| "--" VecExpr
	| '!' VecExpr
	| '-' VecExpr
	| '~' VecExpr
	| '&' VecExpr
	| '*' VecExpr
	| VecExpr "++"
	| VecExpr "--"
	| VecExpr
	;

VecExpr
	: '[' ArrayElems ']'
	| '[' ArrayElems ',' ']'
	| '[' ']'
	| ArrayAccessCallFieldExpr
	;

ArrayElems
	: Expr
	| ArrayElems ',' Expr
	;

ArrayAccessCallFieldExpr
	: ArrayAccessCallFieldExpr '[' ArrayElems ']'
	| ArrayAccessCallFieldExpr '(' CallArgs ')'
	| ArrayAccessCallFieldExpr '.' Identifier
	| TypeAnnotatedExpr
	;

TypeAnnotatedExpr
	: TypeAnnotatedExpr ':' TypeSpec
	| BaseExpr
	;

BaseExpr
	: Term
	| "this"
	| "Self"
	| Identifier
	| '(' identifier "..." ')'
	| "unsafe" Expr
	| "sizeof" TypeSpec
	| "sizeof" '(' TypeSpec ')'
	| "defined" Identifier
	| "defined" '(' Identifier ')'
	| '(' Expr ParenthesizedExprs ')'
	| "null"
	| "empty"
	| "struct" TypeSpec '{' StructInitFields '}'
	| "struct" TypeSpec
	| "union" TypeSpec '{' StructInitField '}'
	| "implicit" TypeSpec
	| inline_c TypeAnnotation
	| "static" Expr
	;

ParenthesizedExprs
	:
	| ParenthesizedExprs ',' Expr
	;

Term
	: bool
	| str
	| int
	| float
	| char
	;

StructInitFields
	:
	| OneOrMoreStructInitFields ','
	| OneOrMoreStructInitFields
	;

OneOrMoreStructInitFields
	: StructInitField
	| OneOrMoreStructInitFields ',' StructInitField
	;

StructInitField
	: UpperOrLowerIdentifier ':' Expr
	| UpperOrLowerIdentifier
	;

Identifier
	: UpperOrLowerIdentifier
	| MacroIdentifier
	| '_'
	;

MacroIdentifier
	: macro_identifier
	| '$' '{' UpperOrLowerIdentifier TypeAnnotation '}'
	| '$' '{' '_' TypeAnnotation '}'
	;

%%

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"^"	'^'
"~"	'~'
"<<"	"<<"
"<="	"<="
"<"	'<'
"=="	"=="
"=>"	"=>"
"="	'='
">="	">="
">>"	">>"
">"	'>'
"||"	"||"
"|"	'|'
"_"	'_'
"->"	"->"
"--"	"--"
"-"	'-'
","	','
";"	';'
"::"	"::"
":"	':'
"!="	"!="
"!"	'!'
"/"	'/'
"..."	"..."
"."	'.'
".*"	".*"
".**"	".**"
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"$"	'$'
"*"	'*'
"&"	'&'
"&&"	"&&"
"#["	"#["
"%"	'%'
"+"	'+'
"++"	"++"
"abstract"	"abstract"
"as"	"as"
"break"	"break"
"const"	"const"
"continue"	"continue"
"default"	"default"
"defined"	"defined"
"do"	"do"
"else"	"else"
"empty"	"empty"
"enum"	"enum"
"extend"	"extend"
"for"	"for"
"function"	"function"
"if"	"if"
"implement"	"implement"
"implicit"	"implicit"
"import"	"import"
"include"	"include"
"in"	"in"
"inline"	"inline"
"macro"	"macro"
"match"	"match"
"null"	"null"
"private"	"private"
"public"	"public"
"return"	"return"
"rule"	"rule"
"rules"	"rules"
"Self"	"Self"
"sizeof"	"sizeof"
"static"	"static"
"struct"	"struct"
"then"	"then"
"this"	"this"
"tokens"	"tokens"
"trait"	"trait"
"typedef"	"typedef"
"undefined"	"undefined"
"union"	"union"
"unsafe"	"unsafe"
"using"	"using"
"var"	"var"
"while"	"while"
"yield"	"yield"

"+="|"-="|"/="|"*="|"%="|"&&="|"||="|"&="|"|="|"^="|"<<="|">>="	assign_op
[\*\/\+\-\^\=\<\>\!\&\%\~\@\?\:\.]+	custom_op
\"(\\.|[^"\r\n\\])*\"	str

"```"([^`]|\`[^`]|\`\`[^`]|\n)*"```"	inline_c

"true"|"false"	bool
"c'"([^\\']|\\.)"'"	char
"0x"[0-9a-fA-F]+"_"([ui](8|16|32|64)|f(32|64)|[cis])	int
"0o"[0-7]+"_"([ui](8|16|32|64)|f(32|64)|[cis])	int
"0b"[01]+"_"([ui](8|16|32|64)|f(32|64)|[cis])	int
\-?(0|[1-9][0-9]*)"_"([ui](8|16|32|64)|f(32|64)|[cis])	int
"0x"[0-9a-fA-F]+	int
"0o"[0-7]+	int
"0b"[01]+	int
\-?(0|[1-9][0-9]*)	int
\-?[0-9]+"."[0-9]*"_"(f(32|64))	float
\-?[0-9]+"."[0-9]*	float

"$"[A-Za-z_][a-zA-Z0-9_]*	macro_identifier
"${"[A-Za-z_][a-zA-Z0-9_]*"}"	macro_identifier
[_]*[A-Z][a-zA-Z0-9_]*	upper_identifier
"``"([^`]|\`[^`])+"``"	upper_identifier
[_]*[a-z][a-zA-Z0-9_]*"!"	identifier
[_]*[a-z][a-zA-Z0-9_]*	identifier
"`"[^`]+"`"	identifier
[@][a-z][a-zA-Z0-9_]*	identifier
"_"[_]+	identifier

%%
