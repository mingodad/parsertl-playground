// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

%token kABS
%token kABSTRACT
%token kADD
%token kAND
%token kARROW
%token kAS
%token kASSERT
%token kASSIGN
%token kASSIGN_ADD
%token kASSIGN_AND
%token kASSIGN_COND
%token kASSIGN_DIV
%token kASSIGN_INDEX
%token kASSIGN_MOD
%token kASSIGN_MUL
%token kASSIGN_OR
%token kASSIGN_SHL
%token kASSIGN_SHR
%token kASSIGN_SUB
%token kASSIGN_TRUNCDIV
%token kASSIGN_USHR
%token kASSIGN_XOR
%token kAT
%token kBIT_AND
%token kBIT_NOT
%token kBIT_OR
%token kBIT_XOR
%token kBREAK
%token kCASCADE
%token kCASE
%token kCATCH
%token kCEILING
%token kCLASS
%token kCOLON
%token kCOMMA
%token kCONDITIONAL
%token kCONST
%token kCONTINUE
%token kCOVARIANT
%token kDECR
%token kDEFAULT
%token kDEFERRED
%token kDIV
%token kDO
%token kDOUBLE
%token kELSE
%token kENUM
%token kEQ
%token kEQ_STRICT
//%token kERROR
%token kEXPORT
%token kEXTENDS
%token kEXTERNAL
%token kFACTORY
%token kFALSE
%token kFINAL
%token kFINALLY
%token kFLOOR
%token kFOR
%token kGET
%token kGT
%token kGTE
%token kHASH
%token kIDENT
%token kIF
%token kIFnullptr
//%token kILLEGAL
%token kIMPLEMENTS
%token kIMPORT
%token kIN
%token kINCR
%token kINDEX
%token kINTEGER
//%token kINTERPOL_END
//%token kINTERPOL_START
//%token kINTERPOL_VAR
%token kIS
//%token kISNOT
%token kLBRACE
%token kLBRACK
%token kLIBRARY
%token kLPAREN
%token kLT
%token kLTE
%token kMAX
%token kMIN
%token kMOD
%token kMUL
%token kNE
%token kNEGATE
%token kNEW
//%token kNEWLINE
%token kNE_STRICT
%token kNOT
%token kOPERATOR
%token kOR
%token kPART
%token kPERIOD
%token kQM_PERIOD
%token kRBRACE
%token kRBRACK
%token kRECIPROCAL
%token kRECIPROCAL_SQRT
%token kREM
%token kRETHROW
%token kRETURN
%token kRPAREN
%token kSCRIPTTAG
%token kSEMICOLON
%token kSET
%token kSHL
%token kSHR
%token kSQRT
%token kSQUARE
%token kSTATIC
%token kSTRING
%token kSUB
%token kSUPER
%token kSWITCH
%token kTHIS
%token kTHROW
%token kTRUE
%token kTRUNCATE
%token kTRUNCDIV
%token kTRY
%token kTYPEDEF
%token kUSHR
%token kVAR
%token kVOID
%token kWHILE
//%token kWHITESP
%token kWITH
%token knullptr

//  Operator precedence table
//
//  14  multiplicative  * / ~/ %
//  13  additive        + -
//  12  shift           << >> >>>
//  11  bitwise and     &
//  10  bitwise xor     ^
//   9  bitwise or      |
//   8  relational      >= > <= < is as
//   7  equality        == != === !==
//   6  logical and     &&
//   5  logical or      ||
//   4  null check      ??
//   3  conditional     ?
//   2  assignment      = *= /= ~/= %= += -= <<= >>= >>>= &= ^= |= ??=
//   1  comma           ,

%left kCOMMA
%left kASSIGN kASSIGN_ADD kASSIGN_AND kASSIGN_COND kASSIGN_DIV kASSIGN_INDEX kASSIGN_MOD kASSIGN_MUL kASSIGN_OR kASSIGN_SHL kASSIGN_SHR kASSIGN_SUB kASSIGN_TRUNCDIV kASSIGN_USHR kASSIGN_XOR
%left kCONDITIONAL
%left kIFnullptr
%left kOR
%left kAND
%left kEQ kNE kEQ_STRICT kNE_STRICT
%left kGT kGTE kLT kLTE kIS kAS
%left kBIT_OR
%left kBIT_XOR
%left kBIT_AND
%left kSHL kSHR kUSHR
%left kADD kSUB
%left kMUL kMOD kDIV kTRUNCDIV

%%

input :
	%empty
	| tokens
	;

tokens :
	token
	| tokens token
	;

token :
	kABS
	| kABSTRACT
	| kADD
	| kAND
	| kARROW
	| kAS
	| kASSERT
	| kASSIGN
	| kASSIGN_ADD
	| kASSIGN_AND
	| kASSIGN_COND
	| kASSIGN_DIV
	| kASSIGN_INDEX
	| kASSIGN_MOD
	| kASSIGN_MUL
	| kASSIGN_OR
	| kASSIGN_SHL
	| kASSIGN_SHR
	| kASSIGN_SUB
	| kASSIGN_TRUNCDIV
	| kASSIGN_USHR
	| kASSIGN_XOR
	| kAT
	| kBIT_AND
	| kBIT_NOT
	| kBIT_OR
	| kBIT_XOR
	| kBREAK
	| kCASCADE
	| kCASE
	| kCATCH
	| kCEILING
	| kCLASS
	| kCOLON
	| kCOMMA
	| kCONDITIONAL
	| kCONST
	| kCONTINUE
	| kCOVARIANT
	| kDECR
	| kDEFAULT
	| kDEFERRED
	| kDIV
	| kDO
	| kDOUBLE
	| kELSE
	| kENUM
	| kEQ
	| kEQ_STRICT
	//| kERROR
	| kEXPORT
	| kEXTENDS
	| kEXTERNAL
	| kFACTORY
	| kFALSE
	| kFINAL
	| kFINALLY
	| kFLOOR
	| kFOR
	| kGET
	| kGT
	| kGTE
	| kHASH
	| kIDENT
	| kIF
	| kIFnullptr
	//| kILLEGAL
	| kIMPLEMENTS
	| kIMPORT
	| kIN
	| kINCR
	| kINDEX
	| kINTEGER
	//| kINTERPOL_END
	//| kINTERPOL_START
	//| kINTERPOL_VAR
	| kIS
	//| kISNOT
	| kLBRACE
	| kLBRACK
	| kLIBRARY
	| kLPAREN
	| kLT
	| kLTE
	| kMAX
	| kMIN
	| kMOD
	| kMUL
	| kNE
	| kNEGATE
	| kNEW
	//| kNEWLINE
	| kNE_STRICT
	| kNOT
	| kOPERATOR
	| kOR
	| kPART
	| kPERIOD
	| kQM_PERIOD
	| kRBRACE
	| kRBRACK
	| kRECIPROCAL
	| kRECIPROCAL_SQRT
	| kREM
	| kRETHROW
	| kRETURN
	| kRPAREN
	| kSCRIPTTAG
	| kSEMICOLON
	| kSET
	| kSHL
	| kSHR
	| kSQRT
	| kSQUARE
	| kSTATIC
	| kSTRING
	| kSUB
	| kSUPER
	| kSWITCH
	| kTHIS
	| kTHROW
	| kTRUE
	| kTRUNCATE
	| kTRUNCDIV
	| kTRY
	| kTYPEDEF
	| kUSHR
	| kVAR
	| kVOID
	| kWHILE
	//| kWHITESP
	| kWITH
	| knullptr
	;

%%

%x TRIPLE_SQ_STR TRIPLE_DQ_STR BLOCK_COMMENT

%%

[ \t\r\n]+	skip()
"//".*	skip()
//"/*"(?s:.)*?"*/"	skip()

"/*"<>BLOCK_COMMENT>
<BLOCK_COMMENT>{
    "/*"<>BLOCK_COMMENT>
    "*/"<<> skip()
    .|\n<.>
}

// Token definitions.
// Some operator tokens appear in blocks, e.g. assignment operators.
// There is code that depends on the values within a block to be
// contiguous, and on the order of values.

"("	kLPAREN
")"	kRPAREN
"["	kLBRACK
"]"	kRBRACK
"{"	kLBRACE
"}"	kRBRACE
"=>"	kARROW
":"	kCOLON
";"	kSEMICOLON
"."	kPERIOD
"?."	kQM_PERIOD
"++"	kINCR
"--"	kDECR

/* Assignment operators.                            */
/* Please update IsAssignmentOperator() if you make */
/* any changes to this block.                       */
"="	kASSIGN
"|="	kASSIGN_OR
"^="	kASSIGN_XOR
"&="	kASSIGN_AND
"<<="	kASSIGN_SHL
">>="	kASSIGN_SHR
">>>="	kASSIGN_USHR
"+="	kASSIGN_ADD
"-="	kASSIGN_SUB
"*="	kASSIGN_MUL
"~/="	kASSIGN_TRUNCDIV
"/="	kASSIGN_DIV
"%="	kASSIGN_MOD
/* Avoid trigraph ??= below. */
"?\?="	kASSIGN_COND

".."	kCASCADE

","	kCOMMA
"||"	kOR
"&&"	kAND
"|"	kBIT_OR
"^"	kBIT_XOR
"&"	kBIT_AND
"~"	kBIT_NOT

/* Shift operators. */
"<<"	kSHL
">>"	kSHR
">>>"	kUSHR

/* Additive operators. */
"+"	kADD
"-"	kSUB

/* Multiplicative operators */
"*"	kMUL
"/"	kDIV
"~/"	kTRUNCDIV
"%"	kMOD

"!"	kNOT
"?"	kCONDITIONAL
"??"	kIFnullptr

/* Equality operators.                             */
/* Please update IsEqualityOperator() if you make  */
/* any changes to this block.                      */
"=="	kEQ
"!="	kNE
"==="	kEQ_STRICT
"!=="	kNE_STRICT

/* Relational operators.                             */
/* Please update IsRelationalOperator() if you make  */
/* any changes to this block.                        */
"<"	kLT
">"	kGT
"<="	kLTE
">="	kGTE

/* Internal token for !(expr is Type) negative type test operator */
//""	kISNOT

"[]"	kINDEX
"[]="	kASSIGN_INDEX
"unary-"	kNEGATE

//"$"	kINTERPOL_VAR
//"${"	kINTERPOL_START
//"}"	kINTERPOL_END

"@"	kAT
"#"	kHASH

//"\n"	kNEWLINE
//""	kWHITESP
//""	kERROR
//""	kILLEGAL

/* Support for Dart scripts. */
"#!"	kSCRIPTTAG

/* Support for optimized code */
"rem"	kREM
"abs"	kABS
"sqrt"	kSQRT
"min"	kMIN
"max"	kMAX
"reciprocal"	kRECIPROCAL
"reciprocal-sqrt"	kRECIPROCAL_SQRT
"square"	kSQUARE
"truncate"	kTRUNCATE
"floor"	kFLOOR
"ceiling"	kCEILING

// List of keywords. The list must be alphabetically ordered. The
// keyword recognition code depends on the ordering.
// If you add a keyword at the beginning or end of this list, make sure
// to update kFirstKeyword and kLastKeyword below.
"abstract"	kABSTRACT
"as"	kAS
"assert"	kASSERT
"break"	kBREAK
"case"	kCASE
"catch"	kCATCH
"class"	kCLASS
"const"	kCONST
"continue"	kCONTINUE
"covariant"	kCOVARIANT
"default"	kDEFAULT
"deferred"	kDEFERRED
"do"	kDO
"else"	kELSE
"enum"	kENUM
"export"	kEXPORT
"extends"	kEXTENDS
"external"	kEXTERNAL
"factory"	kFACTORY
"false"	kFALSE
"final"	kFINAL
"finally"	kFINALLY
"for"	kFOR
"get"	kGET
"if"	kIF
"implements"	kIMPLEMENTS
"import"	kIMPORT
"in"	kIN
"is"	kIS
"library"	kLIBRARY
"new"	kNEW
"null"	knullptr
"operator"	kOPERATOR
"part"	kPART
"rethrow"	kRETHROW
"return"	kRETURN
"set"	kSET
"static"	kSTATIC
"super"	kSUPER
"switch"	kSWITCH
"this"	kTHIS
"throw"	kTHROW
"true"	kTRUE
"try"	kTRY
"typedef"	kTYPEDEF
"var"	kVAR
"void"	kVOID
"while"	kWHILE
"with"	kWITH

r?'''<TRIPLE_SQ_STR>
<TRIPLE_SQ_STR>{
	'''<INITIAL>	kSTRING
	.|\n<.>
}
r?\"\"\"<TRIPLE_DQ_STR>
<TRIPLE_DQ_STR>{
	\"\"\"<INITIAL>	kSTRING
	.|\n<.>
}

r\"[^"]*\"	kSTRING
r'[^']*'	kSTRING

\"(\\.|[^"\\])*\"	kSTRING
'(\\.|[^'\\])*'	kSTRING
"`"[^`]*"`"	kSTRING

[0-9]+	kINTEGER
[0-9]+"."[0-9]+	kDOUBLE
[$A-Za-z_][A-Za-z0-9_]*	kIDENT

%%
