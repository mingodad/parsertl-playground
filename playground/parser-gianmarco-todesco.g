//From: https://github.com/gianmarco-todesco/Parser/blob/32d0873f9d79c0ff8af733a7e5e3fde80cd10062/src/grammarbuilder.cpp

%token id qstring number NL

%%

StmLst : ;//List
//StmLst : StmLst ;//pass,1
StmLst : StmLst Stm ;//List,1+2

Stm : NL ;
Stm : id "->" right action NL ; //Rule, 0x19

right : ; //Right
right : right id ; //Right
right : right qstring ; //Right

action : ;
action : ':' "pass" ; //Action,0x2
action : ':' "pass" '(' number ')' ; //Action,0xA
action : ':' "null" ; //Action,0x2
action : ':' id '(' IntLst ')' ; //Action,0xA
action : ':' id ; //Action,0x2

IntLst : number ; //IntLst
IntLst : IntLst ',' number ; //IntLst,0x5

%%

%%

[ \t\r]+	skip()
\n  NL

"("	'('
")"	')'
","	','
"->"	"->"
":"	':'
"null"	"null"
"pass"	"pass"

'(\\.|[^'\r\n\\])+'	qstring
\"(\\.|[^"\r\n\\])+\"	qstring

[0-9]+	number
[A-Za-z_][A-Za-z0-9_]*	id

%%
