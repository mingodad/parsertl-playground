//From: https://github.com/StanfordPL/x64asm/blob/505ab5e404d0c19a038b91b6690f85c7a087b8c6/src/att.y
/*
Copyright 2013-2015 Stanford University

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */

 /*
Some high level notes as this implementation isn't totally obvious.

This parser has to deal with the fact that x86 assembly isn't LALR(1)
parseable.  The high level way around this is to parse opcode, operand
string pairs and then use those pairs as keys in a lookup table to resolve
instruction form.

A side effect of this implementation is that some of the parsing rules for
memory operands shadow the parsing rules for moffs and rel operands.  This,
combined with the fact that the corresponding lexer stores least specific
operand types is handled using a method to check whether operands can be
reinterpreted as the desired types and cast as necessary.

This implementation relies on a table which is ordered such that most
specific operand orderings appear prior to less specific orderings, so that
for instance, adc $0x10, %al is parsed as ADC_IMM8_AL rather than ADC_IMM32_R32.
 */

/*Tokens*/
%token COMMA
%token COLON
%token OPEN
%token CLOSE
%token ENDL
%token SCALE
%token RIP
%token HINT
%token IMM
%token OFFSET
%token LABEL
%token PREF_66
%token PREF_REX_W
%token FAR
%token MM
%token RH
%token R_8
%token R_16
%token R_32
%token R_64
%token SREG
%token ST
%token XMM
%token YMM
%token OPCODE


%start code

%%


blank :
	/*empty*/
	| blank ENDL
	;

code :
	blank instrs
	;

instrs :
	/*empty*/
	| instr
	| instrs instr
	;

instr :
	LABEL COLON ENDL blank
	| OPCODE typed_operands ENDL blank
	;

typed_operands :
	/*empty*/
	| typed_operand
	| typed_operand COMMA typed_operand
	| typed_operand COMMA typed_operand COMMA typed_operand
	| typed_operand COMMA typed_operand COMMA typed_operand COMMA typed_operand
	;

typed_operand :
	HINT
	| IMM
	| LABEL
	| PREF_66
	| PREF_REX_W
	| FAR
	| MM
	| RH
	| R_8
	| R_16
	| R_32
	| R_64
	| SREG
	| ST
	| XMM
	| YMM
	| moffs
	| m
	;

moffs :
	OFFSET
	| SREG COLON OFFSET
	;

m :
	OPEN R_32 CLOSE
	| OPEN R_64 CLOSE
	| OPEN RIP CLOSE
	| SREG COLON OPEN R_32 CLOSE
	| SREG COLON OPEN R_64 CLOSE
	| SREG COLON OPEN RIP CLOSE
	| OFFSET OPEN R_32 CLOSE
	| OFFSET OPEN R_64 CLOSE
	| OFFSET OPEN RIP CLOSE
	| SREG COLON OFFSET OPEN R_32 CLOSE
	| SREG COLON OFFSET OPEN R_64 CLOSE
	| SREG COLON OFFSET OPEN RIP CLOSE
	| OPEN COMMA R_32 COMMA SCALE CLOSE
	| OPEN COMMA R_64 COMMA SCALE CLOSE
	| OPEN COMMA R_32 CLOSE
	| OPEN COMMA R_64 CLOSE
	| SREG COLON OPEN COMMA R_32 COMMA SCALE CLOSE
	| SREG COLON OPEN COMMA R_64 COMMA SCALE CLOSE
	| SREG COLON OPEN COMMA R_32 CLOSE
	| SREG COLON OPEN COMMA R_64 CLOSE
	| OFFSET OPEN COMMA R_32 COMMA SCALE CLOSE
	| OFFSET OPEN COMMA R_64 COMMA SCALE CLOSE
	| OFFSET OPEN COMMA R_32 CLOSE
	| OFFSET OPEN COMMA R_64 CLOSE
	| SREG COLON OFFSET OPEN COMMA R_32 COMMA SCALE CLOSE
	| SREG COLON OFFSET OPEN COMMA R_64 COMMA SCALE CLOSE
	| SREG COLON OFFSET OPEN COMMA R_32 CLOSE
	| SREG COLON OFFSET OPEN COMMA R_64 CLOSE
	| OPEN R_32 COMMA R_32 COMMA SCALE CLOSE
	| OPEN R_64 COMMA R_64 COMMA SCALE CLOSE
	| OPEN R_32 COMMA R_32 CLOSE
	| OPEN R_64 COMMA R_64 CLOSE
	| SREG COLON OPEN R_32 COMMA R_32 COMMA SCALE CLOSE
	| SREG COLON OPEN R_64 COMMA R_64 COMMA SCALE CLOSE
	| SREG COLON OPEN R_32 COMMA R_32 CLOSE
	| SREG COLON OPEN R_64 COMMA R_64 CLOSE
	| OFFSET OPEN R_32 COMMA R_32 COMMA SCALE CLOSE
	| OFFSET OPEN R_64 COMMA R_64 COMMA SCALE CLOSE
	| OFFSET OPEN R_32 COMMA R_32 CLOSE
	| OFFSET OPEN R_64 COMMA R_64 CLOSE
	| SREG COLON OFFSET OPEN R_32 COMMA R_32 COMMA SCALE CLOSE
	| SREG COLON OFFSET OPEN R_64 COMMA R_64 COMMA SCALE CLOSE
	| SREG COLON OFFSET OPEN R_32 COMMA R_32 CLOSE
	| SREG COLON OFFSET OPEN R_64 COMMA R_64 CLOSE
	;

%%

%%

","            COMMA
":"            COLON
"("            OPEN
")"            CLOSE
"\n"           ENDL
[ \t*]        skip()
"#"[^\n]*"\n"  ENDL
";"[^\n]*"\n"  ENDL

"1"  SCALE
"2"  SCALE
"4"  SCALE
"8"  SCALE

"%rip"  RIP

"<taken>"      HINT
"<not taken>"  HINT

"-0x"[0-9a-fA-F]+  OFFSET
"0x"[0-9a-fA-F]+   OFFSET

"$-0x"[0-9a-fA-F]+  IMM
"$0x"[0-9a-fA-F]+   IMM

"."[a-zA-Z0-9_]+  LABEL

"<66>"    PREF_66
"<rexw>"  PREF_REX_W
"<far>"   FAR

"%mm0"  MM
"%mm1"  MM
"%mm2"  MM
"%mm3"  MM
"%mm4"  MM
"%mm5"  MM
"%mm6"  MM
"%mm7"  MM

"%ah"  RH
"%ch"  RH
"%dh"  RH
"%bh"  RH

"%al"    R_8
"%cl"    R_8
"%dl"    R_8
"%bl"    R_8
"%spl"   R_8
"%bpl"   R_8
"%sil"   R_8
"%dil"   R_8
"%r8b"   R_8
"%r9b"   R_8
"%r10b"  R_8
"%r11b"  R_8
"%r12b"  R_8
"%r13b"  R_8
"%r14b"  R_8
"%r15b"  R_8

"%ax"    R_16
"%cx"    R_16
"%dx"    R_16
"%bx"    R_16
"%sp"    R_16
"%bp"    R_16
"%si"    R_16
"%di"    R_16
"%r8w"   R_16
"%r9w"   R_16
"%r10w"  R_16
"%r11w"  R_16
"%r12w"  R_16
"%r13w"  R_16
"%r14w"  R_16
"%r15w"  R_16

"%eax"   R_32
"%ecx"   R_32
"%edx"   R_32
"%ebx"   R_32
"%esp"   R_32
"%ebp"   R_32
"%esi"   R_32
"%edi"   R_32
"%r8d"   R_32
"%r9d"   R_32
"%r10d"  R_32
"%r11d"  R_32
"%r12d"  R_32
"%r13d"  R_32
"%r14d"  R_32
"%r15d"  R_32

"%rax"  R_64
"%rcx"  R_64
"%rdx"  R_64
"%rbx"  R_64
"%rsp"  R_64
"%rbp"  R_64
"%rsi"  R_64
"%rdi"  R_64
"%r8"   R_64
"%r9"   R_64
"%r10"  R_64
"%r11"  R_64
"%r12"  R_64
"%r13"  R_64
"%r14"  R_64
"%r15"  R_64

"%es"  SREG
"%cs"  SREG
"%ss"  SREG
"%ds"  SREG
"%fs"  SREG
"%gs"  SREG

"%st"     ST
"%st(0)"  ST
"%st(1)"  ST
"%st(2)"  ST
"%st(3)"  ST
"%st(4)"  ST
"%st(5)"  ST
"%st(6)"  ST
"%st(7)"  ST

"%xmm0"   XMM
"%xmm1"   XMM
"%xmm2"   XMM
"%xmm3"   XMM
"%xmm4"   XMM
"%xmm5"   XMM
"%xmm6"   XMM
"%xmm7"   XMM
"%xmm8"   XMM
"%xmm9"   XMM
"%xmm10"  XMM
"%xmm11"  XMM
"%xmm12"  XMM
"%xmm13"  XMM
"%xmm14"  XMM
"%xmm15"  XMM

"%ymm0"   YMM
"%ymm1"   YMM
"%ymm2"   YMM
"%ymm3"   YMM
"%ymm4"   YMM
"%ymm5"   YMM
"%ymm6"   YMM
"%ymm7"   YMM
"%ymm8"   YMM
"%ymm9"   YMM
"%ymm10"  YMM
"%ymm11"  YMM
"%ymm12"  YMM
"%ymm13"  YMM
"%ymm14"  YMM
"%ymm15"  YMM

[a-z][a-z0-9]*  OPCODE
"rep "[a-z]+    OPCODE
"repz "[a-z]+   OPCODE
"repnz "[a-z]+  OPCODE

//. { yyterminate()

%%
