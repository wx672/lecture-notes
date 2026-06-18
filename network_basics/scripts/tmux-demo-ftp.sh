#!/bin/bash

set -euC

cd /tmp

tmux rename-window "FTP demo"

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

# Pane 0 is for FTP data connection. And it's read only.
# In pane 1, FTP cmd 'port 127,0,0,1,100,0' should be issued to invite the server.
# For passive mode, you should compute the port number yourself.
# '100,0' = (100 << 8) = 100 * 2^8 = 100*256 = 25600 (or 256*100 + 0)
tmux send-keys -t{top-left} "nc -l 25600" 

# Tmux pane 1 is for interact with the local FTP control port (21)
# example session:
# 		user yourusername
#       ...
# 		pass yourpassword
#       ...
# 		port 127,0,0,1,100,0 (this is for active mode)
#       ...
# 		pasv (enable passive mode)
#       >> 227 Entering Passive Mode (127,0,0,1,61,17) << (server response)
# in pane 0:
#       nc localhost $((61*256+17))
# back to pane 1:
#       nlst
# check output in pane 0
tmux send-keys -t{top-right} "nc -4 localhost 21"

tmux send-keys -t{up-of} "watch -tn.1 'ss -4ant \"( sport = 21 or dport = 21 or sport = 25600 or dport = 25600 )\"'" C-m

tmux send-keys "sudo tcpdump -ilo -nnvvvxXKS -s0 port 21 or port 20" C-m

tmux select-pane -t{top-left}
#tmux send-keys C-l "sudo tshark -i lo -f \"port 21\"" C-m

# Ref: https://www.arp242.net/tmux.html
