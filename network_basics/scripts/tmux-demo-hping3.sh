#!/bin/bash

set -euC

# hping3 will send a RST upon receiving a SYN+ACK from the server.
# To keep the server stay in syn-recv state we have to filter out RST packets.
# remember to delete this rule upon finish this work
sudo iptables -A OUTPUT -p tcp -m tcp --tcp-flags RST RST -j DROP

tmux new-window -n "TCP SYN-flood demo" 

#    Window setup
# +------------------+
# | hping3 | server  |
# +------------------+
# |      watch       |
# +------------------+
# |     tcpdump      |
# +------------------+
#
tmux split-window -hl
tmux split-window -vfl75%
tmux split-window -vl12

# -S: set SYN bit
# -i: interval
tmux send-keys -t{top-left} "sudo hping3 -S -i 2 -p 3333 -I lo 127.0.0.1"
#tmux send-keys -t{top-left} "sudo hping3 --flood -S -I lo -p 80 127.0.0.1"

# have to start a http server first. nc doesn't response to multiple clients.
tmux send-keys -t{top-right} "sudo python3 -m http.server 3333"

tmux send-keys -t{up-of} "watch -tn.1 'ss -4anto state syn-recv'" C-m

tmux send-keys "sudo tcpdump -ilo port 3333" C-m
#tmux send-keys C-l "sudo tshark -ilo -f \"port 3333\"" C-m

tmux select-pane -t{top}

#trap 'sudo iptables -D OUTPUT -p tcp -m tcp --tcp-flags RST RST -j DROP' INT EXIT TERM ERR
