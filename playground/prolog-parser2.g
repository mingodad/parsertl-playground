//From: https://github.com/mariushegele/rapid/blob/0a95af9c67aece160768efe09de9a7ad44e62d54/rapid.y

%token left_arrow is
%token atom variable
%token num real
//%token string
%token open_round_brackets close_round_brackets
%token open_square_brackets close_square_brackets
%token pipesym
%token dot comma
%token smaller greater equal colon whatthehell
%token plus minus times divby
%token comment ml_comment
%token end

%start S

%left smaller greater equal

%left plus minus
%left times divby

%%

S :
	Clause
	| S Clause
	| S Comment
	| Comment
	| S end
	| end
	;

Clause :
	Rule
	| Fact
	;

Rule :
	Predicate left_arrow PredicateList dot
	;

Fact :
	Predicate dot
	;

PredicateList :
	Predicate
	| PredicateList comma Predicate
	;

Predicate :
	atom open_round_brackets TermList close_round_brackets
	| Condition
	| Assignment
	;


TermList :
	Term
	| TermList comma Term
	;

Term :
	Operand
	| List
	| Function
	;

Function :
	atom open_round_brackets TermList close_round_brackets
	;

List :
	open_square_brackets close_square_brackets
	| open_square_brackets Operand close_square_brackets
	| open_square_brackets List close_square_brackets
	| open_square_brackets List comma List close_square_brackets
	| open_square_brackets Operand pipesym RestList close_square_brackets
	;

RestList :
	List
	| Operand
	;


Operand :
	variable
	| Operation
	| Constant
	;

Constant :
	num
	| real
	;

 Operation :
	open_round_brackets Operation close_round_brackets
	| Operand plus Operand
	| Operand minus Operand
	| Operand times Operand
	| Operand divby Operand
	;

Condition :
	Operand greater Operand
	| Operand smaller Operand
	| Operand greater equal Operand
	| Operand equal smaller Operand
	| Operand equal equal Operand
	| Operand equal colon equal Operand
	| Operand equal whatthehell equal Operand
	| Operand whatthehell equal equal Operand
	| Term is Operand
	;

Assignment :
	Operand equal Operand
	| Operand whatthehell equal Operand
	;

Comment :
	comment
	| ml_comment
	;

%%

num [1-9][0-9]*|0
real {num}\.[0-9]+

%%

[ \t]+	skip()
"%".*	comment
"/*"(?s:.)*?"*/"	ml_comment

")"	close_round_brackets
"]"	close_square_brackets
":"	colon
","	comma
"/"	divby
"."	dot
\r\n|\n	end
"="	equal
">"	greater
"is"	is
":-"	left_arrow
"-"	minus
"("	open_round_brackets
"["	open_square_brackets
"|"	pipesym
"+"	plus
"<"	smaller
"*"	times
"\\"	whatthehell

//\"[a-zA-Z0-9]*\"	string
{num}	num
{real}	real
[a-z][a-zA-Z0-9_]*	atom
[A-Z_][a-zA-Z0-9_]*	variable

%%
