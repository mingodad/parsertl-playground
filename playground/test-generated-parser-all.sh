#!/bin/sh
tmpofn=/tmp/test-parser
tmpfn=$tmpofn.cpp
for fn in *.g
do
	echo "== Now testing $fn"
	./parsertl-playground -generateParser $fn test.empty > $tmpfn \
		&& g++ $tmpfn -o $tmpofn && $tmpofn $PWD/test.empty
done
