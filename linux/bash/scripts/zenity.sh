#!/bin/bash
while NAME=`zenity --entry --text="Your name?"` 
do
    zenity --info --text="Hello, $NAME\!"
done
