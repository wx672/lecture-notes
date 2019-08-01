#!/bin/bash
printf "Play a game?" 
read YN 
case $YN in 
  [yY]|[yY][eE][sS]) exec bb ;; 
		  *) echo "Maybe later." ;; 
esac 
