#!/usr/bin/python2

from socket import *
serverPort = 12000
serverSocket = socket(AF_INET,SOCK_STREAM)
serverSocket.bind(('',serverPort))
serverSocket.listen(0)
print serverSocket.getsockname()
print 'The server is ready to receive'
while 1:
    connectionSocket, addr = serverSocket.accept()
    print connectionSocket.getsockname()
    sentence = connectionSocket.recv(1024)
    capitalizedSentence = sentence.upper()
    connectionSocket.send(capitalizedSentence)
    connectionSocket.close()
