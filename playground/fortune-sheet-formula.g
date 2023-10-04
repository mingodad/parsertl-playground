//From: https://github.com/ruilisi/fortune-sheet/blob/3a0a0ad40a38f8e931fc7f5069964dcecaaae93b/packages/formula-parser/src/grammar-parser/grammar-parser.jison
/* description: Parses end evaluates mathematical expressions. */

%token STRING FUNCTION ERROR ABSOLUTE_CELL MIXED_CELL RELATIVE_CELL
%token VARIABLE NUMBER ARRAY DECIMAL NOT

/* operator associations and precedence (low-top, high-bottom) */
%left '='
%left "<=" ">=" "<>" NOT
%left '>' '<'
%left '+' '-'
%left '*' '/'
%left '^'
%left '&'
%left '%'
%left UMINUS

%start expressions

%%
/* language grammar */

expressions
  : expression //EOF
;

expression
  : variableSequence
  | number
  | STRING
  | expression '&' expression
  | expression '=' expression
  | expression '+' expression
  | '(' expression ')'
  | expression "<=" expression
  | expression ">=" expression
  | expression "<>" expression
  | expression NOT expression
  | expression '>' expression
  | expression '<' expression
  | expression '-' expression
  | expression '*' expression
  | expression '/' expression
  | expression '^' expression
  | '-' expression
  | '+' expression
  | FUNCTION '(' ')'
  | FUNCTION '(' expseq ')'
  | cell
  | error
  | error error
;

cell
   : ABSOLUTE_CELL
  | RELATIVE_CELL
  | MIXED_CELL
  | ABSOLUTE_CELL ':' ABSOLUTE_CELL
  | ABSOLUTE_CELL ':' RELATIVE_CELL
  | ABSOLUTE_CELL ':' MIXED_CELL
  | RELATIVE_CELL ':' ABSOLUTE_CELL
  | RELATIVE_CELL ':' RELATIVE_CELL
  | RELATIVE_CELL ':' MIXED_CELL
  | MIXED_CELL ':' ABSOLUTE_CELL
  | MIXED_CELL ':' RELATIVE_CELL
  | MIXED_CELL ':' MIXED_CELL
;

expseq
  : expression
  | ARRAY
  | expseq ';' expression
  | expseq ',' expression
;

variableSequence
  : VARIABLE
  | variableSequence DECIMAL VARIABLE
;

number
  : NUMBER
  | NUMBER DECIMAL NUMBER
  | number '%'
;

error
  : ERROR
;

%%

%x FUNC_ST

FUNC   [A-Za-z]{1,}[A-Za-z_0-9.]+|[A-Za-z.]+

%%

/* lexical grammar */

\s+                                                                                             skip()
\"("\\"["]|[^"])*\"                                                                           STRING
"'"('\\'[']|[^'])*"'"                                                                           STRING
{FUNC}[(]<FUNC_ST>    reject()
"#"[A-Z0-9/]+[!?]?                                                                        ERROR
"$"[A-Za-z]+"$"[0-9]+                                                                           ABSOLUTE_CELL
"$"[A-Za-z]+[0-9]+                                                                              MIXED_CELL
[A-Za-z]+"$"[0-9]+                                                                              MIXED_CELL
[A-Za-z]+[0-9]+                                                                                 RELATIVE_CELL
[A-Za-z]{1,}[A-Za-z_0-9]+                                                                       VARIABLE
[A-Za-z_]+                                                                                      VARIABLE
[0-9]+                                                                                          NUMBER
"["(.*)?"]"                                                                                     ARRAY

<FUNC_ST> {
    {FUNC}<INITIAL>    FUNCTION
    .<INITIAL>  reject()
}

"&"                                                                                             '&'
[.]                                                                                             DECIMAL
":"                                                                                             ':'
";"                                                                                             ';'
","                                                                                             ','
"*"                                                                                             '*'
"/"                                                                                             '/'
"-"                                                                                             '-'
"+"                                                                                             '+'
"^"                                                                                             '^'
"("                                                                                             '('
")"                                                                                             ')'
">"                                                                                             '>'
"<"                                                                                             '<'
"NOT"                                                                                           NOT
//"!"                                                                                             '!'
"="                                                                                             '='
"%"                                                                                            '%'

"<="	"<="
">="	">="
"<>"	"<>"

//[#]                                                                                             '#'
//<<EOF>>                                                                                         EOF

%%
