#!/bin/bash

set -euC

cd /tmp

tmux rename-window "UDP demo"
tmux split-window -v
tmux split-window -v

tmux select-pane -t 0
tmux resize-pane -U 30

tmux send-keys C-l "nc -4ul 3333" 

tmux split-window -h

tmux select-pane -t 1
tmux send-keys C-l "nc -4u localhost 3333"

tmux select-pane -t 2
tmux resize-pane -U 8
tmux send-keys C-l "watch -t -n.1 'ss -4anu \"( sport == 3333 or dport == 3333 )\"'" C-m

tmux select-pane -t 3
tmux send-keys C-l "sudo tcpdump -ilo -nnvvvxXK -s0 udp port 3333" C-m
#tmux send-keys C-l "sudo tshark -ilo -f \"port 3333\"" C-m

# Local Variables:
# Ref: https://www.arp242.net/tmux.html
# End:
