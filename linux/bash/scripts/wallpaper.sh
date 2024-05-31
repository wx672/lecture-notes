#!/bin/bash

#"$HOME/Pics/2009Summer/wallpapers/2009summer-1280x768"
IMGDIR="$HOME/.local/share/wallpapers/"

files=($IMGDIR/wallpaper*.webp)

# length of array ${files[@]}
n=${#files[@]}

# random array element
wallpaper="${files[RANDOM % n]}"

# set it as wallpaper
hsetroot -cover $wallpaper
