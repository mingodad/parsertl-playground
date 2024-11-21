//From: https://github.com/deiuch/c-to-json/blob/20bb61dc4782d210d5619beae14af1f4666f76ba/yacc_syntax.y
/**
 * Parser for C Programming Language (ISO/IEC 9899:2018).
 *
 * @authors: Denis Chernikov, Vladislav Kuleykin
 *
 * Source (ISO/IEC 9899:2017, no critical changes were applied in :2018):
 * http://www.open-std.org/jtc1/sc22/wg14/www/abq/c17_updated_proposed_fdis.pdf
 *
 * Not for commercial use.
 */

/*Tokens*/
%token ADD_ASSIGN
%token ALIGNAS
%token ALIGNOF
%token AMPERSAND
%token AND_ASSIGN
%token ARROW
%token ASSIGN
%token ASTERISK
%token ATOMIC
%token AUTO
%token BOOL
%token BREAK
%token CARET
%token CASE
%token CHAR
%token COLON
%token COMMA
%token COMPLEX
%token CONST
%token CONSTANT
%token CONTINUE
%token DBL_MINUS
%token DBL_PLUS
%token DEFAULT
%token DIV_ASSIGN
%token DO
%token DOT
%token DOUBLE
%token ELLIPSIS
%token ELSE
%token ENUM
%token EQ
%token EXCLAMATION
%token EXTERN
%token FLOAT
%token FOR
%token GE
%token GENERIC
%token GOTO
%token GR
%token IDENTIFIER
%token IF
%token IMAGINARY
%token INLINE
%token INT
%token LBRACE
%token LBRACKET
%token LE
%token LEFT_ASSIGN
%token LOG_AND
%token LOG_OR
%token LONG
%token LPAREN
%token LS
%token LSHIFT
%token MINUS
%token MOD_ASSIGN
%token MUL_ASSIGN
%token NE
%token NORETURN
%token OR_ASSIGN
%token PERCENT
%token PLUS
%token QUESTION
%token RBRACE
%token RBRACKET
%token REGISTER
%token RESTRICT
%token RETURN
%token RIGHT_ASSIGN
%token RPAREN
%token RSHIFT
%token SEMICOLON
%token SHORT
%token SIGNED
%token SIZEOF
%token SLASH
%token STATIC
%token STATIC_ASSERT
%token STRING_LITERAL
%token STRUCT
%token SUB_ASSIGN
%token SWITCH
%token THREAD_LOCAL
%token TILDE
%token TYPEDEF
%token TYPEDEF_NAME
%token UNION
%token UNSIGNED
%token VERTICAL
%token VOID
%token VOLATILE
%token WHILE
%token XOR_ASSIGN

%nonassoc /*1*/ ATOMIC
%nonassoc /*2*/ LPAREN
%nonassoc /*3*/ NO_ELSE
%nonassoc /*4*/ ELSE
%left /*5*/ LOG_OR
%left /*6*/ LOG_AND
%left /*7*/ VERTICAL
%left /*8*/ CARET
%left /*9*/ AMPERSAND
%left /*10*/ EQ NE
%left /*11*/ LS GR LE GE
%left /*12*/ LSHIFT RSHIFT
%left /*13*/ PLUS MINUS
%left /*14*/ ASTERISK SLASH PERCENT

%start TranslationUnit

%%

TranslationUnit :
	ExternalDeclaration
	| TranslationUnit ExternalDeclaration
	;

ExternalDeclaration :
	FunctionDefinition
	| Declaration
	;

FunctionDefinition :
	DeclarationSpecifiers Declarator CompoundStatement
	| DeclarationSpecifiers Declarator DeclarationList CompoundStatement
	;

DeclarationList :
	Declaration
	| DeclarationList Declaration
	;

Declaration :
	DeclarationSpecifiers SEMICOLON
	| DeclarationSpecifiers InitDeclaratorList SEMICOLON
	| StaticAssertDeclaration
	;

DeclarationSpecifiers :
	StorageClassSpecifier
	| TypeSpecifier
	| TypeQualifier
	| FunctionSpecifier
	| AlignmentSpecifier
	| StorageClassSpecifier DeclarationSpecifiers
	| TypeSpecifier DeclarationSpecifiers
	| TypeQualifier DeclarationSpecifiers
	| FunctionSpecifier DeclarationSpecifiers
	| AlignmentSpecifier DeclarationSpecifiers
	;

InitDeclaratorList :
	InitDeclarator
	| InitDeclaratorList COMMA InitDeclarator
	;

InitDeclarator :
	Declarator
	| Declarator ASSIGN Initializer
	;

StorageClassSpecifier :
	TYPEDEF
	| EXTERN
	| STATIC
	| THREAD_LOCAL
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
	| IMAGINARY
	| AtomicTypeSpecifier
	| StructOrUnionSpecifier
	| EnumSpecifier
	| TypedefName
	;

StructOrUnionSpecifier :
	StructOrUnion LBRACE StructDeclarationList RBRACE
	| StructOrUnion IDENTIFIER LBRACE StructDeclarationList RBRACE
	| StructOrUnion IDENTIFIER
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
	SpecifierQualifierList SEMICOLON
	| SpecifierQualifierList StructDeclaratorList SEMICOLON
	| StaticAssertDeclaration
	;

SpecifierQualifierList :
	TypeSpecifier
	| TypeQualifier
	| AlignmentSpecifier
	| TypeSpecifier SpecifierQualifierList
	| TypeQualifier SpecifierQualifierList
	| AlignmentSpecifier SpecifierQualifierList
	;

StructDeclaratorList :
	StructDeclarator
	| StructDeclaratorList COMMA StructDeclarator
	;

StructDeclarator :
	Declarator
	| COLON ConstantExpression
	| Declarator COLON ConstantExpression
	;

EnumSpecifier :
	ENUM LBRACE EnumeratorList RBRACE
	| ENUM LBRACE EnumeratorList COMMA RBRACE
	| ENUM IDENTIFIER LBRACE EnumeratorList RBRACE
	| ENUM IDENTIFIER LBRACE EnumeratorList COMMA RBRACE
	| ENUM IDENTIFIER
	;

EnumeratorList :
	Enumerator
	| EnumeratorList COMMA Enumerator
	;

Enumerator :
	IDENTIFIER
	| IDENTIFIER ASSIGN ConstantExpression
	;

AtomicTypeSpecifier :
	ATOMIC /*1N*/ LPAREN /*2N*/ TypeName RPAREN
	;

TypeQualifier :
	CONST
	| RESTRICT
	| VOLATILE
	| ATOMIC /*1N*/
	;

FunctionSpecifier :
	INLINE
	| NORETURN
	;

AlignmentSpecifier :
	ALIGNAS LPAREN /*2N*/ TypeName RPAREN
	| ALIGNAS LPAREN /*2N*/ ConstantExpression RPAREN
	;

Declarator :
	DirectDeclarator
	| Pointer DirectDeclarator
	;

DirectDeclarator :
	IDENTIFIER
	| LPAREN /*2N*/ Declarator RPAREN
	| DirectDeclarator LBRACKET RBRACKET
	| DirectDeclarator LBRACKET AssignmentExpression RBRACKET
	| DirectDeclarator LBRACKET TypeQualifierList RBRACKET
	| DirectDeclarator LBRACKET TypeQualifierList AssignmentExpression RBRACKET
	| DirectDeclarator LBRACKET STATIC AssignmentExpression RBRACKET
	| DirectDeclarator LBRACKET STATIC TypeQualifierList AssignmentExpression RBRACKET
	| DirectDeclarator LBRACKET TypeQualifierList STATIC AssignmentExpression RBRACKET
	| DirectDeclarator LBRACKET ASTERISK /*14L*/ RBRACKET
	| DirectDeclarator LBRACKET TypeQualifierList ASTERISK /*14L*/ RBRACKET
	| DirectDeclarator LPAREN /*2N*/ ParameterTypeList RPAREN
	| DirectDeclarator LPAREN /*2N*/ RPAREN
	| DirectDeclarator LPAREN /*2N*/ IdentifierList RPAREN
	;

Pointer :
	ASTERISK /*14L*/
	| ASTERISK /*14L*/ TypeQualifierList
	| ASTERISK /*14L*/ Pointer
	| ASTERISK /*14L*/ TypeQualifierList Pointer
	;

TypeQualifierList :
	TypeQualifier
	| TypeQualifierList TypeQualifier
	;

ParameterTypeList :
	ParameterList
	| ParameterList COMMA ELLIPSIS
	;

ParameterList :
	ParameterDeclaration
	| ParameterList COMMA ParameterDeclaration
	;

ParameterDeclaration :
	DeclarationSpecifiers Declarator
	| DeclarationSpecifiers
	| DeclarationSpecifiers AbstractDeclarator
	;

IdentifierList :
	IDENTIFIER
	| IdentifierList COMMA IDENTIFIER
	;

TypeName :
	SpecifierQualifierList
	| SpecifierQualifierList AbstractDeclarator
	;

AbstractDeclarator :
	Pointer
	| DirectAbstractDeclarator
	| Pointer DirectAbstractDeclarator
	;

DirectAbstractDeclarator :
	LPAREN /*2N*/ AbstractDeclarator RPAREN
	| LBRACKET RBRACKET
	| LBRACKET AssignmentExpression RBRACKET
	| LBRACKET TypeQualifierList RBRACKET
	| LBRACKET TypeQualifierList AssignmentExpression RBRACKET
	| LBRACKET STATIC AssignmentExpression RBRACKET
	| LBRACKET STATIC TypeQualifierList AssignmentExpression RBRACKET
	| LBRACKET TypeQualifierList STATIC AssignmentExpression RBRACKET
	| LBRACKET ASTERISK /*14L*/ RBRACKET
	| LPAREN /*2N*/ RPAREN
	| LPAREN /*2N*/ ParameterTypeList RPAREN
	| DirectAbstractDeclarator LBRACKET RBRACKET
	| DirectAbstractDeclarator LBRACKET AssignmentExpression RBRACKET
	| DirectAbstractDeclarator LBRACKET TypeQualifierList RBRACKET
	| DirectAbstractDeclarator LBRACKET TypeQualifierList AssignmentExpression RBRACKET
	| DirectAbstractDeclarator LBRACKET STATIC AssignmentExpression RBRACKET
	| DirectAbstractDeclarator LBRACKET STATIC TypeQualifierList AssignmentExpression RBRACKET
	| DirectAbstractDeclarator LBRACKET TypeQualifierList STATIC AssignmentExpression RBRACKET
	| DirectAbstractDeclarator LBRACKET ASTERISK /*14L*/ RBRACKET
	| DirectAbstractDeclarator LPAREN /*2N*/ RPAREN
	| DirectAbstractDeclarator LPAREN /*2N*/ ParameterTypeList RPAREN
	;

TypedefName :
	TYPEDEF_NAME
	;

Initializer :
	AssignmentExpression
	| LBRACE InitializerList RBRACE
	| LBRACE InitializerList COMMA RBRACE
	;

InitializerList :
	Initializer
	| Designation Initializer
	| InitializerList COMMA Initializer
	| InitializerList COMMA Designation Initializer
	;

Designation :
	DesignatorList ASSIGN
	;

DesignatorList :
	Designator
	| DesignatorList Designator
	;

Designator :
	LBRACKET ConstantExpression RBRACKET
	| DOT IDENTIFIER
	;

StaticAssertDeclaration :
	STATIC_ASSERT LPAREN /*2N*/ ConstantExpression COMMA STRING_LITERAL RPAREN SEMICOLON
	;

Statement :
	LabeledStatement
	| CompoundStatement
	| ExpressionStatement
	| SelectionStatement
	| IterationStatement
	| JumpStatement
	;

LabeledStatement :
	IDENTIFIER COLON Statement
	| CASE ConstantExpression COLON Statement
	| DEFAULT COLON Statement
	;

CompoundStatement :
	LBRACE RBRACE
	| LBRACE BlockItemList RBRACE
	;

BlockItemList :
	BlockItem
	| BlockItemList BlockItem
	;

BlockItem :
	Declaration
	| Statement
	;

ExpressionStatement :
	SEMICOLON
	| Expression SEMICOLON
	;

SelectionStatement :
	IF LPAREN /*2N*/ Expression RPAREN Statement %prec NO_ELSE /*3N*/
	| IF LPAREN /*2N*/ Expression RPAREN Statement ELSE /*4N*/ Statement
	| SWITCH LPAREN /*2N*/ Expression RPAREN Statement
	;

IterationStatement :
	WHILE LPAREN /*2N*/ Expression RPAREN Statement
	| DO Statement WHILE LPAREN /*2N*/ Expression RPAREN SEMICOLON
	| FOR LPAREN /*2N*/ ExpressionOpt SEMICOLON ExpressionOpt SEMICOLON ExpressionOpt RPAREN Statement
	| FOR LPAREN /*2N*/ Declaration ExpressionOpt SEMICOLON ExpressionOpt RPAREN Statement
	;

JumpStatement :
	GOTO IDENTIFIER SEMICOLON
	| CONTINUE SEMICOLON
	| BREAK SEMICOLON
	| RETURN SEMICOLON
	| RETURN Expression SEMICOLON
	;

ConstantExpression :
	ConditionalExpression
	;

ExpressionOpt :
	/*empty*/
	| Expression
	;

Expression :
	AssignmentExpression
	| Expression COMMA AssignmentExpression
	;

AssignmentExpression :
	ConditionalExpression
	| UnaryExpression AssignmentOperator AssignmentExpression
	;

AssignmentOperator :
	ASSIGN
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

ConditionalExpression :
	ArithmeticalExpression
	| ArithmeticalExpression QUESTION ExpressionOpt COLON ConditionalExpression
	;

ArithmeticalExpression :
	CastExpression
	| ArithmeticalExpression LOG_OR /*5L*/ ArithmeticalExpression
	| ArithmeticalExpression LOG_AND /*6L*/ ArithmeticalExpression
	| ArithmeticalExpression VERTICAL /*7L*/ ArithmeticalExpression
	| ArithmeticalExpression CARET /*8L*/ ArithmeticalExpression
	| ArithmeticalExpression AMPERSAND /*9L*/ ArithmeticalExpression
	| ArithmeticalExpression EQ /*10L*/ ArithmeticalExpression
	| ArithmeticalExpression NE /*10L*/ ArithmeticalExpression
	| ArithmeticalExpression LS /*11L*/ ArithmeticalExpression
	| ArithmeticalExpression GR /*11L*/ ArithmeticalExpression
	| ArithmeticalExpression LE /*11L*/ ArithmeticalExpression
	| ArithmeticalExpression GE /*11L*/ ArithmeticalExpression
	| ArithmeticalExpression LSHIFT /*12L*/ ArithmeticalExpression
	| ArithmeticalExpression RSHIFT /*12L*/ ArithmeticalExpression
	| ArithmeticalExpression PLUS /*13L*/ ArithmeticalExpression
	| ArithmeticalExpression MINUS /*13L*/ ArithmeticalExpression
	| ArithmeticalExpression ASTERISK /*14L*/ ArithmeticalExpression
	| ArithmeticalExpression SLASH /*14L*/ ArithmeticalExpression
	| ArithmeticalExpression PERCENT /*14L*/ ArithmeticalExpression
	;

CastExpression :
	UnaryExpression
	| LPAREN /*2N*/ TypeName RPAREN CastExpression
	;

UnaryExpression :
	PostfixExpression
	| DBL_PLUS UnaryExpression
	| DBL_MINUS UnaryExpression
	| UnaryOperator CastExpression
	| SIZEOF UnaryExpression
	| SIZEOF LPAREN /*2N*/ TypeName RPAREN
	| ALIGNOF LPAREN /*2N*/ TypeName RPAREN
	;

UnaryOperator :
	AMPERSAND /*9L*/
	| ASTERISK /*14L*/
	| PLUS /*13L*/
	| MINUS /*13L*/
	| TILDE
	| EXCLAMATION
	;

PostfixExpression :
	PrimaryExpression
	| PostfixExpression LBRACKET Expression RBRACKET
	| PostfixExpression LPAREN /*2N*/ RPAREN
	| PostfixExpression LPAREN /*2N*/ ArgumentExpressionList RPAREN
	| PostfixExpression DOT IDENTIFIER
	| PostfixExpression ARROW IDENTIFIER
	| PostfixExpression DBL_PLUS
	| PostfixExpression DBL_MINUS
	| LPAREN /*2N*/ TypeName RPAREN LBRACE InitializerList RBRACE
	| LPAREN /*2N*/ TypeName RPAREN LBRACE InitializerList COMMA RBRACE
	;

ArgumentExpressionList :
	AssignmentExpression
	| ArgumentExpressionList COMMA AssignmentExpression
	;

PrimaryExpression :
	IDENTIFIER
	| CONSTANT
	| STRING_LITERAL
	| LPAREN /*2N*/ Expression RPAREN
	| GenericSelection
	;

GenericSelection :
	GENERIC LPAREN /*2N*/ AssignmentExpression COMMA GenericAssocList RPAREN
	;

GenericAssocList :
	GenericAssociation
	| GenericAssocList COMMA GenericAssociation
	;

GenericAssociation :
	TypeName COLON AssignmentExpression
	| DEFAULT COLON AssignmentExpression
	;

%%

//%x COMMENT
%x PREP
%x INCL_FL
%x INCL_ST
%x ERROR_S
%x WARNING
%x CHR
%x STR

O         [0-7]
D         [0-9]
H         [0-9A-Fa-f]
ND        [A-Za-z_]
DE        [Ee][+-]?{D}+
HE        [Pp][+-]?{D}+
LS        L|l|LL|ll
IS        [Uu]{LS}?|{LS}[Uu]?
FS        [FfLl]
HASH      "??="|"#"
LBRACKET  "??("|"["
BS        "??/"|"\\"
RBRACKET  "??)"|"]"
CARET     "??'"|"^"
LBRACE    "??<"|"{"
VERTICAL  "??!"|"|"
RBRACE    "??>"|"}"
TILDE     "??-"|"~"
PR_INS    [ \t]+[^\n\r]+(\\\n.*)*
NLE       {BS}(\n|\r|\r\n)
UCN       {BS}(u{H}{4}|U{H}{8})
ID        {ND}({ND}|{D}|{UCN})*
ESC       {BS}['"?\\abfnrtv]|{BS}"??/"|{BS}{O}{1,3}|{BS}x{H}+|{UCN}
CHAR      [LUu]?'({ESC}|[^'\\\n\r])+'
STRL      ([LUu]|u8)?\"({ESC}|[^"\\\n\r])+\"
WS        [ \f\n\r\t\v]

%%

^[ \t]*({HASH}|"%:")[ \t]*<PREP>

<PREP>"if"{PR_INS}<INITIAL> skip()
<PREP>"ifdef"{PR_INS}<INITIAL> skip()
<PREP>"ifndef"{PR_INS}<INITIAL> skip()
<PREP>"elif"{PR_INS}<INITIAL> skip()
<PREP>"else".*<INITIAL> skip()
<PREP>"endif".*<INITIAL> skip()

<PREP>"include"[ \t]*\"<INCL_FL>
<PREP>"include"[ \t]*"<"<INCL_ST>
<INCL_ST>[^>\n\r]+<.>
<INCL_ST>">"[ \t]*$<INITIAL> skip()
<INCL_FL>[^"\n\r]+<.>
<INCL_FL>\"[ \t]*$<INITIAL> skip()

<PREP>"define"{PR_INS}<INITIAL> skip()
<PREP>"undef"{PR_INS}<INITIAL> skip()

<PREP>"line"{PR_INS}<INITIAL> skip() /* TODO change source notification */
<PREP>"error"{WS}*<ERROR_S>
<ERROR_S>[^\n\r]+$<INITIAL> skip()
<PREP>"warning"{WS}*<WARNING>    /* not in ISO/IEC 9899:2017 */
<WARNING>[^\n\r]*$<INITIAL> skip()
<PREP>"pragma"{PR_INS}<INITIAL> skip() /* TODO compiler pragmas */

<PREP>[^\n\r]<.>

"//".* skip() /* ignore inline comment */
"/*"(?s:.)*?"*/"    skip()  /* ignore comment content */

"auto"                  AUTO
"break"                 BREAK
"case"                  CASE
"char"                  CHAR
"const"                 CONST
"continue"              CONTINUE
"default"               DEFAULT
"do"                    DO
"double"                DOUBLE
"else"                  ELSE
"enum"                  ENUM
"extern"                EXTERN
"float"                 FLOAT
"for"                   FOR
"goto"                  GOTO
"if"                    IF
"inline"                INLINE
"int"                   INT
"long"                  LONG
"register"              REGISTER
"restrict"              RESTRICT
"return"                RETURN
"short"                 SHORT
"signed"                SIGNED
"sizeof"                SIZEOF
"static"                STATIC
"struct"                STRUCT
"switch"                SWITCH
"typedef"               TYPEDEF
"union"                 UNION
"unsigned"              UNSIGNED
"void"                  VOID
"volatile"              VOLATILE
"while"                 WHILE
"_Alignas"              ALIGNAS
"_Alignof"              ALIGNOF
"_Atomic"               ATOMIC
"_Bool"                 BOOL
"_Complex"              COMPLEX
"_Generic"              GENERIC
"_Imaginary"            IMAGINARY
"_Noreturn"             NORETURN
"_Static_assert"        STATIC_ASSERT
"_Thread_local"         THREAD_LOCAL

TYPEDEF_NAME	TYPEDEF_NAME
{ID} IDENTIFIER
//{
//    yylval.node = get_const_node(Identifier, alloc_const_str(yytext));
//    if (is_typedef_name(yytext)) return TYPEDEF_NAME;
//    return IDENTIFIER;
//    // TODO check Universal character name, ISO/IEC 9899:2017, page 44
//}

0[Xx]{H}+{IS}?          CONSTANT
0{O}+{IS}?              CONSTANT
{D}+{IS}? CONSTANT

{D}+{DE}{FS}?           CONSTANT
{D}*"."{D}+{DE}?{FS}?   CONSTANT
{D}+"."{D}*{DE}?{FS}?   CONSTANT
0[Xx]{H}+{HE}{FS}?      CONSTANT
0[Xx]{H}*"."{H}+{HE}?{FS}? CONSTANT
0[Xx]{H}+"."{H}*{HE}?{FS}? CONSTANT

[LUu]?'<CHR>    /* TODO prefix considering, ISO/IEC 9899:2017, page 48-50 */

(L|U|u|u8)?\"<STR> /* TODO prefix considering, ISO/IEC 9899:2017, page 50-52 */
<CHR>'<INITIAL> CONSTANT
    // TODO value conversion, UTF-8, ISO/IEC 9899:2017, page 50-52
<STR>\"<INITIAL> STRING_LITERAL
    // TODO UTF-8, ISO/IEC 9899:2017, page 50-52
<STR>\"{WS}*(L|U|u|u8)?\"<.>
<STR,CHR>{ESC}<.>
<STR,CHR>.<.>

{LBRACKET}|"<:"         LBRACKET
{RBRACKET}|":>"         RBRACKET
"("                     LPAREN
")"                     RPAREN
{LBRACE}|"<%"           LBRACE
{RBRACE}|"%>"           RBRACE
"."                     DOT
"->"                    ARROW
"++"                    DBL_PLUS
"--"                    DBL_MINUS
"&"                     AMPERSAND
"*"                     ASTERISK
"+"                     PLUS
"-"                     MINUS
{TILDE}                 TILDE
"!"                     EXCLAMATION
"/"                     SLASH
"%"                     PERCENT
"<<"                    LSHIFT
">>"                    RSHIFT
"<"                     LS
">"                     GR
"<="                    LE
">="                    GE
"=="                    EQ
"!="                    NE
{CARET}                 CARET
{VERTICAL}              VERTICAL
"&&"                    LOG_AND
{VERTICAL}{VERTICAL}    LOG_OR
"?"                     QUESTION
":"                     COLON
";"                     SEMICOLON
"..."                   ELLIPSIS
"="                     ASSIGN
"*="                    MUL_ASSIGN
"/="                    DIV_ASSIGN
"%="                    MOD_ASSIGN
"+="                    ADD_ASSIGN
"-="                    SUB_ASSIGN
"<<="                   LEFT_ASSIGN
">>="                   RIGHT_ASSIGN
"&="                    AND_ASSIGN
{CARET}=                XOR_ASSIGN
{VERTICAL}=             OR_ASSIGN
","                     COMMA

<INITIAL,PREP,STR,CHR>[^ \f\n\r\t\v]*"??/"\r\n skip() // skip and retry

<INITIAL,PREP,STR,CHR>[^ \f\n\r\t\v]*"??/"[\r\n] skip()// skip and retry

<INITIAL,PREP,STR,CHR>[^ \f\n\r\t\v]*\\\r\n skip()// skip and retry

<INITIAL,PREP,STR,CHR>[^ \f\n\r\t\v]*\\[\n\r] skip()// skip and retry


{WS}                    skip() /* skip over whitespaces */

%%
