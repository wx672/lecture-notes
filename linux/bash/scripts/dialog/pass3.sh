#!/bin/bash

PASS="linux"
# password storage
data=$(tempfile 2>/dev/null)

# trap it
trap "rm -f $data" 0 1 2 5 15

dialog --title "Password" \
    --clear \
    --insecure \
    --passwordbox "Enter your password" 10 30 2> $data

[ "`cat $data`" != "$PASS" ] && dialog --title "Wrong!" --clear --msgbox "Wrong password!" 8 30 && exit 1

[ -x /usr/games/sl ] && /usr/games/sl
