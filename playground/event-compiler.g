//From: https://github.com/compiler-dept/event-compiler/blob/c58cbab4d03b367a7b488f802f71b675bbb38d7e/src/parser.y

%token  SEMIC EVENT TYPE LBRACE RBRACE EXTENDS
%token  COMMA IDENTIFIER COLON RARROW LBRACKET RBRACKET
%token  PREDICATE LPAREN RPAREN DEF ASSIGN EQ
%token  NEQ GT LT ADD SUB MULT
%token  DIV POW DOT NUMBER


%start translation_unit

%%

translation_unit : declaration_sequence ;
//translation_unit : error ;

declaration_sequence : declaration_sequence declaration ;
declaration_sequence : declaration ;

declaration : event_declaration SEMIC ;
declaration : rule_declaration SEMIC ;
declaration : predicate_definition SEMIC ;
declaration : function_definition SEMIC ;

event_declaration : EVENT TYPE LBRACE member_sequence RBRACE ;
event_declaration : EVENT TYPE EXTENDS TYPE LBRACE member_sequence RBRACE ;

member_sequence : member_sequence COMMA member ;
member_sequence : member ;

member : IDENTIFIER ;

rule_declaration : TYPE COLON rule_signature RARROW IDENTIFIER ;

rule_signature : LBRACKET event_sequence COLON predicate_sequence RBRACKET ;
rule_signature : LBRACKET event_sequence RBRACKET ;
rule_signature : LBRACKET RBRACKET ;

event_sequence : event_sequence COMMA event ;
event_sequence : event ;

event : TYPE ;

predicate_sequence : predicate_sequence COMMA predicate ;
predicate_sequence : predicate ;

predicate : IDENTIFIER ;

predicate_definition : PREDICATE IDENTIFIER LPAREN parameter_list RPAREN DEF expression ;

function_definition : TYPE IDENTIFIER LPAREN RPAREN DEF expression ;
function_definition : TYPE IDENTIFIER LPAREN parameter_list RPAREN DEF expression ;

parameter_list : parameter_list COMMA parameter ;
parameter_list : parameter ;

parameter : TYPE IDENTIFIER ;

function_call : IDENTIFIER LPAREN argument_sequence RPAREN ;
function_call : IDENTIFIER LPAREN RPAREN ;

argument_sequence : expression_sequence ;

event_definition : LBRACE initializer_sequence RBRACE ;

initializer_sequence : initializer_sequence COMMA initializer ;
initializer_sequence : initializer ;

initializer : IDENTIFIER ASSIGN expression ;

vector : LBRACKET component_sequence RBRACKET ;

component_sequence : expression_sequence ;

expression_sequence : expression_sequence COMMA expression ;
expression_sequence : expression ;

expression : comparison_expression ;

comparison_expression : additive_expression EQ additive_expression ;
comparison_expression : additive_expression NEQ additive_expression ;
comparison_expression : additive_expression GT additive_expression ;
comparison_expression : additive_expression LT additive_expression ;
comparison_expression : additive_expression ;

additive_expression : addition ;
additive_expression : multiplicative_expression ;

addition : additive_expression ADD multiplicative_expression ;
addition : additive_expression SUB multiplicative_expression ;

multiplicative_expression : multiplication ;
multiplicative_expression : negation ;

multiplication : multiplicative_expression MULT negation ;
multiplication : multiplicative_expression DIV negation ;

negation : SUB negation ;
negation : power ;

power : primary_expression POW primary_expression ;
power : primary_expression ;

primary_expression : LPAREN expression RPAREN ;
primary_expression : atomic ;

atomic : IDENTIFIER DOT IDENTIFIER ;
atomic : IDENTIFIER ;
atomic : NUMBER ;
atomic : vector ;
atomic : event_definition ;
atomic : function_call ;

%%

%%

"event"              EVENT
"extends"            EXTENDS
"predicate"          PREDICATE
[A-Z][a-zA-Z0-9_]*   TYPE
[a-z][a-zA-Z0-9_]*   IDENTIFIER
[0-9]+(\.[0-9]+)?    NUMBER
[ \t\n]+             skip()
"/*"(?s:.)*?"*/"    skip()
"=="                 EQ
"!="                 NEQ
">"                  GT
"<"                  LT
"->"                 RARROW
":="                 DEF
"."                  DOT
":"                  COLON
","                  COMMA
";"                  SEMIC
"{"                  LBRACE
"}"                  RBRACE
"["                  LBRACKET
"]"                  RBRACKET
"("                  LPAREN
")"                  RPAREN
"="                  ASSIGN
"+"                  ADD
"-"                  SUB
"*"                  MULT
"/"                  DIV
"^"                  POW


%%
