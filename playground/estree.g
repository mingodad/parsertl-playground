//From: https://github.com/xp44mm/ESTreeParser/blob/1f728480b912e778a5492906ff939a4ae7651e89/ESTreeParser/estree.fsyacc

%token INTERFACE
%token ID
%token EXTEND
%token QUOTED
%token ENUM

%left "|"

%%

file :
	definitions
	;

definitions :
	definition
	| definitions definition
	;

definition :
	interfaceDefinition
	| enumDefinition
	;

interfaceDefinition :
	interfaceHead interfaceBody
	;

interfaceHead :
	INTERFACE ID
	| EXTEND INTERFACE ID
	| INTERFACE ID "<:" ids
	| EXTEND INTERFACE ID "<:" ids
	;

ids :
	ID
	| ids "," ID
	;

interfaceBody :
	"{" "}"
	| "{" fields "}"
	;

fields :
	field
	| fields field
	;

field :
	ID ":" annotation ";"
	;

annotation :
	QUOTED
	| ID
	| annotation "|" annotation
	| "[" annotation "]"
	| interfaceBody
	;

enumDefinition :
	enumHead enumBody
	;

enumHead :
	ENUM ID
	| EXTEND ENUM ID
	;

enumBody :
	"{" "}"
	| "{" cases "}"
	;

cases :
	QUOTED
	| cases "|" QUOTED
	;

%%

%%

[\n\r\t ]+ skip()
"//".*  skip()

interface	INTERFACE
extend	EXTEND
enum	ENUM
"<:"	"<:"
","	","
"{"	"{"
"}"	"}"
":"	":"
";"	";"
"|"	"|"
"["	"["
"]"	"]"

\"(\\.|[^"\n\r\\])*\"	QUOTED
'(\\.|[^'\n\r\\])*'	QUOTED
[A-Za-z_][A-Za-z0-9_]*	ID

%%
