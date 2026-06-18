#!/bin/bash
# arglist.sh
# Invoke this script with several arguments, such as "one two three".

echo '##########################################################'
index=1     # Initialize count.

echo '$*' sees all arguments as a single word. 
echo "Listing args with \"\$*\":"

for arg in "$*"  # Doesn't work properly if "$*" isn't quoted.
do
    echo "Arg #$index = $arg"
    let "index+=1"
done

echo "Entire arg list seen as single word."
echo
echo '$@' is $@
echo '$*' is $*
echo

echo '##########################################################'
index=1     # Reset count.
            # What happens if you forget to do this?

echo '$@' sees arguments as separate words. 
echo "Listing args with \"\$@\":"

for arg in "$@"
do
    echo "Arg #$index = $arg"
    let "index+=1"
done
echo "Arg list seen as separate words."
echo '$@' is $@
echo '$*' is $*
echo

echo '##########################################################'
index=1     # Reset count.
            # What happens if you forget to do this?

echo "Listing args with \"\$@\" (unquoted) --- for arg :"
for arg in $@
do
    echo "Arg #$index = $arg"
    let "index+=1"
done
echo "Arg list seen as ???"
echo '$@' is $@
echo '$*' is $*
echo

echo '##########################################################'
index=1     # Reset count.

echo 'Unquoted $* sees arguments as separate words.'
echo "Listing args with \$* (unquoted):"
for arg in $*
do
    echo "Arg #$index = $arg"
    let "index+=1"
done        
echo "Arg list seen as separate words."
echo '$@' is $@
echo '$*' is $*
exit 0
