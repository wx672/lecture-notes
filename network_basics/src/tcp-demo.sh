#!/bin/bash

set -euC

tmux rename-window "TCP demo"
tmux split-window -v 
tmux split-window -v 

tmux select-pane -t 0
tmux resize-pane -U 30

tmux send-keys C-l "python2 tcpServer.py" 

tmux split-window -h

tmux select-pane -t 1
tmux send-keys C-l "python2 tcpClient.py"

tmux select-pane -t 2
tmux resize-pane -U 8
tmux send-keys C-l "watch -t -n.1 'ss -4ant \"( sport == 12000 or dport == 12000 )\"'" C-m

tmux select-pane -t 3
tmux send-keys C-l "sudo tcpdump -ilo -vvv -nn -xXSK -s0 port 12000" C-m
#tmux send-keys C-l "sudo tshark -ilo -f \"port 12000\"" C-m

# Local Variables:
# Ref: https://www.arp242.net/tmux.html
# End:
