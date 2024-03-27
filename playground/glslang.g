//From: https://github.com/KhronosGroup/glslang/blob/8c0199c4fd186b2e4d736335d0e26fec34e30726/glslang/MachineIndependent/glslang.y
//
// Copyright (C) 2002-2005  3Dlabs Inc. Ltd.
// Copyright (C) 2012-2013 LunarG, Inc.
// Copyright (C) 2017 ARM Limited.
// Copyright (C) 2015-2019 Google, Inc.
// Modifications Copyright (C) 2020 Advanced Micro Devices, Inc. All rights reserved.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
//    Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
//    Redistributions in binary form must reproduce the above
//    copyright notice, this list of conditions and the following
//    disclaimer in the documentation and/or other materials provided
//    with the distribution.
//
//    Neither the name of 3Dlabs Inc. Ltd. nor the names of its
//    contributors may be used to endorse or promote products derived
//    from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//

/**
 * This is bison grammar and productions for parsing all versions of the
 * GLSL shading languages.
 */

/* Based on:
ANSI C Yacc grammar

In 1985, Jeff Lee published his Yacc grammar (which is accompanied by a
matching Lex specification) for the April 30, 1985 draft version of the
ANSI C standard.  Tom Stockfisch reposted it to net.sources in 1987; that
original, as mentioned in the answer to question 17.25 of the comp.lang.c
FAQ, can be ftp'ed from ftp.uu.net, file usenet/net.sources/ansi.c.grammar.Z.

I intend to keep this version as close to the current C Standard grammar as
possible; please let me know if you discover discrepancies.

Jutta Degener, 1995
*/

/*Tokens*/
%token CONST
%token BOOL
%token INT
%token UINT
%token FLOAT
%token BVEC2
%token BVEC3
%token BVEC4
%token IVEC2
%token IVEC3
%token IVEC4
%token UVEC2
%token UVEC3
%token UVEC4
%token VEC2
%token VEC3
%token VEC4
%token MAT2
%token MAT3
%token MAT4
%token MAT2X2
%token MAT2X3
%token MAT2X4
%token MAT3X2
%token MAT3X3
%token MAT3X4
%token MAT4X2
%token MAT4X3
%token MAT4X4
%token SAMPLER2D
%token SAMPLER3D
%token SAMPLERCUBE
%token SAMPLER2DSHADOW
%token SAMPLERCUBESHADOW
%token SAMPLER2DARRAY
%token SAMPLER2DARRAYSHADOW
%token ISAMPLER2D
%token ISAMPLER3D
%token ISAMPLERCUBE
%token ISAMPLER2DARRAY
%token USAMPLER2D
%token USAMPLER3D
%token USAMPLERCUBE
%token USAMPLER2DARRAY
%token SAMPLER
%token SAMPLERSHADOW
%token TEXTURE2D
%token TEXTURE3D
%token TEXTURECUBE
%token TEXTURE2DARRAY
%token ITEXTURE2D
%token ITEXTURE3D
%token ITEXTURECUBE
%token ITEXTURE2DARRAY
%token UTEXTURE2D
%token UTEXTURE3D
%token UTEXTURECUBE
%token UTEXTURE2DARRAY
%token ATTRIBUTE
%token VARYING
%token FLOAT16_T
%token FLOAT32_T
%token DOUBLE
%token FLOAT64_T
%token INT64_T
%token UINT64_T
%token INT32_T
%token UINT32_T
%token INT16_T
%token UINT16_T
%token INT8_T
%token UINT8_T
%token I64VEC2
%token I64VEC3
%token I64VEC4
%token U64VEC2
%token U64VEC3
%token U64VEC4
%token I32VEC2
%token I32VEC3
%token I32VEC4
%token U32VEC2
%token U32VEC3
%token U32VEC4
%token I16VEC2
%token I16VEC3
%token I16VEC4
%token U16VEC2
%token U16VEC3
%token U16VEC4
%token I8VEC2
%token I8VEC3
%token I8VEC4
%token U8VEC2
%token U8VEC3
%token U8VEC4
%token DVEC2
%token DVEC3
%token DVEC4
%token DMAT2
%token DMAT3
%token DMAT4
%token F16VEC2
%token F16VEC3
%token F16VEC4
%token F16MAT2
%token F16MAT3
%token F16MAT4
%token F32VEC2
%token F32VEC3
%token F32VEC4
%token F32MAT2
%token F32MAT3
%token F32MAT4
%token F64VEC2
%token F64VEC3
%token F64VEC4
%token F64MAT2
%token F64MAT3
%token F64MAT4
%token DMAT2X2
%token DMAT2X3
%token DMAT2X4
%token DMAT3X2
%token DMAT3X3
%token DMAT3X4
%token DMAT4X2
%token DMAT4X3
%token DMAT4X4
%token F16MAT2X2
%token F16MAT2X3
%token F16MAT2X4
%token F16MAT3X2
%token F16MAT3X3
%token F16MAT3X4
%token F16MAT4X2
%token F16MAT4X3
%token F16MAT4X4
%token F32MAT2X2
%token F32MAT2X3
%token F32MAT2X4
%token F32MAT3X2
%token F32MAT3X3
%token F32MAT3X4
%token F32MAT4X2
%token F32MAT4X3
%token F32MAT4X4
%token F64MAT2X2
%token F64MAT2X3
%token F64MAT2X4
%token F64MAT3X2
%token F64MAT3X3
%token F64MAT3X4
%token F64MAT4X2
%token F64MAT4X3
%token F64MAT4X4
%token ATOMIC_UINT
%token ACCSTRUCTNV
%token ACCSTRUCTEXT
%token RAYQUERYEXT
%token FCOOPMATNV
%token ICOOPMATNV
%token UCOOPMATNV
%token COOPMAT
%token HITOBJECTNV
%token HITOBJECTATTRNV
%token SAMPLERCUBEARRAY
%token SAMPLERCUBEARRAYSHADOW
%token ISAMPLERCUBEARRAY
%token USAMPLERCUBEARRAY
%token SAMPLER1D
%token SAMPLER1DARRAY
%token SAMPLER1DARRAYSHADOW
%token ISAMPLER1D
%token SAMPLER1DSHADOW
%token SAMPLER2DRECT
%token SAMPLER2DRECTSHADOW
%token ISAMPLER2DRECT
%token USAMPLER2DRECT
%token SAMPLERBUFFER
%token ISAMPLERBUFFER
%token USAMPLERBUFFER
%token SAMPLER2DMS
%token ISAMPLER2DMS
%token USAMPLER2DMS
%token SAMPLER2DMSARRAY
%token ISAMPLER2DMSARRAY
%token USAMPLER2DMSARRAY
%token SAMPLEREXTERNALOES
%token SAMPLEREXTERNAL2DY2YEXT
%token ISAMPLER1DARRAY
%token USAMPLER1D
%token USAMPLER1DARRAY
%token F16SAMPLER1D
%token F16SAMPLER2D
%token F16SAMPLER3D
%token F16SAMPLER2DRECT
%token F16SAMPLERCUBE
%token F16SAMPLER1DARRAY
%token F16SAMPLER2DARRAY
%token F16SAMPLERCUBEARRAY
%token F16SAMPLERBUFFER
%token F16SAMPLER2DMS
%token F16SAMPLER2DMSARRAY
%token F16SAMPLER1DSHADOW
%token F16SAMPLER2DSHADOW
%token F16SAMPLER1DARRAYSHADOW
%token F16SAMPLER2DARRAYSHADOW
%token F16SAMPLER2DRECTSHADOW
%token F16SAMPLERCUBESHADOW
%token F16SAMPLERCUBEARRAYSHADOW
%token IMAGE1D
%token IIMAGE1D
%token UIMAGE1D
%token IMAGE2D
%token IIMAGE2D
%token UIMAGE2D
%token IMAGE3D
%token IIMAGE3D
%token UIMAGE3D
%token IMAGE2DRECT
%token IIMAGE2DRECT
%token UIMAGE2DRECT
%token IMAGECUBE
%token IIMAGECUBE
%token UIMAGECUBE
%token IMAGEBUFFER
%token IIMAGEBUFFER
%token UIMAGEBUFFER
%token IMAGE1DARRAY
%token IIMAGE1DARRAY
%token UIMAGE1DARRAY
%token IMAGE2DARRAY
%token IIMAGE2DARRAY
%token UIMAGE2DARRAY
%token IMAGECUBEARRAY
%token IIMAGECUBEARRAY
%token UIMAGECUBEARRAY
%token IMAGE2DMS
%token IIMAGE2DMS
%token UIMAGE2DMS
%token IMAGE2DMSARRAY
%token IIMAGE2DMSARRAY
%token UIMAGE2DMSARRAY
%token F16IMAGE1D
%token F16IMAGE2D
%token F16IMAGE3D
%token F16IMAGE2DRECT
%token F16IMAGECUBE
%token F16IMAGE1DARRAY
%token F16IMAGE2DARRAY
%token F16IMAGECUBEARRAY
%token F16IMAGEBUFFER
%token F16IMAGE2DMS
%token F16IMAGE2DMSARRAY
%token I64IMAGE1D
%token U64IMAGE1D
%token I64IMAGE2D
%token U64IMAGE2D
%token I64IMAGE3D
%token U64IMAGE3D
%token I64IMAGE2DRECT
%token U64IMAGE2DRECT
%token I64IMAGECUBE
%token U64IMAGECUBE
%token I64IMAGEBUFFER
%token U64IMAGEBUFFER
%token I64IMAGE1DARRAY
%token U64IMAGE1DARRAY
%token I64IMAGE2DARRAY
%token U64IMAGE2DARRAY
%token I64IMAGECUBEARRAY
%token U64IMAGECUBEARRAY
%token I64IMAGE2DMS
%token U64IMAGE2DMS
%token I64IMAGE2DMSARRAY
%token U64IMAGE2DMSARRAY
%token TEXTURECUBEARRAY
%token ITEXTURECUBEARRAY
%token UTEXTURECUBEARRAY
%token TEXTURE1D
%token ITEXTURE1D
%token UTEXTURE1D
%token TEXTURE1DARRAY
%token ITEXTURE1DARRAY
%token UTEXTURE1DARRAY
%token TEXTURE2DRECT
%token ITEXTURE2DRECT
%token UTEXTURE2DRECT
%token TEXTUREBUFFER
%token ITEXTUREBUFFER
%token UTEXTUREBUFFER
%token TEXTURE2DMS
%token ITEXTURE2DMS
%token UTEXTURE2DMS
%token TEXTURE2DMSARRAY
%token ITEXTURE2DMSARRAY
%token UTEXTURE2DMSARRAY
%token F16TEXTURE1D
%token F16TEXTURE2D
%token F16TEXTURE3D
%token F16TEXTURE2DRECT
%token F16TEXTURECUBE
%token F16TEXTURE1DARRAY
%token F16TEXTURE2DARRAY
%token F16TEXTURECUBEARRAY
%token F16TEXTUREBUFFER
%token F16TEXTURE2DMS
%token F16TEXTURE2DMSARRAY
%token SUBPASSINPUT
%token SUBPASSINPUTMS
%token ISUBPASSINPUT
%token ISUBPASSINPUTMS
%token USUBPASSINPUT
%token USUBPASSINPUTMS
%token F16SUBPASSINPUT
%token F16SUBPASSINPUTMS
%token SPIRV_INSTRUCTION
%token SPIRV_EXECUTION_MODE
%token SPIRV_EXECUTION_MODE_ID
%token SPIRV_DECORATE
%token SPIRV_DECORATE_ID
%token SPIRV_DECORATE_STRING
%token SPIRV_TYPE
%token SPIRV_STORAGE_CLASS
%token SPIRV_BY_REFERENCE
%token SPIRV_LITERAL
%token ATTACHMENTEXT
%token IATTACHMENTEXT
%token UATTACHMENTEXT
%token LEFT_OP
%token RIGHT_OP
%token INC_OP
%token DEC_OP
%token LE_OP
%token GE_OP
%token EQ_OP
%token NE_OP
%token AND_OP
%token OR_OP
%token XOR_OP
%token MUL_ASSIGN
%token DIV_ASSIGN
%token ADD_ASSIGN
%token MOD_ASSIGN
%token LEFT_ASSIGN
%token RIGHT_ASSIGN
%token AND_ASSIGN
%token XOR_ASSIGN
%token OR_ASSIGN
%token SUB_ASSIGN
%token STRING_LITERAL
%token LEFT_PAREN
%token RIGHT_PAREN
%token LEFT_BRACKET
%token RIGHT_BRACKET
%token LEFT_BRACE
%token RIGHT_BRACE
%token DOT
%token COMMA
%token COLON
%token EQUAL
%token SEMICOLON
%token BANG
%token DASH
%token TILDE
%token PLUS
%token STAR
%token SLASH
%token PERCENT
%token LEFT_ANGLE
%token RIGHT_ANGLE
%token VERTICAL_BAR
%token CARET
%token AMPERSAND
%token QUESTION
%token INVARIANT
%token HIGH_PRECISION
%token MEDIUM_PRECISION
%token LOW_PRECISION
%token PRECISION
//%token PACKED
//%token RESOURCE
//%token SUPERP
%token FLOATCONSTANT
%token INTCONSTANT
%token UINTCONSTANT
%token BOOLCONSTANT
%token IDENTIFIER
%token TYPE_NAME
%token CENTROID
%token IN
%token OUT
%token INOUT
%token STRUCT
%token VOID
%token WHILE
%token BREAK
%token CONTINUE
%token DO
%token ELSE
%token FOR
%token IF
%token DISCARD
%token RETURN
%token SWITCH
%token CASE
%token DEFAULT
%token TERMINATE_INVOCATION
%token TERMINATE_RAY
%token IGNORE_INTERSECTION
%token UNIFORM
%token SHARED
%token BUFFER
%token TILEIMAGEEXT
%token FLAT
%token SMOOTH
%token LAYOUT
%token DOUBLECONSTANT
%token INT16CONSTANT
%token UINT16CONSTANT
%token FLOAT16CONSTANT
%token INT32CONSTANT
%token UINT32CONSTANT
%token INT64CONSTANT
%token UINT64CONSTANT
%token SUBROUTINE
%token DEMOTE
%token PAYLOADNV
%token PAYLOADINNV
%token HITATTRNV
%token CALLDATANV
%token CALLDATAINNV
%token PAYLOADEXT
%token PAYLOADINEXT
%token HITATTREXT
%token CALLDATAEXT
%token CALLDATAINEXT
%token PATCH
%token SAMPLE
%token NONUNIFORM
%token COHERENT
%token VOLATILE
%token RESTRICT
%token READONLY
%token WRITEONLY
%token DEVICECOHERENT
%token QUEUEFAMILYCOHERENT
%token WORKGROUPCOHERENT
%token SUBGROUPCOHERENT
%token NONPRIVATE
%token SHADERCALLCOHERENT
%token NOPERSPECTIVE
%token EXPLICITINTERPAMD
%token PERVERTEXEXT
%token PERVERTEXNV
%token PERPRIMITIVENV
%token PERVIEWNV
%token PERTASKNV
%token PERPRIMITIVEEXT
%token TASKPAYLOADWORKGROUPEXT
%token PRECISE


%start translation_unit

%%

variable_identifier :
	IDENTIFIER
	;

primary_expression :
	variable_identifier
	| LEFT_PAREN expression RIGHT_PAREN
	| FLOATCONSTANT
	| INTCONSTANT
	| UINTCONSTANT
	| BOOLCONSTANT
	| STRING_LITERAL
	| INT32CONSTANT
	| UINT32CONSTANT
	| INT64CONSTANT
	| UINT64CONSTANT
	| INT16CONSTANT
	| UINT16CONSTANT
	| DOUBLECONSTANT
	| FLOAT16CONSTANT
	;

postfix_expression :
	primary_expression
	| postfix_expression LEFT_BRACKET integer_expression RIGHT_BRACKET
	| function_call
	| postfix_expression DOT IDENTIFIER
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	;

integer_expression :
	expression
	;

function_call :
	function_call_or_method
	;

function_call_or_method :
	function_call_generic
	;

function_call_generic :
	function_call_header_with_parameters RIGHT_PAREN
	| function_call_header_no_parameters RIGHT_PAREN
	;

function_call_header_no_parameters :
	function_call_header VOID
	| function_call_header
	;

function_call_header_with_parameters :
	function_call_header assignment_expression
	| function_call_header_with_parameters COMMA assignment_expression
	;

function_call_header :
	function_identifier LEFT_PAREN
	;

function_identifier :
	type_specifier
	| postfix_expression
	| non_uniform_qualifier
	;

unary_expression :
	postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator unary_expression
	;

unary_operator :
	PLUS
	| DASH
	| BANG
	| TILDE
	;

multiplicative_expression :
	unary_expression
	| multiplicative_expression STAR unary_expression
	| multiplicative_expression SLASH unary_expression
	| multiplicative_expression PERCENT unary_expression
	;

additive_expression :
	multiplicative_expression
	| additive_expression PLUS multiplicative_expression
	| additive_expression DASH multiplicative_expression
	;

shift_expression :
	additive_expression
	| shift_expression LEFT_OP additive_expression
	| shift_expression RIGHT_OP additive_expression
	;

relational_expression :
	shift_expression
	| relational_expression LEFT_ANGLE shift_expression
	| relational_expression RIGHT_ANGLE shift_expression
	| relational_expression LE_OP shift_expression
	| relational_expression GE_OP shift_expression
	;

equality_expression :
	relational_expression
	| equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
	;

and_expression :
	equality_expression
	| and_expression AMPERSAND equality_expression
	;

exclusive_or_expression :
	and_expression
	| exclusive_or_expression CARET and_expression
	;

inclusive_or_expression :
	exclusive_or_expression
	| inclusive_or_expression VERTICAL_BAR exclusive_or_expression
	;

logical_and_expression :
	inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression
	;

logical_xor_expression :
	logical_and_expression
	| logical_xor_expression XOR_OP logical_and_expression
	;

logical_or_expression :
	logical_xor_expression
	| logical_or_expression OR_OP logical_xor_expression
	;

conditional_expression :
	logical_or_expression
	| logical_or_expression QUESTION expression COLON assignment_expression
	;

assignment_expression :
	conditional_expression
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator :
	EQUAL
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression :
	assignment_expression
	| expression COMMA assignment_expression
	;

constant_expression :
	conditional_expression
	;

declaration :
	function_prototype SEMICOLON
	| spirv_instruction_qualifier function_prototype SEMICOLON
	| spirv_execution_mode_qualifier SEMICOLON
	| init_declarator_list SEMICOLON
	| PRECISION precision_qualifier type_specifier SEMICOLON
	| block_structure SEMICOLON
	| block_structure IDENTIFIER SEMICOLON
	| block_structure IDENTIFIER array_specifier SEMICOLON
	| type_qualifier SEMICOLON
	| type_qualifier IDENTIFIER SEMICOLON
	| type_qualifier IDENTIFIER identifier_list SEMICOLON
	;

block_structure :
	type_qualifier IDENTIFIER LEFT_BRACE struct_declaration_list RIGHT_BRACE
	;

identifier_list :
	COMMA IDENTIFIER
	| identifier_list COMMA IDENTIFIER
	;

function_prototype :
	function_declarator RIGHT_PAREN
	| function_declarator RIGHT_PAREN attribute
	| attribute function_declarator RIGHT_PAREN
	| attribute function_declarator RIGHT_PAREN attribute
	;

function_declarator :
	function_header
	| function_header_with_parameters
	;

function_header_with_parameters :
	function_header parameter_declaration
	| function_header_with_parameters COMMA parameter_declaration
	;

function_header :
	fully_specified_type IDENTIFIER LEFT_PAREN
	;

parameter_declarator :
	type_specifier IDENTIFIER
	| type_specifier IDENTIFIER array_specifier
	;

parameter_declaration :
	type_qualifier parameter_declarator
	| parameter_declarator
	| type_qualifier parameter_type_specifier
	| parameter_type_specifier
	;

parameter_type_specifier :
	type_specifier
	;

init_declarator_list :
	single_declaration
	| init_declarator_list COMMA IDENTIFIER
	| init_declarator_list COMMA IDENTIFIER array_specifier
	| init_declarator_list COMMA IDENTIFIER array_specifier EQUAL initializer
	| init_declarator_list COMMA IDENTIFIER EQUAL initializer
	;

single_declaration :
	fully_specified_type
	| fully_specified_type IDENTIFIER
	| fully_specified_type IDENTIFIER array_specifier
	| fully_specified_type IDENTIFIER array_specifier EQUAL initializer
	| fully_specified_type IDENTIFIER EQUAL initializer
	;

fully_specified_type :
	type_specifier
	| type_qualifier type_specifier
	;

invariant_qualifier :
	INVARIANT
	;

interpolation_qualifier :
	SMOOTH
	| FLAT
	| NOPERSPECTIVE
	| EXPLICITINTERPAMD
	| PERVERTEXNV
	| PERVERTEXEXT
	| PERPRIMITIVENV
	| PERPRIMITIVEEXT
	| PERVIEWNV
	| PERTASKNV
	;

layout_qualifier :
	LAYOUT LEFT_PAREN layout_qualifier_id_list RIGHT_PAREN
	;

layout_qualifier_id_list :
	layout_qualifier_id
	| layout_qualifier_id_list COMMA layout_qualifier_id
	;

layout_qualifier_id :
	IDENTIFIER
	| IDENTIFIER EQUAL constant_expression
	| SHARED
	;

precise_qualifier :
	PRECISE
	;

type_qualifier :
	single_type_qualifier
	| type_qualifier single_type_qualifier
	;

single_type_qualifier :
	storage_qualifier
	| layout_qualifier
	| precision_qualifier
	| interpolation_qualifier
	| invariant_qualifier
	| precise_qualifier
	| non_uniform_qualifier
	| spirv_storage_class_qualifier
	| spirv_decorate_qualifier
	| SPIRV_BY_REFERENCE
	| SPIRV_LITERAL
	;

storage_qualifier :
	CONST
	| INOUT
	| IN
	| OUT
	| CENTROID
	| UNIFORM
	| TILEIMAGEEXT
	| SHARED
	| BUFFER
	| ATTRIBUTE
	| VARYING
	| PATCH
	| SAMPLE
	| HITATTRNV
	| HITOBJECTATTRNV
	| HITATTREXT
	| PAYLOADNV
	| PAYLOADEXT
	| PAYLOADINNV
	| PAYLOADINEXT
	| CALLDATANV
	| CALLDATAEXT
	| CALLDATAINNV
	| CALLDATAINEXT
	| COHERENT
	| DEVICECOHERENT
	| QUEUEFAMILYCOHERENT
	| WORKGROUPCOHERENT
	| SUBGROUPCOHERENT
	| NONPRIVATE
	| SHADERCALLCOHERENT
	| VOLATILE
	| RESTRICT
	| READONLY
	| WRITEONLY
	| SUBROUTINE
	| SUBROUTINE LEFT_PAREN type_name_list RIGHT_PAREN
	| TASKPAYLOADWORKGROUPEXT
	;

non_uniform_qualifier :
	NONUNIFORM
	;

type_name_list :
	IDENTIFIER
	| type_name_list COMMA IDENTIFIER
	;

type_specifier :
	type_specifier_nonarray type_parameter_specifier_opt
	| type_specifier_nonarray type_parameter_specifier_opt array_specifier
	;

array_specifier :
	LEFT_BRACKET RIGHT_BRACKET
	| LEFT_BRACKET conditional_expression RIGHT_BRACKET
	| array_specifier LEFT_BRACKET RIGHT_BRACKET
	| array_specifier LEFT_BRACKET conditional_expression RIGHT_BRACKET
	;

type_parameter_specifier_opt :
	type_parameter_specifier
	| /*empty*/
	;

type_parameter_specifier :
	LEFT_ANGLE type_parameter_specifier_list RIGHT_ANGLE
	;

type_parameter_specifier_list :
	type_specifier
	| unary_expression
	| type_parameter_specifier_list COMMA unary_expression
	;

type_specifier_nonarray :
	VOID
	| FLOAT
	| INT
	| UINT
	| BOOL
	| VEC2
	| VEC3
	| VEC4
	| BVEC2
	| BVEC3
	| BVEC4
	| IVEC2
	| IVEC3
	| IVEC4
	| UVEC2
	| UVEC3
	| UVEC4
	| MAT2
	| MAT3
	| MAT4
	| MAT2X2
	| MAT2X3
	| MAT2X4
	| MAT3X2
	| MAT3X3
	| MAT3X4
	| MAT4X2
	| MAT4X3
	| MAT4X4
	| DOUBLE
	| FLOAT16_T
	| FLOAT32_T
	| FLOAT64_T
	| INT8_T
	| UINT8_T
	| INT16_T
	| UINT16_T
	| INT32_T
	| UINT32_T
	| INT64_T
	| UINT64_T
	| DVEC2
	| DVEC3
	| DVEC4
	| F16VEC2
	| F16VEC3
	| F16VEC4
	| F32VEC2
	| F32VEC3
	| F32VEC4
	| F64VEC2
	| F64VEC3
	| F64VEC4
	| I8VEC2
	| I8VEC3
	| I8VEC4
	| I16VEC2
	| I16VEC3
	| I16VEC4
	| I32VEC2
	| I32VEC3
	| I32VEC4
	| I64VEC2
	| I64VEC3
	| I64VEC4
	| U8VEC2
	| U8VEC3
	| U8VEC4
	| U16VEC2
	| U16VEC3
	| U16VEC4
	| U32VEC2
	| U32VEC3
	| U32VEC4
	| U64VEC2
	| U64VEC3
	| U64VEC4
	| DMAT2
	| DMAT3
	| DMAT4
	| DMAT2X2
	| DMAT2X3
	| DMAT2X4
	| DMAT3X2
	| DMAT3X3
	| DMAT3X4
	| DMAT4X2
	| DMAT4X3
	| DMAT4X4
	| F16MAT2
	| F16MAT3
	| F16MAT4
	| F16MAT2X2
	| F16MAT2X3
	| F16MAT2X4
	| F16MAT3X2
	| F16MAT3X3
	| F16MAT3X4
	| F16MAT4X2
	| F16MAT4X3
	| F16MAT4X4
	| F32MAT2
	| F32MAT3
	| F32MAT4
	| F32MAT2X2
	| F32MAT2X3
	| F32MAT2X4
	| F32MAT3X2
	| F32MAT3X3
	| F32MAT3X4
	| F32MAT4X2
	| F32MAT4X3
	| F32MAT4X4
	| F64MAT2
	| F64MAT3
	| F64MAT4
	| F64MAT2X2
	| F64MAT2X3
	| F64MAT2X4
	| F64MAT3X2
	| F64MAT3X3
	| F64MAT3X4
	| F64MAT4X2
	| F64MAT4X3
	| F64MAT4X4
	| ACCSTRUCTNV
	| ACCSTRUCTEXT
	| RAYQUERYEXT
	| ATOMIC_UINT
	| SAMPLER1D
	| SAMPLER2D
	| SAMPLER3D
	| SAMPLERCUBE
	| SAMPLER2DSHADOW
	| SAMPLERCUBESHADOW
	| SAMPLER2DARRAY
	| SAMPLER2DARRAYSHADOW
	| SAMPLER1DSHADOW
	| SAMPLER1DARRAY
	| SAMPLER1DARRAYSHADOW
	| SAMPLERCUBEARRAY
	| SAMPLERCUBEARRAYSHADOW
	| F16SAMPLER1D
	| F16SAMPLER2D
	| F16SAMPLER3D
	| F16SAMPLERCUBE
	| F16SAMPLER1DSHADOW
	| F16SAMPLER2DSHADOW
	| F16SAMPLERCUBESHADOW
	| F16SAMPLER1DARRAY
	| F16SAMPLER2DARRAY
	| F16SAMPLER1DARRAYSHADOW
	| F16SAMPLER2DARRAYSHADOW
	| F16SAMPLERCUBEARRAY
	| F16SAMPLERCUBEARRAYSHADOW
	| ISAMPLER1D
	| ISAMPLER2D
	| ISAMPLER3D
	| ISAMPLERCUBE
	| ISAMPLER2DARRAY
	| USAMPLER2D
	| USAMPLER3D
	| USAMPLERCUBE
	| ISAMPLER1DARRAY
	| ISAMPLERCUBEARRAY
	| USAMPLER1D
	| USAMPLER1DARRAY
	| USAMPLERCUBEARRAY
	| TEXTURECUBEARRAY
	| ITEXTURECUBEARRAY
	| UTEXTURECUBEARRAY
	| USAMPLER2DARRAY
	| TEXTURE2D
	| TEXTURE3D
	| TEXTURE2DARRAY
	| TEXTURECUBE
	| ITEXTURE2D
	| ITEXTURE3D
	| ITEXTURECUBE
	| ITEXTURE2DARRAY
	| UTEXTURE2D
	| UTEXTURE3D
	| UTEXTURECUBE
	| UTEXTURE2DARRAY
	| SAMPLER
	| SAMPLERSHADOW
	| SAMPLER2DRECT
	| SAMPLER2DRECTSHADOW
	| F16SAMPLER2DRECT
	| F16SAMPLER2DRECTSHADOW
	| ISAMPLER2DRECT
	| USAMPLER2DRECT
	| SAMPLERBUFFER
	| F16SAMPLERBUFFER
	| ISAMPLERBUFFER
	| USAMPLERBUFFER
	| SAMPLER2DMS
	| F16SAMPLER2DMS
	| ISAMPLER2DMS
	| USAMPLER2DMS
	| SAMPLER2DMSARRAY
	| F16SAMPLER2DMSARRAY
	| ISAMPLER2DMSARRAY
	| USAMPLER2DMSARRAY
	| TEXTURE1D
	| F16TEXTURE1D
	| F16TEXTURE2D
	| F16TEXTURE3D
	| F16TEXTURECUBE
	| TEXTURE1DARRAY
	| F16TEXTURE1DARRAY
	| F16TEXTURE2DARRAY
	| F16TEXTURECUBEARRAY
	| ITEXTURE1D
	| ITEXTURE1DARRAY
	| UTEXTURE1D
	| UTEXTURE1DARRAY
	| TEXTURE2DRECT
	| F16TEXTURE2DRECT
	| ITEXTURE2DRECT
	| UTEXTURE2DRECT
	| TEXTUREBUFFER
	| F16TEXTUREBUFFER
	| ITEXTUREBUFFER
	| UTEXTUREBUFFER
	| TEXTURE2DMS
	| F16TEXTURE2DMS
	| ITEXTURE2DMS
	| UTEXTURE2DMS
	| TEXTURE2DMSARRAY
	| F16TEXTURE2DMSARRAY
	| ITEXTURE2DMSARRAY
	| UTEXTURE2DMSARRAY
	| IMAGE1D
	| F16IMAGE1D
	| IIMAGE1D
	| UIMAGE1D
	| IMAGE2D
	| F16IMAGE2D
	| IIMAGE2D
	| UIMAGE2D
	| IMAGE3D
	| F16IMAGE3D
	| IIMAGE3D
	| UIMAGE3D
	| IMAGE2DRECT
	| F16IMAGE2DRECT
	| IIMAGE2DRECT
	| UIMAGE2DRECT
	| IMAGECUBE
	| F16IMAGECUBE
	| IIMAGECUBE
	| UIMAGECUBE
	| IMAGEBUFFER
	| F16IMAGEBUFFER
	| IIMAGEBUFFER
	| UIMAGEBUFFER
	| IMAGE1DARRAY
	| F16IMAGE1DARRAY
	| IIMAGE1DARRAY
	| UIMAGE1DARRAY
	| IMAGE2DARRAY
	| F16IMAGE2DARRAY
	| IIMAGE2DARRAY
	| UIMAGE2DARRAY
	| IMAGECUBEARRAY
	| F16IMAGECUBEARRAY
	| IIMAGECUBEARRAY
	| UIMAGECUBEARRAY
	| IMAGE2DMS
	| F16IMAGE2DMS
	| IIMAGE2DMS
	| UIMAGE2DMS
	| IMAGE2DMSARRAY
	| F16IMAGE2DMSARRAY
	| IIMAGE2DMSARRAY
	| UIMAGE2DMSARRAY
	| I64IMAGE1D
	| U64IMAGE1D
	| I64IMAGE2D
	| U64IMAGE2D
	| I64IMAGE3D
	| U64IMAGE3D
	| I64IMAGE2DRECT
	| U64IMAGE2DRECT
	| I64IMAGECUBE
	| U64IMAGECUBE
	| I64IMAGEBUFFER
	| U64IMAGEBUFFER
	| I64IMAGE1DARRAY
	| U64IMAGE1DARRAY
	| I64IMAGE2DARRAY
	| U64IMAGE2DARRAY
	| I64IMAGECUBEARRAY
	| U64IMAGECUBEARRAY
	| I64IMAGE2DMS
	| U64IMAGE2DMS
	| I64IMAGE2DMSARRAY
	| U64IMAGE2DMSARRAY
	| SAMPLEREXTERNALOES
	| SAMPLEREXTERNAL2DY2YEXT
	| ATTACHMENTEXT
	| IATTACHMENTEXT
	| UATTACHMENTEXT
	| SUBPASSINPUT
	| SUBPASSINPUTMS
	| F16SUBPASSINPUT
	| F16SUBPASSINPUTMS
	| ISUBPASSINPUT
	| ISUBPASSINPUTMS
	| USUBPASSINPUT
	| USUBPASSINPUTMS
	| FCOOPMATNV
	| ICOOPMATNV
	| UCOOPMATNV
	| COOPMAT
	| spirv_type_specifier
	| HITOBJECTNV
	| struct_specifier
	| TYPE_NAME
	;

precision_qualifier :
	HIGH_PRECISION
	| MEDIUM_PRECISION
	| LOW_PRECISION
	;

struct_specifier :
	STRUCT IDENTIFIER LEFT_BRACE struct_declaration_list RIGHT_BRACE
	| STRUCT LEFT_BRACE struct_declaration_list RIGHT_BRACE
	;

struct_declaration_list :
	struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration :
	type_specifier struct_declarator_list SEMICOLON
	| type_qualifier type_specifier struct_declarator_list SEMICOLON
	;

struct_declarator_list :
	struct_declarator
	| struct_declarator_list COMMA struct_declarator
	;

struct_declarator :
	IDENTIFIER
	| IDENTIFIER array_specifier
	;

initializer :
	assignment_expression
	| LEFT_BRACE initializer_list RIGHT_BRACE
	| LEFT_BRACE initializer_list COMMA RIGHT_BRACE
	| LEFT_BRACE RIGHT_BRACE
	;

initializer_list :
	initializer
	| initializer_list COMMA initializer
	;

declaration_statement :
	declaration
	;

statement :
	compound_statement
	| simple_statement
	;

simple_statement :
	declaration_statement
	| expression_statement
	| selection_statement
	| switch_statement
	| case_label
	| iteration_statement
	| jump_statement
	| demote_statement
	;

demote_statement :
	DEMOTE SEMICOLON
	;

compound_statement :
	LEFT_BRACE RIGHT_BRACE
	| LEFT_BRACE statement_list RIGHT_BRACE
	;

statement_no_new_scope :
	compound_statement_no_new_scope
	| simple_statement
	;

statement_scoped :
	compound_statement
	| simple_statement
	;

compound_statement_no_new_scope :
	LEFT_BRACE RIGHT_BRACE
	| LEFT_BRACE statement_list RIGHT_BRACE
	;

statement_list :
	statement
	| statement_list statement
	;

expression_statement :
	SEMICOLON
	| expression SEMICOLON
	;

selection_statement :
	selection_statement_nonattributed
	| attribute selection_statement_nonattributed
	;

selection_statement_nonattributed :
	IF LEFT_PAREN expression RIGHT_PAREN selection_rest_statement
	;

selection_rest_statement :
	statement_scoped ELSE statement_scoped
	| statement_scoped
	;

condition :
	expression
	| fully_specified_type IDENTIFIER EQUAL initializer
	;

switch_statement :
	switch_statement_nonattributed
	| attribute switch_statement_nonattributed
	;

switch_statement_nonattributed :
	SWITCH LEFT_PAREN expression RIGHT_PAREN LEFT_BRACE switch_statement_list RIGHT_BRACE
	;

switch_statement_list :
	/*empty*/
	| statement_list
	;

case_label :
	CASE expression COLON
	| DEFAULT COLON
	;

iteration_statement :
	iteration_statement_nonattributed
	| attribute iteration_statement_nonattributed
	;

iteration_statement_nonattributed :
	WHILE LEFT_PAREN condition RIGHT_PAREN statement_no_new_scope
	| DO statement WHILE LEFT_PAREN expression RIGHT_PAREN SEMICOLON
	| FOR LEFT_PAREN for_init_statement for_rest_statement RIGHT_PAREN statement_no_new_scope
	;

for_init_statement :
	expression_statement
	| declaration_statement
	;

conditionopt :
	condition
	| /*empty*/
	;

for_rest_statement :
	conditionopt SEMICOLON
	| conditionopt SEMICOLON expression
	;

jump_statement :
	CONTINUE SEMICOLON
	| BREAK SEMICOLON
	| RETURN SEMICOLON
	| RETURN expression SEMICOLON
	| DISCARD SEMICOLON
	| TERMINATE_INVOCATION SEMICOLON
	| TERMINATE_RAY SEMICOLON
	| IGNORE_INTERSECTION SEMICOLON
	;

translation_unit :
	external_declaration
	| translation_unit external_declaration
	;

external_declaration :
	function_definition
	| declaration
	| SEMICOLON
	;

function_definition :
	function_prototype compound_statement_no_new_scope
	;

attribute :
	LEFT_BRACKET LEFT_BRACKET attribute_list RIGHT_BRACKET RIGHT_BRACKET
	;

attribute_list :
	single_attribute
	| attribute_list COMMA single_attribute
	;

single_attribute :
	IDENTIFIER
	| IDENTIFIER LEFT_PAREN constant_expression RIGHT_PAREN
	;

spirv_requirements_list :
	spirv_requirements_parameter
	| spirv_requirements_list COMMA spirv_requirements_parameter
	;

spirv_requirements_parameter :
	IDENTIFIER EQUAL LEFT_BRACKET spirv_extension_list RIGHT_BRACKET
	| IDENTIFIER EQUAL LEFT_BRACKET spirv_capability_list RIGHT_BRACKET
	;

spirv_extension_list :
	STRING_LITERAL
	| spirv_extension_list COMMA STRING_LITERAL
	;

spirv_capability_list :
	INTCONSTANT
	| spirv_capability_list COMMA INTCONSTANT
	;

spirv_execution_mode_qualifier :
	SPIRV_EXECUTION_MODE LEFT_PAREN INTCONSTANT RIGHT_PAREN
	| SPIRV_EXECUTION_MODE LEFT_PAREN spirv_requirements_list COMMA INTCONSTANT RIGHT_PAREN
	| SPIRV_EXECUTION_MODE LEFT_PAREN INTCONSTANT COMMA spirv_execution_mode_parameter_list RIGHT_PAREN
	| SPIRV_EXECUTION_MODE LEFT_PAREN spirv_requirements_list COMMA INTCONSTANT COMMA spirv_execution_mode_parameter_list RIGHT_PAREN
	| SPIRV_EXECUTION_MODE_ID LEFT_PAREN INTCONSTANT COMMA spirv_execution_mode_id_parameter_list RIGHT_PAREN
	| SPIRV_EXECUTION_MODE_ID LEFT_PAREN spirv_requirements_list COMMA INTCONSTANT COMMA spirv_execution_mode_id_parameter_list RIGHT_PAREN
	;

spirv_execution_mode_parameter_list :
	spirv_execution_mode_parameter
	| spirv_execution_mode_parameter_list COMMA spirv_execution_mode_parameter
	;

spirv_execution_mode_parameter :
	FLOATCONSTANT
	| INTCONSTANT
	| UINTCONSTANT
	| BOOLCONSTANT
	| STRING_LITERAL
	;

spirv_execution_mode_id_parameter_list :
	constant_expression
	| spirv_execution_mode_id_parameter_list COMMA constant_expression
	;

spirv_storage_class_qualifier :
	SPIRV_STORAGE_CLASS LEFT_PAREN INTCONSTANT RIGHT_PAREN
	| SPIRV_STORAGE_CLASS LEFT_PAREN spirv_requirements_list COMMA INTCONSTANT RIGHT_PAREN
	;

spirv_decorate_qualifier :
	SPIRV_DECORATE LEFT_PAREN INTCONSTANT RIGHT_PAREN
	| SPIRV_DECORATE LEFT_PAREN spirv_requirements_list COMMA INTCONSTANT RIGHT_PAREN
	| SPIRV_DECORATE LEFT_PAREN INTCONSTANT COMMA spirv_decorate_parameter_list RIGHT_PAREN
	| SPIRV_DECORATE LEFT_PAREN spirv_requirements_list COMMA INTCONSTANT COMMA spirv_decorate_parameter_list RIGHT_PAREN
	| SPIRV_DECORATE_ID LEFT_PAREN INTCONSTANT COMMA spirv_decorate_id_parameter_list RIGHT_PAREN
	| SPIRV_DECORATE_ID LEFT_PAREN spirv_requirements_list COMMA INTCONSTANT COMMA spirv_decorate_id_parameter_list RIGHT_PAREN
	| SPIRV_DECORATE_STRING LEFT_PAREN INTCONSTANT COMMA spirv_decorate_string_parameter_list RIGHT_PAREN
	| SPIRV_DECORATE_STRING LEFT_PAREN spirv_requirements_list COMMA INTCONSTANT COMMA spirv_decorate_string_parameter_list RIGHT_PAREN
	;

spirv_decorate_parameter_list :
	spirv_decorate_parameter
	| spirv_decorate_parameter_list COMMA spirv_decorate_parameter
	;

spirv_decorate_parameter :
	FLOATCONSTANT
	| INTCONSTANT
	| UINTCONSTANT
	| BOOLCONSTANT
	;

spirv_decorate_id_parameter_list :
	spirv_decorate_id_parameter
	| spirv_decorate_id_parameter_list COMMA spirv_decorate_id_parameter
	;

spirv_decorate_id_parameter :
	variable_identifier
	| FLOATCONSTANT
	| INTCONSTANT
	| UINTCONSTANT
	| BOOLCONSTANT
	;

spirv_decorate_string_parameter_list :
	STRING_LITERAL
	| spirv_decorate_string_parameter_list COMMA STRING_LITERAL
	;

spirv_type_specifier :
	SPIRV_TYPE LEFT_PAREN spirv_instruction_qualifier_list COMMA spirv_type_parameter_list RIGHT_PAREN
	| SPIRV_TYPE LEFT_PAREN spirv_requirements_list COMMA spirv_instruction_qualifier_list COMMA spirv_type_parameter_list RIGHT_PAREN
	| SPIRV_TYPE LEFT_PAREN spirv_instruction_qualifier_list RIGHT_PAREN
	| SPIRV_TYPE LEFT_PAREN spirv_requirements_list COMMA spirv_instruction_qualifier_list RIGHT_PAREN
	;

spirv_type_parameter_list :
	spirv_type_parameter
	| spirv_type_parameter_list COMMA spirv_type_parameter
	;

spirv_type_parameter :
	constant_expression
	| type_specifier_nonarray
	;

spirv_instruction_qualifier :
	SPIRV_INSTRUCTION LEFT_PAREN spirv_instruction_qualifier_list RIGHT_PAREN
	| SPIRV_INSTRUCTION LEFT_PAREN spirv_requirements_list COMMA spirv_instruction_qualifier_list RIGHT_PAREN
	;

spirv_instruction_qualifier_list :
	spirv_instruction_qualifier_id
	| spirv_instruction_qualifier_list COMMA spirv_instruction_qualifier_id
	;

spirv_instruction_qualifier_id :
	IDENTIFIER EQUAL STRING_LITERAL
	| IDENTIFIER EQUAL INTCONSTANT
	;

%%

O   [0-7]
D   [0-9]
NZ  [1-9]
L   [a-zA-Z_]
A   [a-zA-Z_0-9]
H   [a-fA-F0-9]
HP  (0[xX])
E   ([Ee][+-]?{D}+)
P   ([Pp][+-]?{D}+)
FS  (f|F|l|L)
IS  (((u|U)(l|L|ll|LL)?)|((l|L|ll|LL)(u|U)?))
CP  (u|U|L)
SP  (u8|u|U|L)
ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))
WS  [ \t\v\n\r\f]

%%

{WS}+	skip()
"/*"(?s:.)*?"*/"			skip()
"//".*					skip()
//"#".*                     		skip()

"const"                   CONST
"uniform"                 UNIFORM
"tileImageEXT"            TILEIMAGEEXT
"buffer"                  BUFFER
"in"                      IN
"out"                     OUT
"smooth"                  SMOOTH
"flat"                    FLAT
"centroid"                CENTROID
"invariant"               INVARIANT
//"packed"                  PACKED
//"resource"                RESOURCE
"inout"                   INOUT
"struct"                  STRUCT
"break"                   BREAK
"continue"                CONTINUE
"do"                      DO
"for"                     FOR
"while"                   WHILE
"switch"                  SWITCH
"case"                    CASE
"default"                 DEFAULT
"if"                      IF
"else"                    ELSE
"discard"                 DISCARD
"terminateInvocation"     TERMINATE_INVOCATION
"terminateRayEXT"         TERMINATE_RAY
"ignoreIntersectionEXT"   IGNORE_INTERSECTION
"return"                  RETURN
"void"                    VOID
"bool"                    BOOL
"float"                   FLOAT
"int"                     INT
"bvec2"                   BVEC2
"bvec3"                   BVEC3
"bvec4"                   BVEC4
"vec2"                    VEC2
"vec3"                    VEC3
"vec4"                    VEC4
"ivec2"                   IVEC2
"ivec3"                   IVEC3
"ivec4"                   IVEC4
"mat2"                    MAT2
"mat3"                    MAT3
"mat4"                    MAT4
"true"                    BOOLCONSTANT
"false"                   BOOLCONSTANT
"layout"                  LAYOUT
"shared"                  SHARED
"highp"                   HIGH_PRECISION
"mediump"                 MEDIUM_PRECISION
"lowp"                    LOW_PRECISION
//"superp"                  SUPERP
"precision"               PRECISION
"mat2x2"                  MAT2X2
"mat2x3"                  MAT2X3
"mat2x4"                  MAT2X4
"mat3x2"                  MAT3X2
"mat3x3"                  MAT3X3
"mat3x4"                  MAT3X4
"mat4x2"                  MAT4X2
"mat4x3"                  MAT4X3
"mat4x4"                  MAT4X4
"uint"                    UINT
"uvec2"                   UVEC2
"uvec3"                   UVEC3
"uvec4"                   UVEC4

"nonuniformEXT"           NONUNIFORM
"demote"                  DEMOTE
"attribute"               ATTRIBUTE
"varying"                 VARYING
"noperspective"           NOPERSPECTIVE
"coherent"                COHERENT
"devicecoherent"          DEVICECOHERENT
"queuefamilycoherent"     QUEUEFAMILYCOHERENT
"workgroupcoherent"       WORKGROUPCOHERENT
"subgroupcoherent"        SUBGROUPCOHERENT
"shadercallcoherent"      SHADERCALLCOHERENT
"nonprivate"              NONPRIVATE
"restrict"                RESTRICT
"readonly"                READONLY
"writeonly"               WRITEONLY
"atomic_uint"             ATOMIC_UINT
"volatile"                VOLATILE
"patch"                   PATCH
"sample"                  SAMPLE
"subroutine"              SUBROUTINE
"dmat2"                   DMAT2
"dmat3"                   DMAT3
"dmat4"                   DMAT4
"dmat2x2"                 DMAT2X2
"dmat2x3"                 DMAT2X3
"dmat2x4"                 DMAT2X4
"dmat3x2"                 DMAT3X2
"dmat3x3"                 DMAT3X3
"dmat3x4"                 DMAT3X4
"dmat4x2"                 DMAT4X2
"dmat4x3"                 DMAT4X3
"dmat4x4"                 DMAT4X4
"image1D"                 IMAGE1D
"iimage1D"                IIMAGE1D
"uimage1D"                UIMAGE1D
"image2D"                 IMAGE2D
"iimage2D"                IIMAGE2D
"uimage2D"                UIMAGE2D
"image3D"                 IMAGE3D
"iimage3D"                IIMAGE3D
"uimage3D"                UIMAGE3D
"image2DRect"             IMAGE2DRECT
"iimage2DRect"            IIMAGE2DRECT
"uimage2DRect"            UIMAGE2DRECT
"imageCube"               IMAGECUBE
"iimageCube"              IIMAGECUBE
"uimageCube"              UIMAGECUBE
"imageBuffer"             IMAGEBUFFER
"iimageBuffer"            IIMAGEBUFFER
"uimageBuffer"            UIMAGEBUFFER
"image1DArray"            IMAGE1DARRAY
"iimage1DArray"           IIMAGE1DARRAY
"uimage1DArray"           UIMAGE1DARRAY
"image2DArray"            IMAGE2DARRAY
"iimage2DArray"           IIMAGE2DARRAY
"uimage2DArray"           UIMAGE2DARRAY
"imageCubeArray"          IMAGECUBEARRAY
"iimageCubeArray"         IIMAGECUBEARRAY
"uimageCubeArray"         UIMAGECUBEARRAY
"image2DMS"               IMAGE2DMS
"iimage2DMS"              IIMAGE2DMS
"uimage2DMS"              UIMAGE2DMS
"image2DMSArray"          IMAGE2DMSARRAY
"iimage2DMSArray"         IIMAGE2DMSARRAY
"uimage2DMSArray"         UIMAGE2DMSARRAY
"i64image1D"              I64IMAGE1D
"u64image1D"              U64IMAGE1D
"i64image2D"              I64IMAGE2D
"u64image2D"              U64IMAGE2D
"i64image3D"              I64IMAGE3D
"u64image3D"              U64IMAGE3D
"i64image2DRect"          I64IMAGE2DRECT
"u64image2DRect"          U64IMAGE2DRECT
"i64imageCube"            I64IMAGECUBE
"u64imageCube"            U64IMAGECUBE
"i64imageBuffer"          I64IMAGEBUFFER
"u64imageBuffer"          U64IMAGEBUFFER
"i64image1DArray"         I64IMAGE1DARRAY
"u64image1DArray"         U64IMAGE1DARRAY
"i64image2DArray"         I64IMAGE2DARRAY
"u64image2DArray"         U64IMAGE2DARRAY
"i64imageCubeArray"       I64IMAGECUBEARRAY
"u64imageCubeArray"       U64IMAGECUBEARRAY
"i64image2DMS"            I64IMAGE2DMS
"u64image2DMS"            U64IMAGE2DMS
"i64image2DMSArray"       I64IMAGE2DMSARRAY
"u64image2DMSArray"       U64IMAGE2DMSARRAY
"double"                  DOUBLE
"dvec2"                   DVEC2
"dvec3"                   DVEC3
"dvec4"                   DVEC4
"int64_t"                 INT64_T
"uint64_t"                UINT64_T
"i64vec2"                 I64VEC2
"i64vec3"                 I64VEC3
"i64vec4"                 I64VEC4
"u64vec2"                 U64VEC2
"u64vec3"                 U64VEC3
"u64vec4"                 U64VEC4

// GL_EXT_shader_explicit_arithmetic_types
"int8_t"                  INT8_T
"i8vec2"                  I8VEC2
"i8vec3"                  I8VEC3
"i8vec4"                  I8VEC4
"uint8_t"                 UINT8_T
"u8vec2"                  U8VEC2
"u8vec3"                  U8VEC3
"u8vec4"                  U8VEC4

"int16_t"                 INT16_T
"i16vec2"                 I16VEC2
"i16vec3"                 I16VEC3
"i16vec4"                 I16VEC4
"uint16_t"                UINT16_T
"u16vec2"                 U16VEC2
"u16vec3"                 U16VEC3
"u16vec4"                 U16VEC4

"int32_t"                 INT32_T
"i32vec2"                 I32VEC2
"i32vec3"                 I32VEC3
"i32vec4"                 I32VEC4
"uint32_t"                UINT32_T
"u32vec2"                 U32VEC2
"u32vec3"                 U32VEC3
"u32vec4"                 U32VEC4

"float16_t"               FLOAT16_T
"f16vec2"                 F16VEC2
"f16vec3"                 F16VEC3
"f16vec4"                 F16VEC4
"f16mat2"                 F16MAT2
"f16mat3"                 F16MAT3
"f16mat4"                 F16MAT4
"f16mat2x2"               F16MAT2X2
"f16mat2x3"               F16MAT2X3
"f16mat2x4"               F16MAT2X4
"f16mat3x2"               F16MAT3X2
"f16mat3x3"               F16MAT3X3
"f16mat3x4"               F16MAT3X4
"f16mat4x2"               F16MAT4X2
"f16mat4x3"               F16MAT4X3
"f16mat4x4"               F16MAT4X4

"float32_t"               FLOAT32_T
"f32vec2"                 F32VEC2
"f32vec3"                 F32VEC3
"f32vec4"                 F32VEC4
"f32mat2"                 F32MAT2
"f32mat3"                 F32MAT3
"f32mat4"                 F32MAT4
"f32mat2x2"               F32MAT2X2
"f32mat2x3"               F32MAT2X3
"f32mat2x4"               F32MAT2X4
"f32mat3x2"               F32MAT3X2
"f32mat3x3"               F32MAT3X3
"f32mat3x4"               F32MAT3X4
"f32mat4x2"               F32MAT4X2
"f32mat4x3"               F32MAT4X3
"f32mat4x4"               F32MAT4X4
"float64_t"               FLOAT64_T
"f64vec2"                 F64VEC2
"f64vec3"                 F64VEC3
"f64vec4"                 F64VEC4
"f64mat2"                 F64MAT2
"f64mat3"                 F64MAT3
"f64mat4"                 F64MAT4
"f64mat2x2"               F64MAT2X2
"f64mat2x3"               F64MAT2X3
"f64mat2x4"               F64MAT2X4
"f64mat3x2"               F64MAT3X2
"f64mat3x3"               F64MAT3X3
"f64mat3x4"               F64MAT3X4
"f64mat4x2"               F64MAT4X2
"f64mat4x3"               F64MAT4X3
"f64mat4x4"               F64MAT4X4

// GL_EXT_spirv_intrinsics
"spirv_instruction"       SPIRV_INSTRUCTION
"spirv_execution_mode"    SPIRV_EXECUTION_MODE
"spirv_execution_mode_id" SPIRV_EXECUTION_MODE_ID
"spirv_decorate"          SPIRV_DECORATE
"spirv_decorate_id"       SPIRV_DECORATE_ID
"spirv_decorate_string"   SPIRV_DECORATE_STRING
"spirv_type"              SPIRV_TYPE
"spirv_storage_class"     SPIRV_STORAGE_CLASS
"spirv_by_reference"      SPIRV_BY_REFERENCE
"spirv_literal"           SPIRV_LITERAL

"sampler2D"               SAMPLER2D
"samplerCube"             SAMPLERCUBE
"samplerCubeShadow"       SAMPLERCUBESHADOW
"sampler2DArray"          SAMPLER2DARRAY
"sampler2DArrayShadow"    SAMPLER2DARRAYSHADOW
"isampler2D"              ISAMPLER2D
"isampler3D"              ISAMPLER3D
"isamplerCube"            ISAMPLERCUBE
"isampler2DArray"         ISAMPLER2DARRAY
"usampler2D"              USAMPLER2D
"usampler3D"              USAMPLER3D
"usamplerCube"            USAMPLERCUBE
"usampler2DArray"         USAMPLER2DARRAY
"sampler3D"               SAMPLER3D
"sampler2DShadow"         SAMPLER2DSHADOW

"texture2D"               TEXTURE2D
"textureCube"             TEXTURECUBE
"texture2DArray"          TEXTURE2DARRAY
"itexture2D"              ITEXTURE2D
"itexture3D"              ITEXTURE3D
"itextureCube"            ITEXTURECUBE
"itexture2DArray"         ITEXTURE2DARRAY
"utexture2D"              UTEXTURE2D
"utexture3D"              UTEXTURE3D
"utextureCube"            UTEXTURECUBE
"utexture2DArray"         UTEXTURE2DARRAY
"texture3D"               TEXTURE3D

"sampler"                 SAMPLER
"samplerShadow"           SAMPLERSHADOW

"textureCubeArray"        TEXTURECUBEARRAY
"itextureCubeArray"       ITEXTURECUBEARRAY
"utextureCubeArray"       UTEXTURECUBEARRAY
"samplerCubeArray"        SAMPLERCUBEARRAY
"samplerCubeArrayShadow"  SAMPLERCUBEARRAYSHADOW
"isamplerCubeArray"       ISAMPLERCUBEARRAY
"usamplerCubeArray"       USAMPLERCUBEARRAY
"sampler1DArrayShadow"    SAMPLER1DARRAYSHADOW
"isampler1DArray"         ISAMPLER1DARRAY
"usampler1D"              USAMPLER1D
"isampler1D"              ISAMPLER1D
"usampler1DArray"         USAMPLER1DARRAY
"samplerBuffer"           SAMPLERBUFFER
"isampler2DRect"          ISAMPLER2DRECT
"usampler2DRect"          USAMPLER2DRECT
"isamplerBuffer"          ISAMPLERBUFFER
"usamplerBuffer"          USAMPLERBUFFER
"sampler2DMS"             SAMPLER2DMS
"isampler2DMS"            ISAMPLER2DMS
"usampler2DMS"            USAMPLER2DMS
"sampler2DMSArray"        SAMPLER2DMSARRAY
"isampler2DMSArray"       ISAMPLER2DMSARRAY
"usampler2DMSArray"       USAMPLER2DMSARRAY
"sampler1D"               SAMPLER1D
"sampler1DShadow"         SAMPLER1DSHADOW
"sampler2DRect"           SAMPLER2DRECT
"sampler2DRectShadow"     SAMPLER2DRECTSHADOW
"sampler1DArray"          SAMPLER1DARRAY

"samplerExternalOES"      SAMPLEREXTERNALOES // GL_OES_EGL_image_external

"__samplerExternal2DY2YEXT" SAMPLEREXTERNAL2DY2YEXT // GL_EXT_YUV_target

"itexture1DArray"         ITEXTURE1DARRAY
"utexture1D"              UTEXTURE1D
"itexture1D"              ITEXTURE1D
"utexture1DArray"         UTEXTURE1DARRAY
"textureBuffer"           TEXTUREBUFFER
"itexture2DRect"          ITEXTURE2DRECT
"utexture2DRect"          UTEXTURE2DRECT
"itextureBuffer"          ITEXTUREBUFFER
"utextureBuffer"          UTEXTUREBUFFER
"texture2DMS"             TEXTURE2DMS
"itexture2DMS"            ITEXTURE2DMS
"utexture2DMS"            UTEXTURE2DMS
"texture2DMSArray"        TEXTURE2DMSARRAY
"itexture2DMSArray"       ITEXTURE2DMSARRAY
"utexture2DMSArray"       UTEXTURE2DMSARRAY
"texture1D"               TEXTURE1D
"texture2DRect"           TEXTURE2DRECT
"texture1DArray"          TEXTURE1DARRAY

"attachmentEXT"           ATTACHMENTEXT
"iattachmentEXT"          IATTACHMENTEXT
"uattachmentEXT"          UATTACHMENTEXT

"subpassInput"            SUBPASSINPUT
"subpassInputMS"          SUBPASSINPUTMS
"isubpassInput"           ISUBPASSINPUT
"isubpassInputMS"         ISUBPASSINPUTMS
"usubpassInput"           USUBPASSINPUT
"usubpassInputMS"         USUBPASSINPUTMS

"f16sampler1D"                 F16SAMPLER1D
"f16sampler2D"                 F16SAMPLER2D
"f16sampler3D"                 F16SAMPLER3D
"f16sampler2DRect"             F16SAMPLER2DRECT
"f16samplerCube"               F16SAMPLERCUBE
"f16sampler1DArray"            F16SAMPLER1DARRAY
"f16sampler2DArray"            F16SAMPLER2DARRAY
"f16samplerCubeArray"          F16SAMPLERCUBEARRAY
"f16samplerBuffer"             F16SAMPLERBUFFER
"f16sampler2DMS"               F16SAMPLER2DMS
"f16sampler2DMSArray"          F16SAMPLER2DMSARRAY
"f16sampler1DShadow"           F16SAMPLER1DSHADOW
"f16sampler2DShadow"           F16SAMPLER2DSHADOW
"f16sampler2DRectShadow"       F16SAMPLER2DRECTSHADOW
"f16samplerCubeShadow"         F16SAMPLERCUBESHADOW
"f16sampler1DArrayShadow"      F16SAMPLER1DARRAYSHADOW
"f16sampler2DArrayShadow"      F16SAMPLER2DARRAYSHADOW
"f16samplerCubeArrayShadow"    F16SAMPLERCUBEARRAYSHADOW

"f16image1D"                   F16IMAGE1D
"f16image2D"                   F16IMAGE2D
"f16image3D"                   F16IMAGE3D
"f16image2DRect"               F16IMAGE2DRECT
"f16imageCube"                 F16IMAGECUBE
"f16image1DArray"              F16IMAGE1DARRAY
"f16image2DArray"              F16IMAGE2DARRAY
"f16imageCubeArray"            F16IMAGECUBEARRAY
"f16imageBuffer"               F16IMAGEBUFFER
"f16image2DMS"                 F16IMAGE2DMS
"f16image2DMSArray"            F16IMAGE2DMSARRAY

"f16texture1D"                 F16TEXTURE1D
"f16texture2D"                 F16TEXTURE2D
"f16texture3D"                 F16TEXTURE3D
"f16texture2DRect"             F16TEXTURE2DRECT
"f16textureCube"               F16TEXTURECUBE
"f16texture1DArray"            F16TEXTURE1DARRAY
"f16texture2DArray"            F16TEXTURE2DARRAY
"f16textureCubeArray"          F16TEXTURECUBEARRAY
"f16textureBuffer"             F16TEXTUREBUFFER
"f16texture2DMS"               F16TEXTURE2DMS
"f16texture2DMSArray"          F16TEXTURE2DMSARRAY

"f16subpassInput"              F16SUBPASSINPUT
"f16subpassInputMS"            F16SUBPASSINPUTMS
"__explicitInterpAMD"     EXPLICITINTERPAMD
"pervertexNV"             PERVERTEXNV
"pervertexEXT"            PERVERTEXEXT
"precise"                 PRECISE

"rayPayloadNV"            PAYLOADNV
"rayPayloadEXT"           PAYLOADEXT
"rayPayloadInNV"          PAYLOADINNV
"rayPayloadInEXT"         PAYLOADINEXT
"hitAttributeNV"          HITATTRNV
"hitAttributeEXT"         HITATTREXT
"callableDataNV"          CALLDATANV
"callableDataEXT"         CALLDATAEXT
"callableDataInNV"        CALLDATAINNV
"callableDataInEXT"       CALLDATAINEXT
"accelerationStructureNV" ACCSTRUCTNV
"accelerationStructureEXT"    ACCSTRUCTEXT
"rayQueryEXT"              RAYQUERYEXT
"perprimitiveNV"          PERPRIMITIVENV
"perviewNV"               PERVIEWNV
"taskNV"                  PERTASKNV
"perprimitiveEXT"         PERPRIMITIVEEXT
"taskPayloadSharedEXT"    TASKPAYLOADWORKGROUPEXT

"fcoopmatNV"              FCOOPMATNV
"icoopmatNV"              ICOOPMATNV
"ucoopmatNV"              UCOOPMATNV

"coopmat"                 COOPMAT

"hitObjectNV"             HITOBJECTNV
"hitObjectAttributeNV"    HITOBJECTATTRNV

"+="	ADD_ASSIGN
"&"	AMPERSAND
"&="	AND_ASSIGN
"&&"	AND_OP
"!"	BANG
"^"	CARET
":"	COLON
","	COMMA
"#"	DASH
"--"	DEC_OP
"/="	DIV_ASSIGN
"."	DOT
"=="	EQ_OP
"="	EQUAL
">="	GE_OP
"++"	INC_OP
"<"	LEFT_ANGLE
"<<="	LEFT_ASSIGN
"{"	LEFT_BRACE
"["	LEFT_BRACKET
"<<"	LEFT_OP
"("	LEFT_PAREN
"<="	LE_OP
"%="	MOD_ASSIGN
"*="	MUL_ASSIGN
"!="	NE_OP
"|="	OR_ASSIGN
"||"	OR_OP
"%"	PERCENT
"+"	PLUS
"?"	QUESTION
">"	RIGHT_ANGLE
">>="	RIGHT_ASSIGN
"}"	RIGHT_BRACE
"]"	RIGHT_BRACKET
">>"	RIGHT_OP
")"	RIGHT_PAREN
";"	SEMICOLON
"/"	SLASH
"*"	STAR
"-="	SUB_ASSIGN
"~"	TILDE
"|"	VERTICAL_BAR
"^="	XOR_ASSIGN
"^"	XOR_OP

INT16CONSTANT	INT16CONSTANT
INT32CONSTANT	INT32CONSTANT
INT64CONSTANT	INT64CONSTANT
INTCONSTANT	INTCONSTANT

UINT16CONSTANT	UINT16CONSTANT
UINT32CONSTANT	UINT32CONSTANT
UINT64CONSTANT	UINT64CONSTANT
UINTCONSTANT	UINTCONSTANT

FLOAT16CONSTANT	FLOAT16CONSTANT
FLOATCONSTANT	FLOATCONSTANT
DOUBLECONSTANT	DOUBLECONSTANT

{HP}{H}+{IS}?				INTCONSTANT
{NZ}{D}*{IS}?				INTCONSTANT
"0"{O}*{IS}?				INTCONSTANT
{CP}?"'"([^'\\\n]|{ES})+"'"		INTCONSTANT

{D}+{E}{FS}?				DOUBLECONSTANT
{D}*"."{D}+{E}?{FS}?			DOUBLECONSTANT
{D}+"."{E}?{FS}?			DOUBLECONSTANT
{HP}{H}+{P}{FS}?			DOUBLECONSTANT
{HP}{H}*"."{H}+{P}{FS}?			DOUBLECONSTANT
{HP}{H}+"."{P}{FS}?			DOUBLECONSTANT

\"(\\.|[^"\r\n\\])*\"	STRING_LITERAL

TYPE_NAME	TYPE_NAME
[A-Za-z_][A-Za-z0-9_]*	IDENTIFIER

%%
