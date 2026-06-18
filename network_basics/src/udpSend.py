#!/usr/bin/python

import socket
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
while True:
    s.sendto("Hello, world", ("", 5005))
s.close()
