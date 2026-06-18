import socket
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind(("",5005))
while True:
    data, addr = s.recvfrom(1024)
    print 'received message:%s' % data
s.close()
