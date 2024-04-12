//From: https://github.com/CordyJ/Open-TuringPlus/blob/main/doc/SSL_Specification.pdf
//https://en.wikipedia.org/wiki/S/SL_programming_language
//https://github.com/alegemaate/s-sl
//https://github.com/open-watcom/open-watcom-v2/tree/master/bld/ssl
// S/SL grammar

%token id string integer tInputAny tOtherwise
%token tInput tOutput tError tType tMechanism tRules tEnd
%token tCall tExit tReturn tErrorSignal tOr tCycle tCycleEnd  tChoice tChoiceEnd

/*
The Shift/Reduce conflict in action:tReturn is ok
*/

%%

s_sl :
	definitions tRules rule_list tEnd
	;

definitions :
	definition
	| definitions definition
	;

definition :
	inputDefinition
	| outputDefinition
	| inputOutputDefinition
	| errorDefinition
	| typeDefinition
	| mechanismDefinition
	;

inputDefinition :
	tInput ':' tokenDefinitions ';'
	;

outputDefinition :
	tOutput ':' tokenDefinitions ';'
	;

inputOutputDefinition :
	tInput tOutput ':' tokenDefinitions ';'
	;

errorDefinition :
	tError ':' errorSignalDefinitions ';'
	;

typeDefinition :
	tType id ':' valueDefinitions ';'
	;

mechanismDefinition :
	tMechanism id ':' operationDefinitions ';'
	;

rule_list :
	rule
	| rule_list rule
	;

rule :
	proc_rule
	| choice_rule
	;

proc_rule :
	id ':' actions ';'
	;

choice_rule :
	id tReturn id /*typeId*/ ':' actions ';'
	;

actions :
	action
	| actions action
	;

action :
	id 					/*a: inputToken*/
	| string 				/*a: inputToken*/
	| tInputAny			/*a:*/
	| '.' id 				/*b: outputToken*/
	| '.' string 				/*b: outputToken*/
	| tErrorSignal id 		/*c: errorId*/
	| tCycle actions tCycleEnd /*d: */
	| tExit				/*e:*/
	| choice				/*f:*/
	| tCall id 				/*g: procedureRuleId*/
	| tReturn	/*it's ok to shift here*/			/*h:*/
	| tReturn id 	/*J: valueId*/
	| tReturn string 	/*J: valueId*/
	| tReturn integer 	/*J: valueId*/
	//|	/*k: updateOpId*/
	| id '(' id ')'		/*l: parameterizedUpdateOpId(valueId)*/
	| tCall id '(' param_list ')'
	;

//cycle_actions :
//	action
//	| tExit				/*e:*/
//	| tReturn				/*h:*/
//	| cycle_actions tExit
//	| cycle_actions tReturn
//	| cycle_actions action
//	;

choice :
	tChoice input_choice_body tChoiceEnd /*f:*/
	| tChoice tCall id /*choiceRuleId*/ value_choice_body tChoiceEnd /*i:*/
	| tChoice id /*choiceOpId*/ value_choice_body tChoiceEnd /*m:*/
	| tChoice id '(' id /*valueId*/ ')' /*parameterizedChoiceOpId*/ value_choice_body tChoiceEnd /*n:*/
	| tChoice tOtherwise /*InputLookaheadChoice*/ input_choice_body tChoiceEnd
	;

input_choice_body :
	input_choice_cases
	| input_choice_cases choice_otherwise
	;

input_choice_cases :
	input_choice_case
	| input_choice_cases input_choice_case
	;

input_choice_case :
	tOr inputToken_list ':'
	| tOr inputToken_list ':' actions
	;

choice_otherwise :
	tOr tOtherwise ':'
	| tOr tOtherwise ':' actions
	;

value_choice_body :
	value_choice_cases
	| value_choice_cases choice_otherwise
	;

value_choice_cases :
	value_choice_case
	| value_choice_cases value_choice_case
	;

value_choice_case :
	tOr valueId_list ':'
	| tOr valueId_list ':' actions
	;

inputToken_list :
	id
	| string
	| inputToken_list ',' id
	| inputToken_list ',' string
	;

valueId_list :
	id
	| string
	| integer
	| valueId_list ',' id
	| valueId_list ',' string
	| valueId_list ',' integer
	;

tokenDefinitions :
	tokenDefinition
	| tokenDefinitions tokenDefinition
	;

tokenDefinition :
	id
	| id string /*synonym*/
	| id '=' tokenValue
	| id string '=' tokenValue
	;

tokenValue :
	id
	| integer
	| string
	;

errorSignalDefinitions :
	errorSignalDefinition
	| errorSignalDefinitions errorSignalDefinition
	;

errorSignalDefinition :
	id
	| id '=' integer /*errorValue*/
	| id '=' id /*reference errorValue*/
	;

valueDefinitions :
	valueDefinition
	| valueDefinitions valueDefinition
	;

valueDefinition :
	id
	| id '=' tokenValue
	;

operationDefinitions :
	operationDefinition
	| operationDefinitions operationDefinition
	;

operationDefinition :
	id
	| id '(' id /*typeId*/ ')'
	| id tReturn id /*typeId*/
	| id '(' id /*typeId*/ ')' tReturn id /*typeId*/
	;

param_list :
	id
	| param_list ',' id
	;

%%

%option caseless

%%

[ \t\r\n\f]+  skip()
"%".*   skip()

"." '.'
";" ';'
"," ','
":" ':'
"=" '='
"(" '('
")" ')'
"?"	tInputAny
"*"	tOtherwise
"["|"if" tChoice
"]"|"fi" tChoiceEnd
"{"|"do" tCycle
"}"|"od" tCycleEnd
"|"|"!" tOr
"@" tCall
"#" tErrorSignal
">" tExit
">>"    tReturn

"INPUT" tInput
"OUTPUT"    tOutput
"ERROR" tError
"TYPE"  tType
"MECHANISM" tMechanism
"RULES" tRules
"END"   tEnd

"-"?[0-9]+  integer

'(\\.|[^'\r\n\\])+' string

[A-Za-z_][A-Za-z0-9_]* id

%%
