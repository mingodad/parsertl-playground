/*Tokens*/
%token EGG_NUMBER
%token EGG_ULONG
%token EGG_STRING
%token ANIMPRELOAD
//%token BEZIERCURVE
%token BFACE
%token BILLBOARD
%token BILLBOARDCENTER
%token BINORMAL
%token BUNDLE
//%token CLOSED
%token COLLIDE
%token COMMENT
%token COMPONENT
%token COORDSYSTEM
//%token CV
%token DART
%token DNORMAL
%token DRGBA
%token DUV
%token DXYZ
%token DCS
%token DISTANCE
//%token DTREF
//%token DYNAMICVERTEXPOOL
%token EXTERNAL_FILE
%token GROUP
%token DEFAULTPOSE
%token JOINT
%token KNOTS
//%token INCLUDE
%token INSTANCE
%token LINE
%token LOOP
%token MATERIAL
%token MATRIX3
%token MATRIX4
%token MODEL
%token MREF
%token NORMAL
%token NURBSCURVE
%token NURBSSURFACE
%token OBJECTTYPE
%token ORDER
//%token OUTTANGENT
%token PATCH
%token POINTLIGHT
%token POLYGON
%token REF
%token RGBA
%token ROTATE
%token ROTX
%token ROTY
%token ROTZ
%token SANIM
%token SCALAR
%token SCALE
//%token SEQUENCE
//%token SHADING
%token SWITCH
%token SWITCHCONDITION
%token TABLE
%token TABLE_V
%token TAG
%token TANGENT
%token TEXLIST
%token TEXTURE
//%token TLENGTHS
%token TRANSFORM
%token TRANSLATE
%token TREF
%token TRIANGLEFAN
%token TRIANGLESTRIP
%token TRIM
//%token TXT
%token UKNOTS
%token UV
%token AUX
%token VKNOTS
%token VERTEX
//%token VERTEXANIM
%token VERTEXPOOL
%token VERTEXREF
%token XFMANIM
%token XFMSANIM
%token START_EGG
%token START_GROUP_BODY
%token START_TEXTURE_BODY
%token START_PRIMITIVE_BODY
%token '{'
%token '}'


%start grammar

%%

grammar :
	egg
	| START_EGG egg
	| START_GROUP_BODY group_body
	| START_TEXTURE_BODY texture_body
	| START_PRIMITIVE_BODY primitive_body
	;

egg :
	empty
	| egg node
	;

node :
	coordsystem
	| comment
	| texture
	| material
	| external_reference
	| vertex_pool
	| group
	| joint
	| instance
	| polygon
	| trianglefan
	| trianglestrip
	| patch
	| point_light
	| line
	| nurbs_surface
	| nurbs_curve
	| table
	| anim_preload
	;

coordsystem :
	COORDSYSTEM '{' required_string '}'
	;

comment :
	COMMENT optional_name '{' repeated_string '}'
	;

texture :
	TEXTURE required_name '{' required_string texture_body '}'
	;

texture_body :
	empty
	| texture_body SCALAR required_name '{' real_or_string '}'
	| texture_body transform
	;

material :
	MATERIAL required_name '{' material_body '}'
	;

material_body :
	empty
	| material_body SCALAR required_name '{' real_or_string '}'
	;

external_reference :
	EXTERNAL_FILE optional_name '{' required_string '}'
	| string EXTERNAL_FILE optional_name '{' required_string '}'
	;

vertex_pool :
	VERTEXPOOL required_name '{' vertex_pool_body '}'
	;

vertex_pool_body :
	empty
	| vertex_pool_body vertex
	;

vertex :
	VERTEX '{' vertex_body '}'
	| VERTEX integer '{' vertex_body '}'
	;

vertex_body :
	real
	| real real
	| real real real
	| real real real real
	| vertex_body UV optional_name '{' vertex_uv_body '}'
	| vertex_body AUX required_name '{' vertex_aux_body '}'
	| vertex_body NORMAL '{' vertex_normal_body '}'
	| vertex_body RGBA '{' vertex_color_body '}'
	| vertex_body DXYZ string '{' real real real '}'
	| vertex_body DXYZ '{' string real real real '}'
	;

vertex_uv_body :
	real real
	| real real real
	| vertex_uv_body TANGENT '{' real real real '}'
	| vertex_uv_body TANGENT '{' real real real real '}'
	| vertex_uv_body BINORMAL '{' real real real '}'
	| vertex_uv_body DUV string '{' real real '}'
	| vertex_uv_body DUV string '{' real real real '}'
	| vertex_uv_body DUV '{' string real real '}'
	| vertex_uv_body DUV '{' string real real real '}'
	;

vertex_aux_body :
	/*empty*/
	| real real real real
	;

vertex_normal_body :
	real real real
	| vertex_normal_body DNORMAL string '{' real real real '}'
	| vertex_normal_body DNORMAL '{' string real real real '}'
	;

vertex_color_body :
	real real real real
	| vertex_color_body DRGBA string '{' real real real real '}'
	| vertex_color_body DRGBA '{' string real real real real '}'
	;

group :
	GROUP optional_name '{' group_body '}'
	;

joint :
	JOINT optional_name '{' group_body '}'
	;

instance :
	INSTANCE optional_name '{' group_body '}'
	;

group_body :
	empty
	| group_body SCALAR required_name '{' real_or_string '}'
	| group_body BILLBOARD '{' string '}'
	| group_body BILLBOARDCENTER '{' real real real '}'
	| group_body COLLIDE optional_name '{' cs_type collide_flags '}'
	| group_body DCS '{' integer '}'
	| group_body DCS '{' EGG_STRING '}'
	| group_body DART '{' integer '}'
	| group_body DART '{' EGG_STRING '}'
	| group_body SWITCH '{' integer '}'
	| group_body OBJECTTYPE '{' required_string '}'
	| group_body MODEL '{' integer '}'
	| group_body TAG optional_name '{' repeated_string '}'
	| group_body TEXLIST '{' integer '}'
	| group_body transform
	| group_body default_pose
	| group_body group_vertex_ref
	| group_body switchcondition
	| group_body REF '{' group_name '}'
	| group_body node
	;

cs_type :
	string
	;

collide_flags :
	empty
	| collide_flags string
	;

transform :
	TRANSFORM '{' transform_body '}'
	;

default_pose :
	DEFAULTPOSE '{' transform_body '}'
	;

transform_body :
	empty
	| transform_body translate2d
	| transform_body translate3d
	| transform_body rotate2d
	| transform_body rotx
	| transform_body roty
	| transform_body rotz
	| transform_body rotate3d
	| transform_body scale2d
	| transform_body scale3d
	| transform_body uniform_scale
	| transform_body matrix3
	| transform_body matrix4
	;

translate2d :
	TRANSLATE '{' real real '}'
	;

translate3d :
	TRANSLATE '{' real real real '}'
	;

rotate2d :
	ROTATE '{' real '}'
	;

rotx :
	ROTX '{' real '}'
	;

roty :
	ROTY '{' real '}'
	;

rotz :
	ROTZ '{' real '}'
	;

rotate3d :
	ROTATE '{' real real real real '}'
	;

scale2d :
	SCALE '{' real real '}'
	;

scale3d :
	SCALE '{' real real real '}'
	;

uniform_scale :
	SCALE '{' real '}'
	;

matrix3 :
	MATRIX3 '{' matrix3_body '}'
	;

matrix3_body :
	empty
	| real real real real real real real real real
	;

matrix4 :
	MATRIX4 '{' matrix4_body '}'
	;

matrix4_body :
	empty
	| real real real real real real real real real real real real real real real real
	;

group_vertex_ref :
	VERTEXREF '{' integer_list group_vertex_membership REF '{' vertex_pool_name '}' '}'
	;

group_vertex_membership :
	empty
	| group_vertex_membership SCALAR required_name '{' real_or_string '}'
	;

switchcondition :
	SWITCHCONDITION '{' switchcondition_body '}'
	;

switchcondition_body :
	DISTANCE '{' real real VERTEX '{' real real real '}' '}'
	| DISTANCE '{' real real real VERTEX '{' real real real '}' '}'
	;

polygon :
	POLYGON optional_name '{' primitive_body '}'
	;

trianglefan :
	TRIANGLEFAN optional_name '{' primitive_body '}'
	;

trianglestrip :
	TRIANGLESTRIP optional_name '{' primitive_body '}'
	;

patch :
	PATCH optional_name '{' primitive_body '}'
	;

point_light :
	POINTLIGHT optional_name '{' primitive_body '}'
	;

line :
	LINE optional_name '{' primitive_body '}'
	;

nurbs_surface :
	NURBSSURFACE optional_name '{' nurbs_surface_body '}'
	;

nurbs_curve :
	NURBSCURVE optional_name '{' nurbs_curve_body '}'
	;

primitive_component_body :
	empty
	| primitive_component_body NORMAL '{' primitive_normal_body '}'
	| primitive_component_body RGBA '{' primitive_color_body '}'
	;

primitive_body :
	empty
	| primitive_body COMPONENT integer '{' primitive_component_body '}'
	| primitive_body TREF '{' primitive_tref_body '}'
	| primitive_body TEXTURE '{' primitive_texture_body '}'
	| primitive_body MREF '{' primitive_material_body '}'
	| primitive_body primitive_vertex_ref
	| primitive_body NORMAL '{' primitive_normal_body '}'
	| primitive_body RGBA '{' primitive_color_body '}'
	| primitive_body BFACE '{' primitive_bface_body '}'
	| primitive_body SCALAR required_name '{' real_or_string '}'
	;

nurbs_surface_body :
	empty
	| nurbs_surface_body TREF '{' primitive_tref_body '}'
	| nurbs_surface_body TEXTURE '{' primitive_texture_body '}'
	| nurbs_surface_body MREF '{' primitive_material_body '}'
	| nurbs_surface_body primitive_vertex_ref
	| nurbs_surface_body NORMAL '{' primitive_normal_body '}'
	| nurbs_surface_body RGBA '{' primitive_color_body '}'
	| nurbs_surface_body BFACE '{' primitive_bface_body '}'
	| nurbs_surface_body ORDER '{' nurbs_surface_order_body '}'
	| nurbs_surface_body UKNOTS '{' nurbs_surface_uknots_body '}'
	| nurbs_surface_body VKNOTS '{' nurbs_surface_vknots_body '}'
	| nurbs_surface_body nurbs_curve
	| nurbs_surface_body TRIM '{' nurbs_surface_trim_body '}'
	| nurbs_surface_body SCALAR required_name '{' real_or_string '}'
	;

nurbs_curve_body :
	empty
	| nurbs_curve_body TREF '{' primitive_tref_body '}'
	| nurbs_curve_body TEXTURE '{' primitive_texture_body '}'
	| nurbs_curve_body MREF '{' primitive_material_body '}'
	| nurbs_curve_body primitive_vertex_ref
	| nurbs_curve_body NORMAL '{' primitive_normal_body '}'
	| nurbs_curve_body RGBA '{' primitive_color_body '}'
	| nurbs_curve_body BFACE '{' primitive_bface_body '}'
	| nurbs_curve_body ORDER '{' nurbs_curve_order_body '}'
	| nurbs_curve_body KNOTS '{' nurbs_curve_knots_body '}'
	| nurbs_curve_body SCALAR required_name '{' real_or_string '}'
	;

primitive_tref_body :
	texture_name
	;

primitive_texture_body :
	required_name
	;

primitive_material_body :
	material_name
	;

primitive_normal_body :
	real real real
	| primitive_normal_body DNORMAL string '{' real real real '}'
	| primitive_normal_body DNORMAL '{' string real real real '}'
	;

primitive_color_body :
	real real real real
	| primitive_color_body DRGBA string '{' real real real real '}'
	| primitive_color_body DRGBA '{' string real real real real '}'
	;

primitive_bface_body :
	integer
	;

primitive_vertex_ref :
	VERTEXREF '{' integer_list REF '{' vertex_pool_name '}' '}'
	;

nurbs_surface_order_body :
	integer integer
	;

nurbs_surface_uknots_body :
	real_list
	;

nurbs_surface_vknots_body :
	real_list
	;

nurbs_surface_trim_body :
	empty
	| nurbs_surface_trim_body LOOP '{' nurbs_surface_trim_loop_body '}'
	;

nurbs_surface_trim_loop_body :
	empty
	| nurbs_surface_trim_loop_body nurbs_curve
	;

nurbs_curve_order_body :
	integer
	;

nurbs_curve_knots_body :
	real_list
	;

table :
	TABLE optional_name '{' table_body '}'
	;

bundle :
	BUNDLE optional_name '{' table_body '}'
	;

table_body :
	empty
	| table_body table
	| table_body bundle
	| table_body sanim
	| table_body xfmanim
	| table_body xfm_s_anim
	;

sanim :
	SANIM optional_name '{' sanim_body '}'
	;

sanim_body :
	empty
	| sanim_body SCALAR required_name '{' real_or_string '}'
	| sanim_body TABLE_V '{' real_list '}'
	;

xfmanim :
	XFMANIM optional_name '{' xfmanim_body '}'
	;

xfmanim_body :
	empty
	| xfmanim_body SCALAR required_name '{' real_or_string '}'
	| xfmanim_body TABLE_V '{' real_list '}'
	;

xfm_s_anim :
	XFMSANIM optional_name '{' xfm_s_anim_body '}'
	;

xfm_s_anim_body :
	empty
	| xfm_s_anim_body SCALAR required_name '{' real_or_string '}'
	| xfm_s_anim_body sanim
	;

anim_preload :
	ANIMPRELOAD optional_name '{' anim_preload_body '}'
	;

anim_preload_body :
	empty
	| anim_preload_body SCALAR required_name '{' real_or_string '}'
	;

integer_list :
	empty
	| integer_list integer
	;

real_list :
	empty
	| real_list real
	;

texture_name :
	required_name
	;

material_name :
	required_name
	;

vertex_pool_name :
	required_name
	;

group_name :
	required_name
	;

required_name :
	empty
	| string
	;

optional_name :
	optional_string
	;

required_string :
	empty
	| string
	;

optional_string :
	empty
	| string
	;

string :
	EGG_NUMBER
	| EGG_ULONG
	| EGG_STRING
	;

repeated_string :
	empty
	| repeated_string_body
	;

repeated_string_body :
	string
	| repeated_string_body string
	;

real :
	EGG_NUMBER
	| EGG_ULONG
	;

real_or_string :
	EGG_NUMBER
	| EGG_ULONG
	| EGG_STRING
	;

integer :
	EGG_NUMBER
	| EGG_ULONG
	;

empty :
	/*empty*/
	;

%%

%option caseless

HEX             0x[0-9a-fA-F]*
BINARY          0b[01]*
NUMERIC         ([+-]?(([0-9]+[.]?)|([0-9]*[.][0-9]+))([eE][+-]?[0-9]+)?)

%%

[ \t\r\n]+ skip()

"//".* skip()

"/*"(?s:.)*?"*/"	skip()

"<ANIMPRELOAD>"  ANIMPRELOAD
"<AUX>"  AUX
//"<BEZIERCURVE>"  BEZIERCURVE
"<BFACE>"  BFACE
"<BILLBOARD>"  BILLBOARD
"<BILLBOARDCENTER>"  BILLBOARDCENTER
"<BINORMAL>"  BINORMAL
"<BUNDLE>"  BUNDLE
"<CHAR*>"  SCALAR
//"<CLOSED>"  CLOSED
"<COLLIDE>"  COLLIDE
"<COMMENT>"  COMMENT
"<COMPONENT>"  COMPONENT
"<COORDINATESYSTEM>"  COORDSYSTEM
//"<CV>"  CV
"<DART>"  DART
"<DNORMAL>"  DNORMAL
"<DRGBA>"  DRGBA
"<DUV>"  DUV
"<DXYZ>"  DXYZ
"<DCS>"  DCS
"<DISTANCE>"  DISTANCE
//"<DTREF>"  DTREF
//"<DYNAMICVERTEXPOOL>"  DYNAMICVERTEXPOOL
"<FILE>"  EXTERNAL_FILE
"<GROUP>"  GROUP
"<DEFAULTPOSE>"  DEFAULTPOSE
"<JOINT>"  JOINT
"<KNOTS>"  KNOTS
//"<INCLUDE>"  INCLUDE
"<INSTANCE>"  INSTANCE
"<LINE>"  LINE
"<LOOP>"  LOOP
"<MATERIAL>"  MATERIAL
"<MATRIX3>"  MATRIX3
"<MATRIX4>"  MATRIX4
"<MODEL>"  MODEL
"<MREF>"  MREF
"<NORMAL>"  NORMAL
"<NURBSCURVE>"  NURBSCURVE
"<NURBSSURFACE>"  NURBSSURFACE
"<OBJECTTYPE>"  OBJECTTYPE
"<ORDER>"  ORDER
//"<OUTTANGENT>"  OUTTANGENT
"<PATCH>"  PATCH
"<POINTLIGHT>"  POINTLIGHT
"<POLYGON>"  POLYGON
"<REF>"  REF
"<RGBA>"  RGBA
"<ROTATE>"  ROTATE
"<ROTX>"  ROTX
"<ROTY>"  ROTY
"<ROTZ>"  ROTZ
"<S$ANIM>"  SANIM
"<SCALAR>"  SCALAR
"<SCALE>"  SCALE
//"<SEQUENCE>"  SEQUENCE
//"<SHADING>"  SHADING
"<SWITCH>"  SWITCH
"<SWITCHCONDITION>"  SWITCHCONDITION
"<TABLE>"  TABLE
"<V>"  TABLE_V
"<TAG>"  TAG
"<TANGENT>"  TANGENT
"<TEXLIST>"  TEXLIST
"<TEXTURE>"  TEXTURE
//"<TLENGTHS>"  TLENGTHS
"<TRANSFORM>"  TRANSFORM
"<TRANSLATE>"  TRANSLATE
"<TREF>"  TREF
"<TRIANGLEFAN>"  TRIANGLEFAN
"<TRIANGLESTRIP>"  TRIANGLESTRIP
"<TRIM>"  TRIM
//"<TXT>"  TXT
"<U-KNOTS>"  UKNOTS
"<U_KNOTS>"  UKNOTS
"<UV>"  UV
"<V-KNOTS>"  VKNOTS
"<V_KNOTS>"  VKNOTS
"<VERTEX>"  VERTEX
//"<VERTEXANIM>"  VERTEXANIM
"<VERTEXPOOL>"  VERTEXPOOL
"<VERTEXREF>"  VERTEXREF
"<XFM$ANIM>"  XFMANIM
"<XFM$ANIM_S$>"  XFMSANIM



{NUMERIC}  EGG_NUMBER

{HEX}  EGG_ULONG

{BINARY}  EGG_ULONG

"nan"{HEX}  EGG_NUMBER

"inf"  EGG_NUMBER

"-inf"  EGG_NUMBER

"1.#inf"  EGG_NUMBER

"-1.#inf"  EGG_NUMBER


["](\\.|[^"\r\n\\])*["]  EGG_STRING


[^ \t\n\r{}"]+  EGG_STRING

"{"	'{'
"}"	'}'


%%
