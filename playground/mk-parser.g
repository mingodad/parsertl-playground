//From: https://gitlab.gnome.org/Archive/anjuta/-/blob/master/plugins/mk-project/mk-parser.y?ref_type=heads
/*
 * mk-parser.y
 * Copyright (C) Sébastien Granjoux 2009 <seb.sfo@free.fr>
 *
 * main.c is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * main.c is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*Tokens*/
%token EOL
%token SPACE
%token TAB
%token HASH
//%token MACRO
%token VARIABLE
%token COMMA
%token COLON
%token DOUBLE_COLON
%token ORDER
%token SEMI_COLON
%token EQUAL
%token IMMEDIATE_EQUAL
%token CONDITIONAL_EQUAL
%token APPEND
%token CHARACTER
%token NAME
//%token MK_VARIABLE
%token _PHONY
%token _SUFFIXES
%token _DEFAULT
%token _PRECIOUS
%token _INTERMEDIATE
%token _SECONDARY
%token _SECONDEXPANSION
%token _DELETE_ON_ERROR
%token _IGNORE
%token _LOW_RESOLUTION_TIME
%token _SILENT
%token _EXPORT_ALL_VARIABLES
%token _NOTPARALLEL
%token	IFEQ
%token	ELSE
%token	ENDIF

%start file

%%

file :
	statement
	| file statement
	;

statement :
	end_of_line
	| space end_of_line
	| definition end_of_line
	| conditional end_of_line
	| rule command_list
	;

definition :
	head_list equal_group value
	| head_list equal_group
	;

rule :
	depend_list end_of_line
	| depend_list SEMI_COLON command_line EOL
	;

depend_list :
	head_list rule_token prerequisite_list
	;

command_list :
	/*empty*/
	| command_list TAB command_line EOL
	;

conditional:
	IFEQ value
	| ELSE
	| ENDIF
	;

/* Lists
 *----------------------------------------------------------------------------*/

end_of_line :
	EOL
	| comment
	;

comment :
	HASH not_eol_list EOL
	;

not_eol_list :
	/*empty*/
	| not_eol_list not_eol_token
	;

prerequisite_list :
	/*empty*/
	| space
	| optional_space prerequisite_list_body optional_space
	;

prerequisite_list_body :
	prerequisite
	| prerequisite_list_body space prerequisite
	;

head_list :
	optional_space head_list_body optional_space
	;

head_list_body :
	head
	| head_list_body space head
	;

command_line :
	/*empty*/
	| command_line command_token
	;

/* Items
 *----------------------------------------------------------------------------*/

optional_space :
	/*empty*/
	| space
	;

space :
	space_token
	| space space_token
	;

head :
	head_elm
	| head head_elm
	;

head_elm :
	head_token
	| variable_token
	;

value :
	value_token
	| space_token
	| value value_token
	| value space_token
	;

prerequisite :
	name_prerequisite
	;

name_prerequisite :
	prerequisite_token
	| name_prerequisite prerequisite_token
	;

equal_group :
	EQUAL
	| IMMEDIATE_EQUAL
	| CONDITIONAL_EQUAL
	| APPEND
	;

/* Tokens
 *----------------------------------------------------------------------------*/

not_eol_token :
	word_token
	| space_token
	;

prerequisite_token :
	name_token
	| equal_token
	| rule_token
	| variable_token
	;

command_token :
	name_token
	| variable_token
	| equal_token
	| rule_token
	| depend_token
	| space_token
	;

value_token :
	name_token
	| variable_token
	| equal_token
	| rule_token
	| depend_token
	;

head_token :
	name_token
	| depend_token
	;

variable_token :
	VARIABLE
	;

name_token :
	NAME
	| CHARACTER
	| COMMA
	| ORDER
	| _PHONY
	| _SUFFIXES
	| _DEFAULT
	| _PRECIOUS
	| _INTERMEDIATE
	| _SECONDARY
	| _SECONDEXPANSION
	| _DELETE_ON_ERROR
	| _IGNORE
	| _LOW_RESOLUTION_TIME
	| _SILENT
	| _EXPORT_ALL_VARIABLES
	| _NOTPARALLEL
	;

rule_token :
	COLON
	| DOUBLE_COLON
	;

depend_token :
	SEMI_COLON
	;

word_token :
	VARIABLE
	| NAME
	| CHARACTER
	| ORDER
	| HASH
	| COMMA
	| COLON
	| DOUBLE_COLON
	| SEMI_COLON
	| EQUAL
	| IMMEDIATE_EQUAL
	| CONDITIONAL_EQUAL
	| APPEND
	| _PHONY
	| _SUFFIXES
	| _DEFAULT
	| _PRECIOUS
	| _INTERMEDIATE
	| _SECONDARY
	| _SECONDEXPANSION
	| _DELETE_ON_ERROR
	| _IGNORE
	| _LOW_RESOLUTION_TIME
	| _SILENT
	| _EXPORT_ALL_VARIABLES
	| _NOTPARALLEL
	| IFEQ
	| ELSE
	| ENDIF
	;

space_token :
	SPACE
	| TAB
	;

equal_token :
	EQUAL
	| IMMEDIATE_EQUAL
	| CONDITIONAL_EQUAL
	| APPEND
	;

%%

NAME          [^ \t\n\r:#=$"'`&@\\]+

%%

\n	EOL


([ ]|\\\n)([ \t]|\\\n)*	SPACE

#	HASH

\t	TAB

\$\([^ \t\n\r:#=$)]+\)	VARIABLE

\$\{[^ \t\n\r:#=$}]+\}	VARIABLE

\$[^ \t\n\r\(\{]	VARIABLE

,	COMMA

:	COLON

::	DOUBLE_COLON

;	SEMI_COLON

\|	ORDER

\=	EQUAL

:=	IMMEDIATE_EQUAL

\?=	CONDITIONAL_EQUAL

\+=	APPEND

\\[ ]	CHARACTER

\\:	CHARACTER

\\=	CHARACTER

\\#	CHARACTER

".PHONY"	_PHONY

".SUFFIXES"	_SUFFIXES

".DEFAULT"	_DEFAULT

".PRECIOUS"	_PRECIOUS

".INTERMEDIATE"	_INTERMEDIATE

".SECONDARY"	_SECONDARY

".SECONDEXPANSION"	_SECONDEXPANSION

".DELETE_ON_ERROR"	_DELETE_ON_ERROR

".IGNORE"	_IGNORE

".LOW_RESOLUTION_TIME"	_LOW_RESOLUTION_TIME

".SILENT"	_SILENT

".EXPORT_ALL_VARIABLES"	_EXPORT_ALL_VARIABLES

".NOTPARALLEL"	_NOTPARALLEL

ifeq	IFEQ

else	ELSE

endif	ENDIF

{NAME}	NAME

.	CHARACTER

//<<EOF>>                     { if (mkp_scanner_parse_end (yyextra) == YY_NULL) return YY_NULL; }


%%
