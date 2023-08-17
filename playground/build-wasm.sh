#!/bin/sh

umask 022

#myflags="-flto -O2 -s TOTAL_STACK=8MB"
myflags="-O2 -s TOTAL_STACK=8MB"
#myflags="-flto -O2 -s TOTAL_STACK=128MB -s INITIAL_MEMORY=256MB"
#myflags="-g4 -fsanitize=address -fsanitize=undefined"

main_func="_main_playground"
main_cpp="playground.cpp"
output_fn="parsertl_playground.js"

emsdk-env em++  \
	-std=c++17 $myflags -Wall -Wno-unused-function -pedantic \
	-s EXPORTED_FUNCTIONS=$main_func  -s EXPORTED_RUNTIME_METHODS=ccall,cwrap \
	-s ALLOW_MEMORY_GROWTH=1 -s NO_DISABLE_EXCEPTION_CATCHING \
	-I.. \
	$main_cpp \
	-DWASM_PLAYGROUND \
	-DPARSERTL_WITH_BITSETx \
	-DPARSERTL_WITH_BUILD_TABLE_INDEX \
	-o $output_fn

# --pre-js chpeg-pre.js \
# -g2 -gsource-map --source-map-base='./'
