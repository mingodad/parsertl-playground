#!/bin/sh

umask 022

myflags="-O2"
#myflags="-g4 -fsanitize=address -fsanitize=undefined"


g++  \
	-std=c++17 $myflags -Wall -Wno-unused-function -pedantic \
	-I.. \
	 playground.cpp \
	-DPARSERTL_WITH_BITSET \
	-DPARSERTL_WITH_BOOLSETx \
	-DPARSERTL_WITH_BUILD_TABLE_INDEX \
	-o parsertl-playground

