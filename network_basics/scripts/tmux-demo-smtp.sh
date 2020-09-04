#!/bin/bash

set -euC

cd /tmp

tmux rename-window "SMTP demo"
tmux split-window -v
tmux split-window -v

tmux select-pane -t 0
tmux resize-pane -U 8
tmux send-keys C-l "nc -4 localhost smtp"

tmux select-pane -t 1
tmux resize-pane -U 8
tmux send-keys C-l "watch -t -n.1 'ss -4ant \"( sport = 25 or dport == 25 )\"'" C-m

tmux select-pane -t 2
tmux send-keys C-l "sudo tcpdump -ilo port smtp" C-m
#tmux send-keys C-l "sudo tshark -ilo -f \"port 3333\"" C-m

# Local Variables:
# Ref: https://www.arp242.net/tmux.html
# End:
