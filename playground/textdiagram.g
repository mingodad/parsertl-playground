 //From: https://github.com/weidagang/text-diagram

%token object_id size EOS text side

%%

program : statement* ;
statement : object_declaration | message_statement | note_statement | space_statement ;
object_declaration : "object" object_id+ EOS ;
message_statement : object_id "->" object_id content? EOS ;
note_statement : "note" side "of" object_id content EOS ;
space_statement : "space" size EOS ;
content : text ;

%%

%%

[ \t]	skip()

("left"|"right")	side
"object"	"object"
"space"	"space"
"note"	"note"
"->"	"->"
"of"	"of"
":"[^\n;]+	text

[a-zA-Z_][a-zA-Z0-9_]*	object_id
[0-9]+	size /*integer*/

[;\n]	EOS

%%
