//From: https://github.com/spawnfest/dtu/blob/de71d8dc0f1823c234359f0abd72c6162905c0cd/src/dtu_parser.yrl

%token integer float string
%token lname uname
%token open close open_list close_list open_map close_map
%token at colon pipe dot hash sep symbol

%%

doc : tl_exprs ;

tl_exprs : tl_expr ;
tl_exprs : tl_exprs tl_expr ;

tl_expr : node ;

node : qname head body ;
node : qname head ;
node : qname body ;
node : expr ;

head : open close ;
head : open seq close ;

body : open_map close_map ;
body : open_map seq close_map ;
body : open_map pipe alt_seq close_map ;

tagged : hash collection ;
tagged : hash qname collection ;
tagged : hash qname scalar ;
tagged : hash qname symbol scalar ;
tagged : pair ;
tagged : qname ;

collection : list ;
collection : map ;
collection : tuple ;

list : open_list close_list ;
list : open_list seq close_list ;

map : open_map close_map ;
map : open_map seq close_map ;

tuple : open close ;
tuple : open seq close ;

seq : node_list ;
seq : node_list sep ;

node_list : node ;
node_list : node_list sep node ;

alt_seq : expr ;
alt_seq : alt_seq pipe expr ;

pair : scalar colon node ;
pair : qname colon node ;
pair : scalar ;

scalar : integer ;
scalar : float ;
scalar : string ;

qname : qname_items at qname_items ;
qname : qname_items ;

qname_items : qname_item ;
qname_items : qname_items dot qname_item  ;

qname_item : lname ;
qname_item : uname ;

expr : tagged ;
expr : symbol tagged ;
expr : expr symbol tagged ;
expr : expr symbol symbol tagged ;
expr : expr symbol open expr close ;

%%

Number   [0-9]
Float    [0-9]+\.[0-9]+([eE][-+]?[0-9]+)?

String   \"(\\.|[^"\r\n\\])*\"

UName    [A-Z_][a-zA-Z0-9_-]*
LName    [a-z][a-zA-Z0-9_-]*

Symbol   (<|=|>|!|%|&|\?|\*|-|\+|\/|~)+

Open          \(
Close         \)

OpenList      \[
CloseList     \]

OpenMap       \{
CloseMap      \}

Sep           ,
Dot           \.
Hash          #
Colon         :
Pipe          \|
At            @

Endls         (\s|\t)*(\r?\n)
Whites        \s+
Tabs          \t+

%%

{Number}+               integer
{Float}                 float
{String}                string

{Open}                  open
{Close}                 close

{OpenList}              open_list
{CloseList}             close_list

{OpenMap}               open_map
{CloseMap}              close_map

{Sep}                   sep
{Dot}                   dot
{Hash}                  hash
{At}                    at
{Colon}                 colon
{Pipe}                  pipe
{Symbol}               symbol

// spaces, tabs and new lines
{Endls}                 skip()
{Whites}                skip()
{Tabs}                  skip()

{UName}                uname
{LName}                 lname

%%
