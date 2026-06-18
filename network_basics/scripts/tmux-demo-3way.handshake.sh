#!/bin/bash

set -euC

cd /tmp

tmux set -w remain-on-exit on

tmux rename-window "TCP 3-way handshake demo"

#    Window setup
# +--------+--------+
# | nc -4l | nc -4  |
# +--------+--------+
# |      watch      |
# +-----------------+
# |     tcpdump     |
# +-----------------+
#
tmux split-window -h
tmux split-window -vfl99
tmux split-window -vl12

tmux send-keys -t{top-left}  "nc -4l 3333"
#tmux send-keys -t{top-left}  "socat - TCP-LISTEN:3333,fork,reuseaddr"

tmux send-keys -t{top-right} "nc -4 localhost 3333"

tmux send-keys -t{up-of} "watch -t -n.1 'ss -4ant \"( sport == 3333 or dport == 3333 )\"'" C-m

tmux send-keys "sudo tcpdump -Silo port 3333" C-m
#tmux send-keys "sudo tcpdump -ilo -nnvvvxXKS -s0 port 3333" C-m
#tmux send-keys "sudo tshark -ilo -f \"port 3333\"" C-m

tmux select-pane -t{top-left}

