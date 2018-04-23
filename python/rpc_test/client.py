#!/usr/bin/env python

from xmlrpclib import ServerProxy  
if __name__ == '__main__':  
    s = ServerProxy("http://auth:8080")  
    print s.add(3,4)  
