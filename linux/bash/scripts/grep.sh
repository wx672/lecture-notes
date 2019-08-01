#!/bin/bash
for f in *.sh
do
    if grep -q while $f; then
	echo "$f: while loop found\!"
    else
	echo "$f: no while loop."
    fi
done
