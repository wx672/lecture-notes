#!/bin/bash

set -euC

cd /tmp

tmux rename-window "FTP demo"
tmux split-window -v
tmux split-window -v

tmux select-pane -t 0
tmux resize-pane -U 30

# Tmux pane 0 is for FTP data connection. And it's read only.
# In tmux pane 1, FTP cmd 'port 127,0,0,1,100,0' should be issued to connect to it.
# For passive mode, you should compute the port number yourself.
# 256*100 + 0 = 25600
tmux send-keys C-l "nc -l 25600" 

tmux split-window -h

# Tmux pane 1 is for interact with the local FTP control port (21)
# example session:
# 		user wx672
#       ...
# 		pass *** (use a temp password)
#       ...
# 		port 127,0,0,1,100,0 (this is for active mode)
#       ...
# 		pasv (enable passive mode)
#       >> 227 Entering Passive Mode (127,0,0,1,61,17) << (server response)
# in pane 0:
#       nc -l $((61*256+17))
# back to pane 1:
#       nlst
# check output in pane 0
tmux select-pane -t 1
tmux send-keys C-l "nc -4 localhost 21"

tmux select-pane -t 2
tmux resize-pane -U 8
tmux send-keys C-l "watch -t -n.1 'ss -4ant \"( sport = 21 or dport = 21 or sport = 25600 or dport = 25600 )\"'" C-m

tmux select-pane -t 3
tmux send-keys C-l "sudo tcpdump -ilo -nnvvvxXKS -s0 port 21 or port 20" C-m
#tmux send-keys C-l "sudo tshark -i lo -f \"port 21\"" C-m

# Local Variables:
# Ref: https://www.arp242.net/tmux.html
# End:
