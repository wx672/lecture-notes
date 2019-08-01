#!/bin/bash

dialog --title "Loyalty check" \
    --backtitle "Linux Shell Script Tutorial Example" \
    --yesno "Are you sure you want to permanently erase Windows from your PC?" 7 60

# get respose
response=$?

case $response in
    0) dialog --title "Good!" --clear --msgbox "Good! You can pass your Linux exam." 8 41;;
    1) dialog --title "Bad!" --clear --msgbox "You died." 10 30;;
    255) echo "[ESC] key pressed.";;
esac
