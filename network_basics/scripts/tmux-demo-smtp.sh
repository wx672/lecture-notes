#!/bin/bash

set -euC

cd /tmp

tmux rename-window "SMTP demo"

#    Window setup
# +-----------+
# | nc -4 cs6 |
# +-----------+
# |   watch   |
# +-----------+
# |  tcpdump  |
# +-----------+
#
tmux split-window -vfl75%
tmux split-window -vl12

tmux send-keys -t{top} "nc -4 localhost smtp"
#tmux send-keys -t{top} "nc -4 cs6 smtp"
tmux send-keys -t{up-of} "watch -tn.1 'ss -4ant dst :smtp or src :25'" C-m
#tmux send-keys -t{up-of} "watch -tn.1 'ss -4ant dst :smtp'" C-m
tmux send-keys "sudo tcpdump -ilo port smtp" C-m
#tmux send-keys "sudo tcpdump -i wlp1s0 port smtp" C-m

tmux select-pane -t{top}
#tmux send-keys C-l "sudo tshark -ilo -f \"port 3333\"" C-m

# Ref: https://www.arp242.net/tmux.html
