#!/usr/bin/python

import socket               # Import socket module

s = socket.socket()         # Create a socket object
host = socket.gethostname() # Get local machine name
port = 12345                # The server port

s.connect((host, port))
s.send('Hi, server!')
print 'REMOTE:', s.recv(1024)
s.close                     # Close the socket when done
