/* From: https://github.com/BenHanson/idl2cpp/blob/main/parser.cpp */

// IDL reference: https://msdn.microsoft.com/en-us/library/windows/desktop/aa367088(v=vs.85).aspx
// - This parser only needs to parse what OLE Viewer outputs.
// https://github.com/microsoft/VCSamples/tree/master/VC2010Samples/MFC/ole/oleview

// Start of new grammar 02/06/2018
%token Name Number String Uuid

// All keywords from Microsoft site:
%x ATTRIBUTES

%%

// attr_list cleared in lib_name
file : attr_list 'library' lib_name '{' lib_stmts '}' ';' ;
lib_name : Name ;
lib_stmts : lib_stmt ';'
	| lib_stmts lib_stmt ';' ;
lib_stmt : 'dispinterface' Name ;
lib_stmt : 'importlib' '(' String ')' ;
lib_stmt : 'interface' if_type ;
// attr_list cleared in coclass_name
lib_stmt :
	attr_list 'coclass' coclass_name '{' interface_list '}' ;
coclass_name : Name ;
// attr_list cleared in dispinterface
lib_stmt :
	attr_list dispinterface '{' member_list '}' ;
// attr_list cleared in unknown
lib_stmt :
	attr_list 'interface' 'IDispatch' ':' unknown '{' member_list '}'
	| attr_list 'interface' unknown '{' member_list '}'
	| attr_list 'interface' Name ':' unknown '{' member_list '}' ;
unknown : 'IUnknown' ;
lib_stmt :
	attr_list interface '{' member_list '}' ;
lib_stmt : attr_list 'module' Name '{' member_list '}' ;
lib_stmt : 'typedef' opt_attr_list type_specifier  ;
dispinterface : 'dispinterface' Name ;
interface : 'interface' Name ':' 'IDispatch' ;
interface : 'interface' Name ':' Name ;
type_specifier :
	'enum' opt_name '{' enum_items '}' Name ;
type_specifier : struct_union Name '{' struct_members '}' Name ;
type_specifier : type Name ;
struct_union : 'struct' | 'union' ;
struct_members : %empty
	| struct_members member ;
member : opt_attr_list type Name opt_array ';' ;
opt_array : %empty | '[' Number ']' ;

interface_list : %empty ;
interface_list :
	interface_list opt_attr_list 'interface' if_type ';' ;
interface_list :
	interface_list opt_attr_list 'dispinterface' Name ';' ;
if_type : 'IDispatch' | 'IUnknown' | Name ;

member_list : %empty ;
member_list : member_list 'properties:' ;
member_list : member_list 'methods:' ;
member_list : member_list function
	| member_list property  ;
function :
	opt_attr_list type opt_call function_name '(' param_list ')' ';' ;
function_name : Name ;
property : opt_attr_list type opt_call property_name opt_assign_value ';' ;
property_name : Name ;
opt_assign_value : %empty | '=' value ;
value : Number | String ;
param_list : %empty
	| param
	| param_list ',' param ;
param : opt_attr_list type opt_param_name ;
opt_param_name : %empty ;
opt_param_name : param_name opt_array ;
param_name : Name ;

opt_name : %empty
	| Name ;
enum_items : enum_item
	| enum_items ',' enum_item ;
enum_item : Name '=' Number ;
name_star_list : Name opt_stars
	| name_star_list ',' Name opt_stars ;
type : opt_const raw_type opt_stars ;
opt_const : %empty | 'const' ;
raw_type : 'BSTR' ;
raw_type : 'CURRENCY' ;
raw_type : 'DATE' ;
raw_type : 'double' ;
raw_type : 'IDispatch' ;
raw_type : 'IUnknown' ;
raw_type : int ;
raw_type : 'int64' ;
raw_type : Name ;
raw_type : 'SAFEARRAY' '(' type ')' ;
raw_type : 'SCODE' ;
raw_type : 'single' ;
raw_type : 'uint64' ;
raw_type : unsigned ;
raw_type : 'VARIANT' ;
raw_type : 'VARIANT_BOOL' ;
raw_type : 'void' ;
int : 'char' ;
int : 'int' ;
int : 'long' ;
int : 'short' ;
int : 'wchar_t' ;
unsigned : 'unsigned' int ;
opt_stars : %empty ;
opt_stars : opt_stars '*' ;
opt_call : %empty
	| '_stdcall'
	| '_cdecl'
	| '_pascal'
	| '_macpascal'
	| '_mpwcdecl'
	| '_mpwpascal' ;

attr_list : '[' attr_list ']' ;
opt_attr_list : %empty
	| '[' attr_list ']' ;
attr_list : attr
	| attr_list opt_comma attr ;
opt_comma : %empty | ',' ;
// I have lumped all attributes together as it was unclear which
// context all attributes occurred in from the MS documentation.
attr : 'appobject'
	| 'bindable'
	| 'control'
	| 'custom' '(' Uuid ',' String ')'
	// String could be another data type
	| 'custom' '(' '{' Uuid '}' ',' String ')'
	| 'default'
	| 'defaultbind' ;
attr : 'defaultvalue' '(' number_string ')' ;
attr : 'displaybind'
	| 'dllname' '(' String ')'
	| 'dual'
	| 'entry' '(' number_string ')'
	| 'helpcontext' '(' Number ')'
	| 'helpfile' '(' String ')' ;
attr : 'helpstring' '(' String ')' ;
attr : 'hidden' ;
attr : 'id' '(' Number ')' ;
attr : 'immediatebind' ;
attr : 'in'  ;
attr : 'lcid' ;
attr : 'lcid' '(' Number ')'
	| 'licensed'
	| 'noncreatable'
	| 'nonextensible'
	| 'notify'
	| 'odl'
	// https://msdn.microsoft.com/en-us/library/windows/desktop/aa367129(v=vs.85).aspx
	| 'oleautomation' ;
attr : 'optional' ;
attr : 'out' ;
attr : 'propget' ;
attr : 'propput' ;
attr : 'propputref' ;
attr : 'public'
	| 'range' '(' number_name ',' number_name ')' ;
attr : 'readonly' ;
attr : 'requestedit' ;
attr : 'restricted' ;
attr : 'retval' ;
attr : 'source' ;
attr : 'uuid' '(' uuid ')' ;
attr : 'vararg'
	| 'version' '(' Number ')' ;

string_list : String
	| string_list String ;

number_string : Number | String ;
number_name : Number | Name ;
uuid : Uuid ;
uuid : String ;

%%

%%

// Attributes:
<INITIAL>\[<ATTRIBUTES>	'['

// Determined by running strings.exe on IViewer.dll
<ATTRIBUTES>appobject	'appobject'
<ATTRIBUTES>bindable	'bindable'
<ATTRIBUTES>control	'control'
<ATTRIBUTES>custom	'custom'
<ATTRIBUTES>default	'default'
<ATTRIBUTES>defaultbind	'defaultbind'
<ATTRIBUTES>defaultvalue	'defaultvalue'
<ATTRIBUTES>displaybind	'displaybind'
<ATTRIBUTES>dllname	'dllname'
<ATTRIBUTES>dual	'dual'
<ATTRIBUTES>entry	'entry'
<ATTRIBUTES>helpcontext	'helpcontext'
<ATTRIBUTES>helpfile	'helpfile'
<ATTRIBUTES>helpstring	'helpstring'
<ATTRIBUTES>hidden	'hidden'
<ATTRIBUTES>id	'id'
<ATTRIBUTES>immediatebind	'immediatebind'
<ATTRIBUTES>in	'in'
<ATTRIBUTES>lcid	'lcid'
<ATTRIBUTES>licensed	'licensed'
<ATTRIBUTES>noncreatable	'noncreatable'
<ATTRIBUTES>nonextensible	'nonextensible'
<ATTRIBUTES>notify	'notify'
<ATTRIBUTES>odl	'odl'
<ATTRIBUTES>oleautomation	'oleautomation'
<ATTRIBUTES>optional	'optional'
<ATTRIBUTES>out	'out'
<ATTRIBUTES>propget	'propget'
<ATTRIBUTES>propput	'propput'
<ATTRIBUTES>propputref	'propputref'
<ATTRIBUTES>public	'public'
<ATTRIBUTES>range	'range'
<ATTRIBUTES>readonly	'readonly'
<ATTRIBUTES>requestedit	'requestedit'
<ATTRIBUTES>restricted	'restricted'
<ATTRIBUTES>retval	'retval'
<ATTRIBUTES>source	'source'
<ATTRIBUTES>uuid	'uuid'
<ATTRIBUTES>vararg	'vararg'
<ATTRIBUTES>version	'version'
<ATTRIBUTES>\]<INITIAL>	']'

// Keywords:
// Determined by running strings.exe on IViewer.dll
BSTR	'BSTR'
DATE	'DATE'
CURRENCY	'CURRENCY'
IDispatch	'IDispatch'
IUnknown	'IUnknown'
SAFEARRAY	'SAFEARRAY'
SCODE	'SCODE'
VARIANT	'VARIANT'
VARIANT_BOOL	'VARIANT_BOOL'
_cdecl	'_cdecl'
_macpascal	'_macpascal'
_mpwcdecl	'_mpwcdecl'
_mpwpascal	'_mpwpascal'
_pascal	'_pascal'
_stdcall	'_stdcall'
char	'char'
coclass	'coclass'
const	'const'
dispinterface	'dispinterface'
double	'double'
enum	'enum'
importlib	'importlib'
int	'int'
int64	'int64'
interface	'interface'
library	'library'
long	'long'
methods:	'methods:'
module	'module'
properties:	'properties:'
short	'short'
single	'single'
struct	'struct'
typedef	'typedef'
uint64	'uint64'
union	'union'
unsigned	'unsigned'
void	'void'
wchar_t	'wchar_t'

<*>[(]	'('
<*>[)]	')'
<*>[*]	'*'
<*>","	','
":"	':'
";"	';'
"="	'='
<*>[{]	'{'
<*>[}]	'}'
[A-Z_a-z][0-9A-Z_a-z]*	Name
<*>-?\d+([.]\d+)?|0x[0-9A-Fa-f]{8}	Number
<*>["]([^"\\]|\\.)*["]	String
<*>[0-9A-Fa-f]{8}(-[0-9A-Fa-f]{4}){3}-[0-9A-Fa-f]{12}	Uuid
[/][/].*|[/][*](?s:.)*?[*][/]	skip()
<*>\s+	skip()

%%
