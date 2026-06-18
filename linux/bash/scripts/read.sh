#!/bin/bash
while read LINE
do
    case $LINE in  
        *root*) echo $LINE ;;
	*stud*) echo $LINE ;;
	*) echo "I don't care." ;;
    esac 
done < /etc/passwd 
