#!/bin/bash

set -euC

tmux rename-window "UDP demo"
tmux split-window -v 

tmux select-pane -t 0
tmux resize-pane -U 30

tmux send-keys C-l "python2 udpServer.py" 

tmux split-window -h

tmux select-pane -t 1
tmux send-keys C-l "python2 udpClient.py"

tmux select-pane -t 2
tmux send-keys C-l "sudo tcpdump -ilo -nn -vvv -xXK port 12000" C-m
#tmux send-keys C-l "sudo tshark -ilo -f \"port 12000\"" C-m

# Local Variables:
# Ref: https://www.arp242.net/tmux.html
# End:
