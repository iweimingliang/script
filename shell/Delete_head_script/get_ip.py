#!/usr/bin/env python

import socket
hostname = socket.getfqdn(socket.gethostname())
host_ip = socket.gethostbyname(hostname)
print host_ip
