%token name MODULE IMPORT SEMI

%%

translation_unit :
	%empty
	| top_level_statements
	;

top_level_statements :
	top_level
	| top_level_statements top_level
	;

top_level :
	module
	| import
	;

module :
	MODULE name SEMI
	;

import :
	IMPORT name SEMI
	;

%%

%%

[ \t\r\n]	skip()

";"	SEMI

"import"	IMPORT
"module"	MODULE

[A-Za-z_][A-Za-z0-9_]*	name

%%
