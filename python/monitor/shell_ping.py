#!/usr/bin/env python

import time

def read_ip_list():
    print "haha"    

def ping(ping_ip):
    import subprocess
    import shlex
    import os
    cmd = "ping " + str(ping_ip) + ' -A -c 5'
    args = shlex.split(cmd) 

    a,p = subprocess.call(args,stdout=subprocess.PIPE)
    print a,p
    ip_file = open(ping_ip,'a')

    for line in str(p):
        if 'packet' in line:
             write_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(int(time.time())))
             print write_time
        elif 'rtt' in line:   
             print "haha"
#             print line.strip()

    ip_file.close()

if __name__ == '__main__':
    ping('115.29.165.148')
