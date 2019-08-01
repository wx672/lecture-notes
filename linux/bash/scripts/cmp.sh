#!/bin/bash
# This is a simple string comparision script.
#
# 1. Use '[[' instead of '[' whenever possible.
# 2. Don't use '[  ]' with '<', '>'.
# 3. '-eq -le -ge -lt -gt' are for arithmetic comparisons
# 4. '< >' for string comparisons
#
if [ -z "$2" ]; then
    echo Usage: $0 '<string1> <string2>'
elif [[ "$1" > "$2" ]]; then
    echo $1 is bigger than $2.
elif [[ "$1" = "$2" ]]; then
    echo $1 is equal to $2.
else
    echo $1 is smaller than $2.
fi
