//From: https://github.com/lvln/thayer_parsers/blob/d799cb760779a5aad917f23e2fa6c9d5522c4eab/abnf/bison/abnf.y#L1

%token REPEAT_ZOM REPEAT_OOM
%token RULE_HEAD RULENAME NUM_VAL CHAR_VAL PROSE_VAL

%%
/* The ABNF Grammar */
rulelist:
    rule | rulelist rule
    ;

rule:
    RULE_HEAD elements
    ;

elements:
    alternation
    ;

alternation:
    concatenation
    | alternation '/' concatenation
    ;

concatenation:
    repetition
    | concatenation repetition
    ;

repetition:
     repeat element
     ;

// repeat = 1*DIGIT / (*DIGIT "*" *DIGIT)
repeat:
    %empty
    | REPEAT_ZOM
    | REPEAT_OOM
    ;

element:
   RULENAME | group | option | CHAR_VAL | NUM_VAL | PROSE_VAL
   ;

group:
    '(' alternation ')'
    ;

option:
    '['  alternation  ']'
    ;

%%

ident [A-Za-z-][A-Za-z0-9-]*

%%

[ \t\r\n]+  skip()
";".*   skip()

"/"	'/'
"("	'('
")"	')'
"["	'['
"]"	']'



"%"[-]?([Bb][0-1]+|[Dd][0-9]+("."[0-9]+)?|[xX][0-9A-Fa-f]+("."[0-9A-Fa-f]+)?)   NUM_VAL

"*" REPEAT_ZOM
"1*"[1-9]*    REPEAT_OOM

'(\\.|[^'\r\n\\])+'    CHAR_VAL
\"(\\.|[^"\r\n\\])+\"    CHAR_VAL
{ident}\s*"=""/"?   RULE_HEAD
{ident}  RULENAME
"<"(?s:.)+">"   PROSE_VAL

%%
