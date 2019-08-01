#!/bin/bash
### demonstrate ARRAY and RANDOM ###

files=($HOME/pics/2009summer/wallpapers/2009summer-1280x768/*.jpg)

# get the length of array ${files[@]}
n=${#files[@]}

# get a random array element
wallpaper="${files[RANDOM % n]}"

# set it as wallpaper
qiv -z $wallpaper
