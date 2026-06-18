#!/bin/bash
YN=yes 
printf "Play a game?[$YN]" 
read YN 
: ${YN:=yes}
case $YN in 
  [yY]|[yY][eE][sS]) exec bb ;; 
		  *) echo "Maybe later." ;; 
esac 
