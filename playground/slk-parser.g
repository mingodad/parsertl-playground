//From: http://www.slkpg.site/

/*
Rule header should start at the begining of a line
*/

%token ID RULE_ID TOK ACTION ALT_RHS EPSILON

%%

grammar :
    rules
    ;

rules :
    rule
    | rules rule
    ;

rule :
    lhs alt_rhs
    ;

lhs :
    RULE_ID
    ;

alt_rhs :
    rhs ALT_RHS
    | alt_rhs rhs ALT_RHS
    ;

rhs :
    EPSILON
    | rhs_seq
    ;

rhs_seq :
    rhs_elm
    | rhs_seq rhs_elm
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

%x alt_rhs alt_epsilon

base_id [A-Za-z_][A-Za-z0-9_]*

rule_sep ":"|"::="|"-->"|":="|"->"|"="|":?"|":!"

tok	"\\"?[^A-Za-z\n]
action	"__"{base_id}|"_action_"{base_id}
epsilon _epsilon_

%%

[\n\r\t ]+    skip()
"/*"(?s:.)*?"*/"    skip()
"//".*  skip()

<INITIAL,alt_rhs> {
    "{" '{'
    "}" '}'
    "[" '['
    "]" ']'
    "}+" "}+"
}
{epsilon}<alt_epsilon>   EPSILON
{tok}<alt_rhs> TOK
{action}<alt_rhs>   ACTION
{base_id}<alt_rhs> ID

<alt_rhs,alt_epsilon> {
    [\r\t ]+    skip()
    \n<INITIAL> ALT_RHS
}

<alt_rhs> {
    {tok} TOK
    {action}<alt_rhs>   ACTION
    {base_id} ID
}

^{base_id}\s*{rule_sep}   RULE_ID

%%
