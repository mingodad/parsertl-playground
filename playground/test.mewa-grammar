% LANGUAGE language1;
% TYPESYSTEM "language1/typesystem";
% CMDLINE "cmdlinearg";
# @description C style comments
# @rule	COMMENT ::= "/*" ... "*/"
% COMMENT "/*" "*/";
# @description C++ style end of line comments
# @rule	COMMENT ::= "//" ... "\\n"
% COMMENT "//";

# @rule BOOLEAN ::= "true" | "false"
BOOLEAN : '((true)|(false))';
# @rule LOALPHA ::= "a"|"b"|"c"|"d"|"e"|"f"|"g"|"h"|"i"|"j"|"k"|"l"|"m"|"n"|"o"|"p"|"q"|"r"|"s"|"t"|"u"|"v"|"w"|"x"|"y"|"z"
#	HIALPHA ::= "A"|"B"|"B"|"D"|"E"|"F"|"G"|"H"|"I"|"J"|"K"|"L"|"M"|"N"|"O"|"P"|"Q"|"R"|"S"|"T"|"U"|"V"|"W"|"X"|"Y"|"Z"
#	USCORE  ::= "_"
#	IDENT   ::= (LOALPHA | HIALPHA | USCORE) (LOALPHA | HIALPHA | USCORE | DIGIT)*
IDENT	: '[a-zA-Z_]+[a-zA-Z_0-9]*';
# @rule DQSTRING ::= [double quoted string]
# @description Double quoted string with backslash are used for escaping double quotes and back slashes in the string
DQSTRING: '["]((([^\\"\n]+)|([\\][^"\n]))*)["]' 1;
# @rule SQSTRING ::= [single quoted string]
# @description Single quoted string with backslash are used for escaping single quotes and back slashes in the string
SQSTRING: "[']((([^\\'\n]+)|([\\][^'\n]))*)[']" 1;
# @rule DIGIT ::= ("0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9")
#	UINTEGER ::= DIGIT*
UINTEGER: '[0123456789]+';
# @rule FLOAT ::= DIGIT* "." DIGIT+
FLOAT	: '[0123456789]*[.][0123456789]+';
# @rule EXPONENT ::= ("E"|"e") (("-"|"+") DIGIT+ | DIGIT+)
#	FLOAT ::= DIGIT* "." DIGIT+ EXPONENT
FLOAT	: '[0123456789]*[.][0123456789]+[Ee][+-]{0,1}[0123456789]+';
# @description Numbers must not be followed immediately by an identifier
ILLEGAL	: '[0123456789]+[A-Za-z_]';
ILLEGAL	: '[0123456789]*[.][0123456789]+[A-Za-z_]';
ILLEGAL	: '[0123456789]*[.][0123456789]+[Ee][+-]{0,1}[0123456789]+[A-Za-z_]';

# @startsymbol program
program		   	= extern_definitionlist free_definitionlist main_procedure			(program)
			;
extern_definitionlist	= extern_definition extern_definitionlist
			| ε
			;
free_definitionlist	= free_definition free_definitionlist
			| ε
			;
namespace_definitionlist= namespace_definition namespace_definitionlist
			| ε
			;
instruct_definitionlist	= instruct_definition instruct_definitionlist
			| ε
			;
inclass_definitionlist	= inclass_definition inclass_definitionlist
			| ε
			;
ininterf_definitionlist	= ininterf_definition ininterf_definitionlist
			| ε
			;
extern_definition	= "extern" DQSTRING "function" IDENT typespec "(" extern_paramlist ")" ";"	(extern_funcdef)
			| "extern" DQSTRING "procedure" IDENT "(" extern_paramlist ")" ";"		(extern_procdef)
			| "extern" DQSTRING "function" IDENT typespec "(" extern_paramlist "..." ")" ";"(extern_funcdef_vararg)
			| "extern" DQSTRING "procedure" IDENT "(" extern_paramlist "..." ")" ";"	(extern_procdef_vararg)
			;
extern_paramdecl	= typespec IDENT								(extern_paramdef)
			| typespec									(extern_paramdef)
			;
extern_parameters 	= extern_paramdecl "," extern_parameters					(extern_paramdef_collect)
			| extern_paramdecl								(extern_paramdef_collect)
			;
extern_paramlist	= extern_parameters								(extern_paramdeflist)
			| ε										(extern_paramdeflist)
			;
ininterf_definition 	= "function" IDENT typespec "(" extern_paramlist ")" funcattribute ";"		(interface_funcdef)
			| "procedure" IDENT "(" extern_paramlist ")" funcattribute ";"			(interface_procdef)
			| "operator" operatordecl typespec "(" extern_paramlist ")" funcattribute ";"	(interface_operator_funcdef)
			| "operator" operatordecl "(" extern_paramlist ")" funcattribute ";"		(interface_operator_procdef)
			;
funcattribute		= "const" funcattribute								(funcattribute {const=true})
			| "nothrow" funcattribute							(funcattribute {throws=false})
			| ε										(funcattribute {const=false,throws=true})
			;
instruct_definition	= typedefinition ";"								(definition 1)
			| variabledefinition ";"							(definition 2)
			| structdefinition								(definition 1)
			;
inclass_definition	= typedefinition ";"								(definition 1)
			| variabledefinition ";"							(definition 2)
			| structdefinition								(definition 1)
			| classdefinition 								(definition 1)
			| interfacedefinition								(definition 1)
			| functiondefinition								(definition_2pass 4)
			| operatordefinition								(definition_2pass 4)
			| constructordefinition								(definition_2pass 4)
			;
free_definition		= namespacedefinition
			| typedefinition ";"								(definition 1)
			| variabledefinition ";"							(definition 1)
			| structdefinition								(definition 1)
			| classdefinition 								(definition 1)
			| interfacedefinition								(definition 1)
			| functiondefinition								(definition 1)
			;
namespace_definition	= namespacedefinition								(definition 1)
			| typedefinition ";"								(definition 1)
			| structdefinition								(definition 1)
			| classdefinition 								(definition 1)
			| interfacedefinition								(definition 1)
			| functiondefinition								(definition 1)
			;
typename/L1		= IDENT
			| IDENT "::" typename
			;
typehdr/L1		= typename									(typehdr {const=false})
			| "const" typename								(typehdr {const=true})
			| "any" "class" "^"								(typehdr_any "any class^")
			| "any" "const" "class" "^"							(typehdr_any "any const class^")
			| "any" "struct" "^"								(typehdr_any "any struct^")
			| "any" "const" "struct" "^"							(typehdr_any "any const struct^")
			;
typegen/L1		= typehdr
			| typegen "[" generic_instance "]"						(typegen_generic)
			| typegen "^"									(typegen_pointer {const=false})
			| typegen "const" "^"								(typegen_pointer {const=true})
			;
typespec/L1		= typegen									(typespec)
			| typegen "&"									(typespec_ref)
			;
typedefinition		= "typedef" typegen IDENT							(typedef)
			| "typedef" "function" IDENT typespec "(" extern_paramlist ")" 			(typedef_functype {throws=true})
			| "typedef" "procedure" IDENT "(" extern_paramlist ")"				(typedef_proctype {throws=true})
			| "typedef" "function" IDENT typespec "(" extern_paramlist ")" "nothrow" 	(typedef_functype {throws=false})
			| "typedef" "procedure" IDENT "(" extern_paramlist ")" "nothrow"		(typedef_proctype {throws=false})
			;
structdefinition	= "struct" IDENT "{" instruct_definitionlist "}"				(structdef)
			| "generic" "struct" IDENT "[" generic_header "]"
				"{" instruct_definitionlist "}"						(generic_structdef)
			;
interfacedefinition	= "interface" IDENT "{" ininterf_definitionlist "}"				(interfacedef)
			;
inheritlist		= typegen "," inheritlist							(inheritdef 1)
			| typegen									(inheritdef 1)
			;
namespacedefinition	= "namespace" IDENT  "{" namespace_definitionlist "}"				(namespacedef)
			;
classdefinition		= "class" IDENT "{" inclass_definitionlist "}"					(classdef)
			| "class" IDENT ":" inheritlist "{" inclass_definitionlist "}"			(classdef)
			| "generic" "class" IDENT "[" generic_header "]"
				"{" inclass_definitionlist "}"						(generic_classdef)
			| "generic" "class" IDENT "[" generic_header "]"
				":" inheritlist "{" inclass_definitionlist "}"				(generic_classdef)
			;
linkage			= "private"									(linkage {private=true, linkage="internal", explicit=true})
			| "public"									(linkage {private=false, linkage="external", explicit=true})
			| ε										(linkage {private=false, linkage="external", explicit=false})
			;
functiondefinition	= linkage "function" IDENT typespec callablebody				(funcdef)
			| linkage "procedure" IDENT callablebody					(procdef)
			| "generic" linkage "function" IDENT "[" generic_header "]"
				 typespec callablebody							(generic_funcdef)
			| "generic" linkage "procedure" IDENT "[" generic_header "]"
				 callablebody								(generic_procdef)
			;
constructordefinition	= linkage "constructor" callablebody						(constructordef)
			| "destructor" codeblock							(destructordef {linkage="external"})
			;
operatordefinition      = linkage "operator" operatordecl typespec callablebody				(operator_funcdef)
			| linkage "operator" operatordecl callablebody					(operator_procdef)
			;
operatordecl		= "->"										(operatordecl {name="->", symbol="arrow"})
			| "="										(operatordecl {name="=", symbol="assign"})
			| "+"										(operatordecl {name="+", symbol="plus"})
			| "-"										(operatordecl {name="-", symbol="minus"})
			| "*"										(operatordecl {name="*", symbol="mul"})
			| "/"										(operatordecl {name="/", symbol="div"})
			| "%"										(operatordecl {name="%", symbol="mod"})
			| "&&"										(operatordecl {name="&&", symbol="and"})
			| "||"										(operatordecl {name="||", symbol="or"})
			| "&"										(operatordecl {name="&", symbol="bitand"})
			| "|"										(operatordecl {name="|", symbol="bitor"})
			| "<<"										(operatordecl {name="<<", symbol="lsh"})
			| ">>"										(operatordecl {name=">>", symbol="rsh"})
			| "~"										(operatordecl {name="~", symbol="lneg"})
			| "!"										(operatordecl {name="!", symbol="not"})
			| "(" ")"									(operatordecl {name="()", symbol="call"})
			| "[" "]"									(operatordecl {name="[]", symbol="get"})
			| "=="										(operatordecl {name="==", symbol="eq"})
			| "!="										(operatordecl {name="!=", symbol="ne"})
			| ">="										(operatordecl {name=">=", symbol="ge"})
			| "<="										(operatordecl {name="<=", symbol="le"})
			| ">"										(operatordecl {name=">", symbol="gt"})
			| "<"										(operatordecl {name="<", symbol="lt"})
			;
lambda_paramlist	= lambda_parameters								(lambda_paramdeflist)
			| ε										(lambda_paramdeflist)
			;
lambda_parameters	= IDENT "," lambda_parameters
			| IDENT
			;
lamda_expression	= "lambda" "(" lambda_paramlist ")" codeblock					(lambda_expression)
			;
generic_instance_defelem= typegen
			| UINTEGER									(generic_instance_dimension)
			| lamda_expression
			;
generic_instance_deflist= generic_instance_defelem							(generic_instance_deflist)
			| generic_instance_defelem "," generic_instance_deflist				(generic_instance_deflist)
			;
generic_instance	= generic_instance_deflist							(generic_instance)
			;
generic_defaultlist	= IDENT "=" typegen "," generic_defaultlist					(generic_header_ident_type)
			| IDENT "=" typegen								(generic_header_ident_type)
			;
generic_identlist	= IDENT "," generic_identlist							(generic_header_ident)
			| IDENT "," generic_defaultlist							(generic_header_ident)
			| IDENT										(generic_header_ident)
			;
generic_header		= generic_identlist								(generic_header)
			| generic_defaultlist								(generic_header)
			;
callablebody		= "(" impl_paramlist ")" funcattribute "{" statementlist "}"			({}callablebody)
			;
main_procedure		= "main" codeblock								(main_procdef)
			| ε
			;
impl_paramlist		= impl_parameters								(paramdeflist)
			| ε										(paramdeflist)
			;
impl_parameters		= impl_paramdecl "," impl_parameters
			| impl_paramdecl
			;
impl_paramdecl		= typespec IDENT								(paramdef)
			;
codeblock/L1		= "{" statementlist "}"								({}codeblock)
			;
statementlist/L1	= statement statementlist							(>>)
			| ε
			;
elseblock/L1		= "elseif" "(" expression ")" codeblock	elseblock				(conditional_elseif)
			| "elseif" "(" expression ")" codeblock 					(conditional_elseif)
			| "else" codeblock 								(conditional_else)
			;
catchblock		= "catch" IDENT	codeblock							(>>catchblock)
			| "catch" IDENT	"," IDENT codeblock						(>>catchblock)
			;
tryblock		= "try" codeblock								(tryblock)
			;
statement/L1		= structdefinition								(definition 1)
			| classdefinition 								(definition 1)
			| functiondefinition								(definition 1)
			| typedefinition ";"								(definition 1)
			| "var" variabledefinition ";"							(>>definition 1)
			| expression ";"								(free_expression)
			| "return" expression ";"							(>>return_value)
			| "return" ";"									(>>return_void)
			| "throw" expression "," expression ";"						(throw_exception)
			| "throw" expression  ";"							(throw_exception)
			| tryblock catchblock								({}trycatch)
			| "delete" expression ";"							(delete)
			| "if" "(" expression ")" codeblock elseblock					(conditional_if)
			| "if" "(" expression ")" codeblock 						(conditional_if)
			| "while" "(" expression ")" codeblock						(conditional_while)
			| "with" "(" expression ")" codeblock						(with_do)
			| "with" "(" expression ")" ";"							(with_do)
			| codeblock
			;
variabledefinition	= typespec IDENT								(>>vardef)
			| typespec IDENT "=" expression							(>>vardef)
			;
expression/L1		= "{" expressionlist "}"							(>>structure)
			| "{" "}"									(>>structure)
			| "new" typespec ":" expression							(>>allocate)
			| "cast" typespec ":" expression						(>>typecast)
			;
expression/L2		= IDENT										(variable)
			| BOOLEAN									(constant "constexpr bool")
			| UINTEGER									(constant "constexpr uint")
			| FLOAT										(constant "constexpr float")
			| "null"									(null)
			| DQSTRING									(string_constant)
			| SQSTRING									(char_constant)
			| lamda_expression
			| "(" expression ")"
			;
expression/L3		= expression  "="  expression							(>>binop "=")
			| expression  "+="  expression							(>>assign_operator "+")
			| expression  "-="  expression							(>>assign_operator "-")
			| expression  "*="  expression							(>>assign_operator "*")
			| expression  "/="  expression							(>>assign_operator "/")
			| expression  "^="  expression							(>>assign_operator "^")
			| expression  "%="  expression							(>>assign_operator "%")
			| expression  "&&="  expression							(>>assign_operator "&&")
			| expression  "||="  expression							(>>assign_operator "||")
			| expression  "&="  expression							(>>assign_operator "&")
			| expression  "|="  expression							(>>assign_operator "|")
			| expression  "<<="  expression							(>>assign_operator "<<")
			| expression  ">>="  expression							(>>assign_operator ">>")
			;
expression/L4		= expression  "||"  expression							(>>binop "||")
			;
expression/L5		= expression  "&&"  expression							(>>binop "&&")
			;
expression/L6		= expression  "|"  expression							(>>binop "|")
			;
expression/L7		= expression  "^"  expression							(>>binop "^")
			| expression  "&"  expression							(>>binop "&")
			;
expression/L8		= expression  "=="  expression							(>>binop "==")
			| expression  "!="  expression							(>>binop "!=")
			| expression  "<="  expression							(>>binop "<=")
			| expression  "<"  expression							(>>binop "<")
			| expression  ">="  expression							(>>binop ">=")
			| expression  ">"  expression							(>>binop ">")
			;
expression/L9		= expression  "+"  expression							(>>binop "+")
			| expression  "-"  expression							(>>binop "-")
			| "&"  expression								(operator_address "&")
			| "-"  expression								(>>unop "-")
			| "+"  expression								(>>unop "+")
			| "~"  expression								(>>unop "~")
			| "!"  expression								(>>unop "!")
			;
expression/L10		= expression  "*"  expression							(>>binop "*")
			| expression  "/"  expression							(>>binop "/")
			| expression  "%"  expression							(>>binop "%")
			;
expression/L11		= expression  "<<"  expression							(>>binop "<<")
			| expression  ">>"  expression							(>>binop ">>")
			;
expression/L12		= iexpression
			| expression "." IDENT								(member)
			| "*" expression								(>>unop "->")
			;
expression/L13		= expression  "(" expressionlist ")"						(>>operator "()")
			| expression  "(" ")"								(>>operator "()")
			| expression  "[" expressionlist "]"						(>>operator_array "[]")
			;
iexpression/L14		= expression indirection IDENT							(rep_operator "->")
			;
indirection/L14		= "->" indirection								(count)
			| "->"										(count)
			;
expressionlist/L0	= expression "," expressionlist
			| expression
			;

