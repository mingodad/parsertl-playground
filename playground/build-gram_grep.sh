#!/bin/sh

umask 022

myflags="-O2"
#myflags="-g4 -fsanitize=address -fsanitize=undefined"


gcc-14-env g++  \
	-std=c++20 $myflags -Wall -Wno-unused-function -pedantic \
	-I.. \
	 gram_grep.cpp \
	-DPARSERTL_WITH_BITSET \
	-DPARSERTL_WITH_BOOLSETx \
	-DPARSERTL_WITH_BUILD_TABLE_INDEX \
	-o gram_grep

#./gram_grep -vE "\/\/.*|\/\*(?s:.)*?\*\/" -E memory_file gram_grep.cpp
# ./gram_grep -dumpMaster -f gg-nosc.g gram_grep.cpp