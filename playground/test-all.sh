#!/bin/sh
for fn in *.g
do
	#echo "== Now testing $fn"
	echo "$fn:1:1:"
	/usr/bin/time ./parsertl-playground $fn test.empty
done
