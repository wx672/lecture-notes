#!/bin/bash
for (( i=5; i>0; i--)); do
    printf "\rFire starting in $i seconds..."
    read -t 1 #sleep 1
done

[ -x /usr/bin/aafire ] && /usr/bin/aafire
#/usr/bin/aafiree
