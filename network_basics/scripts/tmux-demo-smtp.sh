#!/bin/bash

set -euC

cd /tmp

tmux rename-window "SMTP demo"

#    Window setup
# +-----------+
# | nc cs6 25 |
# +-----------+
# |   watch   |
# +-----------+
# |  tcpdump  |
# +-----------+
#
tmux split-window -v
# tmux split-window -vfl75%
# tmux split-window -vl12

# tmux send-keys -t{top} "nc localhost smtp"
tmux send-keys -t{top} "nc cs6 smtp"
# tmux send-keys -t{up-of} "watch -tn.1 'ss dst :smtp'" C-m
tmux send-keys "sudo tcpdump -i wlp1s0 -nnvvvSKXx -s0 port smtp" C-m
# tmux send-keys "sudo tcpdump -ilo port smtp" C-m

tmux select-pane -t{top}
#tmux send-keys C-l "sudo tshark -ilo -f \"port 3333\"" C-m

# Ref: https://www.arp242.net/tmux.html
