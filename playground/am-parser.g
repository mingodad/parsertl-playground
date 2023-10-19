/*
 * am-parser.y
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
//%token END_OF_FILE
%token END_OF_LINE
%token SPACE
%token TAB
%token COMMENT
%token MACRO
%token VARIABLE
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
//%token AM_VARIABLE
%token INCLUDE
%token SUBDIRS
%token DIST_SUBDIRS
%token _DATA
%token _HEADERS
%token _LIBRARIES
%token _LISP
%token _LTLIBRARIES
%token _MANS
%token _PROGRAMS
%token _PYTHON
%token _JAVA
%token _SCRIPTS
%token _SOURCES
%token _TEXINFOS
%token _DIR
%token _LDFLAGS
%token _CPPFLAGS
%token _CFLAGS
%token _CXXFLAGS
%token _JAVACFLAGS
%token _VALAFLAGS
%token _FCFLAGS
%token _OBJCFLAGS
%token _LFLAGS
%token _YFLAGS
%token TARGET_LDFLAGS
%token TARGET_CPPFLAGS
%token TARGET_CFLAGS
%token TARGET_CXXFLAGS
%token TARGET_JAVACFLAGS
%token TARGET_VALAFLAGS
%token TARGET_FCFLAGS
%token TARGET_OBJCFLAGS
%token TARGET_LFLAGS
%token TARGET_YFLAGS
%token TARGET_DEPENDENCIES
%token TARGET_LIBADD
%token TARGET_LDADD


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
	| am_variable end_of_line
	| include end_of_line
	| line end_of_line
	| rule command_list
	;

am_variable :
	optional_space automake_head optional_space equal_token value_list
	| optional_space automake_head optional_space equal_token
	;

include :
	optional_space include_token value_list
	;

definition :
	head_list equal_token value_list
	| head_list equal_token
	;

rule :
	depend_list end_of_line
	| depend_list SEMI_COLON command_line END_OF_LINE
	//| depend_list SEMI_COLON command_line END_OF_FILE
	;

depend_list :
	head_list rule_token prerequisite_list
	;

command_list :
	/*empty*/
	| command_list TAB command_line END_OF_LINE
	//| command_list TAB command_line END_OF_FILE
	;

line :
	head_list
	;

end_of_line :
	END_OF_LINE
	//| END_OF_FILE
	| COMMENT
	;

//not_eol_list :
//	/*empty*/
//	| not_eol_list not_eol_token
//	;

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
	| head_list_body space next_head
	| automake_head space next_head
	;

value_list :
	space
	| optional_space value_list_body optional_space
	;

value_list_body :
	value
	| value_list_body space value
	;

command_line :
	/*empty*/
	| command_line command_token
	;

optional_space :
	/*empty*/
	| space
	;

space :
	space_token
	| space space_token
	;

automake_head :
	automake_token
	| target_automake_token
	| head target_automake_token
	| automake_head target_automake_token
	;

head :
	head_token
	| ac_variable
	| variable
	| head head_token
	| head automake_token
	| head include_token
	| head variable
	| head ac_variable
	| automake_head head_token
	| automake_head automake_token
	| automake_head include_token
	| automake_head variable
	| automake_head ac_variable
	;

next_head :
	head_token
	| ac_variable
	| variable
	| automake_token
	| target_automake_token
	| include_token
	| next_head head_token
	| next_head automake_token
	| next_head include_token
	| next_head variable
	| next_head ac_variable
	;

value :
	value_token
	| variable
	| ac_variable
	| value value_token
	| value variable
	| value ac_variable
	;

prerequisite :
	name_prerequisite
	;

name_prerequisite :
	prerequisite_token
	| variable
	| ac_variable
	| name_prerequisite prerequisite_token
	| name_prerequisite variable
	| name_prerequisite ac_variable
	;

variable :
	VARIABLE
	;

ac_variable :
	MACRO
	;

//not_eol_token :
//	word_token
//	| space_token
//	;

prerequisite_token :
	name_token
	| automake_token
	| target_automake_token
	| equal_token
	| rule_token
	;

command_token :
	name_token
	| variable_token
	| automake_token
	| target_automake_token
	| equal_token
	| rule_token
	| depend_token
	| include_token
	| space_token
	| comment_token
	;

value_token :
	name_token
	| equal_token
	| rule_token
	| depend_token
	| include_token
	| automake_token
	| target_automake_token
	;

head_token :
	name_token
	| depend_token
	;

space_token :
	SPACE
	| TAB
	;

comment_token :
	COMMENT
	;

equal_token :
	EQUAL
	| IMMEDIATE_EQUAL
	| CONDITIONAL_EQUAL
	| APPEND
	;

rule_token :
	COLON
	| DOUBLE_COLON
	;

depend_token :
	SEMI_COLON
	;

//word_token :
//	name_token
//	| equal_token
//	| rule_token
//	| depend_token
//	;

name_token :
	NAME
	| CHARACTER
	| ORDER
	;

variable_token :
	VARIABLE
	| MACRO
	;

automake_token :
	SUBDIRS
	| DIST_SUBDIRS
	| _LDFLAGS
	| _CPPFLAGS
	| _CFLAGS
	| _CXXFLAGS
	| _JAVACFLAGS
	| _VALAFLAGS
	| _FCFLAGS
	| _OBJCFLAGS
	| _LFLAGS
	| _YFLAGS
	;

target_automake_token :
	_DATA
	| _HEADERS
	| _LIBRARIES
	| _LISP
	| _LTLIBRARIES
	| _MANS
	| _PROGRAMS
	| _PYTHON
	| _JAVA
	| _SCRIPTS
	| _SOURCES
	| _TEXINFOS
	| _DIR
	| TARGET_LDFLAGS
	| TARGET_CPPFLAGS
	| TARGET_CFLAGS
	| TARGET_CXXFLAGS
	| TARGET_JAVACFLAGS
	| TARGET_VALAFLAGS
	| TARGET_FCFLAGS
	| TARGET_OBJCFLAGS
	| TARGET_LFLAGS
	| TARGET_YFLAGS
	| TARGET_DEPENDENCIES
	| TARGET_LIBADD
	| TARGET_LDADD
	;

include_token :
	INCLUDE
	;

%%

NAME          [^ \t\n\r:#=$"'`&@\\]+

%%

//<<EOF>>					{ gint ret = amp_am_scanner_parse_end (yyextra); if (ret !=1) return ret; }

\n	END_OF_LINE

([ ]|\\\n)([ \t]|\\\n)*	SPACE

([ \t])*#.*\n	COMMENT

\t	TAB

@{NAME}@	MACRO

\$\([^)]+\)	VARIABLE

\$\{[^}]+\}	VARIABLE

\$[^ \t\n\r\(\{]	VARIABLE

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

include	INCLUDE

\-include	INCLUDE

SUBDIRS	SUBDIRS

DIST_SUBDIRS	DIST_SUBDIRS

{NAME}_DATA	_DATA

{NAME}_HEADERS	_HEADERS

{NAME}_LIBRARIES	_LIBRARIES

{NAME}_LISP	_LISP

{NAME}_LTLIBRARIES	_LTLIBRARIES

{NAME}_MANS	_MANS

{NAME}_PROGRAMS	_PROGRAMS

{NAME}_PYTHON	_PYTHON

{NAME}_JAVA	_JAVA

{NAME}_SCRIPTS	_SCRIPTS

{NAME}_SOURCES	_SOURCES

{NAME}_TEXINFOS	_TEXINFOS

{NAME}dir	_DIR

AM_LDFLAGS	_LDFLAGS

AM_CPPFLAGS	_CPPFLAGS

AM_CFLAGS	_CFLAGS

AM_CXXFLAGS	_CXXFLAGS

AM_JAVACFLAGS	_JAVACFLAGS

AM_VALAFLAGS	_VALAFLAGS

AM_FCFLAGS	_FCFLAGS

AM_OBJCFLAGS	_OBJCFLAGS

AM_LFLAGS	_LFLAGS

AM_YFLAGS	_YFLAGS

{NAME}_LDFLAGS	TARGET_LDFLAGS

{NAME}_CPPFLAGS	TARGET_CPPFLAGS

{NAME}_CFLAGS	TARGET_CFLAGS

{NAME}_CXXFLAGS	TARGET_CXXFLAGS

{NAME}_JAVACFLAGS	TARGET_JAVACFLAGS

{NAME}_VALAFLAGS	TARGET_VALAFLAGS

{NAME}_FCFLAGS	TARGET_FCFLAGS

{NAME}_OBJCFLAGS	TARGET_OBJCFLAGS

{NAME}_LFLAGS	TARGET_LFLAGS

{NAME}_YFLAGS	TARGET_YFLAGS

{NAME}_DEPENDENCIES	TARGET_DEPENDENCIES

{NAME}_LDADD	TARGET_LDADD

{NAME}_LIBADD	TARGET_LIBADD

{NAME}	NAME

.	CHARACTER

%%
