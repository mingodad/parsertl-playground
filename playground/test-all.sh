#!/bin/sh
for fn in *.g
do
	echo "== Now testing $fn"
	/usr/bin/time ./parsertl-playground $fn test.empty
done
