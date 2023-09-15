//From: https://github.com/andmarti1424/sc-im/blob/main/src/gram.y
/*******************************************************************************
 * Copyright (c) 2013-2021, Andrés Martinelli <andmarti@gmail.com>             *
 * All rights reserved.                                                        *
 *                                                                             *
 * This file is a part of sc-im                                                *
 *                                                                             *
 * sc-im is a spreadsheet program that is based on sc. The original authors    *
 * of sc are James Gosling and Mark Weiser, and mods were later added by       *
 * Chuck Martin.                                                               *
 *                                                                             *
 * Redistribution and use in source and binary forms, with or without          *
 * modification, are permitted provided that the following conditions are met: *
 * 1. Redistributions of source code must retain the above copyright           *
 *    notice, this list of conditions and the following disclaimer.            *
 * 2. Redistributions in binary form must reproduce the above copyright        *
 *    notice, this list of conditions and the following disclaimer in the      *
 *    documentation and/or other materials provided with the distribution.     *
 * 3. All advertising materials mentioning features or use of this software    *
 *    must display the following acknowledgement:                              *
 *    This product includes software developed by Andrés Martinelli            *
 *    <andmarti@gmail.com>.                                                    *
 * 4. Neither the name of the Andrés Martinelli nor the                        *
 *   names of other contributors may be used to endorse or promote products    *
 *   derived from this software without specific prior written permission.     *
 *                                                                             *
 * THIS SOFTWARE IS PROVIDED BY ANDRES MARTINELLI ''AS IS'' AND ANY            *
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED   *
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE      *
 * DISCLAIMED. IN NO EVENT SHALL ANDRES MARTINELLI BE LIABLE FOR ANY           *
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES  *
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;*
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND *
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT  *
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE       *
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.           *
 *******************************************************************************/

%option caseless
%token NL

/*Tokens*/
%token STRING
%token COL
%token NUMBER
%token FNUMBER
%token RANGE
%token VAR
%token WORD
//%token MAPWORD
//%token PLUGIN
%token S_SHOW
%token S_HIDE
%token S_SHOWROW
%token S_HIDEROW
%token S_SHOWCOL
%token S_HIDECOL
%token S_FREEZE
%token S_UNFREEZE
%token S_MARK
%token S_AUTOFIT
%token S_PAD
%token S_DELETECOL
%token S_DATEFMT
%token S_SUBTOTAL
%token S_RSUBTOTAL
%token S_FORMAT
%token S_FMT
%token S_LET
%token S_LABEL
%token S_LEFTSTRING
%token S_RIGHTSTRING
%token S_LEFTJUSTIFY
%token S_RIGHTJUSTIFY
%token S_CENTER
%token S_SORT
%token S_FILTERON
%token S_GOTO
%token S_GOTOB
%token S_CCOPY
%token S_CPASTE
%token S_PLOT
%token S_LOCK
%token S_UNLOCK
%token S_DEFINE
%token S_UNDEFINE
%token S_DETAIL
%token S_EVAL
%token S_SEVAL
%token S_ERROR
%token S_FILL
%token S_STRTONUM
%token S_DELETEROW
%token S_VALUEIZEALL
%token S_SHIFT
%token S_GETNUM
%token S_YANKAREA
%token S_PASTEYANKED
%token S_GETSTRING
%token S_GETEXP
%token S_GETFMT
%token S_GETFORMAT
%token S_RECALC
%token S_EXECUTE
%token S_QUIT
%token S_EXPORT
%token S_REBUILD_GRAPH
%token S_PRINT_GRAPH
%token S_SYNCREFS
%token S_REDO
%token S_UNDO
%token S_IMAP
%token S_CMAP
%token S_NEWSHEET
%token S_NEXTSHEET
%token S_PREVSHEET
%token S_DELSHEET
%token S_MOVETOSHEET
%token S_RENAMESHEET
%token S_NMAP
%token S_VMAP
%token S_INOREMAP
%token S_CNOREMAP
%token S_NNOREMAP
%token S_VNOREMAP
%token S_NUNMAP
%token S_IUNMAP
%token S_CUNMAP
%token S_VUNMAP
%token S_COLOR
%token S_CELLCOLOR
%token S_UNFORMAT
%token S_REDEFINE_COLOR
%token S_DEFINE_COLOR
%token S_SET
%token S_FCOPY
%token S_FSUM
%token S_TRIGGER
%token S_UNTRIGGER
%token S_OFFSCR_SC_COLS
%token S_OFFSCR_SC_ROWS
%token S_NB_FROZEN_ROWS
%token S_NB_FROZEN_COLS
%token S_NB_FROZEN_SCREENROWS
%token S_NB_FROZEN_SCREENCOLS
%token K_AUTOBACKUP
%token K_NOAUTOBACKUP
%token K_AUTOCALC
%token K_NOAUTOCALC
%token K_DEBUG
%token K_NODEBUG
%token K_TRG
%token K_NOTRG
%token K_EXTERNAL_FUNCTIONS
%token K_NOEXTERNAL_FUNCTIONS
%token K_EXEC_LUA
%token K_NOEXEC_LUA
%token K_HALF_PAGE_SCROLL
%token K_NOHALF_PAGE_SCROLL
%token K_NOCURSES
%token K_CURSES
%token K_NUMERIC
%token K_NONUMERIC
%token K_NUMERIC_DECIMAL
%token K_NONUMERIC_DECIMAL
%token K_NUMERIC_ZERO
%token K_NONUMERIC_ZERO
%token K_OVERLAP
%token K_NOOVERLAP
%token K_INPUT_BAR_BOTTOM
%token K_IGNORE_HIDDEN
%token K_NOIGNORE_HIDDEN
%token K_INPUT_EDIT_MODE
%token K_UNDERLINE_GRID
%token K_TRUNCATE
%token K_NOTRUNCATE
%token K_AUTOWRAP
%token K_NOAUTOWRAP
%token K_QUIET
%token K_NOQUIET
%token K_QUIT_AFTERLOAD
%token K_NOQUIT_AFTERLOAD
%token K_XLSX_READFORMULAS
%token K_NOXLSX_READFORMULAS
%token K_DEFAULT_COPY_TO_CLIPBOARD_CMD
%token K_DEFAULT_PASTE_FROM_CLIPBOARD_CMD
%token K_COPY_TO_CLIPBOARD_DELIMITED_TAB
%token K_NOCOPY_TO_CLIPBOARD_DELIMITED_TAB
%token K_DEFAULT_OPEN_FILE_UNDER_CURSOR_CMD
%token K_IMPORT_DELIMITED_TO_TEXT
%token K_IGNORECASE
%token K_NOIGNORECASE
%token K_TM_GMTOFF
%token K_COMMAND_TIMEOUT
%token K_MAPPING_TIMEOUT
%token K_NEWLINE_ACTION
%token K_SHOW_CURSOR
%token K_NOSHOW_CURSOR
//%token K_ERROR
//%token K_INVALID
%token K_FIXED
%token K_SUM
%token K_PROD
%token K_AVG
%token K_STDDEV
%token K_COUNT
%token K_ROWS
%token K_COLS
%token K_ABS
%token K_FROW
%token K_FCOL
%token K_ACOS
%token K_ASIN
%token K_ATAN
%token K_ATAN2
%token K_CEIL
%token K_COS
%token K_EXP
%token K_FABS
%token K_FLOOR
%token K_HYPOT
%token K_LN
%token K_LOG
%token K_PI
%token K_POW
%token K_SIN
%token K_SQRT
%token K_TAN
%token K_DTR
%token K_RTD
%token K_MAX
%token K_MIN
%token K_RND
%token K_ROUND
%token K_IF
%token K_PV
%token K_FV
%token K_PMT
%token K_HOUR
%token K_MINUTE
%token K_SECOND
%token K_MONTH
%token K_DAY
%token K_YEAR
%token K_NOW
%token K_DATE
%token K_DTS
%token K_TTS
%token K_FMT
%token K_REPLACE
%token K_SUBSTR
%token K_UPPER
%token K_LOWER
%token K_CAPITAL
%token K_STON
%token K_SLEN
%token K_EQS
%token K_EXT
%token K_EVALUATE
%token K_SEVALUATE
%token K_LUA
%token K_NVAL
%token K_SVAL
%token K_LOOKUP
%token K_HLOOKUP
%token K_VLOOKUP
%token K_INDEX
%token K_STINDEX
%token K_GETENT
//%token K_TBLSTYLE
//%token K_TBL
//%token K_LATEX
//%token K_SLATEX
//%token K_TEX
//%token K_FRAME
//%token K_RNDTOEVEN
%token K_FILENAME
%token K_MYROW
%token K_MYCOL
%token K_LASTROW
%token K_LASTCOL
%token K_COLTOA
//%token K_CRACTION
//%token K_CRROW
//%token K_CRCOL
//%token K_ROWLIMIT
//%token K_COLLIMIT
//%token K_PAGESIZE
%token K_ERR
%token K_REF
//%token K_LOCALE
%token K_SET8BIT
%token K_ASCII
%token K_CHR
%token K_FACT

%token ';'
%token '?'
%token ':'
%token '|'
%token '&'
%token '<'
%token '='
%token '>'
%token '!'
%token '+'
%token '-'
%token '#'
%token '*'
%token '/'
%token '%'
%token '^'
%token '{'
%token '}'
%token '@'
%token '('
%token ')'
%token ','
%token '.'
%token '~'
%token '$'

%right /*1*/ ';'
%left /*2*/ '?' ':'
%left /*3*/ '|'
%left /*4*/ '&'
%nonassoc /*5*/ '<' '=' '>' '!'
%left /*6*/ '+' '-' '#'
%left /*7*/ '*' '/' '%'
%left /*8*/ '^'

%start sc_commands

%%

sc_commands :
    command NL
    | sc_commands command NL
    ;

command :
	S_LET var_or_range '=' /*5N*/ e
	| S_LET var_or_range '=' /*5N*/
	| S_LABEL var_or_range '=' /*5N*/ e
	| S_LEFTSTRING var_or_range '=' /*5N*/ e
	| S_RIGHTSTRING var_or_range '=' /*5N*/ e
	| S_LEFTJUSTIFY var_or_range
	| S_RIGHTJUSTIFY var_or_range
	| S_CENTER var_or_range
	| S_FMT var_or_range STRING
	| S_DATEFMT var_or_range STRING
	| S_DATEFMT STRING
	| S_HIDE COL
	| S_HIDE NUMBER
	| S_SHOW COL
	| S_SHOW NUMBER
	| S_DELETECOL COL
	| S_DELETEROW NUMBER
	| S_HIDECOL COL
	| S_SHOWCOL COL
	| S_HIDEROW NUMBER
	| S_SHOWROW NUMBER
	| S_SHOWCOL COL ':' /*2L*/ COL
	| S_SHOWROW NUMBER ':' /*2L*/ NUMBER
	| S_HIDECOL COL ':' /*2L*/ COL
	| S_HIDEROW NUMBER ':' /*2L*/ NUMBER
	| S_VALUEIZEALL
	| S_SHIFT var_or_range STRING
	| S_MARK COL var_or_range
	| S_MARK COL var_or_range var_or_range
	| S_MARK COL STRING var_or_range
	| S_MARK COL STRING var_or_range var_or_range
	| S_FILL var_or_range num num
	| S_FILL num num
	| S_FREEZE NUMBER ':' /*2L*/ NUMBER
	| S_FREEZE NUMBER
	| S_FREEZE COL ':' /*2L*/ COL
	| S_FREEZE COL
	| S_UNFREEZE NUMBER ':' /*2L*/ NUMBER
	| S_UNFREEZE NUMBER
	| S_UNFREEZE COL ':' /*2L*/ COL
	| S_UNFREEZE COL
	| S_SORT range STRING
	| S_SUBTOTAL range COL STRING COL
	| S_RSUBTOTAL range COL STRING COL
	| S_AUTOFIT COL ':' /*2L*/ COL
	| S_AUTOFIT COL
	| S_PAD NUMBER COL ':' /*2L*/ COL
	| S_PAD NUMBER COL
	| S_PAD NUMBER var_or_range
	| S_GETFORMAT COL
	| S_FORMAT COL NUMBER NUMBER NUMBER
	| S_FORMAT NUMBER NUMBER
	| S_FILTERON range
	| S_GOTO var_or_range var_or_range
	| S_GOTO var_or_range
	| S_GOTO num
	| S_GOTO STRING
	| S_GOTO '#' /*6L*/ STRING
	| S_GOTO '%' /*7L*/ STRING
	| S_GOTOB num
	| S_GOTOB STRING
	| S_GOTOB '#' /*6L*/ STRING
	| S_GOTOB '%' /*7L*/ STRING
	| S_CCOPY range
	| S_STRTONUM range
	| S_CPASTE
	| S_LOCK var_or_range
	| S_UNLOCK var_or_range
	| S_NEWSHEET STRING
	| S_DELSHEET STRING
	| S_DELSHEET
	| S_NEXTSHEET
	| S_PREVSHEET
	| S_MOVETOSHEET STRING
	| S_RENAMESHEET STRING
	| S_NMAP STRING STRING
	| S_IMAP STRING STRING
	| S_VMAP STRING STRING
	| S_CMAP STRING STRING
	| S_NNOREMAP STRING STRING
	| S_INOREMAP STRING STRING
	| S_VNOREMAP STRING STRING
	| S_CNOREMAP STRING STRING
	| S_NUNMAP STRING
	| S_IUNMAP STRING
	| S_VUNMAP STRING
	| S_CUNMAP STRING
	| S_COLOR STRING
	| S_DETAIL var
	| S_CELLCOLOR var_or_range STRING
	| S_TRIGGER var_or_range STRING
	| S_OFFSCR_SC_COLS NUMBER
	| S_OFFSCR_SC_ROWS NUMBER
	| S_NB_FROZEN_ROWS NUMBER
	| S_NB_FROZEN_COLS NUMBER
	| S_NB_FROZEN_SCREENROWS NUMBER
	| S_NB_FROZEN_SCREENCOLS NUMBER
	| S_UNTRIGGER var_or_range
	| S_CELLCOLOR STRING
	| S_UNFORMAT var_or_range
	| S_UNFORMAT
	| S_REDEFINE_COLOR STRING NUMBER NUMBER NUMBER
	| S_DEFINE_COLOR STRING NUMBER NUMBER NUMBER
	| S_FCOPY
	| S_FCOPY strarg
	| S_FSUM
	| S_PLOT STRING var_or_range
	| S_SET setlist
	| S_DEFINE strarg range
	| S_DEFINE strarg var
	| S_UNDEFINE var_or_range
	| S_EVAL e
	| S_EXECUTE STRING
	| S_EXPORT STRING STRING
	| S_QUIT
	| S_REBUILD_GRAPH
	| S_PRINT_GRAPH
	| S_SYNCREFS
	| S_UNDO
	| S_REDO
	| S_RECALC
	| S_GETNUM var_or_range
	| S_GETNUM '{' STRING '}' '!' /*5N*/ var_or_range
	| S_GETSTRING var_or_range
	| S_GETEXP var_or_range
	| S_GETFMT var_or_range
	| S_YANKAREA '{' STRING '}' '!' /*5N*/ var_or_range STRING
	| S_PASTEYANKED '{' STRING '}' NUMBER STRING
	| S_SEVAL e
	| S_ERROR STRING
	| /*empty*/
	//| error
	;

term :
	var
	| '{' STRING '}' '!' /*5N*/ var
	| '@' K_FIXED term
	| '(' '@' K_FIXED ')' term
	| '@' K_SUM '(' var_or_range ')'
	| '@' K_SUM '(' range ',' e ')'
	| '@' K_PROD '(' var_or_range ')'
	| '@' K_PROD '(' range ',' e ')'
	| '@' K_AVG '(' var_or_range ')'
	| '@' K_AVG '(' range ',' e ')'
	| '@' K_STDDEV '(' var_or_range ')'
	| '@' K_STDDEV '(' range ',' e ')'
	| '@' K_COUNT '(' var_or_range ')'
	| '@' K_COUNT '(' range ',' e ')'
	| '@' K_MAX '(' var_or_range ')'
	| '@' K_MAX '(' range ',' e ')'
	| '@' K_MAX '(' e ',' expr_list ')'
	| '@' K_MIN '(' var_or_range ')'
	| '@' K_MIN '(' range ',' e ')'
	| '@' K_MIN '(' e ',' expr_list ')'
	| '@' K_ROWS '(' var_or_range ')'
	| '@' K_COLS '(' var_or_range ')'
	| '@' K_ABS '(' e ')'
	| '@' K_FROW '(' e ')'
	| '@' K_FCOL '(' e ')'
	| '@' K_ACOS '(' e ')'
	| '@' K_ASIN '(' e ')'
	| '@' K_ATAN '(' e ')'
	| '@' K_ATAN2 '(' e ',' e ')'
	| '@' K_CEIL '(' e ')'
	| '@' K_COS '(' e ')'
	| '@' K_EXP '(' e ')'
	| '@' K_FABS '(' e ')'
	| '@' K_FLOOR '(' e ')'
	| '@' K_HYPOT '(' e ',' e ')'
	| '@' K_LN '(' e ')'
	| '@' K_LOG '(' e ')'
	| '@' K_POW '(' e ',' e ')'
	| '@' K_SIN '(' e ')'
	| '@' K_SQRT '(' e ')'
	| '@' K_TAN '(' e ')'
	| '@' K_DTR '(' e ')'
	| '@' K_RTD '(' e ')'
	| '@' K_RND '(' e ')'
	| '@' K_ROUND '(' e ',' e ')'
	| '@' K_IF '(' e ',' e ',' e ')'
	| '@' K_PV '(' e ',' e ',' e ')'
	| '@' K_FV '(' e ',' e ',' e ')'
	| '@' K_PMT '(' e ',' e ',' e ')'
	| '@' K_HOUR '(' e ')'
	| '@' K_MINUTE '(' e ')'
	| '@' K_SECOND '(' e ')'
	| '@' K_MONTH '(' e ')'
	| '@' K_DAY '(' e ')'
	| '@' K_YEAR '(' e ')'
	| '@' K_NOW
	| '@' K_DTS '(' e ',' e ',' e ')'
	| NUMBER '.' NUMBER '.' NUMBER
	| '@' K_TTS '(' e ',' e ',' e ')'
	| '@' K_STON '(' e ')'
	| '@' K_SLEN '(' e ')'
	| '@' K_EQS '(' e ',' e ')'
	| '@' K_DATE '(' e ')'
	| '@' K_DATE '(' e ',' e ')'
	| '@' K_FMT '(' e ',' e ')'
	| '@' K_UPPER '(' e ')'
	| '@' K_LOWER '(' e ')'
	| '@' K_CAPITAL '(' e ')'
	| '@' K_INDEX '(' range ',' e ')'
	| '@' K_INDEX '(' e ',' range ')'
	| '@' K_INDEX '(' range ',' e ',' e ')'
	| '@' K_LOOKUP '(' range ',' e ')'
	| '@' K_LOOKUP '(' e ',' range ')'
	| '@' K_HLOOKUP '(' range ',' e ',' e ')'
	| '@' K_HLOOKUP '(' e ',' range ',' e ')'
	| '@' K_VLOOKUP '(' range ',' e ',' e ')'
	| '@' K_VLOOKUP '(' e ',' range ',' e ')'
	| '@' K_STINDEX '(' range ',' e ')'
	| '@' K_STINDEX '(' e ',' range ')'
	| '@' K_STINDEX '(' range ',' e ',' e ')'
	| '@' K_EXT '(' e ',' e ')'
	| '@' K_LUA '(' e ',' e ')'
	| '@' K_MYROW
	| '@' K_MYCOL
	| '@' K_LASTROW
	| '@' K_LASTCOL
	| '@' K_NVAL '(' e ',' e ')'
	| '@' K_SVAL '(' e ',' e ')'
	| '@' K_REPLACE '(' e ',' e ',' e ')'
	| '@' K_EVALUATE '(' e ')'
	| '@' K_SEVALUATE '(' e ')'
	| '@' K_SUBSTR '(' e ',' e ',' e ')'
	| '(' e ')'
	| '+' /*6L*/ term
	| NUMBER
	| FNUMBER
	| '@' K_PI
	| STRING
	| '~' term
	| '!' /*5N*/ term
	| '@' K_FILENAME '(' e ')'
	| '@' K_COLTOA '(' e ')'
	| '@' K_ASCII '(' e ')'
	| '@' K_SET8BIT '(' e ')'
	| '@' K_CHR '(' e ')'
	| '@' K_ERR
	| K_ERR
	| '@' K_REF
	| K_REF
	| '@' K_FACT '(' e ')'
	;

e :
	e '+' /*6L*/ e
	| e '-' /*6L*/ e
	| e '*' /*7L*/ e
	| e '/' /*7L*/ e
	| e '%' /*7L*/ e
	| '-' /*6L*/ e
	| e '^' /*8L*/ e
	| term
	| e '?' /*2L*/ e ':' /*2L*/ e
	| e ';' /*1R*/ e
	| e '<' /*5N*/ e
	| e '=' /*5N*/ e
	| e '>' /*5N*/ e
	| e '&' /*4L*/ e
	| e '|' /*3L*/ e
	| e '<' /*5N*/ '=' /*5N*/ e
	| e '<' /*5N*/ '>' /*5N*/ e
	| e '>' /*5N*/ '=' /*5N*/ e
	| e '#' /*6L*/ e
	;

expr_list :
	e
	| expr_list ',' e
	;

range :
	var ':' /*2L*/ var
	| RANGE
	;

var :
	COL NUMBER
	| '$' COL NUMBER
	| COL '$' NUMBER
	| '$' COL '$' NUMBER
	| '@' K_GETENT '(' e ',' e ')'
	| VAR
	;

var_or_range :
	range
	| var
	;

num :
	NUMBER
	| FNUMBER
	| '-' /*6L*/ num
	| '+' /*6L*/ num
	;

strarg :
	STRING
	| var
	;

setlist :
	/*empty*/
	| setlist setitem
	;

setitem :
	K_OVERLAP '=' /*5N*/ NUMBER
	| K_OVERLAP
	| K_INPUT_BAR_BOTTOM '=' /*5N*/ NUMBER
	| K_INPUT_BAR_BOTTOM
	| K_INPUT_EDIT_MODE '=' /*5N*/ NUMBER
	| K_INPUT_EDIT_MODE
	| K_UNDERLINE_GRID '=' /*5N*/ NUMBER
	| K_UNDERLINE_GRID
	| K_NOOVERLAP
	| K_TRUNCATE '=' /*5N*/ NUMBER
	| K_TRUNCATE
	| K_NOTRUNCATE
	| K_AUTOWRAP '=' /*5N*/ NUMBER
	| K_AUTOWRAP
	| K_NOAUTOWRAP
	| K_AUTOBACKUP '=' /*5N*/ NUMBER
	| K_NOAUTOBACKUP
	| K_AUTOCALC
	| K_AUTOCALC '=' /*5N*/ NUMBER
	| K_NOAUTOCALC
	| K_DEBUG
	| K_DEBUG '=' /*5N*/ NUMBER
	| K_NODEBUG
	| K_TRG
	| K_TRG '=' /*5N*/ NUMBER
	| K_NOTRG
	| K_EXTERNAL_FUNCTIONS
	| K_EXTERNAL_FUNCTIONS '=' /*5N*/ NUMBER
	| K_NOEXTERNAL_FUNCTIONS
	| K_EXEC_LUA
	| K_EXEC_LUA '=' /*5N*/ NUMBER
	| K_NOEXEC_LUA
	| K_HALF_PAGE_SCROLL
	| K_HALF_PAGE_SCROLL '=' /*5N*/ NUMBER
	| K_NOHALF_PAGE_SCROLL
	| K_IGNORE_HIDDEN
	| K_IGNORE_HIDDEN '=' /*5N*/ NUMBER
	| K_NOIGNORE_HIDDEN
	| K_QUIET '=' /*5N*/ NUMBER
	| K_QUIET
	| K_NOQUIET
	| K_QUIT_AFTERLOAD
	| K_QUIT_AFTERLOAD '=' /*5N*/ NUMBER
	| K_NOQUIT_AFTERLOAD
	| K_XLSX_READFORMULAS
	| K_XLSX_READFORMULAS '=' /*5N*/ NUMBER
	| K_NOXLSX_READFORMULAS
	| K_NOCURSES
	| K_NOCURSES '=' /*5N*/ NUMBER
	| K_CURSES
	| K_NUMERIC
	| K_NUMERIC '=' /*5N*/ NUMBER
	| K_NONUMERIC
	| K_IGNORECASE
	| K_IGNORECASE '=' /*5N*/ NUMBER
	| K_NOIGNORECASE
	| K_NUMERIC_DECIMAL
	| K_NUMERIC_DECIMAL '=' /*5N*/ NUMBER
	| K_NONUMERIC_DECIMAL
	| K_NUMERIC_ZERO
	| K_NUMERIC_ZERO '=' /*5N*/ NUMBER
	| K_NONUMERIC_ZERO
	| K_NEWLINE_ACTION
	| K_NEWLINE_ACTION '=' /*5N*/ WORD
	| K_DEFAULT_COPY_TO_CLIPBOARD_CMD '=' /*5N*/ strarg
	| K_DEFAULT_PASTE_FROM_CLIPBOARD_CMD '=' /*5N*/ strarg
	| K_IMPORT_DELIMITED_TO_TEXT
	| K_IMPORT_DELIMITED_TO_TEXT '=' /*5N*/ NUMBER
	| K_COPY_TO_CLIPBOARD_DELIMITED_TAB
	| K_COPY_TO_CLIPBOARD_DELIMITED_TAB '=' /*5N*/ NUMBER
	| K_NOCOPY_TO_CLIPBOARD_DELIMITED_TAB
	| K_DEFAULT_OPEN_FILE_UNDER_CURSOR_CMD '=' /*5N*/ strarg
	| K_NEWLINE_ACTION '=' /*5N*/ NUMBER
	| K_COMMAND_TIMEOUT
	| K_COMMAND_TIMEOUT '=' /*5N*/ num
	| K_MAPPING_TIMEOUT
	| K_MAPPING_TIMEOUT '=' /*5N*/ num
	| K_TM_GMTOFF
	| K_TM_GMTOFF '=' /*5N*/ num
	| K_SHOW_CURSOR '=' /*5N*/ NUMBER
	| K_SHOW_CURSOR
	| K_NOSHOW_CURSOR
	;

%%

%%

[ \t\r]+	skip()
"#".*\n?   skip()
\n  NL

"AUTOBACKUP"     K_AUTOBACKUP
"NOAUTOBACKUP"     K_NOAUTOBACKUP
"AUTOCALC"     K_AUTOCALC
"NOAUTOCALC"     K_NOAUTOCALC
"DEBUG"     K_DEBUG
"NODEBUG"     K_NODEBUG
"TRG"     K_TRG
"NOTRG"     K_NOTRG
"EXTERNAL_FUNCTIONS"     K_EXTERNAL_FUNCTIONS
"NOEXTERNAL_FUNCTIONS"     K_NOEXTERNAL_FUNCTIONS
"HALF_PAGE_SCROLL"     K_HALF_PAGE_SCROLL
"NOHALF_PAGE_SCROLL"     K_NOHALF_PAGE_SCROLL
"NOCURSES"     K_NOCURSES
"CURSES"     K_CURSES
"NUMERIC"     K_NUMERIC
"NONUMERIC"     K_NONUMERIC
"NUMERIC_DECIMAL"     K_NUMERIC_DECIMAL
"NONUMERIC_DECIMAL"     K_NONUMERIC_DECIMAL
"NUMERIC_ZERO"     K_NUMERIC_ZERO
"NONUMERIC_ZERO"     K_NONUMERIC_ZERO
"OVERLAP"     K_OVERLAP
"NOOVERLAP"     K_NOOVERLAP
"QUIT_AFTERLOAD"     K_QUIT_AFTERLOAD
"NOQUIT_AFTERLOAD"     K_NOQUIT_AFTERLOAD
"XLSX_READFORMULAS"     K_XLSX_READFORMULAS
"NOXLSX_READFORMULAS"     K_NOXLSX_READFORMULAS
"DEFAULT_COPY_TO_CLIPBOARD_CMD"     K_DEFAULT_COPY_TO_CLIPBOARD_CMD
"DEFAULT_PASTE_FROM_CLIPBOARD_CMD"     K_DEFAULT_PASTE_FROM_CLIPBOARD_CMD
"COPY_TO_CLIPBOARD_DELIMITED_TAB"     K_COPY_TO_CLIPBOARD_DELIMITED_TAB
"NOCOPY_TO_CLIPBOARD_DELIMITED_TAB"     K_NOCOPY_TO_CLIPBOARD_DELIMITED_TAB
"IGNORECASE"     K_IGNORECASE
"NOIGNORECASE"     K_NOIGNORECASE
"TM_GMTOFF"     K_TM_GMTOFF
"NEWLINE_ACTION"     K_NEWLINE_ACTION
//"ERROR"     K_ERROR
//"INVALID"     K_INVALID
"FIXED"     K_FIXED
"SUM"     K_SUM
"PROD"     K_PROD
"AVG"     K_AVG
"STDDEV"     K_STDDEV
"COUNT"     K_COUNT
"ROWS"     K_ROWS
"COLS"     K_COLS
"ABS"     K_ABS
"FROW"     K_FROW
"FCOL"     K_FCOL
"ACOS"     K_ACOS
"ASIN"     K_ASIN
"ATAN"     K_ATAN
"ATAN2"     K_ATAN2
"CEIL"     K_CEIL
"COS"     K_COS
"EXP"     K_EXP
"FABS"     K_FABS
"FLOOR"     K_FLOOR
"HYPOT"     K_HYPOT
"LN"     K_LN
"LOG"     K_LOG
"PI"     K_PI
"POW"     K_POW
"SIN"     K_SIN
"SQRT"     K_SQRT
"TAN"     K_TAN
"DTR"     K_DTR
"RTD"     K_RTD
"MAX"     K_MAX
"MIN"     K_MIN
"RND"     K_RND
"ROUND"     K_ROUND
"IF"     K_IF
"PV"     K_PV
"FV"     K_FV
"PMT"     K_PMT
"HOUR"     K_HOUR
"MINUTE"     K_MINUTE
"SECOND"     K_SECOND
"MONTH"     K_MONTH
"DAY"     K_DAY
"YEAR"     K_YEAR
"NOW"     K_NOW
"DATE"     K_DATE
"DTS"     K_DTS
"TTS"     K_TTS
"KFMT"     K_FMT
"REPLACE"     K_REPLACE
"SUBSTR"     K_SUBSTR
"UPPER"     K_UPPER
"LOWER"     K_LOWER
"CAPITAL"     K_CAPITAL
"STON"     K_STON
"SLEN"     K_SLEN
"EQS"     K_EQS
"EXT"     K_EXT
"LUA"     K_LUA
"NVAL"     K_NVAL
"SVAL"     K_SVAL
"LOOKUP"     K_LOOKUP
"HLOOKUP"     K_HLOOKUP
"VLOOKUP"     K_VLOOKUP
"INDEX"     K_INDEX
"STINDEX"     K_STINDEX
//"TBLSTYLE"     K_TBLSTYLE
//"TBL"     K_TBL
//"LATEX"     K_LATEX
//"SLATEX"     K_SLATEX
//"TEX"     K_TEX
//"FRAME"     K_FRAME
//"RNDTOEVEN"     K_RNDTOEVEN
"FILENAME"     K_FILENAME
"MYROW"     K_MYROW
"MYCOL"     K_MYCOL
"LASTROW"     K_LASTROW
"LASTCOL"     K_LASTCOL
"COLTOA"     K_COLTOA
//"CRACTION"     K_CRACTION
//"CRROW"     K_CRROW
//"CRCOL"     K_CRCOL
//"ROWLIMIT"     K_ROWLIMIT
//"COLLIMIT"     K_COLLIMIT
//"PAGESIZE"     K_PAGESIZE
"ERR"     K_ERR
"REF"     K_REF
//"LOCALE"     K_LOCALE
"SET8BIT"     K_SET8BIT
"ASCII"     K_ASCII
"CHR"     K_CHR

SHOW 	S_SHOW
HIDE 	S_HIDE
SHOWROW 	S_SHOWROW
HIDEROW 	S_HIDEROW
SHOWCOL 	S_SHOWCOL
HIDECOL 	S_HIDECOL
FREEZE 	S_FREEZE
UNFREEZE 	S_UNFREEZE
MARK 	S_MARK
AUTOFIT 	S_AUTOFIT
PAD 	S_PAD
DELETECOL 	S_DELETECOL
DATEFMT 	S_DATEFMT
SUBTOTAL 	S_SUBTOTAL
RSUBTOTAL 	S_RSUBTOTAL
FORMAT 	S_FORMAT
FMT 	S_FMT
LET 	S_LET
LABEL 	S_LABEL
LEFTSTRING 	S_LEFTSTRING
RIGHTSTRING 	S_RIGHTSTRING
LEFTJUSTIFY 	S_LEFTJUSTIFY
RIGHTJUSTIFY 	S_RIGHTJUSTIFY
CENTER 	S_CENTER
SORT 	S_SORT
FILTERON 	S_FILTERON
GOTO 	S_GOTO
GOTOB 	S_GOTOB
CCOPY 	S_CCOPY
CPASTE 	S_CPASTE
PLOT 	S_PLOT
LOCK 	S_LOCK
UNLOCK 	S_UNLOCK
DEFINE 	S_DEFINE
UNDEFINE 	S_UNDEFINE
DETAIL 	S_DETAIL
EVAL 	S_EVAL
SEVAL 	S_SEVAL
ERROR 	S_ERROR
FILL 	S_FILL
STRTONUM 	S_STRTONUM
DELETEROW 	S_DELETEROW
VALUEIZEALL 	S_VALUEIZEALL
SHIFT 	S_SHIFT
GETNUM 	S_GETNUM
YANKAREA 	S_YANKAREA
PASTEYANKED 	S_PASTEYANKED
GETSTRING 	S_GETSTRING
GETEXP 	S_GETEXP
GETFMT 	S_GETFMT
GETFORMAT 	S_GETFORMAT
RECALC 	S_RECALC
EXECUTE 	S_EXECUTE
QUIT 	S_QUIT
EXPORT 	S_EXPORT
REBUILD_GRAPH 	S_REBUILD_GRAPH
PRINT_GRAPH 	S_PRINT_GRAPH
SYNCREFS 	S_SYNCREFS
REDO 	S_REDO
UNDO 	S_UNDO
IMAP 	S_IMAP
CMAP 	S_CMAP
NEWSHEET 	S_NEWSHEET
NEXTSHEET 	S_NEXTSHEET
PREVSHEET 	S_PREVSHEET
DELSHEET 	S_DELSHEET
MOVETOSHEET 	S_MOVETOSHEET
RENAMESHEET 	S_RENAMESHEET
NMAP 	S_NMAP
VMAP 	S_VMAP
INOREMAP 	S_INOREMAP
CNOREMAP 	S_CNOREMAP
NNOREMAP 	S_NNOREMAP
VNOREMAP 	S_VNOREMAP
NUNMAP 	S_NUNMAP
IUNMAP 	S_IUNMAP
CUNMAP 	S_CUNMAP
VUNMAP 	S_VUNMAP
COLOR 	S_COLOR
CELLCOLOR 	S_CELLCOLOR
UNFORMAT 	S_UNFORMAT
REDEFINE_COLOR 	S_REDEFINE_COLOR
DEFINE_COLOR 	S_DEFINE_COLOR
SET 	S_SET
FCOPY 	S_FCOPY
FSUM 	S_FSUM
TRIGGER 	S_TRIGGER
UNTRIGGER 	S_UNTRIGGER
OFFSCR_SC_COLS 	S_OFFSCR_SC_COLS
OFFSCR_SC_ROWS 	S_OFFSCR_SC_ROWS
NB_FROZEN_ROWS 	S_NB_FROZEN_ROWS
NB_FROZEN_COLS 	S_NB_FROZEN_COLS
NB_FROZEN_SCREENROWS 	S_NB_FROZEN_SCREENROWS
NB_FROZEN_SCREENCOLS 	S_NB_FROZEN_SCREENCOLS
K_EXEC_LUA 	K_EXEC_LUA
K_NOEXEC_LUA 	K_NOEXEC_LUA
K_INPUT_BAR_BOTTOM 	K_INPUT_BAR_BOTTOM
K_IGNORE_HIDDEN 	K_IGNORE_HIDDEN
K_NOIGNORE_HIDDEN 	K_NOIGNORE_HIDDEN
K_INPUT_EDIT_MODE 	K_INPUT_EDIT_MODE
K_UNDERLINE_GRID 	K_UNDERLINE_GRID
K_TRUNCATE 	K_TRUNCATE
K_NOTRUNCATE 	K_NOTRUNCATE
K_AUTOWRAP 	K_AUTOWRAP
K_NOAUTOWRAP 	K_NOAUTOWRAP
K_QUIET 	K_QUIET
K_NOQUIET 	K_NOQUIET
K_DEFAULT_OPEN_FILE_UNDER_CURSOR_CMD 	K_DEFAULT_OPEN_FILE_UNDER_CURSOR_CMD
K_IMPORT_DELIMITED_TO_TEXT 	K_IMPORT_DELIMITED_TO_TEXT
K_COMMAND_TIMEOUT 	K_COMMAND_TIMEOUT
K_MAPPING_TIMEOUT 	K_MAPPING_TIMEOUT
K_SHOW_CURSOR 	K_SHOW_CURSOR
K_NOSHOW_CURSOR 	K_NOSHOW_CURSOR
K_EVALUATE 	K_EVALUATE
K_SEVALUATE 	K_SEVALUATE
K_GETENT 	K_GETENT
K_FACT 	K_FACT

";" 	';'
"?" 	'?'
":" 	':'
"|" 	'|'
"&" 	'&'
"<" 	'<'
"=" 	'='
">" 	'>'
"!" 	'!'
"+" 	'+'
"-" 	'-'
"#" 	'#'
"*" 	'*'
"/" 	'/'
"%" 	'%'
"^" 	'^'
"{" 	'{'
"}" 	'}'
"@" 	'@'
"(" 	'('
")" 	')'
"," 	','
"." 	'.'
"~" 	'~'
"$" 	'$'

\"("\\".|[^"\n\r\\])*\" 	STRING
[A-Za-z]{1,2} 	COL
[0-9]+ 	NUMBER
[0-9]+"."[0-9]+ 	FNUMBER
xRANGEx 	RANGE
xVARx 	VAR
[A-Za-z_][A-Za-z_]+ 	WORD


%%
