#!/bin/bash

set -euC

tmux rename-window "TCP demo"

#    Window setup
# +--------+--------+
# | server | client |
# +--------+--------+
# |      watch      |
# +-----------------+
# |     tcpdump     |
# +-----------------+
#
tmux split-window -h
tmux split-window -fl99
tmux split-window -l12

tmux send-keys -t{top-left} "python2 tcpServer.py" 

tmux send-keys -t{top-right} "python2 tcpClient.py"

tmux send-keys -t{up-of} "watch -tn.1 'ss -ant \"( sport == 12000 or dport == 12000 )\"'" C-m

tmux send-keys "sudo tcpdump -ilo -vvvnnxXSK -s0 port 12000" C-m
#tmux send-keys C-l "sudo tshark -ilo -f \"port 12000\"" C-m

