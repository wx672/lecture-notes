#!/bin/bash

set -euC

cd /tmp

tmux rename-window "UDP demo"

#    Window setup
# +---------+---------+
# | nc -4ul | nc -4u  |
# +---------+---------+
# |       watch       |
# +-------------------+
# |      tcpdump      |
# +-------------------+
#
tmux split-window -h
tmux split-window -vfl99
tmux split-window -vl12

tmux send-keys -t{top-left}  "nc -4ul 3333" 
tmux send-keys -t{top-right} "nc -4u localhost 3333"
tmux send-keys -t{up-of} \
	 "watch -t -n.1 'ss -4anu \"( sport == 3333 or dport == 3333 )\"'" C-m
tmux send-keys "sudo tcpdump -ilo -nnvvvxXK -s0 udp port 3333" C-m
#tmux send-keys C-l "sudo tshark -ilo -f \"port 3333\"" C-m

tmux select-pane -t{top-left}

# Ref: https://www.arp242.net/tmux.html
