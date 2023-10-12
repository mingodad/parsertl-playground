// Calculator from flex & bison book.
//Directives
%token INTEGER '(' ')'
%left '+' '-'
%left '*' '/'
%precedence UMINUS

%% //Grammar rules
start : exp ;
exp :
    exp '+' exp #expPlus
    | exp '-' exp #expMinus
    | exp '*' exp #expMulti
    | exp '/' exp #expDiv
    | '(' exp ')'
    | '-' exp %prec UMINUS #expNeg
    | INTEGER
    ;

//Regex macros
%%

%%

[0-9]+	INTEGER

\+	'+'
-	'-'
\*	'*'
\/	'/'
\(	'('
\)	')'
[ \t\n\r]	skip()

%%
