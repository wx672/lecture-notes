#!/bin/bash

for f in $(fd --no-ignore --type executable --exclude howmany.sh); do echo -n "$f: "; strace -c ./$f 2>&1 | tail -1; done | awk '{print $1,$5}' | sort -nk2
