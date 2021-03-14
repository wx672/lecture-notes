#!/bin/bash

for f in $(find . -executable -type f | grep -v $0); do echo -n "$f: "; strace -c $f 2>&1 | tail -1; done | awk '{print $1,$5}' | sort -nk2
