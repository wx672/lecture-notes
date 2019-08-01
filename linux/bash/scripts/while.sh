#!/bin/bash
x=0 
while [ $x -lt 10 ]        #  [ ]
do 
    y=$x 
    while [[ $y -ge 0 ]]   #  [[ ]]
    do 
	echo -n $y         # no newline
	y=$((y-1))         # y--
    done 
    echo 
    x=`echo "$x + 1" | bc` # x++
done 
