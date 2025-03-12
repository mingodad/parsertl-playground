//From: https://github.com/JetBrains/kotlin/blob/bd7a6ea1c0d5d0d617a0d3a989591a08d7d724a5/compiler/psi/src/org/jetbrains/kotlin/lexer/Kotlin.flex

%token AND
%token ANDAND
%token ARROW
%token AS_KEYWORD
%token AS_SAFE
%token AT
//%token BLOCK_COMMENT
%token BREAK_KEYWORD
%token CHARACTER_LITERAL
%token CLASS_KEYWORD
//%token CLOSING_QUOTE
%token COLON
%token COLONCOLON
%token COMMA
%token CONTINUE_KEYWORD
//%token DANGLING_NEWLINE
%token DIV
%token DIVEQ
%token DOT
%token DOUBLE_ARROW
%token DOUBLE_SEMICOLON
%token DO_KEYWORD
%token ELSE_KEYWORD
%token EOL_COMMENT
%token EQ
%token EQEQ
%token EQEQEQ
//%token ESCAPE_SEQUENCE
%token EXCL
%token EXCLEQ
%token EXCLEQEQEQ
%token FALSE_KEYWORD
%token FIELD_IDENTIFIER
%token FLOAT_LITERAL
%token FOR_KEYWORD
%token FUN_KEYWORD
%token GT
%token GTEQ
%token HASH
%token IDENTIFIER
%token IF_KEYWORD
%token INTEGER_LITERAL
%token INTERFACE_KEYWORD
//%token INTERPOLATION_PREFIX
%token IN_KEYWORD
%token IS_KEYWORD
%token LBRACE
%token LBRACKET
%token LPAR
%token LT
%token LTEQ
%token MINUS
%token MINUSEQ
%token MINUSMINUS
%token MUL
%token MULTEQ
%token NOT_IN
%token NOT_IS
%token NULL_KEYWORD
%token OBJECT_KEYWORD
//%token OPEN_QUOTE
%token OROR
%token PACKAGE_KEYWORD
%token PERC
%token PERCEQ
%token PLUS
%token PLUSEQ
%token PLUSPLUS
%token QUEST
%token RANGE
%token RANGE_UNTIL
%token RBRACE
%token RBRACKET
//%token REGULAR_STRING_PART
%token RESERVED
%token RETURN_KEYWORD
%token RPAR
%token STRING
%token SEMICOLON
%token SUPER_KEYWORD
%token THIS_KEYWORD
%token THROW_KEYWORD
%token TRUE_KEYWORD
%token TRY_KEYWORD
%token TYPEOF_KEYWORD
%token TYPE_ALIAS_KEYWORD
%token VAL_KEYWORD
%token VAR_KEYWORD
%token WHEN_KEYWORD
%token WHILE_KEYWORD
//%token WHITE_SPACE

%%

input :
    tokens
    ;

tokens :
	token
	| tokens token
	;

token :
	AND
	| ANDAND
	| ARROW
	| AS_KEYWORD
	| AS_SAFE
	| AT
	//| BLOCK_COMMENT
	| BREAK_KEYWORD
	| CHARACTER_LITERAL
	| CLASS_KEYWORD
	//| CLOSING_QUOTE
	| COLON
	| COLONCOLON
	| COMMA
	| CONTINUE_KEYWORD
	//| DANGLING_NEWLINE
	| DIV
	| DIVEQ
	| DOT
	| DOUBLE_ARROW
	| DOUBLE_SEMICOLON
	| DO_KEYWORD
	| ELSE_KEYWORD
	| EOL_COMMENT
	| EQ
	| EQEQ
	| EQEQEQ
	//| ESCAPE_SEQUENCE
	| EXCL
	| EXCLEQ
	| EXCLEQEQEQ
	| FALSE_KEYWORD
	| FIELD_IDENTIFIER
	| FLOAT_LITERAL
	| FOR_KEYWORD
	| FUN_KEYWORD
	| GT
	| GTEQ
	| HASH
	| IDENTIFIER
	| IF_KEYWORD
	| INTEGER_LITERAL
	| INTERFACE_KEYWORD
	//| INTERPOLATION_PREFIX
	| IN_KEYWORD
	| IS_KEYWORD
	| LBRACE
	| LBRACKET
	| LPAR
	| LT
	| LTEQ
	| MINUS
	| MINUSEQ
	| MINUSMINUS
	| MUL
	| MULTEQ
	| NOT_IN
	| NOT_IS
	| NULL_KEYWORD
	| OBJECT_KEYWORD
	//| OPEN_QUOTE
	| OROR
	| PACKAGE_KEYWORD
	| PERC
	| PERCEQ
	| PLUS
	| PLUSEQ
	| PLUSPLUS
	| QUEST
	| RANGE
	| RANGE_UNTIL
	| RBRACE
	| RBRACKET
	//| REGULAR_STRING_PART
	| RESERVED
	| RETURN_KEYWORD
	| RPAR
	| SEMICOLON
	| STRING
	| SUPER_KEYWORD
	| THIS_KEYWORD
	| THROW_KEYWORD
	| TRUE_KEYWORD
	| TRY_KEYWORD
	| TYPEOF_KEYWORD
	| TYPE_ALIAS_KEYWORD
	| VAL_KEYWORD
	| VAR_KEYWORD
	| WHEN_KEYWORD
	| WHILE_KEYWORD
	//| WHITE_SPACE
	;

%%

//%unicode

//%xstate STRING_PREFIX STRING RAW_STRING SHORT_TEMPLATE_ENTRY BLOCK_COMMENT DOC_COMMENT
//%state LONG_TEMPLATE_ENTRY UNMATCHED_BACKTICK

DIGIT [0-9]
DIGIT_OR_UNDERSCORE   [_0-9]
DIGITS  {DIGIT}{DIGIT_OR_UNDERSCORE}*
HEX_DIGIT [0-9A-Fa-f]
HEX_DIGIT_OR_UNDERSCORE   [_0-9A-Fa-f]
WHITE_SPACE_CHAR [ \r\n\t\f]

// TODO: prohibit '$' in identifiers?
//LETTER   [[:letter:]]|_
LETTER   [A-Za-z_]
IDENTIFIER_PART [[:digit:]]|{LETTER}
PLAIN_IDENTIFIER {LETTER}{IDENTIFIER_PART}*
// TODO: this one MUST allow everything accepted by the runtime
// TODO: Replace backticks with one backslash at the beginning
ESCAPED_IDENTIFIER   `[^`\n]+`
IDENTIFIER   {PLAIN_IDENTIFIER}|{ESCAPED_IDENTIFIER}
FIELD_IDENTIFIER   \${IDENTIFIER}

EOL_COMMENT "/""/"[^\n]*
SHEBANG_COMMENT "#!"[^\n]*

LONG_SUFFIX [Ll]
UNSIGNED_SUFFIX [Uu]
TYPED_INTEGER_SUFFIX   {UNSIGNED_SUFFIX}?{LONG_SUFFIX}?
DECIMAL_INTEGER_LITERAL (0|([1-9]({DIGIT_OR_UNDERSCORE})*)){TYPED_INTEGER_SUFFIX}
HEX_INTEGER_LITERAL 0[Xx]({HEX_DIGIT_OR_UNDERSCORE})*{TYPED_INTEGER_SUFFIX}
BIN_INTEGER_LITERAL 0[Bb]({DIGIT_OR_UNDERSCORE})*{TYPED_INTEGER_SUFFIX}
INTEGER_LITERAL {DECIMAL_INTEGER_LITERAL}|{HEX_INTEGER_LITERAL}|{BIN_INTEGER_LITERAL}

FLOATING_POINT_LITERAL_SUFFIX [Ff]
EXPONENT_PART [Ee]["+""-"]?({DIGIT_OR_UNDERSCORE})*
//FLOAT_LITERAL (({FLOATING_POINT_LITERAL1})[Ff])|(({FLOATING_POINT_LITERAL2})[Ff])|(({FLOATING_POINT_LITERAL3})[Ff])|(({FLOATING_POINT_LITERAL4})[Ff])
//DOUBLE_LITERAL (({FLOATING_POINT_LITERAL1})[Dd]?)|(({FLOATING_POINT_LITERAL2})[Dd]?)|(({FLOATING_POINT_LITERAL3})[Dd]?)|(({FLOATING_POINT_LITERAL4})[Dd])
FLOATING_POINT_LITERAL1 ({DIGITS})"."({DIGITS})+({EXPONENT_PART})?({FLOATING_POINT_LITERAL_SUFFIX})?
FLOATING_POINT_LITERAL2 "."({DIGITS})({EXPONENT_PART})?({FLOATING_POINT_LITERAL_SUFFIX})?
FLOATING_POINT_LITERAL3 ({DIGITS})({EXPONENT_PART})({FLOATING_POINT_LITERAL_SUFFIX})?
FLOATING_POINT_LITERAL4 ({DIGITS})({FLOATING_POINT_LITERAL_SUFFIX})
DOUBLE_LITERAL {FLOATING_POINT_LITERAL1}|{FLOATING_POINT_LITERAL2}|{FLOATING_POINT_LITERAL3}|{FLOATING_POINT_LITERAL4}

ESCAPE_SEQUENCE \\(u{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}|[^\n])
CHARACTER_LITERAL "'"([^\\\'\n]|{ESCAPE_SEQUENCE})*("'"|\\)?
// TODO: introduce symbols (e.g. 'foo) as another way to write string literals

INTERPOLATION   \$+
// ANY_ESCAPE_SEQUENCE   \\[^]
THREE_QUO   (\"\"\")
THREE_OR_MORE_QUO   ({THREE_QUO}\"*)

REGULAR_STRING_PART [^\\\"\n\$]+
SHORT_TEMPLATE_ENTRY {INTERPOLATION}{IDENTIFIER}
LONELY_DOLLAR \$+
LONG_TEMPLATE_ENTRY_START {INTERPOLATION}\{
LONELY_BACKTICK `

%%

// Mere mortals

{WHITE_SPACE_CHAR}+ skip() //WHITE_SPACE

{EOL_COMMENT} EOL_COMMENT
{SHEBANG_COMMENT} HASH //SHEBANG_COMMENT

// (Nested) comments
"/*"(?s:.)*?"*/"    skip()

//"/**/" skip() //BLOCK_COMMENT
//
//"/**"<>DOC_COMMENT>
//
//"/*"<>BLOCK_COMMENT>
//
//<BLOCK_COMMENT,DOC_COMMENT>{
//    "/*"<>.>
//    "*/"<<>	skip()
//    [\s\S]<.>
//}

// String templates

\"(\\.|[^"\r\n\\])*\"    STRING

/*
{INTERPOLATION}\" INTERPOLATION_PREFIX

<STRING_PREFIX>{THREE_QUO}<RAW_STRING>      OPEN_QUOTE
<RAW_STRING>\n                  REGULAR_STRING_PART
<RAW_STRING>\"                  REGULAR_STRING_PART
<RAW_STRING>\\                  REGULAR_STRING_PART
<RAW_STRING>{THREE_OR_MORE_QUO}<INITIAL>  CLOSING_QUOTE //REGULAR_STRING_PART

<STRING_PREFIX>\"          OPEN_QUOTE
<STRING>\n<INITIAL>                 DANGLING_NEWLINE
<STRING>\"<INITIAL>                 CLOSING_QUOTE
<STRING>{ESCAPE_SEQUENCE}  ESCAPE_SEQUENCE

<STRING,RAW_STRING>{REGULAR_STRING_PART}         REGULAR_STRING_PART

<STRING,RAW_STRING>{SHORT_TEMPLATE_ENTRY}
                                       {
                                           int interpolationPrefix = 0;
                                           for (int i = 0; i < yylength(); i++) {
                                               if (yycharat(i) == '$') { interpolationPrefix++
                                               else { break
                                           }
                                           int rest = yylength() - interpolationPrefix;
                                           if (interpolationPrefix == requiredInterpolationPrefix) {
                                               pushState(SHORT_TEMPLATE_ENTRY);
                                               yypushback(rest);
                                               return KtTokens.SHORT_TEMPLATE_ENTRY_START;
                                           } else if (interpolationPrefix < requiredInterpolationPrefix) {
                                               yypushback(rest);
                                               return KtTokens.REGULAR_STRING_PART;
                                           } else {
                                               yypushback(requiredInterpolationPrefix + rest);
                                               return KtTokens.REGULAR_STRING_PART;
                                           }
                                       }

// Only *this* keyword is itself an expression valid in this position
// *null*, *true* and *false* are also keywords and expression, but it does not make sense to put them
// in a string template for it'd be easier to just type them in without a dollar
<SHORT_TEMPLATE_ENTRY>"this"<INITIAL>          THIS_KEYWORD
<SHORT_TEMPLATE_ENTRY>{IDENTIFIER}<INITIAL>    IDENTIFIER

<STRING,RAW_STRING>{LONELY_DOLLAR}               REGULAR_STRING_PART

<STRING,RAW_STRING>{LONG_TEMPLATE_ENTRY_START}
                                       {
                                           int interpolationPrefix = yylength() - 1;
                                           if (interpolationPrefix == requiredInterpolationPrefix) {
                                               pushState(LONG_TEMPLATE_ENTRY);
                                               return KtTokens.LONG_TEMPLATE_ENTRY_START;
                                           } else if (interpolationPrefix < requiredInterpolationPrefix) {
                                               yypushback(1);
                                               return KtTokens.REGULAR_STRING_PART;
                                           } else {
                                               yypushback(requiredInterpolationPrefix + 1);
                                               return KtTokens.REGULAR_STRING_PART;
                                           }
                                       }

<LONG_TEMPLATE_ENTRY>"{"              LBRACE
<LONG_TEMPLATE_ENTRY>"}"              RBRACE //LONG_TEMPLATE_ENTRY_END
*/

{INTEGER_LITERAL}\.\. INTEGER_LITERAL
{INTEGER_LITERAL} INTEGER_LITERAL

{DOUBLE_LITERAL}     FLOAT_LITERAL

{CHARACTER_LITERAL} CHARACTER_LITERAL

"typealias"  TYPE_ALIAS_KEYWORD
"interface"  INTERFACE_KEYWORD
"continue"   CONTINUE_KEYWORD
"package"    PACKAGE_KEYWORD
"return"     RETURN_KEYWORD
"object"     OBJECT_KEYWORD
"while"      WHILE_KEYWORD
"break"      BREAK_KEYWORD
"class"      CLASS_KEYWORD
"throw"      THROW_KEYWORD
"false"      FALSE_KEYWORD
"super"      SUPER_KEYWORD
"typeof"     TYPEOF_KEYWORD
"when"       WHEN_KEYWORD
"true"       TRUE_KEYWORD
"this"       THIS_KEYWORD
"null"       NULL_KEYWORD
"else"       ELSE_KEYWORD
"try"        TRY_KEYWORD
"val"        VAL_KEYWORD
"var"        VAR_KEYWORD
"fun"        FUN_KEYWORD
"for"        FOR_KEYWORD
"is"         IS_KEYWORD
"in"         IN_KEYWORD
"if"         IF_KEYWORD
"do"         DO_KEYWORD
"as"         AS_KEYWORD

{FIELD_IDENTIFIER} FIELD_IDENTIFIER
{IDENTIFIER} IDENTIFIER
\!in{IDENTIFIER_PART}        EXCL
\!is{IDENTIFIER_PART}        EXCL

"..."        RESERVED
"==="        EQEQEQ
"!=="        EXCLEQEQEQ
"!in"        NOT_IN
"!is"        NOT_IS
"as?"        AS_SAFE
"++"         PLUSPLUS
"--"         MINUSMINUS
"<="         LTEQ
">="         GTEQ
"=="         EQEQ
"!="         EXCLEQ
"&&"         ANDAND
"&"          AND
"||"         OROR
"*="         MULTEQ
"/="         DIVEQ
"%="         PERCEQ
"+="         PLUSEQ
"-="         MINUSEQ
"->"         ARROW
"=>"         DOUBLE_ARROW
".."         RANGE
"..<"        RANGE_UNTIL
"::"         COLONCOLON
"["          LBRACKET
"]"          RBRACKET
"{"          LBRACE
"}"          RBRACE
"("          LPAR
")"          RPAR
"."          DOT
"*"          MUL
"+"          PLUS
"-"          MINUS
"!"          EXCL
"/"          DIV
"%"          PERC
"<"          LT
">"          GT
"?"          QUEST
":"          COLON
";;"         DOUBLE_SEMICOLON
";"          SEMICOLON
"="          EQ
","          COMMA
"#"          HASH
"@"          AT

//{LONELY_BACKTICK} { pushState(UNMATCHED_BACKTICK); return TokenType.BAD_CHARACTER

// error fallback
//[\s\S]       { return TokenType.BAD_CHARACTER
// error fallback for exclusive states
//<STRING, RAW_STRING, SHORT_TEMPLATE_ENTRY, BLOCK_COMMENT, DOC_COMMENT> .	BAD_CHARACTER

%%
