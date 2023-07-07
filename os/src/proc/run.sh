#!/bin/sh
$(grep gcc.*a.out $1 | cut -d\" -f2) && /tmp/a.out
