//From: https://github.com/PixarAnimationStudios/OpenUSD/blob/f941bce34505c88eaf32dc79f36eab2659b2b1ee/pxr/usd/sdf/textFileFormat.yy
//
// Copyright 2016 Pixar
//
// Licensed under the Apache License, Version 2.0 (the "Apache License")
// with the following modification; you may not use this file except in
// compliance with the Apache License and the following modification to it:
// Section 6. Trademarks. is deleted and replaced with:
//
// 6. Trademarks. This License does not grant permission to use the trade
//    names, trademarks, service marks, or product names of the Licensor
//    and its affiliates, except as required to comply with Section 4(c) of
//    the License and to reproduce the content of the NOTICE file.
//
// You may obtain a copy of the Apache License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the Apache License with the above modification is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the Apache License for the specific
// language governing permissions and limitations under the Apache License.
//

/*Tokens*/
%token TOK_NL
%token TOK_MAGIC
//%token TOK_SYNTAX_ERROR
%token TOK_ASSETREF
%token TOK_PATHREF
%token TOK_IDENTIFIER
%token TOK_CXX_NAMESPACED_IDENTIFIER
%token TOK_NAMESPACED_IDENTIFIER
%token TOK_NUMBER
%token TOK_STRING
%token TOK_ABSTRACT
%token TOK_ADD
%token TOK_APPEND
%token TOK_CLASS
%token TOK_CONFIG
%token TOK_CONNECT
%token TOK_CUSTOM
%token TOK_CUSTOMDATA
%token TOK_DEF
%token TOK_DEFAULT
%token TOK_DELETE
%token TOK_DICTIONARY
%token TOK_DISPLAYUNIT
%token TOK_DOC
%token TOK_INHERITS
%token TOK_KIND
%token TOK_NAMECHILDREN
%token TOK_NONE
%token TOK_OFFSET
%token TOK_OVER
%token TOK_PERMISSION
%token TOK_PAYLOAD
%token TOK_PREFIX_SUBSTITUTIONS
%token TOK_SUFFIX_SUBSTITUTIONS
%token TOK_PREPEND
%token TOK_PROPERTIES
%token TOK_REFERENCES
%token TOK_RELOCATES
%token TOK_REL
%token TOK_RENAMES
%token TOK_REORDER
%token TOK_ROOTPRIMS
%token TOK_SCALE
%token TOK_SPECIALIZES
%token TOK_SUBLAYERS
%token TOK_SYMMETRYARGUMENTS
%token TOK_SYMMETRYFUNCTION
%token TOK_TIME_SAMPLES
%token TOK_UNIFORM
%token TOK_VARIANTS
%token TOK_VARIANTSET
%token TOK_VARIANTSETS
%token TOK_VARYING
%token '('
%token ')'
%token '='
%token '['
%token ']'
%token '.'
%token '{'
%token '}'
%token ':'
%token ';'
%token ','


%start sdf_file

%%

sdf_file :
	layer
	;

keyword :
	TOK_ABSTRACT
	| TOK_ADD
	| TOK_APPEND
	| TOK_CLASS
	| TOK_CONFIG
	| TOK_CONNECT
	| TOK_CUSTOM
	| TOK_CUSTOMDATA
	| TOK_DEF
	| TOK_DEFAULT
	| TOK_DELETE
	| TOK_DICTIONARY
	| TOK_DISPLAYUNIT
	| TOK_DOC
	| TOK_INHERITS
	| TOK_KIND
	| TOK_NAMECHILDREN
	| TOK_NONE
	| TOK_OFFSET
	| TOK_OVER
	| TOK_PAYLOAD
	| TOK_PERMISSION
	| TOK_PREFIX_SUBSTITUTIONS
	| TOK_SUFFIX_SUBSTITUTIONS
	| TOK_PREPEND
	| TOK_PROPERTIES
	| TOK_REFERENCES
	| TOK_RELOCATES
	| TOK_REL
	| TOK_RENAMES
	| TOK_REORDER
	| TOK_ROOTPRIMS
	| TOK_SCALE
	| TOK_SPECIALIZES
	| TOK_SUBLAYERS
	| TOK_SYMMETRYARGUMENTS
	| TOK_SYMMETRYFUNCTION
	| TOK_TIME_SAMPLES
	| TOK_UNIFORM
	| TOK_VARIANTS
	| TOK_VARIANTSET
	| TOK_VARIANTSETS
	| TOK_VARYING
	;

layer_metadata_form :
	layer_metadata_opt
	| layer_metadata_opt prim_list newlines_opt
	;

layer :
	TOK_MAGIC layer_metadata_form
	;

layer_metadata_opt :
	newlines_opt
	| newlines_opt '(' layer_metadata_list_opt ')' newlines_opt
	;

layer_metadata_list_opt :
	newlines_opt
	| newlines_opt layer_metadata_list stmtsep_opt
	;

layer_metadata_list :
	layer_metadata
	| layer_metadata_list stmtsep layer_metadata
	;

layer_metadata_key :
	identifier
	;

layer_metadata :
	TOK_STRING
	| layer_metadata_key '=' metadata_value
	| TOK_DELETE identifier '=' metadata_listop_list
	| TOK_ADD identifier '=' metadata_listop_list
	| TOK_PREPEND identifier '=' metadata_listop_list
	| TOK_APPEND identifier '=' metadata_listop_list
	| TOK_REORDER identifier '=' metadata_listop_list
	| TOK_DOC '=' TOK_STRING
	| TOK_SUBLAYERS '=' sublayer_list
	;

sublayer_list :
	'[' newlines_opt ']'
	| '[' newlines_opt sublayer_list_int listsep_opt ']'
	;

sublayer_list_int :
	sublayer_stmt
	| sublayer_list_int listsep sublayer_stmt
	;

sublayer_stmt :
	layer_ref layer_offset_opt
	;

layer_ref :
	TOK_ASSETREF
	;

layer_offset_opt :
	/*empty*/
	| '(' layer_offset_int stmtsep_opt ')'
	;

layer_offset_int :
	layer_offset_stmt
	| layer_offset_int stmtsep layer_offset_stmt
	;

layer_offset_stmt :
	TOK_OFFSET '=' TOK_NUMBER
	| TOK_SCALE '=' TOK_NUMBER
	;

prim_list :
	prim_stmt
	| prim_list newlines prim_stmt
	;

prim_stmt :
	TOK_DEF prim_stmt_int
	| TOK_DEF prim_type_name prim_stmt_int
	| TOK_CLASS prim_stmt_int
	| TOK_CLASS prim_type_name prim_stmt_int
	| TOK_OVER prim_stmt_int
	| TOK_OVER prim_type_name prim_stmt_int
	| TOK_REORDER TOK_ROOTPRIMS '=' name_list
	;

prim_type_name :
	identifier
	| prim_type_name '.' identifier
	;

prim_stmt_int :
	TOK_STRING prim_metadata_opt '{' prim_contents_list_opt '}'
	;

prim_metadata_opt :
	newlines_opt
	| newlines_opt '(' prim_metadata_list_opt ')' newlines_opt
	;

prim_metadata_list_opt :
	newlines_opt
	| newlines_opt prim_metadata_list stmtsep_opt
	;

prim_metadata_list :
	prim_metadata
	| prim_metadata_list stmtsep prim_metadata
	;

prim_metadata_key :
	identifier
	| TOK_CUSTOMDATA
	| TOK_SYMMETRYARGUMENTS
	;

prim_metadata :
	TOK_STRING
	| prim_metadata_key '=' metadata_value
	| TOK_DELETE identifier '=' metadata_listop_list
	| TOK_ADD identifier '=' metadata_listop_list
	| TOK_PREPEND identifier '=' metadata_listop_list
	| TOK_APPEND identifier '=' metadata_listop_list
	| TOK_REORDER identifier '=' metadata_listop_list
	| TOK_DOC '=' TOK_STRING
	| TOK_KIND '=' TOK_STRING
	| TOK_PERMISSION '=' identifier
	| TOK_PAYLOAD '=' payload_list
	| TOK_DELETE TOK_PAYLOAD '=' payload_list
	| TOK_ADD TOK_PAYLOAD '=' payload_list
	| TOK_PREPEND TOK_PAYLOAD '=' payload_list
	| TOK_APPEND TOK_PAYLOAD '=' payload_list
	| TOK_REORDER TOK_PAYLOAD '=' payload_list
	| TOK_INHERITS '=' inherit_list
	| TOK_DELETE TOK_INHERITS '=' inherit_list
	| TOK_ADD TOK_INHERITS '=' inherit_list
	| TOK_PREPEND TOK_INHERITS '=' inherit_list
	| TOK_APPEND TOK_INHERITS '=' inherit_list
	| TOK_REORDER TOK_INHERITS '=' inherit_list
	| TOK_SPECIALIZES '=' specializes_list
	| TOK_DELETE TOK_SPECIALIZES '=' specializes_list
	| TOK_ADD TOK_SPECIALIZES '=' specializes_list
	| TOK_PREPEND TOK_SPECIALIZES '=' specializes_list
	| TOK_APPEND TOK_SPECIALIZES '=' specializes_list
	| TOK_REORDER TOK_SPECIALIZES '=' specializes_list
	| TOK_REFERENCES '=' reference_list
	| TOK_DELETE TOK_REFERENCES '=' reference_list
	| TOK_ADD TOK_REFERENCES '=' reference_list
	| TOK_PREPEND TOK_REFERENCES '=' reference_list
	| TOK_APPEND TOK_REFERENCES '=' reference_list
	| TOK_REORDER TOK_REFERENCES '=' reference_list
	| TOK_RELOCATES '=' relocates_map
	| TOK_VARIANTS '=' typed_dictionary
	| TOK_VARIANTSETS '=' name_list
	| TOK_DELETE TOK_VARIANTSETS '=' name_list
	| TOK_ADD TOK_VARIANTSETS '=' name_list
	| TOK_PREPEND TOK_VARIANTSETS '=' name_list
	| TOK_APPEND TOK_VARIANTSETS '=' name_list
	| TOK_REORDER TOK_VARIANTSETS '=' name_list
	| TOK_SYMMETRYFUNCTION '=' identifier
	| TOK_SYMMETRYFUNCTION '='
	| TOK_PREFIX_SUBSTITUTIONS '=' string_dictionary
	| TOK_SUFFIX_SUBSTITUTIONS '=' string_dictionary
	;

payload_list :
	TOK_NONE
	| payload_list_item
	| '[' newlines_opt ']'
	| '[' newlines_opt payload_list_int listsep_opt ']'
	;

payload_list_int :
	payload_list_item
	| payload_list_int listsep payload_list_item
	;

payload_list_item :
	layer_ref prim_path_opt payload_params_opt
	| TOK_PATHREF payload_params_opt
	;

payload_params_opt :
	/*empty*/
	| '(' newlines_opt ')'
	| '(' newlines_opt payload_params_int stmtsep_opt ')'
	;

payload_params_int :
	payload_params_item
	| payload_params_int stmtsep payload_params_item
	;

payload_params_item :
	layer_offset_stmt
	;

reference_list :
	TOK_NONE
	| reference_list_item
	| '[' newlines_opt ']'
	| '[' newlines_opt reference_list_int listsep_opt ']'
	;

reference_list_int :
	reference_list_item
	| reference_list_int listsep reference_list_item
	;

reference_list_item :
	layer_ref prim_path_opt reference_params_opt
	| TOK_PATHREF reference_params_opt
	;

reference_params_opt :
	/*empty*/
	| '(' newlines_opt ')'
	| '(' newlines_opt reference_params_int stmtsep_opt ')'
	;

reference_params_int :
	reference_params_item
	| reference_params_int stmtsep reference_params_item
	;

reference_params_item :
	layer_offset_stmt
	| TOK_CUSTOMDATA '=' typed_dictionary
	;

inherit_list :
	TOK_NONE
	| inherit_list_item
	| '[' newlines_opt ']'
	| '[' newlines_opt inherit_list_int listsep_opt ']'
	;

inherit_list_int :
	inherit_list_item
	| inherit_list_int listsep inherit_list_item
	;

inherit_list_item :
	prim_path
	;

specializes_list :
	TOK_NONE
	| specializes_list_item
	| '[' newlines_opt ']'
	| '[' newlines_opt specializes_list_int listsep_opt ']'
	;

specializes_list_int :
	specializes_list_item
	| specializes_list_int listsep specializes_list_item
	;

specializes_list_item :
	prim_path
	;

relocates_map :
	'{' newlines_opt relocates_stmt_list_opt '}'
	;

relocates_stmt_list_opt :
	/*empty*/
	| relocates_stmt_list listsep_opt
	;

relocates_stmt_list :
	relocates_stmt
	| relocates_stmt_list listsep relocates_stmt
	;

relocates_stmt :
	TOK_PATHREF ':' TOK_PATHREF
	;

name_list :
	name_list_item
	| '[' newlines_opt name_list_int listsep_opt ']'
	;

name_list_int :
	name_list_item
	| name_list_int listsep name_list_item
	;

name_list_item :
	TOK_STRING
	;

prim_contents_list_opt :
	newlines_opt
	| newlines_opt prim_contents_list
	;

prim_contents_list :
	prim_contents_list_item
	| prim_contents_list prim_contents_list_item
	;

prim_contents_list_item :
	prim_property stmtsep
	| prim_child_order_stmt stmtsep
	| prim_property_order_stmt stmtsep
	| prim_stmt newlines
	| variantset_stmt newlines
	;

variantset_stmt :
	TOK_VARIANTSET TOK_STRING '=' newlines_opt '{' newlines_opt variant_list '}'
	;

variant_list :
	variant_stmt
	| variant_list variant_stmt
	;

variant_stmt :
	TOK_STRING prim_metadata_opt '{' prim_contents_list_opt '}' newlines_opt
	;

prim_child_order_stmt :
	TOK_REORDER TOK_NAMECHILDREN '=' name_list
	;

prim_property_order_stmt :
	TOK_REORDER TOK_PROPERTIES '=' name_list
	;

prim_property :
	prim_attribute
	| prim_relationship
	;

prim_attr_variability :
	TOK_UNIFORM
	| TOK_CONFIG
	;

prim_attr_qualifiers :
	prim_attr_variability
	;

prim_attr_type :
	identifier
	| identifier '[' ']'
	;

prim_attribute_full_type :
	prim_attr_type
	| prim_attr_qualifiers prim_attr_type
	;

prim_attribute_default :
	prim_attribute_full_type namespaced_name attribute_assignment_opt attribute_metadata_list_opt
	;

prim_attribute_fallback :
	TOK_CUSTOM prim_attribute_full_type namespaced_name attribute_assignment_opt attribute_metadata_list_opt
	;

prim_attribute_connect :
	prim_attribute_full_type namespaced_name '.' TOK_CONNECT '=' connect_rhs
	| TOK_ADD prim_attribute_full_type namespaced_name '.' TOK_CONNECT '=' connect_rhs
	| TOK_PREPEND prim_attribute_full_type namespaced_name '.' TOK_CONNECT '=' connect_rhs
	| TOK_APPEND prim_attribute_full_type namespaced_name '.' TOK_CONNECT '=' connect_rhs
	| TOK_DELETE prim_attribute_full_type namespaced_name '.' TOK_CONNECT '=' connect_rhs
	| TOK_REORDER prim_attribute_full_type namespaced_name '.' TOK_CONNECT '=' connect_rhs
	;

prim_attribute_time_samples :
	prim_attribute_full_type namespaced_name '.' TOK_TIME_SAMPLES '=' time_samples_rhs
	;

prim_attribute :
	prim_attribute_fallback
	| prim_attribute_default
	| prim_attribute_connect
	| prim_attribute_time_samples
	;

connect_rhs :
	TOK_NONE
	| connect_item
	| '[' newlines_opt ']'
	| '[' newlines_opt connect_list listsep_opt ']'
	;

connect_list :
	connect_item
	| connect_list listsep connect_item
	;

connect_item :
	prim_or_property_scene_path
	;

time_samples_rhs :
	'{' newlines_opt time_sample_list '}'
	;

time_sample_list :
	/*empty*/
	| time_sample_list_int listsep_opt
	;

time_sample_list_int :
	time_sample
	| time_sample_list_int listsep time_sample
	;

time_sample :
	extended_number ':' typed_value
	| extended_number ':' TOK_NONE
	;

attribute_metadata_list_opt :
	/*empty*/
	| '(' newlines_opt ')'
	| '(' newlines_opt attribute_metadata_list stmtsep_opt ')'
	;

attribute_metadata_list :
	attribute_metadata
	| attribute_metadata_list stmtsep attribute_metadata
	;

attribute_metadata_key :
	identifier
	| TOK_CUSTOMDATA
	| TOK_SYMMETRYARGUMENTS
	;

attribute_metadata :
	TOK_STRING
	| attribute_metadata_key '=' metadata_value
	| TOK_DELETE identifier '=' metadata_listop_list
	| TOK_ADD identifier '=' metadata_listop_list
	| TOK_PREPEND identifier '=' metadata_listop_list
	| TOK_APPEND identifier '=' metadata_listop_list
	| TOK_REORDER identifier '=' metadata_listop_list
	| TOK_DOC '=' TOK_STRING
	| TOK_PERMISSION '=' identifier
	| TOK_DISPLAYUNIT '=' identifier
	| TOK_SYMMETRYFUNCTION '=' identifier
	| TOK_SYMMETRYFUNCTION '='
	;

attribute_assignment_opt :
	/*empty*/
	| '=' attribute_value
	;

attribute_value :
	typed_value
	| TOK_NONE
	;

typed_dictionary :
	'{' newlines_opt typed_dictionary_list_opt '}'
	;

typed_dictionary_list_opt :
	/*empty*/
	| typed_dictionary_list stmtsep_opt
	;

typed_dictionary_list :
	typed_dictionary_element
	| typed_dictionary_list stmtsep typed_dictionary_element
	;

typed_dictionary_element :
	dictionary_value_type dictionary_key '=' typed_value
	| TOK_DICTIONARY dictionary_key '=' typed_dictionary
	;

dictionary_key :
	TOK_STRING
	| name
	;

dictionary_value_type :
	dictionary_value_scalar_type
	| dictionary_value_shaped_type
	;

dictionary_value_scalar_type :
	identifier
	;

dictionary_value_shaped_type :
	identifier '[' ']'
	;

string_dictionary :
	'{' newlines_opt string_dictionary_list_opt '}'
	;

string_dictionary_list_opt :
	/*empty*/
	| string_dictionary_list listsep_opt
	;

string_dictionary_list :
	string_dictionary_element
	| string_dictionary_list listsep string_dictionary_element
	;

string_dictionary_element :
	TOK_STRING ':' TOK_STRING
	;

metadata_listop_list :
	TOK_NONE
	| typed_value_list
	;

metadata_value :
	typed_dictionary
	| typed_value
	| TOK_NONE
	;

typed_value :
	typed_value_atomic
	| typed_value_tuple
	| typed_value_list
	| '[' ']'
	| TOK_PATHREF
	;

typed_value_atomic :
	TOK_NUMBER
	| TOK_STRING
	| identifier
	| TOK_ASSETREF
	;

typed_value_list :
	'[' typed_value_list_int ']'
	;

typed_value_list_int :
	newlines_opt typed_value_list_items listsep_opt
	;

typed_value_list_items :
	typed_value_list_item
	| typed_value_list_items listsep typed_value_list_item
	;

typed_value_list_item :
	typed_value_atomic
	| typed_value_list
	| typed_value_tuple
	;

typed_value_tuple :
	'(' typed_value_tuple_int ')'
	;

typed_value_tuple_int :
	newlines_opt typed_value_tuple_items listsep_opt
	;

typed_value_tuple_items :
	typed_value_tuple_item
	| typed_value_tuple_items listsep typed_value_tuple_item
	;

typed_value_tuple_item :
	typed_value_atomic
	| typed_value_tuple
	;

prim_relationship_type :
	TOK_REL
	| TOK_CUSTOM TOK_REL
	| TOK_CUSTOM TOK_VARYING TOK_REL
	| TOK_VARYING TOK_REL
	;

prim_relationship_time_samples :
	prim_relationship_type namespaced_name '.' TOK_TIME_SAMPLES '=' time_samples_rhs
	;

prim_relationship_default :
	prim_relationship_type namespaced_name '.' TOK_DEFAULT '=' TOK_PATHREF
	;

prim_relationship :
	prim_relationship_type namespaced_name relationship_assignment_opt relationship_metadata_list_opt
	| TOK_DELETE prim_relationship_type namespaced_name relationship_assignment_opt
	| TOK_ADD prim_relationship_type namespaced_name relationship_assignment_opt
	| TOK_PREPEND prim_relationship_type namespaced_name relationship_assignment_opt
	| TOK_APPEND prim_relationship_type namespaced_name relationship_assignment_opt
	| TOK_REORDER prim_relationship_type namespaced_name relationship_assignment_opt
	| prim_relationship_type namespaced_name '[' TOK_PATHREF ']'
	| prim_relationship_time_samples
	| prim_relationship_default
	;

relationship_metadata_list_opt :
	/*empty*/
	| '(' newlines_opt ')'
	| '(' newlines_opt relationship_metadata_list stmtsep_opt ')'
	;

relationship_metadata_list :
	relationship_metadata
	| relationship_metadata_list stmtsep relationship_metadata
	;

relationship_metadata_key :
	identifier
	| TOK_CUSTOMDATA
	| TOK_SYMMETRYARGUMENTS
	;

relationship_metadata :
	TOK_STRING
	| relationship_metadata_key '=' metadata_value
	| TOK_DELETE identifier '=' metadata_listop_list
	| TOK_ADD identifier '=' metadata_listop_list
	| TOK_PREPEND identifier '=' metadata_listop_list
	| TOK_APPEND identifier '=' metadata_listop_list
	| TOK_REORDER identifier '=' metadata_listop_list
	| TOK_DOC '=' TOK_STRING
	| TOK_PERMISSION '=' identifier
	| TOK_SYMMETRYFUNCTION '=' identifier
	| TOK_SYMMETRYFUNCTION '='
	;

relationship_assignment_opt :
	/*empty*/
	| '=' relationship_rhs
	;

relationship_rhs :
	relationship_target
	| TOK_NONE
	| '[' newlines_opt ']'
	| '[' newlines_opt relationship_target_list listsep_opt ']'
	;

relationship_target_list :
	relationship_target
	| relationship_target_list listsep relationship_target
	;

relationship_target :
	TOK_PATHREF
	;

prim_path_opt :
	/*empty*/
	| prim_path
	;

prim_path :
	TOK_PATHREF
	;

prim_or_property_scene_path :
	TOK_PATHREF
	;

name :
	identifier
	| keyword
	;

namespaced_name :
	TOK_IDENTIFIER
	| TOK_NAMESPACED_IDENTIFIER
	| keyword
	;

identifier :
	TOK_IDENTIFIER
	| TOK_CXX_NAMESPACED_IDENTIFIER
	;

extended_number :
	TOK_NUMBER
	| TOK_IDENTIFIER
	;

stmtsep_opt :
	/*empty*/
	| stmtsep
	;

stmtsep :
	';' newlines_opt
	| newlines
	;

listsep_opt :
	newlines_opt
	| listsep
	;

listsep :
	',' newlines_opt
	;

newlines_opt :
	/*empty*/
	| newlines
	;

newlines :
	TOK_NL
	| newlines TOK_NL
	;

%%

/* States */
%x SLASHTERIX_COMMENT

/* character classes
  * defines UTF-8 encoded byte values for standard ASCII
  * and multi-byte UTF-8 character sets
  * valid multi-byte UTF-8 sequences are as follows:
  * For an n-byte encoded UTF-8 character, the last n-1 bytes range [\x80-\xbf]
  * 2-byte UTF-8 characters, first byte in range [\xc2-\xdf]
  * 3-byte UTF-8 characters, first byte in range [\xe0-\xef]
  * 4-byte UTF-8 characters, first byte in range [\xf0-\xf4]
  * ASCII characters span [\x41-\x5a] (upper case) [\x61-\x7a] (lower case) [\x30-39] (digits)
  */
ALPHA1      [\x41-\x5a]
ALPHA2      [\x61-\x7a]
DIGIT       [\x30-\x39]
UEND        [\x80-\xbf]
U2PRE       [\xc2-\xdf]
U3PRE       [\xe0-\xef]
U4PRE       [\xf0-\xf4]
UNDER       [_]
DASH        [\-]
BAR         [\|]
ALPHA       {ALPHA1}|{ALPHA2}
ALPHANUM    {ALPHA}|{DIGIT}
UTF8X       {U2PRE}{UEND}|{U3PRE}{UEND}{UEND}|{U4PRE}{UEND}{UEND}{UEND}
UTF8        {ALPHANUM}|{UTF8X}
UTF8NODIG   {ALPHA}|{UTF8X}
UTF8U       {UTF8}|{UNDER}
UTF8NODIGU  {UTF8NODIG}|{UNDER}
UTF8UD      {UTF8U}|{DASH}
UTF8UDB     {UTF8UD}|{BAR}

%%

    /* skip over whitespace and comments */
    /* handle the first line # comment specially, since it contains the
       magic token */
[[:blank:]]+ skip()
"#"[^\r\n]*  TOK_MAGIC
"//"[^\r\n]* skip()
"/*"<SLASHTERIX_COMMENT>
<SLASHTERIX_COMMENT>.|\n|\r<.>
<SLASHTERIX_COMMENT>"*/"<INITIAL>	skip()

    /* newline is returned as TOK_NL
     * Note that newlines embedded in quoted strings and tuples are counted
     * as part of the token and do NOT emit a separate TOK_NL.
     */
((\r\n)|\r|\n)  TOK_NL

    /* literal keywords.  we return the yytext so that the yacc grammar
       can make use of it. */
"add"                 TOK_ADD
"append"              TOK_APPEND
"class"               TOK_CLASS
"config"              TOK_CONFIG
"connect"             TOK_CONNECT
"custom"              TOK_CUSTOM
"customData"          TOK_CUSTOMDATA
"default"             TOK_DEFAULT
"def"                 TOK_DEF
"delete"              TOK_DELETE
"dictionary"          TOK_DICTIONARY
"displayUnit"         TOK_DISPLAYUNIT
"doc"                 TOK_DOC
"inherits"            TOK_INHERITS
"kind"                TOK_KIND
"nameChildren"        TOK_NAMECHILDREN
"None"                TOK_NONE
"offset"              TOK_OFFSET
"over"                TOK_OVER
"payload"             TOK_PAYLOAD
"permission"          TOK_PERMISSION
"prefixSubstitutions" TOK_PREFIX_SUBSTITUTIONS
"prepend"             TOK_PREPEND
"properties"          TOK_PROPERTIES
"references"          TOK_REFERENCES
"relocates"           TOK_RELOCATES
"rel"                 TOK_REL
"reorder"             TOK_REORDER
"rootPrims"           TOK_ROOTPRIMS
"scale"               TOK_SCALE
"subLayers"           TOK_SUBLAYERS
"suffixSubstitutions" TOK_SUFFIX_SUBSTITUTIONS
"specializes"         TOK_SPECIALIZES
"symmetryArguments"   TOK_SYMMETRYARGUMENTS
"symmetryFunction"    TOK_SYMMETRYFUNCTION
"timeSamples"         TOK_TIME_SAMPLES
"uniform"             TOK_UNIFORM
"variantSet"          TOK_VARIANTSET
"variantSets"         TOK_VARIANTSETS
"variants"            TOK_VARIANTS
"varying"             TOK_VARYING

"abstract"	TOK_ABSTRACT
"renames"	TOK_RENAMES

 /* unquoted C++ namespaced identifier -- see bug 10775 */
[[:alpha:]_][[:alnum:]_]*(::[[:alpha:]_][[:alnum:]_]*)+  TOK_CXX_NAMESPACED_IDENTIFIER

 /* In a Unicode enabled scheme, 'identifiers' are generally
  * categorized as something that begins with something in the
  * XID_Start category followed by zero or more things in the
  * XID_Continue category.  Since the number of characters in
  * these classes are large, we can't explicitly validate them
  * here easily, so the lex rule is pretty permissive with some
  * further validation done in code prior to calling what was
  * read an 'identifier'.  Note this rule will also match
  * standard ASCII strings because the UTF-8 encoded byte
  * representation is the same for these characters.
  * However, unlike the path lexer, we can guarantee that
  * prim names aren't something special to be called out here
  * so we can be a little more specific about the kinds of strings
  * we match, particularly to not collide with the pure digit match rule
  * below
  */
{UTF8NODIGU}{UTF8U}*  TOK_IDENTIFIER

 /* unquoted namespaced identifiers match any number of colon
  * delimited identifiers
  */
{UTF8NODIGU}{UTF8U}*(:{UTF8NODIGU}{UTF8U}*)+  TOK_NAMESPACED_IDENTIFIER

    /* scene paths */
\<[^\<\>\r\n]*\>  TOK_PATHREF

    /* Single '@'-delimited asset references */
@[^@\n]*@ TOK_ASSETREF

    /* Triple '@'-delimited asset references. */
@@@([^@\n]|@{1,2}[^@\n]|\\@@@)*@{0,2}@@@  TOK_ASSETREF

    /* Singly quoted, single line strings with escapes.
       Note: we handle empty singly quoted strings below, to disambiguate
       them from the beginning of triply-quoted strings.
       Ex: "Foo \"foo\"" */
'([^'\\\r\n]|(\\.))+'   TOK_STRING  /* ' //<- unfreak out coloring code */
\"([^"\\\r\n]|(\\.))+\" TOK_STRING  /* " //<- unfreak out coloring code */

//    /* Empty singly quoted strings that aren't the beginning of
//       a triply-quoted string. */
//''/[^'] {  /* ' // <- keep syntax coloring from freaking out */
//        (*yylval_param) = std::string();
//        return TOK_STRING;
//    }
//\"\"/[^"] {
//        (*yylval_param) = std::string();
//        return TOK_STRING;
//    }

    /* Triply quoted, multi-line strings with escapes.
       Ex: """A\n\"B\"\nC""" */
'''([^'\\]|(\\.)|(\\[\r\n])|('{1,2}[^']))*'''        TOK_STRING  /* ' //<- unfreak out coloring code */
\"\"\"([^"\\]|(\\.)|(\\[\r\n])|(\"{1,2}[^"]))*\"\"\"	TOK_STRING  /* " //<- unfreak out coloring code */

    /* Super special case for negative 0.  We have to store this as a double to
     * preserve the sign.  There is no negative zero integral value, and we
     * don't know at this point what the final stored type will be. */
-0  TOK_NUMBER

    /* Positive integers: store as uint64_t if in range, otherwise double. */
[[:digit:]]+  TOK_NUMBER

    /* Negative integers: store as long. */
-[[:digit:]]+  TOK_NUMBER

    /* Numbers with decimal places or exponents: store as double. */
-?[[:digit:]]+(\.[[:digit:]]*)?([eE][+\-]?[[:digit:]]+)?   TOK_NUMBER
-?\.[[:digit:]]+([eE][+\-]?[[:digit:]]+)?	TOK_NUMBER

    /* regexps for negative infinity.  we don't handle inf and nan here
     * because they look like identifiers.  we handle them in parser where
     * we have the additional context we need to distinguish them from
     * identifiers. */
-inf TOK_NUMBER

    /* various single-character punctuation.  return the character
     * itself as the token.
     */
//[=,:;\$\.\[\]\(\){}&@-]

"="	'='
","	','
";"	';'
":"	':'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'

    /* the default rule is to ECHO any unmatched character.  by returning a
     * token that the parser does not know how to handle these become syntax
     * errors instead.
     */
//<*>.|\\n {return TOK_SYNTAX_ERROR;}

%%
