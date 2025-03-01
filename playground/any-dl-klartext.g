//Fom: https://github.com/klartext/any-dl/raw/refs/heads/master/scriptparser.mly
/*
  any-dl:
  -------
  Generic Media-Downloader for any kind of Online-Mediathek.

  Author / copyright: Oliver Bandel
  Copyleft:           GNU GENERAL PUBLIC LICENSE  v3 (or higher)
*/

//%token AND
%token ANYTAG
%token APPEND_TO
%token ARG
%token ARG_KEYS
%token ARG_PAIRS
%token ARG_VALS
%token BASENAME
%token CALL_MACRO
%token COLON
%token COLSELECT
%token COMMA
%token CSV_READ
%token CSV_SAVE
%token CSV_SAVE_AS
%token DATA
%token DATA_SLURP
%token DEF_MACRO
%token DELETE
%token DO
//%token DOCLIST
%token DONE
%token DOT
%token DOWNLOAD
%token DROPCOL
%token DROPROW
%token DUMMY
%token DUMP
%token DUMP_DATA
%token ELSE
%token EMPTYDUMMY
%token END
%token ENDIF
//%token EOF
//%token EOL
%token EQUALS
%token EXITPARSE
%token GET
%token GREP
%token GREPV
//%token GT
%token HTML_DECODE
%token HTML_STRING
%token IDENTIFIER
%token IFNE
%token INT_NUM
%token ISELECT_MATCH
%token JSON_PRETTIFY
%token LINKEXTRACT
%token LINKEXTRACT_XML
%token LIST_VARIABLES
%token LPAREN
%token MAKE_URL
%token MATCH
%token MSELECT
//%token NOT
//%token OR
%token PARSERNAME
%token PASTE
%token POST
%token PRINT
%token PRINT_STRING
%token QUOTE
%token READLINE
%token REBASE
%token RECALL
%token ROWSELECT
%token RPAREN
%token SAVE
%token SAVE_AS
%token SELECT
%token SELECT_MATCH
%token SEMI
%token SHOW_MATCH
%token SHOW_TAGS
%token SHOW_TAGS_FULLPATH
%token SHOW_TYPE
%token SHOW_VARIABLES
%token SORT
//%token ST
%token START
%token STORE
%token STORE_MATCH
%token STRING
%token SUBSTITUTE
%token SYSTEM
%token TABLE_TO_MATCHRES
%token TAG
//%token TAGEXTRACT
%token TAGSELECT
%token THEN
%token TITLEEXTRACT
%token TO_MATCHRES
%token TO_STRING
%token TRANSPOSE
%token UNIQ
%token URL_DECODE
%token VBAR
%token WHILE

//%left NOT
//%left AND OR
//%left GT ST
//%left MINUS PLUS
//%left DIV MULT

%start main

%%

main :
	decl_zom
	;

decl_zom :
    %empty
    | decl_zom decl
    ;

decl :
	parsername urlmatches START parser_script END
	| macrodef START parser_script END
	;

parsername :
	PARSERNAME STRING COLON
	;

macrodef :
	DEF_MACRO STRING COLON
	;

urlmatches :
	LPAREN string_list RPAREN
	|
	;

parser_script :
	statement_list
	|
	;

statement_list :
	command
	| statement_list command
	| assignment
	| statement_list assignment
	| conditional
	| statement_list conditional
	| while_loop
	| statement_list while_loop
	;

conditional :
	IFNE LPAREN statement_list RPAREN THEN statement_list ENDIF
	| IFNE LPAREN statement_list RPAREN THEN statement_list ELSE statement_list ENDIF
	;

assignment :
	IDENTIFIER EQUALS command
	;

while_loop :
	WHILE LPAREN statement_list RPAREN DO statement_list DONE
	;

command :
	command_base SEMI
	;

command_base :
	match_cmd
	| BASENAME
	| DUMMY
	| EMPTYDUMMY
	| DUMP
	| DUMP_DATA
	| EXITPARSE
	| HTML_DECODE
	| LINKEXTRACT
	| LINKEXTRACT_XML
	| QUOTE
	| REBASE
	| SAVE
	| SHOW_TAGS
	| SHOW_TAGS_FULLPATH
	| SHOW_TYPE
	| SORT
	| SYSTEM
	| TO_MATCHRES
	| TABLE_TO_MATCHRES
	| TO_STRING
	| TRANSPOSE
	| UNIQ
	| URL_DECODE
	| JSON_PRETTIFY
	| append_to
	| call_macro
	| csv_save
	| csv_save_as
	| csv_read
	| delete_cmd
	| storematch_cmd
	| download_cmd
	| drop_cmd
	| get_cmd
	| post_cmd
	| list_variables_cmd
	| make_url_cmd
	| paste_cmd
	| print_cmd
	| print_cmd_simple
	| readline
	| recall_cmd
	| save_as
	| selection
	| show_variables_cmd
	| showmatch_cmd
	| store_cmd
	| subst_cmd
	| tagselect_cmd
	| titleextract_cmd
	;

append_to :
	APPEND_TO LPAREN STRING RPAREN
	;

call_macro :
	CALL_MACRO LPAREN STRING RPAREN
	;

match_cmd :
	MATCH LPAREN STRING RPAREN
	;

print_cmd_simple :
	PRINT
	;

showmatch_cmd :
	SHOW_MATCH
	;

print_cmd :
	PRINT_STRING LPAREN STRING RPAREN
	| PRINT LPAREN argument_list RPAREN
	;

get_cmd :
	GET
	| GET LPAREN get_args RPAREN
	;

post_cmd :
	POST LPAREN argument_list RPAREN
	;

download_cmd :
	DOWNLOAD
	| DOWNLOAD LPAREN argument_list RPAREN
	;

store_cmd :
	STORE LPAREN STRING RPAREN
	;

recall_cmd :
	RECALL LPAREN STRING RPAREN
	;

delete_cmd :
	DELETE LPAREN STRING RPAREN
	;

storematch_cmd :
	STORE_MATCH LPAREN STRING RPAREN
	;

csv_save_as :
	CSV_SAVE_AS LPAREN argument_list RPAREN
	;

csv_save :
	CSV_SAVE
	;

csv_read :
	CSV_READ LPAREN argument_list RPAREN
	;

save_as :
	SAVE_AS LPAREN argument_list RPAREN
	;

readline :
	READLINE LPAREN STRING RPAREN
	| READLINE
	;

paste_cmd :
	PASTE LPAREN argument_list RPAREN
	;

subst_cmd :
	SUBSTITUTE LPAREN STRING COMMA STRING RPAREN
	;

show_variables_cmd :
	SHOW_VARIABLES
	;

list_variables_cmd :
	LIST_VARIABLES
	;

make_url_cmd :
	MAKE_URL LPAREN argument_item RPAREN
	| MAKE_URL LPAREN argument_item COMMA argument_item RPAREN
	| MAKE_URL
	;

selection :
	COLSELECT LPAREN INT_NUM RPAREN
	| ROWSELECT LPAREN INT_NUM RPAREN
	| SELECT LPAREN INT_NUM RPAREN
	| MSELECT LPAREN selection_list RPAREN
	| SELECT_MATCH LPAREN INT_NUM COMMA STRING RPAREN
	| ISELECT_MATCH LPAREN INT_NUM COMMA STRING COMMA STRING RPAREN
	| GREP LPAREN argument_list RPAREN
	| GREPV LPAREN argument_list RPAREN
	;

drop_cmd :
	DROPCOL LPAREN INT_NUM RPAREN
	| DROPROW LPAREN INT_NUM RPAREN
	;

titleextract_cmd :
	TITLEEXTRACT
	;

tagselect_cmd :
	TAGSELECT LPAREN tag_selector VBAR extractor_list RPAREN
	| TAGSELECT LPAREN tag_selector VBAR ARG_PAIRS RPAREN
	| TAGSELECT LPAREN tag_selector VBAR ARG_KEYS RPAREN
	| TAGSELECT LPAREN tag_selector VBAR ARG_VALS RPAREN
	;

tag_selector :
	ANYTAG
	| tagselect_arg_list
	;

tagselect_arg_list :
	tagselect_arg
	| tagselect_arg_list COMMA tagselect_arg
	;

tagselect_arg :
	tagname DOT argkey EQUALS argval
	| tagname DOT argkey
	| tagname DOT EQUALS argval
	| tagname
	| DOT argkey EQUALS argval
	| DOT argkey
	| DOT EQUALS argval
	;

tagname :
	STRING
	;

argkey :
	STRING
	;

argval :
	STRING
	;

extractor_list :
	extractor
	| extractor_list COMMA extractor
	;

extractor :
	DATA
	| DATA_SLURP
	| TAG
	| ARG LPAREN STRING RPAREN
	| DUMP
	| HTML_STRING
	;

string_list :
	| STRING
	| string_list COMMA STRING
	;

selection_list :
	INT_NUM
	| selection_list COMMA INT_NUM
	;

get_args :
	STRING
	| STRING COMMA STRING
	;

argument_list :
	| argument_item
	| argument_list COMMA argument_item
	;

argument_item :
	IDENTIFIER
	| STRING
	;

%%

%x GT3 UND3

alpha   [a-zA-Z]+
alpha_   [a-zA-Z_.]+
blanks   [ \t\n\r]+
digit    [0-9]
identifier   [a-zA-Z]({alpha_}|{digit})*

%%

"parsername"  PARSERNAME
"defmacro"    DEF_MACRO
"start"       START
"end"         END

"call"        CALL_MACRO

"show_type"    SHOW_TYPE
"match"        MATCH
"show_match"   SHOW_MATCH
"print"        PRINT
"print_string" PRINT_STRING

"json_prettify"       JSON_PRETTIFY

"csv_save_as"     CSV_SAVE_AS
"csv_save"        CSV_SAVE
"csv_read"        CSV_READ
"save"     SAVE
"save_as"  SAVE_AS

"linkextract"      LINKEXTRACT
"linkextract_xml"  LINKEXTRACT_XML
"titleextract"     TITLEEXTRACT
"tagselect"        TAGSELECT
"rebase"           REBASE

"get"            GET
"post"           POST
"download"       DOWNLOAD
"makeurl"        MAKE_URL

"store"          STORE
"recall"         RECALL
"delete"         DELETE
"storematch"     STORE_MATCH
"sort"           SORT
"uniq"           UNIQ
"show_variables"   SHOW_VARIABLES
"list_variables"   LIST_VARIABLES

"paste"          PASTE

"grep"           GREP
"grepv"          GREPV
"rowselect"      ROWSELECT
"select"         SELECT
"mselect"        MSELECT

"selectmatch"    SELECT_MATCH
"iselectmatch"   ISELECT_MATCH

"colselect"      COLSELECT

"dropcol"        DROPCOL
"droprow"        DROPROW

"basename"       BASENAME
"subst"          SUBSTITUTE
"quote"          QUOTE
"to_string"      TO_STRING
"to_matchres"    TO_MATCHRES
"appendto"       APPEND_TO
"transpose"      TRANSPOSE
"table_to_matchres"  TABLE_TO_MATCHRES

"system"         SYSTEM
"exitparse"      EXITPARSE

"dump"           DUMP
"dump_data"      DUMP_DATA
"show_tags"      SHOW_TAGS
"show_tags_fullpath"  SHOW_TAGS_FULLPATH

"htmldecode"  HTML_DECODE
"urldecode"   URL_DECODE

"readline"       READLINE

"if"          IFNE  /* IF */
"ifne"        IFNE  /* IF */
"ifnotempty"  IFNE  /* IF */
"fi"       ENDIF    /* IF */
"endif"    ENDIF    /* IF */
"then"     THEN     /* IF */
"else"     ELSE     /* IF */
"while"            WHILE    /* WHILE */
"whilene"          WHILE    /* WHILE */
"whilenotequal"    WHILE    /* WHILE */
"do"               DO       /* WHILE */
"done"             DONE     /* WHILE */


"dummy"       DUMMY
"emptydummy"  EMPTYDUMMY

/* selectors and extractors for tagselect() */
"anytag"           ANYTAG     /* selector  */

"data"             DATA       /* extractor */
"dataslurp"        DATA_SLURP /* extractor */
"arg"              ARG        /* extractor */
"tag"              TAG        /* extractor */
"argkeys"          ARG_KEYS   /* extractor */
"argvals"          ARG_VALS   /* extractor */
"argpairs"         ARG_PAIRS    /* extractor */
"htmlstring"       HTML_STRING  /* extractor */
//"doclist"          DOCLIST     /* extractor */


{blanks}   skip()
{identifier}	IDENTIFIER
{digit}+	INT_NUM
\"(\\.|[^"\r\n\\])*\"	STRING
">>>"<GT3>
<GT3>{
	"<<<"<INITIAL>	STRING
	.<.>
}
"_*_"<UND3>
<UND3>{
	"_*_"<INITIAL>	STRING
	.<.>
}
"."            DOT

"$"{identifier}	IDENTIFIER

//">"            GT
//"<"            ST
"="            EQUALS

","            COMMA
";"            SEMI
":"            COLON
"("            LPAREN
")"            RPAREN
"|"            VBAR         /* VBAR or "pipe" in unix"ish */
{digit}+         INT_NUM
"#".*	skip()
"_"              IDENTIFIER
//eof            EOF

%%
