#!/usr/bin/python

import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('rtd.hpwren.ucsd.edu', 12020))
for i in range(0, 60):
    d = s.recv(1024)
    print "{0}: {1}".format(i, d)
s.close()
