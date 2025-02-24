//From: https://github.com/ruuda/rcl/blob/26c10ec70c5d52a978762f29452c8a30e452f398/grammar/bison/grammar.y
// This file contains a Bison grammar for RCL. It is not intended to be used
// directly, there is a hand-written recursive descent parser in src/parser.rs
// instead. However to inform the structure of the hand-written one, it is nice
// to have the grammar in a concise format that is readable by humans and
// machines. In particular, Bison will warn about ambiguities.

// The grammar aims to be parsable with a recursive descent parser, but it's not
// strictly LL(k) because some rules contain left recursion. All of the cases
// that do though, have a clear token immediately following to still decide the
// production.

// Inspect with: bison --feature=syntax-only -Wcounterexamples src/grammar.y

%token IDENT STRING NUMBER UNOP BINOP FSTRING_OPEN FSTRING_INNER FSTRING_CLOSE

%%

expr
  : expr_op
  | expr_stmt
  | expr_if
  ;

expr_stmt: stmt expr;
expr_if: "if" expr_op ':' expr "else" ':' expr;
expr_import: "import" expr;

// There is no operator precedence, so if there is an operator, its args must
// not themselves contain operators. One exception is that if the operator is
// the same, it may be repeated more than once, e.g. "a + b + c" does not need
// to be written as "(a + b) + c". But "a + b * c" does need to be written as
// "a + (b * c)".
expr_op
  : expr_import
  | expr_function
  | UNOP expr_unop
  | expr_not_op BINOP expr_binop
  | expr_not_op
  ;

expr_function: function_args "=>" expr;

// The function args grammar here is a bit of a hack. The options should really
// be `IDENT | '(' function_args_inner ')'`. However, for the input `( IDENT )`,
// that produces an ambiguity between expr_function and expr_term, which Bison
// cannot resolve with a single token lookahead, and it produces a reduce/reduce
// conflict. In the actual parser we solve this by looking further ahead for the
// `=>`. Here, to make Bison happy, we rule out `(x) =>` as a function by
// demanding the trailing comma.
function_args
  : IDENT
  | '(' ')'
  | '(' IDENT ',' function_args_inner ')'
  ;

function_args_inner
  : %empty
  | IDENT
  | function_args_inner ',' IDENT
  ;

expr_unop: expr_not_op | UNOP expr_unop;

// This rule for binop is simplified here. In reality, there should be a
// dedicated one for every binop, so you can repeat the same binop without
// parens, but you cannot mix multiple different ones. To keep this file simple,
// we don't expand it out here and we have just one generic binop.
expr_binop: expr_not_op | expr_not_op BINOP expr_binop;

// Because we disallow confusing operator combinations without parens, the nodes
// of an operator are "not binary operator", "not binop" for short.
expr_not_op
  : expr_term
  | expr_not_op '(' call_args ')'
  | expr_not_op '[' expr ']'
  | expr_not_op '.' IDENT
  ;

call_args
  : %empty
  | expr
  | call_args ',' expr
  ;

expr_term
  : '{' seqs '}'
  | '{' seqs ',' '}'
  | '[' seqs ']'
  | '[' seqs ',' ']'
  | '(' expr ')'
  | FSTRING_OPEN fstring
  | STRING
  | NUMBER
  | IDENT
  ;

fstring
  : expr FSTRING_CLOSE
  | expr FSTRING_INNER fstring
  ;

stmt
  : "let" IDENT optional_type_hint '=' expr ';'
  | "assert" expr ',' expr ';'
  | "trace" expr ';'
  ;

optional_type_hint
  : %empty
  | ':' type_expr
  ;

seqs
  : %empty
  | seq
  | seqs ',' seq
  ;

// Note, here we use expr_op instead of expr to avoid a conflict with the let
// and for from the comprehension.
seq
  : expr_op
  | expr_op ':' expr
  | IDENT '=' expr //',' seq
  | stmt seq
  | "for" idents "in" expr_op ':' seq
  | "if" expr_op ':' seq
  ;

idents: IDENT | idents ',' IDENT;

type_expr
  // Note, we could allow single-argument function types without the parens as
  // well, but let's keep it simple for now and require the parens on function
  // types.
  : '(' types ')' "->" type_expr
  | type_term '[' types ']'
  | type_term
  ;

types
  : %empty
  | type_expr
  | types ',' type_expr
  ;

type_term: IDENT;

%%

%%

[ \t\r\n]+	skip()
"#!".*	skip()
"//".*	skip()

"("	'('
")"	')'
","	','
"->"	"->"
"."	'.'
":"	':'
";"	';'
"="	'='
"=>"	"=>"
"["	'['
"]"	']'
"assert"	"assert"
"else"	"else"
"for"	"for"
"if"	"if"
"import"	"import"
"in"	"in"
"let"	"let"
"trace"	"trace"
"{"	'{'
"}"	'}'

"<="|">="|"=="|"!="|"=>"|"<"|">"|"+"|"-"|"*"|"/"|"|"|"and"|"or"	BINOP
"not"	UNOP
\"(\\.|[^"\r\n\\])*\"	STRING
FSTRING_CLOSE	FSTRING_CLOSE
FSTRING_INNER	FSTRING_INNER
FSTRING_OPEN	FSTRING_OPEN

"0b"[01_]+	NUMBER
"0x"[0-9a-fA-F_]+	NUMBER
[0-9_]+(\.[0-9_]+)?([eE][+-]?[0-9_]+)?	NUMBER

[_A-Za-z][-_A-Za-z0-9]*	IDENT

%%
