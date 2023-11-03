//From: http://www.slkpg.site/

%token ID RULE_ID TOK ACTION

%%

grammar :
    rules
    ;

rules :
    rule
    | rules rule
    ;

rule :
    lhs rhs
    ;

lhs :
    RULE_ID
    ;

rhs :
    rhs_elm
    | rhs rhs_elm
    ;

rhs_elm :
    ID
    | TOK
    | ACTION
    | repeat_elm
    ;

repeat_elm :
    '{' rhs '}' #RepZOM
    | '{' rhs "}+" #RepOOM
    | '[' rhs ']' #RepOOZ
    ;

%%

base_id [A-Za-z_][A-Za-z0-9_]*

rule_sep ":"|"::="|"-->"|":="|"->"|"="|":?"|":!"

%%

[\n\r\t ]+    skip()
"/*"(?s:.)*?"*/"    skip()
"//".*  skip()

"{" '{'
"}" '}'
"[" '['
"]" ']'
"}+" "}+"

/*
":" RULE_SEP
"::=" RULE_SEP
"-->" RULE_SEP
":=" RULE_SEP
"->" RULE_SEP
"=" RULE_SEP
":?" RULE_SEP
":!" RULE_SEP
*/

"\\"?[^A-Za-z\n] TOK

"__"{base_id}   ACTION
"__action_"{base_id}   ACTION
{base_id} ID
^\s*{base_id}\s*{rule_sep}   RULE_ID

%%