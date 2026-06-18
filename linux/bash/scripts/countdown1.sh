#!/bin/bash
for ((i=5; i>0; i--)); do
    printf "\rTrain coming in $i seconds.  Hit any key to continue..."
    read -s -n 1 -t 1
    [ $? -eq 0 ] && break
done
[ -x /usr/games/sl ] && /usr/games/sl
