#!/bin/bash

dialog --title "Loyalty check" \
    --backtitle "Linux Shell Script Tutorial Example" \
    --yesno "Are you sure you want to permanently erase Windows from your PC?" 7 60

# Get exit status
# 0 means user hit [yes] button.
# 1 means user hit [no] button.
# 255 means user hit [Esc] key.
response=$?
case $response in
    0) toilet --gay --font future "Good! You can pass your Linux exam.";;
    1) figlet "You died.";;
    255) echo "[ESC] key pressed.";;
esac
