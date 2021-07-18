#!/bin/bash

set -euC

tmux rename-window "UDP demo"

#    Window setup
# +--------+--------+
# | server | client |
# +--------+--------+
# |     tcpdump     |
# +-----------------+
#
tmux split-window -h
tmux split-window -fl99

tmux send-keys -t{top-left}  "python2 udpServer.py" 
tmux send-keys -t{top-right} "python2 udpClient.py"

tmux send-keys "sudo tcpdump -ilo -vvvnnxXK port 12000" C-m
#tmux send-keys "sudo tshark -ilo -f \"port 12000\"" C-m
