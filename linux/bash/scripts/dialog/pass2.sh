#!/bin/bash

PASS="hogwarts"

read -s -p "Password: " mypass
echo
[ "$mypass" != "$PASS" ] && figlet "Wrong password! Access dined!" && exit 1

for ((i=5;i>0;i--)); do
	printf "\rWelcome aboard! The Hogwarts Express is departing in $i seconds..." 
	sleep 1
done

[ -x /usr/games/sl ] && /usr/games/sl
